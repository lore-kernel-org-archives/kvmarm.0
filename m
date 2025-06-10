Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD1E2EB11
	for <kvmarm@lists.linux.dev>; Tue, 10 Jun 2025 06:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749538693; cv=none; b=jhs/TRF8ORXqmFT4gs5CZ0JAQijIzMPnsbWViJEUAnxpugRtjJDMfRtKJW03ggWdydcYSs07wapTG7sOdhL++FuPK8SR0K/vIdoCLbayZUG7kytmkS+ylyQJUm331eqTyXycz9Ru8tqtktLaD0MCtUhln7kI/kpYCVaDQ466wwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749538693; c=relaxed/simple;
	bh=3OJkrlPOWBPcWNGSbl3jwyWwUd+/V0q6GnmXFUSiD4s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mj/Zi2+O/FrY2rZujeEDFb2ghLgy3SkbL2fVgazbYvDQA5WPjrni/7bgeo6VEPKUCNaQK9/siqoaLroFlRaYVZfA7MyQEu+ArHoEKkl8ACS+UzMrdVb2BIFFizn0yNUqp/WagZZXGO7pwMcRoY9DXSR/tCRSWmZgjZS9Vk/263w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cicVUOpx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cicVUOpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD79C4CEEF;
	Tue, 10 Jun 2025 06:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749538693;
	bh=3OJkrlPOWBPcWNGSbl3jwyWwUd+/V0q6GnmXFUSiD4s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=cicVUOpx2eECVFuPgXLiNe9Xi9Btdp2iB2YJYC7LUNd0EqPEGVvuOZ5//A2jJgVl1
	 ouDCZo7fdwLqQgb901JMQrTKhQrHy/4YdfyUMRJoOSnacTx4y/BPPwPxc4DInrNp/G
	 BHDxdm3IESC5JjdGseOFcv4w/RUfBt+Rl8drVzE9hJDM3Zqni0KixkJ51/t60Rn7cF
	 5yhDhznAcqM59wxs9Tcx3qLCR6Y4eeDAyhccYg+RZ0dg1n9aeyb4Xoza7Rpxgm691j
	 rjgd6kgoWm31ieSFYMtohSewgZfxwYIs5Bl5sCn7vAhas5FAJryxM1JySep0jkD+ST
	 xhTa+QgsFBqHw==
X-Mailer: emacs 30.1 (via feedmail 11-beta-1 Q)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: Re: pkvm boot failures
In-Reply-To: <aEcY-1Iv8S-e8LVi@google.com>
References: <yq5ah60pkq03.fsf@kernel.org> <aEcY-1Iv8S-e8LVi@google.com>
Date: Tue, 10 Jun 2025 12:03:13 +0530
Message-ID: <yq5aecvskswm.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mostafa Saleh <smostafa@google.com> writes:

> On Mon, Jun 09, 2025 at 06:53:40PM +0530, Aneesh Kumar K.V wrote:
>>=20
>> I am hitting the below failure with v6.15 (I tried other kernel versions
>> with similar results). I disabled CONFIG_PROTECTED_NVHE_STACKTRACE
>> because with CONFIG_NVHE_EL2_DEBUG, the stack was pointing at
>> hyp_assert_lock_held() .
>>=20
>> [    0.664457] kvm [1]: nVHE hyp panic at: [<ffff80008050b10c>] __kvm_nv=
he_handle_trap+0x34/0x10c!
>> [    0.664538] kvm [1]: Cannot dump pKVM nVHE stacktrace: !CONFIG_PROTEC=
TED_NVHE_STACKTRACE
>> [    0.664566] kvm [1]: Hyp Offset: 0xffff000007c00000
>> [    0.664631] Kernel panic - not syncing: HYP panic:
>> [    0.664631] PS:614023c9 PC:000080007890b10c ESR:0000000096000007
>> [    0.664631] FAR:0000800078c252f0 HPFAR:0000000000000000 PAR:000000000=
0000000
>> [    0.664631] VCPU:0000000000000000
>> [    0.664938] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.15.0-r=
c1 #594 NONE=20
>> [    0.665068] Hardware name: FVP Base RevC (DT)
>> [    0.665140] Call trace:
>> [    0.665196]  show_stack+0x18/0x24 (C)
>> [    0.665346]  dump_stack_lvl+0x3c/0x80
>> [    0.665468]  dump_stack+0x18/0x24
>> [    0.665588]  panic+0x124/0x2d8
>> [    0.665699]  nvhe_hyp_panic_handler+0x108/0x180
>> [    0.665825]  do_pkvm_init+0xb0/0x124
>> [    0.665957]  do_pkvm_init+0xb0/0x124
>> [    0.666089]  kvm_hyp_init_protection+0x5c/0x6c
>> [    0.666226]  init_hyp_mode+0x760/0x790
>> [    0.666362]  kvm_arm_init+0xac/0x23c
>> [    0.666492]  do_one_initcall+0xa0/0x1f0
>> [    0.666617]  do_initcall_level+0x8c/0xac
>> [    0.666753]  do_initcalls+0x54/0x94
>> [    0.666885]  do_basic_setup+0x18/0x24
>> [    0.667019]  kernel_init_freeable+0xc0/0x10c
>> [    0.667157]  kernel_init+0x20/0x118
>> [    0.667271]  ret_from_fork+0x10/0x20
>> [    0.667400] SMP: stopping secondary CPUs
>> [    0.667475] Kernel Offset: disabled
>> [    0.667534] CPU features: 0x0000,00000140,064dc298,cb7a552f
>> [    0.667619] Memory Limit: none
>> [    0.667681] ---[ end Kernel panic - not syncing: HYP panic:
>> [    0.667681] PS:614023c9 PC:000080007890b10c ESR:0000000096000007
>> [    0.667681] FAR:0000800078c252f0 HPFAR:0000000000000000 PAR:000000000=
0000000
>> [    0.667681] VCPU:0000000000000000 ]
>>=20
>> I was able to locate a .config that make the pkvm work, But i am not
>> able to identify which config dependency is making the difference. I am
>> attaching below the working and non working kernel configs. I am using
>> FVP to test this.
>>=20
>
> I had a look at this and tracked the issue to "CONFIG_JUMP_LABEL=3Dn"
> It seems that it panics at
> 	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> Where "kvm_protected_mode_initialized" is mapped in the initial PGD for t=
he
> hypervisor, but not mapped in the hypervisor created one.
> As the variable is defined outside the hypervisor namespace, it doesn=E2=
=80=99t exist
> in the hyp bss section.
> And in case of "CONFIG_JUMP_LABEL=3Dn" it  won't be patched in this case,=
 causing
> next access to read the variable and panicking.
>
> I guess moving this key to hyp would cause problems with kernel access af=
ter
> de-privilege as cases from kvm_share_hyp(), So I can only think of having=
 a
> different key for the hypervisor as
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 8e8848de4d47..8945b335bcea 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -21,6 +21,7 @@
>  #include <nvhe/trap_handler.h>
>=20=20
>  DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_init_params);
> +DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized_hyp);
>=20=20
>  void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
>=20=20
> @@ -626,7 +627,7 @@ static void handle_host_hcall(struct kvm_cpu_context =
*host_ctxt)
>  	 * basis. This is all fine, however, since __pkvm_prot_finalize
>  	 * returns -EPERM after the first call for a given CPU.
>  	 */
> -	if (static_branch_unlikely(&kvm_protected_mode_initialized))
> +	if (static_branch_unlikely(&kvm_protected_mode_initialized_hyp))
>  		hcall_min =3D __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize;
>

There are other references to kvm_protected_mode_initialized within
nvhe. Shouldn't all of those be updated as well?

Also, do we need to drop this line?

KVM_NVHE_ALIAS(kvm_protected_mode_initialized);

If I understand correctly, nvhe will now have a separate static key,
distinct from the one used by the EL1 host. So we'll need to update
functions like is_pkvm_initialized() and host_data_ptr() accordingly,
right?

>=20=20
>  	id &=3D ~ARM_SMCCC_CALL_HINTS;
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index fcd70bfe44fb..af0854e98902 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -17,6 +17,7 @@
>  #include "hyp_constants.h"
>=20=20
>  DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
> +DECLARE_STATIC_KEY_FALSE(kvm_nvhe_sym(kvm_protected_mode_initialized_hyp=
));
>=20=20
>  static struct memblock_region *hyp_memory =3D kvm_nvhe_sym(hyp_memory);
>  static unsigned int *hyp_memblock_nr_ptr =3D &kvm_nvhe_sym(hyp_memblock_=
nr);
> @@ -229,6 +230,7 @@ static int __init pkvm_drop_host_privileges(void)
>  	 * once the host stage 2 is installed.
>  	 */
>  	static_branch_enable(&kvm_protected_mode_initialized);
> +	static_branch_enable(&kvm_nvhe_sym(kvm_protected_mode_initialized_hyp));
>  	on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
>  	return ret;
>  }
>
> --
>
> Can you please check if that helps in your case?
>
> Thanks,
> Mostafa
>

-aneesh
