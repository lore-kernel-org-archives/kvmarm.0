Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBF14C2BB86
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 12:52:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 418922082D
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 12:52:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2HDDYnPL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 418922082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C71A54A522;
	Fri, 10 Apr 2020 08:52:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iTfVm44fxU7D; Fri, 10 Apr 2020 08:52:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89B1E4B0BA;
	Fri, 10 Apr 2020 08:52:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20FB54B0BA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 08:52:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zjgSpLDQesGH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2020 08:52:41 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E67884A522
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 08:52:40 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C7BAE20769;
 Fri, 10 Apr 2020 12:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586523159;
 bh=+tK1G8/YCJG+rNtFQbFqXIFBjrvfB0e8dfWiL/dTRbo=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=2HDDYnPLhLHkf2dQKH2JWbYduhZe9x8iQLU//3mSJ9Le1sN/+dsHuJPVH6iJLnqE7
 FzyzMWpOR2jTRDRDMzzHrSBuwspYHGv0SY5n6Qk48sbMR9fsqrse/YmqKcrZuJ/+4Z
 uRL3vLndKgh1hZs5R42m1qbWtGXRbFrw+EbTsShs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jMt9B-002B0y-II; Fri, 10 Apr 2020 13:52:37 +0100
Date: Fri, 10 Apr 2020 13:52:35 +0100
From: Marc Zyngier <maz@kernel.org>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH RFCv1 0/7] Support Async Page Fault
Message-ID: <d2882e806ad2f9793437160093c8d3fa@kernel.org>
In-Reply-To: <20200410085820.758686-1-gshan@redhat.com>
References: <20200410085820.758686-1-gshan@redhat.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: gshan@redhat.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 suzuki.poulose@arm.com, sudeep.holla@arm.com, drjones@redhat.com,
 eric.auger@redhat.com, shan.gavin@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: catalin.marinas@arm.com, shan.gavin@gmail.com, sudeep.holla@arm.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

Hi Gavin,

On 2020-04-10 09:58, Gavin Shan wrote:
> There are two stages of page faults and the stage one page fault is
> handled by guest itself. The guest is trapped to host when the page
> fault is caused by stage 2 page table, for example missing. The guest
> is suspended until the requested page is populated. To populate the
> requested page can be costly and might be related to IO activities
> if the page was swapped out previously. In this case, the guest has
> to suspend for a few of milliseconds at least, regardless of the
> overall system load.
> 
> The series adds support to asychornous page fault to improve above
> situation. If it's costly to populate the requested page, a signal
> (PAGE_NOT_PRESENT) is sent to guest so that the faulting process can
> be rescheduled if it can be. Otherwise, it is put into power-saving
> mode. Another signal (PAGE_READY) is sent to guest once the requested
> page is populated so that the faulting process can be waken up either
> from either waiting state or power-saving state.
> 
> In order to fulfil the control flow and convey signals between host
> and guest. A IMPDEF system register (SYS_ASYNC_PF_EL1) is introduced.
> The register accepts control block's physical address, plus requested
> features. Also, the signal is sent using data abort with the specific
> IMPDEF Data Fault Status Code (DFSC). The specific signal is stored
> in the control block by host, to be consumed by guest.
> 
> Todo
> ====
> * CONFIG_KVM_ASYNC_PF_SYNC is disabled for now because the exception
>   injection can't work in nested mode. It might be something to be
>   improved in future.
> * KVM_ASYNC_PF_SEND_ALWAYS is disabled even with CONFIG_PREEMPTION
>   because it's simply not working reliably.
> * Tracepoints, which should something to be done in short term.
> * kvm-unit-test cases.
> * More testing and debugging are needed. Sometimes, the guest can be
>   stuck and the root cause needs to be figured out.

Let me add another few things:

- KVM/arm is (supposed to be) an architectural hypervisor. It means
  that one of the design goal is to have as few differences as possible
  from the actual hardware. I'm not keen on deviating from it (next
  thing you know, you'll add all the PV horror from Xen, HV, VMware...). 

- The idea of butchering the arm64 mm subsystem to handle a new exotic
  style of exceptions is not something I am looking forward to. We
  might as well PV the whole MMU, Xen style, and be done with it. I'll
  let the arm64 maintainers comment on this though.

- We don't add IMPDEF sysregs, period. That's reserved for the HW. If
  you want to trap, there's the HVC instruction to that effect.

- If this is such a great improvement, where are the performance
  numbers?

- The fact that it apparently cannot work with nesting nor with
  preemption tends to indicate that it isn't future proof.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
