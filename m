Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4003161A1
	for <kvmarm@lists.linux.dev>; Sat,  3 Oct 2026 06:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791010639; cv=none; b=tJaO85cW6rnkaiUK0vHzjk5pB8WhZZBtc+S8A9UN/Upbvwk59okTDty8KBoeyyOQnmCkEQ6Dvewd6rFZ8Muwl08oTf4ZmDdA0qt0TbfKlBgGFbeBxwY9knd487rDy3LYOhtlb2TrnpLePLyY7vy4zvqxvc1zTRHMMminnAm60fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791010639; c=relaxed/simple;
	bh=qAjh3bfwDAvjQn/H8WWXm9R9SMLHj6n2zlRKEO0SzGo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X5480v6OgnQajfx/qVlsEgdYK2aqm5cfnas4WK6ncyJz/sMknAo3rSMlBGa+UWNYwZv9P9DmSDpVku0bjdYTYCdocqiy1lSN/TylsA2I3xExvOwcEXqDYpa+6W54Jv7kYw42ZMhRh9Z+fevSDeOhlHnJulDsFwiupF9rX7B+BMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=s+c0TbYx; arc=none smtp.client-ip=91.218.175.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="s+c0TbYx"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=qAjh3bfwDAvjQn/H8WWXm9R9SMLHj6n2zlRKEO0SzGo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791010634; v=1; x=1791615434;
 b=s+c0TbYx8ANQL7IKl00ojtA4/6jHRoxaEMUg37BO5RRxZ7Re4qSw+K49OncJg56qVq/8skvv
 w475h4DcGt83aP/cuKfiY/xrp6gLdzEOhmbditnmWZtvo/rz3s8teoROTz/Ges/aNN/tnZrJgL+
 tMWUo00nfCUeTxNOvwM92bsY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 1a5d39d0f43f4466;
	Sat, 03 Oct 2026 06:57:14 +0000
X-Mizu-Trace-ID: 1a5d39d0f43f4466
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joey.gouly@arm.com,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	mark.rutland@arm.com,
	steven.price@arm.com,
	vdonnefort@google.com,
	qperret@google.com,
	Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH v4 00/18] KVM: arm64: Confine protected VM vCPU state to EL2
Date: Sat,  3 Oct 2026 07:57:13 +0100
Message-Id: <20261003065713.3872839-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <179095643711.351883.2924159912626438826.b4-ty@b4>
References: <20261001135711.1640520-1-fuad.tabba@linux.dev> <179095643711.351883.2924159912626438826.b4-ty@b4>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Marc,

On Fri, 02 Oct 2026 16:55:26 +0100, Marc Zyngier <maz@kernel.org> wrote:

[...]

> Given how busy this merge window is, there were plenty of conflicts, most
> of them with your own patches. Please have a look at the way I resolved
> them and let me know if anything is on the bogus side of wrong...

Thanks for taking these, and for sorting out the conflicts. Most of the
resolution matches mine, but two things in the pkvm-state merge are off:

- In __kvm_vcpu_run(), the !host_vcpu and SVCR bail-outs still return
  -EINVAL. Patch 10 changed them to ARM_EXCEPTION_IL, since the host
  reads bit 31 of -EINVAL as a pending SError.

- In __kvm_adjust_pc(), the pin path uses kern_hyp_va() on the __kern
  pointer, which sparse flags. It needs kern_hyp_va_host().

The diff below fixes both. It also drops the set_bit()s in
pkvm_init_features_from_host() that kvm_pkvm_vcpu_allowed_features()
already does, and realigns the esr_dabt_is_cm() line. Could you fold it
into the merge resolution?

With it applied on next, I booted protected and non-protected guests,
ran CPU hotplug in both, and ran the pKVM selftest (from my tree), all
passing.

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index c709a6ff7448b..1018c36ec39d1 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -244,7 +244,7 @@ static void handle_pvm_entry_dabt(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	/* Handle PC increment on MMIO, or on a CMO the host skipped */
 	pc_update = vcpu_get_flag(host_vcpu, INCREMENT_PC) &&
-		(vcpu->mmio_needed || esr_dabt_is_cm(kvm_vcpu_get_esr(vcpu)));
+		    (vcpu->mmio_needed || esr_dabt_is_cm(kvm_vcpu_get_esr(vcpu)));
 	if (pc_update) {
 		vcpu_clear_flag(vcpu, PC_UPDATE_REQ);
 		kvm_incr_pc(vcpu);
@@ -914,7 +914,7 @@ DEFINE_KVM_HOST_HCALL(int, __kvm_vcpu_run, struct kvm_vcpu __kern *, vcpu)
 
 	host_vcpu = __get_host_hyp_vcpus(kern_hyp_va_host(vcpu), &hyp_vcpu);
 	if (!host_vcpu)
-		return -EINVAL;
+		return ret;
 
 	if (unlikely(hyp_vcpu)) {
 		/*
@@ -924,7 +924,7 @@ DEFINE_KVM_HOST_HCALL(int, __kvm_vcpu_run, struct kvm_vcpu __kern *, vcpu)
 		 * is misbehaving.
 		 */
 		if (unlikely(system_supports_sme() && read_sysreg_s(SYS_SVCR)))
-			return -EINVAL;
+			return ret;
 
 		/*
 		 * ON has a single writer, pkvm_reset_vcpu() on this CPU, so
@@ -1122,7 +1122,7 @@ DEFINE_KVM_HOST_HCALL(void, __kvm_adjust_pc,
 	 * for memory the host isn't sharing, a bad pointer, so the request
 	 * is dropped.
 	 */
-	host_vcpu = kern_hyp_va(vcpu);
+	host_vcpu = kern_hyp_va_host(vcpu);
 	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
 		return;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 03dbe1bf9fa90..f88ad9dc91191 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -413,20 +413,6 @@ static void pkvm_init_features_from_host(struct pkvm_hyp_vm *hyp_vm, const struc
 
 	kvm_pkvm_vcpu_allowed_features(kvm, allowed_features);
 
-	set_bit(KVM_ARM_VCPU_PSCI_0_2, allowed_features);
-
-	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PMU_V3))
-		set_bit(KVM_ARM_VCPU_PMU_V3, allowed_features);
-
-	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_ADDRESS))
-		set_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, allowed_features);
-
-	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_PTRAUTH_GENERIC))
-		set_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, allowed_features);
-
-	if (kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_SVE))
-		set_bit(KVM_ARM_VCPU_SVE, allowed_features);
-
 	bitmap_and(kvm->arch.vcpu_features, host_kvm->arch.vcpu_features,
 		   allowed_features, KVM_VCPU_MAX_FEATURES);
 out:

Cheers,
/fuad
