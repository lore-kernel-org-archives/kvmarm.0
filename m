Return-Path: <SRS0=O4n2=IX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3973C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 09:37:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C64961A24
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 09:37:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C64961A24
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 842544B294;
	Thu, 25 Mar 2021 05:37:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YJRmJtSmSLa4; Thu, 25 Mar 2021 05:37:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B7DD4B43C;
	Thu, 25 Mar 2021 05:37:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 583C54B379
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 05:37:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0+eB4q5YmScU for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 05:37:17 -0400 (EDT)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C86874B294
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 05:37:17 -0400 (EDT)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.207])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4F5fyj3RkJz682BC;
 Thu, 25 Mar 2021 17:32:29 +0800 (CST)
Received: from lhreml714-chm.china.huawei.com (10.201.108.65) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 10:37:15 +0100
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml714-chm.china.huawei.com (10.201.108.65) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 25 Mar 2021 09:37:15 +0000
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2106.013; Thu, 25 Mar 2021 09:37:15 +0000
From: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To: Marc Zyngier <maz@kernel.org>
Subject: RE: [PATCH for-stable-5.10 2/2] KVM: arm64: Workaround firmware
 wrongly advertising GICv2-on-v3 compatibility
Thread-Topic: [PATCH for-stable-5.10 2/2] KVM: arm64: Workaround firmware
 wrongly advertising GICv2-on-v3 compatibility
Thread-Index: AQHXIVdkF/Q7jN0LS02rK142tsme1qqUcRaAgAAAZbA=
Date: Thu, 25 Mar 2021 09:37:15 +0000
Message-ID: <3ed860eaf93c43969b7dfeb0904efb2e@huawei.com>
References: <20210325091424.26348-1-shameerali.kolothum.thodi@huawei.com>
 <20210325091424.26348-3-shameerali.kolothum.thodi@huawei.com>
 <9850fc39c1c80840ea77eba60ee5e663@kernel.org>
In-Reply-To: <9850fc39c1c80840ea77eba60ee5e663@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.26.249]
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
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
> From: Marc Zyngier [mailto:maz@kernel.org]
> Sent: 25 March 2021 09:33
> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> Cc: kvmarm@lists.cs.columbia.edu; kvm@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; stable@vger.kernel.org;
> pbonzini@redhat.com; Linuxarm <linuxarm@huawei.com>
> Subject: Re: [PATCH for-stable-5.10 2/2] KVM: arm64: Workaround firmware
> wrongly advertising GICv2-on-v3 compatibility
> 
> On 2021-03-25 09:14, Shameer Kolothum wrote:
> > From: Marc Zyngier <maz@kernel.org>
> >
> > commit 9739f6ef053f104a997165701c6e15582c4307ee upstream.
> >
> > It looks like we have broken firmware out there that wrongly
> > advertises a GICv2 compatibility interface, despite the CPUs not being
> > able to deal with it.
> >
> > To work around this, check that the CPU initialising KVM is actually
> > able to switch to MMIO instead of system registers, and use that as a
> > precondition to enable GICv2 compatibility in KVM.
> >
> > Note that the detection happens on a single CPU. If the firmware is
> > lying *and* that the CPUs are asymetric, all hope is lost anyway.
> >
> > Cc: stable@vger.kernel.org #5.10
> > Reported-by: Shameerali Kolothum Thodi
> > <shameerali.kolothum.thodi@huawei.com>
> > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Message-Id: <20210305185254.3730990-8-maz@kernel.org>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> 
> Please hold on on that.
> 
> This patch causes a regression, and needs a fix that is currently queued for 5.12
> [1]. Once this hits upstream, please add the fix to the series and post it as a
> whole.

Ok. Yes, I noted that. But was thinking if this goes through first and then we can have a 
stable tag for that one, we can manage it. Anyway, will wait now.

Thanks,
Shameer
 
> Thanks,
> 
>          M.
> 
> [1] https://lore.kernel.org/r/20210323162301.2049595-1-maz@kernel.org
> --
> Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
