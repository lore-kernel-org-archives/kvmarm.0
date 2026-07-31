Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B003E3BF694
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 08:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785485125; cv=none; b=qSVoHjCBT5RBojUVyaBSPwRlVb1DVpoADOl6WxJqI8yqwAypVJFSyPZxxwCYTrmkrGjslDb4cpteDoXmHrEIx8LoKKEhv6s75usuN84pscs6gc0NP/6bolKR6NVdmmGcksVDtqzyTbVKJyfgnUqn4Vm7XpT748gnFoExtxKIzzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785485125; c=relaxed/simple;
	bh=tBCCqlmZxn5OI2IhWZPZlmoTQkgcFX26oqBWaCvzdoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GEfDEl55h5Sl2Ufou/BFVoOMOcURsnUAt31ci4ycf2e/OXMpUtYtUX0x0KoLUa4EjPdiiVtRZThtShHGym3DEP647FUkPuD+dkfXRpFG9/S4f2I8XpJQd76TrCj1wtZADyb6tGxqF7U+kXvmtV2p0k/pU0JqjmKE4K0j9hCHO0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=od+kVw/I; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="od+kVw/I"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-697bd21fdc2so1169312a12.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 01:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785485122; x=1786089922; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tREC8DWAl11F8/UnxzNAwFRNYfjo+IaeEh5kckOuNAE=;
        b=od+kVw/Iw72Z4vv5R4JLJj353wox7OoeJKsYv5ISz90I/dly4oj6xvlEjg8WSFVMhx
         sT+nfgRNxHgypxxXGAP9BYWJ60zkA/AHcw+WlASfMCzp4eUDsb7sTQgPI7nb0iHckWvI
         LzDxut9etIXYM0Wc4by7mAnK8cOgxkSoLd2RF/FJgEzN3H7mwqRzhUl5OKDJ5grJGqs5
         FzYGl5W/iCkEcoljEKTR/wgUDG1xhrSYFGTIhjkWv2XFi0g3OuO4v7xXcJFFJ8MTTSy6
         YuUKUFlfTvvwOYZc0tKMhB8TAU5llTytf4ETRydgewToMXjaJoxJ5I9gN1Bd13kvKqMN
         Pbcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785485122; x=1786089922;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tREC8DWAl11F8/UnxzNAwFRNYfjo+IaeEh5kckOuNAE=;
        b=Dun19/C4090pVTT5WtK0nSC9kPO3xeqMKSKL1iL5idIUwXA6evBltaBBlsNTgFi+9j
         Qravk05Q0Orxel/+UE0cX9FS0utG/VcTqUK8e5Tf0Gq53ybD3Lho9y4PMR8U+EM5vLtO
         5v5FVVDXzvshL7/x1JLzVLgqn4knPoXCXEepD/EWvrhBTu4/GGTr6f+uT/9949DZgvbR
         nus42PiIt2CgkKVnHVh8SYb/twYY/3XxjR71MXOIfFHfCe1Dfm+0/WbK1Olijm9on1JN
         oKn8IpPDJVJ4NYXgR3bdX2r0Jb+DAtSx//wA9DN7wwDuq9pTqZsMyeX0bjXDijuEP8C2
         8FDQ==
X-Forwarded-Encrypted: i=1; AHgh+RoS56x478UOVX/i5j63Kr48D2zf3+hpVV4vQoboTqTmVHQgM2BziIxbewwq3Xv4nJ649N+Pk/g=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7fmhFnKZIuIa66McAU+ZQuWFXi4skciQFfvC68VNfb3Vep2lS
	YFhHjDTZQPVXq8XKd/7HGhgAars84Hut8/NWctq/G0as0QXEEHn4OeaJT66s8oQHmw==
X-Gm-Gg: AR+sD13WipF+MD4JGCzIq0ZdBhlyR7Hk0UFgpSNOivRp4npgrBmYAYb458iu+5tCiEz
	11N6Ub/fULshOY1IbrGh/YBuYyRkuWE7XtqwirBH6w8/bh1/WCC5ZfSYiu7/WZjX2U1e85jMLfg
	06WgCf1BSkj8Ez7lEDSgYKYc3rtwrbOfUvprEZBWHOA0yFauv7nyuHMTG5dInAbyDMTDbnDMWS4
	9te6GliNrQoCDfXx/Z78nuQgHZp657H6mKm9NpxZc6o49AflX3lvKlKXKDE9RZ4wQKFu2eVxOpI
	bnqBk6zwvlHqWRJKCny6JzUSvXjJtMxSCbbJ2Q0wlxmuc74JemZ72ZEHJY34Y0JaJc+09qgw53B
	K2q88BsfI2qQVOk2hMh0mjPSyYEkNaIhBexo+2dg6yPh5fawpScQiItzXkQz40zy+irMJEoL+NU
	4GNcWv2m0VnhNjt4/iPd6ixXcNWoSJTcC4AVUcdTagF6MN1Wz67x5mbc1NkRlHNe0zVnvX/08Kr
	7wJlaRM7udK/ZAjDgYkico1EpVa8qiT
X-Received: by 2002:a17:907:d08e:b0:c16:2d90:68d9 with SMTP id a640c23a62f3a-c1fd26e8036mr51597866b.56.1785485120934;
        Fri, 31 Jul 2026 01:05:20 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd3cc3ea1sm54322866b.26.2026.07.31.01.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 01:05:19 -0700 (PDT)
Date: Fri, 31 Jul 2026 09:05:16 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v3 01/17] KVM: arm64: Add pkvm_private_va_range_pa
Message-ID: <amxXPMVAMExpVEU8@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-2-vdonnefort@google.com>
 <20260720172559.B2DBB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260720172559.B2DBB1F000E9@smtp.kernel.org>

On Mon, Jul 20, 2026 at 05:25:59PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Incorrect physical address calculation for block mappings in pkvm_private_va_range_pa()
> --
> 
> --- Patch [1]: [PATCH v3 01/17] KVM: arm64: Add pkvm_private_va_range_pa ---
> commit 81aa726ac7516be8619c0cb2674493e48b6fca16
> Author: Vincent Donnefort <vdonnefort@google.com>
> 
> KVM: arm64: Add pkvm_private_va_range_pa
> 
> This commit introduces pkvm_private_va_range_pa() to resolve physical
> addresses for the pKVM private range by walking the hypervisor page-table.
> This prepares for the upcoming pKVM heap allocator.
> 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
> > --- a/arch/arm64/kvm/hyp/nvhe/mm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/mm.c
> [ ... ]
> > +phys_addr_t pkvm_private_va_range_pa(void *va)
> > +{
> > +	kvm_pte_t pte = 0;
> > +
> > +	guard(hyp_spinlock)(&pkvm_pgd_lock);
> > +	WARN_ON(kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)va, &pte, NULL));
> > +	WARN_ON(!kvm_pte_valid(pte));
> > +
> > +	return kvm_pte_to_phys(pte) + offset_in_page(va);
> 
> [Severity: High]
> Does this calculation handle block mappings correctly?

There's no risk to step into a block mapping with the users of that function.

I could WARN_ON() though...

> 
> If the virtual address is mapped via a block descriptor (such as a 2MB
> large page), kvm_pte_to_phys(pte) returns the base physical address of
> the block. Adding offset_in_page(va) will only preserve the lowest 12
> bits, discarding the intermediate offset bits between the page size and
> the block size.
> 
> Could this cause multiple virtual pages within the block mapping to
> incorrectly resolve to the same physical base page plus a small offset?
> Perhaps this should retrieve the mapping level from kvm_pgtable_get_leaf()
> and mask the virtual address with the corresponding granule size?
> 
> > +}
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260720171513.1415357-1-vdonnefort@google.com?part=1

-- 
-- 
Vincent
