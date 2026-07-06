Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDBD3B1035
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 18:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783361836; cv=none; b=m0gc9FRT1CWbm9dyHWjAcjYMaoz1gKiBWxsYDNuk2R8fGx5jtdmrwkKZHSClsbCR7eKNR/98A4KAdlZhkMxPl+TIC3w9Gn2LmtVThtYLP0NBWGy3TvsfTWnHrS+Xfom69ylW9SxMcfAmQ1s1Y6/2JbdzdamiKkv0CIybxUtT9Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783361836; c=relaxed/simple;
	bh=JYu4H+PEryhsyhMHEGrwQZHn23FUMRJZrxHDCqCVwQk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=CBBuJT9BB381f7llz6mK292LAfq3FgG8NIiVSlkcH8I0Tl7N0XzpHFc2wOP4G/oG/cJOfO4krOJB56kVhbr0jvcu2gVfdpV3ibw+/XZxzPQTe9wUU0cqvIxVcKKIAfv4sZpJKjtEhFDfITkLo4flFfABAYbtp0AJww6Uk4V3gew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9+6sD5D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9+6sD5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A4C1F000E9;
	Mon,  6 Jul 2026 18:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783361834;
	bh=1mx4ztTr8v8Xp76tcS0Pw1PKBmFXlcmjESgkzcsgq6U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F9+6sD5DiTFkLBlXIAjeN0GbvBzboCVr0jI29e2JmbYNVUl72EqtDncEVOI7Ydlez
	 6cJ2g+Gre0XivP3zwpW0J5VkIY/nLAGwarnpN2Ihsu0DuUbCGowWYmI7vUNVuUSSY6
	 +4Ng//XGQOCdkVC1jSse8Csm3Rrxi39cJJjxL6zqVwSIrZKMJS5KSXU2YS/wDoL+N9
	 gUyBLP+JStUsEs0+BBXWxlKY46sJtj57Zba6WyQI9wcexnQc2QyyAjpkz2uHSE5Isb
	 gjjP/WDQ936u+dBGWFqupqqLJVcj4UQRJpup1srZxzFRLgt9SiATlIhb0Gb/TjTDYP
	 wFr+V7+5tRn+g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 14/18] KVM: arm64: Use noclear for PGD in
 __pkvm_init_vm error path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260706175415.2604046-15-vdonnefort@google.com>
References: <20260706175415.2604046-1-vdonnefort@google.com>
 <20260706175415.2604046-15-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 06 Jul 2026 18:17:13 +0000
Message-Id: <20260706181714.15A4C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Using `unmap_donated_memory_noclear()` for the PGD on the error pa=
th leaks EL2 virtual addresses to the untrusted host, bypassing hypervisor =
ASLR.
--

commit d94f8fc664be6ec0ac22803e7fe54acff9cf8af1
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Use noclear for PGD in __pkvm_init_vm error path
   =20
This commit modifies the error path of __pkvm_init_vm() to use
unmap_donated_memory_noclear() instead of unmap_donated_memory() when
returning the donated stage-2 PGD to the host.

> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkv=
m.c
> index d9ab582268895..0c82f1ddb93df 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -861,7 +861,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned lon=
g vm_hva,
>  	kvm_guest_destroy_stage2(hyp_vm);
>  err_remove_mappings:
>  	unmap_donated_memory(hyp_vm, vm_size);
> -	unmap_donated_memory(pgd, pgd_size);
> +	unmap_donated_memory_noclear(pgd, pgd_size);

[Severity: High]
Does using unmap_donated_memory_noclear() here leak EL2 virtual addresses to
the untrusted host?

If the host deliberately provides an invalid handle before triggering this
hypercall, insert_vm_table_entry() will fail and execution will take this
error path.

Before reaching this error path, kvm_guest_prepare_stage2() initializes the
donated PGD memory as a buddy pool. During this process, __hyp_attach_page()
uses page_add_to_list() to write EL2 list_head pointers into the free pages.

By using the noclear variant here, the memory is returned to the host witho=
ut
zeroing those pointers. The host can then read this returned memory to
extract valid EL2 virtual addresses, which breaks hypervisor KASLR.

Should this remain unmap_donated_memory() to ensure these internal pointers
are properly scrubbed before the host regains access?

>  err_unpin_kvm:
>  	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
>  	return ret;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260706175415.2604=
046-1-vdonnefort@google.com?part=3D14
