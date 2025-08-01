Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD373596D
	for <kvmarm@lists.linux.dev>; Fri,  1 Aug 2025 01:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754013413; cv=none; b=ILfncOlqZBxBvns2c3bCxVEHKzr954F4Kc5sD/cbTi7vSEixL7xLVWWMp6O+5fz2Vk38pa59f/qWL1YzQmC5qAa72Z5bPckeUmlS8PdIA4xykk2UWp0tY3epM6tT357tL8Ag42lFSJIjvCEf3fM6LNS+36XqFxwPyOMF+DYF6bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754013413; c=relaxed/simple;
	bh=1Iwn17Dg8kD3l6fB8LK+OZD/CwFCIbknU2KW6H2btN0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=keMSPv638Stc4JePEENay40CFQmPXsUsoHb1PQOciqSLhhh+3jYLf+sP+XTkgG86HMXSCe4yYQzhYGJ/DORtBtyEwju/cMOhvCHpyySrrYzSt3X0S/rF7IUSyvUag1DXu5kuiIQYMct6j4rAkY72+9tlFX16OrEe4Ztdin53tOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Od4TW79B; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Od4TW79B"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24070ef9e2eso79145ad.0
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 18:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754013411; x=1754618211; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=73dgZbebrLU8zYg1FAZPFQA33fxb43EZn3LSBSzNaM8=;
        b=Od4TW79BWIgro1+ghhEA+0fnLaNGuvF/2j2DTh40cCObzPkC5vaJeZvie+18Qcr2El
         TV4pByYc5QK/R+qaXHF/PSaFdYmU9qBbQvF4LPoAZBH2YvUnCt05ZAVCHIR16PNYLV2U
         CSyNUp1IegJGjNSLYx2mtvt9w58fYrM7eLV3wbLlsqhXaDWVm3/RB4LpH8bKGcG+MF0S
         BDVIZlxyP3brHbPOPnpYFYaQN//LFJHJ/dWtraim2VR8sgKS7VqqkHQe2KQK+422kZC9
         aXSBFmTIXSAx+IS/k4YY1oAixvg7BcO2c6LIfm/xm/9m89ZKYRwvDGvLvOHfyKM+gHbc
         929g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754013411; x=1754618211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=73dgZbebrLU8zYg1FAZPFQA33fxb43EZn3LSBSzNaM8=;
        b=m4IrWn0YdyNzdntNnjOjrTg4wW0gMSDNOW5NYqJjHeoAKZDR6lV/cWFOdCsKhHB1dp
         t1/OBWpL9Idv7szhQ+L9WY2TeyAGsh6A/r4WYSlRbvK1aauIpkbcaRzIg7EeWLfvKKfR
         7K8nb3fKI7sLBGK7AHTffP9KIFq65iALOZq/kh6QdCF8QJDX9wyh5BrBymfj1crUZIi7
         Y+5uheBe2T2FoQTjCBfBI3rMOZk4OUMB06j3Ex8vh4CAvxJ1qjXOQYy42d9bdfoyYo93
         A5JDw3C4Ojg5T132SsDLS6HZHn96ttZF+X48m0Jote8vABUfVG8oB5bVksXPeZ/IVwsO
         y5ow==
X-Forwarded-Encrypted: i=1; AJvYcCWr54G4VqRPbDwW3XabK9tVFoD3yNzh9urbttEFQTTvovenBX9NrnIhJHl6ilFYmScxWy9e36g=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyc7goJBhkbNSpExOPtM8MreRt6IfTSwrTLuSsKblyTYoDzvyH2
	sD2UMp8/OwkfCmPa/qtP5qUOojPKY+6UNL3M4Iub2Laq7KCgorybUobm57URoeG1P1NOX6jDNRg
	9DnQj8bLAAlAZSSoLx56nh9ck9fnxLq6+jomnlYln
X-Gm-Gg: ASbGncviVdusYIbWmIBN10A+CZk44nAEyjt2l5aprDxbG+PhUzDor+MhIhhmyfHFxAS
	Uk17lm8ARQFiHxxCUDWiUX4klbWkIxe0Paeh2wFdbdQeMNDm0dkmCRMv6UeYAzusDveJt/Orb+e
	5ZIK0ORr0U+sGtqAz0LQRtXe2VToRxIRWsAhXO5MA/wGWtY3drsP9LnO+X1fHJWVYNGjLs6v8Go
	DU5M1IIMYugOOAr1d8pXBJbXbKtIXnMj8oGZQ==
X-Google-Smtp-Source: AGHT+IGvZgypmLXLSq3N1f77JjImJFtH643iQZJ6JC8/AqrHkOHoDRMIuJnZGr/f0hMyS1/ZxzAo17cEHgxEVEja0es=
X-Received: by 2002:a17:902:d490:b0:240:48f4:40fd with SMTP id
 d9443c01a7336-2422a435a05mr1308475ad.19.1754013410954; Thu, 31 Jul 2025
 18:56:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250611104844.245235-1-steven.price@arm.com> <20250611104844.245235-20-steven.price@arm.com>
In-Reply-To: <20250611104844.245235-20-steven.price@arm.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Thu, 31 Jul 2025 18:56:38 -0700
X-Gm-Features: Ac12FXzyEE-6rAkSbBh6dTxzQhEIIz_vo5j0_DPiuqgwWpPvKvjM24zs36qca7o
Message-ID: <CAGtprH-on3JdsHx-DyjN_z_5Z6HJoSQjJpA5o5_V6=rygMSbtQ@mail.gmail.com>
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

On Wed, Jun 11, 2025 at 3:59=E2=80=AFAM Steven Price <steven.price@arm.com>=
 wrote:
>
> +static int realm_create_protected_data_page(struct realm *realm,
> +                                           unsigned long ipa,
> +                                           kvm_pfn_t dst_pfn,
> +                                           kvm_pfn_t src_pfn,
> +                                           unsigned long flags)
> +{
> +       unsigned long rd =3D virt_to_phys(realm->rd);
> +       phys_addr_t dst_phys, src_phys;
> +       bool undelegate_failed =3D false;
> +       int ret, offset;
> +
> +       dst_phys =3D __pfn_to_phys(dst_pfn);
> +       src_phys =3D __pfn_to_phys(src_pfn);
> +
> +       for (offset =3D 0; offset < PAGE_SIZE; offset +=3D RMM_PAGE_SIZE)=
 {
> +               ret =3D realm_create_protected_data_granule(realm,
> +                                                         ipa,
> +                                                         dst_phys,
> +                                                         src_phys,
> +                                                         flags);
> +               if (ret)
> +                       goto err;
> +
> +               ipa +=3D RMM_PAGE_SIZE;
> +               dst_phys +=3D RMM_PAGE_SIZE;
> +               src_phys +=3D RMM_PAGE_SIZE;
> +       }
> +
> +       return 0;
> +
> +err:
> +       if (ret =3D=3D -EIO) {
> +               /* current offset needs undelegating */
> +               if (WARN_ON(rmi_granule_undelegate(dst_phys)))
> +                       undelegate_failed =3D true;
> +       }
> +       while (offset > 0) {
> +               ipa -=3D RMM_PAGE_SIZE;
> +               offset -=3D RMM_PAGE_SIZE;
> +               dst_phys -=3D RMM_PAGE_SIZE;
> +
> +               rmi_data_destroy(rd, ipa, NULL, NULL);
> +
> +               if (WARN_ON(rmi_granule_undelegate(dst_phys)))
> +                       undelegate_failed =3D true;
> +       }
> +
> +       if (undelegate_failed) {
> +               /*
> +                * A granule could not be undelegated,
> +                * so the page has to be leaked
> +                */
> +               get_page(pfn_to_page(dst_pfn));

I would like to point out that the support for in-place conversion
with guest_memfd using hugetlb pages [1] is under discussion.

As part of the in-place conversion, the policy we are routing for is
to avoid any "refcounts" from KVM on folios supplied by guest_memfd as
in-place conversion works by splitting and merging folios during
memory conversion as per discussion at LPC [2].

The best way to avoid further use of this page with huge page support
around would be either:
1) Explicitly Inform guest_memfd of a particular pfn being in use by
KVM without relying on page refcounts or
2) Set the page as hwpoisoned. (Needs further discussion)

This page refcounting strategy will have to be revisited depending on
which series lands first. That being said, it would be great if ARM
could review/verify if the series [1] works for backing CCA VMs with
huge pages.

[1] https://lore.kernel.org/kvm/cover.1747264138.git.ackerleytng@google.com=
/
[2] https://lpc.events/event/18/contributions/1764/

> +       }
> +
> +       return -ENXIO;
> +}
> +
> +static int populate_region(struct kvm *kvm,
> +                          phys_addr_t ipa_base,
> +                          phys_addr_t ipa_end,
> +                          unsigned long data_flags)
> +{
> +       struct realm *realm =3D &kvm->arch.realm;
> +       struct kvm_memory_slot *memslot;
> +       gfn_t base_gfn, end_gfn;
> +       int idx;
> +       phys_addr_t ipa =3D ipa_base;
> +       int ret =3D 0;
> +
> +       base_gfn =3D gpa_to_gfn(ipa_base);
> +       end_gfn =3D gpa_to_gfn(ipa_end);
> +
> +       idx =3D srcu_read_lock(&kvm->srcu);
> +       memslot =3D gfn_to_memslot(kvm, base_gfn);
> +       if (!memslot) {
> +               ret =3D -EFAULT;
> +               goto out;
> +       }
> +
> +       /* We require the region to be contained within a single memslot =
*/
> +       if (memslot->base_gfn + memslot->npages < end_gfn) {
> +               ret =3D -EINVAL;
> +               goto out;
> +       }
> +
> +       if (!kvm_slot_can_be_private(memslot)) {
> +               ret =3D -EPERM;
> +               goto out;
> +       }
> +
> +       while (ipa < ipa_end) {
> +               struct vm_area_struct *vma;
> +               unsigned long hva;
> +               struct page *page;
> +               bool writeable;
> +               kvm_pfn_t pfn;
> +               kvm_pfn_t priv_pfn;
> +               struct page *gmem_page;
> +
> +               hva =3D gfn_to_hva_memslot(memslot, gpa_to_gfn(ipa));
> +               vma =3D vma_lookup(current->mm, hva);
> +               if (!vma) {
> +                       ret =3D -EFAULT;
> +                       break;
> +               }
> +
> +               pfn =3D __kvm_faultin_pfn(memslot, gpa_to_gfn(ipa), FOLL_=
WRITE,
> +                                       &writeable, &page);

Is this assuming double backing of guest memory ranges? Is this logic
trying to simulate a shared fault?

Does memory population work with CCA if priv_pfn and pfn are the same?
I am curious how the memory population will work with in-place
conversion support available for guest_memfd files.

> +
> +               if (is_error_pfn(pfn)) {
> +                       ret =3D -EFAULT;
> +                       break;
> +               }
> +
> +               ret =3D kvm_gmem_get_pfn(kvm, memslot,
> +                                      ipa >> PAGE_SHIFT,
> +                                      &priv_pfn, &gmem_page, NULL);
> +               if (ret)
> +                       break;
> +
> +               ret =3D realm_create_protected_data_page(realm, ipa,
> +                                                      priv_pfn,
> +                                                      pfn,
> +                                                      data_flags);
> +
> +               kvm_release_page_clean(page);
> +
> +               if (ret)
> +                       break;
> +
> +               ipa +=3D PAGE_SIZE;
> +       }
> +
> +out:
> +       srcu_read_unlock(&kvm->srcu, idx);
> +       return ret;
> +}
> +
