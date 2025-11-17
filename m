Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC5DE32B98A
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 11:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763379358; cv=none; b=Nb/XOgpuH5eYuTBZbJi9lLHXxINgiAkh3WBRRr9FEU2P/zBvYPX5Z+J1Bfrts3WfNQNAV/WVmOh6Gg+YeCtCXjs0nh5Hmkis2HdUV91tA34OtFHG8mDnSs7wIEfukCt4vrIUwK+5JgRvY+UuLDGP+p4/DA/1vgO8LZE2nnLS7Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763379358; c=relaxed/simple;
	bh=FiVg8HIoSq1vAMera7LlyWAWAwVwtwqzruYByVnF+ss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V2wTmFCXnjz5K90nblGGoreGEPxkAHS35pUtPtWPyRmGUgjK1o3GRYzh6z3qZl4HdB6/zqC3NFOWTCgNIq/pXT+GdSOvgqdEtDp15Ygu0DuvXlkG/trncKbU4Z7TEjdkRfFhTbIli6SuTR2QPoUwJ1is9YEc+MdiC7sVXTSFejs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aOsrJoRg; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aOsrJoRg"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ee147baf7bso426751cf.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 03:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763379355; x=1763984155; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=InxzUv4fZ1uU4fFpdnx0a5dxJKeuOiNcfcnGKmmDKis=;
        b=aOsrJoRg438PvGfUG+HwziQ4wv7kroz+Vd6E9k5D3teezAgE4UVOCwkxBIU9mEZAf2
         bNvbHQqqsZiKPtjZqRrvd0Bq1EkPawFSyzMjq8UZ7Y/i7ltkoElJzK8Hd3G0T+snsbjs
         /DRKAR1roDWXorhb+7jEvLAn/n1qPcdHnP5wy5yriY8VhmCew4gkFizj02ZID3jjfTkt
         aqoovJRaEdTS/yi/zB2DwfjJcNuAbUyTVRdXu9UH3z5fpOu3CLiwVrulgGkyXLlqIemn
         M7UiWTzokPVuwoI/74ZpNx/qhBu8r3DPsSRb2GDg2YeId/iDL/g3A5A5695O7HcmPLCz
         Ud+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763379355; x=1763984155;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=InxzUv4fZ1uU4fFpdnx0a5dxJKeuOiNcfcnGKmmDKis=;
        b=tabhyjYCM3PSBLiibtlFEYxfjD9ereJ/19UAo1h09LievBILltw/FtzC0T5T95sb14
         VMNMwiT3E2hwduYbDD/4yh/OnCNicinK2qGoycRDtbQJ/XHOXa9Lm9cec3pOlxa+64MR
         /uNCGLFOcfDNbP1Vjoj8QcImRuMjMk9+WM0RyZYV/K3YB844Ny/6LPFuSim37K2BM/n+
         CuT348wE2dJ8Gw/ZW3n436KCNzrnVYEswgNs+Tgp7gD8oliFeAdKdAOsQUVG+5lJJcDc
         FBkhbyhUZiuDyXpfR8weZPC1D8AgXLuMiemHP/BV5H/SKRk1TWEOq++bLrDrIr9uZxUT
         GbHA==
X-Gm-Message-State: AOJu0Yxf8kYAw+sYgmH5q4Dol2UQObOT0uPsLFsmK75VUV+LT8+ZgEvx
	x0sd8arMARjlC2I1Cn8kBNmcdT45CmVuIPyciUg4LBgpplHIJylaj07WE9InsxZp4asQvmzvJl5
	fetNhFW0sXDuMC2/0AmoMcXsuKcgsiru5uAwElTIV
X-Gm-Gg: ASbGncsNNmxKM7zqHpo1f+ka90zu+ZU4acZ9MzwKYZ6TM7USC/z+PBb1v92SLxqE98m
	RMDVgzLOOOBqjYVO8Xx/He4/dLfFEQy1NpPp1YANV6Klu69O69ZIhtKj1XVmvFUz9aW29+zBqQz
	RIwSeHXWLZMNx28pGumjMmKp/2HJEYsjp0G6brOC31o9STsMtmMjBNM5FZJk0iMPSBQpZFlVjZf
	WFSC7NEOkyzOk4H/lsHqAAHAYvn316PSiKrpcK3PDIzzjy5acmipViDu2FkhYGUSZFZ3++FVhXX
	CslaPw==
X-Google-Smtp-Source: AGHT+IEeSiW3i7KxR/7PtZwLbRJe4Rt/AuAzXIflTZcma7G9RYj/Byd8sqTWf75xRzlbievXcmfG+TwcqMMRZMTyoY0=
X-Received: by 2002:ac8:7fcd:0:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-4ee02b0dba6mr11656171cf.18.1763379355279; Mon, 17 Nov 2025
 03:35:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-6-maz@kernel.org>
In-Reply-To: <20251117091527.1119213-6-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 11:35:18 +0000
X-Gm-Features: AWmQ_bnrhZokZgmcow0lXNWcucVmFJ-Nro-VXQIq3EmXDZs9hFHaUagkAg0JMFQ
Message-ID: <CA+EHjTxVr7uk8Ofhb2VHjDw+LfC4ZSz4dDun5+xLcnRQy5AKaQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Mon, 17 Nov 2025 at 09:22, Marc Zyngier <maz@kernel.org> wrote:
>
> FEAT_NV2 is pretty terrible for anything that tries to enforce immediate
> effects, and writing to ICH_HCR_EL2 in the hope to disable a maintenance
> interrupt is vain. This only hits memory, and the guest hasn't cleared
> anything -- the MI will fire.
>
> For example, running the vgic_irq test under NV results in about 800
> maintenance interrupts being actually handled by the L1 guest,
> when none were expected.
>
> As a cheap workaround, read back ICH_MISR_EL2 after writing 0 to
> ICH_HCR_EL2. This is very cheap on real HW, and causes a trap to
> the host in NV, giving it the opportunity to retire the pending
> MI. With this, the above test tuns to completion without any MI
> being actually handled.

nit: tuns->runs


>
> Yes, this is really poor...
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/vgic-v3-sr.c      | 7 +++++++
>  arch/arm64/kvm/vgic/vgic-v3-nested.c | 6 ++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> index 99342c13e1794..f503cf01ac82c 100644
> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> @@ -244,6 +244,13 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
>         }
>
>         write_gicreg(0, ICH_HCR_EL2);
> +
> +       /*
> +        * Hack alert: On NV, this results in a trap so that the above
> +        * write actually takes effect...
> +        */
> +       isb();
> +       read_gicreg(ICH_MISR_EL2);
>  }

nit: is it worth gating this with "ARM64_HAS_NESTED_VIRT"?

Otherwise,
Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad




>  void __vgic_v3_restore_state(struct vgic_v3_cpu_if *cpu_if)
> diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> index 40f7a37e0685c..d6797632157a0 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
> @@ -94,8 +94,10 @@ static int lr_map_idx_to_shadow_idx(struct shadow_if *shadow_if, int idx)
>   *
>   * - because most of the ICH_*_EL2 registers live in the VNCR page, the
>   *   quality of emulation is poor: L1 can setup the vgic so that an MI would
> - *   immediately fire, and not observe anything until the next exit. Trying
> - *   to read ICH_MISR_EL2 would do the trick, for example.
> + *   immediately fire, and not observe anything until the next exit.
> + *   Similarly, a pending MI is not immediately disabled by clearing
> + *   ICH_HCR_EL2.En. Trying to read ICH_MISR_EL2 would do the trick, for
> + *   example.
>   *
>   * System register emulation:
>   *
> --
> 2.47.3
>
>
