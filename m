Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDC93E317B
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785509471; cv=none; b=LHr5E3PNLIw23EiebWWVRweqo9RHdLw3uWWWgorb0X4n/H1VGsCLyIkCVeAEkBZvOpXdxLbbdcM97fiLCFnfgtvjbLeVXjfZFR+Byp71YvbtKW7Difu6gjibKSHL75KYMeS84n+EaJpgJwU5FwpiN+fPQZwtFXhLLLAbKnX9+fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785509471; c=relaxed/simple;
	bh=C5thwXXlxg02JSTc4/DulIUGtQ3qt1KQRtqxk1GuPVA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hG7iteH6SLnQ+ZezluAMiBQzvbcgQCosHUff5feb+6FB/2DIbQkPx8PqB0vmCElicGdRAzlh+eKQUUZlemBAh5s9T+1k6ETUnV7ijuauLPXcSDIlvL8lAMsKpySJuiekdrNIHrNvPRTQEc/xCUm7tTCIo2QkLze2H+rKnCMqqpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y4VVceIg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y4VVceIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2D71F000E9;
	Fri, 31 Jul 2026 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785509469;
	bh=VtsFakcy7DTYWYlvA8L1Rkr6gG3dA7UVyHy/xUZF5i0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y4VVceIgYbTedq2Ed4eX1THoFCb5uU9uX4zFbu6h+sUqcX87SBdkc+ihMZC0VHid+
	 5LRpiTmbq9FizhLRUD8gfF3NzAD/Hk2itSZFHytUDhlzmfdbxgksYcygeELaGG6ppY
	 mxS5tajwNBUUleUDWWSrpZ4yAZp6qI8sy7gni18daoObFdvYt/TK6w5LccAMM9zq4L
	 9ad9UbrbHmFsVXRyDj4H2NeVcK04I92mr2qiJp9J8u3p0DNEqjgxiO91SOX+CKH3d9
	 RY+qxa3FUIC7+67R0rrsSscS9083bBacCOpug6XPChJWtEf/b7Wr2B/CCJckd58vR2
	 suD06e2TcL4wA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 05/17] KVM: arm64: Allow kvm_hyp_memcache usage
 outside of stage-2
Reply-To: sashiko-reviews@lists.linux.dev
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260731143541.956291-6-vdonnefort@google.com>
References: <20260731143541.956291-1-vdonnefort@google.com>
 <20260731143541.956291-6-vdonnefort@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 14:51:08 +0000
Message-Id: <20260731145109.4B2D71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] In pKVM, `user_mem_abort()` skips memcache topup during permission=
 faults, leading to a NULL pointer dereference in `pkvm_pgtable_stage2_map(=
)` if the fault triggers a THP block mapping upgrade.
--

--- Patch [5]: [PATCH v4 05/17] KVM: arm64: Allow kvm_hyp_memcache usage ou=
tside of stage-2 ---
commit 005835cc03d158de34bf975706ada05a2388636e
Author: Vincent Donnefort <vdonnefort@google.com>

KVM: arm64: Allow kvm_hyp_memcache usage outside of stage-2

This commit introduces init_hyp_memcache() and init_hyp_stage2_memcache()
to initialize generic and stage-2 specific memcaches. It modifies the
allocator to use GFP_KERNEL_ACCOUNT conditionally based on the new KMEMCG
flag.

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6c941aaa10c63..1e37f2f56c680 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
[ ... ]
> @@ -1160,8 +1160,10 @@ static void *hyp_mc_alloc_fn(void *mc)
>  {
>  	struct kvm_hyp_memcache *memcache =3D mc;
>  	void *addr;
> +	gfp_t gfp;
> =20
> -	addr =3D (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> +	gfp =3D memcache->flags & HYP_MEMCACHE_ACCOUNT_KMEMCG ? GFP_KERNEL_ACCO=
UNT : GFP_KERNEL;
> +	addr =3D (void *)__get_free_page(gfp);

[Severity: High]
This is a pre-existing issue, but while reviewing these memcache changes,
I noticed a potential NULL pointer dereference related to the memcache topup
logic across user_mem_abort() and pkvm_pgtable_stage2_map().

In arch/arm64/kvm/mmu.c:user_mem_abort(), topup_mmu_memcache() is skipped
during a permission fault:

	memcache =3D get_mmu_memcache(s2fd->vcpu);
	if (!perm_fault || (memslot_is_logging(s2fd->memslot) &&
			    kvm_is_write_fault(s2fd->vcpu))) {
		ret =3D topup_mmu_memcache(s2fd->vcpu, memcache);
		if (ret)
			return ret;
	}

If transparent_hugepage_adjust() then detects a THP and upgrades the mapping
to PMD_SIZE, pkvm_pgtable_stage2_map() will be called to install the block
mapping.

Since the memcache wasn't topped up, cache->mapping is NULL, and this code
subsequently dereferences it in arch/arm64/kvm/pkvm.c:pkvm_pgtable_stage2_m=
ap():

	swap(mapping, cache->mapping);
	mapping->gfn =3D gfn;

Could a guest trigger this by forcing a permission fault on a page that
khugepaged has collapsed into a THP, leading to a host kernel panic?

>  	if (addr && memcache->flags & HYP_MEMCACHE_ACCOUNT_STAGE2)
>  		kvm_account_pgtable_pages(addr, 1);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731143541.9562=
91-1-vdonnefort@google.com?part=3D5
