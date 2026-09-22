Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3202F260C;
	Tue, 22 Sep 2026 14:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790087519; cv=none; b=dfnMkLORx6oyb0J2sjn64CKy2vO7aw5eGKP9bq8OivtCKX8LRYAsXHIKEB8q923FkOpL0snuM1GDqYwbr0ovUiV360W3F3r+F0PozaRS78Co0mbxszpDYrs1nv0nW6za9XvKKbwpF4ASrrAqcBpFT8NfSgzqPJwnDtfWuDulanE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790087519; c=relaxed/simple;
	bh=6IImLfTKxPhGIdpizcT4cnoXrUZEZ+xiZp14YeweZOg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=J6dTvu4DP6A2scMnEM8zWdZMwibF6EywtOiDtLPJGFnyk874dT9Y0vSSk9Iof2Cf/P2Dnqj/NAEYtQ2q3H6z9TJvzCF0UtNfW3aBy9sbo2l2Sm+ZDwB3F5GfEn5FZf/e5nLIdTQAX8imWA+h32FLplSK2gpPbHqUS9Swujdeaas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oduosniq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oduosniq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E84B1F000FF;
	Tue, 22 Sep 2026 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790087517;
	bh=w/jfGaM0qWyYXl2OytFCyasVG0o2ZzBWvSGfH33ibz8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oduosniqM5wZzM/Oy8KUIAo4sHwzuvLkS1A9KFRQ/AZMmiSUfibVrUIbawmWHs/Fi
	 4kfY48XN42PTV8QJ7beUlp3hL31X34Nfm2t3v7qo6kzPmL7ApDOwXHLbsxhITuAT06
	 wfwgce69whe9sEB82VSqub0XhRqQI/ySgLTwRFwI08zzMZJByA8gyQ534NMf67RXQh
	 +yP1GFlnOx+stTNk206mZc70UgakvoBBVh0iOPFo9McL7qHVc1U8xyTJ9g+/I4vS0c
	 dDfeu2VU2awim8xAA26Ej1QqT0Z2Wea97RYc0+AZNnHkH5GBTTCIOr6w+0pv8pxs5+
	 Zkx4OMYX/RCeg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/14] KVM: arm64: Size the stage-2 memcache from the
 fault MMU
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260922-kvm-arm-prefault-v3-7-787bd3bc7e3f@kernel.org>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-7-787bd3bc7e3f@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 14:31:56 +0000
Message-Id: <20260922143157.0E84B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] arm64: kvm: spurious allocation in kvm_s2_fault_map during prefa=
ult
--

commit 9bf98edb6fb89edb3f2ce746e5754cac7f11bfe0
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>
KVM: arm64: Size the stage-2 memcache from the fault MMU

This commit modifies topup_mmu_memcache() to use the target MMU from s2fd->=
mmu
rather than the active vCPU MMU. This is a preparatory step for stage-2
pre-faulting, which needs to target the canonical MMU regardless of the vCP=
U's
context.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 5c429065a4feb..221ea069f9bb6 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2251,7 +2251,7 @@ static int user_mem_abort(const struct kvm_s2_fault=
_desc *s2fd,
>  	memcache =3D get_mmu_memcache(s2fd->vcpu);
>  	if (!perm_fault || memslot_is_logging(s2fd->memslot) ||
>  	    is_protected_kvm_enabled()) {
> -		ret =3D topup_mmu_memcache(s2fd->vcpu, memcache);
> +		ret =3D topup_mmu_memcache(s2fd->mmu, memcache);
>  		if (ret)
>  			return ret;
>  	}

[Severity: Medium]
Does this decoupling of s2fd->mmu and vcpu->arch.hw_mmu cause a spurious
allocation downstream in kvm_s2_fault_map()?

When pre-faulting is executed on a nested vCPU, s2fd->mmu is set to the
non-nested canonical MMU, while vcpu->arch.hw_mmu remains nested. In
kvm_s2_fault_map(), the allocation of the mapping struct is gated on the ac=
tive
vCPU MMU:

arch/arm64/kvm/mmu.c:kvm_s2_fault_map() {
	if (kvm_is_nested_s2_mmu(kvm, s2fd->vcpu->arch.hw_mmu)) {
		mapping =3D kmalloc_obj(struct kvm_guest_s2_mapping,
				      GFP_KERNEL_ACCOUNT);
		if (!mapping) {
			kvm_release_page_unused(s2vi->page);
			return -ENOMEM;
		}
	}
}

However, the consumption and tracking of this mapping relies on pgt->mmu, w=
hich
resolves to the target s2fd->mmu:

arch/arm64/kvm/mmu.c:kvm_s2_fault_map() {
		if ((ret =3D=3D 0 || ret =3D=3D -EAGAIN) && kvm_is_nested_s2_mmu(kvm, pgt=
->mmu)) {
			kvm_record_guest_s2_mapping(pgt->mmu, canonical_ipa,
						    gfn_to_gpa(gfn), mapping_size, mapping);
			mapping =3D NULL;
		}
}

Because kvm_is_nested_s2_mmu() for pgt->mmu evaluates to false during a
pre-fault, the allocation is never used and is subsequently safely freed at=
 the
end of the function.

Could this lead to an unnecessary allocation in the ioctl path that might
spuriously fail and return -ENOMEM to userspace?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922-kvm-arm-pr=
efault-v3-0-787bd3bc7e3f@kernel.org?part=3D7
