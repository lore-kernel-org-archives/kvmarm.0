Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3AE1400B
	for <kvmarm@lists.linux.dev>; Tue,  5 Mar 2024 18:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709664536; cv=none; b=GRst59CY9EBVBPoyeukZu4oiSWIbt8SN07EUwvDiDSPU31rX1i57h4bu9ZjR9lsjThqeNJ6oTmF4HKjYxBHxzSkMtKx5YeBxDqAJ8MtrF+TYuj8BK3nUjcjEaT26W45DpFSHVm8DXa4yO0LkF8dbxE/57rSy1cIu7KX9W2QqCqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709664536; c=relaxed/simple;
	bh=dSnVqxXdXBQ3d6YHtUhcUeGFSPSJGZz8/MCeKLlhRHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=If9Miih/y4xgnto2fPllhth0zJI6arJdZdKfvXJyGgK5D04l079hFG165P4J9bVyXGR/Q57/tBHm0NvIBPTUfyWa9XbAvSDAiwcLb88aAxeEEH5y4gh43QqOO4baoOMvxH4bDemoK0Kj3fatL4AIBNTTx4dXTakJOTmdFlHzSnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sGVp4fHw; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sGVp4fHw"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709664532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j+Zj9cqUShvqFDWkLjHqbbR7Cd2iF1e2A5jCN1Pac1g=;
	b=sGVp4fHwvC7YQdK27ICZCoq31X52zFghb1GHuzcasN9PcDvIL1pzUxKgX21gi72dR/fbhH
	FaT8tXZqLNtbtyAAIUMUGH6taORHWLc7hqrTq4mcRBDFL6q6lvpQ3+0/aPjEpoxN9TmPci
	22PfKNanld4V8RAxhLHpYcDbeNxoIRU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 1/3] KVM: arm64: pkvm: Actually enable/disable PMU events when running vCPU
Date: Tue,  5 Mar 2024 18:48:38 +0000
Message-ID: <20240305184840.636212-2-oliver.upton@linux.dev>
In-Reply-To: <20240305184840.636212-1-oliver.upton@linux.dev>
References: <20240305184840.636212-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

flush_hyp_vcpu() does not carry through the PMU event context from the
host, regardless of whether the VM is protected or not. This is
problematic for two reasons:

 - The expectation for non-protected VMs is that the protected-mode
   hypervisor has feature parity with the 'normal' KVM configuration.
   However, PMU events programmed to run with the guest do not work.

 - The protected-mode hypervisor needs to prevent the host from peering
   in on the guest. Nothing stops the host from leaving an event enabled
   straight past guest entry...

Address the both of these issues by priming the hyp vCPU's PMU event
context before entering the guest. Take special care to not trust the
host in the case of pVMs by referring directly to what hardware says is
enabled.

Cc: Will Deacon <will@kernel.org>
Fixes: be66e67f1750 ("KVM: arm64: Use the pKVM hyp vCPU structure in handle___kvm_vcpu_run()")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2385fd03ed87..8621f8383f0c 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -23,6 +23,26 @@ DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
 
 void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
 
+static void flush_debug_state(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
+
+	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
+	hyp_vcpu->vcpu.arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
+
+	/*
+	 * The host's PMU context cannot be trusted for protected VMs. Refer to
+	 * hardware to determine which PMCs need to be disabled/enabled on vCPU
+	 * entry/exit, respectively.
+	 */
+	if (kvm_vm_is_protected(kern_hyp_va(host_vcpu->kvm))) {
+		hyp_vcpu->vcpu.arch.pmu.events.events_host = read_sysreg(pmcntenclr_el0);
+		hyp_vcpu->vcpu.arch.pmu.events.events_guest = 0;
+	} else {
+		hyp_vcpu->vcpu.arch.pmu.events = host_vcpu->arch.pmu.events;
+	}
+}
+
 static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
 	struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
@@ -35,18 +55,18 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
 
 	hyp_vcpu->vcpu.arch.hcr_el2	= host_vcpu->arch.hcr_el2;
-	hyp_vcpu->vcpu.arch.mdcr_el2	= host_vcpu->arch.mdcr_el2;
 	hyp_vcpu->vcpu.arch.cptr_el2	= host_vcpu->arch.cptr_el2;
 
 	hyp_vcpu->vcpu.arch.iflags	= host_vcpu->arch.iflags;
 	hyp_vcpu->vcpu.arch.fp_state	= host_vcpu->arch.fp_state;
 
-	hyp_vcpu->vcpu.arch.debug_ptr	= kern_hyp_va(host_vcpu->arch.debug_ptr);
 	hyp_vcpu->vcpu.arch.host_fpsimd_state = host_vcpu->arch.host_fpsimd_state;
 
 	hyp_vcpu->vcpu.arch.vsesr_el2	= host_vcpu->arch.vsesr_el2;
 
 	hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3 = host_vcpu->arch.vgic_cpu.vgic_v3;
+
+	flush_debug_state(hyp_vcpu);
 }
 
 static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
-- 
2.44.0.278.ge034bb2e1d-goog

