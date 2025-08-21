Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84382EBDE2
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810066; cv=none; b=utdBvqtFlw8arwqeNLp5pmhBIRRoOzj7Kurb45IKu+HDfdeoj3aT7n9edkk+8sZdsWL7+Wx984lWwvn+NJTagwT+PmcLQQUyYhWSdypliED7VW80tsYGdDMuEenhiCQ6CZEipwPi5Drqx0OeQ4citAZ/Den73pc0PwaQefv4EMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810066; c=relaxed/simple;
	bh=+61MIfhB12OoqxvOVjd5E5G1e4moY0EeyCZxMuVXI2c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lWyvp27+yevm0ndn/TPSyyld9z/3dpT3I63pkyIpT8y42mMG6d4qUgVWKuZ6N39GEJaRQ5JreGjZNP3KkwSxTSAgX/3oTllzM3KKH2Rnw03poBw97A6iR2ICPqZr8Xy4wA121veIyWJUFsvH61/FqhtDjH1XjVJPPGKJxqA7fDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FcNY2DFD; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FcNY2DFD"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-323266b700cso2886043a91.0
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810063; x=1756414863; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AynODOx7TIbccej4ZjLdZ9RTKEuSncfsehCPn6XLS1g=;
        b=FcNY2DFDtEbv5uiHlEviqGNOtwOVPkqMlrqEjAZ0sC3HASsWafO/JlN9kqWVsRVnqv
         7TmoZDfJnzM+3O7+RBih17ZEnitEv7VZo7Y450S0F+xCK/q9zD9C++tFHcbxkfmKAfZc
         RVciaCm3Zmtxtcno0tHVa9ht5GwxvoMthqXkCyoiP9ZV5+8OIJPawhKUv+P0w4F0wciW
         N1OrBmAJycjE66xIry2Cz/z4TsbQUywHixSVsKTB4a76gdquYkRwC3IuioR9byw4eZ8E
         C4RSrTpERmuvZQBWNz8WvOKeEQ3EgkmhaOKy2vlFWbu2QRWN1HckgJ4Hq2lUgWPyjw2P
         zUUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810063; x=1756414863;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AynODOx7TIbccej4ZjLdZ9RTKEuSncfsehCPn6XLS1g=;
        b=Y1MF3rMsya2AE/5td3pMC94ba9cd4oYIf2q5Eap1ZlJUb2xLWVT8XOzy+Yv6Kt+g8s
         u4krL0T3Im8nSHilE/1KzS20GrqE4cXLugJPOIkRwHTl4LQG/ysp1QxaQitsqKBdOnDU
         mKAL+ZgyvTEvmVm//2gTTqcsTzCzJ5kZ09DhxSxjSFGGek6f3ZmM/3sDd7nEDCuxfego
         E7XyCBg0EjLbeMqxiiekSUMmenE4gc7tV9QBzHQcdZX2sRh8uTuh0GgNEnU1Ojn7rzpL
         F2gbIsC/qAvdsYqN+G8siaDCd+P5m8ujYoN2PrM6N9qUJ0rO6LGio9R8r3zQYdMoBj02
         87tA==
X-Forwarded-Encrypted: i=1; AJvYcCXtf3sxp2k2qZccjPIjyAUNeH1RYIXJY/TxN+o5iljH4lt1tDd6T7Q1Q3OAwDx59p6laGjNVws=@lists.linux.dev
X-Gm-Message-State: AOJu0YxCLwpftEQx4mNzmMk7yFUzKbVfGZedE4Pbur7vywpWnXkpPqGc
	brh2oaty2yADxPMep6vX0yr/n46xsiUIMZDCb29cswBihI86Je3B62A+zPnCccP4C3jfpDYE7Ew
	i7oyPPg==
X-Google-Smtp-Source: AGHT+IEVYwl5YEkw1vqENiDixKFNtOSSF5og6sdGONTLhDTmarsazTWsy/GXacXJvdeMD+BKnVg4vh8e0tk=
X-Received: from pjbsd14.prod.google.com ([2002:a17:90b:514e:b0:321:78e7:57fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b4c:b0:31e:d929:5ca5
 with SMTP id 98e67ed59e1d1-32515e2230emr1041388a91.1.1755810063041; Thu, 21
 Aug 2025 14:01:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:36 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-11-seanjc@google.com>
Subject: [RFC PATCH 10/16] KVM: arm64: Drop local vfio_allow_any_uc, use
 vm_flags snapshot
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop user_mem_abort()'s local vfio_allow_any_uc variable and instead use
the vm_flags snapshot.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/mmu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 10c73494d505..e1375296940b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1476,7 +1476,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	int ret = 0;
 	bool writable, force_pte = false;
 	bool mte_allowed, is_vma_cacheable;
-	bool s2_force_noncacheable = false, vfio_allow_any_uc = false;
+	bool s2_force_noncacheable = false;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
 	struct vm_area_struct *vma;
@@ -1608,8 +1608,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	fault->gfn = fault->ipa >> PAGE_SHIFT;
 	mte_allowed = kvm_vma_mte_allowed(vma);
 
-	vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
-
 	vm_flags = vma->vm_flags;
 
 	is_vma_cacheable = kvm_vma_is_cacheable(vma);
@@ -1741,7 +1739,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
 	if (s2_force_noncacheable) {
-		if (vfio_allow_any_uc)
+		if (vm_flags & VM_ALLOW_ANY_UNCACHED)
 			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
 			prot |= KVM_PGTABLE_PROT_DEVICE;
-- 
2.51.0.261.g7ce5a0a67e-goog

