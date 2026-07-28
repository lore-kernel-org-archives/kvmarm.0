Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA75B314B6D
	for <kvmarm@lists.linux.dev>; Tue, 28 Jul 2026 09:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785232047; cv=none; b=ttrnwwu8y2ZvwVfxjcSIgth5r6l2OqL5hgMuUiinIPCq3NW1Aa7dWkwGLcHt3MH3c8cM2PyZTjpKYrH8Q31ytV53Y2zrrrIhDKaaGu48D8O/FgyGSX/PYWnUhP8+A1mzut+QVQdw20d+oSP82lmD4AqwseFjKnZNZ33gOYc7EIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785232047; c=relaxed/simple;
	bh=7wI6jghwXjqIpfRXc4ISkN3dnzd++TejSJF2KhXBoPg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YRju0ZYnTtyrI2edhk5LCxfzPrplfQmZyu753a9tdyXags8pPnfUvkCSVdETBVZErkJLyD4yKw2sIEFMw20P633N8wnc/F4CW83LVTy+9nzhubgWpi8jLlWCFspR396ZHD7h8uAO2Y26mRtNNFfCjcytnnH0v8UPNkGH2ZON59g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U722VVme; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U722VVme"
X-Forwarded-Encrypted: i=1; AHgh+RqWXyJhX+ebTemX8COKDqa5sUviS1Bs/f6miHQ9Hmcxu6/Q/sAO0PyJN+uHKXX0x4Aohze3tQw=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785232041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zul95q2edkfvVEgOYYXJEs/IWUfnxAxG6HlhqT6G6ZM=;
	b=U722VVmeQX92tTmEAKEYlfb59+5DbVuiI9GgrZ41pwywg3qYKi2GSF/muycY8F28fidCZ7
	7M36H21vtpR6//yAsV/LzVHGGeJGHua36Um7/aLGJSiWQLWRVg2fXiP4+vJLQMcGzBeDtD
	v8QdSbzDH4zl9ZXYz8N1ZDtkWmxgAmU=
X-Gm-Message-State: AOJu0Yy56Blp0tm7sQikufUz50JEiHK+uEQPi/eMOblNmPm+UQpgvl6r
	0Hy+uI9ov5h4QphGBbLvtvaiwbQehJwFR9kjqaWypF3MDWjDEoQCn4zYdpqEKPeDPkZ9GGgQnlh
	mjJmGYl3tz41s9p/22/xW+pdIgMcbLgJxfiLLmp9k
X-Received: by 2002:a05:622a:aa4d:10b0:519:b82d:fe62 with SMTP id
 d75a77b69052e-529a766aaa6mr50860001cf.7.1785232025049; Tue, 28 Jul 2026
 02:47:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ameGoxbn2wzBq2kL@v4bel>
In-Reply-To: <ameGoxbn2wzBq2kL@v4bel>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 28 Jul 2026 10:46:27 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzmrSD=mPwGv2E+P0+buA=N5+HiV+QkMC=G+9zsQhPJFA@mail.gmail.com>
X-Gm-Features: AUfX_mxBDit6wudXeLiFNj76ppjc7lUTgOi-ZIE3Da7a8Xd_yV4KRw99UJrNVE4
Message-ID: <CA+EHjTzmrSD=mPwGv2E+P0+buA=N5+HiV+QkMC=G+9zsQhPJFA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: nv: Don't skip VNCR invalidation when the TLB
 size is unknown
To: Hyunwoo Kim <imv4bel@gmail.com>
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

Hi Hyunwoo,

On Mon, 27 Jul 2026 at 17:26, Hyunwoo Kim <imv4bel@gmail.com> wrote:
>
> ttl_to_size() returns 0 when no size is defined for the (granule, level)
> pair. That is the case for level 0 with 4kB pages, and for levels 0 and 1
> with 16kB and 64kB pages. For a VNCR pseudo-TLB this happens when the
> guest runs with SCTLR_EL2.M cleared, because __kvm_translate_va() returns
> success with wr->level left at S1_MMU_DISABLED, and that s8 value becomes
> level 1 as it goes through the u8 parameter of pgshift_level_to_ttl(). The
> size is then 0 if the guest has TCR_EL2.TG0 set to 16kB or 64kB.
>
> kvm_invalidate_vncr_ipa() and invalidate_vncr_va() feed that 0 straight
> into the range computation. When the size is 0 the alignment mask is 0 as
> well, both ends of the range collapse to 0, and the first comparison, the
> one that decides there is no overlap, is always true. As a result the
> pseudo-TLB is skipped whatever range the caller asks for, including the
> full IPA range passed by kvm_nested_s2_wp() and kvm_nested_s2_unmap().
>
> kvm_nested_s2_unmap() is called from kvm_unmap_gfn_range(). A guest that
> meets the above conditions therefore keeps its VNCR fixmap mapping across
> an MMU notifier that reclaims the page, and still holds a writable EL2
> alias of that page once it has been freed and reallocated for something
> else.
>
> compute_tlb_inval_range() and compute_s1_tlbi_range() already treat a size
> of 0 as "no size information" and fall back to a conservative value. Apply
> the same principle here, folding the range computation into a helper that
> reports an overlap when the size is unknown. This also removes the
> computation that was duplicated between the two functions. The result of
> the test is unchanged for a non-zero size.
>
> Fixes: ebb2d8fd81b8 ("KVM: arm64: nv: Fix incorrect VNCR invalidation range calculation")

The tag looks right to me. Before that commit the mask was "pa & (size
- 1)", so with a size of 0 both ends collapsed onto pa itself rather
than onto 0, and the full-range unmap still overlapped. So the missed
invalidation only starts at v6.17.


> Cc: stable@vger.kernel.org
> Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
> ---
>  arch/arm64/kvm/nested.c | 39 ++++++++++++++++++++-------------------
>  1 file changed, 20 insertions(+), 19 deletions(-)
>
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index dfb96edbdc43c6..3ac8789b458f39 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -985,6 +985,21 @@ static void invalidate_vncr(struct vncr_tlb *vt)
>                 clear_fixmap(vncr_fixmap(vt->cpu));
>  }
>
> +static bool vncr_tlb_intersects(struct vncr_tlb *vt, u64 addr,
> +                               u64 start, u64 end)
> +{
> +       u64 size, tlb_start, tlb_end;
> +
> +       size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift, vt->wr.level));
> +       if (!size)
> +               return true;

I was wondering if this deserves a short comment. It is the whole
point of the patch, and on its own an early return from a function
called vncr_tlb_intersects() reads as if an unknown size meant "no
overlap" rather than "assume the worst".

With that and with the caveat that I am not very familiar with this
code, but traced this while reviewing (and testing):

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba < fuad.tabba@linux.dev>

Cheers,
/fuad




> +
> +       tlb_start = addr & ~(size - 1);
> +       tlb_end = tlb_start + size;
> +
> +       return !(tlb_end <= start || tlb_start >= end);
> +}
> +
>  /*
>   * VNCR TLB invalidation occurs from MMU notifiers or TLBI instructions, and
>   * either can race against a vcpu not being onlined yet (no pseudo-TLB
> @@ -1008,14 +1023,7 @@ static void kvm_invalidate_vncr_ipa(struct kvm *kvm, u64 start, u64 end)
>                 return;
>
>         kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
> -               u64 ipa_start, ipa_end, ipa_size;
> -
> -               ipa_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
> -                                                           vt->wr.level));
> -               ipa_start = vt->wr.pa & ~(ipa_size - 1);
> -               ipa_end = ipa_start + ipa_size;
> -
> -               if (ipa_end <= start || ipa_start >= end)
> +               if (!vncr_tlb_intersects(vt, vt->wr.pa, start, end))
>                         continue;
>
>                 invalidate_vncr(vt);
> @@ -1045,28 +1053,21 @@ static void invalidate_vncr_va(struct kvm *kvm,
>         lockdep_assert_held_write(&kvm->mmu_lock);
>
>         kvm_for_each_vncr_tlb(i, vcpu, vt, kvm) {
> -               u64 va_start, va_end, va_size;
> -
> -               va_size = ttl_to_size(pgshift_level_to_ttl(vt->wi.pgshift,
> -                                                          vt->wr.level));
> -               va_start = vt->gva & ~(va_size - 1);
> -               va_end = va_start + va_size;
> -
>                 switch (scope->type) {
>                 case TLBI_ALL:
>                         break;
>
>                 case TLBI_VA:
> -                       if (va_end <= scope->va ||
> -                           va_start >= (scope->va + scope->size))
> +                       if (!vncr_tlb_intersects(vt, vt->gva, scope->va,
> +                                                scope->va + scope->size))
>                                 continue;
>                         if (vt->wr.nG && vt->wr.asid != scope->asid)
>                                 continue;
>                         break;
>
>                 case TLBI_VAA:
> -                       if (va_end <= scope->va ||
> -                           va_start >= (scope->va + scope->size))
> +                       if (!vncr_tlb_intersects(vt, vt->gva, scope->va,
> +                                                scope->va + scope->size))
>                                 continue;
>                         break;
>
> --
> 2.43.0
>
