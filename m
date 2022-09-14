Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D21F5ECAAD8
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 08:36:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C5704BC99;
	Wed, 14 Sep 2022 04:36:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8LQ2rl8VxHiB; Wed, 14 Sep 2022 04:36:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 61FA74BC56;
	Wed, 14 Sep 2022 04:36:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AAA24BB72
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:36:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nc9Y3RLJqDhk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2022 04:36:29 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8AB1E4BC6F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:36:28 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id EC7C561944;
 Wed, 14 Sep 2022 08:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5BAC43140;
 Wed, 14 Sep 2022 08:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663144587;
 bh=C6lb+SGUbChCXAYDSH5eSoT2q/RGEauP1K9rMRYRbXQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=R6l7u4rhVRQpBFzCVfPVKCYKhI06IPChZ/Z8/lazLNQ6ALEwwBUhlF3S4O0raeY84
 shSTykddmN/7YAvAidsE6dnaU4ObSUXZov8u9h9iu1LVnnBEBLtII1vkjDAgwsi/DB
 kIUhH6Hd/bPv2pyKCi2mi0D5In5MqGxh4YUDfwxy8Ks8vSfx0vC/ELpIMM61qPFyT1
 3Qgk9hJQrFyW9E6ixXHeKLv0MVLyeTog+8IKKGPgZ7kCafDfBMK+IcOIZstytGoz3a
 FypCgXTRWA3jFoAk8t5/+Dp2EG4terQgY1hbSEZpRUKsiyuCBIRUQj/Ge0vbcvqtWg
 ptS6TTl+DTICg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 22/25] KVM: arm64: Maintain a copy of 'kvm_arm_vmid_bits'
 at EL2
Date: Wed, 14 Sep 2022 09:34:57 +0100
Message-Id: <20220914083500.5118-23-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Sharing 'kvm_arm_vmid_bits' between EL1 and EL2 allows the host to
modify the variable arbitrarily, potentially leading to all sorts of
shenanians as this is used to configure the VTTBR register for the
guest stage-2.

In preparation for unmapping host sections entirely from EL2, maintain
a copy of 'kvm_arm_vmid_bits' in the pKVM hypervisor and initialise it
from the host value while it is still trusted.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 2 ++
 arch/arm64/kernel/image-vars.h   | 3 ---
 arch/arm64/kvm/arm.c             | 1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c   | 3 +++
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index fd99cf09972d..6797eafe7890 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -124,4 +124,6 @@ extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
 
 extern unsigned long kvm_nvhe_sym(__icache_flags);
+extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
+
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 1407533dfb97..d20dc9d555af 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -83,9 +83,6 @@ KVM_NVHE_ALIAS(nvhe_hyp_panic_handler);
 /* Vectors installed by hyp-init on reset HVC. */
 KVM_NVHE_ALIAS(__hyp_stub_vectors);
 
-/* VMID bits set by the KVM VMID allocator */
-KVM_NVHE_ALIAS(kvm_arm_vmid_bits);
-
 /* Kernel symbols needed for cpus_have_final/const_caps checks. */
 KVM_NVHE_ALIAS(arm64_const_caps_ready);
 KVM_NVHE_ALIAS(cpu_hwcap_keys);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 56083ed49708..503046dca288 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1895,6 +1895,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
+	kvm_nvhe_sym(kvm_arm_vmid_bits) = kvm_arm_vmid_bits;
 }
 
 static int kvm_hyp_init_protection(u32 hyp_va_bits)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 09e221ea6184..3c9ce49dc15c 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -15,6 +15,9 @@
 /* Used by icache_is_vpipt(). */
 unsigned long __icache_flags;
 
+/* Used by kvm_get_vttbr(). */
+unsigned int kvm_arm_vmid_bits;
+
 /*
  * Set trap register values based on features in ID_AA64PFR0.
  */
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
