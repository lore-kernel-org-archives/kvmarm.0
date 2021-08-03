Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2C7C4338F
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 12:13:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 454D160F35
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 12:13:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 454D160F35
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B70040825;
	Tue,  3 Aug 2021 08:13:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e+RRuVPorm9N; Tue,  3 Aug 2021 08:13:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59FE940856;
	Tue,  3 Aug 2021 08:13:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E23BD40825
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 08:13:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 120vx73ZUAtG for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 08:12:58 -0400 (EDT)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15F8240413
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 08:12:58 -0400 (EDT)
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4GfDDt5Bwfz81l7;
 Tue,  3 Aug 2021 20:09:02 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 3 Aug 2021 20:12:52 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Tue, 3 Aug 2021 13:12:49 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Will Deacon <will@kernel.org>
Subject: RE: [PATCH v3 1/4] KVM: arm64: Introduce a new VMID allocator for KVM
Thread-Topic: [PATCH v3 1/4] KVM: arm64: Introduce a new VMID allocator for KVM
Thread-Index: AQHXhGab640eJKj5GkyvLUvpg3vhNathnrgAgAAZP8A=
Date: Tue, 3 Aug 2021 12:12:49 +0000
Message-ID: <318d2eaad3864fdf84ea6d14218a10e1@huawei.com>
References: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
 <20210729104009.382-2-shameerali.kolothum.thodi@huawei.com>
 <20210803113856.GA30853@willie-the-truck>
In-Reply-To: <20210803113856.GA30853@willie-the-truck>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.86.18]
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
> Sent: 03 August 2021 12:39
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> linux-kernel@vger.kernel.org; maz@kernel.org; catalin.marinas@arm.com;
> james.morse@arm.com; julien.thierry.kdev@gmail.com;
> suzuki.poulose@arm.com; jean-philippe@linaro.org;
> Alexandru.Elisei@arm.com; qperret@google.com; Linuxarm
> <linuxarm@huawei.com>
> Subject: Re: [PATCH v3 1/4] KVM: arm64: Introduce a new VMID allocator for
> KVM
> 
> On Thu, Jul 29, 2021 at 11:40:06AM +0100, Shameer Kolothum wrote:
> > A new VMID allocator for arm64 KVM use. This is based on
> > arm64 ASID allocator algorithm.
> >
> > One major deviation from the ASID allocator is the way we
> > flush the context. Unlike ASID allocator, we expect less
> > frequent rollover in the case of VMIDs. Hence, instead of
> > marking the CPU as flush_pending and issuing a local context
> > invalidation on the next context switch, we broadcast TLB
> > flush + I-cache invalidation over the inner shareable domain
> > on rollover.
> >
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> 
> [...]
> 
> > +void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
> > +{
> > +	unsigned long flags;
> > +	unsigned int cpu;
> > +	u64 vmid, old_active_vmid;
> > +
> > +	vmid = atomic64_read(&kvm_vmid->id);
> > +
> > +	/*
> > +	 * Please refer comments in check_and_switch_context() in
> > +	 * arch/arm64/mm/context.c.
> > +	 */
> > +	old_active_vmid = atomic64_read(this_cpu_ptr(&active_vmids));
> > +	if (old_active_vmid && vmid_gen_match(vmid) &&
> > +	    atomic64_cmpxchg_relaxed(this_cpu_ptr(&active_vmids),
> > +				     old_active_vmid, vmid))
> > +		return;
> > +
> > +	raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
> > +
> > +	/* Check that our VMID belongs to the current generation. */
> > +	vmid = atomic64_read(&kvm_vmid->id);
> > +	if (!vmid_gen_match(vmid)) {
> > +		vmid = new_vmid(kvm_vmid);
> > +		atomic64_set(&kvm_vmid->id, vmid);
> 
> new_vmid() can just set kvm_vmid->id directly

Ok.
> 
> > +	}
> > +
> > +	cpu = smp_processor_id();
> 
> Why?

Left over from previous one. Forgot to remove
as we don't have the tlb_flush_pending check anymore.

Thanks,
Shameer

> 
> Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
