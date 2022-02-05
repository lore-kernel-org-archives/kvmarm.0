Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D22CC433FE
	for <kvmarm@archiver.kernel.org>; Sat,  5 Feb 2022 06:09:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2B5340C10;
	Sat,  5 Feb 2022 01:09:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id suuJytv6Q1rF; Sat,  5 Feb 2022 01:09:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACDBF40C29;
	Sat,  5 Feb 2022 01:09:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEB0940FD3
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Feb 2022 01:09:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WgYCZQE2KUCj for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Feb 2022 01:09:47 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68BA340C10
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Feb 2022 01:09:47 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1644041387;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=9DjdP0NZq7FEwMEfMYlhPQOzj1IUaS2o/1SDmCK+oqQ=;
 b=fIZG1tZutRqFmCMqA6FxVL3rdxqVugTf53HH3vB8D7DSvXs3ZHhzLO6yOXBOXCW8G96pup
 JUX8yLfAO7wZc86GWLy7ScsoQxrkyg65CKKhJ34qdqs8GxAc+frljMPjBiF24/7S7Gmyf1
 mBVOU8Gds0Bvjoc5mY7cHDqwk4cnwaw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-318-rvMRinjDO9W5F-An5YPdyw-1; Sat, 05 Feb 2022 01:09:42 -0500
X-MC-Unique: rvMRinjDO9W5F-An5YPdyw-1
Received: by mail-ed1-f72.google.com with SMTP id
 k5-20020a508ac5000000b00408dec8390aso4170476edk.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Feb 2022 22:09:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=9DjdP0NZq7FEwMEfMYlhPQOzj1IUaS2o/1SDmCK+oqQ=;
 b=O51sU2zuo+cC1QW4p1f46czLKOXUmuNbJYvVYsTAkhe/v/X5VHc/LJWpzcewEeObzt
 ZwQNySLt+uAAJfDID95e+TWSyQDFsGaEnFf5qx0kZSHVLy2QuhR0DG9etcuCy+Q99J3P
 FdQQ/jIXUf4S6tmxBYthp0AL1pnNjaSfDy/e6tiY2bOTmgDiFSMTd5ulmDD4wINbo960
 qh1yfEqxf2TXX+feyp3x4n0KAxL8rAy8j9YYaOxbMiKVDP6anGlRl2jzuQRB3nWzuGX7
 4VsGjVySwzanzvk5H1sCJRy+df8FP0rWZhpr8rExEyccNTkiQ5MMwUpI7iCjCq7wDGKj
 xdSg==
X-Gm-Message-State: AOAM532TjKoibTpyjAY0Cs+zkl/ROxeQ9++VkNzwVYdN0v6whhUiYjDd
 Pseiak5iO9EjRY7sOylqH1izTfWYtFSfWrxZ+1O/QbD8iID4ldce8SNYjzjeUoMVYpnthVgbi5Z
 uGNEfShqo0DV2fdA7EVJWXnAH
X-Received: by 2002:a05:6402:90b:: with SMTP id
 g11mr2688584edz.69.1644041381535; 
 Fri, 04 Feb 2022 22:09:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDdtdx2OjSz5RZOamZ7u7/zDd1EnnB169l8sfvPwQjBB817q7JLa+K+N6Qip6n0byyG51eeA==
X-Received: by 2002:a05:6402:90b:: with SMTP id
 g11mr2688559edz.69.1644041381267; 
 Fri, 04 Feb 2022 22:09:41 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045?
 ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
 by smtp.googlemail.com with ESMTPSA id d6sm1673811eds.25.2022.02.04.22.09.38
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 04 Feb 2022 22:09:40 -0800 (PST)
Message-ID: <f41961a1-1248-7b6f-c19f-6d25565d93cf@redhat.com>
Date: Sat, 5 Feb 2022 07:09:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.17, take #2
To: Marc Zyngier <maz@kernel.org>
References: <20220204135120.1000894-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220204135120.1000894-1-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2/4/22 14:51, Marc Zyngier wrote:
> Paolo,
> 
> Here's a handful of fixes for -rc3, all courtesy of James Morse.
> 
> Please pull,
> 
> 	M.
> 
> The following changes since commit 26291c54e111ff6ba87a164d85d4a4e134b7315c:
> 
>    Linux 5.17-rc2 (2022-01-30 15:37:07 +0200)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.17-2
> 
> for you to fetch changes up to 1dd498e5e26ad71e3e9130daf72cfb6a693fee03:
> 
>    KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata (2022-02-03 09:22:30 +0000)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for 5.17, take #2
> 
> - A couple of fixes when handling an exception while a SError has been
>    delivered
> 
> - Workaround for Cortex-A510's single-step[ erratum
> 
> ----------------------------------------------------------------
> James Morse (3):
>        KVM: arm64: Avoid consuming a stale esr value when SError occur
>        KVM: arm64: Stop handle_exit() from handling HVC twice when an SError occurs
>        KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata
> 
>   Documentation/arm64/silicon-errata.rst  |  2 ++
>   arch/arm64/Kconfig                      | 16 ++++++++++++++++
>   arch/arm64/kernel/cpu_errata.c          |  8 ++++++++
>   arch/arm64/kvm/handle_exit.c            |  8 ++++++++
>   arch/arm64/kvm/hyp/include/hyp/switch.h | 23 +++++++++++++++++++++--
>   arch/arm64/tools/cpucaps                |  5 +++--
>   6 files changed, 58 insertions(+), 4 deletions(-)
> 

Pulled, thanks (and sent already the pull request to Linus).

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
