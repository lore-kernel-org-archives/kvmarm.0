Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C2DC13B
	for <kvmarm@lists.linux.dev>; Tue,  5 Mar 2024 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709657200; cv=none; b=NOvfcM6t1n12lFOiYcD/Jq48dT5NDMkLHbY3pb6iv1XSo866r7iCkJqpGiw1uUmlb0BSVh24PJDogA5ETh+oyZbpCKWAh6eN48rAiA6uJR993Mpkr1qXIe8Yvm2xAgxx5bM7x992H2vAyR8J7ErC8Y6S6KBeaQoXujRdNWGr4xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709657200; c=relaxed/simple;
	bh=tloykq4FipHwzmG+LtYESH6X6ycS0Nf4/O5QnjtLbyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=DRp/fXzAx8GkNdjkXcflCOGzHd4mQYPDxYj4uqC/KjjA9u+GJ6+nwb/HYqlrVO72oR/WX8aGi6y9FmuPogc+Y6BpDrgmYNmTNK9jCbzpMbBxs4dsnO+h142wu5YJsCrxSBtiWNZIBySSGTCQNGdj7EQRSTvYWqy21g7fhgcv1bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IfPQbcFv; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IfPQbcFv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709657195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fpQfrotHy+/SWb8R20YZRRn8M8ivZ5IKPumNkXdds/M=;
	b=IfPQbcFvR12atPYoxuk/D5YyZnpxN0QHT6CP7AgR7NRl23jMoERaSyl2nMwgVf0RRBdtvM
	K8QtYY6WBzUwROTSES/mhdH7AxPjhsooXOuXtaKMacg8/Xp6R0M2z1VAVXYPLxV119r5wG
	FUzwD5VRVkvqT/jRSQBz0MFVq+poi6Y=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: alexandru.elisei@arm.com,
	eric.auger@redhat.com,
	nikos.nikoleris@arm.com,
	shahuang@redhat.com,
	pbonzini@redhat.com,
	thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 03/18] arm64: efi: Don't create dummy test
Date: Tue,  5 Mar 2024 17:46:27 +0100
Message-ID: <20240305164623.379149-23-andrew.jones@linux.dev>
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

The purpose of the _NO_FILE_4Uhere_ kernel is to check that all the
QEMU command line options that have been pulled together by the
scripts will work. Since booting with UEFI and the -kernel command
line is supported by QEMU, then we don't need to create a dummy
test for _NO_FILE_4Uhere_ and go all the way into UEFI's shell and
execute it to prove the command line is OK, since we would have
failed much before all that if it wasn't. Just run QEMU "normally",
i.e. no EFI_RUN=y, but add the UEFI -bios and its file system command
line options, in order to check the full command line.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
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
2.44.0

