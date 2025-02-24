Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1113020E01C
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 23:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740441356; cv=none; b=UGjg3ny46d773bljTQ7mcKUOOWI/EeIw5OSgq8I2yTIoMnl6zpUZwlRHcleuuePjABKj3Q4E7P21GwhRbY5m/A50dVCmI9WLnPRoxUgrZSkcjW/vZclVPqY4vTdTgnnhXxhFEK49EiKxDGZ0UKo+fSOsGkAYNPfIPukSoG18gjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740441356; c=relaxed/simple;
	bh=ACqJB2KXicxvfLHjzx6leY0tlI8JuUGirNReQgQidhg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SCSBjktyp2kTkJeLHmKc9xiK7+BLfB8MotOEInX5PoPcY0y5eLi5iPoZtOUqoWXKqBdny2cxgeGRFBKpq/aE0kxRVy5sWmGsk1gmL51VcCccsATnaR6v6nXRymEpm0oil7NJv8G33x0cinaWJJKIkiJItv7RqFG9xMBRnSxNGtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z1Ceo/sn; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z1Ceo/sn"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc4dc34291so9596097a91.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 15:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740441354; x=1741046154; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gY5t+lA+xCJMUFRKRfvQdv+q8kOSitFuxy9rKD2JbVY=;
        b=z1Ceo/snKGTpVCky6Ciy0LY4rCce6FFTizhdqaqHY8Z8obciJg9rXfQXPlJmMLBrf5
         tYnAHw7hMzGisjplZflI/rT1P42VrNqV+OFQt9EZuy/MifXYHU/8eYMXMdix2hiDQneB
         XMPwfk2FhsQ1fgVVY42Y9dtCmA0k50QUuhWvkeuy++PCZHsGnYw2Fcf4aZ8m5p4/mvbT
         Ccmcco93o8441S+g7XsmpePFmmEZW2nn18J3uN9kmAiNYSzB1EjOmtG86WeCWBJyRZCx
         uvghOR3aI1vUkpW2rI6uZipSvjgVbOnmYCA01wMYfbUYsS3gGgLJMaFmgfvirrTPsHxR
         YXSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740441354; x=1741046154;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gY5t+lA+xCJMUFRKRfvQdv+q8kOSitFuxy9rKD2JbVY=;
        b=Wv19/ViADx+3RtybQghxIZX9azv3u3r7hKtIVORKtA/3xcjkiZiLKtKngJyJKNviKr
         8qZhhia72U68eF18Wgdtve7/16cMBoVywF7i5XtWsjTnPtGqD3q9Orxq3G+DzP3tGRJT
         YJgPq5B+3UfKO86kciiXzwiUlhk4yQCOnCMkhmcjW7OILcd+NidtqtINnYVByWyZJnsr
         sQYBpBh69Mhqs0EHl6eGfrVyLwEszP9NWwhIQ7Fer5ugif9yh/hTLfLqE+kltnQH7UFV
         6gsV3EXGNRgWEMLt7TUoenUu9zbKppZLnXbNcSgrGa1/Kb6VM9XcUa8wZyYiPZk9FYYQ
         jYXA==
X-Forwarded-Encrypted: i=1; AJvYcCVPHf6/hnDSnpiyDScaoiPrR1rYyPnJWrfUW0IUTldKqUOCJlTnbzE7b8yRbChnqbuuHp2J4Gc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6ynoUy0aIZh5qSqqd8lavl8+4QuEh03SJ1vV7+yvrq/05CwgW
	HgcJ7gu9/t+0vszIosk73DRn6mNWZ+zkzj140faytcxmI/ZvcyJvBA3aaxOUgvGrshXPQshfDBz
	p5w==
X-Google-Smtp-Source: AGHT+IG7Oktdw38sVEoOW4Tvh6JQ9psvOsFz+B6sIudCx6XDJiW/lrg1jUS4SL5IEqUCfnyPdnnvHXtLVtU=
X-Received: from pfbgc10.prod.google.com ([2002:a05:6a00:62ca:b0:730:7648:7a74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:6a27:b0:1ee:d6a7:e332
 with SMTP id adf61e73a8af0-1eef3d5aabamr27634032637.26.1740441354199; Mon, 24
 Feb 2025 15:55:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 15:55:40 -0800
In-Reply-To: <20250224235542.2562848-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250224235542.2562848-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224235542.2562848-6-seanjc@google.com>
Subject: [PATCH 5/7] KVM: x86: Unload MMUs during vCPU destruction, not before
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Aaron Lewis <aaronlewis@google.com>, Jim Mattson <jmattson@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"

When destroying a VM, unload a vCPU's MMUs as part of normal vCPU freeing,
instead of as a separate prepratory action.  Unloading MMUs ahead of time
is a holdover from commit 7b53aa565084 ("KVM: Fix vcpu freeing for guest
smp"), which "fixed" a rather egregious flaw where KVM would attempt to
free *all* MMU pages when destroying a vCPU.

At the time, KVM would spin on all MMU pages in a VM when free a single
vCPU, and so would hang due to the way KVM pins and zaps root pages
(roots are invalidated but not freed if they are pinned by a vCPU).

  static void free_mmu_pages(struct kvm_vcpu *vcpu)
  {
        struct kvm_mmu_page *page;

        while (!list_empty(&vcpu->kvm->active_mmu_pages)) {
                page = container_of(vcpu->kvm->active_mmu_pages.next,
                                    struct kvm_mmu_page, link);
                kvm_mmu_zap_page(vcpu->kvm, page);
        }
        free_page((unsigned long)vcpu->mmu.pae_root);
  }

Now that KVM doesn't try to free all MMU pages when destroying a single
vCPU, there's no need to unpin roots prior to destroying a vCPU.

Note!  While KVM mostly destroys all MMUs before calling
kvm_arch_destroy_vm() (see commit f00be0cae4e6 ("KVM: MMU: do not free
active mmu pages in free_mmu_pages()")), unpinning MMU roots during vCPU
destruction will unfortunately trigger remote TLB flushes, i.e. will try
to send requests to all vCPUs.

Happily, thanks to commit 27592ae8dbe4 ("KVM: Move wiping of the kvm->vcpus
array to common code"), that's a non-issue as freed vCPUs are naturally
skipped by xa_for_each_range(), i.e. by kvm_for_each_vcpu().  Prior to that
commit, KVM x86 rather stupidly freed vCPUs one-by-one, and _then_
nullified them, one-by-one.  I.e. triggering a VM-wide request would hit a
use-after-free.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9978ed4c0917..a61dbd1f0d01 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12374,6 +12374,9 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
+	kvm_clear_async_pf_completion_queue(vcpu);
+	kvm_mmu_unload(vcpu);
+
 	kvmclock_reset(vcpu);
 
 	kvm_x86_call(vcpu_free)(vcpu);
@@ -12767,17 +12770,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	return ret;
 }
 
-static void kvm_unload_vcpu_mmus(struct kvm *kvm)
-{
-	unsigned long i;
-	struct kvm_vcpu *vcpu;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		kvm_clear_async_pf_completion_queue(vcpu);
-		kvm_mmu_unload(vcpu);
-	}
-}
-
 void kvm_arch_sync_events(struct kvm *kvm)
 {
 	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
@@ -12882,7 +12874,6 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
 		mutex_unlock(&kvm->slots_lock);
 	}
-	kvm_unload_vcpu_mmus(kvm);
 	kvm_destroy_vcpus(kvm);
 	kvm_x86_call(vm_destroy)(kvm);
 	kvm_free_msr_filter(srcu_dereference_check(kvm->arch.msr_filter, &kvm->srcu, 1));
-- 
2.48.1.658.g4767266eb4-goog

