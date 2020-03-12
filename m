Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD18FC10DCE
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 12:05:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B83F20716
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 12:05:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="xMSz8X+0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B83F20716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B2674A541;
	Thu, 12 Mar 2020 08:05:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4R63F+6DYa55; Thu, 12 Mar 2020 08:05:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B7F884A542;
	Thu, 12 Mar 2020 08:05:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 11B514A51F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 08:05:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m6IrmTo6bXh0 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 08:05:09 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E59BF4A49F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 08:05:08 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 967DB206E7;
 Thu, 12 Mar 2020 12:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584014707;
 bh=kF1jN8Wxs2QJYXtiW/6/YPILqARijKLxcTLHrblKp4U=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=xMSz8X+0VXtjyVOmUmgY3wXSKQTgBmi1+2IsmfOShGZSY/RDKa1wL6/UIClcZYUK2
 mjK9DrRrxe8P8dn0eVzIOEyjY9i1E7TE0OqZwj/KTjVT/ulAIWr0rvFFpu/FJJiL5P
 M3Xdaxx4zwUu4eC4bcu9xVh8m113xDUJpkMkZiQw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jCMaH-00CCnj-Tk; Thu, 12 Mar 2020 12:05:06 +0000
MIME-Version: 1.0
Date: Thu, 12 Mar 2020 12:05:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v5 01/23] irqchip/gic-v3: Use SGIs without active state if
 offered
In-Reply-To: <51b2c74fdbcca049cc01be6d78c7c693@kernel.org>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-2-maz@kernel.org>
 <63f6530a-9369-31e6-88d0-5337173495b9@huawei.com>
 <51b2c74fdbcca049cc01be6d78c7c693@kernel.org>
Message-ID: <1bff1835ba7d6e22edb836d38cf16a14@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com,
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

On 2020-03-12 09:28, Marc Zyngier wrote:
> Hi Zenghui,
> 
> On 2020-03-12 06:30, Zenghui Yu wrote:
>> Hi Marc,
>> 
>> On 2020/3/5 4:33, Marc Zyngier wrote:
>>> To allow the direct injection of SGIs into a guest, the GICv4.1
>>> architecture has to sacrifice the Active state so that SGIs look
>>> a lot like LPIs (they are injected by the same mechanism).
>>> 
>>> In order not to break existing software, the architecture gives
>>> offers guests OSs the choice: SGIs with or without an active
>>> state. It is the hypervisors duty to honor the guest's choice.
>>> 
>>> For this, the architecture offers a discovery bit indicating whether
>>> the GIC supports GICv4.1 SGIs (GICD_TYPER2.nASSGIcap), and another
>>> bit indicating whether the guest wants Active-less SGIs or not
>>> (controlled by GICD_CTLR.nASSGIreq).
>> 
>> I still can't find the description of these two bits in IHI0069F.
>> Are they actually architected and will be available in the future
>> version of the spec?  I want to confirm it again since this has a
>> great impact on the KVM code, any pointers?
> 
> Damn. The bits *are* in the engineering spec version 19 (unfortunately
> not a public document, but I believe you should have access to it).
> 
> If the bits have effectively been removed from the spec, I'll drop the
> GICv4.1 code from the 5.7 queue until we find a way to achieve the same
> level of support.
> 
> I've emailed people inside ARM to find out.

I've now had written confirmation that the bits are still there.

It is just that the current revision of the documentation was cut 
*before*
they made it into the architecture (there seem to be a 6 month delay 
between
the architecture being sampled and the documentation being released).

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
