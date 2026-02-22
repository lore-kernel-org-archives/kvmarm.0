Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8316E1DE3DC
	for <kvmarm@lists.linux.dev>; Sun, 22 Feb 2026 17:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771783191; cv=pass; b=OT6o1kn97/EkoD3pM4PHxvKT2LdmxAE4T6+5CiIh36o4P/HpWX88r1CYhouwU6gPALzxctRFAnZL7wvV5UWqcH557o/AdQhFSow6Pn7SgGqVAkPz0CRUr2QKkOuiigaf30ns9N/54E7EZ4qqsPpVv7x7Pi7UHvsxXBcwuN0r1yw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771783191; c=relaxed/simple;
	bh=eKuRo72pi3QcR/TAbX6JrQsIwy/ci3OUBS1cUlynznM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fbze0stYwHJF0tWQ+1vCi/RtMSks9K9JwUspTb5an4JegPlWge2Zh+2YbC849or+a6KH/ASRmiKDeFuz1hbAy6HuQZttiI2cyDi/nP3700GXya0WABQsuRusvXUNU0i4T/ReZwmpPxA84HLWy+z1N+7D2gwCs/9UQxzBLILHcc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cpiuAUha; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cpiuAUha"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5069a785ed2so620681cf.1
        for <kvmarm@lists.linux.dev>; Sun, 22 Feb 2026 09:59:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771783188; cv=none;
        d=google.com; s=arc-20240605;
        b=dsZuW0GeSIUYEP78rMOcVjYbB2wy3wRAXyKXxXI0e5Qam8JM8vl92dlSWHpUVvK6PJ
         i+00qh+7b5mhLWKjiXhh4NTOMOuXL9GA7IPkND5WV13cOTriJ8TvFw9+X4nvUg0UiAa9
         PWLlYnVpl5SjW9G51WPkLXoRlqqteoEHO4UoRwZwWYI/9RPpZf/ISSzw0s2xOOZQUR4C
         6GzHK2/WgbLGe8T1oEk8s76h+Vzk9HCRdaPloxTa/cyx0PFBqo/SDJuO0P6J7kxf0GkJ
         ok0Qe1MKjiuchSvbRlC/SmWyBultDPpdylMs+Y7SqBzYMuSaKdARrZXpUpsmd5I0rfP0
         FdKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=pQ/DTelLQW8X8WLIzdKUZ9IVFS1QEQ7S0xRLul8dB6U=;
        fh=l+sdVha7YxfGfdzT9OeZJPp+WkrcNTj9WAopZOBOGVo=;
        b=I/swwZ1SR3g70Sg1Na/VlzkPiR4fd3vAt41OGlzwh6KALlPjloBadOyG6nBBWxKLiX
         MQqvhe0DR7neuxO6aVq0F4e51S/gp0SoL9dC3NvbbwuOS/FpuuY9wrI6W1E6mTh4fKlD
         UPvJsUtI/GuHpM9nox2Hk7JXQJzwA6Y6vFY+5FbSFRQFAECs9SbZYjU4+7ApALjmdm6n
         nOUjSVtbd83Ay2XtXvdaPWbkPZnTBADYwBffQZ6kgRziCihmTPdzqzL90X5jHZm1xWHo
         YWQNZKCJExk50Jf9O5juKvIV/uwyelp+1SszbOJb/JqnZHmUwx6tbEXU+mUfdOXxI8Hm
         6Dtw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771783188; x=1772387988; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pQ/DTelLQW8X8WLIzdKUZ9IVFS1QEQ7S0xRLul8dB6U=;
        b=cpiuAUhaLkviaNwCDEl4AgW2BGR0WQwTUNemZRAHKXAzWT43rZm6epiYtQk3eYlAQv
         1ZR6PWXYZeSf1dffhfBuqX9t7z4EuM6Kw3uGqOfKPLBv73P1FZt8kItFki/NvibN3hmc
         +VoquDNb97sWlhiCPW8fznW4Ht8VXs0AFV+7JJ0llTP80sfqMkw2nRN8GurDTkhNnUl5
         6uJLeKB74hIeISNOtV9Xr8Kcy0B3fDdCbgvZWiZyhiK7G8WxGunuZQL3Go52wkNTVaWA
         NvxYAeRvBF7IFq+qsN9ZVZxIDnXJbi11Y55soR9icY/gjFS8tJtR5cgqXPBE3+mI/Fdr
         fXOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771783188; x=1772387988;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pQ/DTelLQW8X8WLIzdKUZ9IVFS1QEQ7S0xRLul8dB6U=;
        b=EvsQDkKK6bMnvcUz2uhkRRiQ9/MZ8ZpyGQLoSvMmGjzuHCZu1vxbhWZ0KXLMbqU8UZ
         6ieyLZ4wHFH+7MOvCORAIva+2xYI4spRlSwwzlVVRpFAjMCdNZ+mw8QudXcGFEMxX6jm
         vkJ2gKK2HHhkf8DGc5A4sHTrwPfsWM9X9VCrQrmlTuDkYkANplSoWfGHAbT30QkqEZuS
         NiU1vcnTjDoziMkDFOgbfLg8Zias54ZdnWxTWjZW62JkkqNG6G0sDqaYtKMSAURJhR4C
         hDWiPvY1fpzcPF+1sXTEcEvYuRXryJcW0/dm27nxMxBstxf7pDuI/ELLTgV3XJxF4+KP
         tNYg==
X-Gm-Message-State: AOJu0Yxf3hdwvYOzcevTN6634F8iAt4LAb05yDscrTx+ixNhEyacV80T
	cLGW5s+kqKNGxdnKRhrbqCwOu+FZEXXY7LFu4LnzZROhluZxU1qBpgFq2dNmIjNdf6sNVuaKhft
	UK3DHE0h0/s2zV52KDS0rUJxwRod1ibFnxUTfqK3w
X-Gm-Gg: AZuq6aIohtCiu0ciwhoGhuZNow1jdk/7Sziqtqm0aPOGYHGuMPXtORlwXBgFzwFBnLX
	GLvTP22t5WhTSVY6wQCOhoWCa+UUpRLMtZb98N8LJFYGXG38pm5JGTGfEW6jjn7XT0H2qUQosEX
	Q4aPuagjpsWDPEyJTsIflSqcAKPdyjF/MF9yPqpHxMJUZB4pvXHkNZmirHVAb78/5vDNKwdYo9E
	LPhXd89j5xPkwaAzr1Bf7aTxoUwg5kWVWAqIrgBq1Z/RgOd3i1c5NrkUG0EoLWpOMettQW3aLn/
	X1vMHFJh
X-Received: by 2002:a05:622a:1451:b0:4ff:bffa:d9e4 with SMTP id
 d75a77b69052e-5070e8c5755mr13358721cf.13.1771783188028; Sun, 22 Feb 2026
 09:59:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260222141000.3084258-1-maz@kernel.org>
In-Reply-To: <20260222141000.3084258-1-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 22 Feb 2026 17:58:00 +0000
X-Gm-Features: AaiRm50zqZjqoVrNG72cEBICJ3I1cXMK2s6jm__GSaPoqNDpAt8k3N-biQWzjiE
Message-ID: <CA+EHjTy4p-Mbfr86NR9n1LgHC0EWrkdVjYb8O3z7k=Lv1entQg@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix protected mode handling of pages larger
 than 4kB
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Quentin Perret <qperret@google.com>, Will Deacon <will@kernel.org>, 
	Vincent Donnefort <vdonnefort@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sun, 22 Feb 2026 at 14:10, Marc Zyngier <maz@kernel.org> wrote:
>
> Since 3669ddd8fa8b5 ("KVM: arm64: Add a range to pkvm_mappings"),
> pKVM tracks the memory that has been mapped into a guest in a
> side data structure. Crucially, it uses it to find out whether
> a page has already been mapped, and therefore refuses to map it
> twice. So far, so good.
>
> However, this very patch completely breaks non-4kB page support,
> with guests being unable to boot. The most obvious symptom is that
> we take the same fault repeatedly, and not making forward progress.
> A quick investigation shows that this is because of the above
> rejection code.
>
> As it turns out, there are multiple issues at play:
>
> - while the HPFAR_EL2 register gives you the faulting IPA minus
>   the bottom 12 bits, it will still give you the extra bits that
>   are part of the page offset for anything larger than 4kB,
>   even for a level-3 mapping

Matches the ARM ARM.

> - pkvm_kvm_pgtable_stage2_map() assumes that the address passed
>   as a parameter is aligned to the size of the intended mapping

nit: pkvm_kvm_pgtable_stage2_map() -> kvm_pgtable_stage2_map()

> - the faulting address is only aligned for a non-page mapping
>
> When the planets are suitably aligned (pun intended), the guest
> faults a page by accessing it past the bottom 4kB, and extra bits
> get set in the HPFAR_EL2 register. If this results in a page mapping
> (which is likely with large granule sizes), nothing aligns it further
> down, and pkvm_mapping_iter_first() finds an intersection that
> doesn't really exist. We assume this is a spurious fault and return
> -EAGAIN. And again.
>
> This doesn't hit outside of the protected code, as the page table
> code always aligns the IPA down to a page boundary, hiding the issue
> for everyone else.
>
> Fix it by always forcing the alignment on vma_pagesize, irrespective
> of the value of vma_pagesize.
>
> Fixes: 3669ddd8fa8b5 ("KVM: arm64: Add a range to pkvm_mappings")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Cc: stable@vger.kernel.org
> ---
>  arch/arm64/kvm/mmu.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8c5d259810b2f..aa587f2e28264 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1753,14 +1753,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         }
>
>         /*
> -        * Both the canonical IPA and fault IPA must be hugepage-aligned to
> -        * ensure we find the right PFN and lay down the mapping in the right
> -        * place.
> +        * Both the canonical IPA and fault IPA must be aligned to the
> +        * mapping size to ensure we find the right PFN and lay down the
> +        * mapping in the right place.
>          */
> -       if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) {
> -               fault_ipa &= ~(vma_pagesize - 1);
> -               ipa &= ~(vma_pagesize - 1);
> -       }
> +       fault_ipa &= ~(vma_pagesize - 1);
> +       ipa &= ~(vma_pagesize - 1);

nit: Since we're changing this code anyway, should we use the ALIGN
macros instead?

Reviewed-by: Fuad Tabba <tabba@google.com>

and using 4, 16, and 64KB pages:

Tested-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


>
>         gfn = ipa >> PAGE_SHIFT;
>         mte_allowed = kvm_vma_mte_allowed(vma);
> --
> 2.47.3
>
