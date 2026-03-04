Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF3B2F6565
	for <kvmarm@lists.linux.dev>; Wed,  4 Mar 2026 00:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772584771; cv=none; b=EiInIuwn4ILmKCNQJ+fGeYJOtEu6D2ehb/tHHowhJqS2MU8NR5bu7dghvDMGTbQgZyUE/qCfIOraSKWkZ7ia0MbTWtNW7T5O3fq7HFY1LRJ5H+YYnfg2tvmxpng4nr6qpjJgu8YD8oee95KdVsE5d1YSRAg1sLi1oH45ibkJ/34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772584771; c=relaxed/simple;
	bh=T2A9wJKs59MrLQGleN+1xCvv/eKLPAOAaicX81EOd7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nwD0f/tA8BddgkVgKFoXVSZojuhbpuHbUGi4FW5zGVfHJVda9InkyzDAHCbW4l42gOB93Jf+kwkUEHr6E6ReWUOGFFNqL5zrjV00RT0x7ssWb6vqczhv5n9AvNIxQT9WMOCcBhflS9j4s6Thp+IMuvrfBI0nSxzn3BdW7Wy+Z24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uSxRViHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uSxRViHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B69C2BCB1
	for <kvmarm@lists.linux.dev>; Wed,  4 Mar 2026 00:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772584771;
	bh=T2A9wJKs59MrLQGleN+1xCvv/eKLPAOAaicX81EOd7c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uSxRViHS6MiVpBNGaXGiOQEO8urRfdmg9pVohWKyK/WZT2dktxESz+HGRMfYvfwR+
	 ZCBkA7rtQU55uZO/2MC3DjXd+ck8Ms7fbCuizl8cHgSO7bZDcMo6ztdGvVGhgzQ7ja
	 ehf6rAUpF6/QHiH6IeRAmOqijyTlryniMDVJmDypb30RMh0DyrkSi9/0woMgumXw3e
	 sYftiapQvhZnRtabDw+jVO1LjBdnvrQfifiT/vPhN5kpWPLPtZMPqb+LCun/QZRrmY
	 4ThJGHHreeky8OEnX97ekfA5XL+IGPcp3vYE2VkjjEhDRrvepw0ibXK1J/KAGrzq6a
	 cTyIhNbT46XOA==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-7947cf097c1so60503257b3.2
        for <kvmarm@lists.linux.dev>; Tue, 03 Mar 2026 16:39:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWYLfuKyKlQY0Y87sAXdqIIcJ5Tt7yReOzTYWXoiIiBwVkU+YX3OszrvNyKDsNt76d2Z8IsOyo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6q5oMi78gqlt6o0CgS1SUZMLx57CCm5vv9ka/NWGVbtQnn66x
	dKdASfaIrzsHN0IPsjU+FLPrVPeATjYmWxYVY03A1aDoQOCftVgPDTWF+U5WfJEjzbMwlRvcpML
	hWFa2ALosmQnqLfbtWMp/LUFEGuQeQVE=
X-Received: by 2002:a05:690c:6c06:b0:794:d3e6:a503 with SMTP id
 00721157ae682-798c6bdebe7mr2222457b3.24.1772584770663; Tue, 03 Mar 2026
 16:39:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260303-aarch64-clear-pages-v1-1-ad0c3ee9a555@kernel.org> <aab0SvA0dU0R0pnl@willie-the-truck>
In-Reply-To: <aab0SvA0dU0R0pnl@willie-the-truck>
From: Linus Walleij <linusw@kernel.org>
Date: Wed, 4 Mar 2026 01:39:19 +0100
X-Gmail-Original-Message-ID: <CAD++jLnhe_k1-eU90KjOi_Aj57S53a9GJoCZ-LTE0fz-TVSqvg@mail.gmail.com>
X-Gm-Features: AaiRm51SPIg6uwJI8TiwfWI3bFu7gsbqG0yTxInpwVnNjmqUrCUushkqAuiNwSM
Message-ID: <CAD++jLnhe_k1-eU90KjOi_Aj57S53a9GJoCZ-LTE0fz-TVSqvg@mail.gmail.com>
Subject: Re: [PATCH] arm64: Implement clear_pages()
To: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Ankur Arora <ankur.a.arora@oracle.com>, 
	David Hildenbrand <david@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, James Clark <james.clark2@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 3, 2026 at 3:46=E2=80=AFPM Will Deacon <will@kernel.org> wrote:

> > +extern void clear_pages_asm(void *addr, unsigned int nbytes);
> > +
> > +static inline void clear_pages(void *addr, unsigned int npages)
> > +{
> > +     clear_pages_asm(addr, npages * PAGE_SIZE);
> > +}
> > +#define clear_pages clear_pages
>
> Hmm. From what I can tell, this just turns a branch in C code into a
> branch in assembly, so it's hard to correlate that meaningfully with
> the performance improvement you see.

I think what I see is the effect of #define clear_pages clear_pages.

Because without that <linux/mm.h> open codes:

#ifndef clear_pages
(...)
static inline void clear_pages(void *addr, unsigned int npages)
{
        do {
                clear_page(addr);
                addr +=3D PAGE_SIZE;
        } while (--npages);
}
#endif

So for clearing anything multi-page we get an outer loop
and an inner loop inside clear_page(), but with clear_pages()
implemented there is no outer loop, instead the total bytes is
computed first (not one page at a time) and then there is a
single loop.

> If we have CPUs that are this sensitive to branches, perhaps we'd be
> better off taking the opposite approach and moving more code into C
> so that the compiler can optimise the control flow for us?

Hm! That would be to create a default clear_page() in
<linux/mm.h> and simply delete the existing lib/clear_page.S
and let the default kick in.

Right now every arch is implementing it custom.
Maybe for no reason in some cases, I could try it!

I doubt the compiler would emit this part though:

#ifdef CONFIG_AS_HAS_MOPS
(...)
alternative_else_nop_endif
        setpn   [x0]!, x1!, xzr
        setmn   [x0]!, x1!, xzr
        seten   [x0]!, x1!, xzr
        ret

Three instructions to clear all pages. But maybe that is not good
if this is a gigabyte, and the per-page loop provides a good breather
preemption point in that case, and then we just shouldn't touch
anything.

Yours,
Linus Walleij
