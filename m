Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271493446B0;
	Tue, 18 Aug 2026 08:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787041582; cv=none; b=XBOdsQjvPlYxeyWH2pdvWvYUFJ8ZTcz0zsmwxKGY8YTRQreWMt0B7iLxxYnhGPr3GIQb9K+ftGV9ADJH03vRjsj8VplBZoR59WMVVb9QLhn3OEdabxeycBFnb2ZfAGlO5A8PKYLIbQQT82CZAwztrKkk1mwme06T98KB3HE9fyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787041582; c=relaxed/simple;
	bh=0MLVF5AuTb/1pSNc4BeGxYEUVEiYQk3IAY7mi1r4R0k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uQvx7BO1hcW437/EfAbVEqcJWJV/fBDW2b5w2z+7dbetKZan9sqqo/LJr5Ru4pqK1vZq2oySWE2bpiQqXL9KHF4h5bIzNaJAACd/9XVSzvcVXzWD1xmxn62Rl4oRHa+Vw1cQadLtENKJA9J1hVSoS4ZZSDt7ykLR4zr5KJKliDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jUFv942u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jUFv942u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722031F000E9;
	Tue, 18 Aug 2026 08:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787041580;
	bh=AMYD67WRGFL/G8pmDJxtcovyuG1HHRZrm7rD9R8gI7M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jUFv942u+4UcVPejl/BkJw8lN9taMSAeBYfQjE7onUMW/kcaHdf/rNXY6X+f8oEYE
	 u/PBzevtv87pTsL6Wssblr3FNDKMd914LT2pmu6BmLJ2F+1Nz4RjZGx/s06qTv7t7D
	 /O67cGsYw3B8QS+nSWWZuLQCdgrU42py3U3zgfV3UU/PtxYKTAHrWzAxoROFcuD6W4
	 uGd0KNCYmwNRI2VrNsbxYjl+JAcgmScVt6mVtTXHOZM/5kNxfYylbnGYOvNQ1mV0Q0
	 Yl+p6ws8fXpojkT2kJ0uW4IEifjFX/o2wBtE7MtIpprvmMZ7PD20nf33o22+7yqWmC
	 eJHM+oPNRMzbA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] KVM: SEV: Drop page refcount early during RMP fault
 handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ackerley Tng" <ackerleytng@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260818-gmem-no-return-page-v1-2-4f8d939efdbc@google.com>
References: <20260818-gmem-no-return-page-v1-0-4f8d939efdbc@google.com>
 <20260818-gmem-no-return-page-v1-2-4f8d939efdbc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 08:26:19 +0000
Message-Id: <20260818082620.722031F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Dropping the page reference early exposes the physical frame (=
PFN) to concurrent freeing and reallocation before hardware RMP operations =
(PSMASH) execute, leading to cross-VM memory corruption.
--

--- Patch [2]: [PATCH 2/4] KVM: SEV: Drop page refcount early during RMP fa=
ult handling ---
commit b722a12d672bd9f9b3789be73ead1445ff086955
Author: Ackerley Tng <ackerleytng@google.com>

KVM: SEV: Drop page refcount early during RMP fault handling

This patch modifies the RMP fault handler to drop the page reference retrie=
ved
from guest_memfd early. The intention is to avoid holding the reference
throughout the rest of the handler, as the subsequent hardware operations a=
nd
page table zapping only require the physical frame number.

> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b2738362a928b..19c31fa944e34 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
[ ... ]
> @@ -5036,12 +5036,13 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, =
gpa_t gpa, u64 error_code)
>  				    gpa);
>  		return;
>  	}
> +	kvm_release_page_unused(page);
> =20
>  	ret =3D snp_lookup_rmpentry(pfn, &assigned, &rmp_level);

[Severity: Critical]
Does dropping this page reference early expose the physical frame to concur=
rent
freeing and reallocation before the hardware operations execute?

Since sev_handle_rmp_fault() does not hold kvm->mmu_lock, if the page is
unpinned here, couldn't a concurrent fallocate(FALLOC_FL_PUNCH_HOLE) on the
guest_memfd unmap and free the page back to the host?

If the host then reallocates this physical page to a different VM as a
private 2MB hugepage, its reverse map entry would be assigned to the new VM.

When this vCPU resumes, it could call snp_lookup_rmpentry(), see the page is
assigned and 2MB, and proceed to execute snp_rmptable_psmash():

    if (rmp_level =3D=3D PG_LEVEL_4K)
        goto out;

    ret =3D snp_rmptable_psmash(pfn);

Could this blindly shatter the other VM's 2MB entry into 4KB entries and
break hardware memory isolation?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818-gmem-no-re=
turn-page-v1-0-4f8d939efdbc@google.com?part=3D2
