Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1F3361976
	for <kvmarm@lists.linux.dev>; Sun, 13 Sep 2026 17:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789321867; cv=none; b=t8udEjFTCRirNqnny6VxaYxO92kANp1aogFsDDb44jJikdwWIQHlrMBqMb+7Y0fZUBW0WKU4zuOU4chQvpRuReaAbG96HAmptsm51GP2VbCGQLCY9QlaQUW1XnNuxKGnRru4yMc4J+l8elpocW0SnX6O47og3dEAJbnuxfP0ViY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789321867; c=relaxed/simple;
	bh=wV+Ea5O648gDH19JqA6lFL8uIzT5+1nkWnhxVFsJvWE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=az7CVkq/EreUA6PJApaIbIYmdc+muyW4yXOhRdnM3jxak33QjKnxXE4muqNhjLbAU5hxn8jOyW2dDQbShIpVSN6Ufi4pdh7CcQ9HA/JX8Ctyh+e2jptjRmUxiaPb0AijYEazNQ1Y32p32+r11zgkWk/lwKjsaP5Gxf/YFTQVfkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HMOdbwTZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HMOdbwTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57AC1F000FF;
	Sun, 13 Sep 2026 17:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789321865;
	bh=sr27lRZX+84OKhFDydgoA6ib60H/VRpxjIzqDMMXloQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HMOdbwTZESUyH6/WTUdu5DI0JDa20vXX2D9VXEpXW6V7AsC0cf7Im8lRv7YKH4eAN
	 4y7gC/RUsIBBXl1dzST/vUHF6j8ZcnB+Jh6NvB5NC42bQIyhsmCulCCroRA8wayMVh
	 gQmMaNo5ybbpV7fsL7TkTgF2xwe//9x5RgXXpNNCEpxpXL+CajHa8FpB820sDBumye
	 CFEn6veT0O9RtfdsHxES/hImmaooeRJhSWwvbxySuYoL9+E0iIPALSBdng2Deb62f5
	 PWaWpScuTu3r/3cNYQjGxJbI94yQlbAqLHbXyjYqLsSg+MV+DPlDWxJXFbpwV+gY5F
	 1a+kVS2FgUuDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1] KVM: arm64: Fix protected VMs fault on system with
 pages larger than 4K
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260913173516.3122436-1-vdonnefort@google.com>
References: <20260913173516.3122436-1-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 17:51:05 +0000
Message-Id: <20260913175105.A57AC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] gmem_abort() passes an unaligned fault_ipa to kvm_pgtable_stage2_m=
ap(), which triggers the new -EINVAL check on pKVM hosts.
--

commit 724c2b0f8e554f59f7c409467796ff8e9acf590b
Author: Vincent Donnefort <vdonnefort@google.com>
Subject: KVM: arm64: Fix protected VMs fault on system with pages larger th=
an 4K

This commit aligns the fault IPA down to the page size for protected VMs
in pkvm_mem_abort(), similar to previous fixes for non-protected VMs.
It also adds a strict page-alignment check to pkvm_pgtable_stage2_map()
which returns -EINVAL if the address, size, or physical address are unalign=
ed.

[ ... ]

> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8e4c6e4bec123..1ca27d01a3ec6 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -414,6 +414,9 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, =
u64 addr, u64 size,
>  	u64 end =3D addr + size;
>  	int ret;
> =20
> +	if (!PAGE_ALIGNED(addr | size | phys))
> +		return -EINVAL;
> +

[Severity: High]
Does this new check break non-protected VMs using guest_memfd on a pKVM hos=
t?

When gmem_abort() handles page faults for guest_memfd slots, it passes
s2fd->fault_ipa directly to kvm_pgtable_stage2_map() without aligning it
down to the page size:

arch/arm64/kvm/mmu.c:gmem_abort() {
    ...
	} else {
		ret =3D KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa,
							 PAGE_SIZE,
							 __pfn_to_phys(pfn),
							 prot, memcache, flags);
	}
    ...
}

Since HPFAR_EL2 only aligns to 4K, on a 16K or 64K page host, the fault_ipa
passed from gmem_abort() will fail this new PAGE_ALIGNED check and return
-EINVAL. This prevents memory mapping and causes the VM fault handling to
abort.

Should gmem_abort() also be updated to apply ALIGN_DOWN to s2fd->fault_ipa,
just like pkvm_mem_abort() was fixed in this patch?

>  	lockdep_assert_held_write(&kvm->mmu_lock);
>  	mapping =3D pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, end - 1);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260913173516.3122=
436-1-vdonnefort@google.com?part=3D1
