Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317AA15E8B
	for <kvmarm@lists.linux.dev>; Tue,  5 Mar 2024 16:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657203; cv=none; b=dJH2V8Rp3YvY/Xi4xr0OPQLDJSpUoGnT5XQGAnF8/qo6ieQQRTnhQaMUGfdx+Ab7I7/z4AOjAB2VHqFULaBVfbL99YlKmOJRKEbhVX2AceQYyOzhI0qyTmZvk7hh+0XlrnhE6gCAvmAttKMQ+m2dcvOGGramTPpS3sK2YcnbJLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657203; c=relaxed/simple;
	bh=VM/iI6eWsrWoxm9SRfOsz46HpOfnaePstNU8qTMviWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=N4nepCiJb45iMaJM4YBjJ80kxA4FtQ/fApqd/aJlc3vEWFt6r47mJ+MSxO9jX7y2YwDdszURzkc1z0kLb0pmMm/mWH7E57+53em/bYQc4XlzM7kEv/5XQJU13UqG1BQYLlWxLRW0wRF1Y15CiXsfPT+/s5jnmMtdPE5nqWtrDsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=igrKLPuL; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="igrKLPuL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RnWnN5FTaEFq8qeb3uUDZVv1wApvYCzi38Ljvuq94m0=;
	b=igrKLPuLBZBZaO51XC+ghCiKgYPmP2l7GoGmT4oXFODUeLCcN96cR3Qk27d7zjvyAz+6aX
	CD7ntPbiXsATLztQWUYNsyMqUlUypMLnVjtQjBbE9pdAbn+f+bzAPGf0LMWRngHtcZzO9r
	zYu9m92eenUoFPs9Sha7IH7o2VLdEnI=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 05/18] arm64: efi: Remove redundant dtb generation
Date: Tue,  5 Mar 2024 17:46:29 +0100
Message-ID: <20240305164623.379149-25-andrew.jones@linux.dev>
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

When a line in bash is written as

 $(some-line)

Then 'some-line' will be evaluated and then whatever some-line outputs
will be evaluated. The dtb is getting generated twice since the line
that should generate it is within $() and the output of that is the
command itself (since arm/run outputs its command), so the command
gets executed again. Remove the $() to just execute dtb generation
once.

While mucking with arm/efi/run tidy it a bit by by removing the unused
sourcing of common.bash and the unnecessary 'set -e' (we check for and
propagate errors ourselves). Finally, make one reorganization change
and some whitespace fixes.

Fixes: 2607d2d6946a ("arm64: Add an efi/run script")
Fixes: 2e080dafec2a ("arm64: Use the provided fdt when booting through EFI")
Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/run | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index 8b6512520026..e45cecfa3265 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -1,7 +1,5 @@
 #!/bin/bash
 
-set -e
-
 if [ $# -eq 0 ]; then
 	echo "Usage $0 TEST_CASE [QEMU_ARGS]"
 	exit 2
@@ -13,7 +11,6 @@ if [ ! -f config.mak ]; then
 fi
 source config.mak
 source scripts/arch-run.bash
-source scripts/common.bash
 
 if [ -f /usr/share/qemu-efi-aarch64/QEMU_EFI.fd ]; then
 	DEFAULT_UEFI=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd
@@ -27,6 +24,7 @@ fi
 : "${EFI_CASE:=$(basename $1 .efi)}"
 : "${EFI_TESTNAME:=$TESTNAME}"
 : "${EFI_TESTNAME:=$EFI_CASE}"
+: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
 : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
 
 [ "$EFI_USE_ACPI" = "y" ] || EFI_USE_DTB=y
@@ -65,20 +63,18 @@ if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
 	exit
 fi
 
-: "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
 mkdir -p "$EFI_CASE_DIR"
-
 cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
 echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
 if [ "$EFI_USE_DTB" = "y" ]; then
 	qemu_args+=(-machine acpi=off)
 	FDT_BASENAME="dtb"
-	$(EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}")
+	EFI_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}"
 	echo "setvar fdtfile -guid $EFI_VAR_GUID -rt =L\"$FDT_BASENAME\""  >> "$EFI_CASE_DIR/startup.nsh"
 fi
 echo "$EFI_CASE.efi" "${cmd_args[@]}" >> "$EFI_CASE_DIR/startup.nsh"
 
 EFI_RUN=y $TEST_DIR/run \
-       -bios "$EFI_UEFI" \
-       -drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
-       "${qemu_args[@]}"
+	-bios "$EFI_UEFI" \
+	-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+	"${qemu_args[@]}"
-- 
2.44.0

