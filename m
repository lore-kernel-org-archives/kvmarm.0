Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72541DDC33
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 12:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783339706; cv=none; b=dBo6pXLbOhAHe9z9joQ4zDX1T6zBMTKvTGmM/jW/48lyXJPrt0uNaGV/SrCQ7RClMhvGzGekH/w9zAlbT1ODNGOsRADYw+9DrAsKieWUnBIZBSTpw6LLyDp3yCjOnFNcqM8OMz+CzSPIHTVLsqdLFkqsf1WuELItRSh+T47zxsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783339706; c=relaxed/simple;
	bh=z4y8erDb6j+TUM58O5mqAx6G1fXWaZqcSl62ugosxOw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=U+XKY67SgtVGsLXIVOj0EQXcdKLtQB+Teg1UuG0gEiD8CerGn+oy/vM2x1gUlD7vxhaukYGKSHImR6PUs7acwxZmvX9gAUDBW8j29w+FrUIgs+MZh7RWylgs6KVhge2Fz6j5+Fl7JFYUhseGTEp2kg/GLyAalJsOHAiDspCxfqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MgrN0x+x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MgrN0x+x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0853C1F000E9;
	Mon,  6 Jul 2026 12:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783339704;
	bh=Up0GZwVl41xmI986jUpJVbIrICCFU2rGfw9O2Nar4UU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MgrN0x+x9yJTvPr2QHII3pxJW9nl/oMUWbayUjeLtxRwqLso8ZgNKPwNIALKCvaOe
	 Q3/ikYkFgYzW0NEoiT+ja7lN5e88MAqpW8bJdWVkzBP2KQVbVUUIGcqVPqrazQNpPI
	 XKiR13dgcVv+7IFd030J7SYbBeHolm1IhxAvNjB+yiE9iqz0fhhuQ7kSFarA4yqNFI
	 aZYL1FwDTNiaPSgG9Bx56pUO89GztXSFy8eqJxKbEJ31fLr1C3xbbiOUorQZpDXbf/
	 HnDLKjRJd6Ab/HD5vxpWVv8E3DQ+ewqP7fVai7MoX2g5nkU9bSBN+CsSEIwYnS2lxz
	 uadsp5mC12cFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] KVM: arm64: selftests: Add MMIO sign-extending
 load test
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260706115522.954913-3-fuad.tabba@linux.dev>
References: <20260706115522.954913-1-fuad.tabba@linux.dev>
 <20260706115522.954913-3-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 12:08:23 +0000
Message-Id: <20260706120824.0853C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The test executes guest code at EL0 but fails to map the executa=
ble text segment with unprivileged access permissions (PTE_USER), causing a=
n immediate Instruction Abort.
--

commit 8d8bc26c675634520d0cf6c2769677a38145f1a9
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: selftests: Add MMIO sign-extending load test

Add a test for sign-extending MMIO loads (LDRSB, LDRSH, LDRSW) into Xt
and Wt destinations, with and without the sign bit set. The host supplies
the MMIO data and checks the guest register holds the sign-extended value.

> diff --git a/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c b/tools/te=
sting/selftests/kvm/arm64/mmio_sign_ext.c
> new file mode 100644
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/mmio_sign_ext.c

[ ... ]

> +static void guest_code(void)
> +{
> +	guest_loads_le();
> +
> +	if (guest_mixed_endian_el0()) {
> +		write_sysreg(read_sysreg(sctlr_el1) | SCTLR_EL1_E0E, sctlr_el1);
> +		isb();
> +
> +		asm volatile(
> +		"	msr	elr_el1, %[pc]\n"
> +		"	msr	spsr_el1, %[spsr]\n"
> +		"	mov	x0, %[mmio]\n"
> +		"	isb\n"
> +		"	eret\n"

[ ... ]

> +int main(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +	unsigned int i;
> +	bool be;
> +
> +	vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
> +	virt_map(vm, MMIO_ADDR, MMIO_ADDR, 1);
> +
> +	vm_init_descriptor_tables(vm);
> +	vcpu_init_descriptor_tables(vcpu);
> +	vm_install_sync_handler(vm, VECTOR_SYNC_LOWER_64, ESR_ELx_EC_SVC64,
> +				el0_svc_handler);
> +
> +	be =3D vcpu_mixed_endian_el0(vcpu);
> +	if (be)
> +		make_el0_accessible(vm, MMIO_ADDR, vm->page_size);

[Severity: Medium]
Will this cause an immediate Instruction Abort on hardware supporting
mixed endianness at EL0?

The MMIO address is made EL0-accessible here, but the code segment
containing el0_be_loads is not. KVM selftests map the test payload
(including the .text segment) as EL1-only by default (AP[1]=3D0).

When vcpu_mixed_endian_el0() is true, guest_code() drops to EL0 using eret
to execute el0_be_loads. Since the page containing el0_be_loads lacks
unprivileged access permissions (PTE_USER), the instruction fetch at EL0
will trigger a Permission Fault.

Should the page containing el0_be_loads also be made EL0-accessible here?

> +
> +	ksft_print_header();
> +	ksft_set_plan(ARRAY_SIZE(tests) * (be ? 2 : 1));

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706115522.9549=
13-1-fuad.tabba@linux.dev?part=3D2
