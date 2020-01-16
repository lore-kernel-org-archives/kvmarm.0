Return-Path: <SRS0=uwID=3F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F7C5C32771
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jan 2020 02:01:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DB79D2084D
	for <kvmarm@archiver.kernel.org>; Thu, 16 Jan 2020 02:01:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB79D2084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AD9C4B11C;
	Wed, 15 Jan 2020 21:01:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8mc2v9eAjBNS; Wed, 15 Jan 2020 21:01:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12F304B0FA;
	Wed, 15 Jan 2020 21:01:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6C724B0FA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 21:01:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 82fa-MEWo9xV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jan 2020 21:01:31 -0500 (EST)
Received: from huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DB1894B0F7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jan 2020 21:01:30 -0500 (EST)
Received: from DGGEMM406-HUB.china.huawei.com (unknown [172.30.72.56])
 by Forcepoint Email with ESMTP id A8E43419CB98BBC2D2B3;
 Thu, 16 Jan 2020 10:01:27 +0800 (CST)
Received: from dggeme714-chm.china.huawei.com (10.1.199.110) by
 DGGEMM406-HUB.china.huawei.com (10.3.20.214) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 16 Jan 2020 10:01:27 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme714-chm.china.huawei.com (10.1.199.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 16 Jan 2020 10:01:27 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Thu, 16 Jan 2020 10:01:27 +0800
From: linmiaohe <linmiaohe@huawei.com>
To: "maz@kernel.org" <maz@kernel.org>, "james.morse@arm.com"
 <james.morse@arm.com>, "julien.thierry.kdev@gmail.com"
 <julien.thierry.kdev@gmail.com>, "suzuki.poulose@arm.com"
 <suzuki.poulose@arm.com>, "christoffer.dall@arm.com"
 <christoffer.dall@arm.com>, "catalin.marinas@arm.com"
 <catalin.marinas@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "will@kernel.org"
 <will@kernel.org>, "andre.przywara@arm.com" <andre.przywara@arm.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] KVM: arm/arm64: Fix some obsolete comments
Thread-Topic: [PATCH] KVM: arm/arm64: Fix some obsolete comments
Thread-Index: AdXMEIsRM8NLXBleSYieolgkDnr4pA==
Date: Thu, 16 Jan 2020 02:01:27 +0000
Message-ID: <9a12f0f18f37418e921afede5f6e3645@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
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

friendly ping. :)
> From: Miaohe Lin <linmiaohe@huawei.com>
>
> Fix various comments, including comment typo, and obsolete comments no longer make sense.
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  virt/kvm/arm/arch_timer.c    | 5 ++---
>  virt/kvm/arm/arm.c           | 1 -
>  virt/kvm/arm/vgic/vgic-its.c | 2 +-
>  3 files changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c index 73867f97040c..d8d2f4bec935 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -322,9 +322,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
>  	}
>  
>  	/*
> -	 * If the timer can fire now, we don't need to have a soft timer
> -	 * scheduled for the future.  If the timer cannot fire at all,
> -	 * then we also don't need a soft timer.
> +	 * If the timer cannot fire at all, we don't need to have a
> +	 * soft timer scheduled for the future.
>  	 */
>  	if (!kvm_timer_irq_can_fire(ctx)) {
>  		soft_timer_cancel(&ctx->hrtimer);
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c index 8de4daf25097..7687663ab71b 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -525,7 +525,6 @@ static bool need_new_vmid_gen(struct kvm_vmid *vmid)
>  
>  /**
>   * update_vmid - Update the vmid with a valid VMID for the current generation
> - * @kvm: The guest that struct vmid belongs to
>   * @vmid: The stage-2 VMID information struct
>   */
>  static void update_vmid(struct kvm_vmid *vmid) diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c index 98c7360d9fb7..d64569b30b5c 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -2564,7 +2564,7 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)  }
>  
>  /**
> - * vgic_its_save_tables_v0 - Save the ITS tables into guest ARM
> + * vgic_its_save_tables_v0 - Save the ITS tables into guest RAM
>   * according to v0 ABI
>   */
>  static int vgic_its_save_tables_v0(struct vgic_its *its)
> --
> 2.19.1
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
