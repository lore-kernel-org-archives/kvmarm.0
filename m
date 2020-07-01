Return-Path: <SRS0=y90B=AM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83577C433DF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jul 2020 14:24:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0A7E22067D
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jul 2020 14:24:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JORjjIeP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A7E22067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75F1B4B286;
	Wed,  1 Jul 2020 10:24:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 13IvUxox7L6p; Wed,  1 Jul 2020 10:24:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 743CC4B235;
	Wed,  1 Jul 2020 10:24:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D11374B235
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2020 10:24:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HZm-EBhismDa for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jul 2020 10:24:44 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D575C4B21C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2020 10:24:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1593613484;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tBmVabZ/r13W4Wz52iSUSVBPJD1c2mHsibs2U9wV+k0=;
 b=JORjjIePUZQezCAclKKFkSzAIjrXEE5C88sR05rEKzyedsYViBfL1NJWLq8Q77W/ehHQMQ
 npN5uqEGzShW/ntodx1E0Tw92vNSGgGZoMTZBYnT8oKCipDElDAERLXERcxoEP877jCAzE
 Dk8QDDAKDCylQq4qqEqePtNXUYe4Y+U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-hPKQIC0tM4ChtUrCRKsK3w-1; Wed, 01 Jul 2020 10:24:43 -0400
X-MC-Unique: hPKQIC0tM4ChtUrCRKsK3w-1
Received: by mail-wr1-f69.google.com with SMTP id h28so20808641wrc.18
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Jul 2020 07:24:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=tBmVabZ/r13W4Wz52iSUSVBPJD1c2mHsibs2U9wV+k0=;
 b=mBDEoPbEt4vno4mouIUJtXSymvf364kLnn0A/pntgQNNYugVvNfMZvBkPLl8789UTr
 vUmIUTfMRz42Sb/ZweehwmnWWDsM8YQ04cXWMlVhmvN1/G3tEXfqh7KJ3U00J3mNLVWR
 Pl+RIynOAEMcX2tMFFMdyep/Os/soufKr3YsZF3flNnsHXGXL2RiuPvSS462GGLMpjoJ
 qPGexjauBSdi4g8x18X+uD4FJQoYBUcRtLtq9flwBgZkjxOsjqiRxqvoahf9okwiVyzu
 SlcxEAnSvm/uKYjsp6FJT+Nm3gPX8K4zXFlseNKxOckTuyKPf4WEjRKvptQnX9dzJr3f
 RRvA==
X-Gm-Message-State: AOAM532B6vtrM7wpmDpqfsoksm7hMGg06XJXYPaX71LtxJWZLe8QwEZG
 +dd6Y/nloDDl0gbM58VuYi3hSqA4eqm1A9hQjbO0FYXKMU+M2lzgT2gUIf169PZ9wjhM9/d/GQV
 p8UJ3qtaKd4YKrKDUXGQiIEz3
X-Received: by 2002:a7b:c208:: with SMTP id x8mr27080865wmi.49.1593613481931; 
 Wed, 01 Jul 2020 07:24:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrQwpCBpIqQTfqMpAOLuxuJU2euPTk+0h0YDWiJcUqEtgDNaujmK6RDYgEkNxjJFdbdhkcfw==
X-Received: by 2002:a7b:c208:: with SMTP id x8mr27080838wmi.49.1593613481707; 
 Wed, 01 Jul 2020 07:24:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1142:70d6:6b9b:3cd1?
 ([2001:b07:6468:f312:1142:70d6:6b9b:3cd1])
 by smtp.gmail.com with ESMTPSA id 133sm7947357wme.5.2020.07.01.07.24.40
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 01 Jul 2020 07:24:41 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.8, take #2
To: Marc Zyngier <maz@kernel.org>
References: <20200629162519.825200-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <733910d5-b4db-3df5-9589-80e0367311fd@redhat.com>
Date: Wed, 1 Jul 2020 16:24:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200629162519.825200-1-maz@kernel.org>
Content-Language: en-US
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Steven Price <steven.price@arm.com>, linux-arm-kernel@lists.infradead.org,
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

On 29/06/20 18:25, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's another pull request for a handful of KVM/arm64 fixes. Nothing
> absolutely critical (see the tag for the gory details), but I'd rather
> get these merged as soon as possible.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit b3a9e3b9622ae10064826dccb4f7a52bd88c7407:
> 
>   Linux 5.8-rc1 (2020-06-14 12:45:04 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git kvmarm-fixes-5.8-2
> 
> for you to fetch changes up to a3f574cd65487cd993f79ab235d70229d9302c1e:
> 
>   KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell (2020-06-23 11:24:39 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm fixes for 5.8, take #2
> 
> - Make sure a vcpu becoming non-resident doesn't race against the doorbell delivery
> - Only advertise pvtime if accounting is enabled
> - Return the correct error code if reset fails with SVE
> - Make sure that pseudo-NMI functions are annotated as __always_inline
> 
> ----------------------------------------------------------------
> Alexandru Elisei (1):
>       KVM: arm64: Annotate hyp NMI-related functions as __always_inline
> 
> Andrew Jones (1):
>       KVM: arm64: pvtime: Ensure task delay accounting is enabled
> 
> Marc Zyngier (1):
>       KVM: arm64: vgic-v4: Plug race between non-residency and v4.1 doorbell
> 
> Steven Price (1):
>       KVM: arm64: Fix kvm_reset_vcpu() return code being incorrect with SVE
> 
>  arch/arm64/include/asm/arch_gicv3.h |  2 +-
>  arch/arm64/include/asm/cpufeature.h |  2 +-
>  arch/arm64/kvm/pvtime.c             | 15 ++++++++++++---
>  arch/arm64/kvm/reset.c              | 10 +++++++---
>  arch/arm64/kvm/vgic/vgic-v4.c       |  8 ++++++++
>  drivers/irqchip/irq-gic-v3-its.c    |  8 ++++++++
>  6 files changed, 37 insertions(+), 8 deletions(-)
> 

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
