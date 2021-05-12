Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC070C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 16:48:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B3D461177
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 16:48:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B3D461177
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A5914B500;
	Wed, 12 May 2021 12:48:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xcZdnxRC22Mt; Wed, 12 May 2021 12:48:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51E674B519;
	Wed, 12 May 2021 12:48:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAFF64B500
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 12:47:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v8yGqPjIXZnf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 12:47:57 -0400 (EDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com
 [209.85.208.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8CD164B20C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 12:47:57 -0400 (EDT)
Received: by mail-ed1-f53.google.com with SMTP id t15so182694edr.11
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 09:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=JLDlceFPG4F0Fb3dNmzA+5MCXXJnN0q1C9HnPLqxGao=;
 b=JzN0isVmUOucKzUKjur/vn33DhCU89F/fH1BSSc5FQmte51dxAY2hw/9FG1hIp887h
 YNlOP5aE5/xQfni49iOo2ZpX9ZEk7bBOhlQQmHkjmNg58xN3MezOnQ6ocZCzSkNGZNKM
 8cvZq6P9kIBbQZAlw/oTJhLswznEGMSNGeGcZsqAOu6iA1+Isx546PrPPKBHXoQmTc3p
 JdUm3DffBX3wu8GZb3lmlSS1HdpW/oVEtDzuF7tSPsLxSzDrpE9o6fagffn31l+TK+PP
 RqQeMwJiwLUBiJKAIBMotEJGeDemsLjxIfMmdVwcpJdtFE8dN+w0G24h1Ujex1/2QwZ4
 7FGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=JLDlceFPG4F0Fb3dNmzA+5MCXXJnN0q1C9HnPLqxGao=;
 b=W21bObUwI3PfVW/DFK9rXgnVq9PB8tUl4Yuery9F1a7slyYyHlXBYT3kirHJp0F3rg
 uJDAIfoRT1KcPvBJNBrNAksiiKjZprPd3COsAqEUdBoa7uuYfSH7mKkoNYzcIUpvhNJW
 t393gsDz0DJ0plNC1zYfpCuYw9VkSPLKpR0SqGuISxRWfD+TE6eEYdcwZdOv8BmsnBOO
 BEhjPQHsKiZsxOGEHcA/GDXag0SVnP/WcMQO6nagFsfU8A+h0YW7L1fIkObk4WxElixS
 vf0q0g+tBwQSZ0AMeCys4Nn9OOW+ORJ5Fs8ykHRxkdou9/EfbvAvxwyMZ7bv3Re03oRN
 fzCw==
X-Gm-Message-State: AOAM5301caQF8fsVYXUpoz2ceYyJBqWw6D0N3XxlAUFb4KAzk/be2mp1
 YP1R0dO+RviDuaMUbg9oerzL6JI0D709igukGx4EPg==
X-Google-Smtp-Source: ABdhPJyRZZ/2wFYuQ59+lzOy/ODmfJDP4HsKhPf+qtv1rThZSJPRW9sq7+R/GFBeQlTmuP+XhNbOkyQHO6bH3wh/JvM=
X-Received: by 2002:aa7:cd4a:: with SMTP id v10mr38037505edw.239.1620838076182; 
 Wed, 12 May 2021 09:47:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144743.039977287@linuxfoundation.org>
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 12 May 2021 22:17:44 +0530
Message-ID: <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 Pavel Machek <pavel@denx.de>, open list <linux-kernel@vger.kernel.org>,
 lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linux-stable <stable@vger.kernel.org>, patches@kernelci.org,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Guenter Roeck <linux@roeck-us.net>
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

On Wed, 12 May 2021 at 20:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.119 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.119-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build regression detected.

> Alexandru Elisei <alexandru.elisei@arm.com>
>     KVM: arm64: Initialize VCPU mdcr_el2 before loading it

stable rc 5.4 arm axm55xx_defconfig builds failed due to these
warnings / errors.
  - arm (axm55xx_defconfig) with gcc-8,9 and 10 failed

arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_vcpu_first_run_init':
arch/arm/kvm/../../../virt/kvm/arm/arm.c:582:2: error: implicit
declaration of function 'kvm_arm_vcpu_init_debug'; did you mean
'kvm_arm_init_debug'? [-Werror=implicit-function-declaration]
  kvm_arm_vcpu_init_debug(vcpu);
  ^~~~~~~~~~~~~~~~~~~~~~~
  kvm_arm_init_debug
cc1: some warnings being treated as errors


steps to reproduce:
--------------------
#!/bin/sh

# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.


tuxmake --runtime podman --target-arch arm --toolchain gcc-8 --kconfig
axm55xx_defconfig

ref:
https://builds.tuxbuild.com/1sRT0HOyHnZ8N5ktJmaEcMIQZL0/


--
Linaro LKFT
https://lkft.linaro.org
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
