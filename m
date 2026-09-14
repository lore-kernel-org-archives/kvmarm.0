Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9383DAABC;
	Mon, 14 Sep 2026 13:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789392398; cv=none; b=kpjbQ+qB2ilGq2nO7yrZAE0OFJmraKqzBD2E/0rDZzl4Wzp98/B0VpFbXiHvGJSMoCw86Ti5V2VSA7amuPz7NK0BvNki4a23gb1kUUUu7H8qGBRn7xfVmSbp01rPDMYGFLvpwoUR2HlL4I3XwzKDNpCV+RKqTp1sFmftuRu26T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789392398; c=relaxed/simple;
	bh=kfv6urV0lGFie3Up9UNvhMRXg9moxSkFxwDMgJj7jgQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XHTqnAWMmtmNnEZtt4h+Flm/ACtf71Q+CNknEMZPYSWg8R2DapNRH96/eAmN+PTm19o95uoQdPGvsT8ESott7gTjDF/wDYKLT61fK3filBAKogJY8DWFQSjLbdWERTUNjcfzE7mgyG2GsfT5BOwkwabzfGT/b4wbYRRyxur0iOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nDnEvTX5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nDnEvTX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71771F00893;
	Mon, 14 Sep 2026 13:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789392397;
	bh=JAmq9K5/aIg+OWqR/4Bgpoi2B07sbGKS27pNZlGY1gI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nDnEvTX5prnxF/jQIY6SlS3BJOAW3lI9/L+vc7btUPqEqHzOA1Akb6di+7bIVIwAy
	 wa+85YqYSAbu3NqL+Q73jaBsfi+43MxqtIABeYJUG7izwr2tFVurj5CMmrDsqtqtxz
	 JBCIibC6lf9DjPU1azZVDIV9B1CWwumNpLLOPym7VGyS7lrvvhKEwY/Uyg1miblX83
	 dfdSQrbBTqtsDq51zR4suExpBTGu412O0m97MZjtbZWiQwIRXAZ6wdu46/xLTeqfiF
	 su1iJ8H3AfS6IQrHoS/QGacdHg+8ndMeWRm4YFxiVk/DQD05DXk0vfX1y6Db0t8AxI
	 BrhO0kVmwRWyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 06/13] KVM: arm64: Size the stage-2 memcache from the
 fault MMU
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260914-kvm-arm-prefault-v2-6-26fb47f74b73@kernel.org>
References: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
 <20260914-kvm-arm-prefault-v2-6-26fb47f74b73@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 13:26:36 +0000
Message-Id: <20260914132636.C71771F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The pKVM page fault handler `pkvm_mem_abort()` completely omits th=
e mandatory MMU notifier invalidation retry protocol, risking the installat=
ion of stale translations.
--

commit caf2d4f716079e3655b6e5fed2957d60fe0bf41c
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

KVM: arm64: Size the stage-2 memcache from the fault MMU

This commit updates topup_mmu_memcache() to take the target s2fd->mmu
instead of the faulting vCPU. This allows the caller to control which MMU
is used for sizing the memcache.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 13541218cadbe..8c23fef4ecf84 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c

[ ... ]

> @@ -1755,7 +1755,7 @@ static int pkvm_mem_abort(const struct kvm_s2_fault=
_desc *s2fd)
>  	int ret;
> =20
>  	hyp_memcache =3D get_mmu_memcache(vcpu);
> -	ret =3D topup_mmu_memcache(vcpu, hyp_memcache);
> +	ret =3D topup_mmu_memcache(s2fd->mmu, hyp_memcache);
>  	if (ret)
>  		return -ENOMEM;
> =20

[Severity: High]
This is a pre-existing issue, but pkvm_mem_abort() appears to omit the MMU
notifier invalidation retry protocol, risking the installation of stale
translations.

Further down in pkvm_mem_abort(), the physical frame is resolved using
pin_user_pages() without first capturing the global mmu_invalidate_seq
counter:

        mmap_read_lock(mm);
        ret =3D pin_user_pages(s2fd->hva, 1, flags, &page);
        mmap_read_unlock(mm);

The mapping is then committed to the stage-2 page tables under the lock
without gating the installation on mmu_invalidate_retry():

        write_lock(&kvm->mmu_lock);
        ret =3D pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
                                      page_to_phys(page), KVM_PGTABLE_PROT_=
RWX,
                                      hyp_memcache, 0);
        write_unlock(&kvm->mmu_lock);

Missing the retry check breaks KVM's invalidation retry protocol. Even when
a page is pinned, a concurrent host MMU invalidation (e.g., from
madvise(MADV_DONTNEED) or NUMA balancing) can overlap with the pin.

Does this allow KVM to install stale translations, leading to memory
corruption or guest-visible data leakage?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-kvm-arm-pr=
efault-v2-0-26fb47f74b73@kernel.org?part=3D6
