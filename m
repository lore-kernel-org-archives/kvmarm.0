Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D420237E2EC
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 13:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222754; cv=none; b=UVVmkk9p3OY8t7OuGkIRKecV/fTvAmY6q+AWBvoB4NL5XSb3Z77nJlCYbBnmjtmpJ6VEonCUdWVg12LxfOrPXr6BO/OTfAd/EZfhTvpXQ2Olli/CmKNbtl12bbK+elAnEbMGtk+y8hBKfq2gAkLtFER7lsI3PkbZ32iZjWglKTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222754; c=relaxed/simple;
	bh=ovLBAvklLxZwC7Jq9ETpckjB1i/iju7Qpbi9FQGDqWQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FZvLYji8cgSqx2PNHnoTJt5qLfV9AK8fKIqfjBt1SpeXPxNrMsvoPkjiJ2b6a5XA0dj9SQt/Bj9mnrfy6AH6p81g/zi0QOaZReUFfKLtL02aF0DqONQ+R86o1O7JH3GF++eqSXHb6CNtcMw0wXc5Ao85igwgyW6iy1ti4wrdmxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MCZwoDif; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MCZwoDif"
X-Forwarded-Encrypted: i=1; AFNElJ9wu/xZc0qC/kt8SmfJI0FB/lfReVwew20KBq5Qicx6LkjnqtONso7kXP9cdKTt/hYtTAI+Z7c=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782222749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F77g4j7YjD5E5qC6B2ZdRa5uX5Miz2j/ZR1CSt9++g4=;
	b=MCZwoDifQsCEE9jKD0DQ5C2a+4+dqQPt7+qb2Sdtaqe5hTDmkXDKP2KEePgA/ZFEuQrMi0
	MWDSNMZSLX3rdFz8ZjoZ5kvSycXvgA+9NewODf9xpISKVc0L8TiCH+/wJrortlds9vRGR7
	hmqjwqGnD8S/4Pbp92k73YJqnfWrbG0=
X-Gm-Message-State: AOJu0YyHQLQHGT3gr3Oqr7A1hJN7vK3vEcxYhC2Ic73K54cVzmsBQNP5
	WoBBn8k6Jyqjps6ML5IImbixIHmeqFFrj6+GRfJK+7q5JYNOIhl80VD29ybjEIQ6+CoQsMcXjS8
	5g5qd5ENrUlhhBY7gK0+Hngq13zYXgOGp4uL4eNfn
X-Received: by 2002:a05:622a:411b:b0:519:df4f:6c93 with SMTP id
 d75a77b69052e-51a5255375emr10017941cf.20.1782222746042; Tue, 23 Jun 2026
 06:52:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260622190701.2039766-1-fuad.tabba@linux.dev>
 <20260622190701.2039766-2-fuad.tabba@linux.dev> <86tsqtqu9u.wl-maz@kernel.org>
In-Reply-To: <86tsqtqu9u.wl-maz@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 23 Jun 2026 14:51:49 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxn8W=KYqTeqs-ZTw-SBD9tH0zUz_O9rTHsq3M7ELXn_w@mail.gmail.com>
X-Gm-Features: AVVi8CebMVsOKX8XmdbtdzDxdkE6ig5bh0MmMzjJbv-f8yL8AKg1mgeDyXjOPkk
Message-ID: <CA+EHjTxn8W=KYqTeqs-ZTw-SBD9tH0zUz_O9rTHsq3M7ELXn_w@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Fix sign-extension of MMIO loads
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Christoffer Dall <christoffer.dall@linaro.org>, Victor Kamensky <victor.kamensky@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Tue, 23 Jun 2026 at 14:08, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 22 Jun 2026 20:07:00 +0100,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
> > A sign-extending load from MMIO (LDRSB, LDRSH, LDRSW) delivers a
> > zero-extended value: in kvm_handle_mmio_return(), vcpu_data_host_to_guest()
> > masks the data to the access width after sign-extension, stripping the
> > sign bits.
> >
> > Move vcpu_data_host_to_guest() ahead of sign-extension so the width mask
> > runs first. trace_kvm_mmio() moves with it and keeps reporting the raw
> > access-width data.
> >
> > Fixes: b30070862edbd ("ARM64: KVM: MMIO support BE host running LE code")
> > Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
> > ---
> >  arch/arm64/kvm/mmio.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmio.c b/arch/arm64/kvm/mmio.c
> > index e2285ed8c91de..d1c3a352d5a22 100644
> > --- a/arch/arm64/kvm/mmio.c
> > +++ b/arch/arm64/kvm/mmio.c
> > @@ -126,6 +126,10 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
> >               len = kvm_vcpu_dabt_get_as(vcpu);
> >               data = kvm_mmio_read_buf(run->mmio.data, len);
> >
> > +             trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
> > +                            &data);
> > +             data = vcpu_data_host_to_guest(vcpu, data, len);
>
> This helper is in charge of the endianness of the read from the
> guest's PoV. How can the sign-extension (which happens from the host's
> perspective) correctly work if it takes place after the byte swapping?
>
> To me, the real issue appears to be in the that helper, which swaps
> the data based on the size of the access instead of the width of the
> register.
>
> Or am I once more completely confused with the endianness crap?

Endianess always confuses me too :D

My reading of the ARM ARM is that the byte reversal is keyed on the access
size there too. It lives in Mem{size}, with the register width handled
separately by SignExtend(regsize):

    data = Mem[address, 2];        // byte-reversed by the access size, BE
    X[t] = SignExtend(data, regsize);

So vcpu_data_host_to_guest(..., len) swapping by len matches the Mem-side
reversal. Swapping by the register width would reorder bytes that were never
loaded. An LDRSH into Wt reads 2 bytes but would bswap 4: the halfword
reaches the helper as 0x0180 host-native, cpu_to_be32 turns it into
0x80010000 instead of the 0x8001 cpu_to_be16 gives, and it never sign-extends
to 0xffff8001.

If that reading holds, none of the helper's ops are individually wrong, and
the only bug was the order, with the sign-extend running before the swap and
the width mask then dropping it. But I've gone round in circles on endianness
before (to say the least), so please say if I've done it again.

Cheers,
/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
