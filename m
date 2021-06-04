Return-Path: <SRS0=VfsR=K6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33B27C4708F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 14:51:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A5D5E613F4
	for <kvmarm@archiver.kernel.org>; Fri,  4 Jun 2021 14:51:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5D5E613F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E99F54B097;
	Fri,  4 Jun 2021 10:51:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8xz1YuD31Dob; Fri,  4 Jun 2021 10:51:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BD4A4B0BC;
	Fri,  4 Jun 2021 10:51:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C84084B0BC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 10:51:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n-uC7LpEXoOx for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Jun 2021 10:51:39 -0400 (EDT)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B36534B097
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Jun 2021 10:51:38 -0400 (EDT)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
 by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FxQZZ31Y7z1BHbD;
 Fri,  4 Jun 2021 22:46:46 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 22:51:32 +0800
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 22:51:31 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Fri, 4 Jun 2021 15:51:29 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [RFC PATCH 0/3] kvm/arm: New VMID allocator based on asid(2nd
 approach) 
Thread-Topic: [RFC PATCH 0/3] kvm/arm: New VMID allocator based on asid(2nd
 approach) 
Thread-Index: AQHXQph5pwodb0a/4kShAMz7Pnc+rqsDq0rQgABREYCAABlY4A==
Date: Fri, 4 Jun 2021 14:51:29 +0000
Message-ID: <95bb84ffdb0f4db3b64b38cc3b651f90@huawei.com>
References: <20210506165232.1969-1-shameerali.kolothum.thodi@huawei.com>
 <e62829990c50479292af94c4152011fc@huawei.com> <87sg1xzqea.wl-maz@kernel.org>
In-Reply-To: <87sg1xzqea.wl-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.88.52]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Linuxarm <linuxarm@huawei.com>, "will@kernel.org" <will@kernel.org>,
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

Hi Marc,

> -----Original Message-----
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: 04 June 2021 14:55
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> linux-kernel@vger.kernel.org; will@kernel.org; catalin.marinas@arm.com;
> james.morse@arm.com; julien.thierry.kdev@gmail.com;
> suzuki.poulose@arm.com; jean-philippe@linaro.org; Alexandru Elisei
> <Alexandru.Elisei@arm.com>; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [RFC PATCH 0/3] kvm/arm: New VMID allocator based on asid(2nd
> approach)
> 
> On Fri, 04 Jun 2021 09:13:10 +0100,
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> wrote:
> >
> > Hi,
> >
> > > -----Original Message-----
> > > From: Shameerali Kolothum Thodi
> > > Sent: 06 May 2021 17:52
> > > To: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> > > linux-kernel@vger.kernel.org
> > > Cc: maz@kernel.org; will@kernel.org; catalin.marinas@arm.com;
> > > james.morse@arm.com; julien.thierry.kdev@gmail.com;
> > > suzuki.poulose@arm.com; jean-philippe@linaro.org; Linuxarm
> > > <linuxarm@huawei.com>
> > > Subject: [RFC PATCH 0/3] kvm/arm: New VMID allocator based on asid(2nd
> > > approach)
> > >
> > > This is based on a suggestion from Will [0] to try out the asid
> > > based kvm vmid solution as a separate VMID allocator instead of
> > > the shared lib approach attempted in v4[1].
> > >
> > > The idea is to compare both the approaches and see whether the
> > > shared lib solution with callbacks make sense or not.
> >
> > A gentle ping on this. Please take a look and let me know.
> 
> I had a look and I don't overly dislike it. I'd like to see the code
> without the pinned stuff though, at least to ease the reviewing. I
> haven't tested it in anger, but I have pushed the rebased code at [1]
> as it really didn't apply to 5.13-rc4.

Thanks for taking a look and the rebase. I will remove the pinned stuff
in the next revision as that was added just to compare against the previous
version.

> 
> One thing I'm a bit worried about is that we so far relied on VMID 0
> never being allocated to a guest, which is now crucial for protected
> KVM. I can't really convince myself that this can never happen with
> this.

Hmm..not sure I quite follow that. As per the current logic vmid 0 is
reserved and is not allocated to Guest. 

> Plus, I've found this nugget:
> 
> <quote
> 	max_pinned_vmids = NUM_USER_VMIDS - num_possible_cpus() - 2;
> </quote>
> 
> What is this "- 2"? My hunch is that it should really be "- 1" as VMID
> 0 is reserved, and we have no equivalent of KPTI for S2.

I think this is more related to the "pinned vmid" stuff and was borrowed from
the asid_update_limit() fn in arch/arm64/mm/context.c. But I missed the
comment that explains the reason behind it. It says,

---x---
	/*
	 * There must always be an ASID available after rollover. Ensure that,
	 * even if all CPUs have a reserved ASID and the maximum number of ASIDs
	 * are pinned, there still is at least one empty slot in the ASID map.
	 */
	max_pinned_asids = num_available_asids - num_possible_cpus() - 2;
---x---

So this is to make sure we will have at least one VMID available after rollover
in case we have pinned the max number of VMIDs. I will include that comment
to make it clear.

Thanks,
Shameer

> 
> 	M.
> 
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h
> =kvm-arm64/mmu/vmid
> 
> --
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
