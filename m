Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795643614;
	b=SS3MWbqjkr8OpR9fvBGSWYguWywI2pdrzSe1slkZEgAK1g8szkTLZBvtGv41bmZgjxuM
	 tR888zqXj1103eUqGMfeNLfet/NPUkRjzMguE1oLr2K3gqxZewbWCI+sAskJZJgn7AxKj
	 +aqhtLBfAmvuU9oDOx6VizL6LMYBiEt+nNQcgAe3TeM8AOCo9Kfx7Jko24PufUUYzYEDB
	 028VhzGV2m4ZTy9tNjHd4UtJSKyv+RwnU0uWWxCzsnP+LhYHUQ29fOmR1ej4Jm481DwIv
	 KbPHTNUEoWC8xgKfOARoJLTfP2uDRfxM3Y65gR1c2tkN3zyFMjZjcI5i8x7JhNTU6jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795643614;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=sIM9fx3UciPNclOJSjwkVx8iGpyjMEGk3Ypj6DNOxLI=;
	b=TzDwGQTeopmfTurQt8fsy3EINgaSGPpsJRlmP7fqcoIXsWsEcteBfcAskfVWTFlXOIIl
	 iO8DGLc04Nng2FwXt6yMGfeUTDYMyIOuY3hUjn5uzROelPtWPi5u70zDUboPpfsa1Jb+H
	 NefayzdFd9Mp8rNMQFrky1H332PFLTcDtgJ1gyDypluvSLb2qSWX5w6wAQHGxFVSlbW6q
	 vIPvcYJq29T2M7SQ0SAxzfB4lCYEGPBs5uG37H1kYVbdeMAoZkSR/ILNZOEfXAdiuKDFy
	 CWNg3pwAp20MfnTQ1v+AH1xbLHjZgcLyVbDN9afd9OjFtOKsQWY+iSmAUIeEba72nFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hbqclMd0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA1A606A31E
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 21:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hbqclMd0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D5F1F000C4;
	Wed, 25 Nov 2026 21:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795643614;
	bh=sIM9fx3UciPNclOJSjwkVx8iGpyjMEGk3Ypj6DNOxLI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hbqclMd0Si/C4FDtBz7XuJBmA3kLufYtbXfQW/RWOzXdr4oBeVICpJwg38anSzjSA
	 2+pZCnBx1A//c1eXa/uGBwLUcThEPQ5BrjPicRkt9IraIDMDE/d/mon9yid9UTmXTq
	 hDpfmr0+HH4/EvdWPqCZZ06Pj3XIySoGOlJgzirovSP2XnQD0Srfa7Eyjexv5DTVED
	 ovYuc4gxt9tNjVcDZT+AI3s+Oiz44nLc2zoXUCR2cLPGpCfdVBydo8E3Lj+RB4fB5F
	 5txaS6bxQWoe4M0eybrJA4yldf0DmurKeonyUzN8NZd5LNA2iySCepQ4rZI+HytBoT
	 K0EJbyNuNYwsQ==
Message-ID: <sashiko-outbox-234217@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Reduce the stage-2 page cache on 64 KiB
 hosts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Usama Arif" <usama.arif@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev>
References: <20261124152842.2634495-1-usama.arif@linux.dev>
 <awcXhk885lqDRAHy@LeoBrasDK>
 <06a69a4f-59bb-49b8-9ed0-f4cfe0ecad37@linux.dev>
 <awcoCklLOKeuXPhh@LeoBrasDK>
 <e7bdcfa9-bbd8-4649-8318-2f6dc236db15@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 21:53:33 +0000
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
- [High] KVM: arm64: malformed reply commit message with mismatched v1
  title
--

commit 093f37ce9b0582c3a6435d4b347c08fc152ebd2e
Author: Usama Arif <usama.arif@linux.dev>

> KVM: arm64: Reduce the stage-2 page cache on 64 KiB hosts
>
> On 25/11/2026 10:25, Leonardo Bras wrote:
> > On Wed, Nov 25, 2026 at 05:55:29PM +0000, Usama Arif wrote:
> >>
> >>
> >> On 25/11/2026 09:14, Leonardo Bras wrote:
> >>> On Tue, Nov 24, 2026 at 07:28:42AM -0800, Usama Arif wrote:
> >>>> When a stage-2 fault may need new page tables, KVM first tops up the
> >>>> vCPU's page cache: if it holds fewer pages than the fault might need=
, it
> >>>> is refilled to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, which arm64 sets to
> >>>> 40. Unused pages stay in the cache until the vCPU is destroyed.
> >>>>
> >>>> With 64 KiB pages, that is 2.5 MiB per vCPU, and most of it is never
> >>>> used. Stage-2 has at most three levels and the root is preallocated,=
 so
> >>>> a fault needs at most two new table pages (kvm_mmu_cache_min_pages()=
).
> >>>> As every last-level table covers 512 MiB, an 8 GiB guest needs just =
17
> >>>> table pages to map all of its memory, while its four vCPU caches get
> >>>> filled with 160.
> >>>>
> >>>> On a production host with 64 KiB pages running 101 VMs with four vCP=
Us
> >>>> each, the caches were still 86% full. The memory used:
> >>>>
> >>>>                         before      after
> >>>>   per-vCPU capacity     2.5 MB     512 KB
> >>>>   all 404 vCPUs         869 MB     <=3D 202 MB
> >>>>
> >>>> Let's lower the capacity to 8 with 64 KiB pages, In the production
> >>>> usecase above, it frees at least 667 MB. That still covers the two-p=
age
> >>>> minimum and leaves room for several table allocations per refill. 4 =
KB
> >>>> and 16 KB pages keep 40.
> >>>>
> >>>> The temporary cache in kvm_phys_addr_ioremap() uses the same capacit=
y,
> >>>> but it is topped up before every page it maps, so 8 is sufficient th=
ere
> >>>> as well. The pKVM hypervisor memcache and the eager split cache don't
> >>>> use this capacity.
> >>>>
> >>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >>>> ---
> >>>>  arch/arm64/include/asm/kvm_types.h | 5 +++++
> >>>>  1 file changed, 5 insertions(+)
> >>>>
> >>>> diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include=
/asm/kvm_types.h
> >>>> index 9a126b9e2d7c99..28568da9ea4a7b 100644
> >>>> --- a/arch/arm64/include/asm/kvm_types.h
> >>>> +++ b/arch/arm64/include/asm/kvm_types.h
> >>>> @@ -2,7 +2,12 @@
> >>>>  #ifndef _ASM_ARM64_KVM_TYPES_H
> >>>>  #define _ASM_ARM64_KVM_TYPES_H
> >>>>
> >>>> +/* Must cover kvm_mmu_cache_min_pages(), at most 2 with 64 KiB page=
s. */
> >>>> +#ifdef CONFIG_ARM64_64K_PAGES
> >>>> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 8
> >>>> +#else
> >>>>  #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> >>>> +#endif
> >>>>
> >>>>  #endif /* _ASM_ARM64_KVM_TYPES_H */
> >>>>
> >>>> --
> >>>> 2.53.1-Meta
> >>>>
> >>>
> >>> Hi Usama,
> >>>
> >>
> >> Hello Leonardo,
> >>
> >>> Have you tried to reproduce this issue in v7.4-rc1 or newer?
> >>
> >> Yes. The patch is against kvmarm/next (v7.4-rc3), which includes
> >> Lorenzo's pre-fault series, and I A/B tested it there.
> >>
> >> On unpatched v7.4-rc3 with 64 KiB pages, a VM whose 16 vCPUs each fault
> >> in one page needs a single stage-2 table page, yet the vCPU caches hold
> >> 640 pages (40 MiB). With the patch they hold 127 pages.
> >>
> >>>
> >>> IIUC Lorenzo Stoakes introduced a change that would cause the memcach=
e to
> >>> skip topup if the cache contains a minimum of ~4 pages, so it can pos=
sibly
> >>> improve that issue.
> >>
> >> I don't think that part is new. __kvm_mmu_topup_memory_cache() has
> >> returned early when mc->nobjs >=3D min since commit 6926f95accee ("KVM:
> >> Move x86's MMU memory cache helpers to common KVM code"). Lorenzo's
> >> commit d27acc152c62 ("KVM: arm64: Size the stage-2 memcache from the
> >> fault MMU") takes min from s2fd->mmu instead of vcpu->arch.hw_mmu. For=
 a
> >> guest abort that is the same MMU, so nothing changes here.
> >>
> >> With 64 KiB pages, min is kvm_mmu_cache_min_pages(), which is at most =
2.
> >>
> >>>
> >>> Although I can see that when it's below that minimum it fills the who=
le
> >>> capacity (40) of the cache.
> >>>
> >>
> >> Right, and that is the problem. Skipping the top-up avoids refilling
> >> the cache, but nothing ever drains it. A vCPU's first fault fills its
> >> cache to 40. Each last-level table covers 512 MiB, so a guest needs ve=
ry
> >> few table pages, and most vCPUs never drop below min. The remaining
> >> pages stay allocated until the vCPU is destroyed, which is why the
> >> production caches were still 86% full.
> >>
> >> The patch keeps the early return and only lowers how far a refill goes.
> >
> > Right,
> >
> > I took a look in the cache workings, and it does not seem to receive fr=
eed
> > pages back in. It gets filled by topup and used by map, so IIUC it is u=
sed
> > only to avoid failing an allocation during the mapping walk.
> >
> > Maybe it could be the case to simplify this cache to have the capacity
> > about the same as the minimum (since it always topup before mapping) and
> > avoid the waste altogether.
> >
> > Maymbe having something like this should be enough?
> >
> > #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE (KVM_PGTABLE_LAST_LEVEL - KVM=
_PGTABLE_FIRST_LEVEL)
> >
>
> That sounds good to me. I tested and it works (and releases even more mem=
ory :))
>
> I had to move #defines around to make it work, the current patch sits
> like below. If this seems acceptable, I can send it as v2 for review.
>
> From 9b044379f470625adb031a0ee7529e054d9ec219 Mon Sep 17 00:00:00 2001
> From: Usama Arif <usama.arif@linux.dev>
> Date: Wed, 25 Nov 2026 12:55:15 -0800
> Subject: [PATCH] KVM: arm64: Shrink the stage-2 memcache to the page-table
>  depth
>
> When a stage-2 fault may need new page tables, KVM first tops up the
> vCPU's memcache: if it holds fewer pages than the fault might need, it
> is refilled to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, which arm64 sets to
> 40. Pages never return to the cache, and unused ones stay there until
> the vCPU is destroyed.
>
> The cache only has to cover a single map: every fault that can allocate
> tables tops it up first, and a map allocates at most one table per
> level below the preallocated root (kvm_mmu_cache_min_pages()). That is
> at most three pages with 4 KiB and 16 KiB pages, and two with 64 KiB
> pages.
>
> With 64 KiB pages, the 40-page cache is 2.5 MiB per vCPU. As every
> last-level table covers 512 MiB, an 8 GiB guest needs just 17 table
> pages to map all of its memory, while its four vCPU caches get filled
> with 160. On a production host with 64 KiB pages running 101 VMs with
> four vCPUs each, the caches were still 86% full. The memory used:
>
>                         before      after
>   per-vCPU capacity     2.5 MiB     256 KiB
>   all 404 vCPUs         869 MiB     <=3D 101 MiB
>
> Let's size the cache to KVM_PGTABLE_LAST_LEVEL - KVM_PGTABLE_FIRST_LEVEL,
> which is 4 pages and covers the deepest walk with one page to spare. On
> the host above, it frees at least 768 MiB. Refills get more frequent,
> but no more than four pages per vCPU ever sit unused. With 4 KiB pages,
> the cache shrinks from 160 KiB to 16 KiB per vCPU.
>
> Move the two level definitions to asm/kvm_types.h, so that the generic
> top-up code in kvm_main.c can see them. kvm_pgtable.h still gets them
> through linux/kvm_types.h.
>
> The temporary cache in kvm_phys_addr_ioremap() uses the same capacity,
> but it is topped up before every page it maps. The pKVM hypervisor
> memcache and the eager split cache don't use this capacity.
>
> Suggested-by: Leonardo Bras <leo.bras@arm.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

[Severity: High]
The commit message appears to be an unedited mailing-list reply containing
the quoted v1 discussion and diff, conversational text, and an embedded
format-patch header block. Because the patch shrinks
KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE to 4 across all host page sizes rather
than only on 64 KiB hosts, and the quoted v1 diff separator causes patch
parsers to truncate the body before the Signed-off-by trailer, the thread
reply and embedded headers should be stripped so the commit uses the v2
subject ("KVM: arm64: Shrink the stage-2 memcache to the page-table
depth") and changelog directly.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/e7bdcfa9-bbd8-4649-=
8318-2f6dc236db15@linux.dev?part=3D1
