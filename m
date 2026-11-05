Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793897574;
	b=5EAje8vLvsF80merqLJZ4VVhM4o/b0cmbLMY16ntyqIAqP0UGAyawqaGSDvOW9In0WuI
	 mVNY2ns6sxXFrnhhutRophV6bFp2kLK92DowCZpnYamgUnpxP51Z8HUhYVZQStCZeOwfj
	 dVBSUqpIFtIASwzCgxd+zAUp0UFbjz58fDrU6eGOYrtr3WubKrnG5/PYNmZG9ImCZDiai
	 1hVxACZp2CpJ1VR+oNUkLw1Pg3tUjKPwYUQqPS7VwQE838DYuxAM/LOwzEPVSDB16uXhp
	 iEPHnNTc1GFg2XH/JUlzOPBwK9hqm0Rl/XXjl2n9RhC2JxthHT3HVB3av5eu+THxSfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793897574;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=w/YTY8Qo0Zgoo2NfvapWx8uwEG48gJ3/0t1KofHUSvY=;
	b=G4dIwZLAdNoBupi1h7sbgySd5PgdukdnhgXucqfajJYHjvTz5tEqiKIl5LW3nZRELUvl
	 Nu4HTADv0WCI3F8z2mGIyRwB8M9LjSmPgvIm9q8Nh5TZ+xDoqpEya88MwdtHWlc6gwFfy
	 E4TTOUQwqW7VzT627/TnunrZKFZt441pYJIOVPt4t/r8a7+WMB+mIlzbngN41NE3L4GBZ
	 H7Z2Nah8YiganfUQvkVDC8i+fa7ZASAln39PVcMI9j9Hj1I7q+lIHhEFEklcOClwzE+xM
	 Olao9Cx5hPUuO92k/tqySOXXjvG9qzB69C1DNM+VZI0+UEX2Ssde1EwVOKCRlsjtl5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e+FQOIfN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141E8606D827
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 16:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e+FQOIfN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78131F000C1;
	Thu,  5 Nov 2026 16:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793897573;
	bh=w/YTY8Qo0Zgoo2NfvapWx8uwEG48gJ3/0t1KofHUSvY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e+FQOIfNYc9wA2g3UCHvH9NgrcOuRcaEGDzbgAv1EgOtmrRJPSTLBvFWZ4/FpJD9W
	 15AaYXrjwrrIpdWszwLaHSgP0IXU4dOJPmQRRLugdqcsOFH2GeRuDWFj4MjhUnBoFp
	 4Rzs/MfQKLEVOfF4GjK9p5j1nvikqWdTzXny56BY2WP5ZbDBEjhwGWJKh1x+rGL6ds
	 KziVI0OEAA3uFY2MyCXCxryvNf3Xye1hcZiGd3E6GHX/hxDJr6irTkKG3bcd3HJMf/
	 asEvxYDhlE469H/oqIzFUy8r+vtIfVfmwvIbI2SxLRDvqAkwSW/6x23nYBVWbcgDlf
	 sFVJw80vCBp+w==
Message-ID: <sashiko-outbox-199546@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 08/14] swiotlb: Align shared IO TLB pools to the
 shared granule size
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
In-Reply-To: <20261104164555.3555725-9-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-9-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 16:52:48 +0000
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
- [Low] swiotlb: premature linux/set_memory.h removal breaks restricted poo=
l build
--

commit 604798053e9de98cc147fbbd212cc3b2c9896b0e
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

swiotlb: Align shared IO TLB pools to the shared granule size

This commit aligns and sizes the SWIOTLB pool allocations to the common CoCo
shared granule size and replaces the default and dynamic pool set_memory_*()
calls with cc_make_shared() and cc_make_private().

> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 2c57b49ac7c06..36fbec2241e4d 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -22,6 +22,7 @@
> =20
>  #include <linux/cache.h>
>  #include <linux/cc_platform.h>
> +#include <linux/cc_shared.h>
>  #include <linux/ctype.h>
>  #include <linux/debugfs.h>
>  #include <linux/dma-direct.h>
> @@ -38,7 +39,6 @@
>  #include <linux/pfn.h>
>  #include <linux/rculist.h>
>  #include <linux/scatterlist.h>
> -#include <linux/set_memory.h>

[Severity: Low]
Does removing linux/set_memory.h in this commit break the build when
CONFIG_DMA_RESTRICTED_POOL is enabled?

At this commit, rmem_swiotlb_device_init() in kernel/dma/swiotlb.c still
calls set_memory_decrypted() directly:

kernel/dma/swiotlb.c:rmem_swiotlb_device_init() {
	...
		if (cc_platform_has(CC_ATTR_MEM_ENCRYPT)) {
			int ret;

			mem->cc_shared =3D true;
			ret =3D set_memory_decrypted((unsigned long)phys_to_virt(rmem->base),
						   rmem->size >> PAGE_SHIFT);
	...
}

That caller is not converted to cc_make_shared() until the subsequent commit
("swiotlb: Reject misaligned restricted DMA pools for CoCo guests").

Because none of the remaining headers included in kernel/dma/swiotlb.c pull=
 in
linux/set_memory.h, architectures without CONFIG_ARCH_HAS_MEM_ENCRYPT lose =
the
static inline stub for set_memory_decrypted() from include/linux/set_memory=
.h,
and x86 with CONFIG_ARCH_HAS_MEM_ENCRYPT=3Dy loses its declaration from
arch/x86/include/asm/set_memory.h, resulting in an implicit function
declaration error during git bisect.

Should the removal of linux/set_memory.h be deferred to the next patch where
rmem_swiotlb_device_init() is converted to cc_make_shared()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104164555.3555=
725-1-aneesh.kumar@kernel.org?part=3D8
