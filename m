Return-Path: <SRS0=HxNd=6C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A48C2D0EF
	for <kvmarm@archiver.kernel.org>; Sat, 18 Apr 2020 11:53:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 312F620780
	for <kvmarm@archiver.kernel.org>; Sat, 18 Apr 2020 11:53:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 312F620780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=hisilicon.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EB7D4B162;
	Sat, 18 Apr 2020 07:53:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PNBUxYxeHszX; Sat, 18 Apr 2020 07:53:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E37A44B1F1;
	Sat, 18 Apr 2020 07:53:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E24634B250
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 22:49:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1DPmEJ35pI+h for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 22:49:30 -0400 (EDT)
Received: from huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C46CA4B228
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 22:49:29 -0400 (EDT)
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.56])
 by Forcepoint Email with ESMTP id 97116A319AD7B1B2AC2E;
 Sat, 18 Apr 2020 10:49:25 +0800 (CST)
Received: from DGGEMM526-MBX.china.huawei.com ([169.254.8.234]) by
 DGGEMM406-HUB.china.huawei.com ([10.3.20.214]) with mapi id 14.03.0487.000;
 Sat, 18 Apr 2020 10:49:24 +0800
From: "Zengtao (B)" <prime.zeng@hisilicon.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Thread-Topic: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Thread-Index: AdYJhvrCKEKaxySRQua1lfr4U9NN2v//iESA//MqKcCAGX9aAP/4ImVggBBPsoCAAVt7AP/+wAyA
Date: Sat, 18 Apr 2020 02:49:23 +0000
Message-ID: <678F3D1BB717D949B966B68EAEB446ED3A545C71@dggemm526-mbx.china.huawei.com>
References: <MN2PR18MB26869A6CA4E67558324F655CC5C70@MN2PR18MB2686.namprd18.prod.outlook.com>
 <06d08f904f003160a48eac3c5ab3c7ff@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED342E29B9@dggemm526-mbx.china.huawei.com>
 <86r1wus7df.wl-maz@kernel.org>
 <678F3D1BB717D949B966B68EAEB446ED3A535FCF@DGGEMM506-MBX.china.huawei.com>
 <3e84aaf8b757bc5a7685a291e54c232b@kernel.org> <20200417160602.26706917@why>
In-Reply-To: <20200417160602.26706917@why>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.221.187]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Sat, 18 Apr 2020 07:53:20 -0400
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 Ganapatrao Kulkarni <gkulkarni@marvell.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "andre.przywara@arm.com" <andre.przywara@arm.com>,
 George Cherian <gcherian@marvell.com>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Anil Kumar Reddy H <areddy3@marvell.com>,
 "Dave.Martin@arm.com" <Dave.Martin@arm.com>
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

 -----Original Message-----
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: Friday, April 17, 2020 11:06 PM
> To: Zengtao (B)
> Cc: George Cherian; Dave.Martin@arm.com; alexandru.elisei@arm.com;
> andre.przywara@arm.com; christoffer.dall@arm.com;
> james.morse@arm.com; jintack@cs.columbia.edu;
> julien.thierry.kdev@gmail.com; kvm@vger.kernel.org;
> kvmarm@lists.cs.columbia.edu; linux-arm-kernel@lists.infradead.org;
> suzuki.poulose@arm.com; Anil Kumar Reddy H; Ganapatrao Kulkarni
> Subject: Re: [PATCH v2 00/94] KVM: arm64: ARMv8.3/8.4 Nested
> Virtualization support
> 
> On Thu, 16 Apr 2020 19:22:21 +0100
> Marc Zyngier <maz@kernel.org> wrote:
> 
> > Hi Zengtao,
> >
> > On 2020-04-16 02:38, Zengtao (B) wrote:
> > > Hi Marc:
> > >
> > > Got it.
> > > Really a bit patch set :)
> >
> > Well, yeah... ;-)
> >
> > >
> > > BTW, I have done a basic kvm unit test
> > > git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git
> > > And I find that after apply the patch KVM: arm64: VNCR-ize ELR_EL1,
> > > The psci test failed for some reason, I can't understand why, this
> > > is only the test result.(find the patch by git bisect + kvm test)
> >
> > That it is that mechanical, we should be able to quickly nail that one.
> >
> > > My platform: Hisilicon D06 board.
> > > Linux kernel: Linux 5.6-rc6 + nv patches(some rebases)
> > > Could you help to take a look?
> >
> > I'll have a look tomorrow. I'm in the middle of refactoring the series
> > for 5.7, and things have changed quite a bit. Hopefully this isn't a VHE
> > vs non-VHE issue.
> 
> So I've repeatedly tried with the current state of the NV patches[1],
> on both an ARMv8.0 system (Seattle) and an ARMv8.2 pile of putrid junk
> (vim3l). PSCI is pretty happy, although I can only test with at most 8
> vcpus (GICv2 gets in the way).
> 
> Can you please:
> 
> - post the detailed error by running the PSCI unit test on its own
I tried to trace the error, and I found in kernel function kvm_mpidr_to_vcpu,
casually, mpidr returns zero and we can't get the expected vcpu, and psci
 test failed due to this.
And as I mentioned in my last before, the psci error is introduced by the
 patch KVM: arm64: VNCR-ize ELR_EL1.(Only test result)
Maybe you have to try tens of times to reproduce. :)
Deep into the patch itself, I don't find any connection between the patch
and the issue.

> - test with the current state of the patches
I test with your nv-5.7-rc1-WIP branch and latest kvm_unit_test, the 
error still exist.

Thanks.
zengtao

> 


> Thanks,
> 
> 	M.
> 
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/l
> og/?h=kvm-arm64/nv-5.7-rc1-WIP
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
