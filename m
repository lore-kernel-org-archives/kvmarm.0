Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1758C4332F
	for <kvmarm@archiver.kernel.org>; Sat,  5 Nov 2022 09:42:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62CF84A1D9;
	Sat,  5 Nov 2022 05:42:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tnWr3Nbr7VMw; Sat,  5 Nov 2022 05:42:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60C1D41066;
	Sat,  5 Nov 2022 05:42:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E7F641066
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Nov 2022 05:42:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3IS7+QwUUhh3 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Nov 2022 05:42:31 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D60140BED
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Nov 2022 05:42:31 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 5DBDB60A66;
 Sat,  5 Nov 2022 09:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E03EC433D6;
 Sat,  5 Nov 2022 09:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1667641349;
 bh=JN6aU2159+LnIGdVUDFlVD7XJbpBPoujgJJuF+mYRII=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=PcYuG0V+rCExyWsyXI9kd/0Y8E/9ufh8ploElPHjPWPige8l3QF5Op90x7/rnyotA
 MiItM2Xxj6vzq6OQz5M62Eybdk+A1RKg1JMNen6cKv6mj+qypW80gL8GSNSizysH63
 by2BLGrUPVtf+GrICFx+1u6I0ifUCLCTkpXdOar3RE/omguTAd/IEPZDH36fCFP2Bl
 P4wIMsX+OoeJ22+LuvWDLYoP60H2INCpeisWFmU7d3uDtmnUzZYgY5w/BfYmNj1PDK
 X3lA5gp+C9qSKijkIXEnnAW5QyBe6zeO8kLAtKIBXrN+Usa11aEYEQLFhdSbU/v7Ro
 sFHCEIU+IT+DQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1orFh5-0041Ff-9v;
 Sat, 05 Nov 2022 09:42:27 +0000
MIME-Version: 1.0
Date: Sat, 05 Nov 2022 09:42:26 +0000
From: Marc Zyngier <maz@kernel.org>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v2 01/14] arm64: Add ID_DFR0_EL1.PerfMon values for
 PMUv3p7 and IMP_DEF
In-Reply-To: <Y2V6WIu40Cg2ShXV@google.com>
References: <20221028105402.2030192-1-maz@kernel.org>
 <20221028105402.2030192-2-maz@kernel.org> <Y2V6WIu40Cg2ShXV@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <778e0ed6767f1d0771bee1cc54b0c49c@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On 2022-11-04 20:47, Oliver Upton wrote:
> On Fri, Oct 28, 2022 at 11:53:49AM +0100, Marc Zyngier wrote:
>> Align the ID_DFR0_EL1.PerfMon values with ID_AA64DFR0_EL1.PMUver.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> FYI, another pile of ID reg changes is on the way that'll move DFR0 to 
> a
> generated definition.
> 
> https://lore.kernel.org/linux-arm-kernel/20220930140211.3215348-1-james.morse@arm.com/
> 

Eh, another of these. The usual way we deal with this churn
is to have a stable branch in the arm64 tree which I pull into
the offending branch in the kvmarm tree.

Thanks for the heads up!

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
