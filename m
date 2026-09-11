Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6944A49B7
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 16:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789145907; cv=none; b=SfOGNmxe3aWod2fKpBzn0rx9XEM5yq3lYj5ANdEpCjtMGmo0wAlW/mfFAqYbHQwPQolzq4jPCcR9lVohddUiZmJ/jo3tJniMMy9Rftcr9s7A46kBFiUqFoy3Uyc1ho0jhCMARkSS+wQDxMmzr9Dfjo4kyfVA1Q7N2te3lU021p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789145907; c=relaxed/simple;
	bh=/diikzD/GEQxLuFgcC8e5HNvPResrrNlv4d1lxHc2Y0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mBhD+xW2ZYAvW4gw5Gp/gxNaidX83BJpaT194jhv2DdnAhY+D75slvP2O6DbWOz0nx7gaQFhffSAfNZpDX0cYmxsFlNvDtdifDvyryBYyAiPMjm0uzq3TpgT/Ow6b5vJsqItUPSm87vARPIvo6xvcazGtzZ42+RL3epwifE11mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CF2eL52i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CF2eL52i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789145892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hxKk78RkbRW1DG36XDgMwpHJuUlT+rNxqDSm0SlrpEQ=;
	b=CF2eL52i40DyS/tP4R4Gr6ZMyKx1cB5TqyV3BhkGLOQJ9gXfWzwKrUfrPPT4vK8NilhdZy
	Yh35dnS4V4PqQbD3c9iRUZhxL3oRd/04yhzPR/j3rverwwvYgL0m9owVVVw7fDDHJuMTPo
	R8KewjSMujMplvYJToEMFjnBkxaHrv8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-MVV-OgC7OGWKNCrtZ4sAkA-1; Fri,
 11 Sep 2026 12:58:05 -0400
X-MC-Unique: MVV-OgC7OGWKNCrtZ4sAkA-1
X-Mimecast-MFC-AGG-ID: MVV-OgC7OGWKNCrtZ4sAkA_1789145881
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 11FFE195396B;
	Fri, 11 Sep 2026 16:58:00 +0000 (UTC)
Received: from [100.90.56.12] (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE9281800361;
	Fri, 11 Sep 2026 16:57:48 +0000 (UTC)
Message-ID: <705b3886-80ef-4b15-8aee-0521fa97cfe3@redhat.com>
Date: Fri, 11 Sep 2026 18:57:45 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] liveupdate: Move to feature flags for LUO and
 memfd ABI compatibility
To: Sean Christopherson <seanjc@google.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: David Matlack <dmatlack@google.com>, Logan Odell <loganodell@google.com>,
 arnd@arndb.de, pasha.tatashin@soleen.com, rppt@kernel.org,
 pratyush@kernel.org, graf@amazon.com, akpm@linux-foundation.org,
 maz@kernel.org, oupton@kernel.org, bhelgaas@google.com, alex@shazbot.org,
 kevin.tian@intel.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
 joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-pci@vger.kernel.org, iommu@lists.linux.dev
References: <20260903023452.721732-1-loganodell@google.com>
 <20260904160009.GV4157646@nvidia.com> <aptFFYqcSiBdMLE8@google.com>
 <20260905012403.GX4157646@nvidia.com> <aqIAtOoew-_6jw29@google.com>
 <20260910143448.GD3968357@nvidia.com> <aqLOWkuVKccR-I7W@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <aqLOWkuVKccR-I7W@google.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: ft_8-3K7gqVFpvoGoVN1vHuExUk0Vt8BV_N_s04TQvA_1789145881
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/26 17:35, Sean Christopherson wrote:
> On Thu, Sep 10, 2026, Jason Gunthorpe wrote:
>> Sometimes you can do more and more work to try and be more and more
>> general but this is *alot* of work and even then eventually hits
>> problematic limits. Like what do you do with the sealing flags? That's
>> ABI breaking if the successor does not support them, and downgrades
>> make exactly that possible.
>>
>> A CSPish user can do things like patch the new sealing flag into their
>> current kernel (while preventing userspace from using it), ensure
>> everything is updated to that, then jump ahead to a newer kernel and
>> enjoy the new flag with full downgrade support. There is so much more
>> control on their part that makes the problem far more managably simple
>> that upstream does not get to have.
>
> I guess maybe we have a different definition of ABI? I'm not saying
> that upstream has to be 100% forwards and backwards compatible. I'm
> saying the serialization payload itself should communicate what
> features are effectively required.
I strongly agree with Sean on this, like really really agree.

All you need is serializing *actions*.  Make the destination a small 
interpreter not something that read structs.  memfd/guest_memfd is 
already created by a bunch of actions, which are syscalls, so it 
shouldn't be hard to either come up with the actions or parse them in 
the destination.

An example matching (going by memory) what is now in place for memfd:

- memfd_create(name[], flags)
- memfd_map(folios[], index)
- memfd_finish(seals, pos, size, mode)

So:

#define MEMFD_LUO_CREATE 0
#define MEMFD_LUO_MAP 1
#define MEMFD_LUO_FINISH 2
struct memfd_luo_op {
	/* 0 = end */
	u32 size;
	u32 op;
	union {
		struct {
			u32 flags;
			char name[];
		} memfd_luo_create;
		struct {
			u32 flags;
		} memfd_luo_secret;
		struct {
			u64 i_size;
			u64 f_pos;
			u32 f_seals;
			u32 i_mode;
		} memfd_luo_finish;
		struct {
			u64 index;
			struct memfd_luo_folio src_folios[]; // whatever
		} memfd_luo_map;
	};
} __aligned(8);

You write almost everything at prepare, just ensure there is room for 
finish and write that on freeze.

Want to move secret memfds?  Sure they're different in underlying 
implementation but they can share LUO serialization format almost 
entirely.  Make it a new op instead of create.. you have 4 billion 
possible ops, adding them isn't quite free but not too expensive either.

In fact memfd is the easy case, almost always you'll have a more 
complicated initialization sequence and a huge explosion of 
possibilities, but the good thing is that the kernel *already* has to 
initialize its data structures from actions.  We're not quite 
serializing syscalls but pretty close, in fact for KVM a lot of code 
could be shared between ioctls and LUO receiving side.

It doesn't have to match exactly userspace, for example you wouldn't 
really need to transmit MFD_ALLOW_SEALING because it's implicit in the 
seals you transmit.  That said, taking inspiration doesn't hurt; just 
remember to *always* validate unknown flags.

>> If it really succeeds at that and it becomes very popular, then let's
>> discuss upstreaming doing additional version combinations.
> 
> Why on earth would we have version numbers in the first place?  IMO, monotically
> increasing version numbers are flat out the worst way to communicate features.

This, too.  KVM has been at API version 12 since 2007.  It is not 
userspace compatible with 2007 vintage QEMU, because a couple 
misfeatures were removed after 10 years or so of waiting, so I guess 
technically it would be 15 or 16, but it doesn't matter because no one 
checks KVM_API_VERSION.  If a ioctl works it works, if it doesn't you 
get a much better message than "KVM API version mismatch".

>> Okay, how about worse, todays kernel has hugetlbfs and there are
>> patches around to luo serialize that. Lots and lots of talks about a
>> post-hugetlbfs world out there.
> 
> And?  Adding a compatibility layer to a future kernel so that it understands an
> incoming HugeTLBFS payload should be trivial.  I can totally see not wanting to
> support serializing a post-HugeTBLFS kernel's memory representation into the "old"
> format, though even that probably wouldn't be all that difficult.

Yeah, hugetlbfs is an implementation detail *of the destination* not the 
source.  The destination somehow needs to take the 1GB area and donate 
it to hugetlbfs.  That's not the source's problem.  All the 
source->destination ABI contains is MFD_HUGETLB and MFD_HUGE_*, which 
promise to the destination a certain alignment of all map requests.
>> Do we want to reject the hugetlbfs serialization until we have a year
>> of debate outlining every possible ABI scenario? I also vote no.
> 
> That's a bit of a strawman argument.  Is designing a forward-looking ABI easy?

No, but it's also not *that* hard if you have a half-decent userspace ABI.

> Hard NAK.  There will inevitably be boundaries that cannot be crossed, but I am
> not at all ok punting on downgrades.  To me, that's basically saying "we want to
> add just enough support upstream so that it's not too painful to carry full support
> out-of-tree".  That completely goes against the spirit of open source and upstream
> Linux, and I want no part of it.
100%.  And I'll add, what happened to "we don't break userspace"?  This 
does the intentional opposite in the hope that no one cares about using 
this feature upstream.  Which in the long term hurts downstream forks as 
much as upstream.

Paolo

