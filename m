Return-Path: <SRS0=dOSa=5Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3B4C43331
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 12:36:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 97AB92072E
	for <kvmarm@archiver.kernel.org>; Tue, 31 Mar 2020 12:36:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3pH8396"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 97AB92072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DA454A531;
	Tue, 31 Mar 2020 08:36:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mnim8XsnOoNu; Tue, 31 Mar 2020 08:36:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AD344B082;
	Tue, 31 Mar 2020 08:36:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A885F4A531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 08:36:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qcFpkFuMQp9U for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Mar 2020 08:36:14 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 797354A3B4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2020 08:36:14 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 55ACA2072E;
 Tue, 31 Mar 2020 12:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1585658173;
 bh=ik9TKDFEsxK8Wd37tq/DBcbZiohbTaTtk/UOLgSpjaA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=P3pH8396YzrMhoIrOrKvsl8Ogou3fHgmSeLnL15LCOBCq5yGlTbw+KLV0kdB7gNfl
 Is8GtkO0jVqFTs1XcDwti05xDFCeVu0E+w5HJ3Q8N4tajlNR2e79SWYGEQniQxnGpx
 fWzdxTbr90i5gE1owK7XaAPCkhZW5jkvjt3idR/g=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jJG7n-00HCA5-1m; Tue, 31 Mar 2020 13:36:11 +0100
Date: Tue, 31 Mar 2020 13:36:09 +0100
From: Marc Zyngier <maz@kernel.org>
To: Janne Karhunen <janne.karhunen@gmail.com>
Subject: Re: kvm stage 2 mapping logic
Message-ID: <20200331133609.08e89abc@why>
In-Reply-To: <CAE=NcrY4K-K8eWwW-8+8J8P2Wg3TnJc-TQko117X=aTy8bQFPQ@mail.gmail.com>
References: <CAE=NcrY4K-K8eWwW-8+8J8P2Wg3TnJc-TQko117X=aTy8bQFPQ@mail.gmail.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: janne.karhunen@gmail.com, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu
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

On Tue, 31 Mar 2020 14:17:51 +0300
Janne Karhunen <janne.karhunen@gmail.com> wrote:

Hi Janne,

> Hi,
> 
> I'm experimenting with the kvm in order to see how it would work in
> co-existence with a tiny external hypervisor that also runs the host
> in el1/vmid 0.

Popular theme these days...

> More about this later on in case it turns out to be
> anything generally useful, but I've been stuck for a few days now
> understanding the kvm stage-2 (ipa-to-phys) mapping when the guest is
> being created. Things I think I've understood so far;
> 
> - qemu mmaps the guest memory per the machine type (virt in my case)
> - qemu pushes the machine physical memory model in the kernel through
> the kvm_vm_ioctl_set_memory_region()
> - kvm has mmu notifier block set to listen to the changes to these
> regions and it becomes active after the machine memory model arrives.
> The mmu notifier calls handle_hva_to_gpa() that dispatches the call to
> the appropriate map or unmap handler and these do the s2 mapping
> changes for the vm as needed

Note that these MMU notifiers only make sense when something happens on
the host: attribute change (for page aging, for example) or unmap
(e.g. page being swapped out).

> - prior to starting the vm, kvm_arch_prepare_memory_region() is given
> a try to see if any IO areas could be s2 mapped before the host is
> allowed to execute. This is mostly an optimization?

Yes, and not necessarily a useful one. I think I have a patch to drop
that.

> - vcpu is started
> - as the pages are touched when the vcpu starts executing, page faults
> get generated and the real s2 mappings slowly start to get created.
> LRU keeps the active pages pinned in memory, others will get evicted
> and their s2 mapping eventually disappears
> - all in all, the vm runs and behaves pretty much like a normal
> userspace process

Indeed, just with a different set of page tables.

> Is this roughly the story? If it is, I'm a bit lost where the stage2
> page fault handler that is supposed to generate the s2 mappings is.

user_mem_abort() is your friend (or not, it's a very nasty piece of
code). If you trace the fault handling path all the way from the EL2
vectors, you will eventually get there.

> It
> was surprisingly easy to get the external hypervisor (with very
> minimal changes to the kvm) to the point when the guest is being
> entered and the vmid 1 starts to refer to the instructions at the vm
> ram base (0x4000 0000 for virt). Those, of course, currently scream
> bloody murder as the s2 mapping does not exist.

Well, *something* must be handling the fault, right? But if you've
wrapped the host with its own S2 page tables, it may not be able to
populate the S2 pages for the guest (wild guess...).

Hope this helps,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
