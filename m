Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771923019D2;
	Tue, 16 Sep 2025 10:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758017788; cv=none; b=AVMSiINgkOKdUsxYwxugoFqZPoitoIgs3Yuyey0Muq3njDzDmys78saAIMz8S86KKNcH9M8NK6a6K2VCMUIng4vj3Ylkq16jOFFYJl8ZM/gYz4qSwT40lB+iUVZD4Gijy5lcG20Lxsc98XliFIinswZ1UzZm0E3iUrENkAHJOOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758017788; c=relaxed/simple;
	bh=WnhgxGMR7wJ9/CFjtwaKsCL8RypUwh3juwnR8dXWu2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WxcFsRhbEtj3IYKcD5dWMhUe0pHnkS+LB5ki5iJdhGblwtsME+C/DCO/cEygnPlLB/Dy5wuiQh/oFNoKld3BQTpQmql0/nLbmqs0gclsBpg30ZMGft9tX3DWNRK0rwLSvuVFG6Zs+M28y8mawmMVXLTiAV6/pUum0z5ou7veVz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dH5md1Y+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dH5md1Y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D2BC4CEEB;
	Tue, 16 Sep 2025 10:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758017787;
	bh=WnhgxGMR7wJ9/CFjtwaKsCL8RypUwh3juwnR8dXWu2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dH5md1Y+HyrlWy7S+14VcOF8a9xKs+sWic8b1RoHGMfHcn3lMhEzwW/LGoK/j/wo4
	 QYrDYop0aEPUCZpiD47VNWY7FxIxoR8b0SYND55zDBX+AsbJnKjBj2VpTeJdNzz1vQ
	 l9QSN77tfPLONkwS7P65hh9H9VdPZVwtJje+28k5+0UkCcFpwY0tBohuLaRAz49XiC
	 nA0we+gO5Poj9Jq7Z1D66qZ+0TLQze/lY1D7d7CznrXJvP8nROKd+I7O+EB6Yjqz4T
	 YNv6JOGcFqV7GqsplRS2Kqi8/6y01j1TSVaGe84BbxWkCuyZ27V0PSCaMdZ6vdh0KP
	 Ulb5X8XvPIioA==
Date: Tue, 16 Sep 2025 11:16:21 +0100
From: Will Deacon <will@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMk49UZ1EiUu3-Y2@willie-the-truck>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
 <aMh4q4-xAPHnaOul@willie-the-truck>
 <aMkLb6jPiSbzeRWL@arm.com>
 <aMk1qxS3htyaTgEQ@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMk1qxS3htyaTgEQ@e129823.arm.com>

On Tue, Sep 16, 2025 at 11:02:19AM +0100, Yeoreum Yun wrote:
> Hi,
> > On Mon, Sep 15, 2025 at 09:35:55PM +0100, Will Deacon wrote:
> > > On Mon, Sep 15, 2025 at 08:40:33PM +0100, Catalin Marinas wrote:
> > > > On Mon, Sep 15, 2025 at 11:32:39AM +0100, Yeoreum Yun wrote:
> > > > > So I think it would be better to keep the current LLSC implementation
> > > > > in LSUI.
> > > >
> > > > I think the code would look simpler with LL/SC but you can give it a try
> > > > and post the code sample here (not in a new series).
> > >
> > > If you stick the cas*t instruction in its own helper say, cmpxchg_user(),
> > > then you can do all the shifting/masking in C and I don't reckon it's
> > > that bad. It means we (a) get rid of exclusives, which is the whole
> > > point of this and (b) don't have to mess around with PAN.
> >
> > We get rid of PAN toggling already since FEAT_LSUI introduces
> > LDTXR/STTXR. But, I'm all for CAS if it doesn't look too bad. Easier
> > I think if we do a get_user() of a u64 and combine it with the futex u32
> > while taking care of CPU endianness. All in a loop. Hopefully the
> > compiler is smart enough to reduce masking/or'ing to fewer instructions.
> >
> 
> Sorry for my wrong previous email.
> 
> Here is what i intened with CAS operation:
> 
> diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> index 1d6d9f856ac5..0aeda7ced2c0 100644
> --- a/arch/arm64/include/asm/futex.h
> +++ b/arch/arm64/include/asm/futex.h
> @@ -126,6 +126,60 @@ LSUI_FUTEX_ATOMIC_OP(or, ldtset, al)
>  LSUI_FUTEX_ATOMIC_OP(andnot, ldtclr, al)
>  LSUI_FUTEX_ATOMIC_OP(set, swpt, al)
> 
> +
> +#define LSUI_CMPXCHG_HELPER(suffix, start_bit)                                 \
> +static __always_inline int                                                     \
> +__lsui_cmpxchg_helper_##suffix(u64 __user *uaddr, u32 oldval, u32 newval)      \
> +{                                                                              \
> +       int ret = 0;                                                            \
> +       u64 oval, nval, tmp;                                                    \
> +                                                                               \
> +       asm volatile("//__lsui_cmpxchg_helper_" #suffix "\n"                    \
> +       __LSUI_PREAMBLE                                                         \
> +"      prfm    pstl1strm, %2\n"                                                \
> +"1:    ldtr    %x1, %2\n"                                                      \
> +"      mov     %x3, %x1\n"                                                     \
> +"      bfi     %x1, %x5, #" #start_bit ", #32\n"                               \
> +"      bfi     %x3, %x6, #" #start_bit ", #32\n"                               \
> +"      mov     %x4, %x1\n"                                                     \
> +"2:    caslt   %x1, %x3, %2\n"                                                 \
> +"      sub     %x1, %x1, %x4\n"                                                \
> +"      cbz     %x1, 3f\n"                                                      \
> +"      mov     %w0, %w7\n"                                                     \
> +"3:\n"                                                                         \
> +"      dmb     ish\n"                                                          \
> +"4:\n"                                                                         \
> +       _ASM_EXTABLE_UACCESS_ERR(1b, 4b, %w0)                                   \
> +       _ASM_EXTABLE_UACCESS_ERR(2b, 4b, %w0)                                   \
> +       : "+r" (ret), "=&r" (oval), "+Q" (*uaddr), "=&r" (nval), "=&r" (tmp)    \
> +       : "r" (oldval), "r" (newval), "Ir" (-EAGAIN)                            \
> +       : "memory");                                                            \

The vast majority of this can be written in C.

Will
