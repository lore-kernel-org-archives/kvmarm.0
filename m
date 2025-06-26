Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7032EB10
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 00:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750896752; cv=none; b=Kamc13xjvRNxE4leL0OVkBQl0zal1ApYtNwEUQtN0uTwH6j9ApuHoMrlwQc/7/2B7bkrtRtf9Up+R/scfBTW+jqHOLdalxRaxLa6GnD/OlRPdWYSpRbDaJMAPNsyNO+c5m3nqCe84l23r6daWzuZUk3UYcmJVBTacyIU8/vEh78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750896752; c=relaxed/simple;
	bh=2XyDfFWH/0eDwvNxvoMEhqm8qOkWL90TlQT4lYrrQX4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=thQT9Azzw9chafA1RAUO0HNpf6oZl1znKH7OiMXnJWgdFfCURn1oQbhbWlTiy15lQqgmDlIAlKtAfbk13QmkjxXy/B002zncl4Bp/ODQLDh8ShD44W1IZu2Gef9PznLYSFN28yWJSRmomEREltVDaJdq5MYxtmbMZnh7hFu5QL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qLVs/qAc; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qLVs/qAc"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311ef4fb5eeso325010a91.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 17:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750896750; x=1751501550; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XIDgjwUm8CjgtXg9AIcmlFZZ7eZmoPHxzXcxCBew1V0=;
        b=qLVs/qAcqrLN9myiZUEZt63nLBd6Wh+uGEU7mhOKu0ZbS7N2f2d4KvAZ0yiOmbR6Jy
         UPOO8AmHSqUkvM+Xe4zZvpIX6EIEnvgAuhEIZo1C99hnAjyu6X6kjmDypOd0NCfVBvGr
         rj1n/f2aCeTmFw3dwBQQ+aQjrSdm8q+6SjqQLKuPzcz3ICxcZrS2HdiUnFFKFxDzaIhO
         TRj5YQzWPAAfLvZgtHaFnr0fX2M67Lr7AkoKCvNtAQJjsIIo/vEREbdFNRMhrkaYhWI1
         K369+fQG89kR/fBLh3sW5uzR7oNbFMlotGdgOio8HW+OcgguBxLx3mfUrd/KMK5Gy+Lo
         3aiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750896750; x=1751501550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XIDgjwUm8CjgtXg9AIcmlFZZ7eZmoPHxzXcxCBew1V0=;
        b=Mtb0vGuKeokumwXDN2q4S8I6AqmCYu6ID9rZgHlGLMN8L7MEdAw5YHjrFc7qVAI9fP
         A0bPZdPyMFQhEiZvFLr/r1DGMX+8/z3E6VTAOt+JMYR9dwa406fMGhJTojFnHgpFaWAh
         hCg18/3Mc697OaOctf3dfAft3l0Lt4cuON3cT+dCmMmo+k7V3ya0R4IZcxDkz30MPOMz
         B5VsKL0TmFtjGuGO4RSien5D9ozDgVHtZb1q29QDQCN/1wzq9jeqEBKdwKVKScI/+qBE
         r/YgIerCMv/gw0NiZIoHL4pvqvDWuiFbYLTHbtgoZM42uwskUL33fSB/b+KwueSCxvf3
         RgwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV/Slx7mB54b0vtf9EQD6zfIod8gNPnjttSdL2UmvjJpL33BuVlZ0QdSnDrLRz5weevT5POzY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxoL2GanTGluZbY1aoxRfsRMHHJ8smi9VzaZeUMv2LoxUh7ECWX
	+zpMttLAD4gNFvd/iTHJxkORqy97bcQbQ5aubmlPddbap43aNZJZv0A02hI4S3hmEZ4oOmgsQH7
	tnDtn1w==
X-Google-Smtp-Source: AGHT+IFxqzI3I7qPfHhdkJFEVHE7dAj1xtEraHFWyog88QsjEjNsPNLon63KPUv4mv/v10Bg3S343op+M7c=
X-Received: from pjvf13.prod.google.com ([2002:a17:90a:da8d:b0:2fe:800f:23a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5345:b0:311:1617:5bc4
 with SMTP id 98e67ed59e1d1-316ed3a99d5mr1851989a91.12.1750896750459; Wed, 25
 Jun 2025 17:12:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 25 Jun 2025 17:12:21 -0700
In-Reply-To: <20250626001225.744268-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626001225.744268-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626001225.744268-2-seanjc@google.com>
Subject: [PATCH v5 1/5] KVM: x86: Replace growing set of *_in_guest bools with
 a u64
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jim Mattson <jmattson@google.com>

Store each "disabled exit" boolean in a single bit rather than a byte.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20250530185239.2335185-2-jmattson@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +----
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 arch/x86/kvm/x86.c              |  9 +--------
 arch/x86/kvm/x86.h              | 13 +++++++++----
 5 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index bf26dfb5416d..6fdeeb5870b3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1407,10 +1407,7 @@ struct kvm_arch {
 
 	gpa_t wall_clock;
 
-	bool mwait_in_guest;
-	bool hlt_in_guest;
-	bool pause_in_guest;
-	bool cstate_in_guest;
+	u64 disabled_exits;
 
 	s64 kvmclock_offset;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ab11d1d0ec51..5ad54640314f 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5015,7 +5015,7 @@ static int svm_vm_init(struct kvm *kvm)
 	}
 
 	if (!pause_filter_count || !pause_filter_thresh)
-		kvm->arch.pause_in_guest = true;
+		kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_PAUSE);
 
 	if (enable_apicv) {
 		int ret = avic_vm_init(kvm);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 65949882afa9..702486e7511c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7519,7 +7519,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 int vmx_vm_init(struct kvm *kvm)
 {
 	if (!ple_gap)
-		kvm->arch.pause_in_guest = true;
+		kvm_disable_exits(kvm, KVM_X86_DISABLE_EXITS_PAUSE);
 
 	if (boot_cpu_has(X86_BUG_L1TF) && enable_ept) {
 		switch (l1tf_mitigation) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2806f7104295..2d893993262b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6481,14 +6481,7 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		    (cap->args[0] & ~KVM_X86_DISABLE_EXITS_PAUSE))
 			pr_warn_once(SMT_RSB_MSG);
 
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
-			kvm->arch.pause_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_MWAIT)
-			kvm->arch.mwait_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_HLT)
-			kvm->arch.hlt_in_guest = true;
-		if (cap->args[0] & KVM_X86_DISABLE_EXITS_CSTATE)
-			kvm->arch.cstate_in_guest = true;
+		kvm_disable_exits(kvm, cap->args[0]);
 		r = 0;
 disable_exits_unlock:
 		mutex_unlock(&kvm->lock);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index db4e6a90e83d..31ae58b765f3 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -521,24 +521,29 @@ static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 	    __rem;						\
 	 })
 
+static inline void kvm_disable_exits(struct kvm *kvm, u64 mask)
+{
+	kvm->arch.disabled_exits |= mask;
+}
+
 static inline bool kvm_mwait_in_guest(struct kvm *kvm)
 {
-	return kvm->arch.mwait_in_guest;
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_MWAIT;
 }
 
 static inline bool kvm_hlt_in_guest(struct kvm *kvm)
 {
-	return kvm->arch.hlt_in_guest;
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_HLT;
 }
 
 static inline bool kvm_pause_in_guest(struct kvm *kvm)
 {
-	return kvm->arch.pause_in_guest;
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_PAUSE;
 }
 
 static inline bool kvm_cstate_in_guest(struct kvm *kvm)
 {
-	return kvm->arch.cstate_in_guest;
+	return kvm->arch.disabled_exits & KVM_X86_DISABLE_EXITS_CSTATE;
 }
 
 static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
-- 
2.50.0.727.gbf7dc18ff4-goog

