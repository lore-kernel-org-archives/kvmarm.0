Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAF6449996
	for <kvmarm@lists.linux.dev>; Thu,  9 Jul 2026 19:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783623694; cv=none; b=KNpANd3ssrAakMTkgaecmqSL9EbpoUet5KNCHg2RMDwFd7S0CYSJ6pHDwd/pCZS5+skjbVozXAX4y3jveEqNZRoH+jx6S/+HJEXepz19kmKU9MfooBtFLghKPRDHIr3DHKdEgXjMEX4IVFMakv4El8iXwFS2TTDtWQgNH9442lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783623694; c=relaxed/simple;
	bh=mbSLLFPX+/+wGifuU8rvXn+yjD80DQsccM2K7nprCAU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sQmHbpCVrPcOEIYXSqoAQb/QlV56eaa/Y68ReGb5XxQyaucs7X9ostYsF23ap6U/DJqFWhaAs4XM89oA1LhAlAIrihVFUD2IsAO+L/iV8ik3zPqiDiIrpce/6HVKsom9F0A00kPyiaYKM/90ZMdr6UH+WXWL5cJjiFl1YqTYgQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KNhwUpS+; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KNhwUpS+"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8423f544944so81187b3a.3
        for <kvmarm@lists.linux.dev>; Thu, 09 Jul 2026 12:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783623692; x=1784228492; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7dhwp5vjqYszriZEVm0D/39l33x16cKgI34FbGJQXy0=;
        b=KNhwUpS+I4wCm8zo/6CxZK4bXclkTdU0AykWeQ9sGasbpyuJXsbXakG/zG00UoOt5C
         LByi+2j2L7jCaQ3VAQn/jj90FhFU7aaIrWN3kMQtC2r8rLItnd/X1WbCaqPvD3CU/ET7
         T0AN1EF4nAg9o93N/Q0a+yMVhf4F2SJvM0dsWdd3aoEvK+AFIw6gA9sLLcq2xaT6oeMU
         HE1YVBQeubLHVOf7McvotJz9LzXt0Zd+DhDh+rK9K9WGbVeQd8ilwc311dTpiZdRsQV5
         foLLdUGeQ7JB44MdGSfQD0KHwFFXJ5vzCro3WKa/U594h8g7+EXpjdiSC/+ciOPr/8/h
         3gbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783623692; x=1784228492;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7dhwp5vjqYszriZEVm0D/39l33x16cKgI34FbGJQXy0=;
        b=WmWEJBoDK+PL7V3o6ChTEMREK0xUWt58HrS32IuhzmbtrYFwNvMsdT8xpdbAl5Y5sW
         ESM6gjb3UOX8mpgJoBQTf6YYx58Hhd/ftpQi6CKP2DqFs5aBUgIxbrUIqokteJQYTjSv
         9vDuK9IXmaBfm5gM6nZ5XfvgTLjBrqS1yYzWrWXf1Omi8UYHJd4RIETshcfv1TgeahoD
         YBWEBrIvv/soI8cOuVO+NNYpVWbit291T+aALzdGWvTZRKp1HNA+tQAroMHAyDRWXGjf
         +CbwsvcqPmuvTy4P/Enl4MSvm4+sL3VOtHW+xsbu0CQCQOKb3szR0a1Oq23WNnjODMmS
         g3hw==
X-Forwarded-Encrypted: i=1; AHgh+RoPM5hDvK050rg1rG9hsUof3UCTdu21pUj4CjhWbwAsWFgay52DE+eXiTd5jzu45E22kLoL4BQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0+XurbTUWxcf1tV2k+FxGyOzogcOb5eW4doEAbJtwiAL9JOWb
	P4EfDLqxyzSR0+Kt+GqrNwqvet7hxFUt4NYS+v+AAmbI1yoPub7WMrFqOgBvpiQFxA+S7Urzn75
	G1CGIlw==
X-Received: from pglx3.prod.google.com ([2002:a63:1703:0:b0:c85:dc1c:c8ea])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3e18:b0:845:e9e8:6458
 with SMTP id d2e1a72fcca58-84842eda2bfmr8132247b3a.20.1783623692329; Thu, 09
 Jul 2026 12:01:32 -0700 (PDT)
Date: Thu, 9 Jul 2026 12:01:31 -0700
In-Reply-To: <ak-EKSslAz1uqEtv@J2N7QTR9R3>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260702142912.6395-1-alexandru.elisei@arm.com>
 <akxOrMnlNga-vtQv@google.com> <ak0wSQ1133O7B96D@raptor> <ak0ziUcCXUlDdcla@google.com>
 <ak-EKSslAz1uqEtv@J2N7QTR9R3>
Message-ID: <ak_wC4Q-mQe14DI8@google.com>
Subject: Re: [RFC PATCH 0/3] KVM: Dirty page logging for guest_memfd-only memslots
From: Sean Christopherson <seanjc@google.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	david.hildenbrand@arm.com, maz@kernel.org, oupton@kernel.org, 
	joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, fuad.tabba@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 09, 2026, Mark Rutland wrote:
> Hi Sean,
> 
> Ignoring dirty page logging for the moment, I think you've raised a much
> bigger concern.
> 
> I've dumped a bit more context below, with a couple of high-level
> questions. The important thing for Alexandru and I is whether core folk
> are willing to consider some mechanism to ensure that guest PAs are
> pinned writeable and never fault (even transiently).
> 
> On Tue, Jul 07, 2026 at 10:12:41AM -0700, Sean Christopherson wrote:
> > On Tue, Jul 07, 2026, Alexandru Elisei wrote:
> > > On Mon, Jul 06, 2026 at 05:56:12PM -0700, Sean Christopherson wrote:
> > > > On Thu, Jul 02, 2026, Alexandru Elisei wrote:
> 
> > > > Please (publicly) document *why*  you want to add dirty-logging support.  It's
> > > > all but impossible to review new uAPI without knowing the use case.
> 
> > > As to why I'm working on it now, it's because of an arm64 feature that
> > > requires that memory remains mapped at stage 2, called Statistical
> > > Profiling Extension (SPE), similar to Intel's PEBS or AMD's IBS. Exposing
> > > the feature to a guest requires that memory remains mapped at stage 2
> > > outside of userspace explicitely unmapping it, and guest_memfd, with the
> > > patch to ignore the MMU notifiers [1], has this property.  I wanted to
> > > expand the functionality of guest_memfd to support migration of virtual
> > > machines when that arm64 feature is exposed to guests.
> > 
> > I'm all for adding dirty logging support for guest_memfd, but for SPE I don't
> > think relying on guest_memfd always being mapped is a good idea.  guest_memfd
> > is "pinned" purely because adding support for page migration is (very) low
> > priority for SNP, TDX, and pKVM.  guest_memfd page migration might play nice
> > with SPE?  Probably depends on whether KVM is forced to do break-before-make?
> 
> The key thing for SPE is that any pages that the SPE HW is using must
> have a valid writeable end-to-end (VA to real PA) mapping at all times
> while the guest is running (and while the host drains buffers). If that
> requirement is violated, even transiently, then data is lost and the
> guest will see an unexpected fault reported by SPE.

Well, at least it doesn't crash the host :-D

> If there's any reason we might (transiently) unmap a leaf entry (or
> entire sub-tree) from the stage-2 tables, or might (transiently) remove
> write permission, then we can't guarantee SPE will work correctly from
> the guest's PoV.
> 
> Obviously we can't guarantee that for regular memslots backed by
> userspace memory, hence we were hoping we could rely on guest_memfd.
> 
> Am I right to understand that we expect (in future) to do things with
> guest_memfd that could violate that? If so (and if we're not happy to
> have some options to say "always keep this pinned end-to-end no matter
> what"), 

Yes?  Page migration is the main one that I think will be problematic for arm64,
*unless* CPUs that support SPE don't require break-before-make (no idea if there
are even plans to ever drop the BBM rules).  Because with page migration, unless
KVM temporarily jails all vCPUs in the host while swizzling stage-2 PTEs, there
will be a small window of time where the memory isn't mapped.

I mention page migration because I expect swap/reclaim to be fully userspace
driven, i.e. if userspace crashes/corrupts the guest, the answer will be "well
don't do that".  But (at least some forms of) page migration will likely be
kernel-driven, e.g. to compact movable memory for THP.  And I really don't want
to give arch code the ability to hard-pin specific ranges of memory.

That said, odds are good that we'll end up with per-gmem flags to communicate to
guest_memfd whether or not the gmem instance supports page migration (x86's TDX
and SNP in particular require extra consideration).  So if the anticipated use
cases are fine with all-or-nothing "pinning", or with juggling guest_memfd files
in userspace if a more dynamic setup is desired, then you should be ok?

E.g. if the anticipated use cases are all slice-of-hardware style setups where
the VM will be statically assigned a chunk of memory, then for the most part this
will all Just Work.

> then I think that means that in practice we cannot virtualize
> SPE correctly, and Alexandru and I need to go back to our architects.
> 
> > And at some point guest_memfd may support userspace-driven swap, but I
> > suppose we can cross that bridge when we come to it.
> 
> Unfortunately, I think we need to figure out now whether it would be
> acceptable to suppress that (or making it mutually exclusive with SPE),
> if only to decide whether or not we continue trying to virtualize SPE.

Eh, as above, if userspace pulls a stupid and kills the guest, that's their
problem.  Just make sure the host isn't at risk :-)

> We don't need to figure out all the details; just whether or not that
> broad approach would be acceptable, or whether we have to give up on SPE
> virtualization.
> 
> > From a uABI perspective, forcing userspace to use guest_memfd to get access to
> > something like SPE isn't ideal.  While I have aspirations of using guest_memfd
> > much more broadly, I don't know that banking on guest_memfd replacing "everything"
> > is a winning strategy.
> 
> I agree this isn't ideal, and we're certainly not expecting that this is
> suitable for all users. We're just trying to get as much functionality
> as we practically can with today's SPE hardware.
> 
> Thanks,
> Mark.
