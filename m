Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E05B58F09F;
	Tue,  8 Sep 2026 16:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788886605; cv=none; b=GGvmEtZzE8zC2V6xki32qVT7bdUqNw5prd5Cxmnmc6/RtkLbjx3V52pod1SAetxxfXqFvrlJguJvqSjHb0gZ+8L+dUsm1w5SDwnLAd1O464lyRTgZcp3RcAD7CrIKQ04uRlLd7n3PzS1hOG/tq5x7PUasIQJpN3n/9xRgejXl0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788886605; c=relaxed/simple;
	bh=9WmAZGetd/RUdXfO7ETx95iUTd3l3J9zhXKl4v+7VD4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ag+6vI7z14/YQG30eeYLSZ+IaTR7QuLKz3qt/uGIWd+bVefdctCiQFdKFuI+YVYAJdMq1duTvOcLhB9EG9MZyVnYL4diIlkI7bqcZZPSjUqV0tEibLuOtxBcHoU6QVC7qi4y21YP/3OgURvSHVy8B4u4B8ZVCJsYlsnW0Go4AU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U3T+UwbX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U3T+UwbX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C501F00A3A;
	Tue,  8 Sep 2026 16:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788886603;
	bh=PSVz+HZbd8+QIFrxArfJkKTLg2fBTYsOIS3WD5CX6LU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U3T+UwbXSVaYN/8eFqHviQhNcYK3fnzSFKCIk3qbDMtjy4orO29q0DDULOtrB5x9n
	 JkU20MN6LApf+VMWOe209PzfdUDXdalYWZbuc0n7fMd5mBHjpWyRIeGuM65CN26spT
	 6ZlASgl8MbHnPP5+t4n6KrH3fEhsJmDheUX2HGkERL9JudSqKxsntdYHGTFa6TM20S
	 DQ12UqAAM13wDA4kkBTfbM2QwfDvf0hqmJz4xsiAxLEILR6iqgCsXWsxA+oCNNaihZ
	 EpcfedHm7Y7S6JPMwDS6pvfFG0Py4CmQpp8gUDvlpMM/XsfLJRpBEquLEEFYg11src
	 dQjAW9fI7qqDg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 12/20] KVM: arm64: CCA: Support timers in realm RECs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suzuki K Poulose" <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260908162223.1683432-13-suzuki.poulose@arm.com>
References: <20260908162223.1683432-1-suzuki.poulose@arm.com>
 <20260908162223.1683432-13-suzuki.poulose@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 16:56:42 +0000
Message-Id: <20260908165643.50C501F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Realm VM timers are blackholed on GICv5 hosts due to unconditional=
 physical interrupt masking combined with disabled direct injection.
--

commit 759ada4556cf9518a1b30ec3610b7b7833129bd9
Author: Steven Price <steven.price@arm.com>

KVM: arm64: CCA: Support timers in realm RECs

This commit adds support for handling timers when exiting a realm REC to the
normal world. It implements realm_timer_irq_ops which relies on the existing
software resampling mechanism for Realm timer interrupts.

> diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> index eba84cab95d01..3eddf44f7b1dd 100644
> --- a/arch/arm64/kvm/arch_timer.c
> +++ b/arch/arm64/kvm/arch_timer.c
[ ... ]
> @@ -1609,8 +1623,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
> =20
>  	get_timer_map(vcpu, &map);
> =20
> -	ops =3D vgic_is_v5(vcpu->kvm) ? &arch_timer_irq_ops_vgic_v5 :
> -				      &arch_timer_irq_ops;
> +	if (vcpu_is_rec(vcpu))
> +		ops =3D &realm_timer_irq_ops;
> +	else if (vgic_is_v5(vcpu->kvm))
> +		ops =3D &arch_timer_irq_ops_vgic_v5;
> +	else
> +		ops =3D &arch_timer_irq_ops;
> =20
>  	for (int i =3D 0; i < nr_timers(vcpu); i++)
>  		kvm_vgic_set_irq_ops(vcpu, timer_irq(vcpu_get_timer(vcpu, i)), ops);

[Severity: High]
Will this cause Realm VM timers to be lost on a GICv5 host?

When a Realm VM is created on a GICv5 host, vcpu_is_rec(vcpu) takes precede=
nce,
assigning realm_timer_irq_ops. However, this struct lacks the
.set_direct_injection callback used for hardware direct injection.

At the same time, because vgic_is_v5(vcpu->kvm) is still true for the host,
other timer paths will unconditionally assume direct injection is active. F=
or
example, kvm_timer_update_irq() skips software injection:

kvm_timer_update_irq() {
        ...
        /* Skip injecting on GICv5 for directly injected (DVI'd) timers */
        if (vgic_is_v5(vcpu->kvm)) {
                ...
                if (map.direct_ptimer =3D=3D timer_ctx ||
                    map.direct_vtimer =3D=3D timer_ctx)
                        return;
        }
}

Additionally, kvm_timer_vcpu_load_gic() unconditionally masks the physical
timer interrupt for GICv5 setups:

kvm_timer_vcpu_load_gic() {
        ...
        phys_active |=3D pending;
        phys_active |=3D vgic_is_v5(vcpu->kvm);

        set_timer_irq_phys_active(ctx, phys_active);
}

Since hardware injection is not configured by the Realm ops and software
injection is bypassed due to the GICv5 checks, does this completely blackho=
le
timer interrupts for Realm VMs on GICv5 hardware?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908162223.1683=
432-1-suzuki.poulose@arm.com?part=3D12
