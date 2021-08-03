Return-Path: <SRS0=p2dm=M2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E2AC4338F
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 12:55:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 49DD360F02
	for <kvmarm@archiver.kernel.org>; Tue,  3 Aug 2021 12:55:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 49DD360F02
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C567540CF8;
	Tue,  3 Aug 2021 08:55:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XD7AQiMOsCXs; Tue,  3 Aug 2021 08:55:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CF4949FA6;
	Tue,  3 Aug 2021 08:55:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AF3340CF8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 08:55:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id weWpoJXN8YGM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Aug 2021 08:55:33 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3F4BB40C88
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Aug 2021 08:55:33 -0400 (EDT)
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4GfFB20Fmzz18Nbw;
 Tue,  3 Aug 2021 20:51:38 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 3 Aug 2021 20:55:27 +0800
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2176.012; Tue, 3 Aug 2021 13:55:25 +0100
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Will Deacon <will@kernel.org>
Subject: RE: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU schedule out
Thread-Topic: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU schedule
 out
Thread-Index: AQHXhGar1JrryboKrU+7h+yU/0K2/6thny2AgAAaZCA=
Date: Tue, 3 Aug 2021 12:55:25 +0000
Message-ID: <ee2863107d614ef8a36006b5aa912eca@huawei.com>
References: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
 <20210729104009.382-5-shameerali.kolothum.thodi@huawei.com>
 <20210803114034.GB30853@willie-the-truck>
In-Reply-To: <20210803114034.GB30853@willie-the-truck>
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



> -----Original Message-----
> From: Will Deacon [mailto:will@kernel.org]
> Sent: 03 August 2021 12:41
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu;
> linux-kernel@vger.kernel.org; maz@kernel.org; catalin.marinas@arm.com;
> james.morse@arm.com; julien.thierry.kdev@gmail.com;
> suzuki.poulose@arm.com; jean-philippe@linaro.org;
> Alexandru.Elisei@arm.com; qperret@google.com; Linuxarm
> <linuxarm@huawei.com>
> Subject: Re: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU
> schedule out
> =

> On Thu, Jul 29, 2021 at 11:40:09AM +0100, Shameer Kolothum wrote:
> > Like ASID allocator, we copy the active_vmids into the
> > reserved_vmids on a rollover. But it's unlikely that
> > every CPU will have a=A0vCPU as current task and we may
> > end up unnecessarily=A0reserving the VMID space.
> >
> > Hence, clear active_vmids when scheduling out a vCPU.
> >
> > Suggested-by: Will Deacon <will@kernel.org>
> > Signed-off-by: Shameer Kolothum
> <shameerali.kolothum.thodi@huawei.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 1 +
> >  arch/arm64/kvm/arm.c              | 1 +
> >  arch/arm64/kvm/vmid.c             | 6 ++++++
> >  3 files changed, 8 insertions(+)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> > index bb993bce1363..d93141cb8d16 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -687,6 +687,7 @@ extern unsigned int kvm_arm_vmid_bits;
> >  int kvm_arm_vmid_alloc_init(void);
> >  void kvm_arm_vmid_alloc_free(void);
> >  void kvm_arm_vmid_update(struct kvm_vmid *kvm_vmid);
> > +void kvm_arm_vmid_clear_active(void);
> >
> >  static inline void kvm_arm_pvtime_vcpu_init(struct kvm_vcpu_arch
> *vcpu_arch)
> >  {
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 077e55a511a9..b134a1b89c84 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -435,6 +435,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> >  	kvm_timer_vcpu_put(vcpu);
> >  	kvm_vgic_put(vcpu);
> >  	kvm_vcpu_pmu_restore_host(vcpu);
> > +	kvm_arm_vmid_clear_active();
> >
> >  	vcpu->cpu =3D -1;
> >  }
> > diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
> > index 5584e84aed95..5fd51f5445c1 100644
> > --- a/arch/arm64/kvm/vmid.c
> > +++ b/arch/arm64/kvm/vmid.c
> > @@ -116,6 +116,12 @@ static u64 new_vmid(struct kvm_vmid
> *kvm_vmid)
> >  	return idx2vmid(vmid) | generation;
> >  }
> >
> > +/* Call with preemption disabled */
> > +void kvm_arm_vmid_clear_active(void)
> > +{
> > +	atomic64_set(this_cpu_ptr(&active_vmids), 0);
> > +}
> =

> I think this is very broken, as it will force everybody to take the
> slow-path when they see an active_vmid of 0.

Yes. I have seen that happening in my test setup.

> It also doesn't solve the issue I mentioned before, as an active_vmid of 0
> means that the reserved vmid is preserved.
> =

> Needs more thought...

How about we clear all the active_vmids in kvm_arch_free_vm() if it
matches the kvm_vmid->id ? But we may have to hold the lock =

there.

Thanks,
Shameer
 =


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
