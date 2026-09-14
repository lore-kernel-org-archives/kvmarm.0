Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E01135C6A4
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 07:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789369538; cv=none; b=thlIJMmZZKiUPCH1fP+sLqvf2qJzrPjlomQWhj2B4lDbSguv0OMHwyaCP1oRZHf3eY2itZv9LVvQQ3OzJdXowY8OYM40URSLRr1lDavMGW85ni53CcZ9X9/LF+wekKPh4j8oBEd1p5pBBhUsuItb3bPBWrOmEbmekYIhVtTwsLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789369538; c=relaxed/simple;
	bh=f4bBHnuaOYmBam8wzhDa3JZk7aD2ofSf19uGateKShE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BGzhUdg0UHRG4fAnFwrTMubZ69oBu0Z+AuOKiatvhyFtglZCuNlZKgikav244Vcbbb5BK41iiYbv37vOd5lmBY2WktBkDBvtQ8QPbG/+Biac0XjW+53rJE00UjWrt6rSXHyeliZQofSonlWvHFspLEcCxvkSF0Fic4tTclBjpyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LZurWqCc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LZurWqCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877D91F000FF;
	Mon, 14 Sep 2026 07:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789369536;
	bh=kgxPgtCmobJTd2WUQg18bmtYEnR30eKvt/s4DS5ACk0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LZurWqCcL+zZMsxmehJ3kQ/BumwMkzbG2rFVE7f/V7V+nyhzGnR0sYXL0ilnFkxez
	 FJ5aZ0RKOZkxZFsk5b2vlZC5b+YvMBFwWfXkEHfhTtPyStTqkOygK78eCO78Woz1Nl
	 3TOmFZYAkBgcInkck4Z8bdVXjJTwelxGrlHInOWBnsbj8J8cbZq6W9YYPPBxy0Au5Y
	 61Wmfl4p6nWCAp6CNevpC9cHWDOsEfzyGFac2kFwqPLDg+btXS5MaI8N1czOQiUcrI
	 /08m7MVOx4annIE75latneJKtPJ8aGgEKRZ5AGAGwsSFt295YPFZJNT7TSuAJ0Vx2z
	 lQczGRFM8byjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] KVM: arm64: Pin the host vCPU before adjusting its PC
 under pKVM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fuad Tabba" <fuad.tabba@linux.dev>
Cc: "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260914065136.3418404-1-fuad.tabba@linux.dev>
References: <20260914065136.3418404-1-fuad.tabba@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 07:05:36 +0000
Message-Id: <20260914070536.877D91F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Double-fetch (TOCTOU) and unvalidated dereference of the host-=
controlled `vcpu->kvm` pointer creates an arbitrary EL2 memory leak.
--

commit 6841c04b3ad40b222469871cbf4d11537656c507
Author: Fuad Tabba <fuad.tabba@linux.dev>

KVM: arm64: Pin the host vCPU before adjusting its PC under pKVM

This commit pins the host vCPU and its VM around __kvm_adjust_pc() when no
hyp vCPU is loaded, to prevent the hypervisor from panicking by dereferenci=
ng
an unmapped host vCPU. A loaded hyp vCPU implies both are already pinned.

> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe=
/hyp-main.c
> index 9a3b92e626adb..e41b4c181eb62 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
[ ... ]
> +static void adjust_pc_unloaded(struct kvm_vcpu *host_vcpu)
> +{
> +	struct kvm *host_kvm;
> +
> +	if (hyp_pin_shared_mem(host_vcpu, host_vcpu + 1))
> +		return;
> +
> +	/* The exception entry reads the VM's MTE flag. */
> +	host_kvm =3D kern_hyp_va(host_vcpu->kvm);
> +	if (!hyp_pin_shared_mem(host_kvm, host_kvm + 1)) {
> +		__kvm_adjust_pc(host_vcpu);

[Severity: Critical]
This is a pre-existing issue, but does this create a double-fetch (TOCTOU)
vulnerability that allows the host kernel to leak arbitrary EL2 memory?

When a vCPU is unloaded, adjust_pc_unloaded() reads host_vcpu->kvm from
host-shared memory (the first fetch) and pins it. When a vCPU is loaded,
handle___kvm_adjust_pc() directly calls __kvm_adjust_pc(host_vcpu) on the
host_vcpu without pinning it here.

In either case, deep inside the __kvm_adjust_pc() call path,
enter_exception64() in arch/arm64/kvm/hyp/exception.c re-reads vcpu->kvm
directly from the host-shared vcpu structure (the second fetch):

	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))

Because the host kernel can concurrently modify host_vcpu->kvm between the
pin (if any) and this second fetch, it could redirect the pointer to an
arbitrary EL2 address. kvm_has_mte() would then dereference this unvalidated
pointer to test the KVM_ARCH_FLAG_MTE_ENABLED bit (bit 1).

If that bit is set, it updates the PSR_TCO_BIT in the vCPU's CPSR, which ge=
ts
written back to host-accessible memory in host_vcpu->arch.ctxt.regs.pstate.=
 By
shifting the base address and observing the result, the host could leak
EL2-private or protected guest memory bit by bit.

> +		hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
> +	}
> +
> +	hyp_unpin_shared_mem(host_vcpu, host_vcpu + 1);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914065136.3418=
404-1-fuad.tabba@linux.dev?part=3D1
