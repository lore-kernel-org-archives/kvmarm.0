Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331883FE67A
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 11:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783338836; cv=none; b=KO0nrArBDH5cunQmJOBnNvRL3RGkmphhnWAGA28nKRe4mbTtaWIHUy+8KSETa9jo1Ikyh4GB3yyvYSjZ/Q836VRq8gr04sJrFQ65mmPGkukSGa/k9iKPmwAKRC/tX83KINwF9ykOPewLWOIZ0Z88LdK+19Myxi3CBvoYzzErRwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783338836; c=relaxed/simple;
	bh=pQ2sBx1yflRxuOdyqgGzEEWEaQnnZZWHr6wFLS1861Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d6vA3Dx/eezCYenW7rcK1pzGAbdLlREIhCuFEArnFckkAfD+1Ft1IdBIUWfPctvIBD6oiEV8YCet/m7Z4XshZwwWRQJZdSlzur8/lVD5p5Si4pPlkTX1yCjY3uhTird1ItQr8Jh9m++I3QOlmIPrgJa4Pyt2dMt/u/BLBqHpLmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QmjaIEJH; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QmjaIEJH"
X-Forwarded-Encrypted: i=1; AHgh+RrrWFFwE0fs5YrDCSfwA5D0APXGzLD0Z9VJ5a4MZ/V7ygqDwsHkDOu5rTGD3Jwx6SzcI5p5v0I=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783338833;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s+eed6la7DRVrFBf17KyzvgFRJ5+OioCbBp3mjbwXuY=;
	b=QmjaIEJHE1uY7IxK8zApWhkKVAT0owPm4UcwM3/4ox2a6AhGckjmp7Mfn4d4mxG+90RQEO
	0XZl8GsZMeRuTsnD+Jdme6YDnFPOciVSHwcqQdOZ7YGId6BRoAGqL0gdRBjex7GDR3NuIa
	7mLB3U+svQdwQiat1gAe0pTUaFt8sNM=
X-Gm-Message-State: AOJu0YxZViSxx7EmUVr5tIS0bmHkyAlkHvT4tdOI5Jlu4kcAnU8gthCX
	p7lILhm9gOADPjYG0UZj9r0zYpq3YZVquLg8c1GkzAyGGuTX6XLkrwMlNndsBEexhMVG1du8IOl
	M00kMzUYSQsEqMxr0CYDcTKfkE5HfPVcRtfuAQNtZ
X-Received: by 2002:ac8:5a15:0:b0:51a:713c:7444 with SMTP id
 d75a77b69052e-51c4c0f67bbmr18296841cf.18.1783338829969; Mon, 06 Jul 2026
 04:53:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706095927.560795-1-fuad.tabba@linux.dev> <20260706095927.560795-7-fuad.tabba@linux.dev>
 <20260706102817.B03AF1F000E9@smtp.kernel.org>
In-Reply-To: <20260706102817.B03AF1F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 6 Jul 2026 12:53:12 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyM3CYofmj_ugC_vkZkUBGw-7UFyXRJbi5QkF4QqcV2YA@mail.gmail.com>
X-Gm-Features: AVVi8CcufXl79qkj69YuJOxGM3lFnmm8GA-GesmNUrodYSpOe3hBd_p7YCWrQzI
Message-ID: <CA+EHjTyM3CYofmj_ugC_vkZkUBGw-7UFyXRJbi5QkF4QqcV2YA@mail.gmail.com>
Subject: Re: [PATCH v4 6/8] KVM: arm64: Minimise EL2's exposure of host VGIC
 state during world switch
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 11:28, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] Userspace KVM_SET_ONE_REG modifications to ICC_VMCR_EL1 and Acti=
ve Priority Registers (APRs) are silently overwritten and lost on vcpu_put(=
) under pKVM.

The vcpu_load/vcpu_put path under pKVM uses the same direct
__vgic_v3_save_aprs / __vgic_v3_restore_vmcr_aprs on the host cpu_if
as non-pKVM nVHE, not the hyp-main.c wrappers.

/fuad


> --
>
> commit 8bda67fe364c44ad574acb3da5de4bf16e0ccbbf
> Author: Marc Zyngier <maz@kernel.org>
>
> KVM: arm64: Minimise EL2's exposure of host VGIC state during world switc=
h
>
> This commit avoids exposing the host's entire vgic_v3_cpu_if to EL2 by
> copying only the necessary vgic_vmcr and active priority registers during
> save and restore operations.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 45d717889f6ea..f3233ee343a39 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
>
> [ ... ]
>
> > @@ -508,16 +520,63 @@ static void handle___vgic_v3_save_aprs(struct kvm=
_cpu_context *host_ctxt)
> >  {
> > -     DECLARE_REG(struct vgic_v3_cpu_if *, cpu_if, host_ctxt, 1);
> > +     struct pkvm_hyp_vcpu *hyp_vcpu;
> > +     struct kvm_vcpu *host_vcpu;
> >
> > -     __vgic_v3_save_aprs(kern_hyp_va(cpu_if));
> > +     host_vcpu =3D get_host_hyp_vcpus_from_vgic_v3_cpu_if(host_ctxt, 1=
,
> > +                                                        &hyp_vcpu);
> > +     if (!host_vcpu)
> > +             return;
> > +
> > +     if (unlikely(hyp_vcpu)) {
> > +             struct vgic_v3_cpu_if *hyp_cpu_if, *host_cpu_if;
> > +             int i;
> > +
> > +             hyp_cpu_if =3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> > +             __vgic_v3_save_aprs(hyp_cpu_if);
> > +
> > +             host_cpu_if =3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> > +             host_cpu_if->vgic_vmcr =3D hyp_cpu_if->vgic_vmcr;
> > +             for (i =3D 0; i < ARRAY_SIZE(host_cpu_if->vgic_ap0r); i++=
) {
> > +                     host_cpu_if->vgic_ap0r[i] =3D hyp_cpu_if->vgic_ap=
0r[i];
> > +                     host_cpu_if->vgic_ap1r[i] =3D hyp_cpu_if->vgic_ap=
1r[i];
> > +             }
>
> [Severity: High]
> Does this sequence risk clobbering userspace writes to ICC_VMCR_EL1 and t=
he
> Active Priority Registers?
>
> When userspace modifies the GIC CPU interface via KVM_SET_ONE_REG, the
> ioctl is wrapped by vcpu_load() and vcpu_put().
>
> Under pKVM, vcpu_load() calls __vgic_v3_restore_vmcr_aprs, which restores
> the hardware with the current values.
>
> The ioctl then updates host_cpu_if in memory with the new userspace value=
s.
>
> Finally, vcpu_put() issues the __vgic_v3_save_aprs hypercall.
>
> Since the hardware and hyp_cpu_if only have the pre-ioctl stale values,
> will this explicit copy back to host_cpu_if overwrite the new values set
> by userspace? This could cause state restoration or live migration to
> silently lose these register updates.
>
> > +     } else {
> > +             __vgic_v3_save_aprs(&host_vcpu->arch.vgic_cpu.vgic_v3);
> > +     }
> >  }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706095927.56=
0795-1-fuad.tabba@linux.dev?part=3D6
