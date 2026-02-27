Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B1A3542CF
	for <kvmarm@lists.linux.dev>; Fri, 27 Feb 2026 16:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772211582; cv=none; b=DPZIcVK6ZoGf5aAmzZpARJI4KxtmbUihLq6Iwpow7FqSUr+HfSKn2q8yYtN4DE8ez+g2tsA5QzEsjR/uyvXHwMj3Kqgoa5fZHDJMnjt50afSgmnDqHj9pvjxtyWcU7IvdVsK8wJJMFdzBbRRQAw26IHG73a7a38B/ddDSY8n4LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772211582; c=relaxed/simple;
	bh=FRFtvEI1yi35Friv27LJBigEAlIfLQnMGtresBTad30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crD+J/oKiBqzMb8B/dnhS15GD9omL/fqzQpDOloYXs3rO4kWyhhI1utZ9iJc76VuzqQnGdC1k9jgYafezNZIoYb08Z3W9SCnf36mMmrUSHv40xlxxm/zbRicbHvgUiCFLX68LKFDl9en53meKDDQcE3X5jI0xBvlb0Gdqe6fly0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E0AD61516;
	Fri, 27 Feb 2026 08:59:34 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F31DF3F73B;
	Fri, 27 Feb 2026 08:59:39 -0800 (PST)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev,
	will@kernel.org,
	maz@kernel.org,
	tabba@google.com,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	alexandru.elisei@arm.com,
	oupton@kernel.org,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvmtool PATCH v6 02/17] util/update_headers: Clean up header copying
Date: Fri, 27 Feb 2026 16:56:09 +0000
Message-ID: <20260227165624.1519865-3-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260227165624.1519865-1-suzuki.poulose@arm.com>
References: <20260227165624.1519865-1-suzuki.poulose@arm.com>
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
 util/update_headers.sh | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/util/update_headers.sh b/util/update_headers.sh
index 105bfc1d..8a5d3d2d 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -28,18 +28,19 @@ then
 	exit 1
 fi
 
-cp -- "$LINUX_ROOT/include/uapi/linux/kvm.h" include/linux
-cp -- "$LINUX_ROOT/include/uap/linux/const.h" include/linux
+copy_uapi_linux_header () {
+	cp -- "$LINUX_ROOT/include/uapi/linux/$1" include/linux
+}
 
-for header in $VIRTIO_LIST
+for header in kvm.h const.h $VIRTIO_LIST
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
@@ -52,8 +53,9 @@ do
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

