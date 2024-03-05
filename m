Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C6F1758C
	for <kvmarm@lists.linux.dev>; Tue,  5 Mar 2024 16:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657210; cv=none; b=oLGvq2BYkC6aWsx648+PNBD50SFkl3kGYhpX1uYgPg0NSV5l4YRegcwVvwBIB4O+rQU7Z+wihYUu/TUhoykAiBGtkwQC1uOtyqyXmvh0fWLkuqQL9E1HOE+B68pe6JWGRmxROp5EWdl5F88kPfHCYAFqwWD4v/DgzqjStZgO0WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657210; c=relaxed/simple;
	bh=EVOErAccFhl0zSp1EdMjve8qutGj5/zPog+Wa3IuFlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Gcocd04wykQhnIhharSc2JagUUiJ8+OqdNNvzU+OEJaR6nEygUP7Ekh+AhevoN09Xa+fUaWM/txGLPueQGeprJh58rOO22QVTspX1iZ6u7Ah6K5U0q2LJj+3dKUYXpTpnUW3Nen+8l9NRKLUhW7vpaa6+pxFm91eHx05NXFojgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xFMsfb22; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xFMsfb22"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kg+y/g3K7LZI8pEGd+3JudvSf0mGrvNAPU1Jt+RaXeg=;
	b=xFMsfb22tMcAM8CIdYVM5c4ubtTK4oN2Q1ThDYWLv5U9M88mBbAuwPFIMlzK8VhaomCm9H
	4cyWVcWS8swkQpfehtaGlE0mhm8GBuwNR65PD9Mg19AU2HQ/Q0pl9fufjEMqb28gwcEbNK
	6qNj8JpNQ8np5zbYGT5uO4GdPDU4Jac=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 06/18] arm64: efi: Move run code into a function
Date: Tue,  5 Mar 2024 17:46:30 +0100
Message-ID: <20240305164623.379149-26-andrew.jones@linux.dev>
In-Reply-To: <20240305164623.379149-20-andrew.jones@linux.dev>
References: <20240305164623.379149-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Push the run code in arm/efi/run into a function named
uefi_shell_run() since it will create an EFI file system, copy
the test and possibly the DTB there, and create a startup.nsh
which executes the test from the UEFI shell. Pushing this
code into a function allows additional execution paths to be
created in the script. Also rename EFI_RUN to UEFI_SHELL_RUN
to pass the information on to arm/run that it's being called
from uefi_shell_run().

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/run | 33 +++++++++++++++++++--------------
 arm/run     |  4 ++--
 2 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index e45cecfa3265..494ba9e7efe7 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -63,18 +63,23 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
 	exit
 fi
 
-mkdir -p "$EFI_CASE_DIR"
-cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
-echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
-if [ "$EFI_USE_DTB" = "y" ]; then
-	qemu_args+=(-machine acpi=off)
-	FDT_BASENAME="dtb"
-	EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}"
-	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
-fi
-echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
+uefi_shell_run()
+{
+	mkdir -p "$EFI_CASE_DIR"
+	cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
+	echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
+	if [ "$EFI_USE_DTB" = "y" ]; then
+		qemu_args+=(-machine acpi=off)
+		FDT_BASENAME="dtb"
+		UEFI_SHELL_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}"
+		echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
+	fi
+	echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
+
+	UEFI_SHELL_RUN=y $TEST_DIR/run \
+		-bios "$EFI_UEFI" \
+		-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+		"${qemu_args[@]}"
+}
 
-EFI_RUN=y $TEST_DIR/run \
-	-bios "$EFI_UEFI" \
-	-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
-	"${qemu_args[@]}"
+uefi_shell_run
diff --git a/arm/run b/arm/run
index ac64b3b461a2..40c2ca66ba7e 100755
--- a/arm/run
+++ b/arm/run
@@ -60,7 +60,7 @@ if ! $qemu $M -chardev '?' | grep -q testdev; then
 	exit 2
 fi
 
-if [ "$EFI_RUN" != "y" ]; then
+if [ "$UEFI_SHELL_RUN" != "y" ]; then
 	chr_testdev='-device virtio-serial-device'
 	chr_testdev+=' -device virtconsole,chardev=ctd -chardev testdev,id=ctd'
 fi
@@ -75,7 +75,7 @@ command="$qemu -nodefaults $M $A -cpu $processor $chr_testdev $pci_testdev"
 command+=" -display none -serial stdio"
 command="$(migration_cmd) $(timeout_cmd) $command"
 
-if [ "$EFI_RUN" = "y" ]; then
+if [ "$UEFI_SHELL_RUN" = "y" ]; then
 	ENVIRON_DEFAULT=n run_qemu_status $command "$@"
 else
 	run_qemu $command -kernel "$@"
-- 
2.44.0

