Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E2673D9036
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774880657; cv=none; b=cBHKL9Vvhriu2xTRjlt/6CAwo/ouNMDhyoFyiMij7SUmRsvMypCniDgxb2MVEByvl5Kclm2xc+/7uN9sX+5YsSe+wDmVIOr+w/tDk4vm/uyVVANFofmzFgVP27QYdgYoc/fmwXucPumXHEHInzz111zAF80pNUBrIAQkdO6WLuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774880657; c=relaxed/simple;
	bh=7X/UQORjTe0Fzi/AdU6GU+4kh3/A+t/fVz3dIspZI1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UcdPrBrDXlfItS8d4hlyBGyiDkQJEb6a6VU3fEb6W2v4vvahiBnFUV61QfP8gYWSX1mohiDUXmbfOGUu6A7SPWpcl3W9a1W44LBGrR65ytyuCl/eZQ1CbdE51DKPtyk5qf7q8NkzjwGSAVVLKSoaMrn3sO1j1yCL2x7VEOEC3WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Rn+zfFKz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Rn+zfFKz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3AF6A1A2D;
	Mon, 30 Mar 2026 07:24:09 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 948DF3F915;
	Mon, 30 Mar 2026 07:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774880655; bh=7X/UQORjTe0Fzi/AdU6GU+4kh3/A+t/fVz3dIspZI1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rn+zfFKz8bJsL7gDA7U7lfvfLGPU802moFnx5InYjDrHXNdCy0GmDaRcP2Ero5pCE
	 whbCQqRzMbuvsyb52Sqg5dvvsm4e1uDUGn3oscW500FTQ3Kd+m7/eevNx0cV71X3Yj
	 jXrkV7+qwjL3N9XMKde6pgtmgN6aFNeIXV6X5MfU=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev,
	will@kernel.org
Cc: kvm@vger.kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	aneesh.kumar@kernel.org,
	linux-kernel@vger.kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v7 02/17] util/update_headers: Clean up header copying
Date: Mon, 30 Mar 2026 15:23:19 +0100
Message-ID: <20260330142334.3309961-3-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330142334.3309961-1-suzuki.poulose@arm.com>
References: <20260330142334.3309961-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We copy two kinds of headers. Generic Linux UAPI headers and the ASM UAPI headers
for arch specific targets. Introduce helper functions for each and centralise
the copy process

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 util/update_headers.sh | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index af75ca36..7902dddb 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -28,17 +28,19 @@ then
 	exit 1
 fi
 
-cp -- "$LINUX_ROOT/include/uapi/linux/kvm.h" include/linux
+copy_uapi_linux_header () {
+	cp -- "$LINUX_ROOT/include/uapi/linux/$1" include/linux
+}
 
-for header in $VIRTIO_LIST
+for header in kvm.h $VIRTIO_LIST
 do
-	cp -- "$LINUX_ROOT/include/uapi/linux/$header" include/linux
+	copy_uapi_linux_header $header
 done
 
 unset KVMTOOL_PATH
 
-copy_optional_arch () {
-	local src="$LINUX_ROOT/arch/$arch/include/uapi/$1"
+copy_uapi_asm_header () {
+	local src="$LINUX_ROOT/arch/$arch/include/uapi/asm/$1"
 
 	if [ -r "$src" ]
 	then
@@ -51,8 +53,9 @@ do
 	KVMTOOL_PATH=$arch
 
 	case $arch in
-		arm64) copy_optional_arch asm/sve_context.h ;;
+		arm64)
+			copy_uapi_asm_header sve_context.h
+			;;
 	esac
-	cp -- "$LINUX_ROOT/arch/$arch/include/uapi/asm/kvm.h" \
-		"$KVMTOOL_PATH/include/asm"
+	copy_uapi_asm_header kvm.h
 done
-- 
2.43.0

