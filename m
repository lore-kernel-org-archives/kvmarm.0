Return-Path: <SRS0=4nKG=KI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88882C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 12:24:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5DF1613BE
	for <kvmarm@archiver.kernel.org>; Thu, 13 May 2021 12:24:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5DF1613BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 224254B87E;
	Thu, 13 May 2021 08:24:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id keTaVEsOx9+T; Thu, 13 May 2021 08:24:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0E264B88E;
	Thu, 13 May 2021 08:24:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 673904B87E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 08:24:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nn+hoSL+LuD4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 May 2021 08:23:59 -0400 (EDT)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com
 [209.85.218.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2F7AC4B872
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 08:23:59 -0400 (EDT)
Received: by mail-ej1-f43.google.com with SMTP id l1so3575836ejb.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 05:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=O/EgZ0Mib/f1h1pn6ynsix9LbKLcelscbkr1YNLcxt0=;
 b=tCXa270jHTARQ+SrPRUuPKjez1uo4RI0PDczBLDyslWWXw5kc8l/rKW/hg/e0ObEC5
 9vF6BFhmbnrL1EizRV+UeRzphaQXA3XLTCh3aRPFPt/gDbBhIm9RLXj33bEc+mNNAQH5
 CXgvNyTXpmQkBzZHu40ZzdG5wdLWNh06ZAZmXoiNdd8sSlLTu2/PbTqWgSQi1zfNLb89
 obXXqRFErYFjFrxXhsgP7jLVHT8Ct6F6KTkP3dUoni7Skl/Z+RIm0CzJHXGe5lalfY2n
 DY+PrAL/q2XtreThld8QGQlWTo5+4BCYszLN4HMiS43J0vVmMlQVzVjcn9KJjLvYuvFK
 hk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=O/EgZ0Mib/f1h1pn6ynsix9LbKLcelscbkr1YNLcxt0=;
 b=kDAUWC6F3x9O/sFOOLstMXSpI3ZwA9U6serpwWCIkF+rvWbgvfq2vux611NQTLL3YM
 97S3LbIEZdSsxE2TFDg/ghdV/BYK6DGjAUMRYk9kFEbFV8/Da9D8g0aCx2kgPX7085Mf
 q/RToErQpKrlH/h6Au53LBlzQNA1hNFRsSA/b6Mlt6XHHUPOTqhRmqxN9kxztFsCU4fL
 JilXI7ExKyJCDUWoREX6ZzknCOdPPRrkjMqIi7GXjiROkohZjtxSev57M+cL2wXpAlnL
 yTBO0jFfNULJTRjzVJ/+eMd0DI9PiCMSqTrBOxY0OqcnBiwFRK2j0CkzOZrsPwuXu3qN
 4wFg==
X-Gm-Message-State: AOAM5323oAh9G1ZapHzDBlOJ2iV8HqyMcO7YYQYCUJw4AQYV/UcACtcf
 LY5tZ7OQ3VVNS+K+8cHIXk9LMmNdjnYk3OUlGAxOtA==
X-Google-Smtp-Source: ABdhPJzKsGAqpkUcIG97jIx+mrSeLSOY0Z3A2rGv49qhwxB5VfeKopzZ4b9Kyxf2I5g3UyueWtekoNaK6tdTEvYDh5w=
X-Received: by 2002:a17:906:c211:: with SMTP id
 d17mr8276408ejz.247.1620908638026; 
 Thu, 13 May 2021 05:23:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144743.039977287@linuxfoundation.org>
 <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
 <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
In-Reply-To: <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 13 May 2021 17:53:46 +0530
Message-ID: <CA+G9fYuVkX20yUZgtEVAmNc_kheKjnNZXcdSPW2HecXNKmcBBQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org,
 patches@kernelci.org, Linus Torvalds <torvalds@linux-foundation.org>,
 linux-stable <stable@vger.kernel.org>, Pavel Machek <pavel@denx.de>,
 Andrew Morton <akpm@linux-foundation.org>, Jon Hunter <jonathanh@nvidia.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Guenter Roeck <linux@roeck-us.net>
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

Hi Alex,

On Wed, 12 May 2021 at 22:29, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> Hi Naresh,
>
> Thank you for the report!
>
> On 5/12/21 5:47 PM, Naresh Kamboju wrote:
> > On Wed, 12 May 2021 at 20:22, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> >> This is the start of the stable review cycle for the 5.4.119 release.
> >> There are 244 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >>
> >> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> >> Anything received after that time might be too late.
> >>
> >> The whole patch series can be found in one patch at:
> >>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.119-rc1.gz
> >> or in the git tree and branch at:
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> >> and the diffstat can be found below.
> >>
> >> thanks,
> >>
> >> greg k-h
> > Build regression detected.
> >
> >> Alexandru Elisei <alexandru.elisei@arm.com>
> >>     KVM: arm64: Initialize VCPU mdcr_el2 before loading it
> > stable rc 5.4 arm axm55xx_defconfig builds failed due to these
> > warnings / errors.
> >   - arm (axm55xx_defconfig) with gcc-8,9 and 10 failed
> >
> > arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_vcpu_first_run_init':
> > arch/arm/kvm/../../../virt/kvm/arm/arm.c:582:2: error: implicit
> > declaration of function 'kvm_arm_vcpu_init_debug'; did you mean
> > 'kvm_arm_init_debug'? [-Werror=implicit-function-declaration]
> >   kvm_arm_vcpu_init_debug(vcpu);
> >   ^~~~~~~~~~~~~~~~~~~~~~~
> >   kvm_arm_init_debug
> > cc1: some warnings being treated as errors
>
> This is my fault, in Linux v5.4 KVM for arm is still around, and there's no
> prototype for the function when compiling for arm. I suspect that's also the case
> for v4.19.
>
> I made this change to get it to build:
>
> $ git diff
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index dd03d5e01a94..32564b017ba0 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -335,6 +335,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu,
> int cpu) {}
>  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>
>  static inline void kvm_arm_init_debug(void) {}
> +static inline void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
>
> which matches the stub for kvm_arm_init_debug(). I can spin a patch out of it and
> send it for 5.4 and 4.19. Marc, what do you think?

FYI,
This proposed fix patch applied and built PASS on the arm.
(you may apply this patch for the next round of stable rc review)

- Naresh
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
