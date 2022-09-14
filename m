Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890B8C6FA89
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 08:36:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 46EB64BB72;
	Wed, 14 Sep 2022 04:36:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3h7YleJVL9KC; Wed, 14 Sep 2022 04:36:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE1C34BC91;
	Wed, 14 Sep 2022 04:36:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68B2B4BB72
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:36:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TLxpqFk0L0lI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2022 04:36:42 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97A394BC52
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:36:41 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 1D147CE1412;
 Wed, 14 Sep 2022 08:36:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD03C43140;
 Wed, 14 Sep 2022 08:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663144597;
 bh=MlWoZVA87h9kjzgVATfOatuufMJn9f6Ylb6LjSEGsNI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Zzq1DsNcFpuv9l/vvfs4uOEzPkpOehHeEupqvvhYZMnV32pSPMKLQl9V2lHOJclZH
 Tn7vL5YTssuTANKK0FXiteg/rQYdCLbtyXCmx4BmgO9R1OEC650leCyDbDbbkWBMUu
 5gnIE21y9GgI6JmBLt4WoMJ5b4tloW+IsgsaDuWD7glhLPxPusRFsj/6eh9K7ur1D1
 Ok1UgM/fZpylv8Tg8TdhcudMi1qzhsu42/mONPy1RW6D+Dl7jJB0hy/1//G2Rk1QdZ
 3pA3nhoqrouHBCdOn8HwXnMIFiHmrxBi3Z6Z9gzRdoG+JngOdfxreXHqxrbMzm3cIx
 Lup7Y+6fPY6aA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [RFC PATCH v3 25/25] KVM: arm64: Use the pKVM hyp vCPU structure in
 handle___kvm_vcpu_run()
Date: Wed, 14 Sep 2022 09:35:00 +0100
Message-Id: <20220914083500.5118-26-will@kernel.org>
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

As a stepping stone towards deprivileging the host's access to the
guest's vCPU structures, introduce some naive flush/sync routines to
copy most of the host vCPU into the hyp vCPU on vCPU run and back
again on return to EL1.

This allows us to run using the pKVM hyp structures when KVM is
initialised in protected mode.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  4 ++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     | 79 +++++++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 28 +++++++++
 3 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 5d456438445c..38424b98ed84 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -67,4 +67,8 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 		     unsigned long vcpu_hva);
 int __pkvm_teardown_vm(pkvm_handle_t handle);
 
+struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
+					 unsigned int vcpu_idx);
+void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
+
 #endif /* __ARM64_KVM_NVHE_PKVM_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index b5f3fcfe9135..728e01d4536b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -22,11 +22,86 @@ DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
+static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+
+	hyp_vcpu->vcpu.arch.ctxt	= host_vcpu->arch.ctxt;
+
+	hyp_vcpu->vcpu.arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
+	hyp_vcpu->vcpu.arch.sve_max_vl	= host_vcpu->arch.sve_max_vl;
+
+	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
+
+	hyp_vcpu->vcpu.arch.hcr_el2	= host_vcpu->arch.hcr_el2;
+	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
+	hyp_vcpu->vcpu.arch.cptr_el2	= host_vcpu->arch.cptr_el2;
+
+	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
+	hyp_vcpu->vcpu.arch.fp_state	= host_vcpu->arch.fp_state;
+
+	hyp_vcpu->vcpu.arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
+	hyp_vcpu->vcpu.arch.host_fpsimd_state = host_vcpu->arch.host_fpsimd_state;
+
+	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
+
+	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
+}
+
+static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+	struct vgic_v3_cpu_if *hyp_cpu_if = &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
+	struct vgic_v3_cpu_if *host_cpu_if = &host_vcpu->arch.vgic_cpu.vgic_v3;
+	unsigned int i;
+
+	host_vcpu->arch.ctxt		= hyp_vcpu->vcpu.arch.ctxt;
+
+	host_vcpu->arch.hcr_el2		= hyp_vcpu->vcpu.arch.hcr_el2;
+	host_vcpu->arch.cptr_el2	= hyp_vcpu->vcpu.arch.cptr_el2;
+
+	host_vcpu->arch.fault		= hyp_vcpu->vcpu.arch.fault;
+
+	host_vcpu->arch.iflags		= hyp_vcpu->vcpu.arch.iflags;
+	host_vcpu->arch.fp_state	= hyp_vcpu->vcpu.arch.fp_state;
+
+	host_cpu_if->vgic_hcr		= hyp_cpu_if->vgic_hcr;
+	for (i = 0; i < hyp_cpu_if->used_lrs; ++i)
+		host_cpu_if->vgic_lr[i] = hyp_cpu_if->vgic_lr[i];
+}
+
 static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 {
-	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 1);
+	int ret;
+
+	host_vcpu = kern_hyp_va(host_vcpu);
+
+	if (unlikely(is_protected_kvm_enabled())) {
+		struct pkvm_hyp_vcpu *hyp_vcpu;
+		struct kvm *host_kvm;
+
+		host_kvm = kern_hyp_va(host_vcpu->kvm);
+		hyp_vcpu = pkvm_load_hyp_vcpu(host_kvm->arch.pkvm.handle,
+					      host_vcpu->vcpu_idx);
+		if (!hyp_vcpu) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		flush_hyp_vcpu(hyp_vcpu);
+
+		ret = __kvm_vcpu_run(&hyp_vcpu->vcpu);
+
+		sync_hyp_vcpu(hyp_vcpu);
+		pkvm_put_hyp_vcpu(hyp_vcpu);
+	} else {
+		/* The host is fully trusted, run its vCPU directly. */
+		ret = __kvm_vcpu_run(host_vcpu);
+	}
 
-	cpu_reg(host_ctxt, 1) =  __kvm_vcpu_run(kern_hyp_va(vcpu));
+out:
+	cpu_reg(host_ctxt, 1) =  ret;
 }
 
 static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3c9ce49dc15c..1b3f10aa4c20 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -241,6 +241,33 @@ static struct pkvm_hyp_vm *get_vm_by_handle(pkvm_handle_t handle)
 	return vm_table[idx];
 }
 
+struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
+					 unsigned int vcpu_idx)
+{
+	struct pkvm_hyp_vcpu *hyp_vcpu = NULL;
+	struct pkvm_hyp_vm *hyp_vm;
+
+	hyp_spin_lock(&vm_table_lock);
+	hyp_vm = get_vm_by_handle(handle);
+	if (!hyp_vm || hyp_vm->nr_vcpus <= vcpu_idx)
+		goto unlock;
+
+	hyp_vcpu = hyp_vm->vcpus[vcpu_idx];
+	hyp_page_ref_inc(hyp_virt_to_page(hyp_vm));
+unlock:
+	hyp_spin_unlock(&vm_table_lock);
+	return hyp_vcpu;
+}
+
+void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct pkvm_hyp_vm *hyp_vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
+
+	hyp_spin_lock(&vm_table_lock);
+	hyp_page_ref_dec(hyp_virt_to_page(hyp_vm));
+	hyp_spin_unlock(&vm_table_lock);
+}
+
 static void unpin_host_vcpu(struct kvm_vcpu *host_vcpu)
 {
 	if (host_vcpu)
@@ -286,6 +313,7 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 	hyp_vcpu->vcpu.vcpu_idx = vcpu_idx;
 
 	hyp_vcpu->vcpu.arch.hw_mmu = &hyp_vm->kvm.arch.mmu;
+	hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
