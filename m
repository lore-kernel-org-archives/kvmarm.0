Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E533EC4338F
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 13:48:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 28CEB60F25
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 13:48:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 28CEB60F25
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97E624B0FE;
	Mon,  9 Aug 2021 09:48:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tNxh50FUcOWp; Mon,  9 Aug 2021 09:48:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 546AF4B0EE;
	Mon,  9 Aug 2021 09:48:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E550D4B0E2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 09:48:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VucjxbF5qCPt for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 09:48:46 -0400 (EDT)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D6D64B0DC
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 09:48:46 -0400 (EDT)
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Gjy4X68kLz81kl;
 Mon,  9 Aug 2021 21:44:44 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 9 Aug 2021 21:48:39 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Mon, 9 Aug 2021 14:48:38 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Will Deacon <will@kernel.org>
Subject: RE: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU schedule out
Thread-Topic: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU schedule
 out
Thread-Index: AQHXhGar1JrryboKrU+7h+yU/0K2/6thny2AgAAaZCCAACXigIAAEl3QgAR0ioCABL+ZgIAAETIA
Date: Mon, 9 Aug 2021 13:48:37 +0000
Message-ID: <85b1c1a7861a4cb2a92fc87af800bf4c@huawei.com>
References: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
 <20210729104009.382-5-shameerali.kolothum.thodi@huawei.com>
 <20210803114034.GB30853@willie-the-truck>
 <ee2863107d614ef8a36006b5aa912eca@huawei.com>
 <20210803153036.GA31125@willie-the-truck>
 <b2146ea5db47485f8410a4c1ab0c15fe@huawei.com>
 <20210809130917.GA1207@willie-the-truck>
In-Reply-To: <20210809130917.GA1207@willie-the-truck>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.88.4]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Linuxarm <linuxarm@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
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



> -----Original Message-----
> From: Will Deacon [mailto:will@kernel.org]
> Sent: 09 August 2021 14:09
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> linux-kernel@vger.kernel.org; maz@kernel.org; catalin.marinas@arm.com;
> james.morse@arm.com; julien.thierry.kdev@gmail.com;
> suzuki.poulose@arm.com; jean-philippe@linaro.org;
> Alexandru.Elisei@arm.com; qperret@google.com; Linuxarm
> <linuxarm@huawei.com>
> Subject: Re: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU
> schedule out
> 
> On Fri, Aug 06, 2021 at 12:24:36PM +0000, Shameerali Kolothum Thodi
> wrote:
> > These are some test numbers with and without this patch, run on two
> > different test setups.
> >
> >
> > a)Test Setup -1
> > -----------------------
> >
> > Platform: HiSilicon D06 with 128 CPUs, VMID bits = 16
> > Run 128 VMs concurrently each with 2 vCPUs. Each Guest will execute
> hackbench
> > 5 times before exiting.
> >
> > Measurements taken avg. of 10 Runs.
> >
> > Image : 5.14-rc3
> > ---------------------------
> >   Time(s)       44.43813888
> >   No. of exits    145,348,264
> >
> > Image: 5.14-rc3 + vmid-v3
> > ----------------------------------------
> >   Time(s)        46.59789034
> >   No. of exits     133,587,307
> >
> > %diff against 5.14-rc3
> >   Time: 4.8% more
> >   Exits: 8% less
> >
> > Image: 5.14-rc3 + vmid-v3 + Without active_asid clear
> > ---------------------------------------------------------------------------
> >   Time(s)         44.5031782
> >   No. of exits      144,443,188
> >
> > %diff against 5.14-rc3
> >   Time: 0.15% more
> >   Exits: 2.42% less
> >
> > b)Test Setup -2
> > -----------------------
> >
> > Platform: HiSilicon D06 + Kernel with maxcpus set to 8 and VMID bits set to
> 4.
> > Run 40 VMs concurrently each with 2 vCPUs. Each Guest will execute
> hackbench
> > 5 times before exiting.
> >
> > Measurements taken avg. of 10 Runs.
> >
> > Image : 5.14-rc3-vmid4bit
> > ------------------------------------
> >   Time(s)        46.19963266
> >   No. of exits     23,699,546
> >
> > Image: 5.14-rc3-vmid4bit + vmid-v3
> > ---------------------------------------------------
> >   Time(s)          45.83307736
> >   No. of exits      23,260,203
> >
> > %diff against 5.14-rc3-vmid4bit
> >   Time: 0.8% less
> >   Exits: 1.85% less
> >
> > Image: 5.14-rc3-vmid4bit + vmid-v3 + Without active_asid clear
> > -----------------------------------------------------------------------------------------
> >   Time(s)           44.5031782
> >   No. of exits        144,443,188
> 
> Really? The *exact* same numbers as the "Image: 5.14-rc3 + vmid-v3 +
> Without
> active_asid clear" configuration? Guessing a copy-paste error here.
> 
> > %diff against 5.14-rc3-vmid4bit
> >   Time: 1.05% less
> >   Exits: 2.06% less
> >
> > As expected, the active_asid clear on schedule out is not helping.
> > But without this patch, the numbers seems to be better than the
> > vanilla kernel when we force the setup(cpus=8, vmd=4bits)
> > to perform rollover.
> 
> I'm struggling a bit to understand these numbers. Are you saying that
> clearing the active_asid helps in the 16-bit VMID case but not in the
> 4-bit case?

Nope, the other way around.. The point I was trying to make is that
clearing the active_vmids definitely have an impact in 16-bit vmid
case, where rollover is not happening, as it ends up taking the slow
path more frequently.

Test setup-1, case 2(with active_vmids clear): Around 4.8% more time
to finish the test compared to vanilla kernel.

Test setup-1, case 3(Without clear): 0.15% more time compared to
vanilla kernel.

For the 4-bit vmid case, the impact of clearing vmids is not that obvious
probably because we have more rollovers.

Test setup-2, case 2(with active_vmids clear):0.8% less time compared to vanilla.
Test setup-2, case 3(Without clear): 1.05% less time compared to vanilla kernel.
 
So between the two(with and without clearing the active_vmids), the "without" 
one has better numbers for both Test setups.

> Why would the active_asid clear have any impact on the number of exits?

In 16 bit vmid case, it looks like the no. of exits is considerably lower if we clear
active_vmids. . Not sure it is because of the frequent slow path or not. But anyway,
the time to finish the test is higher.
 
> The problem I see with not having the active_asid clear is that we will
> roll over more frequently as the number of reserved VMIDs increases.

Ok. The idea of running the 4-bit test setup was to capture that. It doesn't
look like it has a major impact when compared to the original kernel. May be
I should take an average of more test runs. Please let me know if there is a 
better way to measure that impact.

Hope, I am clear.

Thanks,
Shameer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
