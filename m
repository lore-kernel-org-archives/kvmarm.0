Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FED4734DB;
	Fri,  7 Aug 2026 12:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786104094; cv=none; b=frkIj8YAYIwhe/n6lxE/b8KgALxvSu3TqNTWkBvIbevdddULigKe0lM3XbsUkSvUAZxYPYK26rl5HHIQNdiya8jWKBgiBYApU6h7+D/KFY4FFR7cqeyvaxwevJvk5CHYCqLfwgS8NwL5AAAKkkSyrT95rn3lJ1RzfsU/AZ3xs+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786104094; c=relaxed/simple;
	bh=U5YGJPGs2DcMFcJrTktuVBPOnz0CoYVSbCI3NiT5n1A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LFeFWV6qnzffU5tnpiNUWOpFXLVS56IeIEw7iIx3wiOmHNVY553PNnXp5rxtMDojJwie1JnRqaMFtjco57Q2bESrWGj2LMYt8NOMB5mPtdOdP86Qtzoe9trKzgcX8rBAnRMZV/iWowbNJ9O9UW/MWhtssLMNqjMYxSRHSEPkTmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GiklLU7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GiklLU7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368FC1F00A3A;
	Fri,  7 Aug 2026 12:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786104075;
	bh=9NseZk0tJlyP+m+KHNmlcUFvIhq3upGqyyq+qQTHlZc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GiklLU7jw/DtXcIYNswIFTqeeU7nPUr0GDiyHf/ZA2tSjlgq/dW3LmOw2yfenA1Lr
	 dL9d359uCvuUENXUtUzQV9K70KR7GPZ7uO9igt0PWIJm78xV4fj3MKpgiy4sysecC4
	 TyVRJE+wey561gboPDayHuS2pu0rhYc6QXoM+9FpQi3mS0gqEG+560D90DlEaGXymM
	 79rojmOM6TejBb8hz0fD3lXbucSsEpzl9QnluqoK1ptWCFmfJVpTV3FvMIDqi4/ZbG
	 hbEjkI2/47XSX4bD8CyX0GwiQvhEdxaelFCdKkXuEbY8qD0Fbjm5c0376jPAmmY5FN
	 DeXX5ZO09hYSg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 03/49] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260807111159.429128-4-sascha.bischoff@arm.com>
References: <20260807111159.429128-1-sascha.bischoff@arm.com>
 <20260807111159.429128-4-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Aug 2026 12:01:14 +0000
Message-Id: <20260807120115.368FC1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing bounds check in gic_acpi_parse_virt_madt_gicc() when parsi=
ng ACPI MADT GICC subtables, leading to out-of-bounds read on malformed tab=
les.
--

--- Patch [3]: [PATCH v5 03/49] irqchip/gic-v5: Set up gic_kvm_info on ACPI=
 hosts ---
commit 7147e5b6fec39dcd71e533b7ddd5252d309103a5
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts

This commit adds the ACPI equivalent of the DT KVM setup for GICv5. It pars=
es
the MADT GICC entries to retrieve and register the maintenance interrupt, a=
nd
passes the resulting IRQ along with IRS base and coherency information to K=
VM.

> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> index e7a7aedcfaf78..5b8ea8551d832 100644
> --- a/drivers/irqchip/irq-gic-v5.c
> +++ b/drivers/irqchip/irq-gic-v5.c
[ ... ]
> @@ -1162,11 +1164,95 @@ static void __init gic_of_setup_kvm_info(struct d=
evice_node *node)
[ ... ]
> +static int __init gic_acpi_parse_virt_madt_gicc(union acpi_subtable_head=
ers *header,
> +						const unsigned long end)
> +{
> +	struct acpi_madt_generic_interrupt *gicc =3D
> +		(struct acpi_madt_generic_interrupt *)header;
> +	static int first_madt =3D true;
> +
> +	if (!(gicc->flags &

[Severity: High]
Could this read of gicc->flags lead to an out-of-bounds memory access?

If the firmware provides a malformed ACPI MADT table with an entry length
smaller than the size of struct acpi_madt_generic_interrupt, reading
gicc->flags or gicc->vgic_interrupt might cross a page boundary and cause a
kernel panic during early boot.

Would it make sense to validate the entry size against the end pointer here,
perhaps by using a macro like BAD_MADT_GICC_ENTRY(gicc, end), before access=
ing
any of the structure's fields?

> +	      (ACPI_MADT_ENABLED | ACPI_MADT_GICC_ONLINE_CAPABLE)))
> +		return 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260807111159.4291=
28-1-sascha.bischoff@arm.com?part=3D3
