Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A49C433EF
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 07:24:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9889D4B12E;
	Mon,  2 May 2022 03:24:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UvznTFmT9YZX; Mon,  2 May 2022 03:24:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D92149EFF;
	Mon,  2 May 2022 03:24:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70661410F7
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 03:24:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3sslJCe71qjB for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 03:24:33 -0400 (EDT)
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com
 [209.85.166.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 377FD40AFA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 03:24:33 -0400 (EDT)
Received: by mail-io1-f43.google.com with SMTP id r27so10342614iot.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 00:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=U3yK116U7QtcL5LqxzCgKsq8iaHrCKZT63ym/sXbAKc=;
 b=Bzi+R0R7QaC+1bjX2bo/eUhZOcarNK1lhHQK3BnkDNsZ/YQ2kF65HgubGNE1g9QjAF
 VClt8yFpYSC5oht9s5BVdGzylLx1SGefdWn/yZSkP43v9ZQ/U115ldRP4mIaned4xy+i
 XIOYoMJFeLcWOEhr5AxcXnBEpdEmwdLfO6uO7xJ6U4GX4NaQbgjWU8WH2H/DzUzqOLnG
 Y07pCf3IIYshAUYH77brXREcB5+CeW72v1d84nST1hyzetu4eMbN4GXW/ybvmO2gKA4z
 6cXwi4THka5cWO2I5lnhUndPk6YD5GJn9zIhAtE8MWZojqFyir63YUwehSgoAGHPtqPb
 sMAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=U3yK116U7QtcL5LqxzCgKsq8iaHrCKZT63ym/sXbAKc=;
 b=gR6r1YBjBKIlIKxPWrXITOtf4HgqFhvLO2RZ1/QpdzTl3tZhwnLyhjJIuTAtmt2ILS
 EaXWLZtrg4u+6+Ll+XsjJNdDE+q/8uRQyiMwx7U7ngpJybQTy8w9w65XBHOmvvNt2tp5
 kXAlUSOUacRjw5w5qQMTe8y+zxY3Z2fIUrBAVBoanOM+0rscCFa1Dp3L6ZEcJ42LsTR+
 iq3hxEDMcpSyJ1fcM2ZscRUCpYBsqEGBXTn4Wxl9s+EQWEykdvoX6ehRy/TnclOPdvkP
 SP6cr4P9MEWdw3qLflryTrEk4RSdjvzz1ELooCEE+o67mxudBn3JOxlZawpPIZeAHtnt
 xg4Q==
X-Gm-Message-State: AOAM533tkjIPbGdNJEo1DM+monYBz1FKRPPwwpd4zYEufNJswjJQFCx3
 Qe33NcoIZQxxO7Y0/uOHK/B0Gw==
X-Google-Smtp-Source: ABdhPJxeI2hWA90VpSmXaKqPppDo5J6dwWDCrTz4glAq2DiVVqCq9f3COwPcysvhW/KDXqg9MvY5ZQ==
X-Received: by 2002:a05:6638:2643:b0:323:c3e3:fcec with SMTP id
 n3-20020a056638264300b00323c3e3fcecmr4517508jat.289.1651476272267; 
 Mon, 02 May 2022 00:24:32 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 z7-20020a926507000000b002cde6e352e5sm2494262ilb.47.2022.05.02.00.24.31
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 02 May 2022 00:24:31 -0700 (PDT)
Date: Mon, 2 May 2022 07:24:28 +0000
From: Oliver Upton <oupton@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v4 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in
 secondary pagetable stats
Message-ID: <Ym+HLD/U0wwrxtaB@google.com>
References: <20220429201131.3397875-1-yosryahmed@google.com>
 <20220429201131.3397875-5-yosryahmed@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220429201131.3397875-5-yosryahmed@google.com>
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 linux-mm@kvack.org, Zefan Li <lizefan.x@bytedance.com>,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Shakeel Butt <shakeelb@google.com>,
 cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Tejun Heo <tj@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

Hi Yosry,

On Fri, Apr 29, 2022 at 08:11:31PM +0000, Yosry Ahmed wrote:
> Count the pages used by KVM in arm64 for stage2 mmu in secondary pagetable
> stats.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  arch/arm64/kvm/mmu.c | 35 +++++++++++++++++++++++++++++++----
>  1 file changed, 31 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 53ae2c0640bc..fc5030307cce 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -92,9 +92,13 @@ static bool kvm_is_device_pfn(unsigned long pfn)
>  static void *stage2_memcache_zalloc_page(void *arg)
>  {
>  	struct kvm_mmu_memory_cache *mc = arg;
> +	void *virt;
>  
>  	/* Allocated with __GFP_ZERO, so no need to zero */
> -	return kvm_mmu_memory_cache_alloc(mc);
> +	virt = kvm_mmu_memory_cache_alloc(mc);
> +	if (virt)
> +		kvm_account_pgtable_pages(virt, +1);

Sorry I didn't say it last time around, would now be a good time to
clean up the funky sign convention of kvm_mod_used_mmu_pages()? Or limit
the funk to just x86 :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
