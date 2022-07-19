Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B407C43334
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jul 2022 13:30:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 871964CB70;
	Tue, 19 Jul 2022 09:30:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1mmF9zlxaInF; Tue, 19 Jul 2022 09:30:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55ECD4CB56;
	Tue, 19 Jul 2022 09:30:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF5CF4CB4A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 09:30:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T1aKzgrSRa6W for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jul 2022 09:30:22 -0400 (EDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 477C44C8C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 09:30:22 -0400 (EDT)
Received: by mail-wr1-f45.google.com with SMTP id h17so21663436wrx.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jul 2022 06:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=aeU9cgOyyIosd32FJcgD+fpFlGUSWOLfdLntVffrwYI=;
 b=hux2JLvdiv0cwO+vggf9NbJXBqDg2Ko8RqWrIxcttc9Hg0kU7gZtV0HtaGsYzMJN5r
 2xw+PCxakX3m3q/UPEjcRkRQGRkSeFJ2fEGDqyoqsTV9ixkD9v22Id1hMmzBNtUiDsV3
 Kop16VLrqGjXK9trmzw+2iuf+R8SFC6k5cm5xvtgAuXyR91yLdQxFt2Hks/xD4SMcbkv
 RpHxN4o4uYg7HOFYDEMnt50EWgUaPHUff6hQbVOVbFrvUGHzC8sDXcIeXO3S3TfcfB5Z
 L1h4cAf1nwg7RFdkmLR5r6js+oMs8hZj+72cbkaDTBShuQV8VpQ63RwhZpWHg6bc1V60
 GlHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=aeU9cgOyyIosd32FJcgD+fpFlGUSWOLfdLntVffrwYI=;
 b=XS1Rpwy6UD/UE6wxAqhWMJqP0avKK50ipPa8b+OVLbw0F2naOVsYEDMosxSo6WA94m
 btiu0UKiq7j5wkyCjfT04/0xcuZb0eONxEKyt82DKcmVXKiRO8uqbCWvVPw8XJMBVhu/
 MDsJc3MiNJgtKHSZ9vKY1b45ptMbC/xq1yBJU1wS+Rj+x7qd3oRq+/zEKR8KjqXwugWV
 SnPSGA2ZrUWWp+ftvcuLyHudwZ1sm7bTbFH+lbZYZNBshjoKiSnAXV7zWu4ACyeSXJir
 OQgJhFpIq8/C6GHiIKaeEo4+x4bu0Tz8Ae7V1pHclYKskqwI6eNSRUyUQpdEbZmOZiJs
 JB+A==
X-Gm-Message-State: AJIora+rP4c8Q7PxfjtP3H0MLXP/tN7rTtXU3z2xfk7qTvu8XmJRDWtZ
 JQf5Hj8UHx2ldlGbp501PylQgg==
X-Google-Smtp-Source: AGRyM1vzvLKgd/6l5pxRFRCv0etdl5tPYv3bpkSlMQO5Lp/Wf3UVXLnmW9wvqkKhdX+dMbee37E47A==
X-Received: by 2002:a05:6000:1541:b0:21d:b298:96be with SMTP id
 1-20020a056000154100b0021db29896bemr26549092wry.206.1658237421084; 
 Tue, 19 Jul 2022 06:30:21 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com.
 [35.187.36.109]) by smtp.gmail.com with ESMTPSA id
 b14-20020a5d40ce000000b0021a56cda047sm13475885wrq.60.2022.07.19.06.30.20
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 19 Jul 2022 06:30:20 -0700 (PDT)
Date: Tue, 19 Jul 2022 14:30:16 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 14/24] KVM: arm64: Add pcpu fixmap infrastructure at EL2
Message-ID: <Ytax6L2BUt5ON1Dp@google.com>
References: <20220630135747.26983-1-will@kernel.org>
 <20220630135747.26983-15-will@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220630135747.26983-15-will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Oliver Upton <oliver.upton@linux.dev>, Andy Lutomirski <luto@amacapital.net>,
 linux-arm-kernel@lists.infradead.org, Michael Roth <michael.roth@amd.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, kvmarm@lists.cs.columbia.edu
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

>  static struct hyp_pool host_s2_pool;
> diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> index d3a3b47181de..17d689483ec4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> @@ -14,6 +14,7 @@
>  #include <nvhe/early_alloc.h>
>  #include <nvhe/gfp.h>
>  #include <nvhe/memory.h>
> +#include <nvhe/mem_protect.h>
>  #include <nvhe/mm.h>
>  #include <nvhe/spinlock.h>
>  
> @@ -24,6 +25,7 @@ struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
>  unsigned int hyp_memblock_nr;
>  
>  static u64 __io_map_base;
> +static DEFINE_PER_CPU(void *, hyp_fixmap_base);
>  
>  static int __pkvm_create_mappings(unsigned long start, unsigned long size,
>  				  unsigned long phys, enum kvm_pgtable_prot prot)
> @@ -212,6 +214,76 @@ int hyp_map_vectors(void)
>  	return 0;
>  }
>  
> +void *hyp_fixmap_map(phys_addr_t phys)
> +{
> +	void *addr = *this_cpu_ptr(&hyp_fixmap_base);
> +	int ret = kvm_pgtable_hyp_map(&pkvm_pgtable, (u64)addr, PAGE_SIZE,
> +				      phys, PAGE_HYP);
> +	return ret ? NULL : addr;
> +}
> +
> +int hyp_fixmap_unmap(void)
> +{
> +	void *addr = *this_cpu_ptr(&hyp_fixmap_base);
> +	int ret = kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)addr, PAGE_SIZE);
> +
> +	return (ret != PAGE_SIZE) ? -EINVAL : 0;
> +}
> +

I probably missed something but as the pagetable pages for this mapping are
pined, it seems impossible (currently) for this call to fail. Maybe a WARN_ON
would be more appropriate, especially the callers in the subsequent patches do
not seem to check for this function return value?

[...]
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
