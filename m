Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EC5272E56;
	Sat, 17 Oct 2026 11:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792235942; cv=none; b=AHI7P5WTAvnOVDWDPbZ8wujR2wzLWwlbE3S85hjzk0g0nxHKFEDqgIQ6rkszwh3dBkxqc4gxSf6KkMyNHZcR52zAFniR/Pf7b5N8S6CRxcSvhX+5hVpY3oXO7o0N1RHU9/qv+eB2Xk5YcxC9nTn70/XZsEYHmXHdHQRsF+XTRTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792235942; c=relaxed/simple;
	bh=OCTw8+vz7sEYBl55cbeccEMXfXi6zkLyAGf9HBSYQDM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=d9+lol+4KM9g/z/g0+KfpotG2eBGVUeVlhvysyIwxTrtITbw3Q8jziUC43BclcGl+ouHR1qVH8yNaBCnw1VWy+28bqm6OhMenndrBQ7ilhc1tu8SQdv8r33T1KU6+uSdXKMpeipYPXG0itVb7b+xtIxgofbBVdi7DJyx21f5wmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HQHdggwN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HQHdggwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CAB1F000C4;
	Sat, 17 Oct 2026 11:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792235940;
	bh=Z9RR8Y+9CiX/8bUs+isxOWhJ+pNGhscRtRzD48EgSvA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HQHdggwNANyKrCYQJ/GOPYT39W9E9YsKDLJJXXUPOtVZXFolZT02DzAEw5Sp62inM
	 waDc3lkoSBBTBCUSveEPGc7PZFom2Ju8ijBiSt43LZX8bjgwpnRIgp+wR9uRZd+pVp
	 /DtDWMBZCsGTt/wiZ03SX2indl8s8ZmTid5wT28gqcipqJHznsWyNavdvpYmYMBfpy
	 7OGKHgZtn8a0TELL7MOoWa+Qbn7QgRpM7/n2o3+9YJ+xf4H6eMaXBwCeoak5JQh0aW
	 9NHorAdSaZNLS6yUGXsq0ZGl9V7eYgOJtXVCL+Eu2wtEcskMmSfoMYPdakvqD0+9f9
	 gD7vO+4WuLJyw==
Message-ID: <sashiko-outbox-175488@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/5] KVM: selftests: Reserve memslot 1 for the ucall
 MMIO address
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tharit Tangkijwanichakul" <tharitt97@gmail.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261017110213.46199-5-tharitt97@gmail.com>
References: <20261017110213.46199-1-tharitt97@gmail.com>
 <20261017110213.46199-5-tharitt97@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 11:19:00 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM: selftests: memslot 1 collision in vgic_v5_lpi_ist_vm_create=
()
--

commit 9df9f60479f8451e3b508d09149c3249f3de5c98
Author: Tharit Tangkijwanichakul <tharitt97@gmail.com>

KVM: selftests: Reserve memslot 1 for the ucall MMIO address

This commit reserves memslot 1 for a read-only ucall MMIO region in
__vm_create() when KVM_CAP_READONLY_MEM is supported, and bumps
TEST_MEM_SLOT_BASE from 1 to 2.

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 9ddc047d5c275..f387100b1a19a 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -20,6 +20,7 @@
>  #include <linux/kernel.h>
> =20
>  #define KVM_UTIL_MIN_PFN	2
> +#define KVM_UCALL_MEMSLOT	1
> =20
>  u32 kvm_random_seed;
>  struct kvm_random_state kvm_rng;
> @@ -492,6 +493,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u32=
 nr_runnable_vcpus,
>  	struct userspace_mem_region *slot0;
>  	struct kvm_vm *vm;
>  	int i, flags;
> +	gpa_t mmio_gpa;
> =20
>  	kvm_set_files_rlimit(nr_runnable_vcpus);
> =20
> @@ -514,14 +516,19 @@ struct kvm_vm *__vm_create(struct vm_shape shape, u=
32 nr_runnable_vcpus,
> =20
>  	kvm_vm_elf_load(vm, program_invocation_name);
> =20
> -	/*
> -	 * TODO: Add proper defines to protect the library's memslots, and then
> -	 * carve out memslot1 for the ucall MMIO address.  KVM treats writes to
> -	 * read-only memslots as MMIO, and creating a read-only memslot for the
> -	 * MMIO region would prevent silently clobbering the MMIO region.
> +	/* KVM treats writes to read-only memslots as MMIO, and creating
> +	 * a read-only memslot for the MMIO region would prevent silently
> +	 * clobbering the MMIO region.
>  	 */
>  	slot0 =3D memslot2region(vm, 0);
> -	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_siz=
e);
> +	mmio_gpa =3D slot0->region.guest_phys_addr + slot0->region.memory_size;
> +	ucall_init(vm, mmio_gpa);
> +
> +	if (vm_check_cap(vm, KVM_CAP_READONLY_MEM))
> +		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
> +					    mmio_gpa, KVM_UCALL_MEMSLOT,
> +					    vm_adjust_num_guest_pages(vm->mode, 1),
> +					    KVM_MEM_READONLY);

[Severity: Medium]
Does reserving KVM_UCALL_MEMSLOT (slot 1) in __vm_create() collide with
VGIC_V5_LPI_MEMSLOT in tools/testing/selftests/kvm/arm64/vgic_v5.c?

In tools/testing/selftests/kvm/arm64/vgic_v5.c, VGIC_V5_LPI_MEMSLOT is
hardcoded to 1 instead of using TEST_MEM_SLOT_BASE:

    #define VGIC_V5_LPI_MEMSLOT	1

When test_vgic_v5_lpis() or test_vgic_v5_ist_save_restore() runs,
vgic_v5_lpi_ist_vm_create() creates the VM via __vm_create() (which
populates slot 1 because arm64 unconditionally supports
KVM_CAP_READONLY_MEM) and then attempts to add a memslot at
VGIC_V5_LPI_MEMSLOT:

    v->vm =3D __vm_create(VM_SHAPE_DEFAULT, VGIC_V5_LPI_NR_VCPUS, 0);
    ...
    vm_userspace_mem_region_add(v->vm, VM_MEM_SRC_ANONYMOUS,
                                VGIC_V5_LPI_IST_BASE_GPA,
                                VGIC_V5_LPI_MEMSLOT,
                                nr_lpi_ist_pages, 0);

Inside vm_userspace_mem_region_add() -> vm_mem_add(), the duplicate slot
check in vm->regions.slot_hash finds KVM_UCALL_MEMSLOT in slot 1 and
aborts the test with TEST_FAIL("A mem region with the requested slot
already exists...").

Should VGIC_V5_LPI_MEMSLOT be defined in terms of TEST_MEM_SLOT_BASE as
well?

> =20
>  	if (kvm_random_seed !=3D last_kvm_seed)
>  		kvm_seed_rng(kvm_random_seed);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017110213.4619=
9-1-tharitt97@gmail.com?part=3D4
