Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AE320127B
	for <kvmarm@lists.linux.dev>; Fri, 15 Aug 2025 18:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755281909; cv=none; b=dakkB5YHT/zBgPIDQ+W8g9FX57mq1NkYNVd9MkS3WRA0AuCCI7aOsQYn7utLU+bdHvd2zhWqpDmH3V7Wc2rZ6nk6/X5DXIqPW8R90LZaWlvVzHtDrG1ND6Eijz//cw3DpVS6JCsH1wwFIvB20uk+3eNyGqUmXhDbbTFsd2v7hHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755281909; c=relaxed/simple;
	bh=wY+vgsaCc43x29sy+D58GL7Km3HCFo3Oin22U4JvFBc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hi7WaOVGawzMuLYkM7VyquQphOhrAJt4OAv9+/mMurNgWJbvlV4fHFbGpNq6pUMb7zCjdZm+V1kcb3mOp+ZO9jLhTc57sAW1vf2wK+O0iWemuixqAehuJtR+aQqABc/tKH1mGKGbEin8t3dZ6NpRkO3+l15p4DSHbypNGwfCdG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FizPF7Gm; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FizPF7Gm"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-242d3be5bdfso13575ad.1
        for <kvmarm@lists.linux.dev>; Fri, 15 Aug 2025 11:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755281907; x=1755886707; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jY3sNtwdFAAn0D3rH2WM6exJASiMf81df/QjJ9/2MSs=;
        b=FizPF7GmvfoeY9Er7f0BGuTlug4LB0ATDC+TVXYCsS8rxICp3wA7nmTBOYoSLkXahj
         9vA/fWHq93Bp+MmwlVbWvUwjilCNpAfno0LojhxLqMuNkKqDt9JMAA/nnXBO7kef8TDa
         ybUeQUYlivtJuqwCT9SgYNtjIzWKpAddm7VICwIpi+iV7/2DoLlFuwKWVJEOvPoxEQSq
         DBCDtLAuXHUFMJ9KseK9yItdail2SwyVHFEOHj4UWuSW6OyqWJ39HMrXuJ9OCP5q8mf/
         j/21McTx9DSvs2v6cJ0FQ9fQPeRGiZxU4O0MsVrweeIeeZ/o7GC9fo/ut7ERxjf2P8XS
         2hbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755281907; x=1755886707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jY3sNtwdFAAn0D3rH2WM6exJASiMf81df/QjJ9/2MSs=;
        b=JIvoupaMZ63Dj+6yc6BZz6XerjEgUoFEWR18o9BS0TPezBF5OvuV0ftTbEcXmJl1Iy
         FFQS+kWwW0ZANj9mDNSVBWhAGU0xhHwrOe19bv1X1SvgSRlxrXos0skB9Js6NxqzHs/S
         kzJ2pgu9G73Lc4bhBKq5NMsp6g+l1saAr8Ofb0FAzSX8BjODKANGWShXP+LxvrdSLzZs
         N4cB/jCr8y9sNBKNKFV1koJkT64d1nZqbf8K7lIhX6djvK+UKCF8tDPMAkLBH2AzeYa+
         SWRp7yAgO5JQ00oTDxqhxEV+a1haZcAxwUdxsrNZ4CqQfbhDQh7N4sus7HlEEYRv8lwK
         mBJg==
X-Forwarded-Encrypted: i=1; AJvYcCVjHI8DN/BQiIl05spk2GtrGC7SzUi5meLN2uk2T380Obqhx5wQHtZv7+4lZOWgqKbypwVrXD8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGE2nOUjoE1d2ffoBIkr1Cjz1MSRhOAFbvZEx099QLPCpToNob
	zh9mhHU8BTlhkaOwyYNSJvDY0SltpMP43WDn3ox1Nke/EjDrc5WBGjFBwKDcLqhtTfhzp06mHSS
	NuRnaM1a1rE7EMruGeeNiW6xGLjHi/7dYtS1TzxWh
X-Gm-Gg: ASbGnctjZfR4MJVXzfoko4au14BKQvfY47Ym1lrK3Yk2MrRZX79pFHQ2XZSH1gQd9QH
	8W71LNUBu/7hOAO6gmRJq5s092d7ZJ8ufczEU6EL1HpY+mOL1AamkQwGhWSAX+uidc6GXZ8r3DL
	sFDmYzxZK7s+gevc6H8fjr5MHJXz4FbRpfOFFhx+sM7znVSdUvNazU1r3Zy7xyEy0fUnGqf0t5y
	BmSr6lFIZnM7KMWqos+ZTAsr/3KwXW71MAw2ZO5HFyv0kWDjrgrpw==
X-Google-Smtp-Source: AGHT+IG/MLfEHn+NUjk3JeTkvygoGYy2JeIHzIrZZHZgIjMPHcITqpps3JgVEHZ+BBPTyF9DrPEKdybZgIAFZ8JuvHo=
X-Received: by 2002:a17:902:f709:b0:242:abac:2aae with SMTP id
 d9443c01a7336-24478e4ac08mr177905ad.12.1755281907107; Fri, 15 Aug 2025
 11:18:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250611104844.245235-1-steven.price@arm.com> <20250611104844.245235-20-steven.price@arm.com>
 <CAGtprH-on3JdsHx-DyjN_z_5Z6HJoSQjJpA5o5_V6=rygMSbtQ@mail.gmail.com>
 <80c46a5c-7559-4763-bbf2-6c755a4b067c@arm.com> <CAGtprH_6DYk8POPy+sLc3RL0-5gcrTdPNcDWFTssOK5_U4B3Nw@mail.gmail.com>
 <23be7cdb-f094-4303-87ae-2fdfed80178b@arm.com>
In-Reply-To: <23be7cdb-f094-4303-87ae-2fdfed80178b@arm.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 15 Aug 2025 11:18:15 -0700
X-Gm-Features: Ac12FXxRfPJJ5CiXj1SEYOdMuRetA156ExPvVO3KltOm1QNQAryxM5r582UfZ7g
Message-ID: <CAGtprH9rbW173qZyC5_cHkKT5J4YDSg8itFcR2VZvSY88fsGrQ@mail.gmail.com>
Subject: Re: [PATCH v9 19/43] arm64: RME: Allow populating initial contents
To: Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 8:48=E2=80=AFAM Steven Price <steven.price@arm.com>=
 wrote:
>
> >>>> +static int populate_region(struct kvm *kvm,
> >>>> +                          phys_addr_t ipa_base,
> >>>> +                          phys_addr_t ipa_end,
> >>>> +                          unsigned long data_flags)
> >>>> +{
> >>>> +       struct realm *realm =3D &kvm->arch.realm;
> >>>> +       struct kvm_memory_slot *memslot;
> >>>> +       gfn_t base_gfn, end_gfn;
> >>>> +       int idx;
> >>>> +       phys_addr_t ipa =3D ipa_base;
> >>>> +       int ret =3D 0;
> >>>> +
> >>>> +       base_gfn =3D gpa_to_gfn(ipa_base);
> >>>> +       end_gfn =3D gpa_to_gfn(ipa_end);
> >>>> +
> >>>> +       idx =3D srcu_read_lock(&kvm->srcu);
> >>>> +       memslot =3D gfn_to_memslot(kvm, base_gfn);
> >>>> +       if (!memslot) {
> >>>> +               ret =3D -EFAULT;
> >>>> +               goto out;
> >>>> +       }
> >>>> +
> >>>> +       /* We require the region to be contained within a single mem=
slot */
> >>>> +       if (memslot->base_gfn + memslot->npages < end_gfn) {
> >>>> +               ret =3D -EINVAL;
> >>>> +               goto out;
> >>>> +       }
> >>>> +
> >>>> +       if (!kvm_slot_can_be_private(memslot)) {
> >>>> +               ret =3D -EPERM;
> >>>> +               goto out;
> >>>> +       }
> >>>> +
> >>>> +       while (ipa < ipa_end) {
> >>>> +               struct vm_area_struct *vma;
> >>>> +               unsigned long hva;
> >>>> +               struct page *page;
> >>>> +               bool writeable;
> >>>> +               kvm_pfn_t pfn;
> >>>> +               kvm_pfn_t priv_pfn;
> >>>> +               struct page *gmem_page;
> >>>> +
> >>>> +               hva =3D gfn_to_hva_memslot(memslot, gpa_to_gfn(ipa))=
;
> >>>> +               vma =3D vma_lookup(current->mm, hva);
> >>>> +               if (!vma) {
> >>>> +                       ret =3D -EFAULT;
> >>>> +                       break;
> >>>> +               }
> >>>> +
> >>>> +               pfn =3D __kvm_faultin_pfn(memslot, gpa_to_gfn(ipa), =
FOLL_WRITE,
> >>>> +                                       &writeable, &page);
> >>>
> >>> Is this assuming double backing of guest memory ranges? Is this logic
> >>> trying to simulate a shared fault?
> >>
> >> Yes and yes...
> >>
> >>> Does memory population work with CCA if priv_pfn and pfn are the same=
?
> >>> I am curious how the memory population will work with in-place
> >>> conversion support available for guest_memfd files.
> >>
> >> The RMM interface doesn't support an in-place conversion. The
> >> RMI_DATA_CREATE operation takes the PA of the already delegated
> >> granule[1] along with the PA of a non-delegated granule with the data.
> >
> > Ok, I think this will need a source buffer from userspace that is
> > outside guest_memfd once guest_memfd will support a single backing for
> > guest memory. You might want to simulate private access fault for
> > destination GPAs backed by guest_memfd ranges for this initial data
> > population -> similar to how memory population works today with TDX
> > VMs.
>
> Yes, that might well be the best option. At the moment I'm not sure what
> the best approach from the perspective of the VMM is. The current setup
> is nice because the VMM can populate the VM just like a normal non-coco
> setup, so we don't need to special-case anything. Requiring the VMM to
> load the initial contents into some other memory for the purpose of the
> populate call is a little ugly.

IIUC ARM CCA architecture requires two buffers for initial memory
population irrespective of whether we do it within kernel or in
userspace.

IMO, doing it in the kernel is uglier than doing it in userspace.
Baking the requirement of passing two buffers into userspace ABI for
populate seems cleaner to me.

>
> The other option is to just return to the double-memcpy() approach of
> emulating an in-place content-preserving populate by the kernel copying
> the data out of guest_memfd into a temporary page before doing the
> conversion and the RMM copying back from the temporary page. I worry
> about the performance of this, although it doesn't prevent the first
> option being added in the future if necessary. The big benefit is that
> it goes back to looking like a non-coco VM (but using guest_memfd).

Populate path is CoCo specific, I don't see the benefit of trying to
match the behavior with non-coco VMs in userspace.

>
> > Note that with single backing around, at least for x86, KVM
> > shared/private stage2 faults will always be served using guest_memfd
> > as the source of truth (i.e. not via userspace pagetables for shared
> > faults).
>
> Indeed, it's not yet clear to me whether we can only support this
> "single backing" world for CCA, or if it's going to be an option
> alongside using guest_memfd only for protected memory. Obviously we need
> the guest_memfd changes to land first too...

Having a dual backing support just for supporting the initial populate
seems overkill to me. How much payload in general are we talking about
in terms of percentage of total memory size?

IMO, dual backing for guest_memfd was a stopgap solution and should be
deprecated once we have single memory backing support.
CoCo VMs should default to using single backing going forward. Mmap
support [1] for guest_memfd is close to getting merged. In-place
conversion support is likely to follow soon.

[1] https://lore.kernel.org/all/20250729225455.670324-1-seanjc@google.com/

>
> At the moment I'm planning to post a v10 of this series soon, keeping
> the same API. But we will definitely want to support the new guest_memfd
> approach when it's ready.
>
> Thanks,
> Steve
>
