Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619717;
	b=grN5nFNwPsh/+DtgnAXy+y13EYuPQws2mJ2reJM3bRYhPAljxlIO/imWK36xlvjo80Dx
	 iUwm8CjIYvy2EJ1TpKGztxJxNzsgOJULnlyxge4GWKFvHx3+y+sYhJC5e9i8zq/nlnjoK
	 KItMtrvdlI/FAL/VjhY3pPL8QmbL3ffySGdiF5xrKHtl/ceAU34CTokeilqoPv3Idx9/x
	 zHl5QUpENJO7C5mJd11/yNPTf8O2rpjS1gjwiPh9Kk1GIyYZPng+9GkGFbhtohs5p95yA
	 fAz6xinZcUjbCfhPrRM/OChjuGKtq9X1Nl/OmURWNMAo5Hgr4zRUt6E9FPwF/uo2lfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619717;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ph63pIapK/Oi0jQftYWPnDgvG3tpuV/CW0Q/GMRXUhc=;
	b=TSuhjFaTls8Iy5qktFhd7Y989dUlgV3/ven6389OVbbkV9rImCyux2OgQ/O8WOZ4PDgV
	 fpwBTs4rpf90hIwlCc1FqPEuPA9hZr1Dpw3U5UvdFOo39/fi/n0EzE5BdU9z/fschcnD4
	 y+H2US1Ww23dQqTaGtAJyjI24yDI2RF5gp7J6qjLmzYRnhF9I/gGzhD0Qgwqb9TNxdLz8
	 uHSHgFqUvmsb/mOVw9G8Hc/AjHZnZDa5vgg+hidcPwfJvtcKNe7jA9pX5JKVIP4fQXWMh
	 4vSGt+mjRy8DoyAU8dm0RsFV/kXFiykXOp5gmQAovqbo7749NAgjQI4TWE+sReS6l6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=q7bUbu11;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF5D7606A333
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:15:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF5D7606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=q7bUbu11
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F054175A;
	Wed, 25 Nov 2026 07:15:13 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5BC963F86F;
	Wed, 25 Nov 2026 07:15:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795619716; bh=yjBWfAzTzu7cyp4c6c4m2tl0EMMFBBETllhL3u+i548=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7bUbu11hmjXHeunViw/9IsDg0Atfm/2FospNHWMafNTZN6E0lp/TqMd2Zab6Mo8c
	 ce/QmEMbsLy0GlHVbEypXf3dbkc2meFDpoRbYKvdWwYO6e/4BcEmfnpvfx5ng5M2pu
	 4WwhFzRFnx6SyCKOYZIFIvzqxZrc0HqZRGsjhadM=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v6 19/23] arm64: Add proposed GICv5 ITS UAPI definitions
Date: Wed, 25 Nov 2026 15:13:52 +0000
Message-Id: <20261125151356.2875108-20-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261125151356.2875108-1-sascha.bischoff@arm.com>
References: <20261125151356.2875108-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mirror the GICv5 ITS device type, address type and size from the posted
KVM GICv5 ITS series. These definitions are not part of the v7.4-rc1
UAPI header sync.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arm64/include/asm/kvm.h | 2 ++
 include/linux/kvm.h     | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arm64/include/asm/kvm.h b/arm64/include/asm/kvm.h
index 65ee09bd..8c701173 100644
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
index 8dff2fc1..c0e11993 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -1239,6 +1239,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_LOONGARCH_DMSINTC	KVM_DEV_TYPE_LOONGARCH_DMSINTC
 	KVM_DEV_TYPE_ARM_VGIC_V5,
 #define KVM_DEV_TYPE_ARM_VGIC_V5	KVM_DEV_TYPE_ARM_VGIC_V5
+	KVM_DEV_TYPE_ARM_VGIC_V5_ITS,
+#define KVM_DEV_TYPE_ARM_VGIC_V5_ITS	KVM_DEV_TYPE_ARM_VGIC_V5_ITS
 
 	KVM_DEV_TYPE_MAX,
 
-- 
2.34.1

