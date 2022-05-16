Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D007C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 14:49:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B64A14B287;
	Mon, 16 May 2022 10:49:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yVQoKQ7ZkqKZ; Mon, 16 May 2022 10:49:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A2524B27C;
	Mon, 16 May 2022 10:49:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EDC64B276
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 10:49:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kd3CZDMP9Kif for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2022 10:49:25 -0400 (EDT)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com
 [209.85.216.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D0754B275
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 10:49:25 -0400 (EDT)
Received: by mail-pj1-f43.google.com with SMTP id ev18so4044526pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2022 07:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=JQA1CAM9EcNlBvTilQjyrtgzNtDUyC6fSOZfEYDNvqw=;
 b=Ofiyf21IY/JWacyt2sm4b5JqGuuC4xCXQfaviI0AIJLTpd/Oflx9mf4AgU0jPq/he9
 P8q38uagOiSBPUbhhVCO3xI8wFi0ws+7XMFVjOWAvczYAZ33OeUVSPMA8IVoEmfTxavH
 +Jh+8dMsZkVLYRmnNIWBfjKQFw8nAEdqSzfrse3j8qFBus5uBYj6xSSRx79YbRUTr+10
 8B536NcDWQLKPoDEy+LDdo2lk4qv4nAC0OGBKT90rawf8LvkqU6R1Si7o1p8XjJnsjqN
 GT9r+zrdlv0EmZI6VxVd3V7k7fmzQe0uepCQluN6+sScjYoFjch6hclfAYUVyNMTtadf
 qwxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=JQA1CAM9EcNlBvTilQjyrtgzNtDUyC6fSOZfEYDNvqw=;
 b=OCgDqqL6RQOY4J4gNpNYR5vjby3xUrxqBRt7DTf7M5VHh7owNAWY4j+V5nL4btPh3/
 xDWuvh8YO9hNo8W43SLqNCuGDz8QFRISR+xvmKzw8Y938cJxqTojuxVubtZNSj+/ffRK
 1seqnQUWuhoOOWhDQznZc31oAi31UJ0vGtHSLdZv0DxMrQTuCBjW5uzcZTjFT2UqGXDd
 sBkdfuQHR+ArVpMrIlvP+/ZSwne+8zPhxBzg2DHQSZPIA2VYBoqozOUzh9Yx7Z0/azmT
 9aA6k/zmYzrzBdHM8/6t+xnct1sKC04zi3A6VU0LsSJSDigJ9W8ZtFRncZwBifSxCT0M
 lHjQ==
X-Gm-Message-State: AOAM532IrNQ+acObQ0coRxQwDmfS/b7OlYFXtraidkCodWNTVQ+AVVYf
 E1gqgT4GjhhVa7mVFS78/qTXvQ==
X-Google-Smtp-Source: ABdhPJzWW2D4IvLQy4A8frhcp8tSvPwynf61rQPofCvBwMRNuG9eI1HYcmZ1MomMsjCVF1GmR1hHDA==
X-Received: by 2002:a17:903:2d0:b0:14d:8a8d:cb1 with SMTP id
 s16-20020a17090302d000b0014d8a8d0cb1mr17896959plk.50.1652712563657; 
 Mon, 16 May 2022 07:49:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157]) by smtp.gmail.com with ESMTPSA id
 jc13-20020a17090325cd00b001618b4d86b3sm1609217plb.180.2022.05.16.07.49.23
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 16 May 2022 07:49:23 -0700 (PDT)
Date: Mon, 16 May 2022 14:49:19 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v5 20/21] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
Message-ID: <YoJkb7oMEz0v1dnp@google.com>
References: <20220513202819.829591-1-dmatlack@google.com>
 <20220513202819.829591-21-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220513202819.829591-21-dmatlack@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
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

On Fri, May 13, 2022, David Matlack wrote:
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 53ae2c0640bc..2f2ef6b60ff4 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -764,7 +764,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  {
>  	phys_addr_t addr;
>  	int ret = 0;
> -	struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> +	struct kvm_mmu_memory_cache cache = {
> +		.capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> +		.gfp_zero = __GFP_ZERO,

I dislike requiring all users to specificy the capacity.  It largely defeats the
purpose of KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, and bleeds details into code that
really doesn't care all that much about the details.

Rather than force the capacity to be set before topup, what about adding a custom
capacity topup helper?  That allows keeping a default capacity, better documents
the caches that are special, and provides an opportunity to sanity check that the
capacity isn't incorrectly changed by the user.  

And then I believe this code becomes:

	struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };

E.g. (completely untested)

static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc,
					int capacity, int min)
{
	gfp_t gfp = GFP_KERNEL_ACCOUNT;
	void *obj;

	if (mc->nobjs >= min)
		return 0;

	if (likely(mc->capacity)) {
		if (WARN_ON_ONCE(mc->capacity != capacity || !mc->objects))
			return -EIO;
	} else {
		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
		if (!mc->objects)
			return -ENOMEM;

		mc->capacity = capacity;
	}

	while (mc->nobjs < mc->capacity) {
		obj = mmu_memory_cache_alloc_obj(mc, gfp);
		if (!obj)
			return mc->nobjs >= min ? 0 : -ENOMEM;
		mc->objects[mc->nobjs++] = obj;
	}
	return 0;
}

int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
{
	const int capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;

	return __kvm_mmu_topup_memory_cache(mc, capacity, min);
}

int kvm_mmu_topup_custom_memory_cache(struct kvm_mmu_memory_cache *mc,
				      int capacity)
{
	return __kvm_mmu_topup_memory_cache(mc, capacity, capacity);
}

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
