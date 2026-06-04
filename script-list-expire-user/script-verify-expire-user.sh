#!/bin/bash
USER_LIST=(
        itd_sup3
        inhouse1
        infocoll
        Infobrk
        infohis
        colladm
        infoagen
        inforef
        infokyc
        infocdd
        infocust
        gfserv
        smlink01
        sfmladm
        brokadm
        clickadm
        sfixserv
        itadmin
)
printf "%-15s %-10s %-15s %-20s %-20s\n" "USER" "USER_UID" "STATUS" "ACCOUNT_EXPIRE_DATE" "PASSWORD_EXPIRE_DATE"
echo "---------------------------------------------------------------------------------------------------"

NEED_UPDATE=()

for USER in "${USER_LIST[@]}"
do
   if id "$USER" >/dev/null 2>&1
   then
      USER_UID=$(id -u "$USER")
      ACC_EXPIRE=$(chage -l "$USER" | awk -F': ' '/Account expires/{print $2}')
      PASS_EXPIRE=$(chage -l "$USER" | awk -F': ' '/Password expires/{print $2}')
      printf "%-15s %-10s %-15s %-20s %-20s\n" \
       "$USER" "$USER_UID" "EXIST" "$ACC_EXPIRE" "$PASS_EXPIRE"

      if [[ "$PASS_EXPIRE" != "never" ]]; then
         NEED_UPDATE+=("$USER")
      fi
   fi
done

if [[ ${#NEED_UPDATE[@]} -eq 0 ]]; then
   echo ""
   echo "All users already have PASSWORD_EXPIRE_DATE set to 'never'. No changes needed."
   exit 0
fi

echo ""
echo "WARNING: The following users do NOT have password set to 'never':"
for U in "${NEED_UPDATE[@]}"; do
   echo "   - $U"
done

echo ""
read -p "Do you want to set PASSWORD_EXPIRE to 'never' for all listed users? (yes/no): " CONFIRM

if [[ "$CONFIRM" == "yes" ]]; then
   echo ""
   echo "Setting password expiry to 'never'..."
   for U in "${NEED_UPDATE[@]}"; do
      if chage -M -1 "$U"; then
         echo "   OK: $U -> set to never"
      else
         echo "   FAILED: $U -> check permissions"
      fi
   done
   echo ""
   echo "Done."
else
   echo ""
   echo "Cancelled. No changes were made."
fi
