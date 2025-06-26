Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B039B78C9C
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 00:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750896754; cv=none; b=vE2NNV7L4WON0xO5SXECNwc9DVMyuV9kMGT0mC9GMj1WKtcATibCAdZTWj8ALVpVWhVVF7v8zfpvT8yMOhKcs+vq0wXbuiePCe+BRt7gmy41LtIazAe95pCfzHcekLzZ2s9kfPO3MQU8MZr0lgJBgyOtH1wnxeyRuIqRFgq2icw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750896754; c=relaxed/simple;
	bh=wz6AYJSwpgL+PNCPg7+NHYUGvEuhrNDWmDHVzVRm01k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ETsblY1jn6QJQvZtmGwv7L75rS3skjVbH6SyAHJPlUHhsnKvDpodzaN45ecRBnnaluYXC9ZbJIgHBoeapxZRhz3EeP2+SZpKOzxv5R4vMld2DZ88grqnFaQhvjmB6Bp25pZHZCCPFyf30vffIOVUhs2lUcPFhCkxrV1wcFcej4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=At9medhd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="At9medhd"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132e7266d3so281527a91.2
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 17:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750896752; x=1751501552; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XSP+SKXtRx+biMOjK34h1pSwHQW4K9lXK2fj/zxr4DU=;
        b=At9medhd1nbxRtrID0NCl5oxa0n+7ARvNdetIVlEiuB896jm6LqnD5NsCHilcabJ+K
         4JZm0/KMTYbYLVbRDcSaSYVvyb7rCZlIihw0afOk7W4hrbwANTfC4EX0ckqZQthoA1ie
         KBtIWNYZAWPblV+0Qj4OaWeksfk/WOisESV1IUhCLdw9oiRF4991b7tJXWl2XQdTAUAV
         h8u3KWW4sAcLPVDVaW1PyplANYjB2m5/jmwz78ob3zbHf9tNs/9yM1Buq/CITiPCBSZg
         hZ4QUDxIoMw0DB/2uk6AUJjzfbMQiVbOOJ+TEEqmHuHw0R4cvdRAuY6ixe8ZK8MPndZE
         BUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750896752; x=1751501552;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XSP+SKXtRx+biMOjK34h1pSwHQW4K9lXK2fj/zxr4DU=;
        b=ISm+Z7nYTOh2jXJUftyhkNfZ4XKGHa4gNJlxioXpWjo9o04IQYSfLdflF1QBtdFYjb
         B8NlYpLiIADYX60AiS4e/HVQk9vEJ2zgGEc1DrfHRD/o/P/ULz7JtHyBrcK5wEOyhaGL
         aRH+0yRIrmIPj6D5mAJQPPrdBoi5+ehv8WJckgCwrqMei8er7dripI/kUARN/Ffqi6WZ
         ML63dp6rtfkCHt8LppBRSz932nKgkRKvIny/nnebNwjOvYcU9/ynCEm6oEGxw8/zs588
         0I4/Z2augA3vYm2SAXxcXHIDjqJNcBY8vjThRNL7droqyLGsllTUqvcaJCKwEbwBtrm3
         eXLw==
X-Forwarded-Encrypted: i=1; AJvYcCWiIjts6zAJhAiQIW4OVVAz5JSMt+5rnAWxDtJXFuAAuUGxCmYX35DbUEpBF+WbFwcru/HP3Mc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2qJREsc7FSfl706GZ9kOwLi2s8x9UV1+hn1Ga0sd3vhgS+Pmi
	cUcTvGlCMieK0MQRGb+Z1ak+ngKKZya5inOhk3JSpinIEG8ohlBhfhZhzKzvlyibm9yBC7XlB+f
	N9BGqbA==
X-Google-Smtp-Source: AGHT+IFx2aeEYWWp0A4eOd+dZkDdacmFG8AeQwkHeIe1hmy4RL4XWPzZG1HZhh54tyUmB3eNC5v+ZYUBeck=
X-Received: from pjbsz14.prod.google.com ([2002:a17:90b:2d4e:b0:313:1c10:3595])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5484:b0:312:1d2d:18e1
 with SMTP id 98e67ed59e1d1-315f2671e07mr5802724a91.22.1750896752146; Wed, 25
 Jun 2025 17:12:32 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 25 Jun 2025 17:12:22 -0700
In-Reply-To: <20250626001225.744268-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626001225.744268-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626001225.744268-3-seanjc@google.com>
Subject: [PATCH v5 2/5] KVM: x86: Provide a capability to disable APERF/MPERF
 read intercepts
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jim Mattson <jmattson@google.com>

Allow a guest to read the physical IA32_APERF and IA32_MPERF MSRs
without interception.

The IA32_APERF and IA32_MPERF MSRs are not virtualized. Writes are not
handled at all. The MSR values are not zeroed on vCPU creation, saved
on suspend, or restored on resume. No accommodation is made for
processor migration or for sharing a logical processor with other
tasks. No adjustments are made for non-unit TSC multipliers. The MSRs
do not account for time the same way as the comparable PMU events,
whether the PMU is virtualized by the traditional emulation method or
the new mediated pass-through approach.

Nonetheless, in a properly constrained environment, this capability
can be combined with a guest CPUID table that advertises support for
CPUID.6:ECX.APERFMPERF[bit 0] to induce a Linux guest to report the
effective physical CPU frequency in /proc/cpuinfo. Moreover, there is
no performance cost for this capability.

Signed-off-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20250530185239.2335185-3-jmattson@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 23 +++++++++++++++++++++++
 arch/x86/kvm/svm/nested.c      |  4 +++-
 arch/x86/kvm/svm/svm.c         |  5 +++++
 arch/x86/kvm/vmx/nested.c      |  6 ++++++
 arch/x86/kvm/vmx/vmx.c         |  4 ++++
 arch/x86/kvm/x86.c             |  6 +++++-
 arch/x86/kvm/x86.h             |  5 +++++
 include/uapi/linux/kvm.h       |  1 +
 tools/include/uapi/linux/kvm.h |  1 +
 9 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 43ed57e048a8..27ced3ee2b53 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7844,6 +7844,7 @@ Valid bits in args[0] are::
   #define KVM_X86_DISABLE_EXITS_HLT              (1 << 1)
   #define KVM_X86_DISABLE_EXITS_PAUSE            (1 << 2)
   #define KVM_X86_DISABLE_EXITS_CSTATE           (1 << 3)
+  #define KVM_X86_DISABLE_EXITS_APERFMPERF       (1 << 4)
 
 Enabling this capability on a VM provides userspace with a way to no
 longer intercept some instructions for improved latency in some
@@ -7854,6 +7855,28 @@ all such vmexits.
 
 Do not enable KVM_FEATURE_PV_UNHALT if you disable HLT exits.
 
+Virtualizing the ``IA32_APERF`` and ``IA32_MPERF`` MSRs requires more
+than just disabling APERF/MPERF exits. While both Intel and AMD
+document strict usage conditions for these MSRs--emphasizing that only
+the ratio of their deltas over a time interval (T0 to T1) is
+architecturally defined--simply passing through the MSRs can still
+produce an incorrect ratio.
+
+This erroneous ratio can occur if, between T0 and T1:
+
+1. The vCPU thread migrates between logical processors.
+2. Live migration or suspend/resume operations take place.
+3. Another task shares the vCPU's logical processor.
+4. C-states lower thean C0 are emulated (e.g., via HLT interception).
+5. The guest TSC frequency doesn't match the host TSC frequency.
+
+Due to these complexities, KVM does not automatically associate this
+passthrough capability with the guest CPUID bit,
+``CPUID.6:ECX.APERFMPERF[bit 0]``. Userspace VMMs that deem this
+mechanism adequate for virtualizing the ``IA32_APERF`` and
+``IA32_MPERF`` MSRs must set the guest CPUID bit explicitly.
+
+
 7.14 KVM_CAP_S390_HPAGE_1M
 --------------------------
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 749f7b866ac8..b7fd2e869998 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -194,7 +194,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
  * Hardcode the capacity of the array based on the maximum number of _offsets_.
  * MSRs are batched together, so there are fewer offsets than MSRs.
  */
-static int nested_svm_msrpm_merge_offsets[6] __ro_after_init;
+static int nested_svm_msrpm_merge_offsets[7] __ro_after_init;
 static int nested_svm_nr_msrpm_merge_offsets __ro_after_init;
 typedef unsigned long nsvm_msrpm_merge_t;
 
@@ -216,6 +216,8 @@ int __init nested_svm_init_msrpm_merge_offsets(void)
 		MSR_IA32_SPEC_CTRL,
 		MSR_IA32_PRED_CMD,
 		MSR_IA32_FLUSH_CMD,
+		MSR_IA32_APERF,
+		MSR_IA32_MPERF,
 		MSR_IA32_LASTBRANCHFROMIP,
 		MSR_IA32_LASTBRANCHTOIP,
 		MSR_IA32_LASTINTFROMIP,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5ad54640314f..d9931c6c4bc6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -839,6 +839,11 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 	svm_set_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW,
 				  guest_cpuid_is_intel_compatible(vcpu));
 
+	if (kvm_aperfmperf_in_guest(vcpu->kvm)) {
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_APERF, MSR_TYPE_R);
+		svm_disable_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYPE_R);
+	}
+
 	if (sev_es_guest(vcpu->kvm))
 		sev_es_recalc_msr_intercepts(vcpu);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c69df3aba8d1..b8ea1969113d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -715,6 +715,12 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
 
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_APERF, MSR_TYPE_R);
+
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
+					 MSR_IA32_MPERF, MSR_TYPE_R);
+
 	kvm_vcpu_unmap(vcpu, &map);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 702486e7511c..58c5dd368222 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4088,6 +4088,10 @@ void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
 	}
+	if (kvm_aperfmperf_in_guest(vcpu->kvm)) {
+		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_APERF, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_IA32_MPERF, MSR_TYPE_R);
+	}
 
 	/* PT MSRs can be passed through iff PT is exposed to the guest. */
 	if (vmx_pt_mode_is_host_guest())
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2d893993262b..28541a612526 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4580,6 +4580,9 @@ static u64 kvm_get_allowed_disable_exits(void)
 {
 	u64 r = KVM_X86_DISABLE_EXITS_PAUSE;
 
+	if (boot_cpu_has(X86_FEATURE_APERFMPERF))
+		r |= KVM_X86_DISABLE_EXITS_APERFMPERF;
+
 	if (!mitigate_smt_rsb) {
 		r |= KVM_X86_DISABLE_EXITS_HLT |
 			KVM_X86_DISABLE_EXITS_CSTATE;
@@ -6478,7 +6481,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 
 		if (!mitigate_smt_rsb && boot_cpu_has_bug(X86_BUG_SMT_RSB) &&
 		    cpu_smt_possible() &&
-		    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
+		    (cap->args[0] & ~(KVM_X86_DISABLE_EXITS_PAUSE |
+				      KVM_X86_DISABLE_EXITS_APERFMPERF)))
 			pr_warn_once(SMT_RSB_MSG);
 
 		kvm_disable_exits(kvm, cap->args[0]);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 31ae58b765f3..bcfd9b719ada 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -546,6 +546,11 @@ static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_CSTATE;
 }
 
+static inline bool kvm_aperfmperf_in_guest(struct kvm *kvm)
+{
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_APERFMPERF;
+}
+
 static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
 {
 	return kvm->arch.notify_vmexit_flags & KVM_X86_NOTIFY_VMEXIT_ENABLED;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 7a4c35ff03fe..aeb2ca10b190 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -644,6 +644,7 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
+#define KVM_X86_DISABLE_EXITS_APERFMPERF     (1 << 4)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index d00b85cb168c..7415a3863891 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -618,6 +618,7 @@ struct kvm_ioeventfd {
 #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
 #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
 #define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
+#define KVM_X86_DISABLE_EXITS_APERFMPERF     (1 << 4)
 
 /* for KVM_ENABLE_CAP */
 struct kvm_enable_cap {
-- 
2.50.0.727.gbf7dc18ff4-goog

