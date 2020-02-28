Return-Path: <SRS0=iQbv=4Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B8BC3F2D3
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 10:47:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3183A2469F
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 10:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KlQDzgg3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3183A2469F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FAA84AF37;
	Fri, 28 Feb 2020 05:47:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1LZT5ysBSpm4; Fri, 28 Feb 2020 05:47:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6363F4AFA5;
	Fri, 28 Feb 2020 05:47:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFAA94AF7A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 05:47:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jyoHjFcgOGcf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Feb 2020 05:47:15 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09A604AF78
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 05:47:15 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1582886834;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=by6qnbWXHvbfMve5jRvxpdLV2eFgarPImZ7pzkAFACI=;
 b=KlQDzgg3XuorEr3EJk4rOQAVx6NAsR6RVnNCkMEUk2o5EBvX72bQbwvHQ2wKatxPXAiwkS
 /ZdKgfEC/LBlFB08bNd1pXv0GhKqxnzC/eZYuPPkQ9IYx4Idqvd6JLdkWm+MT0i2YjHyCW
 gZT4K3jbnBxELVH2mSXsP95JZP1L3Wg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-rQ2lPpxwN8iNb8RI9MI6rA-1; Fri, 28 Feb 2020 05:47:10 -0500
X-MC-Unique: rQ2lPpxwN8iNb8RI9MI6rA-1
Received: by mail-wr1-f71.google.com with SMTP id c6so1150665wrm.18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 02:47:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=by6qnbWXHvbfMve5jRvxpdLV2eFgarPImZ7pzkAFACI=;
 b=gb6zoU+ubwlwAY+hHZDtmkaPsr/05W8dhaP172rBxHJ0/Cr+sjZQy+VCWOR4PH+1+v
 C/TxhqoZ6kwU1rx2WZAhQ9FLfkt4iGx4FtXXdBuA/jHOuXfZWhV3ARfQ1OKGqmW/uHRn
 ZDZL4vZ2bqFIqfztaD6q/ZmHJGNxXAVerytf7qxVE/sBS5qAek/EHFKzXir1WndLkKl7
 PivCrNyEc4LPzLSWePB9/J+p4N6P9/5P4OWSkoLP9QZZdN4V/tmKJMC8UlRjVR52Or9j
 PVRuXPUaTUyYo4dTZFeij+Rrdr+ff2lgobgE3fDtSJJIObxiShHpWwDwS1uQvsHuLh4I
 +qQg==
X-Gm-Message-State: APjAAAUYSKTVR/UVy1bZUYG8AhOhiroIRH4mvAllpk8T/bbAfNR0Ia05
 YK5w+btXry9wqy5SQSRC3Mr+PSWiW70ByRumqX4FxztqdLfuNja+Js09wzYggRLHqgAIICeZGBX
 OqwQgC8pgsH+je3Pbdl6rduO7
X-Received: by 2002:a7b:c7d2:: with SMTP id z18mr4308798wmk.160.1582886829211; 
 Fri, 28 Feb 2020 02:47:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqz5y4mrS/flKBx5L1gDb3tgLLQMoczS1j4+xFLFc7QK89AHPXzLtC2JXXQ6xdqLZv0ycLtvwA==
X-Received: by 2002:a7b:c7d2:: with SMTP id z18mr4308771wmk.160.1582886828876; 
 Fri, 28 Feb 2020 02:47:08 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:d0d9:ea10:9775:f33f?
 ([2001:b07:6468:f312:d0d9:ea10:9775:f33f])
 by smtp.gmail.com with ESMTPSA id h10sm1694142wml.18.2020.02.28.02.47.07
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 28 Feb 2020 02:47:08 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm fixes for 5.6
To: Marc Zyngier <maz@kernel.org>
References: <20200225235223.12839-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <53886277-3081-f8a9-7750-5784a9af2e56@redhat.com>
Date: Fri, 28 Feb 2020 11:47:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200225235223.12839-1-maz@kernel.org>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, Jeremy Cline <jcline@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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

On 26/02/20 00:52, Marc Zyngier wrote:
> Paolo,
> 
> This is a small update containing a number of fixes, the most important ones
> making sure we force the inlining of any helper that gets used by the EL2 code
> (James identified that some bad things happen with CLang and the Shadow Call
> Stack extention).
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 4a267aa707953a9a73d1f5dc7f894dd9024a92be:
> 
>   KVM: arm64: Treat emulated TVAL TimerValue as a signed 32-bit integer (2020-01-28 13:09:31 +0000)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.6-1
> 
> for you to fetch changes up to e43f1331e2ef913b8c566920c9af75e0ccdd1d3f:
> 
>   arm64: Ask the compiler to __always_inline functions used by KVM at HYP (2020-02-22 11:01:47 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm fixes for 5.6, take #1
> 
> - Fix compilation on 32bit
> - Move  VHE guest entry/exit into the VHE-specific entry code
> - Make sure all functions called by the non-VHE HYP code is tagged as __always_inline
> 
> ----------------------------------------------------------------
> James Morse (3):
>       KVM: arm64: Ask the compiler to __always_inline functions used at HYP
>       KVM: arm64: Define our own swab32() to avoid a uapi static inline
>       arm64: Ask the compiler to __always_inline functions used by KVM at HYP
> 
> Jeremy Cline (1):
>       KVM: arm/arm64: Fix up includes for trace.h
> 
> Mark Rutland (1):
>       kvm: arm/arm64: Fold VHE entry/exit work into kvm_vcpu_run_vhe()
> 
>  arch/arm/include/asm/kvm_host.h          |  3 --
>  arch/arm64/include/asm/arch_gicv3.h      |  2 +-
>  arch/arm64/include/asm/cache.h           |  2 +-
>  arch/arm64/include/asm/cacheflush.h      |  2 +-
>  arch/arm64/include/asm/cpufeature.h      | 10 +++----
>  arch/arm64/include/asm/io.h              |  4 +--
>  arch/arm64/include/asm/kvm_emulate.h     | 48 ++++++++++++++++----------------
>  arch/arm64/include/asm/kvm_host.h        | 32 ---------------------
>  arch/arm64/include/asm/kvm_hyp.h         |  7 +++++
>  arch/arm64/include/asm/kvm_mmu.h         |  3 +-
>  arch/arm64/include/asm/virt.h            |  2 +-
>  arch/arm64/kvm/hyp/switch.c              | 39 ++++++++++++++++++++++++--
>  arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c |  4 +--
>  virt/kvm/arm/arm.c                       |  2 --
>  virt/kvm/arm/trace.h                     |  1 +
>  15 files changed, 84 insertions(+), 77 deletions(-)
> 

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
