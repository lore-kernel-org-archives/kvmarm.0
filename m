Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF267C43334
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jun 2022 17:42:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 238644B35D;
	Fri, 17 Jun 2022 13:42:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nT0PEsAcl1XC; Fri, 17 Jun 2022 13:42:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14EFB4B330;
	Fri, 17 Jun 2022 13:42:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4DAE4B2DA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 13:41:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id keS5OInKIeHX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2022 13:41:58 -0400 (EDT)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3272849E45
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 13:41:58 -0400 (EDT)
Received: by mail-pj1-f49.google.com with SMTP id cv13so2163925pjb.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2022 10:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=/I2MpXcjw3AyYEvY6nT3sj6eeTPFPpb8SnX52+vnNhI=;
 b=SrVIGN592I55tVcbNN6o+NeIvQUZsEvz/Cd/zBTooQP5MUHDNsHnEIe/HEIvL02MeS
 +Vyb3GJ6hErVeRvGS4HKJZ8esknwX53f3/JYrKgK6qbHVwKjP6g5DTzaSfNSoSuWQSUE
 0OpWVK9BS9qSSbcucEV6DeKwOo8YJIoV+RGeD2gyNROhhDqiT5D4ALRgYjWzdtBz4f1z
 KKgXsB4qjmX8Ii5d4QgiGZj9HhJ2UScgx+TKViXz+8p4mWC2jvzXsTcDbiDYFKdUxp2Y
 T0ok5qmZxXkaKD6iNmhtGJtvy5CJM+LV5fEouuWd7p08FI5WsuMwnP7LbyGa5BVLe0Zk
 V/1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=/I2MpXcjw3AyYEvY6nT3sj6eeTPFPpb8SnX52+vnNhI=;
 b=iBqVjjW1Ct4ugXhAPeYkiAjjueizTbwXs/PNy6AAVvgTGKklZn1ZfRuuRUXw+CniBX
 TiRmDg4AF251AD4znd7iGHmCM4SFU93LoqwUYWU712n5rt6l6NwMpN+VYif7e04puJv/
 dh9MCXa/EvaQXzVymhUjB6RLXn7EnmwOXSL93eA4uO/Y+csATz3Paulp6CHRyZrW5OUY
 X6IqTlGt0K8oTUW31f8+ugrPoOn7XBprS6Nm2X6oB/BqmvqcWtfx0wqjFgcs2rEbkGe3
 HkFCmtI3ri2UCIfqTSXxJzUOZhtqXi5wnvPwpMvkSLB8rC4Bsn5P4unyELB2Q6nMNChX
 sD/g==
X-Gm-Message-State: AJIora//vMfNZGwEKzK51G6yLtFi4pmJxVwaILVOdGL17ywXoiD/SLTB
 4Yo9V0n2MxkBsBMYCVErKEtsLA==
X-Google-Smtp-Source: AGRyM1t9uTrYoSS1GO4s/tyedBnGd6ejt1GvCWW+u/gAjLzqhH4WzpxK/5q7wKeu3TQmWYILwdJAhA==
X-Received: by 2002:a17:903:1105:b0:168:9cac:a0a5 with SMTP id
 n5-20020a170903110500b001689caca0a5mr10965048plh.59.1655487716808; 
 Fri, 17 Jun 2022 10:41:56 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com.
 [35.230.65.123]) by smtp.gmail.com with ESMTPSA id
 jj21-20020a170903049500b001616e19537esm3817546plb.213.2022.06.17.10.41.56
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Jun 2022 10:41:56 -0700 (PDT)
Date: Fri, 17 Jun 2022 17:41:52 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
Message-ID: <Yqy84GkGAdE1BzI6@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-22-dmatlack@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-22-dmatlack@google.com>
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

On Mon, May 16, 2022, David Matlack wrote:
> -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)

I still find it somewhat kludgy to have callers provide an capacity.  It's not
terrible while there's only a single call site, but if a use case comes along
for using an oversized cache with multiple call sites, it'll be gross.

Tweaking my idea of a "custom" wrapper, what about adding an "oversized" wrapper?
That yields clear, firm rules on when to use each helper, guards against calling
the "standard" flavor with an impossible @min, and addresses Mingwei's concern
that a misguided user could specify a nonsensically small capacity.

The only quirk is that kvm_mmu_topup_memory_cache_oversized() has a fixed min,
but IMO that's an acceptable tradeoff, and it's a non-issue until another user
pops up.

static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc,
					int capacity, int min)
{
	gfp_t gfp = GFP_KERNEL_ACCOUNT;
	void *obj;

	if (mc->nobjs >= min)
		return 0;

	if (unlikely(!mc->objects)) {
		capacity = max(min, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE);

		mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
		if (!mc->objects)
			return -ENOMEM;

		mc->capacity = capacity;
	}

	/* It is illegal to request a different capacity across topups. */
	if (WARN_ON_ONCE(mc->capacity != capacity))
		return -EIO;

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

	if (WARN_ON_ONCE(min > capacity))
		min = capacity;

	return __kvm_mmu_topup_memory_cache(mc, capacity, min);
}

/* Oversized caches have a fixed size, i.e. min == capacity == size. */
int kvm_mmu_topup_memory_cache_oversized(struct kvm_mmu_memory_cache *mc, int size)
{
	if (WARN_ON_ONCE(size < KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE)
		size = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;

	return __kvm_mmu_topup_memory_cache(mc, size, size);
}
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
