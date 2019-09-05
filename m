Return-Path: <SRS0=E5f7=XA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26D06C3A5A5
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 12:16:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AB42A21883
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 12:16:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AB42A21883
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22FC24A594;
	Thu,  5 Sep 2019 08:16:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cJO4lqY6rs76; Thu,  5 Sep 2019 08:16:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5F974A525;
	Thu,  5 Sep 2019 08:16:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E133C4A525
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 08:16:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Qs5jFYxcEg3P for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Sep 2019 08:16:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 192AF4A520
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 08:16:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A3E128;
 Thu,  5 Sep 2019 05:16:40 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EA823F718;
 Thu,  5 Sep 2019 05:16:40 -0700 (PDT)
Date: Thu, 5 Sep 2019 14:16:38 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: Re: [PATCH 1/1] KVM: inject data abort if instruction cannot be
 decoded
Message-ID: <20190905121638.GD4320@e113682-lin.lund.arm.com>
References: <20190904180736.29009-1-xypron.glpk@gmx.de>
 <20190905092039.GG32415@stefanha-x1.localdomain>
 <561eae08-c5f1-9543-275c-0da0a85cd7df@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <561eae08-c5f1-9543-275c-0da0a85cd7df@gmx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
 Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org,
 Stefan Hajnoczi <stefanha@redhat.com>, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Heinrich,

On Thu, Sep 05, 2019 at 02:01:36PM +0200, Heinrich Schuchardt wrote:
> On 9/5/19 11:20 AM, Stefan Hajnoczi wrote:
> > On Wed, Sep 04, 2019 at 08:07:36PM +0200, Heinrich Schuchardt wrote:
> > > If an application tries to access memory that is not mapped, an error
> > > ENOSYS, "load/store instruction decoding not implemented" may occur.
> > > QEMU will hang with a register dump.
> > > 
> > > Instead create a data abort that can be handled gracefully by the
> > > application running in the virtual environment.
> > > 
> > > Now the virtual machine can react to the event in the most appropriate
> > > way - by recovering, by writing an informative log, or by rebooting.
> > > 
> > > Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> > > ---
> > >   virt/kvm/arm/mmio.c | 4 ++--
> > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
> > > index a8a6a0c883f1..0cbed7d6a0f4 100644
> > > --- a/virt/kvm/arm/mmio.c
> > > +++ b/virt/kvm/arm/mmio.c
> > > @@ -161,8 +161,8 @@ int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
> > >   		if (ret)
> > >   			return ret;
> > >   	} else {
> > > -		kvm_err("load/store instruction decoding not implemented\n");
> > > -		return -ENOSYS;
> > > +		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
> > > +		return 1;
> > 
> > I see this more as a temporary debugging hack than something to merge.
> > 
> > It sounds like in your case the guest environment provided good
> > debugging information and you preferred it over debugging this from the
> > host side.  That's fine, but allowing the guest to continue running in
> > the general case makes it much harder to track down the root cause of a
> > problem because many guest CPU instructions may be executed after the
> > original problem occurs.  Other guest software may fail silently in
> > weird ways.  IMO it's best to fail early.
> > 
> > Stefan
> > 
> 
> As virtual machine are ubiquitous, expect also mission critical system
> to run on them. At development time halting a machine may be a good
> idea. In production this is often the worst solution. Rebooting may be
> essential for survival.
> 
> For an anecdotal example see:
> https://www.hq.nasa.gov/alsj/a11/a11.1201-pa.html
> 
> I am convinced that leaving it to the guest to decide how to react is
> the best choice.
> 
Maintaining strong adherence to the architecture is equally important,
and I'm sure we can find anecdotes to support how not doing the
expected, can also lead to disastrous outcomes.

Have you had a look at the suggested patch I sent?  The idea is that we
can preserve existing legacy ABI, allow for a better debugging
experience, allow userspace to do emulation if it so wishes, and provide
a better error message if userspace doesn't handle this properly.

One thing we could change from my proposed patch would be to have KVM
inject the access as an external abort if the target address also
doesn't hit an MMIO device, which is by far the common scenario reported
here on the list.

Hopefully, a mission critical deployment based on KVM/Arm (scary as that
sounds), would use a recent and patched VMM (QEMU) that either causes
the external abort, or reboots the VM, as per the configuration of the
particular system in question.


Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
