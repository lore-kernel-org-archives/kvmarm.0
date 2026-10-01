Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AFD4A5EC1
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 12:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790856273; cv=none; b=EklbCdc513p7eKqnHVCTbQ1M5QRMV+5f+lSFxsr9RGeJeD6+9kZf+YscIMtWbZni1UTVoRyh7tgd2GIIjKQ9WPr0cqmT7ZqNjNPkunQusZOE6Upb0/uU0WErzGLraXP7cRLJll8Vu2xbEci/Psm94NQuiabDU6zBbluVkCfzsDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790856273; c=relaxed/simple;
	bh=foWljOQ0g5DBx/QsZsEJ/Dx53YjcHRt7h4y6N1WxXJQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZV2QUDt/KLSUIMoJmSSzXIPo6QXoJB8Frn9rZpa+R6y9dtl/kfIWFuOsm7LFGpyuyiQxoRaPXmAsWtlCb2HEAoF5mkU0q3R9nM/h2DX6ssnJePTahcU4Juzg6ynu4QyiTUHg0LQkz1Xa4p6lmt0REHerQ+g5k0cypsXlY4dJA0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIKU9CVN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIKU9CVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20421F000FF;
	Thu,  1 Oct 2026 12:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790856271;
	bh=OjGEtgwg8Qfj1HMrFP3sCKuy1UZDE7g5d1wILhXXTUs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KIKU9CVNcoYaYHML+1EeAHth0gVh3PMO3hV9DiEnpEokTIn3mfUzvAs9ybOOEIo9z
	 mn66KN4JJviM5FXuu0+MOmkmvodszhTDl0sMOsEFBXmBIQ3itTp5rhXYn/YhArXLl9
	 0+E8RHMKiwksXwgWgClv1TDKrOG8tT0lG8aC4UcbClc2OuvSgcm0Zjyqe4EhR5kyLQ
	 IQldIZtxb/bdGF+RNN4clAJiByiur7NbTO9N9i15di0hC9v4Lxcw3i/2tUk4GBwkto
	 jZyWhHBqgtFRsPKIMSzyNrA2YtvedDCXzSPMoG+KRekKzKal6Pk3z4+7++NEBKXF2J
	 ZqO5fpHicbEyw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC 06/12] ACPI: TLBI: Parse domains from table
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S3Jpc3RpbmEgTWFydMWhZW5rbw==?= <kristina.martsenko@arm.com>
Cc: "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20261001110655.461473-7-kristina.martsenko@arm.com>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
 <20261001110655.461473-7-kristina.martsenko@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 12:04:31 +0000
Message-Id: <20261001120431.A20421F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] acpi: tlbi: missing bounds check and integer overflow in structure=
 getters
- [Medium] acpi: tlbi: memory leak of domains array on initialization error=
 paths
- [Low] acpi: tlbi: dangling global pointer after ACPI table is unmapped
--

commit cbbbb2dad21c37d8cb180622bf2879e0d09c3f0d
Author: Kristina Mart=C5=A1enko <kristina.martsenko@arm.com>

ACPI: TLBI: Parse domains from table

This commit parses the Arm TLBI ACPI table to extract a hierarchy of TLBI
domains, identifying member CPUs and subdomains. It builds and validates
cpumasks for each domain so they can be used for domain management in
arm64 code.

> diff --git a/drivers/acpi/arm64/tlbi.c b/drivers/acpi/arm64/tlbi.c
> new file mode 100644
> index 0000000000000..b705a5b198426
> --- /dev/null
> +++ b/drivers/acpi/arm64/tlbi.c
> @@ -0,0 +1,188 @@

[ ... ]

> +struct acpi_table_tlbi *tlbi;
> +static struct tlbi_domain *domains;
> +static int domain_count;

[ ... ]

> +static struct acpi_tlbi_descendant *__init tlbi_get_descendant(u32 offse=
t)
> +{
> +	struct acpi_tlbi_descendant *descendant;
> +
> +	descendant =3D ACPI_ADD_PTR(struct acpi_tlbi_descendant, tlbi, offset);
> +	if (descendant->length < sizeof(*descendant) ||
> +	    offset + descendant->length > tlbi->header.length)

[Severity: High]
Does this code safely access the descendant structure? If the offset
parameter provided by the ACPI table is larger than the table size,
the computed descendant pointer will point out of bounds. Reading
descendant->length before validating the offset will cause an
out-of-bounds memory read.

Additionally, since offset and descendant->length are 32-bit integers,
could the addition offset + descendant->length overflow? If a large
length is provided, the overflow could bypass this bounds check and
allow traversal into out-of-bounds memory.

> +		return NULL;
> +
> +	return descendant;
> +}
> +
> +static struct acpi_tlbi_domain *__init tlbi_get_domain(u32 offset)
> +{
> +	struct acpi_tlbi_domain *domain;
> +
> +	domain =3D ACPI_ADD_PTR(struct acpi_tlbi_domain, tlbi, offset);
> +	if (domain->length < sizeof(*domain) ||
> +	    offset + domain->length > tlbi->header.length)

[Severity: High]
Similarly to tlbi_get_descendant(), does this safely read domain->length?
Reading from the computed pointer before verifying the offset could cause
an out-of-bounds read, and the 32-bit addition here is also vulnerable to
integer overflow.

> +		return NULL;
> +
> +	return domain;
> +}

[ ... ]

> +static int __init parse_tlbi_table(void)
> +{
> +	struct acpi_table_header *table __free(acpi_put_table) =3D
> +		acpi_get_table_pointer(ACPI_SIG_TLBI, 0);
> +	u32 offset;
> +	int ret;
> +
> +	if (IS_ERR(table))
> +		return PTR_ERR(table);
> +
> +	tlbi =3D (struct acpi_table_tlbi *)table;

[Severity: Low]
Does this leave the global tlbi pointer dangling after the function
returns? The table variable uses the __free(acpi_put_table) cleanup
helper, which will unmap the ACPI table memory at the end of the scope.
However, the global tlbi pointer is assigned to this memory and never
cleared.

> +	if (tlbi->header.length < sizeof(*tlbi) ||
> +	    tlbi->domain_count > MAX_TLBI_DOMAINS)
> +		return -EINVAL;
> +	if (!tlbi->domain_count)
> +		return -ENOENT;
> +
> +	domain_count =3D tlbi->domain_count;
> +	domains =3D kcalloc(domain_count, sizeof(*domains), GFP_KERNEL);
> +	if (!domains)
> +		return -ENOMEM;
> +
> +	offset =3D tlbi->domains_offset;
> +
> +	for (int i =3D 0; i < domain_count; i++) {
> +		struct acpi_tlbi_domain *domain =3D tlbi_get_domain(offset);
> +
> +		if (!domain || domain->id > U16_MAX)
> +			return -EINVAL;

[Severity: Medium]
Do these early error paths leak the domains array and the already
allocated cpumasks? Once domains is allocated via kcalloc(), returning
directly without a cleanup path leaves the memory permanently leaked.

> +
> +		domains[i].id =3D domain->id;
> +		if (!zalloc_cpumask_var(&domains[i].cpus, GFP_KERNEL))
> +			return -ENOMEM;
> +
> +		ret =3D parse_tlbi_domain(domain, domains[i].cpus, 0);
> +		if (ret)
> +			return ret;
> +
> +		offset +=3D domain->length;
> +	}
> +
> +	ret =3D validate_tlbi_domains();
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001110655.4614=
73-1-kristina.martsenko@arm.com?part=3D6
