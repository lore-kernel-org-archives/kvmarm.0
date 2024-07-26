Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE169181B85
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038042; cv=none; b=fB1n4Lf34I0QfdFESU/9atDj7D/X6FGZUdcvOBaMTp7GxAB7qQV5yqHcOK39ZRfj+dpaCf/rv6mGKNEiQw+aNe2LaxhVxtZQbiSa7Lp4o2RyAj07qeCRYS1JzyWZZXaFLMOEG06NgyUQ2Yvq44gPEv4V4tUH7RvLLQXcfuZztMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038042; c=relaxed/simple;
	bh=I21AIIPQRJE/LHqjT9YPoKMi3QRQyqy6GfrC1Ir9UhI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G+t/Lu3enQ6pBqTDcllQgl9mNwOKA3VSUfIna1DuuQOQKQG+XvYP2UGfG6Q7q66esOraxIfm5Q089/zl5ymiD89n2qXtrFnfjfdk/EBBSuC2wf9pEiYMd7MoNfKlVNZq3xdyy+8mjYPpbksGQuRPiHrx5fFV1+cuECgoPpEu3Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DIY3F3tj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DIY3F3tj"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1fc52d3c76eso12298935ad.3
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038040; x=1722642840; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=kjY6k542G0oo6Yjo2zUiSEPku2YJftlYNe05DeRMCZs=;
        b=DIY3F3tjiokW1CPpvKLrQbI0ZQIxDbsGOYXCDVsWEnWZ0K3kcuqke2KULBv0f2RsFU
         CSEh/krFh49lQ4oad5PwiavhBv+w0OANk66OasFqet2LTl40XbGogR13bmrrZhxS8Fm3
         NY8v/WKXv/aF1h32WzumxjxuPUqBBqb7Jsvjuuk4mlB1saknkh+4rOdTdlloOdB6+eqe
         ZEz8e0JFOAiAZu863zzmsYi8s8AfZBq2/I4/OXeOgDXek/Kh/1CWdq/w1gkQjXxpfJmN
         LCnxSiOTheK9b7PoZLfohvONV5pVPinqFTDVC2v2mYsJTOIJ5U4WySAktgmHL/KEWY98
         ULAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038040; x=1722642840;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kjY6k542G0oo6Yjo2zUiSEPku2YJftlYNe05DeRMCZs=;
        b=v4RqM+nYSeaqXY0vI5G0y5Du9tbLgcnpurEFc/OATo2iL/NBECyq8v8czh+UqVM+/x
         GDa0NbnMeahxoZlmpE6UnoZJgVAel59bdmtSxLTh9wh6nmkgU+WfcT+Whmv/4Wb7E2Fe
         FabBxN7GKWspjGknidkyLgqeEWotXK573ZlK/CRtAGr9Fw6zs9YL1w8RFYxMnXQAOJE4
         WJKBnZ1ocJ0d9uVotDH74x1uY7fuk27A4Se3kuYm6LLAYzNS1bjEvI3e+BoOPAkcP0WG
         Cc74o7/FYQ33KH15jsV5Nq+OawHwKLG45OX11N66GR8tvS9R7zA3x0WTc34Tbjo3XYpP
         FeaA==
X-Forwarded-Encrypted: i=1; AJvYcCWp5tKUQfivvNa+mmOT/zg+STFGmi1JQqTLdkmgCinRHeSrS1UmebK2RLdfCUYl4Wf8Bc1vdZMMSCaQnIeydwZhB5FOoDFd
X-Gm-Message-State: AOJu0YwNKTdr7wJw7ZlATb647AieHU6xGHAo/OGn/67sOlX1R25Sggdc
	rznQ4IoCg3ToqSVOa4eqWPoEAZAp2kumN9nrg+8kbUp0I3Lgc8Vtg2lZgtHKicH5BNLmE43uEPs
	4yw==
X-Google-Smtp-Source: AGHT+IHzv0Ay1s7/D5RlCraUOAPppGpx+9DOe5Wc2TnAqa2oJae5LaRq2mY8TBHhwH7zU/okRdoTzatzS5o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f60c:b0:1f8:6c64:3575 with SMTP id
 d9443c01a7336-1ff046dcdffmr290425ad.0.1722038040140; Fri, 26 Jul 2024
 16:54:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:49 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-41-seanjc@google.com>
Subject: [PATCH v12 40/84] KVM: x86/mmu: Add helper to "finish" handling a
 guest page fault
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Add a helper to finish/complete the handling of a guest page, e.g. to
mark the pages accessed and put any held references.  In the near
future, this will allow improving the logic without having to copy+paste
changes into all page fault paths.  And in the less near future, will
allow sharing the "finish" API across all architectures.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 12 +++++++++---
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e76f64f55c4a..1cdd67707461 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4311,6 +4311,12 @@ static u8 kvm_max_private_mapping_level(struct kvm *kvm, kvm_pfn_t pfn,
 	return req_max_level;
 }
 
+static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
+				      struct kvm_page_fault *fault, int r)
+{
+	kvm_release_pfn_clean(fault->pfn);
+}
+
 static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 				       struct kvm_page_fault *fault)
 {
@@ -4476,7 +4482,7 @@ static int kvm_mmu_faultin_pfn(struct kvm_vcpu *vcpu,
 	 * mmu_lock is acquired.
 	 */
 	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, fault->mmu_seq, fault->gfn)) {
-		kvm_release_pfn_clean(fault->pfn);
+		kvm_mmu_finish_page_fault(vcpu, fault, RET_PF_RETRY);
 		return RET_PF_RETRY;
 	}
 
@@ -4552,8 +4558,8 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = direct_map(vcpu, fault);
 
 out_unlock:
+	kvm_mmu_finish_page_fault(vcpu, fault, r);
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 
@@ -4641,8 +4647,8 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 	r = kvm_tdp_mmu_map(vcpu, fault);
 
 out_unlock:
+	kvm_mmu_finish_page_fault(vcpu, fault, r);
 	read_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 #endif
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e1c2f098d9d5..b6897916c76b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -835,8 +835,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	r = FNAME(fetch)(vcpu, fault, &walker);
 
 out_unlock:
+	kvm_mmu_finish_page_fault(vcpu, fault, r);
 	write_unlock(&vcpu->kvm->mmu_lock);
-	kvm_release_pfn_clean(fault->pfn);
 	return r;
 }
 
-- 
2.46.0.rc1.232.g9752f9e123-goog

