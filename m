Return-Path: <SRS0=DvdR=PH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B19C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ED13661260
	for <kvmarm@archiver.kernel.org>; Tue, 19 Oct 2021 12:13:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ED13661260
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A246D4B17B;
	Tue, 19 Oct 2021 08:13:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f9wPl1xIB7Ca; Tue, 19 Oct 2021 08:13:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72C614B199;
	Tue, 19 Oct 2021 08:13:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B51134B0DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aIjw6+1rQdZv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Oct 2021 08:13:43 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8266B4AC78
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 08:13:42 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 f20-20020a05600c155400b0030db7b29174so1079784wmg.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Oct 2021 05:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VqYPavyR2JRTUWvE5kjjzlUp50pAuHmuHcARAYk4cwk=;
 b=fGi7IVyHWwfKQS2WbRt2o+yRVdxkv/7OeCdfA8Py2fFF0DRYQaLM7bUAn4tRvOCb6L
 UYC9SRTQ42xvB8Xoqub8ks9s52dpmbfkm+nh04FUXNyyBbLGkbdTtw3MW8S/ct0VuF1a
 hatlEFd42G71G8EgIcsabJ2RwHJb+puTGYm+uiRBCH5+mK8nCmY59E2VMpa+tfRufGpu
 Uyux/TC1Du3dMEK8gNu4keJ5UFr673qhIq57qoEayFQBYpe7vg6F+mJBhZHawxAHDBcN
 If1bGrUtd8wJRrN6RNtohM6Jmv2jaGMrZ/5+CnlgLSAkSU8VUMwN/vtvLWctXfMQ/0jH
 T5Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VqYPavyR2JRTUWvE5kjjzlUp50pAuHmuHcARAYk4cwk=;
 b=UeCAj6fxVnTddSG8xR4Lg9RpuI6B6GYX9JodhjiobNlYfgQqeVJnhpx50x93OV4DBh
 GVAgo1T/zz+r7Y92MYfo93bwd1cLVI8EANO3+o+PJJ6d7W2tfTg0o5F0bg/fQj8ai6BD
 bzWxt/zYyc3c59huC/ZDeHsGdmNvIEpHZ2QCMNCQjARTMm9rnUMP+lKPEwEoVWRlf55k
 3VvDxk/q4bMNGI3e10Bp89ASr+akbEEUDRh4nT1jEO3dfx0ANcAabtDUajmUuC+3pySj
 cYLVjGLzlm8+tpnW8dpAvf5fetM9yRhAQN3UPFGyLrl/Bi+evpL2E7MI3YPUz/63bt4T
 bcXw==
X-Gm-Message-State: AOAM5326bFP45R3beURgwdmqSC/gM7KPiu7sgeCDwiUHmWW5Erq50VSR
 J4PiwgC9gKTlJJU6u0GDtndk9HKvjE5f
X-Google-Smtp-Source: ABdhPJydGp5bAuju3SKMKeRNA5buAgHVc9pJMxXIPwxc98YN65zoWKEuWvhMGvpeXA+5NqfJbVAcywe3r4Wf
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:59ca:401f:83a8:de6d])
 (user=qperret job=sendgmr) by 2002:a05:600c:4e94:: with SMTP id
 f20mr5727676wmq.52.1634645621773; Tue, 19 Oct 2021 05:13:41 -0700 (PDT)
Date: Tue, 19 Oct 2021 13:13:04 +0100
In-Reply-To: <20211019121304.2732332-1-qperret@google.com>
Message-Id: <20211019121304.2732332-16-qperret@google.com>
Mime-Version: 1.0
References: <20211019121304.2732332-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH v2 15/15] KVM: arm64: pkvm: Unshare guest structs during
 teardown
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, Andrew Walbran <qwandor@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

Make use of the newly introduced unshare hypercall during guest teardown
to unmap guest-related data structures from the hyp stage-1.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/asm/kvm_mmu.h  |  1 +
 arch/arm64/kvm/arm.c              |  2 ++
 arch/arm64/kvm/fpsimd.c           | 29 +++++++++++++++++++++
 arch/arm64/kvm/mmu.c              | 42 +++++++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c            |  8 +++++-
 6 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index d1451c8a768b..9f70e82c7436 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -323,6 +323,7 @@ struct kvm_vcpu_arch {
 
 	struct thread_info *host_thread_info;	/* hyp VA */
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
+	struct task_struct *parent_task;
 
 	struct {
 		/* {Break,watch}point registers */
@@ -738,6 +739,7 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
+void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 {
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 185d0f62b724..81839e9a8a24 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -151,6 +151,7 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
 #include <asm/stage2_pgtable.h>
 
 int kvm_share_hyp(void *from, void *to);
+void kvm_unshare_hyp(void *from, void *to);
 int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
 int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
 			   void __iomem **kaddr,
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5312d5a2ef69..ebab9529b736 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -188,6 +188,8 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		}
 	}
 	atomic_set(&kvm->online_vcpus, 0);
+
+	kvm_unshare_hyp(kvm, kvm + 1);
 }
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 2fe1128d9f3d..ace5ebef8aab 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -15,6 +15,22 @@
 #include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
+void kvm_vcpu_unshare_task_fp(struct kvm_vcpu *vcpu)
+{
+	struct task_struct *p = vcpu->arch.parent_task;
+	struct user_fpsimd_state *fpsimd;
+	struct thread_info *ti;
+
+	if (!is_protected_kvm_enabled() || !p)
+		return;
+
+	ti = &p->thread_info;
+	kvm_unshare_hyp(ti, ti + 1);
+	fpsimd = &p->thread.uw.fpsimd_state;
+	kvm_unshare_hyp(fpsimd, fpsimd + 1);
+	put_task_struct(p);
+}
+
 /*
  * Called on entry to KVM_RUN unless this vcpu previously ran at least
  * once and the most recent prior KVM_RUN for this vcpu was called from
@@ -31,6 +47,8 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 	struct thread_info *ti = &current->thread_info;
 	struct user_fpsimd_state *fpsimd = &current->thread.uw.fpsimd_state;
 
+	kvm_vcpu_unshare_task_fp(vcpu);
+
 	/*
 	 * Make sure the host task thread flags and fpsimd state are
 	 * visible to hyp:
@@ -45,6 +63,17 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.host_thread_info = kern_hyp_va(ti);
 	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
+
+	/*
+	 * We need to keep current's task_struct pinned until its data has been
+	 * unshared with the hypervisor to make sure it is not re-used by the
+	 * kernel and donated to someone else while already shared -- see
+	 * kvm_vcpu_unshare_task_fp() for the matching put_task_struct().
+	 */
+	if (is_protected_kvm_enabled()) {
+		get_task_struct(current);
+		vcpu->arch.parent_task = current;
+	}
 error:
 	return ret;
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f0c16ed95974..d548141da2ea 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -344,6 +344,32 @@ static int share_pfn_hyp(u64 pfn)
 	return ret;
 }
 
+static int unshare_pfn_hyp(u64 pfn)
+{
+	struct rb_node **node, *parent;
+	struct hyp_shared_pfn *this;
+	int ret = 0;
+
+	mutex_lock(&hyp_shared_pfns_lock);
+	this = find_shared_pfn(pfn, &node, &parent);
+	if (WARN_ON(!this)) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	this->count--;
+	if (this->count)
+		goto unlock;
+
+	rb_erase(&this->node, &hyp_shared_pfns);
+	kfree(this);
+	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn, 1);
+unlock:
+	mutex_unlock(&hyp_shared_pfns_lock);
+
+	return ret;
+}
+
 int kvm_share_hyp(void *from, void *to)
 {
 	phys_addr_t start, end, cur;
@@ -368,6 +394,22 @@ int kvm_share_hyp(void *from, void *to)
 	return 0;
 }
 
+void kvm_unshare_hyp(void *from, void *to)
+{
+	phys_addr_t start, end, cur;
+	u64 pfn;
+
+	if (is_kernel_in_hyp_mode() || kvm_host_owns_hyp_mappings() || !from)
+		return;
+
+	start = ALIGN_DOWN(kvm_kaddr_to_phys(from), PAGE_SIZE);
+	end = PAGE_ALIGN(kvm_kaddr_to_phys(to));
+	for (cur = start; cur < end; cur += PAGE_SIZE) {
+		pfn = __phys_to_pfn(cur);
+		WARN_ON(unshare_pfn_hyp(pfn));
+	}
+}
+
 /**
  * create_hyp_mappings - duplicate a kernel virtual address range in Hyp mode
  * @from:	The virtual kernel start address of the range
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index cf781ec9212a..bf15e9de4123 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -150,7 +150,13 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
 
 void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kfree(vcpu->arch.sve_state);
+	void *sve_state = vcpu->arch.sve_state;
+
+	kvm_vcpu_unshare_task_fp(vcpu);
+	kvm_unshare_hyp(vcpu, vcpu + 1);
+	if (sve_state)
+		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
+	kfree(sve_state);
 }
 
 static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
-- 
2.33.0.1079.g6e70778dc9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
