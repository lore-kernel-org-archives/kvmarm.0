Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC364334D5;
	Fri, 24 Jul 2026 11:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784891495; cv=none; b=G3cLEHViX4s70Ei0fwAXlFNC0mOFlqaahhKiUCzLSzq3YlBbJ23EH84AIDirnQ9FX9EbU4CxHXfpHVFwfuAUgYscv5vL798dI+NKzi7FAYAlyr6sOgzXFkYktgoQ01rBlH9KDtg2PncPUe+rH3xli1ePHenJAtdQkEvxTNexjIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784891495; c=relaxed/simple;
	bh=vUBLWCfyvt8WkHzVAw/0j/omZAvLwnAbsa4Eqm/OINw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CEX4+2wpx2mh81WXQ4BS8diwlpC5UTc8Gxw69xzGam1GWptFe5b9U9LkxjAjt3UMZDlTrZoEaZI7bvyzGbuJNHj6sJzkeW7cVZq4mrtWc5fGPkCYkVH/YerJfYndXguna7APerrKciVuXT1gsvjxeQ06nbCUCn7zXEtjAzUxdbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UUZJkgzq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UUZJkgzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B12E1F0429A;
	Fri, 24 Jul 2026 11:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784891493;
	bh=Va/CNb0brfOOEkUNdkVxoZdEKCIJet0ZJX7rvBh73kg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UUZJkgzqxjmhrs26AW5eLycW7aP34R+KR96QVU8dx/Bj59/AnfxU1ku/gZyPb4cuK
	 G6COtJ7I7z3K0WkJb3TlLCVXQnw0AWab6kG5JA7ARM20RrA/OQ0MVyPnO2KzrVwTsn
	 JRww8vIez80I3BHJJRDFtjb0SGnPGNKdz7RMJK6LUPmpWJAnD/582kt/LSa7wmgXyw
	 1Y7HD3JPgtnpQXhNKsY6aEWfEmi3liHrX3749oC3k1FiBdSW6pWrXb2RXhKY5tvLuh
	 R8oGdJc9+1S89JQY6en7BqkwUXTFo4uAIdyu6LFRT0uoNHp6lTudlcagsCeeulUF0a
	 EIz5o8HBX+cYw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 08/48] KVM: arm64: gic-v5: Add VPE doorbell domain
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260724104819.1296803-9-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-9-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:11:32 +0000
Message-Id: <20260724111133.6B12E1F0429A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Allocated doorbell IRQs and their associated request handlers are =
leaked during VM teardown, exhausting IRQ descriptors and triggering a kern=
el warning.
--

--- Patch [8]: [PATCH v4 08/48] KVM: arm64: gic-v5: Add VPE doorbell domain=
 ---
commit 3bd242f19027d5c3f4f9f1ea26d5e37b8f153bd4
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

KVM: arm64: gic-v5: Add VPE doorbell domain

This commit adds support for a per-VM VPE doorbell irq domain in GICv5.
It allocates one doorbell per VPE and stores the doorbell base in the VM's
state for use with IRS commands and wakeups.

> diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
> index 3f7b132110114..ebd7c3ede975f 100644
> --- a/arch/arm64/kvm/vgic/vgic-v5.c
> +++ b/arch/arm64/kvm/vgic/vgic-v5.c

[ ... ]

> +static void vgic_v5_teardown_per_vm_domain(struct vgic_v5_vm *vm)
> +{
> +	if (!vm->domain)
> +		return;
> +

[Severity: High]
Does this code leak the allocated doorbell IRQs and their request handlers?

During initialization, vgic_v5_create_per_vm_domain() allocates IRQs via
irq_domain_alloc_irqs(), and vgic_v5_init() requests them via request_irq().

Should free_irq() and irq_domain_free_irqs() be called before tearing down
the domain? Removing a domain that still has allocated IRQs can trigger a
warning in the core IRQ subsystem, and repeatedly creating and destroying
VMs could eventually exhaust the IRQ descriptor space.

> +	irq_domain_remove(vm->domain);
> +	irq_domain_free_fwnode(vm->fwnode);
> +	vm->domain =3D NULL;
> +	vm->fwnode =3D NULL;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D8
