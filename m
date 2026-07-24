Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08466424D53;
	Fri, 24 Jul 2026 11:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784891965; cv=none; b=NS8PDhFi8XyFcnwcApE/cyQtZG8wZvUp1xsstr+VcDXwoAp39telVjdCLcXvumLjvFJASG8a8+1g1/AlUSVG23r+87tv/kR5DG8wqp/TpwzPMvTqmVcpnyTSL3jtmuZZM8sonVjqHQQ+IfGa+ZMrirYhUQmB5WQx50Z7vud8IjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784891965; c=relaxed/simple;
	bh=euq1urGE49AgXTMWK0Q0K3vK/Ft6Ymx5IhKXrN+dhAs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=czeUD8DJckZ7iPF45HJAli7xp4Cx9D+O+7kajG1aijA4piQhPTq8Bfvptze7NV0YyHOxQTuIPCzoLq828cvjR+JWMKly2NjG6TxYIJdiVJ0L9QA/BzFAvd81a8OiQIcHSf+iEqS6gRu7nRmEbubdzQmx014FMav3nHabZVZwd+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GhT7w+6f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GhT7w+6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F63C1F00A3F;
	Fri, 24 Jul 2026 11:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784891960;
	bh=Ign6sz2zco1R13pmGuh7YFyOAPgoWPPvATyl33D5dCU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GhT7w+6fIKY8teyBRTaG+LHbb1i8GfFlTRwpz08leo0Zh+g4XkCOxSAQTXRi23qry
	 8K1rjHA7yB2Ab4nhDbOgdulQ3qQ379tnhYjkid+2HYjBQn9hdEwt5B1Q1jVmhNPYqD
	 5exqslYBCsO23G6Anopsw8eZyidOKC+2rmB25T/xi91xilDPKycMX4c7F4kTF0skhu
	 clMhJaNg+WGssidaV1ONoLL7TA1fxUDi+5bz0BlQalU6q0wNqmy9AZAdx7a2qt/MEm
	 EKi016ch93WLpzcunRwWn5pWLOEUQyNQCkjXUXU3ZeOZn7ayQleP2icmx+vmrWuaJ5
	 l5FSsOZFso4Rw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 03/48] irqchip/gic-v5: Set up gic_kvm_info on ACPI
 hosts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sascha Bischoff" <Sascha.Bischoff@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260724104819.1296803-4-sascha.bischoff@arm.com>
References: <20260724104819.1296803-1-sascha.bischoff@arm.com>
 <20260724104819.1296803-4-sascha.bischoff@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 11:19:20 +0000
Message-Id: <20260724111920.6F63C1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Failed ACPI GSI registration for maintenance IRQ due to missing GI=
Cv5 hardware IRQ type encoding.
--

--- Patch [3]: [PATCH v4 03/48] irqchip/gic-v5: Set up gic_kvm_info on ACPI=
 hosts ---
commit 6d138977b1bc438c493851b44358f453400237da
Author: Sascha Bischoff <Sascha.Bischoff@arm.com>

irqchip/gic-v5: Set up gic_kvm_info on ACPI hosts

This commit adds ACPI support for setting up KVM host information on GICv5
systems. It parses MADT GICC entries to retrieve the maintenance interrupt =
and
registers it as a GSI to be passed to KVM.

> diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
> --- a/drivers/irqchip/irq-gic-v5.c
> +++ b/drivers/irqchip/irq-gic-v5.c
[ ... ]
> @@ -1162,11 +1164,100 @@ static void __init gic_of_setup_kvm_info(struct =
device_node *node)
[ ... ]
> +static void __init gic_acpi_setup_kvm_info(void)
> +{
> +	unsigned int maint_irq =3D 0;
> +	int irq;
> +
> +	if (!gic_acpi_collect_virt_info()) {
> +		pr_warn("Unable to get hardware information used for virtualization\n"=
);
> +		return;
> +	}
> +
> +	if (acpi_v5_kvm_info.maint_irq) {
> +		irq =3D acpi_register_gsi(NULL, acpi_v5_kvm_info.maint_irq,
> +					acpi_v5_kvm_info.maint_irq_mode,
> +					ACPI_ACTIVE_HIGH);

[Severity: High]
Does this fail to register the maintenance IRQ?

acpi_register_gsi() passes the raw maint_irq directly into fwspec.param[0].
However, the GICv5 PPI domain select function expects the hardware IRQ type=
 to
be encoded in the upper bits:

drivers/irqchip/irq-gic-v5.c:gicv5_irq_ppi_domain_select() {
    ...
    if (is_fwnode_irqchip(fwspec->fwnode))
        hwirq_type =3D FIELD_GET(GICV5_HWIRQ_TYPE, fwspec->param[0]);

    if (hwirq_type !=3D GICV5_HWIRQ_TYPE_PPI)
        return 0;
    ...
}

Because the raw MADT value doesn't have the GICV5_HWIRQ_TYPE_PPI bits set, =
the
mapping will be rejected. Should the GSI be encoded with the PPI type before
calling acpi_register_gsi()?

> +		if (irq > 0)
> +			maint_irq =3D irq;
> +		else
> +			pr_warn("Failed to register GSI for GICv5 maintenance IRQ\n");
> +	}
> +
> +	gic_setup_kvm_info(maint_irq);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724104819.1296=
803-1-sascha.bischoff@arm.com?part=3D3
