Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2D4377A80
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792165327; cv=none; b=ujsVrWHzl5ThcmT040k93BwR8A1MpVqZLpx4B/QGdWgjzfH4YF6lralGrBdYPemJbNEYAlxFtxJ1U4rXihAF2gjWFglyKkqOShkl99VRtxSYWjD0V5hwd5LRA1nzv8K6L3zgXXLU/Vwp1t8B++arpg050i1AHa34aT+De1qaS1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792165327; c=relaxed/simple;
	bh=YDZTLBLz+R66tTzrkl7JZx+TKzKl/tRjAKWdlMo8Vdg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=R+OhfVowWQtxFlHq6ZSsQ3F1OXLldArP3c9jajvAWKENBy4Yw0fhIGWhgXcblhNTEWVnxEaYWJwqOaqKeEcwRlZnk5xzFefqYDrfhLEusb93sb8gyivF0o7/7haYympiYnBKn5y1svHaspcQLPCaJ4m6r4X3I5DbfpF8iHoSW3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=EaTxHttJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="EaTxHttJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B001143D;
	Fri, 16 Oct 2026 08:42:01 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E1713F673;
	Fri, 16 Oct 2026 08:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792165324; bh=YDZTLBLz+R66tTzrkl7JZx+TKzKl/tRjAKWdlMo8Vdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaTxHttJtcvn9IJII3+g2c/VhrBkZt7y8+wJUQJ1gHKi+WaeBuBT+seQK2qwYBdVA
	 QrsIKYXwiZZ2ZcfleRfFKMtKur12zsVfh/iJeSEsY2jX2oC9UDduHAJPz2BdDetonm
	 490bSfLR4e3mwgkBngKdqTNQsGR3S4JdME3jKzz0=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v3 17/21] arm64: Sync KVM UAPI headers for GICv5 ITS
Date: Fri, 16 Oct 2026 16:39:35 +0100
Message-Id: <20261016153939.913764-18-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016153939.913764-1-sascha.bischoff@arm.com>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Copy the GICv5 ITS device type, address type and size from the Linux
headers.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/include/asm/kvm.h | 2 ++
 include/linux/kvm.h     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arm64/include/asm/kvm.h b/arm64/include/asm/kvm.h
index 9998252e..3ec5a0b1 100644
--- a/arm64/include/asm/kvm.h
+++ b/arm64/include/asm/kvm.h
@@ -99,8 +99,10 @@ struct kvm_regs {
 
 /* Supported VGICv5 address types  */
 #define KVM_VGIC_V5_ADDR_TYPE_IRS	6
+#define KVM_VGIC_V5_ADDR_TYPE_ITS	7
 
 #define KVM_VGIC_V5_IRS_SIZE		(2 * SZ_64K)
+#define KVM_VGIC_V5_ITS_SIZE		(2 * SZ_64K)
 
 #define KVM_ARM_VCPU_POWER_OFF		0 /* CPU is started in OFF state */
 #define KVM_ARM_VCPU_EL1_32BIT		1 /* CPU running a 32bit VM */
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 6c8afa20..3ff33e49 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -1235,6 +1235,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_DMSINTC	KVM_DEV_TYPE_LOONGARCH_DMSINTC
 	KVM_DEV_TYPE_ARM_VGIC_V5,
 #define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
+	KVM_DEV_TYPE_ARM_VGIC_V5_ITS,
+#define KVM_DEV_TYPE_ARM_VGIC_V5_ITS	KVM_DEV_TYPE_ARM_VGIC_V5_ITS
 
 	KVM_DEV_TYPE_MAX,
 
-- 
2.34.1

