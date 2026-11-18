Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024764;
	b=AwQ6dob39bhCWrLY5sgXUCuP4++tp67gKLDryboXnuUgJSBixEVRkNq5qbXBGY8+hE2B
	 6cWKEYFz8/4bQoLRlWL5kEzEJcmUgkX3xpgt0oH0uYKnTblzrWEai+ry33e3f47/YB7FK
	 WO6Qv2AjQH2oOH4E3/PD0SPgd7gMErU3ZPNNw6BWc9N4X8D04AsMpfK/u/X7KeGtJ8umW
	 XSEnYy/v35fJgQ2CEgFiWCpgxIhGg+XqDm2JLf0FGhzmY2sVHKISGp93PUH/NF11icPj8
	 4ACT5egaGwk8njnBUZQGaM3P574gWEsC8QFU4J/F/v1PhjJ/kKtYXNGu4eJIR1MpI1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024764;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Ph63pIapK/Oi0jQftYWPnDgvG3tpuV/CW0Q/GMRXUhc=;
	b=qo8wPQ9ZqCy2H3JTa7QmwVg+AkykOb6I38Wu2d9KIkAwMjOhuBDXDgDzp7ND2hwdyHyR
	 prIf4hWaHdbelQwiTaiCvpsKUmgcg9Gw75ryhvvkd+feyanV/tNjq6wvc2hT77uwoHqo/
	 FgkezHT0ZcPoeUz2tDl5XW9dLc54TSJOp65/JuiGYvVDnqoy0t62k8Oae5mTZ4zLyLP1y
	 PMhoyHgcdHB1cAIwH3OTq0KBSFQRSn4Nt66Cp07gYsdP3STJdmYndJTldzxW6s42Wv0x3
	 wog+1nHmvqRv1f2yFzBBPHdvNsoJgb5qwvG/dVoD3t0ZZVMm5nOY3GMJAOMWbUK3YFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=i40lV4uS;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B217F606A31C
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 17:59:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B217F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=i40lV4uS
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6446E1477;
	Wed, 18 Nov 2026 09:59:20 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D4F83F632;
	Wed, 18 Nov 2026 09:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795024763; bh=yjBWfAzTzu7cyp4c6c4m2tl0EMMFBBETllhL3u+i548=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i40lV4uSfJvo5OKwC0Vrf9D/BDGpSGV3fkpZSI9HkyA4rdhL0VMSjT4jcxzyX6jX/
	 yU4kKIf0L13JGw2IAxZiU24m1fRkVyQyk6YrDNPrKZBc0cI4lfWP4ckwIQCgDpMFnZ
	 44uWYp94I/HQ9O6LODq7CKfgTP3a/778lTSs8PFk=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: will@kernel.org,
	julien.thierry.kdev@gmail.com
Cc: vladimir.murzin@arm.com,
	maz@kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	timothy.hayes@arm.com,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH kvmtool v5 19/23] arm64: Add proposed GICv5 ITS UAPI definitions
Date: Wed, 18 Nov 2026 17:57:51 +0000
Message-Id: <20261118175755.1946977-20-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261118175755.1946977-1-sascha.bischoff@arm.com>
References: <20261118175755.1946977-1-sascha.bischoff@arm.com>
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

