Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA876519D
	for <kvmarm@lists.linux.dev>; Tue, 19 Mar 2024 15:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710860687; cv=none; b=Xqf/c3Fu3KIK3/EFzMG29gwl4g6CBRy+gqUE14ZIrqc02FiDSt/2Gj8anpXkYbYwX12Ggu1Z0pvv0uQad3XMp1VY0J9PlK2W/rXLMtOjhoVR0OL10qIXuHclOCVzqMeo8++UDoNj0qJGcKx2EjY0+eE+bfwxg20Qxcpsp8oNJyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710860687; c=relaxed/simple;
	bh=HnRw/jl52GGtBjrtL3Z9yzXEz7FNnPbeqRZKY4D8bK4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=beLtnJtkRwJwPXKrXNkcggC8Pasm5Xw6E9FGljMbod2OoxhBJH3eQZWnGItO7lMsHzV9DI6QNR0HzZ7ubYANVQGIF242mskUp5WCoG1QIR7s1a9KbKgr61jv+SLvPHBSy8xXcASjH3Xkrx5W6eUpbQiowxzh9cRwQcbddr41fRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B/ORSSNJ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B/ORSSNJ"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dce775fa8adso9516266276.1
        for <kvmarm@lists.linux.dev>; Tue, 19 Mar 2024 08:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710860684; x=1711465484; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NplQauo3T05ITJQVb58CyaY10AXYgYxjqrk7R2EQZPo=;
        b=B/ORSSNJYikx5OlXiQRnPXBGZsotqIuA+b3ZK/aX3dXdmUgAK3v/9LakP1BSmp/AB8
         W1USBZl+qYIRfN9v4ZQVo21f+LPrpz2ivmZs9pkpOfcL0tXF4OT+MNQZCLUbTBoxHZ2h
         A40YjcCUE1sBahvx5TslBjDoKn0eCxESd0QuN49q9TXgZvPV+FopRIWJGU6XRT5Rdfsj
         ExK/mx0FOvtqWrqGbZMYX7h8POEwIkhe4MQfFSM+dST0+A4SUgD6oHL62+Ji5t7BDe0V
         uwz9NAGnxBBIdKWCx6/WR501dPoKfH5f0BIWCELD3vrfiJo7rv7Te6AGCJvwbwePwm1h
         Va2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710860684; x=1711465484;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NplQauo3T05ITJQVb58CyaY10AXYgYxjqrk7R2EQZPo=;
        b=OLXH3cYtIUiwlKwCRuR8pByUKiGx7oRBCa9QNbQmK9Z8suOyO0H54t/aa+XcyFKpBo
         SowCJEA1PsPsBprr5/v0Pag8I17qydVOfgyENmZoKeQIUXSR+p2RkDYF8nhPrr2PRk1p
         XFFSprnsnCgdgVc8np830rzIwbfQm7z3rQUpbNBi8Jts8kmkMZbu98yry0VYI3HJqpTE
         OuTjrRsGS2j5gky4n9tz1wHkddJS4E6zapfg17KLcmapT2sb7Ab2I4SKQNHp9fVtMukV
         8L9RSS/XpvI3VvkzB9EQFdvAB2lHqzFS3RaQqStmvgHVXkHw1rviuQxcPZL7JLmOcwih
         zEDg==
X-Forwarded-Encrypted: i=1; AJvYcCUMbj76tLSN2ioPDGPbmOkZR2cf2DNwq3Gy5/6yMA5qsUaYDt398nF5pOzs0QLXZvmTEF4d5CbfQ5qPx71yFPgLYKiq2lI9
X-Gm-Message-State: AOJu0YyGbON9799L1kIl/+H/XSbkEx6gm59xAA/KU2sBCLPrbwG4nmJb
	s740/jkMkFdOiLlvq9rG1cKwqrwtcTE1M0Rx/g1x0t4FQxHAry3AXs/TrRfmPx9PeloV7SVkNFl
	wtg==
X-Google-Smtp-Source: AGHT+IFzQ4ti420RAZwrAPIehk+RvMSqfW7livgvdq7TKEUIDyocbziT3vORaOcgDir/FqOa9fXPF8w4MQc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2484:b0:dbd:b165:441 with SMTP id
 ds4-20020a056902248400b00dbdb1650441mr3823227ybb.0.1710860684341; Tue, 19 Mar
 2024 08:04:44 -0700 (PDT)
Date: Tue, 19 Mar 2024 08:04:43 -0700
In-Reply-To: <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <Zd82V1aY-ZDyaG8U@google.com> <fc486cb4-0fe3-403f-b5e6-26d2140fcef9@redhat.com>
 <ZeXAOit6O0stdxw3@google.com> <ZeYbUjiIkPevjrRR@google.com>
 <ae187fa6-0bc9-46c8-b81d-6ef9dbd149f7@redhat.com> <CAGtprH-17s7ipmr=+cC6YuH-R0Bvr7kJS7Zo9a+Dc9VEt2BAcQ@mail.gmail.com>
 <7470390a-5a97-475d-aaad-0f6dfb3d26ea@redhat.com> <CAGtprH8B8y0Khrid5X_1twMce7r-Z7wnBiaNOi-QwxVj4D+L3w@mail.gmail.com>
 <ZfjYBxXeh9lcudxp@google.com> <40f82a61-39b0-4dda-ac32-a7b5da2a31e8@redhat.com>
Message-ID: <Zfmpby6i3PfBEcCV@google.com>
Subject: Re: folio_mmapped
From: Sean Christopherson <seanjc@google.com>
To: David Hildenbrand <david@redhat.com>
Cc: Vishal Annapurve <vannapurve@google.com>, Quentin Perret <qperret@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, keirf@google.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 19, 2024, David Hildenbrand wrote:
> On 19.03.24 01:10, Sean Christopherson wrote:
> > Performance is a secondary concern.  If this were _just_ about guest performance,
> > I would unequivocally side with David: the guest gets to keep the pieces if it
> > fragments a 1GiB page.
> > 
> > The main problem we're trying to solve is that we want to provision a host such
> > that the host can serve 1GiB pages for non-CoCo VMs, and can also simultaneously
> > run CoCo VMs, with 100% fungibility.  I.e. a host could run 100% non-CoCo VMs,
> > 100% CoCo VMs, or more likely, some sliding mix of the two.  Ideally, CoCo VMs
> > would also get the benefits of 1GiB mappings, that's not the driving motiviation
> > for this discussion.
> 
> Supporting 1 GiB mappings there sounds like unnecessary complexity and
> opening a big can of worms, especially if "it's not the driving motivation".
> 
> If I understand you correctly, the scenario is
> 
> (1) We have free 1 GiB hugetlb pages lying around
> (2) We want to start a CoCo VM
> (3) We don't care about 1 GiB mappings for that CoCo VM,

We care about 1GiB mappings for CoCo VMs.  My comment about performance being a
secondary concern was specifically saying that it's the guest's responsilibity
to play nice with huge mappings if the guest cares about its performance.  For
guests that are well behaved, we most definitely want to provide a configuration
that performs as close to non-CoCo VMs as we can reasonably make it.

And we can do that today, but it requires some amount of host memory to NOT be
in the HugeTLB pool, and instead be kept in reserved so that it can be used for
shared memory for CoCo VMs.  That approach has many downsides, as the extra memory
overhead affects CoCo VM shapes, our ability to use a common pool for non-CoCo
and CoCo VMs, and so on and so forth.

>     but hguetlb pages is all we have.
> (4) We want to be able to use the 1 GiB hugetlb page in the future.

...

> > The other big advantage that we should lean into is that we can make assumptions
> > about guest_memfd usage that would never fly for a general purpose backing stores,
> > e.g. creating a dedicated memory pool for guest_memfd is acceptable, if not
> > desirable, for (almost?) all of the CoCo use cases.
> >
> > I don't have any concrete ideas at this time, but my gut feeling is that this
> > won't be _that_ crazy hard to solve if commit hard to guest_memfd _not_ being
> > general purposes, and if we we account for conversion scenarios when designing
> > hugepage support for guest_memfd.
>
> I'm hoping guest_memfd won't end up being the wild west of hacky MM ideas ;)

Quite the opposite, I'm saying we should be very deliberate in how we add hugepage
support and others features to guest_memfd, so that guest_memfd doesn't become a
hacky mess.

And I'm saying say we should stand firm in what guest_memfd _won't_ support, e.g.
swap/reclaim and probably page migration should get a hard "no".

In other words, ditch the complexity for features that are well served by existing
general purpose solutions, so that guest_memfd can take on a bit of complexity to
serve use cases that are unique to KVM guests, without becoming an unmaintainble
mess due to cross-products.
