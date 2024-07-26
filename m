Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4F5183099
	for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 23:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722038056; cv=none; b=hsLK2nHH+ZT+9fydzs4X0iqNiaVTwbOTEHPnDqK3BPVkpHfMnTDvN37/wJd+sr5aYPLeIdq+P86N+6HlfPJEo9JC6A0/vrF54e7ZbnWkVDOUi+omTSM8sjhge+yTFJlOknBNUcUVb44Qv0avqOkd0Yhqm7pPHpogzNOAPe59Yjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722038056; c=relaxed/simple;
	bh=PYmFTsup/AEmfy/4jq9PM2uJzzhDaOGf5jqGf3bldb4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HCnoO0O6QezhjE6p8dVVJGrI/PQEda0eX6Xq18GZNP+dEkYvJtcxisy3Vjy1uHkyGBiJbyc/2i43jhLrb5TijdJlkoXGFck/l8AdrDaUG6qlSyYb3Mwb+LbavNNOsMq30jeHo4o9O5FFrS3MjATPdDeAu9rMqyVz+00+YiupBBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4MS1MK9q; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4MS1MK9q"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2cb5ba80e77so1680010a91.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Jul 2024 16:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722038053; x=1722642853; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IbuNIltU7tfSlkccHv78LPGh6NGiPV3XEW5ZkU/rXdY=;
        b=4MS1MK9q2siwTvwZLY05vAxHnmiiQ0ymQWbF7MykG3ZQ7jv+TAECh9JMnGIQDeIBrk
         A1lG+lqrgTmSk41zxwUYcU/u9mJSk0HaYY0GkawAVIcwYF4kaSfkWzFlVgr+yGOBISKt
         qf0d1mKVRn2Ai0TYP12ZJgYgyoJiZfiPBEOFXujfB8tTwlVaghywdE5y8ASVwfH6jUAi
         t63u0L824h+IwlNJkwEEZkvuiQ0MbbywozUucygc/wpQuwQDl8DlmZ85I68ALyiZcxhj
         fUGGs2HCNfnhhyOwApPnoaboU+jVA1kZD0MurOv/VA54GD45xgRaRxfdeEk/mTE11lxz
         r4hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722038053; x=1722642853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IbuNIltU7tfSlkccHv78LPGh6NGiPV3XEW5ZkU/rXdY=;
        b=LBZKrIdL/UnLxf9pZAMbqtIECoIrDCt8UPSncyGCqULiF1l1Ay9P4fu/1Kljk4ScHM
         wrM8H/Zed2+JTSiqSpyq8AeXes2zHvH5CZkd7KSDMii4juFbI+BpJ+h+5QJDPonhuqDj
         VSaFrJ5SZm1xjuCjEat/Vk61POIjJovP/AKyvyQui1pg6Pctt9/hhveHxtpsirqOZSzp
         3XwdLpkL2STbYjBxnS5kpiSf5gCjule3dZcTZvs9uX3lWRFyewP54hGJ+autvDeBbuaz
         EaOsnAXe8mVVt7w0gMw+RLwbMbhFnV9f4tbkxE7wQOyb3SKYRBX+H5IG3PU44Y6OowRR
         DKWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVH8c2lMYJLFbTYlXlVeIgFbJVumdu8CcAhZfwKLlKl8+mW372dHLSijk+q/P8v9IVogJzguG7MRmyDLTFW1a+g+GmCNJ+m
X-Gm-Message-State: AOJu0YylC+yS/yhJ/XCTloVNO4fM/ZaJBMu7yYzUJFWlEPZbMSwyAAL/
	wKEnRUKPV5rWaaSAygOn1V03Fcfs7sLqHgde6W1pPazlMIy1+In4cZCPkNbcvjmaBtH4L5eJsCG
	HGw==
X-Google-Smtp-Source: AGHT+IF1WA3mVZXk9S93pEq2eXLardKUPi+yfLeicmT6epShCKMtCcCE54tvymeWkFnvdj0Qbejb/rqSUKM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:41cc:b0:1fd:87a7:1445 with SMTP id
 d9443c01a7336-1ff0489344bmr935735ad.9.1722038053119; Fri, 26 Jul 2024
 16:54:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:55 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-47-seanjc@google.com>
Subject: [PATCH v12 46/84] KVM: x86/mmu: Put refcounted pages instead of
 blindly releasing pfns
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

Now that all x86 page fault paths precisely track refcounted pages, use
Use kvm_page_fault.refcounted_page to put references to struct page memory
when finishing page faults.  This is a baby step towards eliminating
kvm_pfn_to_refcounted_page().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 146e57c9c86d..3cdb1bd80823 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4326,6 +4326,9 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 	lockdep_assert_once(lockdep_is_held(&vcpu->kvm->mmu_lock) ||
 			    r == RET_PF_RETRY);
 
+	if (!fault->refcounted_page)
+		return;
+
 	/*
 	 * If the page that KVM got from the *primary MMU* is writable, and KVM
 	 * installed or reused a SPTE, mark the page/folio dirty.  Note, this
@@ -4337,9 +4340,9 @@ static void kvm_mmu_finish_page_fault(struct kvm_vcpu *vcpu,
 	 * folio dirty if KVM could locklessly make the SPTE writable.
 	 */
 	if (!fault->map_writable || r == RET_PF_RETRY)
-		kvm_release_pfn_clean(fault->pfn);
+		kvm_release_page_clean(fault->refcounted_page);
 	else
-		kvm_release_pfn_dirty(fault->pfn);
+		kvm_release_page_dirty(fault->refcounted_page);
 }
 
 static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
-- 
2.46.0.rc1.232.g9752f9e123-goog

