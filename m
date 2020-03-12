Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A842C4CECE
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 17:23:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2F535206FA
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 17:23:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="gswYtdvM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F535206FA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFE9A4A578;
	Thu, 12 Mar 2020 13:23:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id twikV4ZdsnSn; Thu, 12 Mar 2020 13:23:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF0904A800;
	Thu, 12 Mar 2020 13:23:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A25204A578
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 13:23:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8j20ppgw2TpX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 13:23:46 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 79A8A4A4FC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 13:23:46 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5C6342067C;
 Thu, 12 Mar 2020 17:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584033825;
 bh=iqV0woTK+1QbFs1jWfR/8C8FIBB4oluJrGxTmnqVE60=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=gswYtdvMC1EGaa0AsecLAx8y70uxeabXgKreyJqKoprJOJYs1nQk7+t7R1FdYw25q
 Br7LSwcTwvVc7fbBtGBF35dvgBru7G5ce1cwtn5GTM94/11qSKcRsHljB0m6hqeCR2
 T75uS+dsBc59atUIi9qGDfFSezinHb2K8xUT7WRU=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jCRYd-00CHKE-NI; Thu, 12 Mar 2020 17:23:43 +0000
MIME-Version: 1.0
Date: Thu, 12 Mar 2020 17:23:43 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 01/23] irqchip/gic-v3: Use SGIs without active state if
 offered
In-Reply-To: <1fa8ab2f-6766-9dc1-53a6-9cead19a5a7b@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-2-maz@kernel.org>
 <1fa8ab2f-6766-9dc1-53a6-9cead19a5a7b@redhat.com>
Message-ID: <0f3c1c819a98deb77261e89eefa10e3f@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 rrichter@marvell.com, tglx@linutronix.de, yuzenghui@huawei.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu,
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

Hi Eric,

On 2020-03-12 17:16, Auger Eric wrote:
> Hi Marc,

[...]

>> diff --git a/include/linux/irqchip/arm-gic-v3.h 
>> b/include/linux/irqchip/arm-gic-v3.h
>> index 83439bfb6c5b..c29a02678a6f 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -57,6 +57,7 @@
>>  #define GICD_SPENDSGIR			0x0F20
>> 
>>  #define GICD_CTLR_RWP			(1U << 31)
>> +#define GICD_CTLR_nASSGIreq		(1U << 8)
> I am not able to find this bit in Arm IHI 0069F (ID022020)
> same for the bit in GICD_TYPER. Do we still miss part of the spec?

See my response to Zenghui (TL;DR: this addition to the spec missed the
cut-off for revision F and will be added in the next round).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
