Return-Path: <SRS0=aM0J=O7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C6AC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 06:06:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD29D60F21
	for <kvmarm@archiver.kernel.org>; Mon, 11 Oct 2021 06:06:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CD29D60F21
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B9F44B11E;
	Mon, 11 Oct 2021 02:06:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wer4JOPAr5eX; Mon, 11 Oct 2021 02:06:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D07654B0F5;
	Mon, 11 Oct 2021 02:06:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6F674B0F5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 02:06:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qWeXZnUG--pb for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Oct 2021 02:06:34 -0400 (EDT)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D70A49F6C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 02:06:34 -0400 (EDT)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.201])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HSSsS2m3yz67n97;
 Mon, 11 Oct 2021 14:03:40 +0800 (CST)
Received: from lhreml711-chm.china.huawei.com (10.201.108.62) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 11 Oct 2021 08:06:31 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml711-chm.china.huawei.com (10.201.108.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 11 Oct 2021 07:06:30 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.008; Mon, 11 Oct 2021 07:06:30 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Will Deacon <will@kernel.org>
Subject: RE: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU schedule out
Thread-Topic: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU schedule
 out
Thread-Index: AQHXhGar1JrryboKrU+7h+yU/0K2/6thny2AgAAaZCCAACXigIAMKHhQgF+6M6A=
Date: Mon, 11 Oct 2021 06:06:30 +0000
Message-ID: <4e5ef4842f1e4895bfde456bde06c6cf@huawei.com>
References: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
 <20210729104009.382-5-shameerali.kolothum.thodi@huawei.com>
 <20210803114034.GB30853@willie-the-truck>
 <ee2863107d614ef8a36006b5aa912eca@huawei.com>
 <20210803153036.GA31125@willie-the-truck> 
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.25.32]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Linuxarm <linuxarm@huawei.com>, Jonathan Cameron <jonathan.cameron@huawei.com>,
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
> Sent: 11 August 2021 09:48
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
> Hi Will,
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
> 
> [...]
> 
> > I think we have to be really careful not to run into the "suspended
> > animation" problem described in ae120d9edfe9 ("ARM: 7767/1: let the ASID
> > allocator handle suspended animation") if we go down this road.
> >
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
> 
> I attempted to implement the above algo as below. It seems to be
> working in both 16-bit vmid and 4-bit vmid test setup. 

It is not :(. I did an extended, overnight test run and it fails.
It looks to me in my below implementation there is no synchronization
on setting the active VMID and a concurrent rollover. I will have another go.

Thanks,
Shameer

Though I am
> not quite sure this Is exactly what you had in mind above and covers
> all corner cases.
> 
> Please take a look and let me know.
> (The diff below is against this v3 series)
> 
> Thanks,
> Shameer
> 
> --->8<----
> 
> --- a/arch/arm64/kvm/vmid.c
> +++ b/arch/arm64/kvm/vmid.c
> @@ -43,7 +43,7 @@ static void flush_context(void)
>         bitmap_clear(vmid_map, 0, NUM_USER_VMIDS);
> 
>         for_each_possible_cpu(cpu) {
> -               vmid = atomic64_xchg_relaxed(&per_cpu(active_vmids,
> cpu), 0);
> +               vmid = atomic64_read(&per_cpu(active_vmids, cpu));
> 
>                 /* Preserve reserved VMID */
>                 if (vmid == 0)
> @@ -125,32 +125,17 @@ void kvm_arm_vmid_clear_active(void)
>  void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid)
>  {
>         unsigned long flags;
> -       u64 vmid, old_active_vmid;
> +       u64 vmid;
> 
>         vmid = atomic64_read(&kvm_vmid->id);
> -
> -       /*
> -        * Please refer comments in check_and_switch_context() in
> -        * arch/arm64/mm/context.c.
> -        */
> -       old_active_vmid = atomic64_read(this_cpu_ptr(&active_vmids));
> -       if (old_active_vmid && vmid_gen_match(vmid) &&
> -           atomic64_cmpxchg_relaxed(this_cpu_ptr(&active_vmids),
> -                                    old_active_vmid, vmid))
> +       if (vmid_gen_match(vmid)) {
> +               atomic64_set(this_cpu_ptr(&active_vmids), vmid);
>                 return;
> -
> -       raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
> -
> -       /* Check that our VMID belongs to the current generation. */
> -       vmid = atomic64_read(&kvm_vmid->id);
> -       if (!vmid_gen_match(vmid)) {
> -               vmid = new_vmid(kvm_vmid);
> -               atomic64_set(&kvm_vmid->id, vmid);
>         }
> 
> -
> +       raw_spin_lock_irqsave(&cpu_vmid_lock, flags);
> +       vmid = new_vmid(kvm_vmid);
> +       atomic64_set(&kvm_vmid->id, vmid);
>         atomic64_set(this_cpu_ptr(&active_vmids), vmid);
>         raw_spin_unlock_irqrestore(&cpu_vmid_lock, flags);
>  }
> --->8<----
> 
> 
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
