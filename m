Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795790705;
	b=5Vh+31Qzgp6uXvCn/9xaJkhM46pDAKOWPUV7tF1HOFZRFuYu41dVbh14ZvDVnm8uNBQ9
	 m8GEWQmtL+IKIdAwW3CHskNj1vLe2k/zLZVi5wfiPnfo7zqluHojoFJAg8DVG5CDqbaps
	 B/++TeJJTUX8Ecc/DZsicOV+ZgsGnqY9Sc9pn60qywxebX2QtHenZUINuS+K3YB5uYlu0
	 P2vdPpg1bgGYcsSzCpwvE9/IxhAm6pRY0blBT0KrWvJBttqj54dDo/9G6pZL1Gd9tm52/
	 2bFD/UdvrUqjXSP+iix9F0OtXOS2rtLcWdT9mziXu3j/bT5/cZDswLgc2NkkKkXvb/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795790705;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=npagTujFGkU/X56guZt5WCSBTfPqSYqFOMbgDbX+VY4=;
	b=A3reoDwJWErJ8tIEaOHAjsqRNCWyZJdo+YDMMYsvS0niTSJAmIAFYnA9BZnwVyihiscr
	 Cr6cFUS7Q7/tVMyp31YlubSEjO+NWxNWewA7lBeXn3Xg76/uEtbLREUdtxXegYiTwy4Sr
	 cg1f/OwToJdlbxryif0h6+G3+Wr8qZ6a5enQfopODEZDVDvJbC32wrk13gym8bmcdooj2
	 e1fkcNeWQ+L8fwS5m7lHEpEAPlIJZyMN1FeVZOx7rH6dsDs9F/Kc27ThegSgpbNrpV8at
	 tACVh32xR8FdlP8Z4JgnQHBluQMR57Dh8GG3ET552QtlJUKkNbe/mGkk+Zn4xAz0qwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sxc3Is+v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A804F606A31F
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 14:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sxc3Is+v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492AC1F00897;
	Fri, 27 Nov 2026 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795790704;
	bh=npagTujFGkU/X56guZt5WCSBTfPqSYqFOMbgDbX+VY4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sxc3Is+vLW8xvZS2pDCsB8QxXc+pGvsH/cfHpz4jMRiQUUf0LMGRiNDTVB1PEYGrr
	 yizvq2vJA/yKc8VsyQvu6mvTsw6lAPxyJ/f3bbBDzCCpzUQhD50diiZDYBdRCI0Q1q
	 k+DPMUOxa9EjK2o8f1N5ag+f6YlN4js0OhT1ICxP799bN9YHHHPJCgomZaoxLPiFhM
	 Yfx51CyiwOGpjFJRvHJZZbzJNcjte4m8mczPyEyr96W4glZxIhxTwOLXFUR2XXPTbE
	 2yUH21WYijcg13/qcfPBro2wUTLV5MEQL3d5cOielbH7ZcHQ46DLjE9TBPMCcwsiYm
	 zs08DQhuYxMEQ==
Message-ID: <sashiko-outbox-237597@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB
 hosts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Usama Arif" <usama.arif@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <d2b6e735-a685-4e79-bb39-2fb75ebecd09@linux.dev>
References: <20261124152842.2634495-1-usama.arif@linux.dev>
 <86wlpzycnn.wl-maz@kernel.org>
 <563d2406-dcfe-43b6-8f21-2a7694f1f266@linux.dev>
 <86v75jy48c.wl-maz@kernel.org>
 <d2b6e735-a685-4e79-bb39-2fb75ebecd09@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 14:45:03 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] KVM: arm64: unstripped reply thread and obsolete v1 title in
  commit message
--

commit 77fb1ee741e0e031f8b2fbef9f4459a6c491e152
Author: Usama Arif <usama.arif@linux.dev>

> KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
>=20
> On 26/11/2026 07:58, Marc Zyngier wrote:
> > On Thu, 26 Nov 2026 14:32:04 +0000,
> > Usama Arif <usama.arif@linux.dev> wrote:
> >
> > [nonsense deleted]
> >
> >>> Now, to the patch itself: I see no reason to special-case this. If
> >>> kvm_mmu_cache_min_pages() is an indication of what is needed, then
> >>> this macro should be driven by it, or the whole allocator take it into
> >>> account. And then you adjust it by whatever fudge factor seems
> >>> appropriate.
> >>>
> >>
> >> Completely agree! [1] does that: no page-size special case, and
> >> a capacity of KVM_PGTABLE_LAST_LEVEL - KVM_PGTABLE_FIRST_LEVEL for eve=
ry
> >> page size.  It can't track kvm_mmu_cache_min_pages()
> >> at runtime: the vCPU's cache is shared by the canonical and NV shadow
> >> MMUs, and its capacity must stay fixed. So it has to cover the largest
> >> minimum, which stage-2 caps at 3, and 4 is that plus one page of fudge.
> >
> > Of course it can. That's not exactly rock science to add, rather than
> > relying on another set of bad heuristics.
>=20
> You're right, it can. __kvm_mmu_topup_memory_cache() fixes a cache's
> capacity at its first refill, but nothing requires that to be a
> compile-time constant. Does something like the patch below work for
> you? Each VM records twice the largest kvm_mmu_cache_min_pages() of its
> stage-2s as they are initialised, and every top-up passes that to
> __kvm_mmu_topup_memory_cache(), as the eager-split cache already does.
>=20
> > And this must cover more
> > than a single mapping per top-up, because that has a ripple effect on
> > the speed at which we can split large blocks (funnily enough, people
> > care about that stuff).
> >
> >       M.
> >
>=20
> With twice the minimum, each refill covers at least two worst-case
> maps. I asked a LLM to comeup with a way to time for block splitting and =
pagefaults
> and I found it reasonable, I have attached the results in the commit mess=
age.
>=20
> Does a factor of 2 sound reasonable to everyone?
>=20
> If this looks ok, happy to send as v2.
>=20
> From dad1d43f1c2dcb8ffbc8084ec19467731e8548f4 Mon Sep 17 00:00:00 2001
> From: Usama Arif <usama.arif@linux.dev>
> Date: Fri, 27 Nov 2026 06:07:35 -0800
> Subject: [PATCH] KVM: arm64: Size the stage-2 memcache from
>  kvm_mmu_cache_min_pages()
>=20
> When fewer than kvm_mmu_cache_min_pages() pages are left, a stage-2
> fault that may need new tables refills the vCPU's memcache to
> KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, 40 on arm64. A map allocates at most
> one table per level below the preallocated root, which is
> kvm_mmu_cache_min_pages() and at most 3 pages. Only vCPU destruction
> frees the memcache, so whatever a refill leaves unused stays allocated:
> up to 2.5 MiB per vCPU with 64 KiB pages. On a 64 KiB host running 101
> VMs with 4 vCPUs and 1 GiB each, the memcaches held 986 MiB, against
> 25 MiB of stage-2 tables in use.
>=20
> Size the memcache at twice the largest kvm_mmu_cache_min_pages() of the
> VM's stage-2s instead, so that each refill covers at least two
> worst-case maps. With NV, the vCPU's memcache also feeds the shadow
> stage-2s, and a memcache's capacity can't change once used, so record
> the largest value as each stage-2 is initialised. The VM's stage-2 is
> set up at VM creation and the first shadow stage-2s by the first
> KVM_ARM_VCPU_INIT, before any vCPU can fault, and later shadow stage-2s
> have the same size. kvm_phys_addr_ioremap()'s temporary memcache uses
> the same capacity, so arm64 no longer uses the value of
> KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE.
>=20
> With a 48-bit IPA, the capacity is 4 pages with 16 KiB and 64 KiB pages
> and 6 with 4 KiB pages; with the default 40-bit IPA, 2 and 4. On the
> host above and on a production host also running 101 VMs with 4 vCPUs
> each, both with 64 KiB pages and 48-bit IPA VMs:
>=20
>                      memcaches                saved
>                      before      after
>   host above         986 MiB     81 MiB       905 MiB
>   production host    869 MiB     <=3D 101 MiB   >=3D 768 MiB
>=20
> A memcache now refills at most once every two tables, as a capacity of
> 4 does with 4 KiB pages and a 48-bit IPA. Measured that way, per fault
> for the median vCPU, one VM at a time:
>=20
>                                         40           4
>   2M blocks split under dirty logging   4.9-5.1 us   4.9-5.0 us
>   1G block split, then refaulted        2.7-2.8 us   2.8 us
>   every fault allocating a table        4.0-4.1 us   3.7-4.1 us
>=20
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

[Severity: Low]
This isn't a bug, but the commit retains the v1 subject ("KVM: arm64:
Reduce the stage-2 page cache on 64 KiB hosts"), the preceding mailing-list
reply discussion, and the embedded format-patch headers, whereas
kvm_init_stage2_mmu() sizes mmu_page_cache_capacity from 2 *
kvm_mmu_cache_min_pages(mmu) for all host page sizes as described by the
embedded subject ("KVM: arm64: Size the stage-2 memcache from
kvm_mmu_cache_min_pages()").

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/d2b6e735-a685-4e79-=
bb39-2fb75ebecd09@linux.dev?part=3D1
