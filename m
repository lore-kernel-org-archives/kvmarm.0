Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D0E47F762;
	Sat, 17 Oct 2026 11:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792235766; cv=none; b=HwGKuxJWo2sI/ATuqW6JBUyrL8HuVnzX5vgF3h/mPPH44w68Ov4v8jjHnroIqdS9t3BVzLVTICojc9wYq+2CxUoW/jF4LmGt7h4k49/YxWCOFpLkf3A3tF2NxknRtp9yB6DJ0XnI9fs+0isQNfHrBdZHaEmDdxg3cN9ePyp3PEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792235766; c=relaxed/simple;
	bh=3EvYUPTtuBeGYGlmtIDuQvn5OBQK+ly46/cvOUyuRnY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=iAgTIDuJ9KtqejHJOvRgm1V0CL1Vbo5Wv8spNDTZx6u645mwYgmILm+kxrwlXm4Q3lgdf8iUI2HVI9IDttYDBe1ilsGcS2IbeZgyBeWyOn0UvMHlxs+VikzE33Dkv5lXwbzujpP+l19yVxvhkGuAtRQP4f4yFya9D8JkHMCtJLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KzR9odZy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KzR9odZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC7B1F000C4;
	Sat, 17 Oct 2026 11:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792235764;
	bh=5iHFTgph1tssQzabPABKv3rWUcMMnMkXEapqj/fCyZM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KzR9odZyQVRfnGsXojjaWZi0qHm/ndMDD6UVCCjok6UWzdcJzOolyTGy5VeuQvx4E
	 FhNOoydS0Qo5963tRU7+6irhiWD9Te6reLWgiwQPM+oqX6daJwlKr+g7QVWorIC6uV
	 b/ldIHDqPl6bEHTczrF41lgimO90Tid5NRkvtPM88srq4RgYA1OyD8Y/51+oth6ORt
	 ZTU94fO+o/4pBH/uPZKtajrPJ0ddyWl++EzoRxwtqUrU/hCRlPeEul0Tzegt0Avycy
	 uAiHcw2csSk7PYvkj94ZW0KYBUBdTddO+YvxHYR3oFUSsAcer+AbquskyE0ZMZHRAS
	 NIodw+K8NBGww==
Message-ID: <sashiko-outbox-175486@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] KVM: selftests: Test protection of the ucall MMIO
 region
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tharit Tangkijwanichakul" <tharitt97@gmail.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261017110213.46199-6-tharitt97@gmail.com>
References: <20261017110213.46199-1-tharitt97@gmail.com>
 <20261017110213.46199-6-tharitt97@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 11:16:03 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Medium] KVM: selftests: new standalone reserved_slot_test for single mem=
slot check
- [Medium] KVM: selftests: reserved_slot_test omitted from TEST_GEN_PROGS_l=
oongarch
- [Medium] KVM: selftests: reserved slot 1 in __vm_create() conflicts with =
vgic_v5
- [Low] KVM: selftests: open-coded kvm_munmap() and exit reason checks in t=
est
--

commit 73bef34a870afd5da66eced7325a3e568ddcd08a
Author: Tharit Tangkijwanichakul <tharitt97@gmail.com>

KVM: selftests: Test protection of the ucall MMIO region

This commit adds a new selftest to verify that creating a memslot overlappi=
ng
the ucall MMIO region fails with EEXIST and that ucalls continue to work
before and after the attempt.

> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/sel=
ftests/kvm/Makefile.kvm
> index 1f4bc2a1322d8..ff4a5e9733e9f 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -68,6 +68,7 @@ TEST_GEN_PROGS_COMMON +=3D set_memory_region_test
>  TEST_GEN_PROGS_COMMON +=3D memslot_modification_stress_test
>  TEST_GEN_PROGS_COMMON +=3D memslot_perf_test
>  TEST_GEN_PROGS_COMMON +=3D vm_types_test
> +TEST_GEN_PROGS_COMMON +=3D reserved_slot_test
> =20
>  # Compiled test targets
>  TEST_GEN_PROGS_x86 =3D $(TEST_GEN_PROGS_COMMON)

[Severity: Medium]
Should reserved_slot_test also be added to TEST_GEN_PROGS_loongarch?

In tools/testing/selftests/kvm/Makefile.kvm, TEST_GEN_PROGS_COMMON is
included by x86, arm64, s390, and riscv, whereas TEST_GEN_PROGS_loongarch
lists its targets explicitly without including $(TEST_GEN_PROGS_COMMON).

Because main() requires UCALL_EXIT_REASON =3D=3D KVM_EXIT_MMIO, and across
tools/testing/selftests/kvm/include/*/ucall.h only arm64 and loongarch defi=
ne
UCALL_EXIT_REASON as KVM_EXIT_MMIO, adding this target only to
TEST_GEN_PROGS_COMMON leaves it unbuilt on LoongArch while building it on
x86, s390, and riscv where it unconditionally skips.

> diff --git a/tools/testing/selftests/kvm/reserved_slot_test.c b/tools/tes=
ting/selftests/kvm/reserved_slot_test.c
> new file mode 100644
> index 0000000000000..4a908017ca73d
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/reserved_slot_test.c
> @@ -0,0 +1,61 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "kvm_util.h"
> +#include "processor.h"
> +#include "test_util.h"
> +
> +#define CLOBBERED_SLOT		TEST_MEM_SLOT_BASE

[Severity: Medium]
In the earlier commits of this series ("KVM: selftests: Introduce a shared
base for test memslots" and "KVM: selftests: Reserve memslot 1 for the ucall
MMIO address"), TEST_MEM_SLOT_BASE was bumped to 2 and __vm_create() in
tools/testing/selftests/kvm/lib/kvm_util.c was updated to reserve
KVM_UCALL_MEMSLOT (slot 1) when KVM_CAP_READONLY_MEM is supported:

	if (vm_check_cap(vm, KVM_CAP_READONLY_MEM))
		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
					    mmio_gpa, KVM_UCALL_MEMSLOT,
					    vm_adjust_num_guest_pages(vm->mode, 1),
					    KVM_MEM_READONLY);

However, tools/testing/selftests/kvm/arm64/vgic_v5.c still defines
VGIC_V5_LPI_MEMSLOT as 1 instead of TEST_MEM_SLOT_BASE:

#define VGIC_V5_LPI_MEMSLOT	1

When vgic_v5_lpi_ist_vm_create() calls __vm_create() followed by
vm_userspace_mem_region_add() with VGIC_V5_LPI_MEMSLOT, won't vm_mem_add()
find slot 1 already present in vm->regions.slot_hash and abort with
TEST_FAIL() on arm64?

> +
> +static void guest_code(void)
> +{
> +	GUEST_SYNC(1);
> +	GUEST_SYNC(2);
> +}
> +
> +static void test_slot1_protected(void)
> +{
> +	struct kvm_vcpu *vcpu;
> +	struct kvm_run *run;
> +	struct kvm_vm *vm;
> +	struct ucall uc;
> +	u32 nr_pages;
> +	size_t slot_size;
> +	void *slot_mem;
> +	int ret;
> +
> +	vm =3D vm_create_with_one_vcpu(&vcpu, guest_code);
> +	nr_pages =3D vm_adjust_num_guest_pages(vm->mode, 1);
> +	slot_size =3D (size_t)nr_pages * vm->page_size;
> +
> +	run =3D vcpu->run;
> +	vcpu_run(vcpu);
> +	TEST_ASSERT(run->exit_reason =3D=3D KVM_EXIT_MMIO,
> +		    "Unexpected exit reason =3D %u", run->exit_reason);
> +	TEST_ASSERT(get_ucall(vcpu, &uc) =3D=3D UCALL_SYNC && uc.args[1] =3D=3D=
 1,
> +		    "Expected the first sync before clobbering the ucall GPA");
> +
> +	slot_mem =3D kvm_mmap(slot_size, PROT_READ | PROT_WRITE,
> +			    MAP_PRIVATE | MAP_ANONYMOUS, -1);
> +	ret =3D __vm_set_user_memory_region2(vm, CLOBBERED_SLOT, 0,
> +					   vm->ucall_mmio_addr, slot_size, slot_mem, 0, 0);
> +	TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EEXIST,
> +		    "Expected the ucall GPA overlap to be rejected: ret=3D%d errno=3D%=
d",
> +		    ret, errno);

[Severity: Medium]
Could this check be added as a subtest in
tools/testing/selftests/kvm/set_memory_region_test.c instead of introducing=
 a
separate reserved_slot_test binary?

set_memory_region_test.c already exercises KVM_SET_USER_MEMORY_REGION and
KVM_SET_USER_MEMORY_REGION2 error handling and overlapping memslot rejectio=
n,
whereas having a separate binary for this single check adds build and test
overhead for a target that immediately skips on most architectures in
TEST_GEN_PROGS_COMMON.

> +
> +	vcpu_run(vcpu);
> +	TEST_ASSERT(run->exit_reason =3D=3D KVM_EXIT_MMIO,
> +		    "Unexpected exit reason =3D %u", run->exit_reason);
> +	TEST_ASSERT(get_ucall(vcpu, &uc) =3D=3D UCALL_SYNC && uc.args[1] =3D=3D=
 2,
> +		    "Expected the second sync after attempting to clobber the ucall GP=
A");
> +
> +	kvm_vm_free(vm);
> +	TEST_ASSERT(!munmap(slot_mem, slot_size), "munmap() failed, errno=3D%d"=
, errno);
> +}

[Severity: Low]
This isn't a bug, but could test_slot1_protected() use
TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_MMIO) from include/test_util.h f=
or
the two exit reason checks, and kvm_munmap(slot_mem, slot_size) from
include/kvm_syscalls.h to pair with kvm_mmap()?

> +
> +int main(void)
> +{
> +	TEST_REQUIRE(UCALL_EXIT_REASON =3D=3D KVM_EXIT_MMIO);
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_READONLY_MEM));
> +
> +	test_slot1_protected();
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017110213.4619=
9-1-tharitt97@gmail.com?part=3D5
