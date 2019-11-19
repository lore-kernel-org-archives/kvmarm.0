Return-Path: <SRS0=mm64=ZL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858F3C43215
	for <kvmarm@archiver.kernel.org>; Tue, 19 Nov 2019 14:32:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 071F4222A9
	for <kvmarm@archiver.kernel.org>; Tue, 19 Nov 2019 14:32:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 071F4222A9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 669E94AEAF;
	Tue, 19 Nov 2019 09:32:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q0zqXjgrIaYq; Tue, 19 Nov 2019 09:32:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C9EA4AC87;
	Tue, 19 Nov 2019 09:32:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 357974A610
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Nov 2019 09:32:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UfJcDN7sKwkJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Nov 2019 09:32:49 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E403C4A5C3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Nov 2019 09:32:48 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E00930E;
 Tue, 19 Nov 2019 06:32:48 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A036D3F6C4;
 Tue, 19 Nov 2019 06:32:47 -0800 (PST)
Date: Tue, 19 Nov 2019 14:32:43 +0000
From: Andre Przywara <andre.przywara@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 2/3] kvm: arm: VGIC: Scan all IRQs when interrupt group
 gets enabled
Message-ID: <20191119143243.28378f8d@donnerap.cambridge.arm.com>
In-Reply-To: <4245ee82a03c9403f8e4ff815f032709@www.loen.fr>
References: <20191108174952.740-1-andre.przywara@arm.com>
 <20191108174952.740-3-andre.przywara@arm.com>
 <20191110142914.6ffdfdfa@why>
 <20191112093658.08f248c5@donnerap.cambridge.arm.com>
 <9ddab86ca3959acbb8b7aad24be5f1ad@www.loen.fr>
 <20191118141216.352a3a0a@donnerap.cambridge.arm.com>
 <4245ee82a03c9403f8e4ff815f032709@www.loen.fr>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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

On Tue, 19 Nov 2019 09:40:40 +0000
Marc Zyngier <maz@kernel.org> wrote:

Hi Marc,

[ ... ]

> >>
> >> I think that could work. One queue for each group, holding pending,
> >> enabled, group-disabled interrupts. Pending, disabled interrupts are
> >> not queued anywhere, just like today.
> >>
> >> The only snag is per-cpu interrupts. On which queue do they live?
> >> Do you have per-CPU queues? or a global one?  
> >
> > Yes, the idea was to have a per-VCPU "grp_dis_list" in addition to
> > the ap_list, reusing the ap_list list_head in struct vgic_irq.
> > vgic_queue_irq_unlock() would put them into *one* of those two lists,
> > depending on their group-enabled status. When a group gets enabled, 
> > we
> > just have to transfer the IRQs from grp_dis_list to ap_list.
> >
> > But fleshing this out I was wondering if it couldn't be much simpler:
> > We ignore the group-enabled status most of the time, except in
> > vgic_flush_lr_state(). So group-disabled IRQs *would go* to the
> > ap_list (when they are otherwise pending|active and enabled), but
> > would be skipped when eventually populating the LRs.
> > vgic_prune_ap_list would also not touch them, so they would stay in
> > the ap_list (unless removed for other reasons).
> >
> > That might raise some eyebrows (because we keep IRQs in the ap_list
> > which are not ready), but would require only minimal changes and 
> > avoid
> > all kind of nasty/racy code to be added. The only downside I see is
> > that the ap_list could potentially be much longer, but we could 
> > change
> > the sorting algorithm if needed to keep group-disabled IRQs at the
> > end, at which point it wouldn't really matter.
> >
> > Do you see any problem with that approach? Alex seemed to remember
> > that you had an objection against a very similar (if not identical)
> > idea before.  
> 
> My main worry with this is that it causes overhead on the fast path.
> Disabled interrupts (for whichever reason they are disabled) shouldn't
> have to be evaluated on the fast path.
> 
> Take for example kvm_vgic_vcpu_pending_irq(), which we evaluate pretty
> often (each time a vcpu wakes up). Do we want to scan a bunch of
> group-disabled interrupts there? No.
> 
> At the end of the day, what we're looking at is a list of disabled,
> pending interrupts. They can be disabled for multiple reasons
> (group is disabled, or interrupt itself is disabled). But they should
> *not* end-up on the AP list, because that list has a precise semantic.
> 
> Your suggestion to add the group-disabled interrupts to the AP list
> may be a cool hack, but it is mostly a hack that opens the whole thing
> to a bunch of corner cases. Let's not do that.

I understand what you are saying, and I had similar gripes. It was just too tempting to not give it a try ;-)
 
> >> >> And if a group has
> >> >> been disabled, how do you retire these interrupts from the AP   
> >> list?  
> >> >
> >> > This is done above: we kick the respective VCPU and rely on
> >> > vgic_prune_ap_list() to remove them (that uses   
> >> vgic_target_oracle(),  
> >> > which in turn checks vgic_irq_is_grp_enabled()).  
> >>
> >> But what if the CPU isn't running? Kicking it isn't going to do 
> >> much,
> >> is it?  
> >
> > Not directly, but in either approach that would be handled similar to
> > disabled interrupts: once the VCPU runs, they would *not* end up in
> > LRs (because we check the oracle before), and would be cleaned up in
> > prune() once the guest exits (at least for the original approach).  
> 
> I lost track of the original approach already :-/
> 
> Try and build the above suggestion. It should follow the same flow as
> the enabled, group-enabled interrupts, just with a different list.

OK, will do.

Thanks!

Andre.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
