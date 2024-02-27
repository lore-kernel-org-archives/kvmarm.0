Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428FF149006
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 19:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061704; cv=none; b=ET4kGV8N2hocZ4KcJLQRSw8DdYn6gseyZAMKSxtGD7Ulath7i8G5l68FsF8HzW2Ffd8mbukEOqXZwI1PsLgd25KAHeFYrG6YgAoIFRDw0/WsUoTPqfFm/Frv9hDnyQrKp3ki9x25SX4CFmT9ys83v0r7SieAW2iR4iLerwLsE0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061704; c=relaxed/simple;
	bh=pbhRCFWKrwLmCtktpDAGcl7va/xUmhq1PnDLXV/IAw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=dDmDrX5kY2RFEvECfokTBjF4R16utQluMnK0dkRuyvON6J+mqLGp3cm9FZtjoOr+dgLlWZBj2hCI77FePq+gz0S1WdjIU0qzefAxopyqvcQgrhpNsaE/uwdJG2KhQwdgzh26S3m+igp2xe8k/nU1C5bnLWNPMeMD4HFF82AxPdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AD9rdEMV; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AD9rdEMV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RhisSx5x/V7b9Y0kHLu8YVQTirjJ97CAwr4agFIIB1Y=;
	b=AD9rdEMVvhwQutVNepXAg70ugP5MyRPv9hnB2wzdssBdvcHB6smaWEDVnxxrW4pF81s6NF
	9JO5/OC7K2Frn/7p8dX1Wf3Wn79XLebBWTMlqrSYzQuFxBPzWjDtAseq2sgYQsbsRrDNyh
	q1gLxOgnBoaA30aVg7hC14PdUifVMPQ=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 07/18] arm64: efi: Remove EFI_USE_DTB
Date: Tue, 27 Feb 2024 20:21:17 +0100
Message-ID: <20240227192109.487402-27-andrew.jones@linux.dev>
In-Reply-To: <20240227192109.487402-20-andrew.jones@linux.dev>
References: <20240227192109.487402-20-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We don't need two variables for one boolean property. Just use
!EFI_USE_ACPI to infer efi-use-dtb.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/run | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arm/efi/run b/arm/efi/run
index 494ba9e7efe7..b7a8418a07f8 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -27,8 +27,6 @@ fi
 : "${EFI_CASE_DIR:="$EFI_TEST/$EFI_TESTNAME"}"
 : "${EFI_VAR_GUID:=97ef3e03-7329-4a6a-b9ba-6c1fdcc5f823}"
 
-[ "$EFI_USE_ACPI" = "y" ] || EFI_USE_DTB=y
-
 if [ ! -f "$EFI_UEFI" ]; then
 	echo "UEFI firmware not found."
 	echo "Please specify the path with the env variable EFI_UEFI"
@@ -68,7 +66,7 @@ uefi_shell_run()
 	mkdir -p "$EFI_CASE_DIR"
 	cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_DIR/"
 	echo "@echo -off" > "$EFI_CASE_DIR/startup.nsh"
-	if [ "$EFI_USE_DTB" = "y" ]; then
+	if [ "$EFI_USE_ACPI" != "y" ]; then
 		qemu_args+=(-machine acpi=off)
 		FDT_BASENAME="dtb"
 		UEFI_SHELL_RUN=y $TEST_DIR/run -machine dumpdtb="$EFI_CASE_DIR/$FDT_BASENAME" "${qemu_args[@]}"
-- 
2.43.0

