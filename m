Return-Path: <SRS0=IgiY=IW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9F0C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 24 Mar 2021 15:47:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C2D0961A0F
	for <kvmarm@archiver.kernel.org>; Wed, 24 Mar 2021 15:47:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C2D0961A0F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38A734B462;
	Wed, 24 Mar 2021 11:47:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bGjQZyNAXZhJ; Wed, 24 Mar 2021 11:47:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CFFB4B455;
	Wed, 24 Mar 2021 11:47:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BADC4B452
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Mar 2021 11:47:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zKl9zx8GuQJi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Mar 2021 11:47:40 -0400 (EDT)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BA164B299
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Mar 2021 11:47:40 -0400 (EDT)
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.226])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4F5CDX6fSSz683Wv;
 Wed, 24 Mar 2021 23:42:52 +0800 (CST)
Received: from lhreml720-chm.china.huawei.com (10.201.108.71) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Wed, 24 Mar 2021 16:47:37 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml720-chm.china.huawei.com (10.201.108.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 24 Mar 2021 15:47:37 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.013; Wed, 24 Mar 2021 15:47:37 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Marc Zyngier <maz@kernel.org>, "kvmarm@lists.cs.columbia.edu"
 <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] KVM: arm64: Fix CPU interface MMIO compatibility detection
Thread-Topic: [PATCH] KVM: arm64: Fix CPU interface MMIO compatibility
 detection
Thread-Index: AQHXIADnSRTuVbDHwkyLZJ68PSrFKqqTR4Mw
Date: Wed, 24 Mar 2021 15:47:37 +0000
Message-ID: <e7cb67d609924108ae944935f8493745@huawei.com>
References: <20210323162301.2049595-1-maz@kernel.org>
In-Reply-To: <20210323162301.2049595-1-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.93.221]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "kernel-team@android.com" <kernel-team@android.com>
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
> Sent: 23 March 2021 16:23
> To: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org
> Cc: Ard Biesheuvel <ardb@kernel.org>; kernel-team@android.com; Shameerali
> Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Subject: [PATCH] KVM: arm64: Fix CPU interface MMIO compatibility detection
> 
> In order to detect whether a GICv3 CPU interface is MMIO capable,
> we switch ICC_SRE_EL1.SRE to 0 and check whether it sticks.
> 
> However, this is only possible if *ALL* of the HCR_EL2 interrupt
> overrides are set, and the CPU is perfectly allowed to ignore
> the write to ICC_SRE_EL1 otherwise. This leads KVM to pretend
> that a whole bunch of ARMv8.0 CPUs aren't MMIO-capable, and
> breaks VMs that should work correctly otherwise.
> 
> Fix this by setting IMO/FMO/IMO before touching ICC_SRE_EL1,
> and clear them afterwards. This allows us to reliably detect
> the CPU interface capabilities.
> 

Tested on HiSilicon D06 platform where the original issue(firmware wrongly
advertising GICv2-on-v3 compatibility) was reported and all seems to be fine.

Though not sure whether this fix is relevant to this particular platform,
FWIW,

  Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks,
Shameer

> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Fixes: 9739f6ef053f ("KVM: arm64: Workaround firmware wrongly advertising
> GICv2-on-v3 compatibility")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index ee3682b9873c..39f8f7f9227c 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -429,6 +429,13 @@ u64 __vgic_v3_get_gic_config(void)
>  	if (has_vhe())
>  		flags = local_daif_save();
> 
> +	/*
> +	 * Table 11-2 "Permitted ICC_SRE_ELx.SRE settings" indicates
> +	 * that to be able to set ICC_SRE_EL1.SRE to 0, all the
> +	 * interrupt overrides must be set. You've got to love this.
> +	 */
> +	sysreg_clear_set(hcr_el2, 0, HCR_AMO | HCR_FMO | HCR_IMO);
> +	isb();
>  	write_gicreg(0, ICC_SRE_EL1);
>  	isb();
> 
> @@ -436,6 +443,8 @@ u64 __vgic_v3_get_gic_config(void)
> 
>  	write_gicreg(sre, ICC_SRE_EL1);
>  	isb();
> +	sysreg_clear_set(hcr_el2, HCR_AMO | HCR_FMO | HCR_IMO, 0);
> +	isb();
> 
>  	if (has_vhe())
>  		local_daif_restore(flags);
> --
> 2.30.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
