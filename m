Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A582C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 11 Nov 2022 23:39:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4F534B621;
	Fri, 11 Nov 2022 18:39:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GxY4Hh-bhnin; Fri, 11 Nov 2022 18:39:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 340CA4B6E9;
	Fri, 11 Nov 2022 18:39:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8E064B632
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2022 18:39:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tpshG3pLvZtT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Nov 2022 18:39:14 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4FC114B621
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Nov 2022 18:39:14 -0500 (EST)
Date: Fri, 11 Nov 2022 23:39:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668209953;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=zIYQx8/+sO34DwoG2CiugqgOKWcAgSm6gxrxSDTWj7M=;
 b=h1QJ4NkA5S3hZo0nWLXh6z8hWAamDw5T9WdqI/3tjUFAmKDAR0JJbmWNFHmnDn6wf1RNF9
 6XwhqF2KKw1JFa/cRJsrxDGkTIJU3hLJFmytRs9qVy2qGFN2uBimBh243lhAXDGmanBWr/
 ptGzbyl7uS2g1CxhCgD4ZdQKLLPy5DI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [RFC PATCH 2/3] KVM: arm64: Allow userspace to trap SMCCC
 sub-ranges
Message-ID: <Y27dHf+PRt+G4jNg@google.com>
References: <20221110015327.3389351-1-oliver.upton@linux.dev>
 <20221110015327.3389351-3-oliver.upton@linux.dev>
 <86o7tfov7v.wl-maz@kernel.org> <Y21pktYPLPM6eYga@google.com>
 <87fsepvqw5.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87fsepvqw5.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
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

On Fri, Nov 11, 2022 at 08:26:02AM +0000, Marc Zyngier wrote:
> On Thu, 10 Nov 2022 21:13:54 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > The goal of what I was trying to get at is that either the kernel or
> > userspace takes ownership of a range that has an ABI, but not both. i.e.
> > you really wouldn't want some VMM or cloud provider trapping portions of
> > KVM's vendor-specific range while still reporting a 'vanilla' ABI at the
> > time of discovery. Same goes for PSCI, TRNG, etc.
> 
> But I definitely think this is one of the major use cases. For
> example, there is value in taking PSCI to userspace in order to
> implement a newer version of the spec, or to support sub-features that
> KVM doesn't (want to) implement. I don't think this changes the ABI from
> the guest perspective.

I disagree for the implications of partially trapping the 'Vendor
Specific Hypervisor Service'. If the UID for the range still reports KVM
but userspace decided to add some new widget, then from the guest
perspective that widget is now part of KVM's own ABI with the guest.

Trapping the whole range is a bit of a hack to workaround the need for
more complicated verification of a hypercall filter.

But for everything else, I'm fine with arbitrary function filtering.
Userspace is always welcome to shoot itself in the foot.

> pKVM also has a use case for this where userspace gets a notification
> of the hypercall that a guest has performed to share memory.

Is that hypercall in the 'Vendor Specific Hypervisor Service' range?

> Communication with a TEE also is on the cards, as would be a FFA
> implementation. All of this could be implemented in KVM, or in
> userspace, depending what users of these misfeatures want to do.

I'm very hopeful that by forwarding all of this to userspace we can get
out of the business of implementing every darn spec that comes along.

> > > So obviously, this cannot be a simple bitmap. Making it a radix tree
> > > (or an xarray, which is basically the same thing) could work. And the
> > > filtering request from userspace can be similar to what we have for
> > > the PMU filters.
> > 
> > Right, we'll need a more robust data structure for all this.
> > 
> > My only concern is that communicating the hypercall filter between
> > user/kernel with a set of ranges or function numbers is that we could be
> > mutating what KVM *doesn't* already implement into an ABI of sorts.
> > 
> > i.e. suppose that userspace wants to filter function(s) in an
> > unallocated/unused range of function numbers. Later down the line KVM
> > adds support for a new shiny thing and the filter becomes a subset of a
> > now allocated range of calls. We then reject the filter due to the
> > incongruence.
> 
> But isn't the problem to ask for ranges that are unallocated the first
> place? What semantic can userspace give to such a thing other than
> replying "not implemented", which is what the kernel would do anyway?

... assuming we know about all defined services in the kernel. I don't
care about it too much, but there is the case about a new userspace on
an old kernel.

> The more interesting problem is when you want to emulate another
> hypervisor, and that the vendor spaces overlap (a very likely
> outcome). Somehow, this means overriding all the KVM-specific
> hypercalls, and let userspace deal with it. But again, this can be
> done on a per function basis.

Other hypercalls removed, would you be in favor of an all-or-nothing
rule for KVM's vendor range implementation? Of course, that could still
be enforced on whatever UAPI approach we take.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
