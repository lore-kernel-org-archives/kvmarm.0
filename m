Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795575769;
	b=q61Xo/OdL8iuE23SOfsDiAnQS9oeQ3oKGT8HODyp5Dh7lnVNiAhIXfIB+ihkaZKO9Kzs
	 jjiEHuJWoQaJ2v2vG0pNJk4janTzACQMqcI2iqevsnHDnfJNwZDTObaA8K9Ck91ssoteN
	 GESjntTCILya71GbZBTv+8K95r+otyuoxPv/dOXnwxtmNkQIb3O2H+S81qebA6KW40dWh
	 cdb0hMlQfjtXGeKDzCk4TmzYKWc40SGvEp1lnT+adZkDPC3JZ3ld5hGTSJiqwTT9XgCtd
	 0XImQjSMrUwH47Gi4qyvgm4uf7PRMtxfQp08gsrw94Z/L7QhZukslHauALHSuylpz/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795575769;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=ZlJ+QNgY2eTHL284R0Wbw5HiO+XpfwNUzEm+JNX8OsY=;
	b=4NWm9uW2YPJfyFZqpuhvgM8AeYVptw4nQui9rwJ6dsldGveHStlUBpDPhLrOh9f7VDq0
	 r7apZBp6cZdF+bGhPTsjp9pCk9CCSB7Y9b9T8BVJBrqYM/s22zkCSI1gjhv2Wp/ut0yTA
	 FjkW1u8n0IgBb7YdYyYZbvskJaDDyH1ywigYkKk0YDzV6Xoz/5NVaktjb/+YzymrjAGz+
	 1UBZLGzqMqIAVeln1NqRO0AiUyurdOw0SR2pp2VuYC1IGUT7pTde+A/lEzGlywWqtdErp
	 kWIpOA0qyAkWcfTRj4KRmrrfmNzZrcqlM8RW+WGXRMVLlRPsWtSkjAEqY+gV/74C+EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DIBam8tJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DE7606A321;
	Wed, 25 Nov 2026 03:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DIBam8tJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3311F000EF;
	Wed, 25 Nov 2026 03:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795575768;
	bh=ZlJ+QNgY2eTHL284R0Wbw5HiO+XpfwNUzEm+JNX8OsY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DIBam8tJqFf/pCR0U3cgTzDFY24t5PhkTuzO76WpTobCG0xoHen8trwY8NSk5Ltas
	 Ju6yHOMNqeHZ6+oxSTiNeafhTeJETjM1V8q7Jwbi7cYLkMX9UCSbDg/dYanbDLINJ0
	 /uuxrHT1kKi65A6tSas+tBLgR+doEfKxHFIFXcqrx1731xW4dzLVnQ4Y38b3tuS/2g
	 N+C1/yYsVBQV8yJkfhop7bzI61gE02kMIqvjTBvfp+i0W8lDIbtryxtOFtxLDUksEQ
	 gOj14msU//F+3AQO6sFTHFq2bSWxb776zlSOf7ub5mhzmKxku8jjQiIgaXLccX439W
	 ILqJAfEZYFMQQ==
Message-ID: <sashiko-outbox-232440@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] KVM: arm64: selftests: Add a test for VNCR_EL2
 translation faults
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jia He" <justin.he@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261125024426.3464050-3-justin.he@arm.com>
References: <20261125024426.3464050-1-justin.he@arm.com>
 <20261125024426.3464050-3-justin.he@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 03:02:40 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] KVM: arm64: selftests: nv_vncr_abort fails on 16K and 64K
  host page sizes
--

commit 771173f048bfbff4d1afde9bc6d9374d48302af1
Author: Jia He <justin.he@arm.com>

KVM: arm64: selftests: Add a test for VNCR_EL2 translation faults

This commit adds an arm64 KVM selftest for VNCR_EL2 stage-1 translation
faults and hardware access flag updates when the last-level page table is in
a read-only or writable memslot.

> diff --git a/tools/testing/selftests/kvm/arm64/nv_vncr_abort.c b/tools/te=
sting/selftests/kvm/arm64/nv_vncr_abort.c
> new file mode 100644
> index 0000000000000..d2052b1526111
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/arm64/nv_vncr_abort.c
[ ... ]
> +static void setup_vncr_page(struct kvm_vm *vm, enum test_mode mode)
> +{
> +	u64 oa_mask =3D GENMASK_ULL(47, 12);
> +	gpa_t data_gpa, table_gpa;
> +	u64 *l2e, *table;
> +	int idx =3D (VNCR_VA >> 12) & 511;
> +
> +	data_gpa =3D vm_phy_page_alloc(vm, MEM_REGION_DATA);
> +	virt_pg_map(vm, VNCR_VA, data_gpa);
> +	*(u64 *)(addr_gpa2hva(vm, data_gpa) + VNCR_VTTBR_EL2) =3D VNCR_MAGIC;
> +
> +	l2e =3D virt_get_pte_hva_at_level(vm, VNCR_VA, 2);
> +	TEST_ASSERT((*l2e & 3) =3D=3D 3, "level 2 entry is not a table: %lx", *=
l2e);
> +	table_gpa =3D *l2e & oa_mask;
> +	table =3D addr_gpa2hva(vm, table_gpa);
> +
> +	if (mode =3D=3D RW_PT_AF_CLEAR) {
> +		table[idx] &=3D ~PTE_AF;
> +		return;
> +	}
> +
> +	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, RO_PT_GPA,
> +				    RO_PT_SLOT, 1, KVM_MEM_READONLY);
> +	memcpy(addr_gpa2hva(vm, RO_PT_GPA), table, vm->page_size);
> +	if (mode =3D=3D RO_PT_AF_CLEAR)
> +		((u64 *)addr_gpa2hva(vm, RO_PT_GPA))[idx] &=3D ~PTE_AF;
> +
> +	*l2e =3D (*l2e & ~oa_mask) | RO_PT_GPA;
> +}
> +
> +static void sigalrm_handler(int sig)
> +{
> +}
> +
> +static void run_test(enum test_mode mode)
> +{
> +	struct kvm_vcpu_init init;
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +	u64 mmfr1;
> +	int ret;
> +
> +	vm =3D vm_create(1);
> +	kvm_get_default_vcpu_target(vm, &init);
> +	init.features[0] |=3D BIT(KVM_ARM_VCPU_HAS_EL2);
> +	vcpu =3D aarch64_vcpu_add(vm, 0, &init, guest_code);
> +	kvm_arch_vm_finalize_vcpus(vm);
> +
> +	mmfr1 =3D vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_ID_AA64MMFR1_EL1));
> +	__TEST_REQUIRE(SYS_FIELD_GET(ID_AA64MMFR1_EL1, HAFDBS, mmfr1),
> +		       "Hardware AF management not supported");
> +	TEST_REQUIRE(vm->page_size =3D=3D 4096);

[Severity: Medium]
Will this test fail on 16K and 64K host kernels when the CPU supports a 4K
stage-1 translation granule?

guest_modes_append_default() selects VM_MODE_P40V48_4K whenever the CPU
supports a 4K granule regardless of the host page size, so vm->page_size is
4096 and TEST_REQUIRE(vm->page_size =3D=3D 4096) does not skip on 16K or 64K
hosts.

Passing npages =3D 1 to vm_userspace_mem_region_add() in setup_vncr_page() =
then
hits the assertion in vm_mem_add() requiring npages to cover at least one
host page:

tools/testing/selftests/kvm/lib/kvm_util.c:vm_mem_add() {
    ...
	TEST_ASSERT(vm_adjust_num_guest_pages(vm->mode, npages) =3D=3D npages,
		"Number of guest pages is not compatible with the host. "
		"Try npages=3D%d", vm_adjust_num_guest_pages(vm->mode, npages));
    ...
}

Also, in RW_PT_AF_CLEAR mode, vm_phy_page_alloc() returns a 4K-aligned
data_gpa that is not aligned to a 16K or 64K host page, while KVM maps the
containing host pfn at the VNCR fixmap and takes the page offset from
VNCR_VA & (PAGE_SIZE - 1) (which is 0), reading from the start of the host
page instead of data_gpa.

Should run_test() check TEST_REQUIRE(getpagesize() =3D=3D 4096), or size
RO_PT_SLOT with vm_adjust_num_guest_pages() and align data_gpa to the host
page size?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125024426.3464=
050-1-justin.he@arm.com?part=3D2
