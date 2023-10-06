Received: from out-194.mta1.migadu.com (out-194.mta1.migadu.com [95.215.58.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE2A13FF1
	for <kvmarm@lists.linux.dev>; Fri,  6 Oct 2023 09:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ubEQae1w"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1696584978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X/yIMo10s50+HEEuceJOygtADefYGavI8ddW8z0g0no=;
	b=ubEQae1wqPG7kyr3OrdWayUEFDvyQH/gBNN/t013RPbSVdJY2mpxhSryDHJ4cTXx12Jdsc
	gxfdRwcDG0ShuOKA7qTnES557j5PB8lsxPXKQ2qH0O8qR/zFTRpq0xvb2SHTBJgoKeFHiL
	EaGHxGERYRgX4YuQ3AudB+wD16TW8RU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/3] KVM: arm64: Load the stage-2 MMU context in kvm_vcpu_load_vhe()
Date: Fri,  6 Oct 2023 09:36:00 +0000
Message-ID: <20231006093600.1250986-4-oliver.upton@linux.dev>
In-Reply-To: <20231006093600.1250986-1-oliver.upton@linux.dev>
References: <20231006093600.1250986-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To date the VHE code has aggressively reloaded the stage-2 MMU context
on every guest entry, despite the fact that this isn't necessary. This
was probably done for consistency with the nVHE code, which needs to
switch in/out the stage-2 MMU context as both the host and guest run at
EL1.

Hoist __stage2_load() into kvm_vcpu_load_vhe(), thus avoiding a reload
on every guest entry/exit. This is likely to be beneficial to systems
with one of the speculative AT errata, as there is now one less context
synchronization event on the guest entry path. Additionally, it is
possible that implementations have hitched correctness mitigations on
writes to VTTBR_EL2, which are now elided on guest re-entry.

Note that __tlb_switch_to_guest() is deliberately left untouched as it
can be called outside the context of a running vCPU.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index d05b6a08dcde..b0cafd7c5f8f 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -120,6 +120,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
 {
 	__vcpu_load_switch_sysregs(vcpu);
 	__vcpu_load_activate_traps(vcpu);
+	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
 }
 
 void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
@@ -182,17 +183,11 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	sysreg_save_host_state_vhe(host_ctxt);
 
 	/*
-	 * ARM erratum 1165522 requires us to configure both stage 1 and
-	 * stage 2 translation for the guest context before we clear
-	 * HCR_EL2.TGE.
-	 *
-	 * We have already configured the guest's stage 1 translation in
-	 * kvm_vcpu_load_sysregs_vhe above.  We must now call
-	 * __load_stage2 before __activate_traps, because
-	 * __load_stage2 configures stage 2 translation, and
-	 * __activate_traps clear HCR_EL2.TGE (among other things).
+	 * Note that ARM erratum 1165522 requires us to configure both stage 1
+	 * and stage 2 translation for the guest context before we clear
+	 * HCR_EL2.TGE. The stage 1 and stage 2 guest context has already been
+	 * loaded on the CPU in kvm_vcpu_load_vhe().
 	 */
-	__load_stage2(vcpu->arch.hw_mmu, vcpu->arch.hw_mmu->arch);
 	__activate_traps(vcpu);
 
 	__kvm_adjust_pc(vcpu);
-- 
2.42.0.609.gbb76f46606-goog

