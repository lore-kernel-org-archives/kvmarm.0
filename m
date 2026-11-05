Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793897563;
	b=Zanh4uNlMRB4Sf1idwF/l2YpBpOZCY6Tv4a+Fl2TozbRGjs0K2keRIsQ0sJiay+1mV27
	 Ki1CaZ5U/jlXSkuzyzLxz5TyuSt/O3Klo6RJSJcNd1ZuvKgbXBKWjgWa1Pp1bPZ4jM1Bu
	 V4Xw9zYcJEMsA1FvZtxx7u+P0Fc82hjF+E+lPe4RUzviFnZI8KdxFL7I90utdW0L0XnqG
	 +bDlEpt/MXNJ99oYSIjv/IknsKbX8oS8DN6TsCcbwwHE11o98ZSTz8xNYX5IoLPTvSnCw
	 Q4ZPpXQVb7b0bMaV3owaCBk62t7RyXv7R0avNHud0g38KZHyV60H6ppHtXVm0EcgbUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793897563;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=oan7Be93ViXW4gYEkS/gPnA8WQOj5WP16f3Bui9Wk7U=;
	b=SLt/fXOgIOcdoGbf1ipZ0lyDomxEycZPQTFKKvvo4SAQd2ZJQ7S3JCgadNWJXeOD/13I
	 c1ExtsYqA9usaLpIzCGxtb2ArPOa3dUs8JIEGioK43z5H8u3CRxYSElyqvApmXckwS856
	 IF0J2a3n79yMuZgCNbN7YuMlFam0nAQqBAJ1lvF4UstTAQMAExDR+tVs9irz5+WGX/L2Q
	 QLXBQLyZlITct1Qm8f5GkqLx0Q4sG5wNego2wrrg15bLchGkyeK+uUITOtiPbUWQxT03y
	 YhfbGtWfl8qtpEyLu0i9GvsmLSs/zBDUsxUpg2O14OqTeEWpYzuDZs/egDB7W9QPxpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GwerQ7j6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE32B606A31B
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 16:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GwerQ7j6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63A71F000C1;
	Thu,  5 Nov 2026 16:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793897562;
	bh=oan7Be93ViXW4gYEkS/gPnA8WQOj5WP16f3Bui9Wk7U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GwerQ7j6pasgEGyVYTDs+rpslsBSxNGeuuJCR3gfQAwxU39ruFZGQVJsU6xOe4VOb
	 p7GyIAkYyHavX5RkJS3Lv0Ze3kMZMHdhrj9+PyqK9tc5NKk+p36KA8imu+ft2p7EA2
	 SL+c1rpEjgec6lf+I8mbaWwMxUCVpxAjHqR6bRKm4rkj30/1FLUAZ86AgDw7gqrnM/
	 bTm/Yu/FEOyYbtHDF/RfEJgwhD4wl+w5ijxin0UYtDmvctTAwUTCcJxZYU+mCb2qNV
	 mpAILzbOQtMP3TTteKWWvVXKZRDHvLVWthzxmlRt8cds/qw+P0gQaHaLFGjFO6CjBg
	 LJCqfDltxAlpQ==
Message-ID: <sashiko-outbox-199539@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 01/14] mm: Add an allocator for CoCo shared memory
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
In-Reply-To: <20261104164555.3555725-2-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-2-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:52:38 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: invalid cc_make_private() call on cc_make_shared() failure
--

commit 8a434c0ee7399613dbf060530383d80bbc1ab7af
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

mm: Add an allocator for CoCo shared memory

This commit introduces a common allocator and transition helpers for
confidential-computing shared memory, including alloc_cc_shared_pages(),
alloc_cc_shared_pages_node(), and free_cc_shared_pages().

> diff --git a/mm/cc_shared.c b/mm/cc_shared.c
> new file mode 100644
> index 0000000000000..5c4c971cfb7b2
> --- /dev/null
> +++ b/mm/cc_shared.c
> @@ -0,0 +1,233 @@

[ ... ]

> +static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
> +					size_t requested,
> +					struct cc_shared_pages *mem)
> +{
> +	struct cc_shared_layout layout;
> +	struct page *page;
> +	unsigned int order;
> +	bool zero =3D gfp & __GFP_ZERO;
> +	int ret;
> +
> +	ret =3D cc_shared_calc_layout(requested, &layout);
> +	if (ret)
> +		return ret;
> +
> +	order =3D get_order(layout.shared_size);
> +	if (order > MAX_PAGE_ORDER)
> +		return -EINVAL;
> +	/*
> +	 * State transitions require a linear-map address and may modify memory.
> +	 * Allocate from low memory and defer requested zeroing until afterward=
s.
> +	 * Shared allocations have no migration support, so they must not
> +	 * be allocated with __GFP_MOVABLE.
> +	 */
> +	gfp &=3D ~(__GFP_HIGHMEM | __GFP_ZERO | __GFP_MOVABLE);
> +	if (nid =3D=3D NUMA_NO_NODE)
> +		page =3D alloc_pages(gfp, order);
> +	else
> +		page =3D alloc_pages_node(nid, gfp, order);
> +	if (!page)
> +		return -ENOMEM;
> +
> +	ret =3D cc_make_shared(page_address(page), layout.shared_size);
> +	if (ret) {
> +		if (!cc_make_private(page_address(page), layout.shared_size))
> +			__free_pages(page, order);
> +		else
> +			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
> +					    layout.shared_size);
> +		return ret;
> +	}

[Severity: High]
Is it safe to call cc_make_private() across the entire layout.shared_size
range when cc_make_shared() fails in __alloc_cc_shared_pages_node()?

When cc_make_shared() fails via set_memory_decrypted(), the pages in the
range may not have been transitioned to shared state at all, or only a pref=
ix
of the range may have been transitioned.

For example, on x86 TDX in arch/x86/mm/pat/set_memory.c and
arch/x86/coco/tdx/tdx.c:

__set_memory_enc_pgtable() {
	ret =3D x86_platform.guest.enc_status_change_prepare(addr, numpages, enc);
	if (ret)
		goto vmm_fail;

	ret =3D __change_page_attr_set_clr(&cpa, 1);
	...
	if (ret)
		return ret;

	ret =3D x86_platform.guest.enc_status_change_finish(addr, numpages, enc);
	if (ret)
		goto vmm_fail;
}

tdx_enc_status_change_finish() {
	if (!enc && !tdx_enc_status_changed(vaddr, numpages, enc))
		return -EIO;

	if (enc)
		atomic_long_sub(numpages, &nr_shared);
	else
		atomic_long_add(numpages, &nr_shared);

	return 0;
}

If set_memory_decrypted() (enc =3D false) fails with -EBUSY on mem_enc_lock=
 or
with -ENOMEM in __change_page_attr_set_clr() before
tdx_enc_status_change_finish() is reached, the pages remain private and
accepted in the TDX module, and nr_shared is not incremented. Calling
cc_make_private() (set_memory_encrypted(), enc =3D true) then invokes
tdx_enc_status_change_prepare() -> tdx_accept_memory() -> try_accept_one() =
on
already-accepted private memory, which fails and jumps to vmm_fail in
__set_memory_enc_pgtable(), triggering a spurious WARN_ONCE and leaking mem=
ory
that was never shared.

Conversely, if tdx_enc_status_change_finish() fails during cc_make_shared()
before atomic_long_add(numpages, &nr_shared), and the subsequent
cc_make_private() call succeeds, tdx_enc_status_change_finish() will execute
atomic_long_sub(numpages, &nr_shared), underflowing nr_shared and corrupting
the accounting checked in tdx_kexec_finish().

Similarly, on arm64 pKVM in drivers/virt/coco/pkvm-guest/arm-pkvm-guest.c,
pkvm_set_memory_decrypted() shares pages one by one and stops at the first
failing page, leaving the remaining pages private. Calling cc_make_private()
across the full range then invokes KVM_MEM_UNSHARE on private pages, which
fails with -EPERM.

Other callers in the kernel (such as dma_direct_alloc_pages(),
atomic_pool_expand(), and swiotlb_init_late()) do not call
set_memory_encrypted() when set_memory_decrypted() fails, and instead leak =
the
pages directly because the transition state of the range is unknown. Should
__alloc_cc_shared_pages_node() do the same here instead of calling
cc_make_private()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104164555.3555=
725-1-aneesh.kumar@kernel.org?part=3D1
