Return-Path: <SRS0=lhJk=N5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC3CC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 12:33:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87A62604AC
	for <kvmarm@archiver.kernel.org>; Tue,  7 Sep 2021 12:33:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 87A62604AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22EF24B1FE;
	Tue,  7 Sep 2021 08:33:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NSA-Z7rXXmTK; Tue,  7 Sep 2021 08:33:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3E844B200;
	Tue,  7 Sep 2021 08:33:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 127B24B1FC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 08:33:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CP0JwF8UCxRI for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Sep 2021 08:33:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D63694B1FE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Sep 2021 08:33:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A1656D;
 Tue,  7 Sep 2021 05:33:21 -0700 (PDT)
Received: from entos-ampere-02.shanghai.arm.com
 (entos-ampere-02.shanghai.arm.com [10.169.214.103])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9DD7B3F766;
 Tue,  7 Sep 2021 05:33:16 -0700 (PDT)
From: Jia He <justin.he@arm.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 2/2] KVM: arm64: Add memcg accounting to KVM allocations
Date: Tue,  7 Sep 2021 20:31:12 +0800
Message-Id: <20210907123112.10232-3-justin.he@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210907123112.10232-1-justin.he@arm.com>
References: <20210907123112.10232-1-justin.he@arm.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>,
 Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, Jia He <justin.he@arm.com>,
 Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Liu Shixin <liushixin2@huawei.com>, Sami Tolvanen <samitolvanen@google.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Inspired by commit 254272ce6505 ("kvm: x86: Add memcg accounting to KVM
allocations"), it would be better to make arm64 KVM consistent with
common kvm codes.

The memory allocations of VM scope should be charged into VM process
cgroup, hence change GFP_KERNEL to GFP_KERNEL_ACCOUNT.

There remain a few cases since these allocations are global, not in VM
scope.

Signed-off-by: Jia He <justin.he@arm.com>
---
 arch/arm64/kvm/arm.c      | 6 ++++--
 arch/arm64/kvm/mmu.c      | 2 +-
 arch/arm64/kvm/pmu-emul.c | 2 +-
 arch/arm64/kvm/reset.c    | 2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0ca72f5cda41..7a7c478b8e6b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -293,10 +293,12 @@ long kvm_arch_dev_ioctl(struct file *filp,
 
 struct kvm *kvm_arch_alloc_vm(void)
 {
+	size_t sz = sizeof(struct kvm);
+
 	if (!has_vhe())
-		return kzalloc(sizeof(struct kvm), GFP_KERNEL);
+		return kzalloc(sz, GFP_KERNEL_ACCOUNT);
 
-	return vzalloc(sizeof(struct kvm));
+	return __vmalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_HIGHMEM | __GFP_ZERO);
 }
 
 void kvm_arch_free_vm(struct kvm *kvm)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0625bf2353c2..801845ebd9d5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -465,7 +465,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 		return -EINVAL;
 	}
 
-	pgt = kzalloc(sizeof(*pgt), GFP_KERNEL);
+	pgt = kzalloc(sizeof(*pgt), GFP_KERNEL_ACCOUNT);
 	if (!pgt)
 		return -ENOMEM;
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index f33825c995cb..05d42f6b89e4 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -971,7 +971,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		mutex_lock(&vcpu->kvm->lock);
 
 		if (!vcpu->kvm->arch.pmu_filter) {
-			vcpu->kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL);
+			vcpu->kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
 			if (!vcpu->kvm->arch.pmu_filter) {
 				mutex_unlock(&vcpu->kvm->lock);
 				return -ENOMEM;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index cba7872d69a8..608c1baaaa63 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -106,7 +106,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 		    vl > SVE_VL_ARCH_MAX))
 		return -EIO;
 
-	buf = kzalloc(SVE_SIG_REGS_SIZE(sve_vq_from_vl(vl)), GFP_KERNEL);
+	buf = kzalloc(SVE_SIG_REGS_SIZE(sve_vq_from_vl(vl)), GFP_KERNEL_ACCOUNT);
 	if (!buf)
 		return -ENOMEM;
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
