Return-Path: <SRS0=sKrJ=M5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D45B9C4338F
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 12:24:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46A1F6113C
	for <kvmarm@archiver.kernel.org>; Fri,  6 Aug 2021 12:24:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 46A1F6113C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B639B4B0D2;
	Fri,  6 Aug 2021 08:24:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QLuKA2+nu5qw; Fri,  6 Aug 2021 08:24:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83F884B0D5;
	Fri,  6 Aug 2021 08:24:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDAD54B0D2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 08:24:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r5tLGOFP+UyU for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Aug 2021 08:24:45 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF7C84B0CA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Aug 2021 08:24:44 -0400 (EDT)
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Gh4Mr5HQgzmnmx;
 Fri,  6 Aug 2021 20:21:28 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 20:24:38 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Fri, 6 Aug 2021 13:24:36 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Will Deacon <will@kernel.org>
Subject: RE: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU schedule out
Thread-Topic: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU schedule
 out
Thread-Index: AQHXhGar1JrryboKrU+7h+yU/0K2/6thny2AgAAaZCCAACXigIAAEl3QgAR0ioA=
Date: Fri, 6 Aug 2021 12:24:36 +0000
Message-ID: <b2146ea5db47485f8410a4c1ab0c15fe@huawei.com>
References: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
 <20210729104009.382-5-shameerali.kolothum.thodi@huawei.com>
 <20210803114034.GB30853@willie-the-truck>
 <ee2863107d614ef8a36006b5aa912eca@huawei.com>
 <20210803153036.GA31125@willie-the-truck> 
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.89.202]
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
> From: Shameerali Kolothum Thodi
> Sent: 03 August 2021 16:57
> To: 'Will Deacon' <will@kernel.org>
> Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> linux-kernel@vger.kernel.org; maz@kernel.org; catalin.marinas@arm.com;
> james.morse@arm.com; julien.thierry.kdev@gmail.com;
> suzuki.poulose@arm.com; jean-philippe@linaro.org;
> Alexandru.Elisei@arm.com; qperret@google.com; Linuxarm
> <linuxarm@huawei.com>
> Subject: RE: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU
> schedule out
> 
> 
> 
> > -----Original Message-----
> > From: Will Deacon [mailto:will@kernel.org]
> > Sent: 03 August 2021 16:31
> > To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> > Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> > linux-kernel@vger.kernel.org; maz@kernel.org; catalin.marinas@arm.com;
> > james.morse@arm.com; julien.thierry.kdev@gmail.com;
> > suzuki.poulose@arm.com; jean-philippe@linaro.org;
> > Alexandru.Elisei@arm.com; qperret@google.com; Linuxarm
> > <linuxarm@huawei.com>
> > Subject: Re: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU
> > schedule out
> >
> > On Tue, Aug 03, 2021 at 12:55:25PM +0000, Shameerali Kolothum Thodi
> > wrote:
> > > > > diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
> > > > > index 5584e84aed95..5fd51f5445c1 100644
> > > > > --- a/arch/arm64/kvm/vmid.c
> > > > > +++ b/arch/arm64/kvm/vmid.c
> > > > > @@ -116,6 +116,12 @@ static u64 new_vmid(struct kvm_vmid
> > > > *kvm_vmid)
> > > > >  	return idx2vmid(vmid) | generation;
> > > > >  }
> > > > >
> > > > > +/* Call with preemption disabled */
> > > > > +void kvm_arm_vmid_clear_active(void)
> > > > > +{
> > > > > +	atomic64_set(this_cpu_ptr(&active_vmids), 0);
> > > > > +}
> > > >
> > > > I think this is very broken, as it will force everybody to take the
> > > > slow-path when they see an active_vmid of 0.
> > >
> > > Yes. I have seen that happening in my test setup.
> >
> > Why didn't you say so?!
> 
> Sorry. I thought of getting some performance numbers with and
> without this patch and measure the impact. But didn't quite get time
> to finish it yet.

These are some test numbers with and without this patch, run on two
different test setups.


a)Test Setup -1
-----------------------

Platform: HiSilicon D06 with 128 CPUs, VMID bits = 16
Run 128 VMs concurrently each with 2 vCPUs. Each Guest will execute hackbench
5 times before exiting.

Measurements taken avg. of 10 Runs.

Image : 5.14-rc3
---------------------------
  Time(s)       44.43813888
  No. of exits    145,348,264

Image: 5.14-rc3 + vmid-v3
----------------------------------------
  Time(s)        46.59789034
  No. of exits     133,587,307

%diff against 5.14-rc3
  Time: 4.8% more
  Exits: 8% less 

Image: 5.14-rc3 + vmid-v3 + Without active_asid clear
---------------------------------------------------------------------------
  Time(s)         44.5031782
  No. of exits      144,443,188

%diff against 5.14-rc3
  Time: 0.15% more
  Exits: 2.42% less

b)Test Setup -2
-----------------------

Platform: HiSilicon D06 + Kernel with maxcpus set to 8 and VMID bits set to 4.
Run 40 VMs concurrently each with 2 vCPUs. Each Guest will execute hackbench
5 times before exiting.

Measurements taken avg. of 10 Runs.

Image : 5.14-rc3-vmid4bit
------------------------------------
  Time(s)        46.19963266
  No. of exits     23,699,546

Image: 5.14-rc3-vmid4bit + vmid-v3
---------------------------------------------------
  Time(s)          45.83307736
  No. of exits      23,260,203

%diff against 5.14-rc3-vmid4bit
  Time: 0.8% less
  Exits: 1.85% less 

Image: 5.14-rc3-vmid4bit + vmid-v3 + Without active_asid clear
-----------------------------------------------------------------------------------------
  Time(s)           44.5031782
  No. of exits        144,443,188

%diff against 5.14-rc3-vmid4bit
  Time: 1.05% less
  Exits: 2.06% less

As expected, the active_asid clear on schedule out is not helping.
But without this patch, the numbers seems to be better than the
vanilla kernel when we force the setup(cpus=8, vmd=4bits)
to perform rollover.

Please let me know your thoughts.

Thanks,
Shameer

> 
> >
> > > > It also doesn't solve the issue I mentioned before, as an active_vmid of 0
> > > > means that the reserved vmid is preserved.
> > > >
> > > > Needs more thought...
> > >
> > > How about we clear all the active_vmids in kvm_arch_free_vm() if it
> > > matches the kvm_vmid->id ? But we may have to hold the lock
> > > there
> >
> > I think we have to be really careful not to run into the "suspended
> > animation" problem described in ae120d9edfe9 ("ARM: 7767/1: let the ASID
> > allocator handle suspended animation") if we go down this road.
> 
> 
> Ok. I will go through that.
> 
> > Maybe something along the lines of:
> >
> > ROLLOVER
> >
> >   * Take lock
> >   * Inc generation
> >     => This will force everybody down the slow path
> >   * Record active VMIDs
> >   * Broadcast TLBI
> >     => Only active VMIDs can be dirty
> >     => Reserve active VMIDs and mark as allocated
> >
> > VCPU SCHED IN
> >
> >   * Set active VMID
> >   * Check generation
> >   * If mismatch then:
> >         * Take lock
> >         * Try to match a reserved VMID
> >         * If no reserved VMID, allocate new
> >
> > VCPU SCHED OUT
> >
> >   * Clear active VMID
> >
> > but I'm not daft enough to think I got it right first time. I think it
> > needs both implementing *and* modelling in TLA+ before we merge it!
> >
> 
> Ok. I need some time to digest the above first :).
> 
> On another note, how serious do you think is the problem of extra
> reservation of the VMID space? Just wondering if we can skip this
> patch for now or not..
> 
> Thanks,
> Shameer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
