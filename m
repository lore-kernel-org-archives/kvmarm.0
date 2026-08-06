Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047EC30E0F2
	for <kvmarm@lists.linux.dev>; Thu,  6 Aug 2026 21:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786052785; cv=none; b=XIVASopjgDiHWC4oteCD/gRopzqASs17UqomRD6+VR7ZBC+RdGPNLa1ULbaEe+DnDKnk1WZBoEaNjNzEB5lTx78M/XsnIXX6nUxt7zUcePQKZTmk8Jps9e5dNS4EJC+RBJW9gXmYQ7cGtI82d2itnecstNgPX0EJUqTYfgpPMJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786052785; c=relaxed/simple;
	bh=R5IlNYT9grSWMNRUE5eHnlj/fSWDkT4pmhLM0SsMSl0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=s7G/XbcSklORkFw8kLylw2g8LS9G3YY4y4QAY2eUVfHAFAkOwS7LEdbeANblJF3fCXK2DzgvkhJCvJZdfDVSeCExmIUqrhSHG1I/r1e1EasNS0yUMVUdphIV1F+xWh1MU8Xt9PMYL7Blah0rGfxM3b+JY53Ma08ZkrFDMsdCQ5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JJtW7vBI; arc=none smtp.client-ip=209.85.216.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JJtW7vBI"
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38ce7fabf76so4254151a91.2
        for <kvmarm@lists.linux.dev>; Thu, 06 Aug 2026 14:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786052783; x=1786657583; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :reply-to:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=shGHIfLMy0zOulR4PSpJjZWPNrTU67gcyn62KwrDxcg=;
        b=JJtW7vBIC6exKzs0HlnGzhJXboZJPalKm7wgZucWmEHbxJ70uFmgqMiM50EHEEuE6L
         I9lreW6VNLHBMU3v5uVqrBzd8COTdMIl62PpylqmNWYw3/qCRNT+t3Y5ZYxCoHITsTuM
         i0Jf2UAmn7ahd9R/tKrfNRaYZrzG8z+KxnNcgGdBBMIc9C2YGMk2fecq2y+dkXVmw/IU
         8H2fg5NwocwddudBIK3xcZlvbyfiG3aDXg3Hq3ypmtOhPAjmnM6aqrYK0jwl9hQD5iWZ
         Na9t571SgFH4K+t7XFLXBdMsMVtcKaGdQzYU3h/yCuKVgIdOBfypBWmCgqpFrV7NFcdi
         EGTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786052783; x=1786657583;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=shGHIfLMy0zOulR4PSpJjZWPNrTU67gcyn62KwrDxcg=;
        b=FbDy9uRfGSUwTn+KnaFIr5VF8ua4p1YFkoZMZzWP9EiaVyj9ADfeEFs6/AOyJoYAOy
         vs8STjHI9amMFl6xQB5RVwr3s1FQh9NblOvFTEZYXzJWfOx3CsKllpLwW+Y2YYuWKBYk
         SjDXMaBxq9ciZHOeJzgdyoL8AAaMlf4J6vMNuf9iapwh+409ceLXzV3RuGvM/2icyQ5l
         WCnnWtC/pX0DSs4Ziwa1bVJv8MSaplM/mbZsIHd7duQqo5GWmoCRvwbfGZXwSx04HK8Q
         4jXXdN2Yq/rWY2hWr0Ow/ZDmGqZCEteAv2kejkLoly3HtYRi0xps+6pH7WIXYMOyg2on
         hYnA==
X-Forwarded-Encrypted: i=1; AHgh+RrOCmOR4FdHQNJ7FDoOsq6Hx9gi4iOv/1k9jtKS1pvRCjHA+adCIJ3tbcSABMjg9his0AV5wUI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKl37PQCUex1EmcJxxn3VLlpUHBRm1QQRXLrxM+/V/4jrSmnx0
	ShskEdUpsYqMtuj8wmtgMItzFfP8a/uVLNZMMTYl38EIK2Cmye2+O6TyrQ73Md4EAcueTf0bWGH
	51v3jyw==
X-Received: from pjup19.prod.google.com ([2002:a17:90a:d313:b0:38d:efe5:1502])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4fc9:b0:38e:740f:9764
 with SMTP id 98e67ed59e1d1-3903c5f6477mr18528170a91.18.1786052782928; Thu, 06
 Aug 2026 14:46:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  6 Aug 2026 14:46:18 -0700
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260806214618.82180-1-seanjc@google.com>
Subject: [PATCH] KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's requests
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Use kvm_test_request() instead of kvm_check_request() when querying
KVM_REQ_VM_DEAD, i.e. don't clear KVM_REQ_VM_DEAD, as the entire purpose
of KVM_REQ_VM_DEAD is to prevent the vCPU from enterring the guest ever
again, even if userspace insists on redoing KVM_RUN.

Ensuring KVM_REQ_VM_DEAD is never cleared will allow relaxing KVM's rule
that ioctls can't be invoked on dead VMs, to only disallow ioctls if the
VM is bugged, i.e. if KVM hit a KVM_BUG_ON().

Opportunistically add compile-time assertions to guard against clearing
KVM_REQ_VM_DEAD through the standard APIs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---

This was previously posted as part of a series to add an ioctl to allow
userspace to terminate a TDX VM.  I'm posting it separately because it fixes
a very real flaw, although the flaw is probably benign in practice?  I don't
want to find out though, i.e. I don't want to wait to get this merged.

This came back on my radar when fixing a bug in x86's pre-fault code, and
looking at that code made it pretty clear that clearing KVM_REQ_VM_DEAD could
make a bad situation worse.

 arch/arm64/kvm/arm.c     | 2 +-
 arch/x86/kvm/mmu/mmu.c   | 2 +-
 arch/x86/kvm/vmx/tdx.c   | 2 +-
 arch/x86/kvm/x86.c       | 2 +-
 include/linux/kvm_host.h | 9 +++++++--
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..a56ead423897 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1108,7 +1108,7 @@ static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
 static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
-		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
+		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
 			return -EIO;
 
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c519e8e8d646..ec34caa06b6a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5033,7 +5033,7 @@ static int kvm_tdp_page_prefault(struct kvm_vcpu *vcpu, gpa_t gpa,
 		if (signal_pending(current))
 			return -EINTR;
 
-		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
+		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
 			return -EIO;
 
 		cond_resched();
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b272c20586a7..6c842e9191a5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1995,7 +1995,7 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_has_events(vcpu) || signal_pending(current))
 			break;
 
-		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
+		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu)) {
 			ret = -EIO;
 			break;
 		}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d94b59140c45..0af4b4a95c2d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8060,7 +8060,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	bool req_immediate_exit = false;
 
 	if (kvm_request_pending(vcpu)) {
-		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
+		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu)) {
 			r = -EIO;
 			goto out;
 		}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 03bfc92864b6..cf7fe835c4ad 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2324,13 +2324,18 @@ static inline bool kvm_test_request(int req, struct kvm_vcpu *vcpu)
 	return test_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->requests);
 }
 
-static inline void kvm_clear_request(int req, struct kvm_vcpu *vcpu)
+static __always_inline void kvm_clear_request(int req, struct kvm_vcpu *vcpu)
 {
+	BUILD_BUG_ON(req == KVM_REQ_VM_DEAD);
+
 	clear_bit(req & KVM_REQUEST_MASK, (void *)&vcpu->requests);
 }
 
-static inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
+static __always_inline bool kvm_check_request(int req, struct kvm_vcpu *vcpu)
 {
+	/* Once a VM is dead, it needs to stay dead. */
+	BUILD_BUG_ON(req == KVM_REQ_VM_DEAD);
+
 	if (kvm_test_request(req, vcpu)) {
 		kvm_clear_request(req, vcpu);
 

base-commit: a806d364ef288a6443a1337820ea8410a7ccc6b3
-- 
2.55.0.679.g6767b8d81c-goog

