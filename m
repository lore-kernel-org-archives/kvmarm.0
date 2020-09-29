Return-Path: <SRS0=H5U9=DG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC01C4346E
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 09:18:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3BE1020BED
	for <kvmarm@archiver.kernel.org>; Tue, 29 Sep 2020 09:18:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BE1020BED
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C213D4B360;
	Tue, 29 Sep 2020 05:18:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lj4U2agqxqhX; Tue, 29 Sep 2020 05:18:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9253F4B338;
	Tue, 29 Sep 2020 05:18:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE7934B333
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 05:18:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5AlhAu8dBGJC for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Sep 2020 05:18:09 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6FBE34B1F4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Sep 2020 05:18:09 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id 9D8AAFE6DE539D3107D0;
 Tue, 29 Sep 2020 17:18:07 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.69) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Tue, 29 Sep 2020 17:17:57 +0800
From: Jingyi Wang <wangjingyi11@huawei.com>
To: <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>
Subject: [RFC PATCH 2/4] KVM: arm64: Make use of TWED feature
Date: Tue, 29 Sep 2020 17:17:25 +0800
Message-ID: <20200929091727.8692-3-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200929091727.8692-1-wangjingyi11@huawei.com>
References: <20200929091727.8692-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.69]
X-CFilter-Loop: Reflected
Cc: catalin.marinas@arm.com, fanhenglong@huawei.com, prime.zeng@hisilicon.com,
 maz@kernel.org, will@kernel.org
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

For HCR_EL2, TWEDEn(bit[59]) decides whether TWED is enabled, and
when the configurable delay is enabled, TWEDEL (bits[63:60]) encodes
the minimum delay in taking a trap of WFE caused by the TWE bit in
this register as 2^(TWEDEL + 8) cycles.

We use two kernel parameters "twed_enable" and "twed" to configure the
register.

Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arch/arm64/include/asm/kvm_arm.h     |  5 +++++
 arch/arm64/include/asm/kvm_emulate.h | 32 ++++++++++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h    | 13 +++++++++++
 arch/arm64/include/asm/virt.h        |  8 +++++++
 arch/arm64/kvm/arm.c                 | 22 +++++++++++++++++++
 5 files changed, 80 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1da8e3dc4455..03afb2921f1c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -12,6 +12,11 @@
 #include <asm/types.h>
 
 /* Hyp Configuration Register (HCR) bits */
+#define HCR_TWEDEL_SHIFT	60
+#define HCR_TWEDEL_MAX		(UL(0xf))
+#define HCR_TWEDEL_MASK		(HCR_TWEDEL_MAX << HCR_TWEDEL_SHIFT)
+#define HCR_TWEDEL	(UL(1) << HCR_TWEDEL_SHIFT)
+#define HCR_TWEDEN	(UL(1) << 59)
 #define HCR_FWB		(UL(1) << 46)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 1cc5f5f72d0b..1a9cce836170 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -102,6 +102,38 @@ static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
 	vcpu->arch.hcr_el2 |= HCR_TWI;
 }
 
+#ifdef CONFIG_ARM64_TWED
+static inline void vcpu_twed_enable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 |= HCR_TWEDEN;
+}
+
+static inline void vcpu_twed_disable(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.hcr_el2 &= ~HCR_TWEDEN;
+}
+
+static inline void vcpu_twed_init(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.twed = (u64)twed;
+}
+
+static inline void vcpu_set_twed(struct kvm_vcpu *vcpu)
+{
+	u64 delay = vcpu->arch.twed;
+	if (delay > HCR_TWEDEL_MAX)
+		delay = HCR_TWEDEL_MAX;
+
+	vcpu->arch.hcr_el2 &= ~HCR_TWEDEL_MASK;
+	vcpu->arch.hcr_el2 |= (delay << HCR_TWEDEL_SHIFT);
+}
+#else
+static inline void vcpu_twed_enable(struct kvm_vcpu *vcpu) {};
+static inline void vcpu_twed_disable(struct kvm_vcpu *vcpu) {};
+static inline void vcpu_twed_init(struct kvm_vcpu *vcpu) {};
+static inline void vcpu_set_twed(struct kvm_vcpu *vcpu) {};
+#endif
+
 static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 905c2b87e05a..380cd9c8ad0f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -371,6 +371,11 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+
+#ifdef CONFIG_ARM64_TWED
+	/* WFE trap delay */
+	u64 twed;
+#endif
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
@@ -688,4 +693,12 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define kvm_arm_vcpu_sve_finalized(vcpu) \
 	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
 
+#ifdef CONFIG_ARM64_TWED
+#define use_twed() (has_twed() && twed_enable)
+extern bool twed_enable;
+extern unsigned int twed;
+#else
+#define use_twed() false
+#endif
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/include/asm/virt.h b/arch/arm64/include/asm/virt.h
index 09977acc007d..1a9e437e5bf6 100644
--- a/arch/arm64/include/asm/virt.h
+++ b/arch/arm64/include/asm/virt.h
@@ -98,6 +98,14 @@ static __always_inline bool has_vhe(void)
 		return cpus_have_final_cap(ARM64_HAS_VIRT_HOST_EXTN);
 }
 
+static __always_inline bool has_twed(void)
+{
+	if (cpus_have_const_cap(ARM64_HAS_TWED))
+		return true;
+
+	return false;
+}
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* ! __ASM__VIRT_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index b588c3b5c2f0..5b5e8b14dcd5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -59,6 +59,14 @@ static bool vgic_present;
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
+#ifdef CONFIG_ARM64_TWED
+bool twed_enable = false;
+module_param(twed_enable, bool, S_IRUGO | S_IWUSR);
+
+unsigned int twed = 0;
+module_param(twed, uint, S_IRUGO | S_IWUSR);
+#endif
+
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
@@ -270,6 +278,13 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.hw_mmu = &vcpu->kvm->arch.mmu;
 
+	if (use_twed()) {
+		vcpu_twed_enable(vcpu);
+		vcpu_twed_init(vcpu);
+	} else {
+		vcpu_twed_disable(vcpu);
+	}
+
 	err = kvm_vgic_vcpu_init(vcpu);
 	if (err)
 		return err;
@@ -736,6 +751,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 		kvm_arm_setup_debug(vcpu);
 
+		if (use_twed()) {
+			vcpu_twed_enable(vcpu);
+			vcpu_set_twed(vcpu);
+		} else {
+			vcpu_twed_disable(vcpu);
+		}
+
 		/**************************************************************
 		 * Enter the guest
 		 */
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
