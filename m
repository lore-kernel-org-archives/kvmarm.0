Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A02382D7B
	for <kvmarm@lists.linux.dev>; Fri, 23 Feb 2024 15:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708703518; cv=none; b=AEhK2tL0b1cDSSP9r4Rk//9jgiMc9xyoqoPcZ24UXQAa9lrDyADhYvBwlQPMOF6m018G3Grko6F4Yn1jW4hWyzBUK/hJf2HboYNvpCip9U+vHpL3HX//SOIkPh2qbVP7xo5hLUFkpi1YX6EFcHEz5wpDl5i7xYgeFWi0xm5z1jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708703518; c=relaxed/simple;
	bh=BoBz/S/wtgNn0b2w3x5Xyyoegeq7eW2pC44M0/GD4LM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=SeHbB0QDLIUliplJjMLQ3NEY8V0B0B4xG0BPTfZVt3w6UehB3NjQUXXwArJzCQ6g8BYKVRpm6OvwSyjxuLi0nyJSGodhF49441plt/CJWWyogzLtyB5eRi/3ly8hxdhubq/vVXQM7KjRVfW1AnWuCMzFNQuMo9Mgp6JFfR/cTws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jXaPvmoE; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jXaPvmoE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708703515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ulzjyiK3ZcBO8GfguKNO7JW+HXX1i+VA6rmcrThM2TI=;
	b=jXaPvmoE4p4CTkg4OqmI0GFPxSJWBsWKrkq+oDvD0aqI+ru/yAt+nukIU4Q63wws0Y54Pv
	bBB/FcelDw1YOAT6V/RYa6G8Fy4Q65UR1+eKb2CfKyVM9wAlHxge90FQ6maMZGcOb5RJPZ
	+0fRJzAbM0Rc7pP4WXSvqHAxXJJvjmw=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH 05/14] arm64: efi: Remove redundant dtb generation
Date: Fri, 23 Feb 2024 16:51:31 +0100
Message-ID: <20240223155125.368512-21-andrew.jones@linux.dev>
In-Reply-To: <20240223155125.368512-16-andrew.jones@linux.dev>
References: <20240223155125.368512-16-andrew.jones@linux.dev>
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
2.43.0

