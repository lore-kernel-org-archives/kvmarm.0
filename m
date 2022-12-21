Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF72FC4167B
	for <kvmarm@archiver.kernel.org>; Wed, 21 Dec 2022 16:50:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 851FF4B881;
	Wed, 21 Dec 2022 11:50:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xnWkn29X6CtU; Wed, 21 Dec 2022 11:50:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6311B4B880;
	Wed, 21 Dec 2022 11:50:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D7564B87B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 11:50:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZmwDbBr9XrF8 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Dec 2022 11:50:36 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 98A0F4B86C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Dec 2022 11:50:36 -0500 (EST)
Date: Wed, 21 Dec 2022 16:50:30 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1671641435;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=Xdjf8bxiYHpI/EXjIs05wPVvAMrqG6J7dZ0Cm96qYYk=;
 b=qxoDmMVkSPwg3Qz24+AUYA0y6lpWSkYf2PUOZNWsPkHLlkZmsiNsyWI3G8/uHbGwAMUeUA
 JQf9aZ5PKPis0vEWtlTS1mvtDL3/dB8Hvl3yvja4684hiQ4Ws8MJp3lzApIvYoozbbHiux
 QIczvU9G9oZOR1c6d/2ickYaol8Yw5A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/3] KVM: arm64: Fix S1PTW handling on RO memslots
Message-ID: <Y6M5Vh+EGOhkR5hd@google.com>
References: <20221220200923.1532710-1-maz@kernel.org>
 <20221220200923.1532710-2-maz@kernel.org>
 <Y6IteDoK406o9pM+@google.com> <86pmcdaylx.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <86pmcdaylx.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>, stable@vger.kernel.org,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
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

On Wed, Dec 21, 2022 at 09:35:06AM +0000, Marc Zyngier wrote:

[...]

> > > +	if (kvm_vcpu_abt_iss1tw(vcpu)) {
> > > +		/*
> > > +		 * Only a permission fault on a S1PTW should be
> > > +		 * considered as a write. Otherwise, page tables baked
> > > +		 * in a read-only memslot will result in an exception
> > > +		 * being delivered in the guest.
> > 
> > Somewhat of a tangent, but:
> > 
> > Aren't we somewhat unaligned with the KVM UAPI by injecting an
> > exception in this case? I know we've been doing it for a while, but it
> > flies in the face of the rules outlined in the
> > KVM_SET_USER_MEMORY_REGION documentation.
> 
> That's an interesting point, and I certainly haven't considered that
> for faults introduced by page table walks.
> 
> I'm not sure what userspace can do with that though. The problem is
> that this is a write for which we don't have useful data: although we
> know it is a page-table walker access, we don't know what it was about
> to write. The instruction that caused the write is meaningless (it
> could either be a load, a store, or an instruction fetch). How do you
> populate the data[] field then?
> 
> If anything, this is closer to KVM_EXIT_ARM_NISV, for which we give
> userspace the full ESR and ask it to sort it out. I doubt it will be
> able to, but hey, maybe it is worth a shot. This would need to be a
> different exit reason though, as NISV is explicitly for non-memslot
> stuff.
> 
> In any case, the documentation for KVM_SET_USER_MEMORY_REGION needs to
> reflect the fact that KVM_EXIT_MMIO cannot represent a fault due to a
> S1 PTW.

Oh I completely agree with you here. I probably should have said before,
I think the exit would be useless anyway. Getting the documentation in
line with the intended behavior seems to be the best fix.

> >
> > > +		 * The drawback is that we end-up fauling twice if the
> > 
> > typo: s/fauling/faulting/
> > 
> > > +		 * guest is using any of HW AF/DB: a translation fault
> > > +		 * to map the page containing the PT (read only at
> > > +		 * first), then a permission fault to allow the flags
> > > +		 * to be set.
> > > +		 */
> > > +		switch (kvm_vcpu_trap_get_fault_type(vcpu)) {
> > > +		case ESR_ELx_FSC_PERM:
> > > +			return true;
> > > +		default:
> > > +			return false;
> > > +		}
> > > +	}
> > >  
> > >  	if (kvm_vcpu_trap_is_iabt(vcpu))
> > >  		return false;
> > > -- 
> > > 2.34.1
> > > 
> > 
> > Besides the changelog/comment suggestions, the patch looks good to me.
> > 
> > Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> Thanks for the quick review! I'll wait a bit before respinning the
> series, as I'd like to get closure on the UAPI point you have raised.

I'm satisfied if you are :)

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
