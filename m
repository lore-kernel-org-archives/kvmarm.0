Return-Path: <SRS0=O4n2=IX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35082C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 09:33:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7E5A561A0E
	for <kvmarm@archiver.kernel.org>; Thu, 25 Mar 2021 09:33:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E5A561A0E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCE5C4B466;
	Thu, 25 Mar 2021 05:33:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uZ4390K3pBwg; Thu, 25 Mar 2021 05:33:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF74D4B43E;
	Thu, 25 Mar 2021 05:33:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 692F64B395
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 05:33:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t4GTbZE9LNiH for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Mar 2021 05:33:22 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6F4824B379
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Mar 2021 05:33:22 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2CA7F619E3;
 Thu, 25 Mar 2021 09:33:20 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lPMMf-003hPI-SL; Thu, 25 Mar 2021 09:33:18 +0000
MIME-Version: 1.0
Date: Thu, 25 Mar 2021 09:33:17 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH for-stable-5.10 2/2] KVM: arm64: Workaround firmware
 wrongly advertising GICv2-on-v3 compatibility
In-Reply-To: <20210325091424.26348-3-shameerali.kolothum.thodi@huawei.com>
References: <20210325091424.26348-1-shameerali.kolothum.thodi@huawei.com>
 <20210325091424.26348-3-shameerali.kolothum.thodi@huawei.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <9850fc39c1c80840ea77eba60ee5e663@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: shameerali.kolothum.thodi@huawei.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 pbonzini@redhat.com, linuxarm@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, linuxarm@huawei.com, stable@vger.kernel.org,
 pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2021-03-25 09:14, Shameer Kolothum wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> commit 9739f6ef053f104a997165701c6e15582c4307ee upstream.
> 
> It looks like we have broken firmware out there that wrongly advertises
> a GICv2 compatibility interface, despite the CPUs not being able to 
> deal
> with it.
> 
> To work around this, check that the CPU initialising KVM is actually 
> able
> to switch to MMIO instead of system registers, and use that as a
> precondition to enable GICv2 compatibility in KVM.
> 
> Note that the detection happens on a single CPU. If the firmware is
> lying *and* that the CPUs are asymetric, all hope is lost anyway.
> 
> Cc: stable@vger.kernel.org #5.10
> Reported-by: Shameerali Kolothum Thodi 
> <shameerali.kolothum.thodi@huawei.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Message-Id: <20210305185254.3730990-8-maz@kernel.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Please hold on on that.

This patch causes a regression, and needs a fix that is currently queued
for 5.12 [1]. Once this hits upstream, please add the fix to the series
and post it as a whole.

Thanks,

         M.

[1] https://lore.kernel.org/r/20210323162301.2049595-1-maz@kernel.org
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
