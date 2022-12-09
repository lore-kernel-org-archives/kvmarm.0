Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8076EC4167B
	for <kvmarm@archiver.kernel.org>; Fri,  9 Dec 2022 20:45:10 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DE0D94B945;
	Fri,  9 Dec 2022 15:45:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g+mROsknP8zu; Fri,  9 Dec 2022 15:45:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C75BB4B731;
	Fri,  9 Dec 2022 15:45:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 447854B943
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 15:45:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id j83D9JFd8wLh for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Dec 2022 15:45:06 -0500 (EST)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
 [209.85.216.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26BC44B933
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Dec 2022 15:45:06 -0500 (EST)
Received: by mail-pj1-f49.google.com with SMTP id
 e7-20020a17090a77c700b00216928a3917so9353219pjs.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 09 Dec 2022 12:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=vrO0N2BhoytOAhhhHfUhdN91u6TruVaipT5ISV1vaYc=;
 b=f95FMmTEKSCikEYcOfIHQeZ11wft/M7xtxOLWqo9ddBFll+PEIhNuP8Altnit2pg7l
 zyRhiE+JRDfj5dB8/WxDXf1drX13fZ1eOh7rba0AIhbehJO0Y9D2Isb+V0FtO1vE8xtB
 hYMCbXb+6k8JyDHQhnThQvX/+T5zbEXkZxYWQBSqRWCBdOVJmssGwx1Y5IXZJw/6XRzs
 S3ZdcDYHIQuWdKlJwLHVsg5FbzwD0u0eYrShli67IQw7Q2mlLjgxmxsG0ncnWSJMMZVg
 KepJ3JyFSc3873pExBYAY27kO9Gx8PluA0Mbdjh+rOeLvfI90C98illSL1VVYvLRtJsW
 Xzfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=vrO0N2BhoytOAhhhHfUhdN91u6TruVaipT5ISV1vaYc=;
 b=ruzSTa5gzWEgmnl61vsbqoyIZeifaDWQJuAeHz6qhBZAAFkcur+ZGp8mUH21M31x4T
 9ebOdSWAsn2NXZf7muQvgd0aPCKSU04RMAAFcC6SFRsmy86wOINs8p/PM6hmZCEyyiSz
 vtYz33kXCWunc/duBYazWFs6Dap1FTLbzN2bf/fgaVf8YtACuvce6XdvlLj1I53y2ASU
 p0QAP51Tt7ypI0gV+eVAfKAYGukBiw7eGuUtf76F5suryBxFxHgXAi0Ck8bQi6KoRjoT
 iwyVW2iIvhLkUlBefpBsbYOhk6axgCWNi+xSuNckap2i9hmTMNniwp7axntqaMiCq0CQ
 XPsQ==
X-Gm-Message-State: ANoB5plfkkyudAzaBqLaZqLk7p1fxEZccgMYwUPBzpPEZnWH7LJGHlSV
 v1GnR3RCIOvYNddJ6dZSuen5HA==
X-Google-Smtp-Source: AA0mqf5qINBTPYAP4qeg1UzaZ6wwLAd0BwvCi3JbF60z/oyrT5V6BtufJ7TAxCe0PKR19lvup9WOtA==
X-Received: by 2002:a05:6a20:baa3:b0:9d:c38f:9bdd with SMTP id
 fb35-20020a056a20baa300b0009dc38f9bddmr20370pzb.2.1670618705014; 
 Fri, 09 Dec 2022 12:45:05 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com.
 [34.168.104.7]) by smtp.gmail.com with ESMTPSA id
 y10-20020aa793ca000000b0057555d35f79sm1614631pff.101.2022.12.09.12.45.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 09 Dec 2022 12:45:04 -0800 (PST)
Date: Fri, 9 Dec 2022 20:45:01 +0000
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 4/7] KVM: selftests: Correctly initialize the VA space
 for TTBR0_EL1
Message-ID: <Y5OeTeq55OgBJbjT@google.com>
References: <20221209015307.1781352-1-oliver.upton@linux.dev>
 <20221209015307.1781352-5-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221209015307.1781352-5-oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Fri, Dec 09, 2022, Oliver Upton wrote:
> An interesting feature of the Arm architecture is that the stage-1 MMU
> supports two distinct VA regions, controlled by TTBR{0,1}_EL1. As KVM
> selftests on arm64 only uses TTBR0_EL1, the VA space is constrained to
> [0, 2^(va_bits)). This is different from other architectures that
> allow for addressing low and high regions of the VA space from a single
> page table.
> 
> KVM selftests' VA space allocator presumes the valid address range is
> split between low and high memory based the MSB, which of course is a
> poor match for arm64's TTBR0 region.
> 
> Add a helper that correctly handles both addressing schemes with a
> comment describing each.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---

Thanks much!  Looks awesome, especially the comment!

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  .../selftests/kvm/include/kvm_util_base.h     |  1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 49 ++++++++++++++++---
>  2 files changed, 44 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> index 6cd86da698b3..b193863d754f 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> @@ -103,6 +103,7 @@ struct kvm_vm {
>  	struct sparsebit *vpages_mapped;
>  	bool has_irqchip;
>  	bool pgd_created;
> +	bool has_split_va_space;
>  	vm_paddr_t ucall_mmio_addr;
>  	vm_paddr_t pgd;
>  	vm_vaddr_t gdt;
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index a256ec67aff6..53d15f32f220 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -186,6 +186,43 @@ const struct vm_guest_mode_params vm_guest_mode_params[] = {
>  _Static_assert(sizeof(vm_guest_mode_params)/sizeof(struct vm_guest_mode_params) == NUM_VM_MODES,
>  	       "Missing new mode params?");
>  
> +/*
> + * Initializes vm->vpages_valid to match the canonical VA space of the
> + * architecture.
> + *
> + * Most architectures split the range addressed by a single page table into a
> + * low and high region based on the MSB of the VA. On architectures with this
> + * behavior the VA region spans [0, 2^(va_bits - 1)), [-(2^(va_bits - 1), -1].
> + *
> + * arm64 is a bit different from the rest of the crowd, as the low and high
> + * regions of the VA space are addressed by distinct paging structures
> + * (TTBR{0,1}_EL1).

Oooh, they're different CR3s in x86 terminology?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
