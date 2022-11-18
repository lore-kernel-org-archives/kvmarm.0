Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE32C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 18 Nov 2022 17:04:52 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03E374B83A;
	Fri, 18 Nov 2022 12:04:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 51ZjASzwkiEN; Fri, 18 Nov 2022 12:04:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A33B84B8F2;
	Fri, 18 Nov 2022 12:04:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27DDF4B83A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 12:04:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c1rYIylDdY3Z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Nov 2022 12:04:48 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A61694B6C5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Nov 2022 12:04:48 -0500 (EST)
Date: Fri, 18 Nov 2022 17:04:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668791087;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=TT9WIDG2PcC0Y0VIGysC67t4tuJ3IbUzD2E14K7Mj+U=;
 b=LGYC1eBuUtn8jOWDiDcXMIJ1YnhdPWLXut1ZBEcavASub+m8ULYW0AASixs5J/vq/3BhV1
 mVS8burSTjm3iAAFWmAcG5ZCDTMyuAxBv3B0ihS0N/cgR1xxf7HIwJlJWJnK35X8d7ijLp
 fU7waACJ//jWMMIY9avT7eDUsKoxS+A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH 2/3] KVM: arm64: Allow userspace to trap SMCCC
 sub-ranges
Message-ID: <Y3e7KqJKz6nHjFSu@google.com>
References: <20221110015327.3389351-1-oliver.upton@linux.dev>
 <20221110015327.3389351-3-oliver.upton@linux.dev>
 <20221118145637.GC4624@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20221118145637.GC4624@willie-the-truck>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, Paolo Bonzini <pbonzini@redhat.com>,
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

On Fri, Nov 18, 2022 at 02:56:38PM +0000, Will Deacon wrote:
> On Thu, Nov 10, 2022 at 01:53:26AM +0000, Oliver Upton wrote:
> > As the SMCCC (and related specifications) march towards an
> > 'everything and the kitchen sink' interface for interacting with a
> > system, it is less likely that KVM will implement every supported
> > feature.
> > 
> > Add a capability that allows userspace to trap hypercall ranges,
> > allowing the VMM to mix-and-match between calls handled in userspace vs.
> > KVM.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  5 ++++
> >  arch/arm64/include/uapi/asm/kvm.h | 15 ++++++++++
> >  arch/arm64/kvm/arm.c              | 10 +++++++
> >  arch/arm64/kvm/hypercalls.c       | 48 +++++++++++++++++++++++++++++++
> >  include/uapi/linux/kvm.h          |  1 +
> >  5 files changed, 79 insertions(+)
> 
> [...]
> 
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 6f0b56e7f8c7..6e8a222fc295 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -100,6 +100,13 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> >  		r = 0;
> >  		set_bit(KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED, &kvm->arch.flags);
> >  		break;
> > +	case KVM_CAP_ARM_USER_HYPERCALLS:
> > +		if (cap->args[0] & ~KVM_ARM_USER_HYPERCALL_FLAGS)
> > +			return -EINVAL;
> 
> Why not use KVM_CAP_EXIT_HYPERCALL for this?

Err... I hilariously hijacked its UAPI for the exit but added a new cap
for it :)

I think the direction going forward will be to provide userspace with a
range-based filter such that (to a degree) we can arbitrarily forward
hypercalls to userspace, allowing for a mix-and-match approach.

> At some point during pKVM
> development, we used that to notify the VMM about memory being shared
> back from the guest but we eventually dropped it as the notification to
> userspace ended up not being needed:
> 
> https://android-kvm.googlesource.com/linux/+/dbd2861832dfc4c8a3103214b3c212ee7ace1c44%5E%21/
> https://android-kvm.googlesource.com/linux/+/2a3afc6da99c0e0cb62be1687153ee572903aa80%5E%21/
> 
> I'm not saying that what we did was necessarily better, but it seems a bit
> simpler and I figured it might be useful to point you to it.

Yeah, this is certainly a lot cleaner than what I've proposed here. And
frankly, for my immediate interest (forwarding vendor hypercalls to
userspace), this would fit the bill. OTOH, I was hoping that something
a bit more flexible could move the onus of implementing every darn spec
onto userspace (where possible).

I know you said pKVM has no need for userspace notifications at this
moment, but could user hypercalls be useful again going forward?

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
