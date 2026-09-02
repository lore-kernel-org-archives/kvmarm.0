Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066154AD7CD;
	Wed,  2 Sep 2026 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368394; cv=none; b=SsJRe7dCfRp386QFSxcsURJR4MhUzytx84fM4aBExzXGLf0nck+Zb72r7tGYbSuWYWmggNJ8YT8mrdXi6PE/yO/+bwHrdvUNSZQjpPdyWvihm7g+xSue/H77YTRNYrAFaOh62SAvw+FS6t3TxLRx0OTW8InUQle28tDsj/5Rf6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368394; c=relaxed/simple;
	bh=4IrjokeO3RmvbsCQVcI2vWRQ/rev4a64ndJXQ6+QFcs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PrL/yUM7nGzM7BGRDG+cq7rtBgcAO+kW1rzSP3LhnwK4mQwLMKHEPLsCjJ+2Ezb5BvXffG8uhDJs+XyZEWZfgfNbsSFlrE2xV3RKRwjrCfzgXtjrWX2iL/l8EUaML+zdbguI3bsrIt1blR0oIND0rvbWx7kZZah0oaHI7zNOtOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0DNIiS1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0DNIiS1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506631F000E9;
	Wed,  2 Sep 2026 16:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788368392;
	bh=MHSyxEIWpI7DS2F+Eh3RRbWwvuHCBHIP0wqf2HciEIs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g0DNIiS1ZHs3YnP4bJPLZ4osn2UDQi2H2YOxIkEWTOcLg9MdMfuPdJgEAa7DM1JCt
	 HvL4TH6acNLjTM0lhAoXfHAlA41aqjG6rBhib8gG5Ne4dtNjPK6exbjSzoTjIyN5t6
	 RQYd+gdRfaP8LPod20DXH9hbUwlz8/3MYSjHi3kmutQPLzYKKoLxP5I7lxmYq0hskT
	 2cWTnu/4chJJz9Q47YrFSqoE0IEV2Knhp/GWdQuQ8+qkEMyKT4X422TLgeeKIUYNxW
	 yXc2firJ/MeCmT5hqiYiN+a+3QxFGt/H/Op3f0QrmtluOApnJWnZZqhcaxTAYzbEAN
	 H0jk+5XGS0JAg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 20/20] KVM: selftests: Add arch hook to force page
 tables to be naturally aligned
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260902164123.2546762-21-seanjc@google.com>
References: <20260902164123.2546762-1-seanjc@google.com>
 <20260902164123.2546762-21-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 16:59:51 +0000
Message-Id: <20260902165952.506631F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Using the ALIGN() macro with a potentially non-power-of-2 alignm=
ent value leads to incorrect alignment calculations and silent memory corru=
ption.
--

commit ff7ec91da1b3e52d1f5f08d02d9a0f7729040242
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Add arch hook to force page tables to be naturally aligned
   =20
Add an arch hook to communicate to the core physical page allocator that
page table allocations need to be naturally aligned. The hook will be used
for upcoming PowerPC support, which has MMU tables that are larger than the
guest base page size and need to be naturally aligned.

> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
> index 8b5b330a58896..57b653fbd0b1f 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
[ ... ]
> @@ -2120,7 +2127,7 @@ gpa_t __vm_phy_pages_alloc(struct kvm_vm *vm, size_=
t nr_pages,
>  	}
> =20
>  	return ____vm_phy_pages_alloc(vm, nr_pages, min_gpa, vm->memslots[type],
> -				      protected, false);
> +				      protected, naturally_aligned);

[Severity: Medium]
When naturally_aligned is true, ____vm_phy_pages_alloc() sets the alignment
to nr_pages:

	size_t alignment =3D naturally_aligned ? nr_pages : 1;
	...
	base =3D ALIGN(base, alignment);

Since ALIGN(x, a) mathematically requires the alignment 'a' to be a power
of 2, could this result in an incorrect base physical address calculation
if a caller requests a page table allocation with a non-power-of-2
nr_pages? This might silently fail to provide the requested alignment and
lead to overlapping allocations or hardware MMU faults.

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902164123.2546=
762-1-seanjc@google.com?part=3D20
