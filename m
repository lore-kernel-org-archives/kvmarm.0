Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202F512D21B;
	Sat, 17 Oct 2026 11:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792235659; cv=none; b=ufuoysOB01BAAEQWzZQ13uAUEAUgmCg8JIRLBncZVebI5ZqbQV+CbjqPKtysLQhNByRzkBaJTGlX0whZ/2o3Ma1yV+X61lUyYbUiEKaM2qUfMWbC9VxnJQPl/sH7oxjvFV4VhmDG6kgmGzVAiSnEpGB4vNSjxx/PDhFHtvXIUDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792235659; c=relaxed/simple;
	bh=27qYEWcaYHNGonml4D5K68tHrUSuaT21w9HCY1xaNBU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=fhm/zAmriR9weudcuajpzlPlqAESZtp75f+twOdOo5pQuRSYNeBxmHzLiioaevNM1rBu8wDgeekXYYIS8hACewtgIoAfzYh3SGV6osOEp5YumwI3cy3eulAXDZB8kco+uY7Ju64H+mWeTN41H3jyzva3aK26Jrd4ArPempEq9as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SeR5sB7d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SeR5sB7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999511F000C4;
	Sat, 17 Oct 2026 11:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792235657;
	bh=HWA1EPCwGy3APFR44OSkLbVDVGdqarDYLrfZpg+csug=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SeR5sB7dRghlcHoXtyFmW6MJPIZ/zyEMo+fD02Q24uH/3HDKW0dLRzrkgUqBGKhfU
	 zcYRjfp6b5mmrLOUKWlojS4CGrGGlI+7eT7250+iuXkXUnoFe/YCSIlJgxR1PaS/tz
	 rNSzWg66ISCyK6/6Zb5yzaSV/ZMR4rt4+yLbX3XJfwVSJVGC6SAe2AYiYngobENKXb
	 n261Ed7bs65LSr3YUbIDxirYsH+CaeQIR+hTKTPc4ecKP8I4U55Kqc5ax+P1ADS13S
	 sDCZNiVh8lOSvmAnN2EzGnUzgpuQwzksMtrBXya8LnGZyqxlnKCnhzw6y+ZKiPQLyn
	 vPk35fUDbL3Vw==
Message-ID: <sashiko-outbox-175484@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/5] KVM: selftests: Introduce a shared base for test
 memslots
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tharit Tangkijwanichakul" <tharitt97@gmail.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261017110213.46199-2-tharitt97@gmail.com>
References: <20261017110213.46199-1-tharitt97@gmail.com>
 <20261017110213.46199-2-tharitt97@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 11:14:17 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] KVM: selftests: missing TEST_MEM_SLOT_BASE conversion in arm64/v=
gic_v5.c
--

commit ad2bd092653828da36ea26266908671dbd05d3f3
Author: Tharit Tangkijwanichakul <tharitt97@gmail.com>

KVM: selftests: Introduce a shared base for test memslots

This commit introduces TEST_MEM_SLOT_BASE and replaces hardcoded memslot 1
assignments across KVM selftests to prepare for reserving slot 1 for library
use.

[ ... ]

> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
> index 5a7a455b53875..759d604d44ce9 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -30,6 +30,7 @@
> =20
>  #define KVM_DEV_PATH "/dev/kvm"
>  #define KVM_MAX_VCPUS 512
> +#define TEST_MEM_SLOT_BASE 1
> =20
>  #define NSEC_PER_SEC 1000000000L
> =20

[Severity: Medium]
Should tools/testing/selftests/kvm/arm64/vgic_v5.c also be updated to use
TEST_MEM_SLOT_BASE?

Currently it defines VGIC_V5_LPI_MEMSLOT as 1:

tools/testing/selftests/kvm/arm64/vgic_v5.c:
    #define VGIC_V5_LPI_MEMSLOT	1

and in vgic_v5_lpi_ist_vm_create(), it creates the VM with __vm_create() and
adds the LPI IST memslot at VGIC_V5_LPI_MEMSLOT:

    v->vm =3D __vm_create(VM_SHAPE_DEFAULT, VGIC_V5_LPI_NR_VCPUS, 0);
    ...
    vm_userspace_mem_region_add(v->vm, VM_MEM_SRC_ANONYMOUS,
                                VGIC_V5_LPI_IST_BASE_GPA,
                                VGIC_V5_LPI_MEMSLOT,
                                nr_lpi_ist_pages, 0);

Once the follow-up commit ("KVM: selftests: Reserve memslot 1 for the ucall
MMIO address") reserves slot 1 (KVM_UCALL_MEMSLOT) inside __vm_create() when
KVM_CAP_READONLY_MEM is supported (which is unconditionally enabled on
arm64), won't test_vgic_v5_lpis() and test_vgic_v5_ist_save_restore()
collide on slot 1 and fail in vm_mem_add() with TEST_FAIL() because the
memslot already exists in vm->regions.slot_hash?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017110213.4619=
9-1-tharitt97@gmail.com?part=3D1
