Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A441145356
	for <kvmarm@lists.linux.dev>; Tue, 27 Feb 2024 19:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061690; cv=none; b=hMKo1Y7HUtPChJWJ0aVrhLPxdDnOk16hPqBwt+6RPBXubDbX0+PllgJwivzai3Tf5xj8oNLw1U8voTtsgyTfoNYFGuSqzpXv/eLZu/UzMZ+w6XxStOB8k/URgABeuWb8Q8eALFPQ+tEyTGBhY+TA6R5AOiB59C2eOv12xbDqrxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061690; c=relaxed/simple;
	bh=iAcqRhpWnmxPRht06kZJBZfd6TfGtdgpBsS5jPtRCzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=Q+MtxQsoavfcsNBaRGeVd74PHE10PO1Lb44Krua7nRC8v7ws5Vxv1xvK11mDLepV+Xg6YqDuBHRr9M5oxm/6qBbiUJDv3dYpTpHthnA+ev2cmCxw4nwd8oRLy5ij0vHY4lM1UaOMJNezP4ebbIQRVBiOtcerMBBA6ixJPdYnGDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O2GFx3c7; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O2GFx3c7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709061686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZtRLPtvNLuRe5mE7VJYVBFfuNR+bm5yOU8r9yvFXgU=;
	b=O2GFx3c7kcmr/eaqY1fksuWD6IMxO60Bl/5edxWe4nyGmsKXqdwfDRpAPqIDhZwjOgMuEI
	Pj8ZxqiMS0hRHpteiLuxJpGPVOvqvlmbhfUiZdo/SfCOMI/s+aGWkE4WJgL/HPyBZUOBjQ
	IjrHVbOM+UmVi9IS1RMoZ6fNLJFbaW8=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 03/18] arm64: efi: Don't create dummy test
Date: Tue, 27 Feb 2024 20:21:13 +0100
Message-ID: <20240227192109.487402-23-andrew.jones@linux.dev>
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

The purpose of the _NO_FILE_4Uhere_ kernel is to check that all the
QEMU command line options that have been pulled together by the
scripts will work. Since booting with UEFI and the -kernel command
line is supported by QEMU, then we don't need to create a dummy
test for _NO_FILE_4Uhere_ and go all the way into UEFI's shell and
execute it to prove the command line is OK, since we would have
failed much before all that if it wasn't. Just run QEMU "normally",
i.e. no EFI_RUN=y, but add the UEFI -bios and its file system command
line options, in order to check the full command line.

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 arm/efi/run | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arm/efi/run b/arm/efi/run
index 6872c337c945..e629abde5273 100755
--- a/arm/efi/run
+++ b/arm/efi/run
@@ -53,7 +53,14 @@ while (( "$#" )); do
 done
 
 if [ "$EFI_CASE" = "_NO_FILE_4Uhere_" ]; then
-	EFI_CASE=dummy
+	EFI_CASE_DIR="$EFI_TEST/dummy"
+	mkdir -p "$EFI_CASE_DIR"
+	$TEST_DIR/run \
+		$EFI_CASE \
+		-bios "$EFI_UEFI" \
+		-drive file.dir="$EFI_CASE_DIR/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+		"${qemu_args[@]}"
+	exit
 fi
 
 : "${EFI_CASE_DIR:="$EFI_TEST/$EFI_CASE"}"
-- 
2.43.0

