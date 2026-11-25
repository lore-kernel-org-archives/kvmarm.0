Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617835;
	b=iUE9sZwZujJP/wLrAZuyHNMhTSoGBlIyKUD57GNOs5lU58N84WmT6GQFLt94rvjAvCrB
	 ou4h1d9IFrRhFXw3yOS1fuRaOqhfV2yY7ph9Pkxq3F/tNxdnlOfeLR4I3FtHHUR0iU1eB
	 D9LtCZ4o1f1Z79Yo4VtcPG/oFDH5tonzV7vSfIiCS/4ac5lbAdumNRFbO8XLIk2ceJdmP
	 yLwcj353Panulh3AVZUXciPV27EBj6TsialZ/DHVqU/wtSlL8xFe6eGVQ1bhYeqPiA4rx
	 zx0EM1kfEf/s9Kziegb/s/6SRE9KDWgByxpOiQbRNHd2b82ouoLiYtiaIBEDH1WnWkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:In-Reply-To:References:
	 Date:Message-ID:User-Agent:MIME-Version:Content-Type;
	bh=DSDBbrxDF7QE7mJ7cGh5psk8NDNsiMzdc0pE9t4TEt8=;
	b=OQhaYXsn9hxEJUWc0bWcvtHM9hvQLmvtT90tnVIVVKsIvOPqhy4c55HrIsUGndsucUau
	 hnjjA9/zGcfyqOrFJI/2cqglg1h4ETIoCqJHG8Vg42a3VopZ+WPiOjsdBvJKDKTKBUK7a
	 HLnRqxCbfz8WpkzRlh9NbylGQ4FuNjRihumGX5BPrJ/AthTaxxjK5zlrJZKsGXToJts7Y
	 I7QKxub1PUPwU3SfF58T/k4HEugKhKGs6oxLTexqsNc3W5qksRcY9T7RvTKbNOxliFqKw
	 8Zttpr4PEqWtAvLHVH05MC99TgW8hQEeAcqO1j+Rdi7jNmSo1eGR72E4eE/VdTWSugA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IaxxUP7L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C32B606A326;
	Wed, 25 Nov 2026 14:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IaxxUP7L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3521F000C6;
	Wed, 25 Nov 2026 14:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795617835;
	bh=DSDBbrxDF7QE7mJ7cGh5psk8NDNsiMzdc0pE9t4TEt8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=IaxxUP7LRnqywT22he7m+Fp7ezJgAfkpHSw5REph0tRYPRC/9tQDBnxNGaqFCUe0P
	 HC4OCPR1FvefXZR0jreOarx1/ItxF0Kd5XwRm18+njWXI6kfrP7K+QHWF1l9XvxXHk
	 Wb3T7KBp5sU8Uq3JjMSsDtDz2cQ1vDbxW6cRqzm0jkDQjr5S84bbH7Zbc/9r5XtFga
	 tXPaD+SS8GZvYPYpD187DBOSIhZ28zt4gF80M0lT+Uc0vOeuoEM5ntTj2myprO+Uo6
	 0KAYN/vccLRY3U4aBHQmotXHdObAadnDVOITnax/jMq8UASOsc7R09dQV9GiPujVaw
	 zu/OOYjuPVOYA==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Matlack" <dmatlack@google.com>
Cc: "Pratyush Yadav" <pratyush@kernel.org>,  "Tarun Sahu"
 <tarunsahu@google.com>,  "Pasha Tatashin" <pasha.tatashin@soleen.com>,
  "Mike Rapoport" <rppt@kernel.org>,  <robin.murphy@arm.com>,
  <maz@kernel.org>,  <will@kernel.org>,  "Alexander Graf"
 <graf@amazon.com>,  <seanjc@google.com>,  <jgg@nvidia.com>,
  <loganodell@google.com>,  <arnd@arndb.de>,  <dwmw2@infradead.org>,
  <baolu.lu@linux.intel.com>,  "Bjorn Helgaas" <bhelgaas@google.com>,
  <oupton@kernel.org>,  <alex@shazbot.org>,  <gle.com@google.com>,
  <pbonzini@redhat.com>,  "Andrew Morton" <akpm@linux-foundation.org>,
  <kevin.tian@intel.com>,  <joro@8bytes.org>,  <kvmarm@lists.linux.dev>,
  <linux-pci@vger.kernel.org>,  <kexec@lists.infradead.org>,
  <kvm@vger.kernel.org>,  <iommu@lists.linux.dev>,
  <linux-arm-kernel@lists.infradead.org>,  <skhawaja@google.com>,
  <sagis@google.com>,  <linux-arch@vger.kernel.org>,  <linux-mm@kvack.org>,
  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 03/19] kho, memfd_luo: Reference struct kho_vmalloc
 via serialized pointer
In-Reply-To: <DN3VG4JCILOO.YN40XHHSWRPH@google.com> (David Matlack's message
	of "Tue, 24 Nov 2026 16:39:52 -0800")
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-4-tarunsahu@google.com>
	<2vxz4idb1i2w.fsf@kernel.org> <DN3VG4JCILOO.YN40XHHSWRPH@google.com>
Date: Wed, 25 Nov 2026 14:43:47 +0000
Message-ID: <2vxzld6hx97g.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

On Tue, Nov 24 2026, David Matlack wrote:

> On Fri Nov 20, 2026 at 10:19 AM PST, Pratyush Yadav wrote:
> [...]
>
>>> +static size_t memfd_luo_ser_size(void)
>>> +{
>>> +	return sizeof(struct memfd_luo_ser) + sizeof(struct kho_vmalloc);
>>> +}
>>> +
>>> +static struct memfd_luo_ser *memfd_luo_ser_init(void *mem)
>>> +{
>>> +	struct kho_vmalloc *kho_vmalloc = mem + sizeof(struct memfd_luo_ser);
>>> +	struct memfd_luo_ser *ser = mem;
>>> +
>>> +	KHOSER_STORE_PTR(ser->folios, kho_vmalloc);
>>> +	return ser;
>>> +}
>>> +
>>
>> Hmm, I am not a huge fan of this. This makes doing such allocations
>> quite annoying, and I reckon we will be seeing a fair bit of them in
>> many places.
>>
>> The key observation here is that most file handlers need to allocate a
>> bunch of preserved memory, but they usually can free it all at once. So
>> we can get away with a very simple allocator that hands out memory
>> linearly.
>>
>> I have sketched out some code for this, take a look at the patch below.
>> Note that it is only compile tested.
>>
>> Perhaps give it a try and see if it does the job better.
>
> I agree the manual packing in memfd_luo_ser_init() isn't great, but I'm
> not sure we need an arena. This seems like something KHO slab support
> will solve properly, and since kho_alloc_preserve() already takes a
> size, KHO slab can be dropped in underneath it later without changing
> any callers.

While it would be nice to have, I peeked at what we need for slab
support and it sounds overkill. For one, a slab cache is for fixed size
objects. So you'd need a bucket of slabs for different sizes, similar to
what kmalloc() does. You probably don't want to preserve objects spread
around in kmalloc's buckets, so you would need a set of buckets
dedicated for LUO/KHO.

For another, slab cache is great when you are allocating and freeing a
bunch of objects of varying sizes. But that isn't really the workload
preservation has. Each preservation hook needs to allocate a handful of
objects, and then hold them until unpreserve. This arena style allocator
does the job pretty well.

And finally, the object layout within a page/slab of the cache can
change based on configs or kernel versions. See SLAB_RED_ZONE or KASAN
for example. We would need to standardize the layout without
compromising the non-KHO slab users. We can probably solve these
problems, but I don't expect it to be easy.

So I wouldn't want to support slab until we have file handlers that
churn through a lot of preserved objects.

>
> Until then, maybe we should just allocate struct kho_vmalloc separately
> with kho_alloc_preserve() and accept wasting a folio per object. For
> memfd that's one extra page per preserved file.

Yeah, that is fine too I suppose, at least until we start to run into
problems with the memory overhead. I think the arena style allocator is
fairly straightforward and makes the memory savings easy so to me it
sounds promising.

-- 
Regards,
Pratyush Yadav
