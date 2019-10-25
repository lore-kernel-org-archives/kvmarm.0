Return-Path: <SRS0=vP85=YS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF0E4CA9EBC
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 10:12:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5F2FA20679
	for <kvmarm@archiver.kernel.org>; Fri, 25 Oct 2019 10:12:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F2FA20679
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B88964A5C6;
	Fri, 25 Oct 2019 06:12:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k+nW4XSZgQes; Fri, 25 Oct 2019 06:12:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C7004A5C8;
	Fri, 25 Oct 2019 06:12:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76F0E4A5C5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 06:12:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KYQvWkE+1Fqt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Oct 2019 06:12:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E71104A53F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Oct 2019 06:12:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F65028;
 Fri, 25 Oct 2019 03:12:32 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 026823F6C4;
 Fri, 25 Oct 2019 03:12:31 -0700 (PDT)
Date: Fri, 25 Oct 2019 12:12:30 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Shannon Zhao <shannon.zhao@linux.alibaba.com>
Subject: Re: [PATCH RFC 0/7] Support KVM being compiled as a kernel module on
 arm64
Message-ID: <20191025101230.GJ2652@e113682-lin.lund.arm.com>
References: <1571912870-18471-1-git-send-email-shannon.zhao@linux.alibaba.com>
 <8cbd81d6-4ab8-9d2a-5162-8782201cd13d@arm.com>
 <c17e8b0f32902a0811cc6a4ed71e607e@www.loen.fr>
 <18653462-38dc-cce1-d0a1-2a7e891163da@linux.alibaba.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <18653462-38dc-cce1-d0a1-2a7e891163da@linux.alibaba.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
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

On Fri, Oct 25, 2019 at 10:48:46AM +0800, Shannon Zhao wrote:
> 
> 
> On 2019/10/24 21:41, Marc Zyngier wrote:
> > On 2019-10-24 11:58, James Morse wrote:
> > > Hi Shannon,
> > > 
> > > On 24/10/2019 11:27, Shannon Zhao wrote:
> > > > Curently KVM ARM64 doesn't support to compile as a kernel module. It's
> > > > useful to compile KVM as a module.
> > > 
> > > > For example, it could reload kvm without rebooting host machine.
> > > 
> > > What problem does this solve?
> > > 
> > > KVM has some funny requirements that aren't normal for a module. On
> > > v8.0 hardware it must
> > > have an idmap. Modules don't usually expect their code to be
> > > physically contiguous, but
> > > KVM does. KVM influences they way some of the irqchip stuff is set up
> > > during early boot
> > > (EOI mode ... not that I understand it).
> > 
> > We change the EOImode solely based on how we were booted (EL2 or not).
> > KVM doesn't directly influences that (it comes in the picture much
> > later).
> > 
> > > (I think KVM-as-a-module on x86 is an artifact of how it was developed)
> > > 
> > > 
> > > > This patchset support this feature while there are some limitations
> > > > to be solved. But I just send it out as RFC to get more suggestion and
> > > > comments.
> > > 
> > > > Curently it only supports for VHE system due to the hyp code section
> > > > address variables like __hyp_text_start.
> > > 
> > > We still need to support !VHE systems, and we need to do it with a
> > > single image.
> > > 
> > > 
> > > > Also it can't call
> > > > kvm_update_va_mask when loading kvm module and kernel panic with below
> > > > errors. So I make kern_hyp_va into a nop funtion.
> > > 
> > > Making this work for the single-Image on v8.0 is going to be a
> > > tremendous amount of work.
> > > What is the payoff?
> > 
> > I can only agree. !VHE is something we're going to support for the
> > foreseeable
> > future (which is roughly equivalent to "forever"), and modules have
> > properties
> > that are fundamentally incompatible with the way KVM works with !VHE.
> > 
> Yes, with this patchset we still support !VHE system with built-in KVM.
> While for VHE system we could support kernel module and check at module init
> to avoid wrong usage of kvm module on !VHE systems.
> 
> > If the only purpose of this work is to be able to swap KVM implementations
> > in a development environment, then it really isn't worth the effort.
> > 
> Making KVM as a kernel module has many advantages both for development and
> real use environment. For example, we can backport and update KVM codes
> independently and don't need to recompile kernel. Also making KVM as a
> kernel module is a basic for kvm hot upgrade feature without shutdown VMs
> and hosts. This is very important for Cloud Service Provider to provides
> non-stop services for its customers.
> 
But KVM on arm64 is pretty intertwined with the rest of the kernel, and
things like the arch timers, for example, really depend on the exact
semantics of how the rest of the kernel changes.  I fear that you'd end
up back-porting patches that depend on changes to irqchip and timers in
the core code, and you'll get even more oddly-defined behavior in the
wild.

How would you manage that, and how would the end result be a more stable
environment than what you have today?

Also, I'm curious if you expect to find more bugs in the hypervisor
itself than in the rest of the kernel, because it's only in the former
case you can avoid a reboot of the host, and all things considered this
would appear to only help in a small fraction of the cases where you
have to patch things?


Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
