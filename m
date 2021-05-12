Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F31C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 18:54:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2369F613B9
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 18:54:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2369F613B9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 689C94B516;
	Wed, 12 May 2021 14:54:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cJYoJ-J5h+No; Wed, 12 May 2021 14:54:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BC5B4B52E;
	Wed, 12 May 2021 14:54:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 129C74B516
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 14:54:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8xswTBQgo4ty for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 14:54:01 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AA5BB4B515
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 14:54:01 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5311611BD;
 Wed, 12 May 2021 18:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1620845640;
 bh=0v11jeez54FneOK7W+JHdJ88FtBJC12awhEy2sMyl+w=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=LQAx1WTbfrd/rYLoXyh97Re6e8HL2bqQzU+eQCqTCzTTP0Q+E0hx68NMBmgnFxyp5
 Yd53+drZw06vxLeL8HUpQrWNg7YlzEdtRqctl8gtLwAX9uOuGSy/MWHrro4Kwk2XFw
 7Je5lxvRZL6MXHonw/Fvnx0+J++J4KmtdMgP2Gl8=
Date: Wed, 12 May 2021 20:53:57 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 5.4 000/244] 5.4.119-rc1 review
Message-ID: <YJwkRS20XCeVcIox@kroah.com>
References: <20210512144743.039977287@linuxfoundation.org>
 <CA+G9fYs1AH8ZNWMJ=H4TY5C6bqp--=SZfW9P=WbB85qSBDkuXw@mail.gmail.com>
 <b7df0d7f-e582-6a0d-2385-b9fce50f9106@arm.com>
 <87h7j7opg2.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87h7j7opg2.wl-maz@kernel.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Florian Fainelli <f.fainelli@gmail.com>,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, May 12, 2021 at 06:02:37PM +0100, Marc Zyngier wrote:
> On Wed, 12 May 2021 18:00:16 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > =

> > Hi Naresh,
> > =

> > Thank you for the report!
> > =

> > On 5/12/21 5:47 PM, Naresh Kamboju wrote:
> > > On Wed, 12 May 2021 at 20:22, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > >> This is the start of the stable review cycle for the 5.4.119 release.
> > >> There are 244 patches in this series, all will be posted as a respon=
se
> > >> to this one.  If anyone has any issues with these being applied, ple=
ase
> > >> let me know.
> > >>
> > >> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> > >> Anything received after that time might be too late.
> > >>
> > >> The whole patch series can be found in one patch at:
> > >>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/p=
atch-5.4.119-rc1.gz
> > >> or in the git tree and branch at:
> > >>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-s=
table-rc.git linux-5.4.y
> > >> and the diffstat can be found below.
> > >>
> > >> thanks,
> > >>
> > >> greg k-h
> > > Build regression detected.
> > >
> > >> Alexandru Elisei <alexandru.elisei@arm.com>
> > >>     KVM: arm64: Initialize VCPU mdcr_el2 before loading it
> > > stable rc 5.4 arm axm55xx_defconfig builds failed due to these
> > > warnings / errors.
> > >   - arm (axm55xx_defconfig) with gcc-8,9 and 10 failed
> > >
> > > arch/arm/kvm/../../../virt/kvm/arm/arm.c: In function 'kvm_vcpu_first=
_run_init':
> > > arch/arm/kvm/../../../virt/kvm/arm/arm.c:582:2: error: implicit
> > > declaration of function 'kvm_arm_vcpu_init_debug'; did you mean
> > > 'kvm_arm_init_debug'? [-Werror=3Dimplicit-function-declaration]
> > >   kvm_arm_vcpu_init_debug(vcpu);
> > >   ^~~~~~~~~~~~~~~~~~~~~~~
> > >   kvm_arm_init_debug
> > > cc1: some warnings being treated as errors
> > =

> > This is my fault, in Linux v5.4 KVM for arm is still around, and
> > there's no prototype for the function when compiling for arm. I
> > suspect that's also the case for v4.19.
> > =

> > I made this change to get it to build:
> > =

> > $ git diff
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm=
_host.h
> > index dd03d5e01a94..32564b017ba0 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -335,6 +335,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcp=
u *vcpu,
> > int cpu) {}
> > =A0static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu)=
 {}
> > =A0
> > =A0static inline void kvm_arm_init_debug(void) {}
> > +static inline void kvm_arm_vcpu_init_debug(struct kvm_vcpu *vcpu) {}
> > =A0static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
> > =A0static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
> > =A0static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
> > =

> > which matches the stub for kvm_arm_init_debug(). I can spin a patch
> > out of it and send it for 5.4 and 4.19. Marc, what do you think?
> =

> Ideally, we'd drop the patch in its current form from 5.4 and 4.19,
> and send an updated patch with this hunk to fix the 32bit build.
> =


That would be great.  Do you want to do it for this set of releases
(i.e. today/tomorrow) or have me just drop this now and someone will
send me an updated version later when they get a chance?

thanks,

greg k-h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
