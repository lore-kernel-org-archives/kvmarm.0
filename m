Received: from mta0.migadu.com (out-133.mta0.migadu.com [91.218.175.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36E03AF657
	for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 15:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787065958; cv=none; b=TWi8Iv1041y90eQGmZ8OKTwAPipK6DeW+exqWZgQEaVxLb5UUSggqzSNLMrshOXmHWgviLl2dQC/FjonmrO0+OvKtjRuUIMP1onqzQY9en+5hX2kGy9h0d8cynqBzI+QiBbmd1SD+maIYAlYBbLpTz3iPvdtpJ960yFEvGA06uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787065958; c=relaxed/simple;
	bh=GQGdBih8MZDO3/EZHlJE6IZMw4fTsT/Sh/mEEQx14NY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=khqX7BLpBSz0K3hGjwGXL2c7e+N3u4oLxorx908L7avHkj2jteZGJVLKh3cu1Q7EP5bJYaqIX07naNQOl4pxTdF5zFBJ317wVJaYht1ip6KY4OzFE0XlfKRJZXc0OKQDv7SPMXlUE4+ldAVeg7A0Q4ceme6f6LtdCz0YR0k59YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VeGpAyGd; arc=none smtp.client-ip=91.218.175.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VeGpAyGd"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=GQGdBih8MZDO3/EZHlJE6IZMw4fTsT/Sh/mEEQx14NY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787065953; v=1; x=1787670753;
 b=VeGpAyGdzVZgELH0hdG6uY9RfgewNAXk8USt8+l4wjStDp3v/EdvHB/hX5pJamrC7O/3njWi
 A+Sa9N4t9LfPPV6D7KdOhZ6dLpYTJ/bk1u/x0iE2kLXfySnhW+whkjh3YtwcjSOGNFVPM8hLT5f
 ZJTWGWumVbcUZ3RIT1EiPx8w=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f52.google.com (209.85.167.52)
	by smtp.migadu.com with ESMTPS id f3675f7a0f82f6c3;
	Tue, 18 Aug 2026 15:12:33 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so8337e87.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Aug 2026 08:12:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqL0avOeqRZEdty4/I/RZRUN+xvlQSGoKb3x2UqxLHzGC84JqIV8qRkBm0boO3MeNPT9QH0qP4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8wy/pP6begYOsSJ1WISX27kiJLqlCm+onA2xP5nt4cKCKG/pC
	xUnwqUrU6OonwvKOeoX1cF4+qRdP8W35BPD6j/hC00u7cr4tRwGfZ4lCMICzwzYB37+B4gJKZJI
	GOaVEP7qcETkyUW651yMWgtyqKburJ7mYEfn5g/6N
X-Received: by 2002:a05:6512:3d87:b0:5ae:b918:79d5 with SMTP id
 2adb3069b0e04-5b471eaf57amr264250e87.2.1787065947956; Tue, 18 Aug 2026
 08:12:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-8-vdonnefort@google.com> <20260731145215.A1AB01F000E9@smtp.kernel.org>
In-Reply-To: <20260731145215.A1AB01F000E9@smtp.kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 18 Aug 2026 16:11:51 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyfunbnF1RCVxcwQsK+LC79iPSQx4QHZ0SobjRO5-OuNg@mail.gmail.com>
X-Gm-Features: AcwNN1Uy5qshM-8JOqqf01FfhdyLUVim0o9S0YPUL-CXvHFFlix1yMiqxl8Rkws
Message-ID: <CA+EHjTyfunbnF1RCVxcwQsK+LC79iPSQx4QHZ0SobjRO5-OuNg@mail.gmail.com>
Subject: Re: [PATCH v4 07/17] KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC request
To: sashiko-reviews@lists.linux.dev
Cc: Vincent Donnefort <vdonnefort@google.com>, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 31 Jul 2026 at 16:08, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] The __pkvm_hyp_topup hypercall is incorrectly placed in the al=
ways-on band, making it reachable in standard nVHE mode.
> --
>
> --- Patch [7]: [PATCH v4 07/17] KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC re=
quest ---
> commit c7805b75faa5ebe4c309f41eb0346f2ae0a468dd
> Author: Vincent Donnefort <vdonnefort@google.com>
>
> KVM: arm64: Add PKVM_HYP_REQ_HYP_ALLOC request
>
> Introduce a new pkvm_hyp_request type asking the host to top up the pKVM
> heap allocator.
>
> > diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/=
kvm_asm.h
> > index 043495f7fc78b..b77acfd7d1c8a 100644
> > --- a/arch/arm64/include/asm/kvm_asm.h
> > +++ b/arch/arm64/include/asm/kvm_asm.h
> > @@ -89,6 +89,7 @@ enum __kvm_host_smccc_func {
> >       __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
> >       __KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
> >       __KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
> > +     __KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup,
> >
> >       MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
>
> [Severity: Medium]
> Should __KVM_HOST_SMCCC_FUNC___pkvm_hyp_topup be placed after the
> __KVM_HOST_SMCCC_FUNC_PKVM_ONLY marker instead of before it?
>
> Placing it here in the always-on band makes it reachable in standard
> nVHE mode or before pKVM is finalized. If the host kernel executes this
> hypercall during those phases, it could attempt to invoke
> hyp_alloc_topup() against uninitialized pKVM heap structures, potentially
> causing a hypervisor panic.

It does not panic. __host_check_page_state_range() calls
check_range_allowed_memory() before it touches the vmemmap, and that
returns -EPERM because hyp_memblock_nr is zero outside protected mode.

No, it should not move. __pkvm_hyp_topup is in the always-on band
deliberately, so the host can top the heap up before deprivilege.

/fuad

>
> [ ... ]
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index d3c69de698f48..439b91fc8aecf 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> [ ... ]
> > @@ -740,6 +765,7 @@ static const hcall_t host_hcall[] =3D {
> >       HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
> >       HANDLE_FUNC(__vgic_v5_save_apr),
> >       HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
> > +     HANDLE_FUNC(__pkvm_hyp_topup),
> >
> >       HANDLE_FUNC(__pkvm_host_share_hyp),
> >       HANDLE_FUNC(__pkvm_host_unshare_hyp),
>
> [Severity: Medium]
> Does this handler registration also need to be moved to mirror the
> enum placement in the finalized-only band?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731143541.95=
6291-1-vdonnefort@google.com?part=3D7
>
