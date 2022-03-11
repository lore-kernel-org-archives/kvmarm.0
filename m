Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BDB3C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EE3C49E10;
	Fri, 11 Mar 2022 12:41:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kknApAD4Y2bc; Fri, 11 Mar 2022 12:41:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9871D40FB2;
	Fri, 11 Mar 2022 12:41:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D21B040A84
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hnXf0t6b4FhP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:02 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81CDE408A7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:02 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 b70-20020a253449000000b0062c16d950c5so7911490yba.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=j0xad0wsUd0JZg0GeKxejSss4gL9J8KLC9CepguR0Is=;
 b=YcqrJdbSsWWCZ9HE1h7BQY6mSi1J6diw5nGgmloSw7X6l7oE8NvPnzc2OaKBwBOV2+
 zAMMemqEu0ghtWECIO0qUAdItddQbD13SclvXZf+YIVhojgX9aI+DnkcmigL4DUo7cMO
 hrQBGA6Byfu542kaahVe1WaPDqlD62PauplnFxYb7vG9fmcRKUK2ag2eC1vs00/nhdt5
 JDxLPgBmm76D1G0RQSs1bxcy+01CU5yMx9RXB76gAVSj1CMcm+3Lr1ubK4ahARjyHsTO
 ey8uT6wULZ+vnvC5/fM0M9NUSUxpB/VAPn1Nk/WYPTf0aaC0e0hZc5+bHW0FgE9W6xOh
 tWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=j0xad0wsUd0JZg0GeKxejSss4gL9J8KLC9CepguR0Is=;
 b=4kQyLgjBJSZWqF+voJzzU85EyZ6kRlA8gxjzj3mESRjjPj9MeLyIToVRlh21+DugUM
 JLbn2mW9pX7UoxbLrCzqTtEi/5VWNmCMjDJiihkXyY3v+m7YrgVtZq6a/6nKIYF61Mn4
 rdhrpUcbA9sNZ7pdnLWZw1YBmw70HZ9MLvytHRIozuJuIpOt0UA09ORP1/eQSzrKcXXq
 +LWoUH3VV6bMYSNeS2oBlan7PT2kmFWZ9dAh71DK1jzuag6za3JxvEYgwm1bpgBPVtPo
 dlfDtBvhQ92rhCps/OEYHZjgLBp5xRFSTSQshzC6JI/aR5JpuwMNKjVkm7a/mz3mWGHl
 dC4A==
X-Gm-Message-State: AOAM533qYNk0t0lo9V8b2/f2VehEdwcXPcvFx8YuK2HbauzqAf/CVSW5
 0IZUO4Lci4khSm+uxrD3taR0wUM6+UzdFyURzojj1XzpOLEDUgF62tXjJ3fCRD2VvQ3ZJeORZu6
 wYmZgVjmAw8HmGld7CFHzES+K/EZD8JYzsS/Q+/kUGC1kVCaA0vZjLDswfDTQN/p+MjVPTg==
X-Google-Smtp-Source: ABdhPJyYtiCOxt/joBrBg+VAXK+PjFmD0BozCAPN55Ws8+mEBUulPGJB8S41rOZzbW8h7P950PMGDXF3jF4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:be8a:0:b0:608:67d7:22fe with
 SMTP id
 i10-20020a25be8a000000b0060867d722femr8644022ybk.336.1647020461786; Fri, 11
 Mar 2022 09:41:01 -0800 (PST)
Date: Fri, 11 Mar 2022 17:39:47 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-2-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 01/15] KVM: arm64: Generalise VM features into a set of
 flags
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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

From: Marc Zyngier <maz@kernel.org>

We currently deal with a set of booleans for VM features,
while they could be better represented as set of flags
contained in an unsigned long, similarily to what we are
doing on the CPU side.

Signed-off-by: Marc Zyngier <maz@kernel.org>
[Oliver: Flag-ify the 'ran_once' boolean]
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 15 +++++++++------
 arch/arm64/kvm/arm.c              |  7 ++++---
 arch/arm64/kvm/mmio.c             |  3 ++-
 arch/arm64/kvm/pmu-emul.c         |  4 ++--
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 76f795b628f1..0e96087885fe 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -122,7 +122,12 @@ struct kvm_arch {
 	 * should) opt in to this feature if KVM_CAP_ARM_NISV_TO_USER is
 	 * supported.
 	 */
-	bool return_nisv_io_abort_to_user;
+#define KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER	0
+	/* Memory Tagging Extension enabled for the guest */
+#define KVM_ARCH_FLAG_MTE_ENABLED			1
+	/* At least one vCPU has ran in the VM */
+#define KVM_ARCH_FLAG_HAS_RAN_ONCE			2
+	unsigned long flags;
 
 	/*
 	 * VM-wide PMU filter, implemented as a bitmap and big enough for
@@ -135,10 +140,6 @@ struct kvm_arch {
 
 	u8 pfr0_csv2;
 	u8 pfr0_csv3;
-
-	/* Memory Tagging Extension enabled for the guest */
-	bool mte_enabled;
-	bool ran_once;
 };
 
 struct kvm_vcpu_fault_info {
@@ -810,7 +811,9 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 #define kvm_arm_vcpu_sve_finalized(vcpu) \
 	((vcpu)->arch.flags & KVM_ARM64_VCPU_SVE_FINALIZED)
 
-#define kvm_has_mte(kvm) (system_supports_mte() && (kvm)->arch.mte_enabled)
+#define kvm_has_mte(kvm)					\
+	(system_supports_mte() &&				\
+	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(test_bit(KVM_ARM_VCPU_PMU_V3, (vcpu)->arch.features))
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f49ebdd9c990..17021bc8ee2c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -84,7 +84,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 	switch (cap->cap) {
 	case KVM_CAP_ARM_NISV_TO_USER:
 		r = 0;
-		kvm->arch.return_nisv_io_abort_to_user = true;
+		set_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+			&kvm->arch.flags);
 		break;
 	case KVM_CAP_ARM_MTE:
 		mutex_lock(&kvm->lock);
@@ -92,7 +93,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			r = -EINVAL;
 		} else {
 			r = 0;
-			kvm->arch.mte_enabled = true;
+			set_bit(KVM_ARCH_FLAG_MTE_ENABLED, &kvm->arch.flags);
 		}
 		mutex_unlock(&kvm->lock);
 		break;
@@ -559,7 +560,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 		kvm_call_hyp_nvhe(__pkvm_vcpu_init_traps, vcpu);
 
 	mutex_lock(&kvm->lock);
-	kvm->arch.ran_once = true;
+	set_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags);
 	mutex_unlock(&kvm->lock);
 
 	return ret;
diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
index 3e2d8ba11a02..3dd38a151d2a 100644
--- a/arch/arm64/kvm/mmio.c
+++ b/arch/arm64/kvm/mmio.c
@@ -135,7 +135,8 @@ int io_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 	 * volunteered to do so, and bail out otherwise.
 	 */
 	if (!kvm_vcpu_dabt_isvalid(vcpu)) {
-		if (vcpu->kvm->arch.return_nisv_io_abort_to_user) {
+		if (test_bit(KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER,
+			     &vcpu->kvm->arch.flags)) {
 			run->exit_reason = KVM_EXIT_ARM_NISV;
 			run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
 			run->arm_nisv.fault_ipa = fault_ipa;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 4526a5824dac..78fdc443adc7 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -961,7 +961,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 	list_for_each_entry(entry, &arm_pmus, entry) {
 		arm_pmu = entry->arm_pmu;
 		if (arm_pmu->pmu.type == pmu_id) {
-			if (kvm->arch.ran_once ||
+			if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags) ||
 			    (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
 				ret = -EBUSY;
 				break;
@@ -1044,7 +1044,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		mutex_lock(&kvm->lock);
 
-		if (kvm->arch.ran_once) {
+		if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
 			mutex_unlock(&kvm->lock);
 			return -EBUSY;
 		}
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
