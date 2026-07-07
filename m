Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738D8225791;
	Tue,  7 Jul 2026 18:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783447360; cv=none; b=qhcdcUwjLV9Ba5F85Wt3bZ4B0+fFibMzSDi4fCCnopFap95dbJnJwwErK4SafWQGbT6JzQtq/r/Bg37m1v1a6aYURSfslnHhj4qNPiL9wFfLAnM6LHdhje0Mgr8/TGoxCldoHq7zT2MT1OxKz1xTGOn5RG/sHFoGxH489ALO5QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783447360; c=relaxed/simple;
	bh=v5UE4CN/5U1UeycwVcqpmK3ZPN8kJbKTuuCG+EL1iLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Il+ij5X9Y384JJmfhQppciOmcycKQD6liBipyP2qW191VinXaxH/s01uXSlaIelFhcCfum3GZyQe2uh9rl3ISv0GnuTALH8x1LMCM6HP2HcGvOYk0M9nQeHayh/z4Sp+BakD+FVrPlvT4bCXKmKq+PMZL8xz+hpeEwq8VaDn5NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N+Vnbwou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N+Vnbwou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41221F000E9;
	Tue,  7 Jul 2026 18:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783447359;
	bh=FryudSw1T2aBIUC8yNaOKfA0SsyG7mefxgdiOUUg/jo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N+Vnbwoua/QGFqX1FJgxTZEeQArxQywA5ZLkb+cuyiLT1RyZBO8UKEnY1TN1bRU+y
	 mmImothqrfHNURIQLWJ/FVvuF+nGkjn62x3ctvrxuKVMdasv+rz8+EhJWbyE9bVMAP
	 XeXPvElu8iOFTsq5ShjS+JCrJ+t9w6iHaJZ2BvoL54Gs1evNMASXj19FeDmeueAseD
	 M7yO3DIThFb6/MbvZUUbt+47vSyWcwfhLN5nmXrCiCUy18/Fgo7e71ItmXyNIni1sr
	 e1Cudg/8AwbbkWQxfyGpEJeGE//8QxHgz5emwJUSZxpzTmnrZQg99BNpuQfCaJSKtR
	 0RMZFg5mGzjig==
Date: Tue, 7 Jul 2026 11:02:37 -0700
From: Oliver Upton <oupton@kernel.org>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 5/7] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
Message-ID: <ak0_PSnxyAWm9_Fu@kernel.org>
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <20260706-hybrid-v8-5-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
 <akvyvclUQ2b2YHiU@kernel.org>
 <cb5d5f13-a1a9-47dd-a717-5533a8b32b20@rsg.ci.i.u-tokyo.ac.jp>
 <5e66748a-bfda-41a9-8614-88cbf2fe1f09@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5e66748a-bfda-41a9-8614-88cbf2fe1f09@rsg.ci.i.u-tokyo.ac.jp>

On Tue, Jul 07, 2026 at 09:52:49PM +0900, Akihiko Odaki wrote:
> On 2026/07/07 20:23, Akihiko Odaki wrote:
> > On 2026/07/07 3:23, Oliver Upton wrote:
> > > Just detect the changing PMU implementation here, KVM_REQ_RELOAD_PMU
> > > will need to detect the PMCs that require an update anyway. Stash the
> > > last cpu in kvm_arch_vcpu_load() and pass it to this:
> > > 
> > > void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu, int last_cpu)
> > > {
> > >     if (!kvm_pmu_fixed_counters_only(vcpu->kvm) || vcpu->cpu == last_cpu)
> > >         return;
> > > 
> > >     if (kvm_pmu_probe_armpmu(vcpu->cpu) !=
> > > kvm_pmu_probe_armpmu(last_cpu))
> > >         kvm_make_request(KVM_REQ_RELOAD_PMU);
> > > }
> > 
> > It is a nice way to simplify the code and to avoid hardcoding
> > ARMV8_PMU_INSTR_IDX. I'll use the code for the next version.
> 
> I tried this but unfortunately it doesn't seem to work. kvm_arch_vcpu_put()
> sets vcpu->cpu to -1 so we cannot simply read it to get the last cpu in
> kvm_arch_vcpu_load().

Urgh, there's no reason for doing that any more. Let's fix it, I want a
straightforward way to detect pCPU migrations. There may be other
reasons for using it in the future.

Untested, but could you give this a whirl?

From bb5af058030aada66f5c9eafa54db604979acf55 Mon Sep 17 00:00:00 2001
From: Oliver Upton <oupton@kernel.org>
Date: Tue, 7 Jul 2026 09:50:00 -0700
Subject: [PATCH] KVM: arm64: Don't clear vcpu->cpu in kvm_arch_vcpu_put()

commit e9b152cb957c ("arm/arm64: kvm: Set vcpu->cpu to -1 on vcpu_put")
reset vcpu->cpu in order for the VGIC to determine if there was any vCPU
running at the time of access. The VGIC has gone through an entire
rewrite since then, and with commit 7d450e282171 ("KVM: arm/arm64:
vgic-new: Add userland access to VGIC dist registers") the user
accessors just grab all vCPU mutexes instead.

Drop this remaining vestige such that kvm_arch_vcpu_load() can properly
detect a CPU migration. While at it, rework kvm_reset_vcpu() to do a
much more pedantic check that the provided vCPU is actually what's
running on the present CPU.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kvm/arm.c   |  1 -
 arch/arm64/kvm/reset.c | 15 ++++++++++-----
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..735acc42b50b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -749,7 +749,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_arm_vmid_clear_active();
 
 	vcpu_clear_on_unsupported_cpu(vcpu);
-	vcpu->cpu = -1;
 }
 
 static void __kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b963fd975aac..6aba085c0673 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -190,7 +190,8 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
 void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_reset_state reset_state;
-	bool loaded;
+	struct kvm_vcpu *running;
+	bool loaded = false;
 	u32 pstate;
 
 	spin_lock(&vcpu->arch.mp_state_lock);
@@ -198,10 +199,15 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	vcpu->arch.reset_state.reset = false;
 	spin_unlock(&vcpu->arch.mp_state_lock);
 
-	preempt_disable();
-	loaded = (vcpu->cpu != -1);
-	if (loaded)
+	guard(preempt)();
+
+	if ((running = kvm_get_running_vcpu())) {
+		if (KVM_BUG_ON(running != vcpu, vcpu->kvm))
+			return;
+
+		loaded = true;
 		kvm_arch_vcpu_put(vcpu);
+	}
 
 	if (!kvm_arm_vcpu_sve_finalized(vcpu)) {
 		if (vcpu_has_feature(vcpu, KVM_ARM_VCPU_SVE))
@@ -269,7 +275,6 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	if (loaded)
 		kvm_arch_vcpu_load(vcpu, smp_processor_id());
-	preempt_enable();
 }
 
 u32 kvm_get_pa_bits(struct kvm *kvm)
-- 
2.47.3

