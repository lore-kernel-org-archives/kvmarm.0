Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70296C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 17:03:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A1ADD61285
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 17:03:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A1ADD61285
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 155AA4B3AD;
	Wed, 12 May 2021 13:03:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vX2MZzwlwRzS; Wed, 12 May 2021 13:03:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48F0D4B516;
	Wed, 12 May 2021 13:03:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 609AA4B3AD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 13:03:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AUYJ0TtnzwxW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 13:03:53 -0400 (EDT)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com
 [209.85.210.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC6654B20E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 13:03:53 -0400 (EDT)
Received: by mail-ot1-f44.google.com with SMTP id
 t4-20020a05683014c4b02902ed26dd7a60so11043922otq.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 10:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=GQY3BWbMy9+/6V8xt2qeBB5wUj+Dk0xC8e1RwDTKwgY=;
 b=ABbmoiaLS7kWwiM1hNQv32Kxv5Wf5VEttMvkx/HieokwPGCGeGP+/e0OXYr1WLwWeE
 X+IQARzf+g3ordHnEf9eLN54QPlIz4oCRY0XGslthb+grNmd5jGBG25lmHfuxPvvwIsI
 8n8/G8SbPu+HXalO7YVnrme56eh7vKNtU7hBcuWNH2xWxm7FdeO1e6/Gjo5PIv+l2nkg
 ymG5MNGLycWt2g19jyw3qvztdOGoLN/ohm13YseJGdl56y57yP4mH2SgrRhdeFHDbE/e
 89YJB4otzkNs4j8UJM1u7L37q6YuNbzbzKKWid2/d35f9ok5kY28vUt9V5Nls3UGxA5g
 j19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
 :references:mime-version:content-disposition
 :content-transfer-encoding:in-reply-to;
 bh=GQY3BWbMy9+/6V8xt2qeBB5wUj+Dk0xC8e1RwDTKwgY=;
 b=XwGXWa0JMoGd2fv8t02WyDeGL5U6ZPKsyqUUNMB4h2cF1+rSOC1W3IBowgDd03LXZG
 NIqjpkupzQNjaQQUBYOd3jFT/LUuQF/Pfb+EASlYeTrJ0z+XOssEjsz5WqBOvX0i8b9g
 r9s7DNXsJLCMCSdjQF9h9XrgzhCpo8gVfYHvPRxtNVe7C8uja+tlktGjmiSdIQ6SvPBw
 3LgXfzn7zJvvuB/VT4Q+6kD85wrmt2Gl4hA2shLPfywhGi6ikz1ZVae56J5fxtsXtBRE
 XcwDEQtbbtO7GdYl1XUFOey9wjxPGx5j9SzRqVgKfVfD+J60pg4WLAROU/13CNh72MxH
 bY6g==
X-Gm-Message-State: AOAM533tU0ZpFS/AQUyRmzed9nRtf2Own4I/Ro3D9HaR1Mo2tz3DBp+T
 uU5YqyohROTKIVkJoKWObUk=
X-Google-Smtp-Source: ABdhPJze1icLTqJpnsPuqAWyMdwpAW0H8Px+lIVDzFprpriTmtx+5+uJinwOMyRsrv3BiXr4Mxs34A==
X-Received: by 2002:a05:6830:803:: with SMTP id
 r3mr27456804ots.237.1620839033196; 
 Wed, 12 May 2021 10:03:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
 by smtp.gmail.com with ESMTPSA id c65sm87223oia.47.2021.05.12.10.03.51
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 12 May 2021 10:03:52 -0700 (PDT)
Date: Wed, 12 May 2021 10:03:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
Message-ID: <20210512170350.GA1277039@roeck-us.net>
References: <20210512144743.039977287@linuxfoundation.org>
 <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
 <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org,
 patches@kernelci.org, Linus Torvalds <torvalds@linux-foundation.org>,
 linux-stable <stable@vger.kernel.org>, Pavel Machek <pavel@denx.de>,
 Andrew Morton <akpm@linux-foundation.org>, Jon Hunter <jonathanh@nvidia.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, May 12, 2021 at 06:00:16PM +0100, Alexandru Elisei wrote:
> Hi Naresh,
> =

> Thank you for the report!
> =

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
> >>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/pat=
ch-5.4.119-rc1.gz
> >> or in the git tree and branch at:
> >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git linux-5.4.y
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
> > arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_vcpu_first_r=
un_init':
> > arch/arm/kvm/../../../virt/kvm/arm/arm.c:582:2: error: implicit
> > declaration of function 'kvm_arm_vcpu_init_debug'; did you mean
> > 'kvm_arm_init_debug'? [-Werror=3Dimplicit-function-declaration]
> >   kvm_arm_vcpu_init_debug(vcpu);
> >   ^~~~~~~~~~~~~~~~~~~~~~~
> >   kvm_arm_init_debug
> > cc1: some warnings being treated as errors
> =

> This is my fault, in Linux v5.4 KVM for arm is still around, and there's =
no
> prototype for the function when compiling for arm. I suspect that's also =
the case
> for v4.19.
> =


Correct.

Guenter

> I made this change to get it to build:
> =

> $ git diff
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_h=
ost.h
> index dd03d5e01a94..32564b017ba0 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -335,6 +335,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu =
*vcpu,
> int cpu) {}
> =A0static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> =A0
> =A0static inline void kvm_arm_init_debug(void) {}
> +static inline void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu) {}
> =A0static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
> =A0static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
> =A0static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
> =

> which matches the stub for kvm_arm_init_debug(). I can spin a patch out o=
f it and
> send it for 5.4 and 4.19. Marc, what do you think?
> =

> Thanks,
> =

> Alex
> =

> >
> >
> > steps to reproduce:
> > --------------------
> > #!/bin/sh
> >
> > # TuxMake is a command line tool and Python library that provides
> > # portable and repeatable Linux kernel builds across a variety of
> > # architectures, toolchains, kernel configurations, and make targets.
> > #
> > # TuxMake supports the concept of runtimes.
> > # See https://docs.tuxmake.org/runtimes/, for that to work it requires
> > # that you install podman or docker on your system.
> > #
> > # To install tuxmake on your system globally:
> > # sudo pip3 install -U tuxmake
> > #
> > # See https://docs.tuxmake.org/ for complete documentation.
> >
> >
> > tuxmake --runtime podman --target-arch arm --toolchain gcc-8 --kconfig
> > axm55xx_defconfig
> >
> > ref:
> > https://builds.tuxbuild.com/1sRT0HOyHnZ8N5ktJmaEcMIQZL0/
> >
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
