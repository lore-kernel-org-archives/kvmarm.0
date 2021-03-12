Return-Path: <SRS0=ChHZ=IK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75426C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 18:16:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C9D7364F55
	for <kvmarm@archiver.kernel.org>; Fri, 12 Mar 2021 18:15:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9D7364F55
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54E634B489;
	Fri, 12 Mar 2021 13:15:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aeX5bAiQZ9gl; Fri, 12 Mar 2021 13:15:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D69F4B468;
	Fri, 12 Mar 2021 13:15:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60F424B43C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 13:15:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7+kbEyaI4iyx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Mar 2021 13:15:56 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B74A4B42E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 13:15:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615572956;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zT1uG5BRCkJ0aRoz3/NkmyhO11KSSWzsG6Lpm+NPJHg=;
 b=E1WfP6eD46DiH03eGsORZPJcNh7xRFFOidMLcTSjjVZ2o+9LIMJq+mQpuuzmbFGCk2cyMl
 T+XGvMHA98t3mqJy0SY9lhOhmkmMBz5NJxOZ9Encatruu/ivfuANFxLXCoEiupaKPSpGh3
 3nf1ZISphkKvlsv7F/uSvdo3Szc/zxk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-CwmI4vXjOL6H4iT3Were1A-1; Fri, 12 Mar 2021 13:15:55 -0500
X-MC-Unique: CwmI4vXjOL6H4iT3Were1A-1
Received: by mail-wm1-f72.google.com with SMTP id w10so3416044wmk.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Mar 2021 10:15:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=zT1uG5BRCkJ0aRoz3/NkmyhO11KSSWzsG6Lpm+NPJHg=;
 b=BSKxAmcUv/2dz1r+v7DR3wlgkMky09ybYgG5oyKwd8lhzqppncFFexWZ87J/a/XXJI
 908/+azUPCHt2KySoJgmPk+Ih39YvrDX3HM1noyReryP7JhEY1JlpFNFQj7X14cbSh/0
 y0bk8JeMEDXHuUXDW3HPMrrLkjlj8cp+Brj5r6w4QPDl9e0uxbnMkwULnKkydCKtRDoj
 rbe+NvLMfeT8frVy+CCldVdH8XkncdCb5bPqNDNsF/mll2HwJCTglESpdgTV6mD1w9Cd
 T0jTNAcDg18csRJ1yZ6usZYqrUM8jI2Zh4mmW2M/rf8BIqjtgrraanNsdiiJZSl0A0J4
 DE/Q==
X-Gm-Message-State: AOAM533JCf9wINifbIrWEUWdB/Q6bCbgDJAsG83QkLfS6/fJoKSnNhwL
 FbsEFZEJRg6TWUFrdY2sKVeyV2nSyeekSLnszbQrQXA6JdCXQfst8tD3U8r8/HXC4rIQ1HT2fhO
 vdoY+FtX5s5css/CfirUqfwMXfZsAZMTskXGcZXilNVr2GgxmAgC6Zab23O9wdXYCzy2lDN9R4R
 vR
X-Received: by 2002:a7b:c409:: with SMTP id k9mr14187069wmi.151.1615572953534; 
 Fri, 12 Mar 2021 10:15:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzt4L3TBqWVhM4jskGZ84OnFOwnKLJkMoA4pYXvuOzXtxArZsbNlEHt10/qFmRlGX4GZynm/A==
X-Received: by 2002:a7b:c409:: with SMTP id k9mr14187031wmi.151.1615572953265; 
 Fri, 12 Mar 2021 10:15:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id i10sm8192851wrs.11.2021.03.12.10.15.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 12 Mar 2021 10:15:52 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.12, take #2
To: Marc Zyngier <maz@kernel.org>
References: <20210312160003.3920996-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <638be040-7564-a65c-4138-62b21bff4402@redhat.com>
Date: Fri, 12 Mar 2021 19:15:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210312160003.3920996-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, Kees Cook <keescook@chromium.org>,
 kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel@lists.infradead.org, Sami Tolvanen <samitolvanen@google.com>,
 Will Deacon <will@kernel.org>
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

On 12/03/21 17:00, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's the second batch of KVM/arm64 fixes for 5.12. The most notable
> item is the tidying up of the way we deal with the guest physical
> space, which had a couple of warts. The other patches address i-cache
> isolation between vcpus (they are supposed to be vcpu-private, but can
> not being so...), and a fix for a link-time issue that can occur with
> LTO.
> 
> Note that this time around, this pull request is on top of kvm/next,
> right after the patches you applied last week.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 357ad203d45c0f9d76a8feadbd5a1c5d460c638b:
> 
>    KVM: arm64: Fix range alignment when walking page tables (2021-03-06 04:18:41 -0500)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.12-2
> 
> for you to fetch changes up to 262b003d059c6671601a19057e9fe1a5e7f23722:
> 
>    KVM: arm64: Fix exclusive limit for IPA size (2021-03-12 15:43:22 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.12, take #2
> 
> - Fix a couple of branches that could be impossible to resolve at
>    link time when objects are far apart, such as with LTO
> - Mandate i-cache invalidation when two vcpus are sharing a physical CPU
> - Fail VM creation if the implicit IPA size isn't supported
> - Don't reject memslots that reach the IPA limit without breaching it
> 
> ----------------------------------------------------------------
> Marc Zyngier (3):
>        KVM: arm64: Ensure I-cache isolation between vcpus of a same VM
>        KVM: arm64: Reject VM creation when the default IPA size is unsupported
>        KVM: arm64: Fix exclusive limit for IPA size
> 
> Sami Tolvanen (1):
>        KVM: arm64: Don't use cbz/adr with external symbols
> 
>   Documentation/virt/kvm/api.rst     |  3 +++
>   arch/arm64/include/asm/kvm_asm.h   |  4 ++--
>   arch/arm64/kvm/arm.c               |  7 ++++++-
>   arch/arm64/kvm/hyp/entry.S         |  6 ++++--
>   arch/arm64/kvm/hyp/nvhe/hyp-main.c |  6 +++---
>   arch/arm64/kvm/hyp/nvhe/tlb.c      |  3 ++-
>   arch/arm64/kvm/hyp/vhe/tlb.c       |  3 ++-
>   arch/arm64/kvm/mmu.c               |  3 +--
>   arch/arm64/kvm/reset.c             | 12 ++++++++----
>   9 files changed, 31 insertions(+), 16 deletions(-)
> 

Pulled, thanks.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
