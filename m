Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4039538D3E4
	for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 21:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789075694; cv=none; b=sXuz7a4/XsgyUt9w2iUNpVz7hqXNsYWsBr/m4ZQMEFfZUXarB/dkBcTtCiDxC0Yn7IbNmW6GWW+N2UYdSRVDFwXa1VShJJ75te0I5C4oNO0f3ZFqP5qPMYiiBes+wKUAam5CplOCk1usa0tRAXaAuyBjTXbBX90PmwFTEwWKQjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789075694; c=relaxed/simple;
	bh=sLd8srObylfsk8GLiRg89uhj6dHxicu1FuoHk+f9Cg4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AMys1gXvfIfQSTAgx7h7nVhMTbZH1FFNS6xP3MoAqTDcldnkBHPk2ChZgBeJQifRkk6RM2kSAiNGTq5UkVNe2K8TNjpSY6tni8dd/t2oTuxlOOHKjQCMlqa6tPjq1g1r93bKoPmvfNxHsFZAoWbthKcCSVp8dtfDcYj614/PZhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NMEWYn1G; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NMEWYn1G"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d8fb334ddcso1424185ad.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Sep 2026 14:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789075692; x=1789680492; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hOLKQV5MP6URX3X9jqnRFyBsWQauQYYSupdkNVN7Yn8=;
        b=NMEWYn1GaxlEbuYFiu0YGPEj/WCwpRFlyCDvnkERGrk6bMjYcJtTG4mf6OPC/aFQFC
         EAgSInWXh9rFv7MPR+qRDKI4WMIySPzdW/D1iFZJvD3RF3TtevytfXyp7raVBQthm0OP
         9hH/4MhEqI9969ScWIB71QTIaBsSzka8WaBUuWih7cim/kO1VLgvNIz3zecyae7khIqk
         Cv/xekY6rcmr0jHWjJMIAwJTr/YWXXWTE+dR4+GIbAaDjAGeQav7a4m0n7/0ckVpcbjl
         /RKxkxHcTy0Eoq8+3wL1+qWFLK1fd0uts4f8ySTcvs/I6hh4NdrbMdXhPMXlLqLRbrx9
         GENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789075692; x=1789680492;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hOLKQV5MP6URX3X9jqnRFyBsWQauQYYSupdkNVN7Yn8=;
        b=ooyMISSn9Qqlb3EuoJchSrHMCuyPjqRfkA8yfT2j5+X8FmCuFsm03c7SlPPXZ6att8
         2SSHHoaqJQIYni7nrxsKNL2KC3jQ1u4Gu46nWMxyyaudMd96Z6UIFIzX5g14kGUSA4Kc
         cW+jwZeObH8LHqIMq4EEHv9XBu9lwCAIZ+/vcFDCJi8x7/mkH4zlpljurwbL/kfAL6KT
         U8l4muA6tCYYQjo7Q7kqoJhEbcdlZdWDAmzJmyE/8iYXz7eCcUevq2Hnx5KqC9OPxQ9v
         auRCY7hapxPbneFQG8DzlTO5lhlcybs3PEDwx635PS58tO4TGqlWALMkKIUVis6+ZgL8
         ZfLw==
X-Forwarded-Encrypted: i=1; AKwUvByocYFb8oK8G0WP2ZsYdf8EzEwPRJZ0NHSrOhQf3RrXp5TDEX3NkXL3hjJu3gQkn/62mWDLA7M=@lists.linux.dev
X-Gm-Message-State: AFuF++nQs6dXE0cMOJvnc2ywQ6VKeNwNc9YB69jgM7IMfcgRp4qTgN0s
	9AIu5jubbVawjHo/wpbFXwR34WZq5rWi42p9Gfc/NDAZs1ePe2c9kWFzTLdvuUsZNQ==
X-Gm-Gg: AYBFou0Q8kVS9z8te3B16e9Ek7eCtXjNWy/Jkve3c4fH8Vshqbw5zW9l23jdyjum0Qf
	Fgnxsg/shaGzpsISvukF7g30mOmUa+/qFm24Rp1iDwv3WSgJf47GVfdSHs3KkeWzdgLL1WOUSFJ
	RL4Rz9koJXQpnJqCHkM17xmXTs71o2hYGUUJk7u70Ee9fNlIT4/iXXCqeN1usYbppd3r8LOHwO7
	eewziO7YYB3dLWvtxM+EJZmgfZt4EFBzxpGg2g/bAtX553a50tkKyYId7BhYkuYe+bXH8tCn59f
	swAZCU60Of9PrTepjvFEU+lpz1vBDcQEpyVcQkQXySjpuvG8MFiF/8yaPyr5XzWYqGFiggmmKjF
	cq/9p5GzGAaVhmXfRJ8H6jkSuR4fGdq+5lRT2zG6IHOeM0MmV7YbcAh4xvq8v0jAcQ9fpDEbn1S
	4qUj0wi5IbeamXTKNxyovTVQ50OkqAcCpf4FkM2Cs1Pbtp3qAOrC6hOvkiCzSa/u4Rgf1WVRV0o
	kkyCiB9ozdLi8KeCVQe0Gg9NmbQQ8GZzxoz4Ggp
X-Received: by 2002:a17:902:d984:b0:2d7:f0:896b with SMTP id d9443c01a7336-2dd2a33648emr23827755ad.13.1789075690962;
        Thu, 10 Sep 2026 14:28:10 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2ceb715bsm1812275ad.39.2026.09.10.14.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 14:28:10 -0700 (PDT)
Date: Thu, 10 Sep 2026 21:27:58 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Logan Odell <loganodell@google.com>, arnd@arndb.de,
	pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org,
	graf@amazon.com, akpm@linux-foundation.org, pbonzini@redhat.com,
	maz@kernel.org, oupton@kernel.org, bhelgaas@google.com,
	alex@shazbot.org, kevin.tian@intel.com, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
Message-ID: <aqMgjXfTJ8u3n7Kj@google.com>
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com>
 <aptFFYqcSiBdMLE8@google.com>
 <20260905012403.GX4157646@nvidia.com>
 <aqIAtOoew-_6jw29@google.com>
 <20260910143448.GD3968357@nvidia.com>
 <aqLOWkuVKccR-I7W@google.com>
 <20260910171210.GF3968357@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910171210.GF3968357@nvidia.com>

On 2026-09-10 02:12 PM, Jason Gunthorpe wrote:
> On Thu, Sep 10, 2026 at 08:35:54AM -0700, Sean Christopherson wrote:
> 
> > I guess maybe we have a different definition of ABI? 
> > 
> > I'm not saying that upstream has to be 100% forwards and backwards compatible.
> > I'm saying the serialization payload itself should communicate what features are
> > effectively required.  I.e. *if* there are incompatibilities, they should be
> > naturally expressed in the serialization format, not communicated out-of-band
> > through magic numbers.
> 
> The ABI strings were introduced specifically because extension makes
> the actual compatibility indeterminate by userspace. 
> 
> Keep in mind the actual goal here. Someone has kernel A and they need
> to blind kexec into kernel B and NOT have the machine explode, or all
> the VMs sitting on it lost.
> 
> Meaning you must have a way to determine before the kexec if kernel A
> is producing something B will *accept*. Accept is not "parse and fail
> with EOPNOTSUPP" like most uapi schems. Aceept means bring in and
> actually fully support and use.
> 
> So how do you solve this problem? You MUST declare in some kind of
> manifest exactly what ABIs are supported, in some way.

I think this series solves this problem in a fairly clean way without
relying on version numbers.

Each ABI is now extensible with a set of structured featured flags that
are exposed to userspace. Userspace can inspect the flags that the
kernel supports and confirm the next kernel also supports them.

I think there is still room for improvement, like determining what
features are used at runtime rather than statically at compile time, or
allowing userspace to disable use of certain features to control
compatability, but I think these things can be built into this type of
model.

> > The scenario you describe fits exactly with what I am proposing.  
> 
> It does not. What is really wanted here is to tell kernel A to only
> support ABI 1 for memfd and so kernel A will fail to serialize if it
> cannot do it because a newer seal flag was used.
> 
> We do not want to succeed to serialize then fail to accept after
> kexec and have a dead machine.
> 
> This is not anything like a normal uapi compatability problem.
> 
> > actually starts using the new sealing flag, the CSP can downgrade to
> > older kernels at will.  And if the user cares about downgrading,
> > then they need to prevent the flag from being used until the new
> > kernel is rollback-safe and deployed to enough hosts to prevent
> > stockout.
> 
> Yeah, CSP broadly has to do exactly this across a wide range of
> topics. It is a further reason why this feature is not exactly usable
> by a "mainstream" user :\
> 
> > > This is why I think the very idea we can support any version pair is
> > > too much to ask for. We should focus on supporting a small set of
> > > version pairs and not making it too invasive or hard in the kernel or
> > > on the maintainers.
> > >
> > > Thus live update within a stable branch only is my proposal for
> > > upstream support.
> > > 
> > > If it really succeeds at that and it becomes very popular, then let's
> > > discuss upstreaming doing additional version combinations.
> >
> > Why on earth would we have version numbers in the first place?  IMO, monotically
> > increasing version numbers are flat out the worst way to communicate
> > features.
> 
> As above, discoverablility is a key requirement.
> 
> Each version number is a very specific upstream defined ABI, in the
> sense if kernel A emits version X and kernel B accepts version X then
> kexec *must* work.
> 
> You can make some manifest in other more complicated ways, but I'm
> deeply skeptical that is really going to bring any value. It feels
> like it is just increasing the testing matrix :\

The value I see of the flag-based approach over the version-based
approach is:

 - Each component can have one ABI struct that extends over time and one
   serialization/deserialization routines, rather than N for the N
   supported current versions. Supporting multiple versions within a
   single kernel would be required for upgrade/downgrade. Maybe there is
   a way to make the multi-versioning support maintainable but it seems
   like it will be messy to me.

 - Features can be managed individually. Let's say a downstream user
   wants to use a new upstream feature. If we had a versioning model
   they would have to backport the entire version delta from their
   current kernel to that feature upstream. With flags they can backport
   and use an individual feature.

I agree testing matrix becomes more complex but maybe that can be
mitigated with your suggestion that upstream only "officially" supports
(i.e. tests) some constrained version sets like within a stable branch?

>  
> > > > I could see things like HugeTLB not working if someone booted the kernel with
> > > > support for only 1GiB pages and then tried to feed it payload with sub-1GiB ranges.
> > > > But to me, those sorts of things fall into the "well yeah, don't do that" category.
> > > 
> > > Okay, how about worse, todays kernel has hugetlbfs and there are
> > > patches around to luo serialize that. Lots and lots of talks about a
> > > post-hugetlbfs world out there.
> > 
> > And?  Adding a compatibility layer to a future kernel so that it
> > understands an incoming HugeTLBFS payload should be trivial.
> 
> From my experience that's optimistic :(
> 
> > > Do we want to constrain what is possible to ensure we accomodate this
> > > hugetlbfs serialization? I vote no.
> > 
> > In what way is providing strong ABI guarantees for individual components
> > constraining HugeTBLFS serialization?
> 
> I bet it will. Other things we've looked at seemed to be like that.
> Even the above about "yall screwed up" with memfd has the problem
> already. I don't believe we can ever do this so right that it won't be
> constraining to the kernel internals.
> 
> > > Do we want to reject the hugetlbfs serialization until we have a year
> > > of debate outlining every possible ABI scenario? I also vote no.
> > 
> > That's a bit of a strawman argument.  Is designing a forward-looking ABI easy?
> > No, but IMO "a year" is a massive exaggeration of the effort required to come up
> > with a scheme that can survive a variety of plausible upgrade/downgrade scenarios.
> 
> Have you tried to get anything merged into the kernel lately? I've got
> lots of uncontroversial stuff pushed out past 4 months already. Some
> luo patches are close to a year already and don't even have any
> controversy.
> 
> > And again, I'm not saying we have to support infinite compatibility.  
> 
> Okay, I said same stable branch only, do you have some wider
> limitation in mind?
> 
> > > Should we make a downgrade round trip a downstream problem? I think
> > > so!
> > 
> > Hard NAK.  There will inevitably be boundaries that cannot be crossed, but I am
> > not at all ok punting on downgrades.  To me, that's basically saying "we want to
> > add just enough support upstream so that it's not too painful to carry full support
> > out-of-tree".  That completely goes against the spirit of open source and upstream
> > Linux, and I want no part of it.
> 
> I generally agree with you sentiment, but I think this is a unique
> case. I've asked around a fair bit, this is sufficiently complicated,
> requires alot of userspace that the CSPs are not open sourcing so has
> a very minimal usage foot print out side their world. I found one
> other possible user that might be more open source oriented..
> 
> So, if I was feeling unreasonable I'd say stay out of the upstream
> kernel entirely.
> 
> Though, I think this could grow and maybe some open source ecosystem
> will develop around it. I don't know. I'm willing to give it a
> chance.
> 
> HOWEVER upstream is not some kind of free outsourcing for the CSP's
> proprietary forks! Do not ask maintainers to do significant and
> burdensome work that only a CSP is ever going to consume and can only
> really work in a closed proprietary environment. There is no "spirit
> of open source" in that kind of demand. I will be NAKing anything like
> that in my subsystems, I am not signing up to do live update stable
> ABI so the CSPs alone can have a better proprietary product.
> 
> This is how I come to my conclusion that upstream should support same
> stable branch only at this point. It minimizes the burden, it is a
> decent trail of the technology, and if things go well with a quality
> open ecosystem then sure, upstream can change its mind.
> 
> Jason
