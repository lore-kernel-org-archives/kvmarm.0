Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4217C432BE
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:12:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4AAC36138F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:12:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4AAC36138F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDD364B0B6;
	Sun, 15 Aug 2021 20:12:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rwsb4189iGPl; Sun, 15 Aug 2021 20:12:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A66E64B112;
	Sun, 15 Aug 2021 20:12:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC5CA4B0F7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5-RDFpFfNUR9 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:12:32 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D294C4B108
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:26 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 b202-20020a6bb2d3000000b005b7fb465c4aso114253iof.17
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=kqHsZtsc3rsaBs8YykjTfYieWZWleao7VNediAJYDnk=;
 b=pBfl7TLYi2YLH2KPmg5hiwpPawDYkYoGHwz5MgNuqHogNQOycSiur/P2y49NBm+drR
 /Cr/PD+jyTL6ih41g24jrrVagY3NLpgLtUj7KMGNB+PWgZvQ5q3kftrWanrcKQHkYMG4
 MXsF+os6IWikIejEb/aOrCg8aHt/qnJB8EHcLlal0zUwK4kYn4aP7Q7eUjySY5BwB0sB
 uoRPcQJDOg3Hmhj5XtcQXkZ8WMNW0jLoNQdOWmL9zjM1xhxVdC2HdjuToBMw/m2Bn1ql
 z9OVr+DzoxrQ4f92gctg3MtAtVc3lHqYtR/AgT6/72E6J6DzA0IvYww3or7GzwqVSGNc
 Bc5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kqHsZtsc3rsaBs8YykjTfYieWZWleao7VNediAJYDnk=;
 b=FrypzLZbcahSjwRIQ/XYiPGUGzkmJE8VQqAKhn57Bys2Tec0e4QKH5OCSk4UuL058X
 V/VsndP0CB+vMUZ3hFsEdFgjyQQNQWwhPWAWw5w7ArTtEOnlJaptdiibxAKb1BlzIvpE
 Q4hHLXJUFqXrsXF2mDKHBS2mG2HBuTECHb2x1qPS8C+4QkRRBix4p+mz0gahWecgsLWN
 3+Bl1munPtGAjwFfqI9EBtaf6sQv/2efj0XFAQfZBNf8ox8N0FfEK09kDzmR5LqBTDpv
 W3lpRPztzHvaHutGKBq199NNeeavPGKCcGpDZixAkYPB9UAsvCl4uNh0pv1tT784CCm6
 pPuA==
X-Gm-Message-State: AOAM530jQoietd+tqa7mYoDe7TQUZpVSZGNZUSeY8FNyXaHSnA/kuB5K
 Us+Ou7Jvtqaffivo2kcHUKK+n8yKQoc=
X-Google-Smtp-Source: ABdhPJwUzuhENHzkbWfNuyab+2wrwAQ/8Ih1khTW27au7+6FctA+taj7GfdJ29iI5mvEVIhWGnjQzHbS5IM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:1448:: with SMTP id
 l8mr4001325jad.55.1629072746337; Sun, 15 Aug 2021 17:12:26 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:12:15 +0000
In-Reply-To: <20210816001217.3063400-1-oupton@google.com>
Message-Id: <20210816001217.3063400-6-oupton@google.com>
Mime-Version: 1.0
References: <20210816001217.3063400-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 5/7] KVM: arm64: Allow userspace to configure a guest's
 counter-timer offset
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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

Presently, KVM provides no facilities for correctly migrating a guest
that depends on the physical counter-timer. While most guests (barring
NV, of course) should not depend on the physical counter-timer, an
operator may wish to provide a consistent view of the physical
counter-timer across migrations.

Provide userspace with a new vCPU attribute to modify the guest
counter-timer offset. Unlike KVM_REG_ARM_TIMER_OFFSET, this attribute is
hidden from the guest's architectural state. The value offsets *both*
the virtual and physical counter-timer views for the guest. Only support
this attribute on ECV systems as ECV is required for hardware offsetting
of the physical counter-timer.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 Documentation/arm64/booting.rst         |  7 ++
 Documentation/virt/kvm/devices/vcpu.rst | 28 ++++++++
 arch/arm64/include/asm/kvm_asm.h        |  2 +
 arch/arm64/include/asm/sysreg.h         |  2 +
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/arch_timer.c             | 96 ++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  6 ++
 arch/arm64/kvm/hyp/nvhe/timer-sr.c      |  9 +++
 arch/arm64/kvm/hyp/vhe/timer-sr.c       |  5 ++
 include/clocksource/arm_arch_timer.h    |  1 +
 10 files changed, 155 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm64/booting.rst b/Documentation/arm64/booting.rst
index a9192e7a231b..bfdbc9df7b55 100644
--- a/Documentation/arm64/booting.rst
+++ b/Documentation/arm64/booting.rst
@@ -311,6 +311,13 @@ Before jumping into the kernel, the following conditions must be met:
     - ZCR_EL2.LEN must be initialised to the same value for all CPUs the
       kernel will execute on.
 
+  For CPUs with the Enhanced Counter Virtualization (FEAT_ECV) extension
+  present with ID_AA64MMFR0_EL1.ECV >= 0x2:
+
+  - if EL3 is present and the kernel is entered at EL2:
+
+    - SCR_EL3.ECVEn (bit 28) must be initialized to 0b1.
+
 The requirements described above for CPU mode, caches, MMUs, architected
 timers, coherency and system registers apply to all CPUs.  All CPUs must
 enter the kernel in the same exception level.  Where the values documented
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 2acec3b9ef65..f240ecc174ef 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -139,6 +139,34 @@ configured values on other VCPUs.  Userspace should configure the interrupt
 numbers on at least one VCPU after creating all VCPUs and before running any
 VCPUs.
 
+2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_PHYS_OFFSET
+-----------------------------------------
+
+:Parameters: in kvm_device_attr.addr the address for the timer offset is a
+             pointer to a __u64
+
+Returns:
+
+	 ======= ==================================
+	 -EFAULT Error reading/writing the provided
+		 parameter address
+	 -ENXIO  Timer offsetting not implemented
+	 ======= ==================================
+
+Specifies the guest's counter-timer offset from the host's virtual counter.
+The guest's physical counter value is then derived by the following
+equation:
+
+  guest_cntpct = host_cntvct - KVM_ARM_VCPU_TIMER_PHYS_OFFSET
+
+The guest's virtual counter value is derived by the following equation:
+
+  guest_cntvct = host_cntvct - KVM_REG_ARM_TIMER_OFFSET
+			- KVM_ARM_VCPU_TIMER_PHYS_OFFSET
+
+KVM does not allow the use of varying offset values for different vCPUs;
+the last written offset value will be broadcasted to all vCPUs in a VM.
+
 3. GROUP: KVM_ARM_VCPU_PVTIME_CTRL
 ==================================
 
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index aed2aa61766a..052a6f987095 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -64,6 +64,7 @@
 #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
 #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
 #define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			20
+#define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntpoff		21
 
 #ifndef __ASSEMBLY__
 
@@ -199,6 +200,7 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
+extern void __kvm_timer_set_cntpoff(u64 cntpoff);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index c7ddf9a71134..e02b7cd574e6 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -586,6 +586,8 @@
 #define SYS_ICH_LR14_EL2		__SYS__LR8_EL2(6)
 #define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
 
+#define SYS_CNTPOFF_EL2			sys_reg(3, 4, 14, 0, 6)
+
 /* VHE encodings for architectural EL0/1 system registers */
 #define SYS_SCTLR_EL12			sys_reg(3, 5, 1, 0, 0)
 #define SYS_CPACR_EL12			sys_reg(3, 5, 1, 0, 2)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 949a31bc10f0..70e2893c1749 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -366,6 +366,7 @@ struct kvm_arm_copy_mte_tags {
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define   KVM_ARM_VCPU_TIMER_PHYS_OFFSET	2
 #define KVM_ARM_VCPU_PVTIME_CTRL	2
 #define   KVM_ARM_VCPU_PVTIME_IPA	0
 
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 9d9bac3ec40e..46380c389683 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -86,8 +86,11 @@ static u64 timer_get_offset(struct arch_timer_context *ctxt)
 {
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
+	case TIMER_PTIMER:
 		return ctxt->host_offset;
 	default:
+		WARN_ONCE(1, "unrecognized timer %ld\n",
+			  arch_timer_ctx_index(ctxt));
 		return 0;
 	}
 }
@@ -140,6 +143,7 @@ static void timer_set_offset(struct arch_timer_context *ctxt, u64 offset)
 {
 	switch(arch_timer_ctx_index(ctxt)) {
 	case TIMER_VTIMER:
+	case TIMER_PTIMER:
 		ctxt->host_offset = offset;
 		break;
 	default:
@@ -568,6 +572,11 @@ static void set_cntvoff(u64 cntvoff)
 	kvm_call_hyp(__kvm_timer_set_cntvoff, cntvoff);
 }
 
+static void set_cntpoff(u64 cntpoff)
+{
+	kvm_call_hyp(__kvm_timer_set_cntpoff, cntpoff);
+}
+
 static inline void set_timer_irq_phys_active(struct arch_timer_context *ctx, bool active)
 {
 	int r;
@@ -643,6 +652,8 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	}
 
 	set_cntvoff(timer_get_offset(map.direct_vtimer));
+	if (cpus_have_final_cap(ARM64_HAS_ECV2))
+		set_cntpoff(timer_get_offset(vcpu_ptimer(vcpu)));
 
 	kvm_timer_unblocking(vcpu);
 
@@ -810,6 +821,22 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
 	mutex_unlock(&kvm->lock);
 }
 
+static void update_ptimer_cntpoff(struct kvm_vcpu *vcpu, u64 cntpoff)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 cntvoff;
+
+	mutex_lock(&kvm->lock);
+
+	/* adjustments to the physical offset also affect vtimer */
+	cntvoff = timer_get_offset(vcpu_vtimer(vcpu));
+	cntvoff += cntpoff - timer_get_offset(vcpu_ptimer(vcpu));
+
+	update_timer_offset(vcpu, TIMER_PTIMER, cntpoff, false);
+	update_timer_offset(vcpu, TIMER_VTIMER, cntvoff, false);
+	mutex_unlock(&kvm->lock);
+}
+
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
@@ -1346,6 +1373,9 @@ void kvm_timer_init_vhe(void)
 	val = read_sysreg(cnthctl_el2);
 	val |= (CNTHCTL_EL1PCEN << cnthctl_shift);
 	val |= (CNTHCTL_EL1PCTEN << cnthctl_shift);
+
+	if (cpus_have_final_cap(ARM64_HAS_ECV2))
+		val |= CNTHCTL_ECV;
 	write_sysreg(val, cnthctl_el2);
 }
 
@@ -1360,7 +1390,8 @@ static void set_timer_irqs(struct kvm *kvm, int vtimer_irq, int ptimer_irq)
 	}
 }
 
-int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+static int kvm_arm_timer_set_attr_irq(struct kvm_vcpu *vcpu,
+				      struct kvm_device_attr *attr)
 {
 	int __user *uaddr = (int __user *)(long)attr->addr;
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
@@ -1393,7 +1424,37 @@ int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	return 0;
 }
 
-int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+static int kvm_arm_timer_set_attr_offset(struct kvm_vcpu *vcpu,
+					 struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+	u64 offset;
+
+	if (!cpus_have_final_cap(ARM64_HAS_ECV2))
+		return -ENXIO;
+
+	if (get_user(offset, uaddr))
+		return -EFAULT;
+
+	update_ptimer_cntpoff(vcpu, offset);
+	return 0;
+}
+
+int kvm_arm_timer_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
+	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
+		return kvm_arm_timer_set_attr_irq(vcpu, attr);
+	case KVM_ARM_VCPU_TIMER_PHYS_OFFSET:
+		return kvm_arm_timer_set_attr_offset(vcpu, attr);
+	default:
+		return -ENXIO;
+	}
+}
+
+static int kvm_arm_timer_get_attr_irq(struct kvm_vcpu *vcpu,
+				      struct kvm_device_attr *attr)
 {
 	int __user *uaddr = (int __user *)(long)attr->addr;
 	struct arch_timer_context *timer;
@@ -1414,12 +1475,43 @@ int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	return put_user(irq, uaddr);
 }
 
+static int kvm_arm_timer_get_attr_offset(struct kvm_vcpu *vcpu,
+					 struct kvm_device_attr *attr)
+{
+	u64 __user *uaddr = (u64 __user *)(long)attr->addr;
+	u64 offset;
+
+	if (!cpus_have_final_cap(ARM64_HAS_ECV2))
+		return -ENXIO;
+
+	offset = timer_get_offset(vcpu_ptimer(vcpu));
+	return put_user(offset, uaddr);
+}
+
+int kvm_arm_timer_get_attr(struct kvm_vcpu *vcpu,
+			   struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
+	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
+		return kvm_arm_timer_get_attr_irq(vcpu, attr);
+	case KVM_ARM_VCPU_TIMER_PHYS_OFFSET:
+		return kvm_arm_timer_get_attr_offset(vcpu, attr);
+	default:
+		return -ENXIO;
+	}
+}
+
 int kvm_arm_timer_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 {
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_TIMER_IRQ_VTIMER:
 	case KVM_ARM_VCPU_TIMER_IRQ_PTIMER:
 		return 0;
+	case KVM_ARM_VCPU_TIMER_PHYS_OFFSET:
+		if (cpus_have_final_cap(ARM64_HAS_ECV2))
+			return 0;
+		break;
 	}
 
 	return -ENXIO;
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2da6aa8da868..f1b8da4737dc 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -68,6 +68,11 @@ static void handle___kvm_timer_set_cntvoff(struct kvm_cpu_context *host_ctxt)
 	__kvm_timer_set_cntvoff(cpu_reg(host_ctxt, 1));
 }
 
+static void handle___kvm_timer_set_cntpoff(struct kvm_cpu_context *host_ctxt)
+{
+	__kvm_timer_set_cntpoff(cpu_reg(host_ctxt, 1));
+}
+
 static void handle___kvm_enable_ssbs(struct kvm_cpu_context *host_ctxt)
 {
 	u64 tmp;
@@ -185,6 +190,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_create_private_mapping),
 	HANDLE_FUNC(__pkvm_prot_finalize),
+	HANDLE_FUNC(__kvm_timer_set_cntpoff),
 };
 
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 9072e71693ba..e98a949f5227 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -15,6 +15,11 @@ void __kvm_timer_set_cntvoff(u64 cntvoff)
 	write_sysreg(cntvoff, cntvoff_el2);
 }
 
+void __kvm_timer_set_cntpoff(u64 cntpoff)
+{
+	write_sysreg_s(cntpoff, SYS_CNTPOFF_EL2);
+}
+
 /*
  * Should only be called on non-VHE systems.
  * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
@@ -26,6 +31,8 @@ void __timer_disable_traps(struct kvm_vcpu *vcpu)
 	/* Allow physical timer/counter access for the host */
 	val = read_sysreg(cnthctl_el2);
 	val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
+	if (cpus_have_final_cap(ARM64_HAS_ECV2))
+		val &= ~CNTHCTL_ECV;
 	write_sysreg(val, cnthctl_el2);
 }
 
@@ -42,6 +49,8 @@ void __timer_enable_traps(struct kvm_vcpu *vcpu)
 	 * Physical counter access is allowed
 	 */
 	val = read_sysreg(cnthctl_el2);
+	if (cpus_have_final_cap(ARM64_HAS_ECV2))
+		val |= CNTHCTL_ECV;
 	val &= ~CNTHCTL_EL1PCEN;
 	val |= CNTHCTL_EL1PCTEN;
 	write_sysreg(val, cnthctl_el2);
diff --git a/arch/arm64/kvm/hyp/vhe/timer-sr.c b/arch/arm64/kvm/hyp/vhe/timer-sr.c
index 4cda674a8be6..231e16a071a5 100644
--- a/arch/arm64/kvm/hyp/vhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/timer-sr.c
@@ -10,3 +10,8 @@ void __kvm_timer_set_cntvoff(u64 cntvoff)
 {
 	write_sysreg(cntvoff, cntvoff_el2);
 }
+
+void __kvm_timer_set_cntpoff(u64 cntpoff)
+{
+	write_sysreg_s(cntpoff, SYS_CNTPOFF_EL2);
+}
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index 73c7139c866f..7252ffa3d675 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -21,6 +21,7 @@
 #define CNTHCTL_EVNTEN			(1 << 2)
 #define CNTHCTL_EVNTDIR			(1 << 3)
 #define CNTHCTL_EVNTI			(0xF << 4)
+#define CNTHCTL_ECV			(1 << 12)
 
 enum arch_timer_reg {
 	ARCH_TIMER_REG_CTRL,
-- 
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
