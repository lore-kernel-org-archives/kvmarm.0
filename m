Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793897566;
	b=vC3AbajYnZ5us3P+HelNB6U9BoPqQl9yb8W3tIcU+MhDpHz0EHmFkdn8ciUXrKRVTc1f
	 lr1jb9OxZGKhzJHnMfaqbWpxcQBhyaLoGbWmQfs7ElzyEzXRjpgjwARqC7QkWt4ZQ9++D
	 3XLT92FdhCt9eX9VTHCAC82hTiEHYAtOAn8koiyMuxMy3HGl7v1uQS81+NiS9q4+c/vD9
	 vUROkArDmm+V/NbFx1BBKtzuO68YjQtzJ+42DNyPcdjmgaFRMB1OZTLTdXnVxmq05lAbD
	 FXJtbwCJ4s6i50ovF5PfokxBxDN7TjOiXDiL2hULEVMtqlP0BA8GSrRsEFuKK7n9YzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793897566;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=fVOwT2J+od3H7hOrDMRcALEBGpShVHk+/+H7TMrc+vg=;
	b=s2BDBs3itnOCEfyFX7xi1IXCFV6IRyaQPO7AbcqOVMYku4rIFMfbh8ex/4cfEFWLpPik
	 4WMINTTT7aZqXCwDf7TIA+7soNqydDYSPaNz1RyWmXwjtosKKZGRHKM6euAN69GACbSVD
	 srKEyUlQqrKcvzpoWUAr1IO76RvJrZ7IPRJhdnPpe7CDgsLpjtG7kWJvQ7mo3JRvUfyPa
	 mvCXyBd8GGnhcMpdLNUxgbDrQtQllrOKTSns3xAY9UEezxAejl3dU8+N3FZ0+1NoOL94K
	 BL7+gXs6waWH4LTmbinOqANYOfbJqZF1PG2r4GpQTRbExRS6wwZOpUUqaSgjh1V0VNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TmXj4IDO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4816606A31B
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 16:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TmXj4IDO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F6D1F00A15;
	Thu,  5 Nov 2026 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793897565;
	bh=fVOwT2J+od3H7hOrDMRcALEBGpShVHk+/+H7TMrc+vg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TmXj4IDOuBfutiN9cQDhSU+MAtNOJuLmfbZzrjkNpPiOoR2Wj+PaPuDOQYMYOkVxq
	 Cv/k16hg7Uzqt6YS8bnvWR7lwcEVGOVTQux4OG0ov0Z1iN5aGoG9GgDWRGt98qyDWS
	 NKWiq5T2nf7hYoFYi8MXD+T5k3/phhAmd//4/EaiNT4lnl4EE/4mrJCoxhcI+L1Rha
	 VJmmtJDokziST3zi9NDWAvWIbY+KKnMA1s+4PQKuWPj7FBqDlazgS37ESHcrb48xl0
	 +asZgP/9U6q8LeOJrug/iNGgeTaHYfoegLwsHuKuX6Vp7X6pPL3sWV7QB9wqY6l1iT
	 fxgbJf60qqV2Q==
Message-ID: <sashiko-outbox-199540@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 02/14] mm: Zero memory during shared memory
 transitions
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5lZXNoIEt1bWFyIEsuViAoQXJtKQ==?= <aneesh.kumar@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Baoquan He" <baoquan.he@linux.dev>, "Mike
 Rapoport" <rppt@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Joerg Roedel" <joro@8bytes.org>, "Marc Zyngier" <maz@kernel.org>, "Marek
 Szyprowski" <m.szyprowski@samsung.com>, "Robin Murphy" <robin.murphy@arm.com>, "Steven
 Price" <steven.price@arm.com>, "Sumit Semwal" <sumit.semwal@linaro.org>, "Suzuki
 K Poulose" <suzuki.poulose@arm.com>, "Thomas Gleixner" <tglx@kernel.org>, "Will
 Deacon" <will@kernel.org>, "Russell King" <linux@armlinux.org.uk>, "Benjamin
 Gaignard" <benjamin.gaignard@collabora.com>, "Brian Starkey" <Brian.Starkey@arm.com>, "John
 Stultz" <jstultz@google.com>, "Mark Rutland" <mark.rutland@arm.com>, "Radu
 Rendec" <radu@rendec.net>, "T.J. Mercier" <tjmercier@google.com>, "Madhavan
 Srinivasan" <maddy@linux.ibm.com>, "Michael Ellerman" <mpe@ellerman.id.au>, "Nicholas
 Piggin" <npiggin@gmail.com>, "Christophe Leroy" <chleroy@kernel.org>, "Ritesh
 Harjani" <ritesh.list@gmail.com>, "Shrikanth Hegde" <sshegde@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Gerald Schaefer" <gerald.schaefer@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Sven Schnelle" <svens@linux.ibm.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org, "H
 . Peter Anvin" <hpa@zytor.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "K . Y . Srinivasan" <kys@microsoft.com>, "Haiyang
 Zhang" <haiyangz@microsoft.com>, "Wei Liu" <wei.liu@kernel.org>, "Dexuan
 Cui" <decui@microsoft.com>, "Long Li" <longli@microsoft.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, "Vitaly Kuznetsov" <vkuznets@redhat.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, media-ci@linuxtv.org
In-Reply-To: <20261104164555.3555725-3-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-3-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:52:42 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] x86/hyperv: premature zeroing in hv_vtom_clear_present() befor=
e transition
- [High] Drivers: hv: uninitialized SynIC pages in hv_alloc_page() on non-C=
oCo VMs
- [High] dma-pool: dirty cache lines left on linear alias by set_memory_dec=
rypted()
- [Medium] x86/mm: set_memory_decrypted() zeroes legacy VGA VRAM/MMIO in VG=
A_MAP_MEM()
- [Medium] powerpc/pseries/svm: set_memory_decrypted() zeroes private page =
before sharing
--

commit 0a47431deefcabfb66f48104fa0c06cece49f6f0
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

mm: Zero memory during shared memory transitions

This commit moves memory zeroing into the architecture-specific
implementations of set_memory_decrypted() so each platform clears shared
memory at the appropriate point in the private-to-shared transition. It
also removes post-transition memset() calls from callers and keeps explicit
zeroing on paths where no transition takes place.

> diff --git a/arch/powerpc/platforms/pseries/svm.c b/arch/powerpc/platform=
s/pseries/svm.c
> index 7a403dbd35ee5..a344e094fe1c8 100644
> --- a/arch/powerpc/platforms/pseries/svm.c
> +++ b/arch/powerpc/platforms/pseries/svm.c
[ ... ]
> @@ -59,6 +60,7 @@ int set_memory_decrypted(unsigned long addr, int numpag=
es)
>  	if (!PAGE_ALIGNED(addr))
>  		return -EINVAL;
> =20
> +	memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
>  	uv_share_page(PHYS_PFN(__pa(addr)), numpages);
> =20
>  	return 0;

[Severity: Medium]
Should the memset() in set_memory_decrypted() happen after uv_share_page()
rather than before it?

On PowerPC pSeries Secure VMs, memory is partitioned between secure memory
and normal hypervisor-accessible memory rather than shared in place. When
uv_share_page() is called, the Ultravisor unmaps the secure page and the
hypervisor sets pvt->skip_page_out =3D true in kvmppc_share_page() before
allocating a new normal page and mapping it into the guest:

arch/powerpc/kvm/book3s_hv_uvmem.c:kvmppc_share_page() {
	if (kvmppc_gfn_is_uvmem_pfn(gfn, kvm, &uvmem_pfn)) {
		uvmem_page =3D pfn_to_page(uvmem_pfn);
		pvt =3D uvmem_page->zone_device_data;
		pvt->skip_page_out =3D true;
		...
}

Zeroing addr before uv_share_page() writes zeros to the private secure page
that is immediately unmapped and discarded (and faults in a secure page fir=
st
if one was not yet populated), instead of zeroing the shared mapping after
the transition completes.

[ ... ]

> diff --git a/arch/x86/hyperv/ivm.c b/arch/x86/hyperv/ivm.c
> index 2ce4dfe534727..e9c7799a00943 100644
> --- a/arch/x86/hyperv/ivm.c
> +++ b/arch/x86/hyperv/ivm.c
> @@ -755,6 +755,10 @@ static int hv_mark_gpa_visibility(u16 count, const u=
64 pfn[],
>   */
>  static int hv_vtom_clear_present(unsigned long kbuffer, int pagecount, b=
ool enc)
>  {
> +	if (!enc)
> +		memset((void *)kbuffer, 0,
> +		       (size_t)pagecount << PAGE_SHIFT);
> +
>  	return set_memory_np(kbuffer, pagecount);
>  }

[Severity: Critical]
As reported by Sashiko on RFC v8 [1], doesn't zeroing kbuffer in
hv_vtom_clear_present() clear the private mapping before the transition to
shared completes, leaving the final shared mapping unzeroed?

In hv_vtom_init(), hv_vtom_clear_present() is registered as
x86_platform.guest.enc_status_change_prepare, while
hv_vtom_set_host_visibility() is registered as
x86_platform.guest.enc_status_change_finish.

When set_memory_decrypted() runs on Hyper-V Isolation VMs using vTOM or a
paravisor, __set_memory_enc_pgtable() invokes the callbacks in this order:

__set_memory_enc_pgtable()
  -> hv_vtom_clear_present()          (prepare: kbuffer is still private)
  -> __change_page_attr_set_clr()     (updates PTEs with shared_gpa_boundar=
y)
  -> hv_vtom_set_host_visibility()    (finish: marks GPA host-visible and
                                       restores _PAGE_PRESENT via
                                       set_memory_p())

Because memset() runs in hv_vtom_clear_present() while kbuffer still maps t=
he
encrypted/private GPA below ms_hyperv.shared_gpa_boundary, the shared mappi=
ng
above vTOM is never zeroed after hv_vtom_set_host_visibility() makes the
pages host-visible and present again. With the post-transition memset() cal=
ls
removed from callers such as vmbus_connect(), hv_alloc_page(),
dma_direct_alloc(), dma_direct_alloc_pages(), and
__alloc_cc_shared_pages_node(), shared buffers on vTOM VMs will contain
ciphertext or uninitialized data instead of zeros.

Should this memset() be moved to the end of hv_vtom_set_host_visibility()
after set_memory_p() succeeds?

[ ... ]

> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
> index 2f8c32173972d..a1199a74e9a3f 100644
> --- a/arch/x86/mm/mem_encrypt_amd.c
> +++ b/arch/x86/mm/mem_encrypt_amd.c
[ ... ]
> @@ -308,6 +309,9 @@ static int amd_enc_status_change_finish(unsigned long=
 vaddr, int npages, bool en
>  	if (!cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
>  		enc_dec_hypercall(vaddr, npages << PAGE_SHIFT, enc);
> =20
> +	if (!enc)
> +		memset((void *)vaddr, 0, (size_t)npages << PAGE_SHIFT);
> +
>  	return 0;
>  }

[Severity: Medium]
What happens during vgacon_startup() when VGA_MAP_MEM() calls
set_memory_decrypted() on the legacy VGA video memory range?

In arch/x86/include/asm/vga.h, VGA_MAP_MEM() calls set_memory_decrypted() on
the direct-map address of legacy VGA memory (0xb8000 or 0xb0000):

#define VGA_MAP_MEM(x, s)					\
({								\
	unsigned long start =3D (unsigned long)phys_to_virt(x);	\
								\
	if (IS_ENABLED(CONFIG_AMD_MEM_ENCRYPT))			\
		set_memory_decrypted(start, (s) >> PAGE_SHIFT);	\
								\
	start;							\
})

During console initialization, con_init() -> vgacon_startup() calls
VGA_MAP_MEM(vga_vram_base, vga_vram_size) before probing for VGA hardware a=
nd
before vgacon_save_screen() saves the pre-boot screen contents.

With amd_enc_status_change_finish() and tdx_enc_status_change_finish() now
unconditionally calling memset() on !enc:

1. On AMD SME/SEV, set_memory_decrypted() wipes the 32 KiB VGA text buffer
   before vgacon_startup() checks the buffer or saves the initial screen.
2. On AMD SEV-ES/SEV-SNP and Intel TDX guests, 0xb8000-0xbffff is an MMIO
   range; executing memset() (which uses rep stosb when X86_FEATURE_FSRS is
   set) on that shared MMIO range triggers a #VC or #VE exception that
   insn_decode_mmio() cannot decode, panicking the kernel at boot.

[ ... ]

> diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
> index fe50090dcc011..6e836a02910a0 100644
> --- a/drivers/hv/hv.c
> +++ b/drivers/hv/hv.c
> @@ -123,12 +123,13 @@ static int hv_alloc_page(void **page, bool decrypt,=
 const char *note)
>  	if (!*page)
>  		return -ENOMEM;
> =20
> -	if (decrypt)
> +	if (decrypt) {
>  		ret =3D set_memory_decrypted((unsigned long)*page, 1);
> -	if (ret)
> -		goto failed;
> -
> -	memset(*page, 0, PAGE_SIZE);
> +		if (ret)
> +			goto failed;
> +	} else {
> +		memset(*page, 0, PAGE_SIZE);
> +	}
>  	return 0;
> =20
>  failed:

[Severity: High]
As reported by Sashiko on RFC v8 [2], doesn't skipping memset() when decrypt
is true leave SynIC message and event pages uninitialized on standard
(non-CoCo) Hyper-V VMs?

In hv_synic_alloc(), decrypt is set to !vmbus_is_confidential():

drivers/hv/hv.c:hv_synic_alloc() {
	const bool decrypt =3D !vmbus_is_confidential();
	...
	if (!ms_hyperv.paravisor_present && !hv_root_partition()) {
		ret =3D hv_alloc_page(&hv_cpu->hyp_synic_message_page,
			decrypt, "hypervisor SynIC msg");
		if (ret)
			goto err;
		ret =3D hv_alloc_page(&hv_cpu->hyp_synic_event_page,
			decrypt, "hypervisor SynIC event");
		...
}

On a standard non-confidential Hyper-V guest, vmbus_is_confidential() is
false, so decrypt is true. However, on non-CoCo x86 and arm64 guests where
memory encryption is inactive, set_memory_decrypted() is a no-op that retur=
ns
0 without zeroing the page. Because hv_alloc_page() allocates the page with
__get_free_page(GFP_KERNEL) without __GFP_ZERO and skips the else branch wh=
en
decrypt is true, hyp_synic_message_page and hyp_synic_event_page are handed
to the hypervisor with uninitialized kernel memory, leaving non-zero garbage
in message slot headers (msg->header.message_type !=3D HVMSG_NONE) and event
flags.

[ ... ]

> diff --git a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c b/drivers/virt=
/coco/pkvm-guest/arm-pkvm-guest.c
> index 26fe9c3f22e36..7d922e0a28f96 100644
> --- a/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
> +++ b/drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c
[ ... ]
> @@ -61,6 +62,8 @@ static int pkvm_set_memory_encrypted(unsigned long addr=
, int numpages)
> =20
>  static int pkvm_set_memory_decrypted(unsigned long addr, int numpages)
>  {
> +	memset((void *)addr, 0, (size_t)numpages << PAGE_SHIFT);
> +
>  	return __set_memory_range(ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID,
>  				  addr, numpages);
>  }

[Severity: High]
When atomic_pool_expand() expands a CoCo atomic DMA pool on arm64 (both here
in pkvm_set_memory_decrypted() and in realm_set_memory_decrypted()), doesn't
zeroing via the cacheable linear map allocate dirty cache lines after
arch_dma_prep_coherent() has already cleaned the cache?

In kernel/dma/pool.c:atomic_pool_expand(), arch_dma_prep_coherent() and the
non-cacheable vmap remap happen before set_memory_decrypted() is called on
page_to_virt(page):

kernel/dma/pool.c:atomic_pool_expand() {
	...
	arch_dma_prep_coherent(page, pool_size);

#ifdef CONFIG_DMA_DIRECT_REMAP
	if (dma_pool->cc_shared)
		prot =3D pgprot_decrypted(pgprot_dmacoherent(PAGE_KERNEL));
	else
		prot =3D pgprot_dmacoherent(PAGE_KERNEL);

	addr =3D dma_common_contiguous_remap(page, pool_size, prot,
			__builtin_return_address(0));
	if (!addr)
		goto free_page;
#else
	addr =3D page_to_virt(page);
#endif
	if (dma_pool->cc_shared) {
		ret =3D set_memory_decrypted((unsigned long)page_to_virt(page),
					   1 << order);
		...
}

Because pkvm_set_memory_decrypted() and realm_set_memory_decrypted() execute
memset() through the cacheable linear mapping page_to_virt(page) after
arch_dma_prep_coherent() has already run, dirty zeroed cache lines remain in
the CPU data cache for the linear alias while consumers of the atomic pool
access the buffer through the non-cacheable vmap alias addr or via device
DMA. If those dirty cache lines are later evicted, won't they overwrite data
written via the non-cacheable mapping or by DMA?

[1] https://lore.kernel.org/r/20260924100529.1398790-3-aneesh.kumar@kernel.=
org
[2] https://lore.kernel.org/r/20260924100529.1398790-3-aneesh.kumar@kernel.=
org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104164555.3555=
725-1-aneesh.kumar@kernel.org?part=3D2
