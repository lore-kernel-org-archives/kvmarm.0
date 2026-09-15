Received: from mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F5236B06A
	for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 14:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481564; cv=none; b=qWNQliFyMhh03XdGul9a2SvMvTYC5/ikTNSo59UpX+2CHgGZ5TyNjox8E4OAd/qv8x7VQc/mrIe9Dc+4/JBlCBfco6/Y1ga0PteCvUyhsK36/gtcrPoTEfX1QpkBRnDgDDHyaFewhs3lS2uOh2tZXxYYeMOtM5cOBKXPhTrlxKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481564; c=relaxed/simple;
	bh=3G0O+OUF5QFvnfAby8EwEl11RBiKQK5gk892VXgZWD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EnTCA9jJTIDgJFJXDw6iAQoyEfLe+HquNHF4ur3sJzFnwR2un3y3Me++tWOGfk/1SiRiNOOaY3Ikhpe/IOiCWQTY96Ai/hcjIPWdgxLV6K3S+8fT4tEBDyNL4ROPu75CAWuZ7BZ7XDxrcxUABQMjaEr6DjJAC500dv2yszsuuVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CZdBG8e4; arc=none smtp.client-ip=91.218.175.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CZdBG8e4"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=3G0O+OUF5QFvnfAby8EwEl11RBiKQK5gk892VXgZWD0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789481560; v=1; x=1790086360;
 b=CZdBG8e4P22GKwujkr2QHNPwhb/pRhKTOMeCen+2FlulC+Kcoffv3RHY+uuzVN3aVNfCliJ2
 FTov7sbgZw+PA8p8yzBplzLc3cYR6wNI+4lzlZ02eaR+9lWbY2TvWrJutFcwvs0yKTPCkKzr7RO
 tzhfjnOu7X7yd7RwPvkRErp4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 010d588f9ff8e5f4;
	Tue, 15 Sep 2026 14:12:40 +0000
X-Mizu-Trace-ID: 010d588f9ff8e5f4
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b4a0b384b7so298e87.0
        for <kvmarm@lists.linux.dev>; Tue, 15 Sep 2026 07:12:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzVhybLpkVzWxzyKPI2qAy85f7BiO//xTOcjGDmR5faM337Y0JFEnKPuu7aJeUrzLvrdOdtUBY=@lists.linux.dev
X-Gm-Message-State: AFuF++lKf7kLMXhvKotJgR5UirM8Q97YGDCRS5wiWKcYnBasX1nb5LSt
	RFOGWSjRiYXbbQf6jzHuslBy6lMWj0DPTqXlVK+S92khGtahftPTe0ShBC3/g4evALJkrP/atxJ
	Cw5woEnU1c5RMB3gBbUkeIyVTeXzkFgkP8QyZJ2ed
X-Received: by 2002:a05:6512:3dac:b0:5b1:ca0b:25d2 with SMTP id
 2adb3069b0e04-5b8b2d0db8bmr195652e87.4.1789481559798; Tue, 15 Sep 2026
 07:12:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915123846.2317931-1-fuad.tabba@linux.dev>
 <20260915123846.2317931-2-fuad.tabba@linux.dev> <86v78662a6.wl-maz@kernel.org>
In-Reply-To: <86v78662a6.wl-maz@kernel.org>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Tue, 15 Sep 2026 15:12:03 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxUTOj4D6Y-mjA6Wv+D-GWP1SaCBNgH_Ni=CQ3Y0zAK1g@mail.gmail.com>
X-Gm-Features: AcwNN1WrZ2vlMfsvR2ger9LO52Sjk_Eil6ga-Qs09jtEG-4giDpAv8q3LKgSy9Q
Message-ID: <CA+EHjTxUTOj4D6Y-mjA6Wv+D-GWP1SaCBNgH_Ni=CQ3Y0zAK1g@mail.gmail.com>
Subject: Re: [PATCH 1/7] KVM: arm64: Reject the GICv5 CPU interface hypercalls
 under pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	catalin.marinas@arm.com, will@kernel.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, vdonnefort@google.com, qperret@google.com, 
	Sascha.Bischoff@arm.com, steven.price@arm.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Sept 2026 at 15:02, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 15 Sep 2026 13:38:40 +0100,
> Fuad Tabba <fuad.tabba@linux.dev> wrote:
> >
>
> [...]
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index 9a3b92e626adb..7c939baf9c1ba 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -911,6 +911,8 @@ static const hcall_t host_hcall[] = {
> >       HANDLE_FUNC(__kvm_enable_ssbs),
> >       HANDLE_FUNC(__vgic_v3_init_lrs),
> >       HANDLE_FUNC(__vgic_v3_get_gic_config),
> > +     HANDLE_FUNC(__vgic_v5_save_apr),
> > +     HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
> >       HANDLE_FUNC(__pkvm_prot_finalize),
> >
> >       HANDLE_FUNC(__kvm_adjust_pc),
> > @@ -932,8 +934,6 @@ static const hcall_t host_hcall[] = {
> >       HANDLE_FUNC(__tracing_write_event),
> >       HANDLE_FUNC(__vgic_v3_save_aprs),
> >       HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
> > -     HANDLE_FUNC(__vgic_v5_save_apr),
> > -     HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
> >
> >       HANDLE_FUNC(__pkvm_host_share_hyp),
> >       HANDLE_FUNC(__pkvm_host_unshare_hyp),
>
> Why moving things in the array? The whole point of HANDLE_FUNC() is to
> abstract the position.

It's only cosmetic. The array is in the same order as the enum today,
entry for entry.

Cheers,
/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
