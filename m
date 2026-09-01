Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0774E377A96;
	Tue,  1 Sep 2026 14:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788272150; cv=none; b=pL7Nz8T+1OEU/YOYOqgGBCPyF0Sglc2g44ruth2FcysAatLHzgNB+ivUrljy3uH4P4f+99VxArwRHHLT+76nFS66fnMySsyvRhDDL22b7nholKHwlHDBy2L+SeAJCXPIDX3PJ+5RLwpA110LGRuJ8ckMg5JOAy7rbqXL0X8O3RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788272150; c=relaxed/simple;
	bh=TmsQ9Ve01TgN68m6hr1WPJ03S+m8mLtfg3G1zzs94nQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CBfpwU8FozYv1bRYmRtnG1mMhbSxG2d5zAZu3jZ79aag52XG6GGf6MP1ygPe7A/tObfUJZOYFJMQMJoC/y7rC1MG0CTk81GnDKOVgypMpCANPvWeR1PxwHZHulpxV+cFIvztRda7IzNc4+pbIfgKvKBtdfm4UhT6qzos/31TieU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O/rrw3ve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O/rrw3ve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6921F000E9;
	Tue,  1 Sep 2026 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788272148;
	bh=vcEFJO92r+XG/50fNyci3n7g0K6boOIqvasmekniDUI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O/rrw3vemE2skCOuVtwRFcx8IqvEATHgCiImYxK+tmd30vVT/My8ujJ0nUZYfSLVb
	 sgxcFPpdNlJLFk0eJBlINVJz+unrNgQB6GIQI17WelfMeruaexUkHqx8EFvAvhISu4
	 ehB8vPtHrSkcbd2tHa41/lx44Uz0bT5ESw8R95njj1hN83q3Bq/DdwT76CVrM1jpIl
	 M+1zvqjbnq+OCi04BqiO7EKP1ddQBmX8Aof018zGdg+tu8Lghn6vBL4U9TmerJycGD
	 68SiOTxuHJKyFNJSv0hxuS2ak9YDZJuORBeVDn+z6olV7YmnOO7tW5KenZnVaBP2Zo
	 c9eS7OyfebocQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 11/11] KVM: arm64: Tag host-VA hypercall parameters
 __kern
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260901140326.3812068-12-fuad.tabba@linux.dev>
References: <20260901140326.3812068-1-fuad.tabba@linux.dev>
 <20260901140326.3812068-12-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 01 Sep 2026 14:15:47 +0000
Message-Id: <20260901141548.3D6921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The __kvm_adjust_pc hypercall translates and uses a host-provi=
ded vcpu pointer without validation, allowing a malicious host kernel to co=
rrupt protected guest state.
- [High] __pkvm_host_donate_hyp wraps fallible allocator primitives in WARN=
_ON(), allowing unprivileged host userspace to trigger a hypervisor panic.
--

commit f41e99c0d7eef41b448f7016f3b2a6ae6358d4c0
Author: Fuad Tabba <fuad.tabba@linux.dev>
Subject: KVM: arm64: Tag host-VA hypercall parameters __kern

This commit introduces the __kern sparse address space to tag host virtual
addresses passed to EL2 hypercalls. It updates the hypercall declarations
and unwrapping functions to ensure host VAs are explicitly translated
before use, preventing unchecked dereferences at EL2.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 9085f46c2880f..91e74a1a334f0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> @@ -548,9 +548,9 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_host_mkyoung_guest,
>  }
> =20
>  DEFINE_KVM_HOST_HCALL(void, __kvm_adjust_pc,
> -	struct kvm_vcpu *, vcpu)
> +	struct kvm_vcpu __kern *, vcpu)
>  {
> -	__kvm_adjust_pc(kern_hyp_va(vcpu));
> +	__kvm_adjust_pc(kern_hyp_va_host(vcpu));
>  }

[Severity: Critical]
This is a pre-existing issue, but does this hypercall fail to validate the
translated vcpu pointer?

If a compromised host kernel issues the __kvm_adjust_pc hypercall and passes
a forged virtual address, kern_hyp_va_host() could resolve it to the
physical memory of a protected VM's pkvm_hyp_vcpu structure residing in the
EL2 linear map.

Since this pointer is then used directly in __kvm_adjust_pc() to modify
flags like PENDING_EXCEPTION or INCREMENT_PC, could this allow a malicious
host to corrupt protected guest state and bypass pKVM isolation boundaries?

[ ... ]
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> index 6c8e33ebf8bb6..5cdb0318fa7ba 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
[ ... ]
> @@ -657,9 +657,9 @@ static size_t pkvm_get_hyp_vm_size(unsigned int nr_vc=
pus)
>  		size_mul(sizeof(struct pkvm_hyp_vcpu *), nr_vcpus));
>  }
> =20
> -static void *map_donated_memory_noclear(void *host_va, size_t size)
> +static void *map_donated_memory_noclear(void __kern *host_va, size_t siz=
e)
>  {
> -	void *va =3D kern_hyp_va(host_va);
> +	void *va =3D kern_hyp_va_host(host_va);
> =20
>  	if (!PAGE_ALIGNED(va))
>  		return NULL;
> @@ -671,7 +671,7 @@ static void *map_donated_memory_noclear(void *host_va=
, size_t size)
>  	return va;
>  }

[Severity: High]
This isn't a bug introduced by this patch, but can this donation path lead
to a hypervisor panic triggered by unprivileged host userspace?

Host userspace can issue KVM_CREATE_VM or KVM_CREATE_VCPU ioctls, which
trigger hypercalls like __pkvm_init_vm and __pkvm_init_vcpu. These
eventually call map_donated_memory_noclear() and __pkvm_host_donate_hyp().

Looking at arch/arm64/kvm/hyp/nvhe/mem_protect.c:__pkvm_host_donate_hyp():

	__hyp_set_page_state_range(phys, size, PKVM_PAGE_OWNED);
	WARN_ON(pkvm_create_mappings_locked(virt, virt + size, PAGE_HYP));
	WARN_ON(host_stage2_set_owner_locked(phys, size, PKVM_ID_HYP));

Both pkvm_create_mappings_locked() and host_stage2_set_owner_locked()
allocate page tables from the hypervisor's memory pool and can fail with
-ENOMEM if the pool is exhausted.

Since WARN_ON() at EL2 expands to a fatal BRK instruction, could an
unprivileged user exhaust EL2 memory and trigger these paths to crash the
entire system, rather than safely returning an error and rolling back?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260901140326.3812=
068-1-fuad.tabba@linux.dev?part=3D11
