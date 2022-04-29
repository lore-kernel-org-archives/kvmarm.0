Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16108C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 29 Apr 2022 15:39:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9711D40C0A;
	Fri, 29 Apr 2022 11:39:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fvKOyQVRAg5T; Fri, 29 Apr 2022 11:39:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 802264B130;
	Fri, 29 Apr 2022 11:39:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F06E64B10A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 11:39:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WfRm13Fa1fvk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 Apr 2022 11:39:25 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6D0F4B108
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 11:39:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651246765;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=JBL72uy5ImMZv8VAWZdys+gULaq3Qe+E3D81Kp3hvvs=;
 b=jN0UGtp3W34sQbHqB5r0qgKX8oRf1tOy5gRV7Iql/69fWtjcjJiYbymQuLHA5wqIDw7Tgu
 wNby6W3yFNaYUhVES35PDUtfQ8wq0VCCYyQqOXEerG5LzLR2eFmZm/ZviCllqM/2siwRhn
 CEit9UBImw7Bh6mzheYlFomEpIl2cpw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-7t5_iCRxMpimSbvFcQfzoA-1; Fri, 29 Apr 2022 11:39:24 -0400
X-MC-Unique: 7t5_iCRxMpimSbvFcQfzoA-1
Received: by mail-ej1-f70.google.com with SMTP id
 sb36-20020a1709076da400b006f3d4b12d3aso3603795ejc.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 Apr 2022 08:39:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=JBL72uy5ImMZv8VAWZdys+gULaq3Qe+E3D81Kp3hvvs=;
 b=YmrW4V0jHwrtod7VWA4wtSvL8XvBvj8k6kPCwUijMZ6ltCl1pBd2VZux4Jhf6sPSjL
 Q4++FZiKZZM6J0O/V0f9z8h5T6oU0SczrRd0TQl2TffM1rTPag/kPuw8CNYDtL6vrSav
 AxRYDNoqNLWa3yV2FsCX2iQKEqpSGb3sJix7Djjb8W7Z2S9RL1wzW5U1cuPBul5qHylF
 j3l+pnnttplhwz1sbp0k7L8cbT3ai6eAGLgmUNS9mwvdyVbwADSE9HILjbzOXmSQGqf4
 6C8QaadTQi8gf1ZU5uLo46rerQHPmgeExHf46x5/fQaVYYsH6T8hlJUt0xue0SUVEOAj
 JYJg==
X-Gm-Message-State: AOAM532mLZlkWccDOwa4KKGBrnMAvp6mwOhQdyeYg8uYsM0vYK2xYYV1
 M3x0V236veqalkRKFEJWaanRTgrGyvxolmdJUmU4lEqCRztYh40/dXPNsOEUXwPYYPhna8uGjLI
 3oo5HU1aeUbjkOWoOOrMbQRLb
X-Received: by 2002:a05:6402:358f:b0:426:2b74:2c03 with SMTP id
 y15-20020a056402358f00b004262b742c03mr8860847edc.402.1651246762156; 
 Fri, 29 Apr 2022 08:39:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwnIPV1ktpBLiiyAWxokXctmbqVg3u3ZDB9FscRhShNh1tFY7vRckRzsB4CZ2EDa+dzsLN61A==
X-Received: by 2002:a05:6402:358f:b0:426:2b74:2c03 with SMTP id
 y15-20020a056402358f00b004262b742c03mr8860826edc.402.1651246761892; 
 Fri, 29 Apr 2022 08:39:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c?
 ([2001:b07:6468:f312:1c09:f536:3de6:228c])
 by smtp.googlemail.com with ESMTPSA id
 jy28-20020a170907763c00b006f3ef214e53sm725933ejc.185.2022.04.29.08.39.20
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 29 Apr 2022 08:39:21 -0700 (PDT)
Message-ID: <e0967ca4-b574-2be4-55de-3dce212fea21@redhat.com>
Date: Fri, 29 Apr 2022 17:39:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.18, take #2
To: Marc Zyngier <maz@kernel.org>
References: <20220429153615.710743-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220429153615.710743-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Christoffer Dall <christoffer.dall@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 4/29/22 17:36, Marc Zyngier wrote:
> Paolo,
> 
> Here's a trio of fixes for 5.18. Nothing terribly interesting, but
> nonetheless important fixes (two of the bugs are related to AArch32).

Cool, will pull soon.  Please take a quick look at the flags->data ABI 
fix, it's one patch on top of 5.18 as you requested and if I hear 
nothing I'll send it ~Sunday morning to Linus.

Thanks,

Paolo

> Please pull,
> 
> 	M.
> 
> The following changes since commit 21db83846683d3987666505a3ec38f367708199a:
> 
>    selftests: KVM: Free the GIC FD when cleaning up in arch_timer (2022-04-07 08:46:13 +0100)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.18-2
> 
> for you to fetch changes up to 85ea6b1ec915c9dd90caf3674b203999d8c7e062:
> 
>    KVM: arm64: Inject exception on out-of-IPA-range translation fault (2022-04-27 23:02:23 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.18, take #2
> 
> - Take care of faults occuring between the PARange and
>    IPA range by injecting an exception
> 
> - Fix S2 faults taken from a host EL0 in protected mode
> 
> - Work around Oops caused by a PMU access from a 32bit
>    guest when PMU has been created. This is a temporary
>    bodge until we fix it for good.
> 
> ----------------------------------------------------------------
> Alexandru Elisei (1):
>        KVM/arm64: Don't emulate a PMU for 32-bit guests if feature not set
> 
> Marc Zyngier (1):
>        KVM: arm64: Inject exception on out-of-IPA-range translation fault
> 
> Will Deacon (1):
>        KVM: arm64: Handle host stage-2 faults from 32-bit EL0
> 
>   arch/arm64/include/asm/kvm_emulate.h |  1 +
>   arch/arm64/kvm/hyp/nvhe/host.S       | 18 +++++++++---------
>   arch/arm64/kvm/inject_fault.c        | 28 ++++++++++++++++++++++++++++
>   arch/arm64/kvm/mmu.c                 | 19 +++++++++++++++++++
>   arch/arm64/kvm/pmu-emul.c            | 23 ++++++++++++++++++++++-
>   5 files changed, 79 insertions(+), 10 deletions(-)
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
