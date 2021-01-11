Return-Path: <SRS0=NVHA=GO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE91C433DB
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 12:22:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0338322273
	for <kvmarm@archiver.kernel.org>; Mon, 11 Jan 2021 12:22:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0338322273
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 216FF4B0F1;
	Mon, 11 Jan 2021 07:22:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id on9gsitwrzM6; Mon, 11 Jan 2021 07:22:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2D674B2D9;
	Mon, 11 Jan 2021 07:22:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B439F4B2D6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 07:22:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DmBDEn5daR+L for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Jan 2021 07:22:03 -0500 (EST)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E0784B0F1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Jan 2021 07:22:03 -0500 (EST)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.201])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DDt5Z3gQbz67ZD5;
 Mon, 11 Jan 2021 20:18:10 +0800 (CST)
Received: from lhreml721-chm.china.huawei.com (10.201.108.72) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 11 Jan 2021 13:21:59 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml721-chm.china.huawei.com (10.201.108.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 11 Jan 2021 12:21:59 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.002; Mon, 11 Jan 2021 12:21:58 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Marc Zyngier <maz@kernel.org>, "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu"
 <kvmarm@lists.cs.columbia.edu>
Subject: RE: [PATCH 2/2] KVM: arm64: Workaround firmware wrongly advertising
 GICv2-on-v3 compatibility
Thread-Topic: [PATCH 2/2] KVM: arm64: Workaround firmware wrongly advertising
 GICv2-on-v3 compatibility
Thread-Index: AQHW5eF6ISqNl2svcEe1YlX5ji0zwaoiSScg
Date: Mon, 11 Jan 2021 12:21:58 +0000
Message-ID: <5d5fc9f960d54049bbfc88341b511a3e@huawei.com>
References: <20210108171216.2310188-1-maz@kernel.org>
 <20210108171216.2310188-3-maz@kernel.org>
In-Reply-To: <20210108171216.2310188-3-maz@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.81.99]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "linuxarm@openeuler.org" <linuxarm@openeuler.org>,
 "kernel-team@android.com" <kernel-team@android.com>,
 Ard Biesheuvel <ardb@kernel.org>
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
> Sent: 08 January 2021 17:12
> To: linux-arm-kernel@lists.infradead.org; kvmarm@lists.cs.columbia.edu
> Cc: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
> James Morse <james.morse@arm.com>; Julien Thierry
> <julien.thierry.kdev@gmail.com>; Suzuki K Poulose
> <suzuki.poulose@arm.com>; Ard Biesheuvel <ardb@kernel.org>;
> kernel-team@android.com
> Subject: [PATCH 2/2] KVM: arm64: Workaround firmware wrongly advertising
> GICv2-on-v3 compatibility
> 
> It looks like we have broken firmware out there that wrongly advertises
> a GICv2 compatibility interface, despite the CPUs not being able to deal
> with it.
> 
> To work around this, check that the CPU initialising KVM is actually able
> to switch to MMIO instead of system registers, and use that as a
> precondition to enable GICv2 compatibility in KVM.
> 
> Note that the detection happens on a single CPU. If the firmware is
> lying *and* that the CPUs are asymetric, all hope is lost anyway.
> 
> Reported-by: Shameerali Kolothum Thodi
> <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c | 34 +++++++++++++++++++++++++++++++--
>  arch/arm64/kvm/vgic/vgic-v3.c   |  8 ++++++--
>  2 files changed, 38 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 005daa0c9dd7..d504499ab917 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -408,11 +408,41 @@ void __vgic_v3_init_lrs(void)
>  /*
>   * Return the GIC CPU configuration:
>   * - [31:0]  ICH_VTR_EL2
> - * - [63:32] RES0
> + * - [62:32] RES0
> + * - [63]    MMIO (GICv2) capable
>   */
>  u64 __vgic_v3_get_gic_config(void)
>  {
> -	return read_gicreg(ICH_VTR_EL2);
> +	u64 sre = read_gicreg(ICC_SRE_EL1);
> +	unsigned long flags = 0;
> +	bool v2_capable;
> +
> +	/*
> +	 * To check whether we have a MMIO-based (GICv2 compatible)
> +	 * CPU interface, we need to disable the system register
> +	 * view. To do that safely, we have to prevent any interrupt
> +	 * from firing (which would be deadly).
> +	 *
> +	 * Note that this only makes sense on VHE, as interrupts are
> +	 * already masked for nVHE as part of the exception entry to
> +	 * EL2.
> +	 */
> +	if (has_vhe())
> +		flags = local_daif_save();
> +
> +	write_gicreg(0, ICC_SRE_EL1);
> +	isb();
> +
> +	v2_capable = !(read_gicreg(ICC_SRE_EL1) & ICC_SRE_EL1_SRE);
> +
> +	write_gicreg(sre, ICC_SRE_EL1);
> +	isb();
> +
> +	if (has_vhe())
> +		local_daif_restore(flags);
> +
> +	return (read_gicreg(ICH_VTR_EL2) |
> +		v2_capable ? (1ULL << 63) : 0);
>  }

Thanks for sending this out. I had a go with this series and unfortunately
it didn't work on a system with faulty BIOS. It looks like the culprit here is
the ?: operator. There seems to be an operator precedence at play here
and it returns,
  vgic_v3_probe: ich_vtr_el2 0x8000000000000000

And with the below change,

        return (read_gicreg(ICH_VTR_EL2) |
-               v2_capable ? (1ULL << 63) : 0);
+               (v2_capable ? (1ULL << 63) : 0));
 }

It returns,
  vgic_v3_probe: ich_vtr_el2 0x90080003

and works correctly.
[   18.918738] kvm [1]: disabling GICv2 emulation

Thanks,
Shameer

>  u64 __vgic_v3_read_vmcr(void)
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 8e7bf3151057..67b27b47312b 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -584,8 +584,10 @@ early_param("kvm-arm.vgic_v4_enable",
> early_gicv4_enable);
>  int vgic_v3_probe(const struct gic_kvm_info *info)
>  {
>  	u64 ich_vtr_el2 = kvm_call_hyp_ret(__vgic_v3_get_gic_config);
> +	bool has_v2;
>  	int ret;
> 
> +	has_v2 = ich_vtr_el2 >> 63;
>  	ich_vtr_el2 = (u32)ich_vtr_el2;
> 
>  	/*
> @@ -605,13 +607,15 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  			 gicv4_enable ? "en" : "dis");
>  	}
> 
> +	kvm_vgic_global_state.vcpu_base = 0;
> +
>  	if (!info->vcpu.start) {
>  		kvm_info("GICv3: no GICV resource entry\n");
> -		kvm_vgic_global_state.vcpu_base = 0;
> +	} else if (!has_v2) {
> +		pr_warn("CPU interface incapable of MMIO access\n");
>  	} else if (!PAGE_ALIGNED(info->vcpu.start)) {
>  		pr_warn("GICV physical address 0x%llx not page aligned\n",
>  			(unsigned long long)info->vcpu.start);
> -		kvm_vgic_global_state.vcpu_base = 0;
>  	} else {
>  		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
>  		kvm_vgic_global_state.can_emulate_gicv2 = true;
> --
> 2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
