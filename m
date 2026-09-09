Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7503956854A
	for <kvmarm@lists.linux.dev>; Wed,  9 Sep 2026 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788968392; cv=none; b=TP/dxvznitxxa7o172k7dVJ5YXKBGV1G8JH/cZdur6Bhc5r53DOCycRAH6pJ2PVvCpDHPk6nC9IVu79i8j+KAc+qze0anCgIkOI9J5oaG1XgD5/Iv6GGPP3YVVbqkOD3xsvrIfMmcDjFh+ysllQNBCeT8ezNnxq2cLNtV5xRRRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788968392; c=relaxed/simple;
	bh=fzj4Ws8lKIWrjEiyGIpoIDsUvXAXaL99aEWk2VGWV7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QLlsMgH1X1Ti3imGEmwmZLXbQzRrWypAHNy82bW4v2Yuxd5UYaGaKQM6GGQUbD/hgb8h6g4oh3eCY7WbQfmfn2eJg+SKKE2BkC1Q9ObP67pkFUk21UKNE7bHPMq9MwEqHP8AHzIzjCiL8bbJ+r90+dxe2s9LX/CUdK1YKQ8lmUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wPTc+nN/; arc=none smtp.client-ip=91.218.175.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wPTc+nN/"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=fzj4Ws8lKIWrjEiyGIpoIDsUvXAXaL99aEWk2VGWV7s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788968385; v=1; x=1789573185;
 b=wPTc+nN/nl06LlR+NiotyVnLEER9TMXamDiXGMYp783LpOIN/C4AHmZaYpMIi1Ah3qM8m+TH
 sa/r1pD+MaxitH4KLd8/xGzUhBwDk4XIvNsC8afflB4x2NdbezWoqWRiEgh+VP2AqodSBDE7J7g
 GAcTl3y/YR0uq+GCVUrLOzbM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id c7978c46f7c60e04;
	Wed, 09 Sep 2026 15:39:45 +0000
X-Mizu-Trace-ID: c7978c46f7c60e04
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so8769e87.0
        for <kvmarm@lists.linux.dev>; Wed, 09 Sep 2026 08:39:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwnrUoajbLTqSzs3O/2mq38sjbhgVxseYWFU1+XYsdhyslkS2qEkjrUI+B5bD/ZqlfHFf38R0s=@lists.linux.dev
X-Gm-Message-State: AFuF++mQSAkKJmabIj/isc4YQ8ftpDgXVIeqvh9v9dqRlbApL1VjgcjZ
	0LmGfkJymVKMT7Uqakwn7kkz01FZEsl1rtW6yLNiku+f/fIeOewL+APIpzLtpNSXPLEOhpeb+xB
	hjOGmL5BnenKV/YVt5QKWgcHGV3dy05cMekjg/x0i
X-Received: by 2002:a05:6512:1296:b0:5ae:cf5f:4a88 with SMTP id
 2adb3069b0e04-5b764bb8a14mr142455e87.8.1788968380386; Wed, 09 Sep 2026
 08:39:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com> <20260807164322.2970811-3-sebastianene@google.com>
In-Reply-To: <20260807164322.2970811-3-sebastianene@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 9 Sep 2026 16:39:03 +0100
X-Gmail-Original-Message-ID: <CA+EHjTw8H90YZmwbVu6gwe+2+D6QsDLybKcncLcCFSsK4kT+gw@mail.gmail.com>
X-Gm-Features: AcwNN1Xn11LM3S-N1a2DBr7wA2T25hY8d1olPDXuf0s4eEIGVNgdvX4H2BSTCmw
Message-ID: <CA+EHjTw8H90YZmwbVu6gwe+2+D6QsDLybKcncLcCFSsK4kT+gw@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] KVM: arm64: Donate MMIO to the hypervisor
To: Sebastian Ene <sebastianene@google.com>, Mostafa Saleh <smostafa@google.com>
Cc: catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com, 
	maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org, 
	kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, seiden@linux.ibm.com, 
	tglx@kernel.org, vdonnefort@google.com, vladimir.murzin@arm.com, 
	yuzenghui@huawei.com, zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Mostaf, Seb,

On Fri, 7 Aug 2026 at 17:43, Sebastian Ene <sebastianene@google.com> wrote:
>
> From: Mostafa Saleh <smostafa@google.com>
...
> +int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size)
> +{
...
> +       /*
> +        * We set HYP as the owner of the MMIO pages in the host stage-2, for:
> +        * - host aborts: host_stage2_adjust_range() would fail for invalid non zero PTEs.
> +        * - recycle under memory pressure: host_stage2_unmap_dev_all() would call
> +        *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid ptes (counted).
> +        * - other MMIO donation: Would fail as we check that the PTE is valid or empty.
> +        */
> +       ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
> +                             addr, size, &host_s2_pool,
> +                             KVM_HOST_INVALID_PTE_TYPE_DONATION,
> +                             FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));

Before this patch the hyp linear map held nothing but memory, and this
adds the first device mapping to it. That places it outside
`fix_host_ownership()`, whose scope is the memblock list, so nothing
at init verifies the ownership. It's correct as written: the donation
writes the host stage-2 annotation itself.

This has already gone wrong once with the hyp stacks. The fix [1] adds
`pkvm_check_host_ownership()` over the private range, which fails init
on a leaf that isn't hyp-owned. I'd move this mapping there rather
than leave it outside any ownership walk.

...

> +int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size)
> +{
...
> +               virt = __hyp_va(addr + offset);
> +               if (kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)virt, PAGE_SIZE) != PAGE_SIZE)
> +                       goto err_with_unmap;

Sashiko is right, even though this is benign for now. `ret` is still 0
from the `kvm_pgtable_get_leaf()` above, so a short unmap runs the
rollback and returns success. Could it set an error before the goto?

...

> @@ -1161,13 +1161,12 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>         kvm_pte_t *childp = NULL;
>         bool need_flush = false;
>
> -       if (!kvm_pte_valid(ctx->old)) {
> -               if (stage2_pte_is_counted(ctx->old)) {
> -                       kvm_clear_pte(ctx->ptep);
> -                       mm_ops->put_page(ctx->ptep);
> -               }
> +       /*
> +        * That also ignores stage2_pte_is_counted() instead of clearing
> +        * the PTE as the MMIO can be owned by the hypervisor.
> +        */
> +       if (!kvm_pte_valid(ctx->old))
>                 return 0;
> -       }

This changes `kvm_pgtable_stage2_unmap()` for every caller, for a
reason specific to `host_stage2_unmap_dev_all()`. The others are
`__unmap_stage2_range()` and the two guest unmaps in `mem_protect.c`;
as far as I can tell none is affected today, but
`stage2_pte_is_counted()`'s comment still describes the old behaviour.

What's changing isn't what the walk does, it's what counts as a
counted entry, and that isn't the same question for the host stage-2
as for a guest's. Could that be stated at the call site instead?

I couldn't work out what "That" refers to in the new comment.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20260908110713.1540304-1-fuad.tabba@linux.dev/

>
>         if (kvm_pte_table(ctx->old, ctx->level)) {
>                 childp = kvm_pte_follow(ctx->old, mm_ops);
> --
> 2.55.0.654.g21b8a5bc05-goog
>
