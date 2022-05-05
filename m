Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C7AC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  5 May 2022 23:33:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE6A04B27F;
	Thu,  5 May 2022 19:33:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OGHTUKPoweEO; Thu,  5 May 2022 19:33:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CB424B230;
	Thu,  5 May 2022 19:33:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED70C49EB1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 19:33:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uyEm+QWD71c7 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2022 19:33:05 -0400 (EDT)
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com
 [209.85.214.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F9F349E44
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 19:33:05 -0400 (EDT)
Received: by mail-pl1-f182.google.com with SMTP id c9so5105132plh.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 May 2022 16:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=1Rru4EvM+XN9fli3rN5SHjuT5guNThoc36o1YydC9Qw=;
 b=an3wpmzQDMQBkQXqJoOqd+t3py56kyzvH6SCFffNtjcFenp5AuLHGLxJnfURCGI1+n
 uE9X/0H1kj/PRv/Zo127tJTpx031+RG5G+7idyXKOfNS3/LCuHdR9TUGlCDOd2fTX0GR
 uSnL5URALBUeYYhd47aPiBvJwAR9rvRdJWWN+pTORArwRgWnJN74zQM9jtsAVEWrk3tW
 jHehIdevXXhdPspJtGMRa5MhmK8Mn0J0TAT99JodxRypVQgnwiCjbvlZimpERRb4P9ea
 Rl7p+mvefRVHBNMXq2ADk/r/yGexaUrT12X7Oh2dzI6i8jRl2bzD5sU6OP8DMLHciHaO
 UDpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=1Rru4EvM+XN9fli3rN5SHjuT5guNThoc36o1YydC9Qw=;
 b=ATYlV7QAPyZol2qRQmUG8HHlmlEURaJJyziR6Ksj7TQBbG3UgJBf1AAWDIhPth2FMr
 uYB4ISC4D3LZK7KHvUmIUYHbSMQg6EG95WMQDi/KM/aZxnh4p1gWyfM9zn5c1Tzip0DC
 1YOiXfnmFfiOEyFdWmBjLGb49Gy3Ln2+L8bmbcWlST78b1nwIAAOemAMHdLeq9oFu3hC
 QaIXBeWIdANbg7q0KuPr8/NFuN79oYLjiAmWZUmwHM5v5GfxAep36JGW0Nac43lfXXrI
 Fl8u01COD53qzEYLoadDdhn09HnHhzoTID9yHSqU3g41shQaQHoHw3AvoZjfIsaTcy9Q
 W4oA==
X-Gm-Message-State: AOAM531nnJaMX9G7/HnGVpv3BB2UHqfA+qFQN0A/92fi+BQV4Gi1LyQK
 hQvEJBaOmAQCCpVBx1WVggbZbQ==
X-Google-Smtp-Source: ABdhPJz15lbM0bMDWimOz5AKmg1zx67gRQwuIdcs+TBruzTwqhiF+UyOijI/QMMMoovS4rb8KIF7Lg==
X-Received: by 2002:a17:902:b704:b0:156:624:934b with SMTP id
 d4-20020a170902b70400b001560624934bmr671141pls.116.1651793584418; 
 Thu, 05 May 2022 16:33:04 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 w131-20020a627b89000000b0050dc762815fsm1931440pfc.57.2022.05.05.16.33.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 05 May 2022 16:33:04 -0700 (PDT)
Date: Thu, 5 May 2022 23:33:00 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 11/20] KVM: x86/mmu: Allow for NULL vcpu pointer in
 __kvm_mmu_get_shadow_page()
Message-ID: <YnRerE5+FpwkUdQE@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-12-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-12-dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Fri, Apr 22, 2022, David Matlack wrote:
> Allow the vcpu pointer in __kvm_mmu_get_shadow_page() to be NULL. Rename
> it to vcpu_or_null to prevent future commits from accidentally taking
> dependency on it without first considering the NULL case.
> 
> The vcpu pointer is only used for syncing indirect shadow pages in
> kvm_mmu_find_shadow_page(). A vcpu pointer it not required for
> correctness since unsync pages can simply be zapped. But this should
> never occur in practice, since the only use-case for passing a NULL vCPU
> pointer is eager page splitting which will only request direct shadow
> pages (which can never be unsync).
> 
> Even though __kvm_mmu_get_shadow_page() can gracefully handle a NULL
> vcpu, add a WARN() that will fire if __kvm_mmu_get_shadow_page() is ever
> called to get an indirect shadow page with a NULL vCPU pointer, since
> zapping unsync SPs is a performance overhead that should be considered.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 40 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 32 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 04029c01aebd..21407bd4435a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1845,16 +1845,27 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
>  	  &(_kvm)->arch.mmu_page_hash[kvm_page_table_hashfn(_gfn)])	\
>  		if ((_sp)->gfn != (_gfn) || (_sp)->role.direct) {} else
>  
> -static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> -			 struct list_head *invalid_list)
> +static int __kvm_sync_page(struct kvm *kvm, struct kvm_vcpu *vcpu_or_null,
> +			   struct kvm_mmu_page *sp,
> +			   struct list_head *invalid_list)
>  {
> -	int ret = vcpu->arch.mmu->sync_page(vcpu, sp);
> +	int ret = -1;
> +
> +	if (vcpu_or_null)

This should never happen.  I like the idea of warning early, but I really don't
like that the WARN is far removed from the code that actually depends on @vcpu
being non-NULL. Case in point, KVM should have bailed on the WARN and never
reached this point.  And the inner __kvm_sync_page() is completely unnecessary.

I also don't love the vcpu_or_null terminology; I get the intent, but it doesn't
really help because understand why/when it's NULL.

I played around with casting, e.g. to/from an unsigned long or void *, to prevent
usage, but that doesn't work very well because 'unsigned long' ends up being
awkward/confusing, and 'void *' is easily lost on a function call.  And both
lose type safety :-(

All in all, I think I'd prefer this patch to simply be a KVM_BUG_ON() if
kvm_mmu_find_shadow_page() encounters an unsync page.  Less churn, and IMO there's
no real loss in robustness, e.g. we'd really have to screw up code review and
testing to introduce a null vCPU pointer dereference in this code.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3d102522804a..5aed9265f592 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2041,6 +2041,13 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
                        goto out;

                if (sp->unsync) {
+                       /*
+                        * Getting indirect shadow pages without a vCPU pointer
+                        * is not supported, i.e. this should never happen.
+                        */
+                       if (KVM_BUG_ON(!vcpu, kvm))
+                               break;
+
                        /*
                         * The page is good, but is stale.  kvm_sync_page does
                         * get the latest guest state, but (unlike mmu_unsync_children)

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
