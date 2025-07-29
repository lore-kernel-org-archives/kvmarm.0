Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C23A2561A2
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 19:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753817630; cv=none; b=Xfdwwigr5tk7T0AZcZotKsIyo5wD3rs5LkTkvxUQ9Y4279C98eYOV055MN2A6YdYQTbIHYsg2YEGORTUVHuoCCqEmVtPbAGaAYwQErHqgjwk+AjXLo/92b8mcMqTYuBnuTtIknYJiqTSMLX5kQ60BrFk4RMRtY+bBpUsj9TFZKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753817630; c=relaxed/simple;
	bh=L+2rXbfnP5UHLH6J8UIbSI41QWjZkhL1tyySVaOK3Ek=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TFdPNAewlDoJtzCCEQOGkVTig1Nij9nqPcj5AoGfH0PBQDq1Yo+nOZd/blhTQc5nPdevtFRpLdrhbNksB8LDEnPzPg6fXciS3npS4M8hE7PUpZkqf6NBfIZvZa45BO+9Hwcdyx1cklKPAgu/+ue9Ro2GGR/SHD4kcB+ahvcmfWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K/fl3wBc; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K/fl3wBc"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b38d8ee46a5so189025a12.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 12:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753817628; x=1754422428; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=nK97iU3U8P3+PseGfflZpbVtPQJIWPB5aDB6ZsfbPi4=;
        b=K/fl3wBcVHq8JqxZ+vFhd2C9yUsRTq8kJRWSYhD5ByZeRHQtRSK1e2CcQ1wQmeywmh
         0mFCUk/w24iE2QqAJXHRS4cPbv1XAjccvOqrv2o9epPsDC9LjiUzAxGQ40KMuzXTBFwJ
         pAt7oSuRbE0pTqbsmoGM4Z5hgfXC3h+WGgvDSAMxKwBLYrQNPuOlRbaFgHCwwISzuEkJ
         CabbgqD5aEZUpovB9RpCzTNvjUVAM+DBmydzx5fgDZYX8oPPelkuSwSqF4en4JtZsB4d
         Fjx3sGBPBcncOS2fKkN80j9avpPX6/fWZ7clUVdUlxK8+zptuNqTf/lmKlTLGdCRwKD0
         e6pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753817628; x=1754422428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nK97iU3U8P3+PseGfflZpbVtPQJIWPB5aDB6ZsfbPi4=;
        b=tE1FafV49sl7PJQVk5aKyWYnyxvGeewW9gkwagAAltos7GxaWozHd2TeiDgYZ9ACM0
         GjlPnGiub827ZH56/EVOou53KLd1NGeZAS+kMXxGJVBkrlQ21v3yEkPv6gh9yX60DEqp
         6h/3nJx/nKdxUyak7Mw62sdT1RBzl99cTTK7dBXlLEnquupBkqiiRciQimzPtawDtrHX
         DzB8LI7SYETJt8W/11tRJjCwR+ScdQ4BpJ/8aDiXJ+iq0nrQrSK3JQEuABF7/e3Cvnd6
         5JKuA74UczVlWX5hA4rSmxMf12xP0A2ovKBOzB0ptrppWq3rKEKzr4i1jrnsQzbOYZvm
         lFRw==
X-Forwarded-Encrypted: i=1; AJvYcCUWpfJgEIs1loHVkv3XpM5bG1rWRH2dM5DDKJAGS0dDxuTWrrO07vMtsCiAGa1asnHDuyME1HM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yygu4r4eYyLIS6O6TaeiJHEnfQVlBTWRhdscHbocdY07rHPPzkM
	vQHOLTpSggG/eja2C+sMOukX7mrMWBFyHMv+XFhOz+atnhyhCfL3jtkMnhliXTc5I7ms5R9Iic/
	9IpZDvA==
X-Google-Smtp-Source: AGHT+IH4QbqgK/rjqLq7feIazM0nAtyNNAHCeByH/06YNfkwg9k7lbaoNX81vVU/L2yD55+9XIqmw/waN38=
X-Received: from pgac7.prod.google.com ([2002:a05:6a02:2947:b0:b36:36f4:9862])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:914f:b0:23d:659c:aadd
 with SMTP id adf61e73a8af0-23dadeb68c0mr7268679637.22.1753817628625; Tue, 29
 Jul 2025 12:33:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 12:33:36 -0700
In-Reply-To: <20250729193341.621487-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250729193341.621487-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729193341.621487-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: Never clear KVM_REQ_VM_DEAD from a vCPU's requests
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Nikolay Borisov <nik.borisov@suse.com>
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
 arch/arm64/kvm/arm.c     | 2 +-
 arch/x86/kvm/mmu/mmu.c   | 2 +-
 arch/x86/kvm/vmx/tdx.c   | 2 +-
 arch/x86/kvm/x86.c       | 2 +-
 include/linux/kvm_host.h | 9 +++++++--
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f946926716b0..2fdc48c0fc4d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1013,7 +1013,7 @@ static int kvm_vcpu_suspend(struct kvm_vcpu *vcpu)
 static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
 	if (kvm_request_pending(vcpu)) {
-		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
+		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
 			return -EIO;
 
 		if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6e838cb6c9e1..d09bd236a92d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4915,7 +4915,7 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
 		if (signal_pending(current))
 			return -EINTR;
 
-		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
+		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
 			return -EIO;
 
 		cond_resched();
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66744f5768c8..3e0d4edee849 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2010,7 +2010,7 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 		if (kvm_vcpu_has_events(vcpu) || signal_pending(current))
 			break;
 
-		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
+		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu)) {
 			ret = -EIO;
 			break;
 		}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..1700df68f12a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10649,7 +10649,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	bool req_immediate_exit = false;
 
 	if (kvm_request_pending(vcpu)) {
-		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
+		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu)) {
 			r = -EIO;
 			goto out;
 		}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 15656b7fba6c..627054d27222 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2261,13 +2261,18 @@ static inline bool kvm_test_request(int req, struct kvm_vcpu *vcpu)
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
 
-- 
2.50.1.552.g942d659e1b-goog

