Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40315C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  5 May 2022 23:00:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CE4C4B215;
	Thu,  5 May 2022 19:00:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3vdlao15tFug; Thu,  5 May 2022 19:00:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62D344B1F0;
	Thu,  5 May 2022 19:00:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 524324B1F0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 19:00:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6BL6DoI9U-1H for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 May 2022 19:00:44 -0400 (EDT)
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com
 [209.85.215.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3DD4E4B1EF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 May 2022 19:00:44 -0400 (EDT)
Received: by mail-pg1-f172.google.com with SMTP id 7so4708882pga.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 May 2022 16:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=OynsI/Y1y6rsQh9WExR+1/Zkn9MMK8WgC1JkonenMkY=;
 b=czdbdSz4ZFvCh9CDIv//7vre9DD/9YuCdL7EH5JN3DK0rF1o5+bTGuSgXwOZeSrk+p
 p8f2JfvS0v+6umNaERHgOwIdoEi8v1/2zrslEUYWwlHeubYqiVmr34/AxEsei4oudhWF
 CJw1/UWxbSaDoiU0lYFK9W30KO/wNOo18gChC4qkaV1TP5t1Sj1gQwYTlFKXOJwlMxlq
 XeiXI6920NuTALp0ZQbe2zYhFBhwPP2emPNLXFFrtYyo4BIGE7RBJErDr0wdw4Tg7a0V
 li/5C0KssxCA+9aZc5pkAacKGyoxzspvkeX6qENNBTjpWd2qQDkGsVy52938gVfWzJSk
 QdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=OynsI/Y1y6rsQh9WExR+1/Zkn9MMK8WgC1JkonenMkY=;
 b=7aGj3ciwzAjHg3DMUKodtlYyfb0oioWd83IFFSasW+W44S8ts5+rUmO4g5SHC6KFF7
 2bmYyMXiy/59PwV8O+74KST8Rfg8F5BOWFWHHnafrVVRD+ha+69zr94RC3MRu4Z1CrHH
 XUVK0/bQAVaWILFrCSGtwy+PXy02cdhN0LA/upISmlrbDSiFx5l9ln6a30GCDgMwGVJ6
 lote1WSiVYV/VvijV/zc+YQFQd496Ilzg73g/XUE6Wqv84ms5cro6X0wwztyqT8mgCb7
 v7HDLteRNIHxCPpZZ/kMhhl+nXd/YF9wpwMOIIC7+73M0TKm5Y+y3ZE9XJS95I0zxRut
 i6nQ==
X-Gm-Message-State: AOAM530CptjBMr0Fi4KLAdGhstCAhZzNMY49/xmKMpOn8/vlVw4cdTYh
 UdhRykYsGzZ6Z2qeIJvZTKZ03Q==
X-Google-Smtp-Source: ABdhPJxDu0wALLZyxGIddDUnRgsXc2qv3Ld2ZmjdwFGFx/UOM+F3BAohwM2FdgVKnvaNd70HiCM4nw==
X-Received: by 2002:a63:6841:0:b0:3c1:a611:793e with SMTP id
 d62-20020a636841000000b003c1a611793emr308309pgc.249.1651791642951; 
 Thu, 05 May 2022 16:00:42 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 y18-20020a170902d65200b0015e8d4eb27fsm146862plh.201.2022.05.05.16.00.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 05 May 2022 16:00:42 -0700 (PDT)
Date: Thu, 5 May 2022 23:00:39 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v4 08/20] KVM: x86/mmu: Pass memory caches to allocate
 SPs separately
Message-ID: <YnRXFyTik32RIxNp@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-9-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-9-dmatlack@google.com>
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
> Refactor kvm_mmu_alloc_shadow_page() to receive the caches from which it
> will allocate the various pieces of memory for shadow pages as a
> parameter, rather than deriving them from the vcpu pointer. This will be
> useful in a future commit where shadow pages are allocated during VM
> ioctls for eager page splitting, and thus will use a different set of
> caches.
> 
> Preemptively pull the caches out all the way to
> kvm_mmu_get_shadow_page() since eager page splitting will not be calling
> kvm_mmu_alloc_shadow_page() directly.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

...

>  static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
> +						      struct shadow_page_caches *caches,

Definitely work doing the "kvm" capture in an earlier patch, and doing the s/vcpu/kvm
here, the diff on top is tiny.  The shortlog/changelog would need minor tweaks, but
that's not a big deal.

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index da1c3cf91778..15784bab985f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2084,13 +2084,12 @@ struct shadow_page_caches {
        struct kvm_mmu_memory_cache *gfn_array_cache;
 };

-static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
                                                      struct shadow_page_caches *caches,
                                                      gfn_t gfn,
                                                      struct hlist_head *sp_list,
                                                      union kvm_mmu_page_role role)
 {
-       struct kvm *kvm = vcpu->kvm;
        struct kvm_mmu_page *sp;

        sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
@@ -2133,7 +2132,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
        sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
        if (!sp) {
                created = true;
-               sp = kvm_mmu_alloc_shadow_page(vcpu, caches, gfn, sp_list, role);
+               sp = kvm_mmu_alloc_shadow_page(vcpu->kvm, caches, gfn, sp_list, role);
        }

        trace_kvm_mmu_get_page(sp, created);

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
