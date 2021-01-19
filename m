Return-Path: <SRS0=GHi4=GW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2031C433DB
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jan 2021 10:09:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E84C52250E
	for <kvmarm@archiver.kernel.org>; Tue, 19 Jan 2021 10:09:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E84C52250E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EDD34B22D;
	Tue, 19 Jan 2021 05:09:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YzlH8Kxha82o; Tue, 19 Jan 2021 05:09:14 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0F1C4B387;
	Tue, 19 Jan 2021 05:09:14 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FD274B386
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jan 2021 05:09:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SmhbbqaLIvCf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Jan 2021 05:09:10 -0500 (EST)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4BB084B22D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Jan 2021 05:09:10 -0500 (EST)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.226])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DKkmF31gsz67dP0;
 Tue, 19 Jan 2021 18:05:01 +0800 (CST)
Received: from lhreml721-chm.china.huawei.com (10.201.108.72) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Tue, 19 Jan 2021 11:09:07 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml721-chm.china.huawei.com (10.201.108.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 19 Jan 2021 10:09:07 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.006; Tue, 19 Jan 2021 10:09:07 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Subject: RE: [PATCH v2 2/2] KVM: arm64: Workaround firmware wrongly
 advertising GICv2-on-v3 compatibility
Thread-Topic: [PATCH v2 2/2] KVM: arm64: Workaround firmware wrongly
 advertising GICv2-on-v3 compatibility
Thread-Index: AQHW60dBU9omB+37dU2yYyMV32Qj+6oouSqAgAAB/QCABgME8A==
Date: Tue, 19 Jan 2021 10:09:07 +0000
Message-ID: <0edcab071c4845f29ec20af630777dce@huawei.com>
References: <20210115140323.2682634-1-maz@kernel.org>
 <20210115140323.2682634-3-maz@kernel.org>
 <CAMj1kXHEMpypq54Vxr+JgL9b_zoj_y2azK3mgAhXhnXO6Bhygw@mail.gmail.com>
 <67c2f61a5dd33731cf52b6e26095ed51@kernel.org>
In-Reply-To: <67c2f61a5dd33731cf52b6e26095ed51@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.83.172]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Android Kernel Team <kernel-team@android.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: 15 January 2021 14:15
> To: Ard Biesheuvel <ardb@kernel.org>
> Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>; kvmarm
> <kvmarm@lists.cs.columbia.edu>; Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>; James Morse
> <james.morse@arm.com>; Julien Thierry <julien.thierry.kdev@gmail.com>;
> Suzuki K Poulose <suzuki.poulose@arm.com>; Android Kernel Team
> <kernel-team@android.com>
> Subject: Re: [PATCH v2 2/2] KVM: arm64: Workaround firmware wrongly
> advertising GICv2-on-v3 compatibility
> 
> On 2021-01-15 14:08, Ard Biesheuvel wrote:
> > On Fri, 15 Jan 2021 at 15:03, Marc Zyngier <maz@kernel.org> wrote:
> 
> [...]
> 
> >> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c
> >> b/arch/arm64/kvm/vgic/vgic-v3.c index 8e7bf3151057..67b27b47312b
> >> 100644
> >> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> >> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> >> @@ -584,8 +584,10 @@ early_param("kvm-arm.vgic_v4_enable",
> >> early_gicv4_enable);
> >>  int vgic_v3_probe(const struct gic_kvm_info *info)  {
> >>         u64 ich_vtr_el2 = kvm_call_hyp_ret(__vgic_v3_get_gic_config);
> >> +       bool has_v2;
> >>         int ret;
> >>
> >> +       has_v2 = ich_vtr_el2 >> 63;
> >>         ich_vtr_el2 = (u32)ich_vtr_el2;
> >>
> >>         /*
> >> @@ -605,13 +607,15 @@ int vgic_v3_probe(const struct gic_kvm_info
> >> *info)
> >>                          gicv4_enable ? "en" : "dis");
> >>         }
> >>
> >> +       kvm_vgic_global_state.vcpu_base = 0;
> >> +
> >>         if (!info->vcpu.start) {
> >>                 kvm_info("GICv3: no GICV resource entry\n");
> >> -               kvm_vgic_global_state.vcpu_base = 0;
> >> +       } else if (!has_v2) {
> >> +               pr_warn("CPU interface incapable of MMIO access\n");
> >
> > Could we include FW_BUG here to stress that this is a firmware problem?
> 
> Absolutely! That's what it now looks like:
> 
> [    2.648452] kvm [1]: IPA Size Limit: 40 bits
> [    2.649259] [Firmware Bug]: CPU interface incapable of MMIO access
> [    2.649620] kvm [1]: disabling GICv2 emulation
> [    2.650227] kvm [1]: GIC system register CPU interface enabled
> [    2.652004] kvm [1]: vgic interrupt IRQ9
> [    2.655623] kvm [1]: VHE mode initialized successfully
> 
> Updated version pushed out.

Is there a v3 for this series? I couldn't find one.

Anyways, tested this series on a D06 with faulty firmware and it is working as expected.
FWIW,

   Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

> Thanks,
> 
>          M.
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
