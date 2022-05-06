Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A98D1C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  6 May 2022 13:01:15 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2123C4B278;
	Fri,  6 May 2022 09:01:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0RA9SOUIgeUG; Fri,  6 May 2022 09:01:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E8B4C4B208;
	Fri,  6 May 2022 09:01:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F35F84B1BA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 09:01:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YLWdgg0Gx0jr for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2022 09:01:11 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9110A4B17D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2022 09:01:11 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E64AEB834C5;
 Fri,  6 May 2022 13:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD3FC385A8;
 Fri,  6 May 2022 13:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651842068;
 bh=78TflA97GcDiKTkzTzNo81ow+4K3p0br6C/I8gs88JU=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=MmYzcPDPbsRgbpJCkkBat3RoSxhsQbLi9panXSxtaUj1iBwDOvhk++5pG20q/h2cl
 Zs86/1Rib61rKU8TyG4KyOhrS8kbUTc3VZfSqAZwlUxE2azkFmJ1Q56SpCxjymmBXp
 Kv4W8OEksSNcvUu2PTH7nU33KJ+0v7cUYdwXOOdfBBySjlI4lBqNtEHOPypuH51hFy
 pDABUsk6DoAys6rC1XMdf34zV37PJeO5LqryIANR7KHzkbvHhhqtRkdRWp8/TNc+E+
 hG+YbdnspDCaQiXPauuvlrfoTzIilfnohOpuusykYVdgzB74ulERmx0pyOYVyd+qnk
 ROp0WsRv4zRAQ==
Date: Fri, 6 May 2022 14:01:01 +0100
From: Will Deacon <will@kernel.org>
To: Oliver Upton <oupton@google.com>
Subject: Re: [RFC PATCH kvmtool 0/5] ARM: Implement PSCI SYSTEM_SUSPEND
Message-ID: <20220506130101.GC22892@willie-the-truck>
References: <20220311174001.605719-1-oupton@google.com>
 <20220311175717.616958-1-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220311175717.616958-1-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Fri, Mar 11, 2022 at 05:57:12PM +0000, Oliver Upton wrote:
> This is a prototype for supporting KVM_CAP_ARM_SYSTEM_SUSPEND on
> kvmtool. The capability allows userspace to expose the SYSTEM_SUSPEND
> PSCI call to its guests.
> 
> Implement SYSTEM_SUSPEND using KVM_MP_STATE_SUSPENDED, which emulates
> the execution of a WFI instruction in the kernel. Resume the guest when
> a wakeup event is recognized and reset it to the requested entry address
> and context ID.
> 
> Patches 2-4 are small reworks to more easily shoehorn PSCI support into
> kvmtool.
> 
> Patch 5 adds some SMCCC handlers and makes use of them to implement PSCI
> SYSTEM_SUSPEND. For now, just check the bare-minimum, that all vCPUs
> besides the caller have stopped. There are also checks that can be made
> against the requested entry address, but they are at the discretion of
> the implementation.
> 
> Tested with 'echo mem > /sys/power/state' to see that the vCPU is in
> fact placed in a suspended state for the PSCI call. Hacked the switch
> statement to fall through to WAKEUP immediately after to verify the vCPU
> is set up correctly for resume.
> 
> It would be nice if kvmtool actually provided a device good for wakeups,
> since the RTC implementation has omitted any interrupt support.
> 
> kernel changes: http://lore.kernel.org/r/20220311174001.605719-1-oupton@google.com
> 
> Oliver Upton (5):
>   TESTONLY: Sync KVM headers with pending changes
>   Allow architectures to hook KVM_EXIT_SYSTEM_EVENT
>   ARM: Stash vcpu_init in the vCPU structure
>   ARM: Add a helper to re-init a vCPU
>   ARM: Implement PSCI SYSTEM_SUSPEND
> 
>  arm/aarch32/kvm-cpu.c                 | 72 ++++++++++++++++++++
>  arm/aarch64/kvm-cpu.c                 | 66 +++++++++++++++++++
>  arm/include/arm-common/kvm-cpu-arch.h | 23 ++++---
>  arm/kvm-cpu.c                         | 95 ++++++++++++++++++++++++++-
>  arm/kvm.c                             |  9 +++
>  include/kvm/kvm-cpu.h                 |  1 +
>  include/linux/kvm.h                   | 21 ++++++
>  kvm-cpu.c                             |  8 +++
>  8 files changed, 283 insertions(+), 12 deletions(-)

Looks like the kernel-side changes are queued now, so please can you resend
this series? I also think you can drop the AArch32 support, unless you see a
compelling reason for it?

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
