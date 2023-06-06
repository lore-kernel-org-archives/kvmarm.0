Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFED337B97
	for <kvmarm@lists.linux.dev>; Tue,  6 Jun 2023 15:46:11 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ba81b238ee8so9109387276.0
        for <kvmarm@lists.linux.dev>; Tue, 06 Jun 2023 08:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686066370; x=1688658370;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rMZ/HynJl/U9NP5QUyvGk441HSk6eKuPcYI7/KzvY+g=;
        b=VemcZxxL/Mwa5LaodHaVh0gQd91nJG7t168j+wph+uUsnSEVTBGBJ37C+dCreZ4Ov6
         fuWKNgcSFWD67BOLqxNxUKkuu5kUlS3tNZz/Lvxw1wDm9P6bDG/eQ3qYheT3vcwSOO3o
         HDqiHgKvFaYB4gMr2c2mTkW77rIarqRCAibbW4+F37gMnCRlZ7u+oYJFZ7lfOTdrPnte
         T0nRgM/COgO/8Xi4OCYUzXbz51p8THzKxGlDlH+hlCYfst6GiOKiABJtXBQFcuolm5i2
         ojOiTsZBQFrHMlYeDzu4Fr5WwRjo3iWfcHpQwa3JO4AChSMF3nQrY7Di0IpAPCD3m6Jj
         Hs0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686066370; x=1688658370;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rMZ/HynJl/U9NP5QUyvGk441HSk6eKuPcYI7/KzvY+g=;
        b=IdaRkXYUgIVwyyZbY+NYnDskVwaGcOFFgQCojfEE3hEOzCT+ZvEtNKAH2I79iGWIci
         MqnU53cgV+tybMkUw8HIxkZnuOFiOvRPGrvitQo6z/VtukY22mXFzlXIs+g31TwUYm2X
         k+KtaHjtVKrdo5VvMGMermPiXMjPZklPe4WQOw1EMGgojUEJ1At3qxceItZUmzsgEKhw
         M+YWnJr+vTEHI61r5e02MSPvPu3Qt0A6GyMNoY+eDhhAo22vjuSYUPUpyHvY+LMHel3R
         9rpX4sOOyofoloECTKQ9Zg+QF1eBwcBQfUqTN9PUwlJZOEQ34emC6UvtU/DP63/5bocJ
         M0jQ==
X-Gm-Message-State: AC+VfDxa/lbhVLK1Z8j0o/D+M0lXhpV4wtEBPbMLbk07WmU1HfJh9Np6
	UWZCnOw275VR5XZ1F09x2JgV9Lm9pV8=
X-Google-Smtp-Source: ACHHUZ7NK2LHIl646bV6Su+7Y/8II8GFzLB7DYdKI8npF3vvxrgmzCuYGhM+6Tpb0TB4YQVrFWEtO9gtwWI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d15:0:b0:bac:7086:c9b2 with SMTP id
 21-20020a250d15000000b00bac7086c9b2mr853310ybn.12.1686066370747; Tue, 06 Jun
 2023 08:46:10 -0700 (PDT)
Date: Tue, 6 Jun 2023 15:46:09 +0000
In-Reply-To: <ZH9OQzKIfwxR3q54@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <2f16f83e-ed60-fcb7-7f3d-0fa216c41cb9@redhat.com>
 <ZH8+ZG7DOX9TYcIY@linux.dev> <ZH9CvE54NSVXqjlO@google.com> <ZH9OQzKIfwxR3q54@linux.dev>
Message-ID: <ZH9UwSueTP37NaY7@google.com>
Subject: Re: [PATCH] KVM: arm64: Fix smp_processor_id() call in preemptible context
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sebastian Ott <sebott@redhat.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 06, 2023, Oliver Upton wrote:
> On Tue, Jun 06, 2023 at 07:29:16AM -0700, Sean Christopherson wrote:
> > On Tue, Jun 06, 2023, Oliver Upton wrote:
> > > The call from a preemptible context is intentional, so this really
> > > should just be raw_smp_processor_id(). Do you mind if we fix it with the
> > > following?
> > 
> > ...
> > 
> > > Nonetheless, there's no functional requirement for disabling preemption,
> > > as the cpu # is only used to walk the arm_pmus list. Fix it by using
> > > raw_smp_processor_id() instead.
> > 
> > As a partial outsider, that needs an explanation, and the code could really use a
> > comment.  I assume KVM's ABI is that it's userspace's responsibility to ensure that
> > the CPU(s) used for KVM_RUN is compatible with the CPU used for KVM_ARM_VCPU_PMU_V3_CTRL,
> > but neither the original changelog nor the above state that, nor does anything
> > explain what happens if userspace doesn't uphold its side of things.
> 
> See commit 40e54cad4540 ("KVM: arm64: Document default vPMU behavior on
> heterogeneous systems"), which documents the subtlety of vCPU scheduling
> with the 'old' ABI at the callsite of this function. I don't want to
> bleed any details of this crap into user documentation, since the entire
> scheme is irretrievably broken.

I wasn't suggesting adding anything to user documentation, I was suggesting/asking
that the changelog explain the assertion "there's no functional requirement for
disabling preemption".

> See Documentation/virt/kvm/api/devices/vcpu.rst 1.4 for the 'new' ABI
> where userspace explicitly selects a vPMU instance.
> 
> > That stuff might be covered in documentation somewhere, but for someone
> > just looking at git blame, this is all very magical.
> 
> Personally, I find any other fix that involves disabling preemption to be
> quite a lot more 'magical', as there isn't any percpu data we're working
> with in the loop.

Heh, and?  I wasn't suggesting you take Sebastian's fix, nor was I arguing that
disabling preemption is any more or less magical.  I was simply calling out that
for folks that aren't already familiar with the code, it's not obvious why using
an unstable CPU is functionally correct.

Poking around more, it looks like the answer is that kvm_arch_vcpu_load() will
mark the vCPU as being loaded on an unsupported pCPU, which will prevent running
on the target pCPU, and thus presumably prevent creating new perf events on the
incompatible pCPU.

Though following the breadcrumbs from the commit you referenced above, the set of
"supported" CPUs at this point is all possible CPUs in the system.  So unless I'm
missing something, testing that the current, unstable CPU is a "supported" CPU is
unnecessary because running on an impossible CPU is, um, impossible.

I.e. can't you just do?

---
 arch/arm64/kvm/pmu-emul.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 491ca7eb2a4c..b899d580ff73 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -692,29 +692,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	mutex_unlock(&arm_pmus_lock);
 }
 
-static struct arm_pmu *kvm_pmu_probe_armpmu(void)
-{
-	struct arm_pmu *tmp, *pmu = NULL;
-	struct arm_pmu_entry *entry;
-	int cpu;
-
-	mutex_lock(&arm_pmus_lock);
-
-	cpu = smp_processor_id();
-	list_for_each_entry(entry, &arm_pmus, entry) {
-		tmp = entry->arm_pmu;
-
-		if (cpumask_test_cpu(cpu, &tmp->supported_cpus)) {
-			pmu = tmp;
-			break;
-		}
-	}
-
-	mutex_unlock(&arm_pmus_lock);
-
-	return pmu;
-}
-
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 {
 	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
@@ -900,8 +877,14 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		 * upholds the preexisting behavior on heterogeneous systems
 		 * where vCPUs can be scheduled on any core but the guest
 		 * counters could stop working.
+		 *
+		 * In short, the set of "supported" CPUS for the default PMU is
+		 * all possible CPUs in the system, simply grab the first PMU.
 		 */
-		kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();
+		mutex_lock(&arm_pmus_lock);
+		kvm->arch.arm_pmu = list_first_entry_or_null(&arm_pmus);
+		mutex_unlock(&arm_pmus_lock);
+
 		if (!kvm->arch.arm_pmu)
 			return -ENODEV;
 	}

base-commit: 40e54cad454076172cc3e2bca60aa924650a3e4b
-- 

