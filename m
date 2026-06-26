Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108F8175A80;
	Fri, 26 Jun 2026 11:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474397; cv=none; b=cixWo1csuNadn4SsIHN9Fw4mVg4xa7SAgw2XjpoXxLEerLWoB3rFNFCOuEvImrzT2jCGcZFenfen84odLzrzGrO5BonIhBgYDysL+fRuSjlFC5wF5RIa44gk5o7MvG01aeod0K3SkzM8Fmqmqp9Bl7nRWLKkXzXzVIS5X0P1kcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474397; c=relaxed/simple;
	bh=fjrxJQLGwmRuI2zMtba+SKMvIdVPZE1F6L3o26FtE3Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jlHLHuJdr7iwNnqiFcEd0wHVtMV5PlwJWgEcQ9iqI3QAEvuPUaUhmwEUngsDOIbYEaO6dCwYeaq2DeweKc4bHvKlg18Lk57gY5CQ3mEd/o/fs8XpLa0VY9aRJVzPmWIdPbN4Ry5dua3VEOfJ1v745EblMdhtEbndA7ARd3QLtjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VxVpWUxd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VxVpWUxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A0B1F00A3A;
	Fri, 26 Jun 2026 11:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782474395;
	bh=ouswJwkXR2S4nwwAzVktLu91MB9Oz0JoiKIzV1E4/ZA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VxVpWUxdfY8j5Joar8Ic80ZKhkBUrLMQw8nD38/n/mNlkESWI2RlgLcIKY6W/e2Da
	 OQ3mHI7V/8ymOa/Vjs46mCAAU8n3hwd+4YmR2BdjsuCwZLv4aXhoBw2UbNdJCP3hYV
	 6FAStFNGvdpL0uiXn0X6Pc4sd7y1URGxaFaki+Rlhms8GoyKqkwsQTJ5Vtm0FaV1y4
	 VcvM/glfnSScN3i8cz0ybjtu238AidSL++RaEWPo/93kCXmgVIK/HcpK76N3cFGtRe
	 L5QirzSaZNFflyCeL5Zunbx4jVb0HrGw3E6BdizoAoX8NeA3rvky0bnfp8NJ9eFHK+
	 8EoE8MaNJWDHQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: Make kvm_io_bus_get_dev() filter devices by ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Marc Zyngier" <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20260626111344.802555-1-maz@kernel.org>
References: <20260626111344.802555-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 26 Jun 2026 11:46:35 +0000
Message-Id: <20260626114635.82A0B1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Dropping the SRCU lock in kvm_io_bus_get_dev() exposes a Use-After=
-Free for VGIC redistributors.
--

commit 954101cd7bbd1642133e68638e5210cf89b88023
Author: Marc Zyngier <maz@kernel.org>

KVM: Make kvm_io_bus_get_dev() filter devices by ops

This commit updates kvm_io_bus_get_dev() to check the device ops pointer
before dropping the SRCU lock. This aims to prevent lifetime issues where
a caller might introspect an object of the wrong type after the lock is
dropped.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c

[ ... ]

> @@ -6081,7 +6082,9 @@ struct kvm_io_device *kvm_io_bus_get_dev(struct kvm=
 *kvm, enum kvm_bus bus_idx,
>  	if (dev_idx < 0)
>  		goto out_unlock;
> =20
> -	iodev =3D bus->range[dev_idx].dev;
> +	if (bus->range[dev_idx].dev &&
> +	    bus->range[dev_idx].dev->ops =3D=3D ops)
> +		iodev =3D bus->range[dev_idx].dev;
> =20
>  out_unlock:
>  	srcu_read_unlock(&kvm->srcu, srcu_idx);

[Severity: High]
This is a pre-existing issue, but does dropping the SRCU lock here before
returning the matched device pointer expose a use-after-free?

If a host VMM concurrently executes KVM_SIGNAL_MSI (with a doorbell address
overlapping the redistributor) and KVM_CREATE_VCPU (forced to fail due to
resource exhaustion), the failed vCPU creation path can unregister the
device and free the vCPU memory.

Because the SRCU lock is already dropped here, the unregister path won't
be blocked. When the MSI injection path resumes in __vgic_doorbell_to_its(),
it can dereference the freed vCPU memory:

arch/arm64/kvm/vgic/vgic-its.c:__vgic_doorbell_to_its() {
    ...
    kvm_io_dev =3D kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, &kvm_io_gic_ops, d=
b);
    if (!kvm_io_dev)
        return ERR_PTR(-EINVAL);

    iodev =3D container_of(kvm_io_dev, struct vgic_io_device, dev);
    if (iodev->iodev_type !=3D IODEV_ITS)
        return ERR_PTR(-EINVAL);
    ...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260626111344.8025=
55-1-maz@kernel.org?part=3D1
