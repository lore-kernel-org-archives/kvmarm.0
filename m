Return-Path: <SRS0=NdW8=5F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6348BC4332B
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 09:09:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E094F20774
	for <kvmarm@archiver.kernel.org>; Fri, 20 Mar 2020 09:09:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="wqxswQOY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E094F20774
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87FC64B090;
	Fri, 20 Mar 2020 05:09:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tdHnrGTxDAgX; Fri, 20 Mar 2020 05:09:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EB524A4E5;
	Fri, 20 Mar 2020 05:09:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 085894A4E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 05:09:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xnsA098PYZvI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Mar 2020 05:09:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1BBA94A4CD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Mar 2020 05:09:38 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E871A20752;
 Fri, 20 Mar 2020 09:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1584695377;
 bh=lKTpTlYWFEgvmkW6XkcldhhG5+woVU4cLcAGikERfqo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=wqxswQOYA6BABIMXoM2nOSVgWJ47cTHAzkq5NO+OYTws4zesQC/Bq4/lMrY5xYdT3
 LLMxbcIFzNwWU+tjzVGlaWY8W7/DyefzA7Y7u6Z+ryCAs80UEFGKtPql/c5ERxj9ZT
 Yf7rVSM+Zww6zuKaVgksoCp+gttl1NC23l6B3Fpc=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jFDep-00EBy9-8B; Fri, 20 Mar 2020 09:09:35 +0000
MIME-Version: 1.0
Date: Fri, 20 Mar 2020 09:09:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v5 23/23] KVM: arm64: GICv4.1: Expose HW-based SGIs in
 debugfs
In-Reply-To: <e1a1e537-9f8e-5cfb-0132-f796e8bf06c9@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-24-maz@kernel.org>
 <4cb4c3d4-7b02-bb77-cd7a-c185346b6a2f@redhat.com>
 <45c282bddd43420024633943c1befac3@kernel.org>
 <e1a1e537-9f8e-5cfb-0132-f796e8bf06c9@huawei.com>
Message-ID: <b63950513f519d9a04f9719f5aa6a2db@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, eric.auger@redhat.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com,
 jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de,
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

Hi Zenghui,

On 2020-03-20 04:38, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/3/19 23:21, Marc Zyngier wrote:
>> With GICv4.1, you can introspect the HW state for SGIs. You can also
>> look at the vLPI state by peeking at the virtual pending table, but
>> you'd need to unmap the VPE first,
> 
> Out of curiosity, could you please point me to the "unmap the VPE"
> requirement in the v4.1 spec? I'd like to have a look.

Sure. See IHI0069F, 5.3.19 (VMAPP GICv4.1), "Caching of virtual LPI data
structures", and the bit that says:

"A VMAPP with {V,Alloc}=={0,1} cleans and invalidates any caching of the
Virtual Pending Table and Virtual Configuration Table associated with 
the
vPEID held in the GIC"

which is what was crucially missing from the GICv4.0 spec (it doesn't 
say
when the GIC is done writing to memory).

Side note: it'd be good to know what the rules are for your own GICv4
implementations, so that we can at least make sure the current code is 
safe.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
