Return-Path: <SRS0=kG2x=5J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4710C4332B
	for <kvmarm@archiver.kernel.org>; Tue, 24 Mar 2020 12:35:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 569612070A
	for <kvmarm@archiver.kernel.org>; Tue, 24 Mar 2020 12:35:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="fZDmtzWt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 569612070A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 972AD4B08D;
	Tue, 24 Mar 2020 08:35:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aWq8XNQEw8Fx; Tue, 24 Mar 2020 08:35:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 77E7A4B093;
	Tue, 24 Mar 2020 08:35:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 96D4D4B08A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Mar 2020 08:35:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r7eMxQU3kylt for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Mar 2020 08:35:11 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E72A4A4FC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Mar 2020 08:35:11 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 24C3D2080C;
 Tue, 24 Mar 2020 12:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1585053310;
 bh=1JmNFomT0l3uDtttAy7pqv/qb5pJWZXxKY5fJT8GM/k=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=fZDmtzWt0FD2a12FpTHubNlYWp9GDkmFviVJyK6WuK9xHBDKCImt7q1gGHmBTZwlt
 F+n8rX3WkyMa8JQ8up5AA97HK5uQEo3r5sTt8sBHMIwZOvATBD8/ftB4OkyuSEes8p
 qkWe+2Miv9jT/3+ICE2sXw2LFsTMuhYbPLbCYGUI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jGilw-00FFxJ-8y; Tue, 24 Mar 2020 12:35:08 +0000
Date: Tue, 24 Mar 2020 12:35:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v6 14/23] irqchip/gic-v4.1: Add VSGI allocation/teardown
Message-ID: <20200324123506.6d71b04a@why>
In-Reply-To: <f778d757-0312-5412-668c-db9aee889cf0@huawei.com>
References: <20200320182406.23465-1-maz@kernel.org>
 <20200320182406.23465-15-maz@kernel.org>
 <f778d757-0312-5412-668c-db9aee889cf0@huawei.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 tglx@linutronix.de, eric.auger@redhat.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Tue, 24 Mar 2020 10:43:09 +0800
Zenghui Yu <yuzenghui@huawei.com> wrote:

> Hi Marc,
> 
> On 2020/3/21 2:23, Marc Zyngier wrote:
> > Allocate per-VPE SGIs when initializing the GIC-specific part of the
> > VPE data structure.
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> > Link: https://lore.kernel.org/r/20200304203330.4967-15-maz@kernel.org
> > ---
> >   drivers/irqchip/irq-gic-v3-its.c   |  2 +-
> >   drivers/irqchip/irq-gic-v4.c       | 68 +++++++++++++++++++++++++++++-
> >   include/linux/irqchip/arm-gic-v4.h |  4 +-
> >   3 files changed, 71 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> > index 15250faa9ef7..7ad46ff5f0b9 100644
> > --- a/drivers/irqchip/irq-gic-v3-its.c
> > +++ b/drivers/irqchip/irq-gic-v3-its.c
> > @@ -4053,7 +4053,7 @@ static int its_sgi_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
> >   	struct its_cmd_info *info = vcpu_info;  
> >   >   	switch (info->cmd_type) {  
> > -	case PROP_UPDATE_SGI:
> > +	case PROP_UPDATE_VSGI:
> >   		vpe->sgi_config[d->hwirq].priority = info->priority;
> >   		vpe->sgi_config[d->hwirq].group = info->group;
> >   		its_configure_sgi(d, false);  
> 
> [...]
> 
> > @@ -103,7 +105,7 @@ enum its_vcpu_info_cmd_type {
> >   	SCHEDULE_VPE,
> >   	DESCHEDULE_VPE,
> >   	INVALL_VPE,
> > -	PROP_UPDATE_SGI,
> > +	PROP_UPDATE_VSGI,
> >   };  
> >   >   struct its_cmd_info {  
> 
> As Eric pointed out, this belongs to patch #12.

Dammit. This is the *3rd* time I fsck the rebase. Someone *please* hit
me on the head. Hard.

Now *really* fixed:

https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/commit/?h=kvm-arm64/gic-v4.1&id=05d32df13c6b3c0850b68928048536e9a736d520

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
