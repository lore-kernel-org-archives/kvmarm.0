Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AF83B14AC
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 14:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782225657; cv=none; b=r+039nCTePf/Z/kVwuQfBH8zuinDaz1Th3giqwksVLBghN259/yUOzHlK7RzprjmSu1//HHszKDt+9iqFdyk1nxx999ni9wesO2k6NuEtZvrAIbbGO9iGhzHkDX0l6IWvjTHhxcH+e1wbCN1f8Y59QitRBG+3dssxH/sGG0oFGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782225657; c=relaxed/simple;
	bh=SV9yXYvv2I1KDcGTpVO8u2R9L09LYB6CxJB14Bq82xg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BO2avz4JhvV2lY3wKLuH0sWp9PKCCvYKQWUe7BE5cWvh590ZIt3OP0af5+5SySXObDGdeTthoDGOA6efwTXwx0QbeVkeKerX5G4pK0ECkQtCtsv48WJzARmxdEhm4wjyRB22ETFRB2f0e/y2yA6f3SeNHbvs4gEb9/sbOyaRHXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VMTVnIZ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VMTVnIZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91D21F000E9;
	Tue, 23 Jun 2026 14:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782225655;
	bh=l3rWaG9b0YhqeLejy9VBgjTQ9K8rwyO4KETqonms4LI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VMTVnIZ3B9Mr0rm6zFiP7BkCs5eTBDAFy+H7DYmpSke4IZ5nGfk3QsD1uK5jZUNnL
	 rDBmt3x07Nj1KvRmiR9Gn6+W3eiEkRCQrKZ1IyXZNV5wl4FHlr++tD6ktPrZaYcyz6
	 4P+5rGb51jTAVa42xVVbdabNVjNS+tKwZ1+uysGs/+XW5Fq6k1nzi12871dXUY3gn0
	 7DPNMFgyc9/88c9OKHsl5sNl66zYnEzc9V/Z8KZybwx/zjf8ahXckX5SaR3VP+lWml
	 Wnj3yViugsdlMsumRVAaza9GcJG2NO8u3lEy4OLsotD1MhpWH9a0NDpDVp1U4IYtLh
	 UvGFwCdgXP9Lg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] KVM: arm64: nv: Print nested mmu info in
 kvm_ptdump_guest_show()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei-Lin Chang" <weilin.chang@arm.com>
Cc: "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260623142443.648972-2-weilin.chang@arm.com>
References: <20260623142443.648972-1-weilin.chang@arm.com>
 <20260623142443.648972-2-weilin.chang@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 14:40:54 +0000
Message-Id: <20260623144054.B91D21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Pre-existing Use-After-Free and NULL pointer dereference in debugf=
s handlers due to concurrent MMU teardown.
--

commit 09a8b839f22b6806feaaf12ccca901b340acd24f
Author: Wei-Lin Chang <weilin.chang@arm.com>

KVM: arm64: nv: Print nested mmu info in kvm_ptdump_guest_show()

This commit extends kvm_ptdump_guest_show() to print VTCR, VTTBR, and s2
enabled information for valid nested MMUs. It also converts the MMU lock us=
age
to use a lock guard.

> diff --git a/arch/arm64/kvm/ptdump.c b/arch/arm64/kvm/ptdump.c
> index c9140e22abcf1..2a6afe67646af 100644
> --- a/arch/arm64/kvm/ptdump.c
> +++ b/arch/arm64/kvm/ptdump.c
> @@ -155,9 +155,16 @@ static int kvm_ptdump_guest_show(struct seq_file *m,=
 void *unused)
>  		.seq		=3D m,
>  	};
> =20
> -	write_lock(&kvm->mmu_lock);
> +	guard(write_lock)(&kvm->mmu_lock);
> +	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
> +		if (!kvm_s2_mmu_valid(mmu)) {
> +			seq_puts(m, "invalid nested mmu\n");
> +			return 0;
> +		}
> +		seq_printf(m, "0x%016llx 0x%016llx %d\n", mmu->tlb_vttbr,
> +			   mmu->tlb_vtcr, mmu->nested_stage2_enabled ? 1 : 0);
> +	}
>  	ret =3D kvm_pgtable_walk(mmu->pgt, 0, BIT(mmu->pgt->ia_bits), &walker);

[Severity: High]
This is a pre-existing issue, but can this dereference of mmu->pgt cause a
NULL pointer dereference or a Use-After-Free?

If the process holding the VM dies, kvm_mmu_notifier_release() is triggered.
This uninitializes the stage-2 MMU and sets mmu->pgt =3D NULL for the canon=
ical
MMU. However, the KVM struct can be kept alive by open file descriptors for
debugfs files, so kvm_destroy_vm() is not called yet.

If a concurrent reader accesses the stage2_page_tables debugfs file and
invokes kvm_ptdump_guest_show(), could it blindly evaluate
BIT(mmu->pgt->ia_bits) here and trigger a NULL pointer dereference?

Similarly, in kvm_pgtable_debugfs_open() for other debugfs files like range
or levels, the mmu->pgt pointer is cached at open time without synchronizat=
ion:

	pgtable =3D mmu->pgt;

	ret =3D single_open(file, show, pgtable);

Could this lead to a Use-After-Free in the show handlers if the page tables
are freed by concurrent MMU teardown before a read occurs?

> -	write_unlock(&kvm->mmu_lock);
> =20
>  	return ret;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623142443.6489=
72-1-weilin.chang@arm.com?part=3D1
