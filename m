Return-Path: <SRS0=Wnhb=5E=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D774C4332D
	for <kvmarm@archiver.kernel.org>; Thu, 19 Mar 2020 16:16:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B6CD92080C
	for <kvmarm@archiver.kernel.org>; Thu, 19 Mar 2020 16:16:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MVrB/l2O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6CD92080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 42A1B4B08D;
	Thu, 19 Mar 2020 12:16:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 24RtGgsi3D81; Thu, 19 Mar 2020 12:16:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F18254B090;
	Thu, 19 Mar 2020 12:16:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93FE74B08B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 12:16:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id USuU1Vfg0EyF for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Mar 2020 12:16:06 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 92E094B08A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Mar 2020 12:16:06 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 78BC62072C;
 Thu, 19 Mar 2020 16:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584634565;
 bh=zx6EpVvCurtuHtjYl9daum/XLOGNhScxk2ZlhM+sgp4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=MVrB/l2Ov9AOX1/m6SVkK9uZGb1qcoR5fiVh4jakV9y29Z6EhwW3+EFUfqW1Emwzu
 zxtAd/Mtwaj6SXLkaqxYnXwNkInqmq/klFiOnlihfyCuxxvpzAsElanIXBOCFH95E8
 WHwkjglTUs6K2R+94xx/HW7BdwlTf6asizPE2Li8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jExpz-00E13G-QY; Thu, 19 Mar 2020 16:16:03 +0000
MIME-Version: 1.0
Date: Thu, 19 Mar 2020 16:16:03 +0000
From: Marc Zyngier <maz@kernel.org>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v5 23/23] KVM: arm64: GICv4.1: Expose HW-based SGIs in
 debugfs
In-Reply-To: <33576d89-2b12-b98b-e392-3342b9b1265c@redhat.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-24-maz@kernel.org>
 <4cb4c3d4-7b02-bb77-cd7a-c185346b6a2f@redhat.com>
 <45c282bddd43420024633943c1befac3@kernel.org>
 <33576d89-2b12-b98b-e392-3342b9b1265c@redhat.com>
Message-ID: <17921081f98a589c67b37b1d07a9cfcc@kernel.org>
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

On 2020-03-19 15:43, Auger Eric wrote:
> Hi Marc,
> 
> On 3/19/20 4:21 PM, Marc Zyngier wrote:
>> Hi Eric,

[...]

>>> The patch looks good to me but I am now lost about how we retrieve 
>>> the
>>> pending stat of other hw mapped interrupts. Looks we use
>>> irq->pending_latch always. Is that correct?
>> 
>> Correct. GICv4.0 doesn't give us an architectural way to look at the
>> vLPI pending state (there isn't even a guarantee about when the GIC
>> will stop writing to memory, if it ever does).
>> 
>> With GICv4.1, you can introspect the HW state for SGIs. You can also
>> look at the vLPI state by peeking at the virtual pending table, but
>> you'd need to unmap the VPE first, which I obviously don't want to do
>> for this debug interface, specially as it can be used whilst the guest
>> is up and running.
> OK for vLPIs, what about other HW mapped IRQs (arch timer?)

Different kind of HW. With those, the injection is still virtual, so the
SW pending bit is still very much valid. You can actually try and make
the timer interrupt pending, it should show up.

What the irq->hw bit means is "this virtual interrupt is somehow related
to the host_irq". How this is interpreted is completely 
context-dependent.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
