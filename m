Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C0FC32773
	for <kvmarm@archiver.kernel.org>; Fri, 19 Aug 2022 09:44:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 825A84CCC9;
	Fri, 19 Aug 2022 05:44:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Qfg75aJNg+sY; Fri, 19 Aug 2022 05:44:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 416204CCCB;
	Fri, 19 Aug 2022 05:44:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C55324CCBD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2022 05:44:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qFT6a+91TKex for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Aug 2022 05:44:15 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 842574CCBC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2022 05:44:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1660902255;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=c1EVd0DFqKV0OYu8jHYuazH3XovyEoXq9DF8Sjm/ItA=;
 b=efmJwSRYtNdnXJBWnL9+Dwwkg6tNw+WyArygfW1bsxOdoSnRzimIJg4tOWMhY2XSMbLpiR
 cfxfRPgSepgbGswblLigUDEqWeRtbkJprwxXVi1Tf3oACee+7kpe4urQdqh70D2udDC0b9
 1x7GHIXCWcMj4d5ZgO+VGYcKlIRUgAg=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-251-BSZaWLmDMwKAuKInOIwm0w-1; Fri, 19 Aug 2022 05:44:13 -0400
X-MC-Unique: BSZaWLmDMwKAuKInOIwm0w-1
Received: by mail-lf1-f72.google.com with SMTP id
 a18-20020a19ca12000000b00492cd7c3f18so253219lfg.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Aug 2022 02:44:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc;
 bh=c1EVd0DFqKV0OYu8jHYuazH3XovyEoXq9DF8Sjm/ItA=;
 b=gnObVrnSBhRuqjLJrQZw5ATzK2/Htuvat8vayQmW1rcJ5eS3Xfpwq1cteZiMhb4s26
 HcgLQcm4Iv5cCD5gQDjBsQYKYO1OPty0ml8O0vS++s3FWHfBuWy/IZ3DBSHx6KK0pQwK
 q7KJUmF7tIfVldIRXas5Pupaxq8oW261nLKIXe7pkVcqq9bANjgUNK9mTaQFlRHuvd5K
 aVy488gJMbbKXIJsFOLYC/W1t3lWvlmRY8gNTjsspMDNuWVOuUUPra1daJgco+FbZroD
 6VRk570vMFUp/s5Pr3QSyTau9nuZI5mNlSAsYQL9ry+hEU/7Ne85ugzojpVJEUCNEfEp
 8UtQ==
X-Gm-Message-State: ACgBeo0ZH/utW3/TRNkYSMbwnNWVeRBKUGgLmYhIPI4pXKb5BIYkn+i9
 hPkgFLvTDOq92VjRZHMYqADDZs4YWG6viamYse+Ialg8R4QY4Y+MJW2Xltc/9ff2lJGTqCPHEIE
 LuhZZakkjldnn6dPuWHzaDkolYuJgDiT7NU0cvLYP
X-Received: by 2002:a2e:a98b:0:b0:25f:d9e9:588d with SMTP id
 x11-20020a2ea98b000000b0025fd9e9588dmr1993613ljq.205.1660902251962; 
 Fri, 19 Aug 2022 02:44:11 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5OG8h2APd6wlol2n03VyKpahOJJDriZrSFHpdhhHl4YapoZP5eP/Gj/YrjIbyqXVoog9BENLVnLWqv7Zaqqb8=
X-Received: by 2002:a2e:a98b:0:b0:25f:d9e9:588d with SMTP id
 x11-20020a2ea98b000000b0025fd9e9588dmr1993594ljq.205.1660902251667; Fri, 19
 Aug 2022 02:44:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220818140844.2312534-1-maz@kernel.org>
In-Reply-To: <20220818140844.2312534-1-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 19 Aug 2022 11:44:00 +0200
Message-ID: <CABgObfY-sJug_UG8rp4nDOuDEpLvjEQFU1EROT72oO=0GZR67Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.0, take #1
To: Marc Zyngier <maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: kvm@vger.kernel.org, kernel-team@android.com,
 Yang Yingliang <yangyingliang@huawei.com>, kvmarm@lists.cs.columbia.edu,
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

Pulled, thanks.

Paolo

On Thu, Aug 18, 2022 at 4:09 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's a small set of KVM/arm64 fixes for 6.0, the most visible thing
> being a better handling of systems with asymmetric AArch32 support.
>
> Please pull,
>
>         M.
>
> The following changes since commit 0982c8d859f8f7022b9fd44d421c7ec721bb41f9:
>
>   Merge branch kvm-arm64/nvhe-stacktrace into kvmarm-master/next (2022-07-27 18:33:27 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.0-1
>
> for you to fetch changes up to b10d86fb8e46cc812171728bcd326df2f34e9ed5:
>
>   KVM: arm64: Reject 32bit user PSTATE on asymmetric systems (2022-08-17 10:29:07 +0100)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.0, take #1
>
> - Fix unexpected sign extension of KVM_ARM_DEVICE_ID_MASK
>
> - Tidy-up handling of AArch32 on asymmetric systems
>
> ----------------------------------------------------------------
> Oliver Upton (2):
>       KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric systems
>       KVM: arm64: Reject 32bit user PSTATE on asymmetric systems
>
> Yang Yingliang (1):
>       KVM: arm64: Fix compile error due to sign extension
>
>  arch/arm64/include/asm/kvm_host.h | 4 ++++
>  arch/arm64/include/uapi/asm/kvm.h | 6 ++++--
>  arch/arm64/kvm/arm.c              | 3 +--
>  arch/arm64/kvm/guest.c            | 2 +-
>  arch/arm64/kvm/sys_regs.c         | 4 ++--
>  5 files changed, 12 insertions(+), 7 deletions(-)
>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
