Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A877433E8A;
	Fri,  3 Jul 2026 16:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783095950; cv=none; b=QgFxYmCj+6iUpTOxD/t/coErLzArt6SrlhiKoFxTdWEHRS1qN4jPeHU2rFVXzj5w7larjFaWNNOz8K9f8u3P2bMBNtjpWGo0nbvZ7xZfPJzfgsw6XEjf6Pbo0GQChzwnw9IU8f5Ev6V1aaU+Od1Ud8A4ffXVE/VJo1gSZRR/Ldo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783095950; c=relaxed/simple;
	bh=mQj79BNJpFmsvNsIwB8J02G+fwbSWo5niw6tP9N/Irg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A7AZeWb/K516MbQcxwMTA1jbY+Mpymt8Hd3XbYASiRglP6tkCqMVrdIYw+rZmtmnQhASjihXhRimkoqGJW6ssXLQSw1CWIIjWHnfqiOU/fIar56FBmV+BcZrvZr6oQTTJJjHlYCOgT4h/bcCfkKi/PVboC8o+9kR+5dTM2mtPlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AMkaT3PS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMkaT3PS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5AF1F000E9;
	Fri,  3 Jul 2026 16:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783095948;
	bh=fzwa+GMnSM4gl/5raIN7V89c0WKGbnF3BZobK9Oh0nw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AMkaT3PS/wEsejbIGme9rRW26Kfh9sEmrNvVu/LJbUlZ8s+Srs835P3P8ooBJAKfX
	 TYVLohbkgnfNB3C/mOF6VNnDa2xKOuNfEoIuI73hLBQn913Wu3w1c0tUKetFJsyh3N
	 010/WyHr+kW0i8k0xJerESTX++NeNkL/6i/C93U2P4hSouvqKvS/RjxpPwV6pdH6ci
	 ycuID1ia6Xs/RUYy1RwjPTtCvbv8Tj8gKYmLhUyk2PpTWPNXH7XETwgSp5NaLjmL+o
	 WFJxWnIiTS3/Q8aCZ1YuBOtpb2HCj941ByYtnnn9tcV+PXWzpZlhCd7sElu/sJ9fsy
	 W72n1rLVNhSgw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 08/40] KVM: arm64: gic-v5: Add VPE doorbell domain
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260703154811.3355680-9-sascha.bischoff@arm.com>
References: <20260703154811.3355680-1-sascha.bischoff@arm.com>
 <20260703154811.3355680-9-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 16:25:48 +0000
Message-Id: <20260703162548.8D5AF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing NULL check for fwnode allocation allows unintended fallb=
ack to nameless domains.
--

commit 6a3e1b90ffc14235d7c9484abe0167a310e9d6ca
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add VPE doorbell domain

This commit adds support for a per-VM VPE doorbell irq domain to handle
GICv5 hardware notifications for non-resident VPEs. It allocates a doorbell
per VPE under the GICv5 LPI domain and stores the base in the VM's GICv5
state. The per-VPE doorbell state is also added to the CPU interface state.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 3f7b132110114..1baec8e97ac28 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> @@ -152,6 +153,132 @@ int vgic_v5_probe(const struct gic_kvm_info *info)
>  	return 0;
>  }

[ ... ]

> +static int vgic_v5_create_per_vm_domain(struct kvm *kvm)
> +{
> +	struct vgic_v5_vm *vm =3D &kvm->arch.vgic.gicv5_vm;
> +	int nr_vcpus =3D atomic_read(&kvm->online_vcpus);
> +	int id =3D task_pid_nr(current);
> +	int ret, db_virq =3D 0;
> +
> +	if (!gicv5_global_data.lpi_domain) {
> +		kvm_err("LPI domain uninitialized, can't set up KVM Doorbells\n");
> +		return -ENODEV;
> +	}
> +
> +	vm->fwnode =3D irq_domain_alloc_named_id_fwnode("GICv5-vpe-db", id);

[Severity: Medium]
Is it possible for irq_domain_alloc_named_id_fwnode() to fail and return NU=
LL
here under memory pressure?

If it does, passing a NULL fwnode into irq_domain_create_hierarchy() below
will cause it to silently fall back to a nameless domain, degrading the
diagnostic state. Should there be a check here to return -ENOMEM if
vm->fwnode fails to allocate?

> +
> +	/*
> +	 * KVM per-VM VPE DB domain; child of LPI domain; only ever handles
> +	 * doorbells. We know how many doorbells we have, and therefore we
> +	 * create a linear domain.
> +	 */
> +	vm->domain =3D irq_domain_create_hierarchy(gicv5_global_data.lpi_domain,
> +						 0, nr_vcpus, vm->fwnode,
> +						 &vgic_v5_irq_db_domain_ops, vm);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703154811.3355=
680-1-sascha.bischoff@arm.com?part=3D8
