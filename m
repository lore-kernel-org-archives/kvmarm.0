Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5861779A5
	for <kvmarm@lists.linux.dev>; Thu,  3 Oct 2024 16:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727973944; cv=none; b=eM1uLbNMF7jqpt3SKo6ynFcYB0ttD2rPDNxNAvMNKpd5bdQXdZwGUhX5aC4a6YZ6h8K7b8TrXTL/lapZ5X5sJFL/OKr082/mJkB/0Cbz6a14UW8oLG6DvEisawQ8H3gv/VFf6XrsV4V0syA2+5jPuE1o5PDCTccawAeQx0AZ89E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727973944; c=relaxed/simple;
	bh=wk9V0Mtzbg8KE2zjSWEnXkYHnOXtRr0v8qPxIZPtLC0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iywh+sNmO56/xZZmras8yDUvaNPgH0BOY9zoi0U4bDKucrDIq4q3AWvaz6TpXbdfGtnB5Uk5lmSFxcUxzKssPDjz79dF+i0XzEOLMGms4FVLEhTKgLr+FyxJqqvbvLY8NbiVQFBXBkV2cPczySd82vk4X8553esNVQzguiKBHDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yEzr1SbG; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yEzr1SbG"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e278b2a5c4so21287857b3.2
        for <kvmarm@lists.linux.dev>; Thu, 03 Oct 2024 09:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727973942; x=1728578742; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=04mzxfGmXyJ4MT+Ke78VUtxlKFsv2NVMG3lAKc3ZGPY=;
        b=yEzr1SbGhxouwjV0JkkGXZCuNfWaowWt+i0IQ0Q5wa17CwXiGMsFOwI7snraFhntvN
         Hyoow/uN3hodTZ2jwCYZxLJ4mUYBhd3ANodtI+psdGZRINv9tTDZER6QK2B4ePVoL8jW
         ZvHYKHf3CpNVqJElhVcK6+X1oRKpovdcAsWLIUECj/a/FF0UBCTMKbqoaWYQc8tV56D1
         iuGn1BPIounXX4DVtv2J2M24UysnycZeciCbI0GuNkIdpwfygHv5u8l5HvH8LNpel4DN
         ZG8BT0pqJ2F6FH/1nIYsJrBC5cxX/Mq1+1MXAFNQJtqU0szvO+ZFbGX5Dr6QXudHOPDj
         wOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727973942; x=1728578742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=04mzxfGmXyJ4MT+Ke78VUtxlKFsv2NVMG3lAKc3ZGPY=;
        b=vANVM5dM/8E3E9B9jQoSzPEy2AZxF2r9UhbNwElXxYjcycP15PP2CpbmseMRbqgpGs
         2xGzpcjFgrFNlTDs8GQzLodeEIBwtmy6qgjQcEypjF07Pptdv+oiPAaZJwnLbDjOKZvD
         1n9iNxacU925C7Jz0lvO3lvTAJA/GyHZOU6sfZAQ2ovGR42Wsybg3KB0Wm51DKQYv4IX
         KCtoveubTOSIPiNumtn/KaWtJIkAxmYVNb48lhQ6aieHKIMFSvn7YkKmZF65rIFq5OuH
         tMv54GetJFvrxcEhWQO+apBct4/Q4ZBF/b8p5QMTJRKqp6Tdp3xuUq3tGQqQ287aSgwK
         ZR/w==
X-Forwarded-Encrypted: i=1; AJvYcCX/KUTV4JaaU7M2+mAQPe7aNydZ0/XX/7uWvDXpZvsgMgWez48HhzPxz4fITNhyxroiR6SkUmA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrZ7BWYSW8X4tdZClXmgpIJ1VNhQLYo9xcBuT+8fev/ZBfwHZI
	Ji1MO9Zkc5eBisbasURrZ6JwMtdg0xrGrnc4rM5fS4jXKE2zqrvFExOPOl8V+oofgsn0PPxjnL1
	PHg==
X-Google-Smtp-Source: AGHT+IGDZSwW96xge+RMgP0cpWWM9mcSzylTfeYpcdzKxjsPSn/L9lANYgFFFnWLVM7i93X60jjDGBWA6GE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6ac8:b0:6e2:2600:ed65 with SMTP id
 00721157ae682-6e2a2ad8e5fmr1248917b3.1.1727973941957; Thu, 03 Oct 2024
 09:45:41 -0700 (PDT)
Date: Thu, 3 Oct 2024 09:45:40 -0700
In-Reply-To: <Zv3hgOhjaQGAuIOG@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241001001709.1303668-4-oliver.upton@linux.dev>
 <ZvxH3el9SNuNWwi8@google.com> <ZvxeeVn8LphHxWeS@linux.dev>
 <ZvyFkqsRFBAYwqP7@google.com> <86cykj75a0.wl-maz@kernel.org>
 <ZvyOcnZqNzfD7MZx@linux.dev> <ZvySjfDWOhl2O1IA@google.com>
 <865xqa6q0a.wl-maz@kernel.org> <Zv3fcT9lCSujib7J@linux.dev> <Zv3hgOhjaQGAuIOG@linux.dev>
Message-ID: <Zv7KNFX4Mykff6I5@google.com>
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Punt stage-2 recycling to a vCPU request
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 03, 2024, Oliver Upton wrote:
> On Thu, Oct 03, 2024 at 12:04:06AM +0000, Oliver Upton wrote:
> > Hey,
> > 
> > On Thu, Oct 03, 2024 at 12:31:33AM +0100, Marc Zyngier wrote:
> > > On Wed, 02 Oct 2024 01:23:41 +0100, Sean Christopherson <seanjc@google.com> wrote:
> > > > IIUC, KVM round-robins across 2*nr_vcpus MMUs, and when L1 switches to a different
> > > > VTTBR, it will first drop its reference to the previous MMU.  So at any given time,
> > > > there are nr_vcpus worth of unused MMUs, i.e. a vCPU is guaranteed to be able to
> > > > find an unused slot, even if vCPUs that are scheduled out hold onto their S2 MMU
> > > > reference.
> > > 
> > > It's not about not finding a slot, but about making sure that vcpus
> > > that context switch rapidly between VTTBRs for their own guests can do
> > > so freely without sacrificing the TLBs they have just produced. Not
> > > reusing the TLBs hogged by a vcpu that cannot run is a waste of
> > > resource.

I don't think it's a complete waste.  There's value in not having to unmap and
rebuild an S2 MMU that is likely to be reused in the near future, especially for
a vCPU that was preempted.  E.g. the preempted L2 vCPU is already going to
experience some amount of jitter, forcing it to recycle a different S2 MMU and
then rebuild its S2 MMU is going to exacerbate the jitter.

Jitter aside, for a well-behaved system, it's unlikely a vCPU in the same VM will
be able to switch between L2s (VTTBRs) so fast that it would be a net positive to
recycle the TLB/MMU of a VTTBR that is "active", but scheduled out.  E.g. if the
L0 scheduler doesn't give the scheduled out vCPU a time slice "soon", then the L1
VM is going to be quite unhappy.

> > OTOH, our global TLBs don't model hardware exactly since a vCPU doing
> > rapid context switches trash the TLBs of *all* vCPUs in the system.
> > The cost of reusing an MMU is quite noticeable, since our unmap
> > implementation is slightly crap at the moment, the cost of which shows
> > up both on sides of the reclaim (victim and user).
> 
> Oh, and why unmap is crap:

Heh, isn't unmap by definition crap?  If KVM needs to unmap and rebuild an S2 MMU,
then KVM is already in a slow, sub-optimal situation.  I'm not saying unmap and
rebuild shouldn't be optimized as much as possible, just that weighting heavily
twoards avoiding unmap+rebuild will likely yield better overall performance and
experience, even if it means holding references across certain boundaries.

> > > > At that point, choosing an MMU that no vCPU is using seems more likely to recycle
> > > > a cold/dead MMU than a soon-to-be-reused MMU.
> > > > 
> > > > And the round-robin approach makes it all heavily luck-based anyways.  E.g. if
> > > > a vCPU puts VTTBR A and then loads VTTBR B, B could recycle A's S2 MMU if that
> > > > MMU slot is next up for recycling.
> > > 
> > > Well, we'll have to agree to disagree. It's a terrible hack to add
> > > artificial ties between a vcpu and TLBs.

But those ties already exist, in that nested_mmus_size scales with the number of
L1 vCPUs.
 
> > Still should drop the reference in most other cases, as I do *not* want
> > to entertain vCPUs holding a reference when they've gone out to
> > userspace.

Why not?  The vCPU is still running, keeping its S2 MMU resident is desirable, no?
It's extremely unlikely userspace will terminate or refuse to run the vCPU unless
the entire L1 VM is doomed.

Similarly, if an L1 vCPU is running multiple L2s, i.e. multiple VTTBRs, then it's
desirable to keep references to multiple S2 MMUs as well, e.g. so that switching
between two VTTBRs is guaranteed to get a cache hit on both.

Essentially all I'm suggesting is that instead of having a common pool of 2*vCPUs
TLBs per L1 VMM, have 2 (or however many) TLBs per L1 vCPU, plus maybe N extra
TLBs per L1 VMM.  I.e. mimic the hierarchical design of hardware caches and TLBs
to some extent.

vCPUs can still spill past their dedicated 2 TLBs, e.g. if L1 is only running L2s
in a subset of vCPUs.  Yeah, there will be wasted memory if a vCPU stops running
L2s, as KVM won't know when to drop references to its VTTBRs.  But that's a very
manageable problem (though definitely something for the future), e.g. by detecting
effective TLB pressure and requesting vCPUs to drop references to VTTBRs that
aren't actively being used, or by dropping references if the VM clobbers the
associated stage-2 PTEs that are being shadowed (i.e. if L1 is no longer using
that memory for page tables).

I'm not suggesting an overhaul to fix the preemption bug, but I do think that
effectively acquiring references on-demand is an unnecessarily complex solution.
