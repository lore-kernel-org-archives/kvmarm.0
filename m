Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E8C81724;
	Mon, 14 Sep 2026 07:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789371846; cv=none; b=XB9F6gxK9sAPg3XkVCfyEwSd4zk1TwuYyEAZSM63tq+lN9lymCJPV0YKCKFh4uCz1pDEGnOecNgijJxG+d1FFpz6V3lpW4M0ammg42i3ndZ/2sbVu4ZdK3bw4dqD/xaUDzZtDPoSjWOj1TqcAoPh9h9JmcOu+lZmaAQttsPXu54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789371846; c=relaxed/simple;
	bh=LPv6WKphIl01nIpZXcRte1gWv7DmEQhxm2gkpyDARrA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nmHLWoq/5F14maRBZDyAJAUeg413hhD4sB0v2VcY5rnvZCgSNtiKV8nF+++A5DB14vrZPEGuHN1mNz0x8Co5WeFujsMpDcIoi0kF+YDvRzUl8R9h+O7jhPwF8sOG8JqQtDwewlNTax11Q7N6USZxdR7rqrNCzpLpXo4T/lCGGcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DnHEbkbR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DnHEbkbR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D220E1F000FF;
	Mon, 14 Sep 2026 07:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789371845;
	bh=5P3hP3y9yVIlvg/iA2khdJEuM4+4ZoX7xT/j7z4g1ok=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DnHEbkbRsyCB6wYVS5eLk1mqaj9h8UPbxxLDbfQl7RWclo3oFu1NRzbKuLca7JX3T
	 NeyXv4U1kEmDwEeYsikG/bu40pmXY8dII5QSSsmgjQNhxbAxIptyx4gOBk17qK7Bov
	 APPEg4jhvrJQOlEStN9tadacI8OT4k2yf0UvbmSpZ2DqVKnu1uOkzAGBopP3RO4l7M
	 HMp3naxGBdxKJILmOUGDoO42kFi+I9AT/3WcTngyOafyDxdeBf/RUDiCC4d5zJpOPi
	 XqylIQahZZt2gY/eSfLRAeH9nqYu+n4eDCbyXywov5d1SP77pqWR3j2IGq5Q9X3Cpq
	 0vUo/O3gkMK5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] KVM: arm64: selftests: Support five-level
 stage-1 page tables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Itaru Kitayama" <itaru.kitayama@fujitsu.com>
Cc: kvmarm@lists.linux.dev, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260914-arm64-52bit-va-v2-1-3911cb9d4ad4@fujitsu.com>
References: <20260914-arm64-52bit-va-v2-0-3911cb9d4ad4@fujitsu.com>
 <20260914-arm64-52bit-va-v2-1-3911cb9d4ad4@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 07:44:04 +0000
Message-Id: <20260914074404.D220E1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The `type` array in `pte_dump` is missing the entry for P4D, causin=
g it to print an empty string for level 0.
--

commit ec0c73a180f67ed464cb14e88f74413194ff828e
Author: Itaru Kitayama <itaru.kitayama@fujitsu.com>

KVM: arm64: selftests: Support five-level stage-1 page tables

This commit adds support for five-level stage-1 page tables in the ARM64
KVM selftests. It extends the page-table helpers and level validation to
handle the new architectural level -1. This enables testing 52-bit VA
configurations with a 4K translation granule.

> diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/te=
sting/selftests/kvm/lib/arm64/processor.c
> index 01325bf4d36fc..b589368bf8222 100644
> --- a/tools/testing/selftests/kvm/lib/arm64/processor.c
> +++ b/tools/testing/selftests/kvm/lib/arm64/processor.c

[ ... ]

> @@ -214,7 +249,7 @@ u64 *virt_get_pte_hva_at_level(struct kvm_vm *vm, gva=
_t gva, int level)
>  			goto unmapped_gva;
>  		break;
>  	default:
> -		TEST_FAIL("Page table levels must be 2, 3, or 4");
> +		TEST_FAIL("Page table levels must be 2, 3, 4, or 5");
>  	}
> =20
>  	return ptep;

[Severity: Low]
Does this change miss updating the string names in pte_dump()?

Looking at pte_dump() in tools/testing/selftests/kvm/lib/arm64/processor.c,
the type array maps the translation level to its string name:

	static const char * const type[] =3D { "", "pud", "pmd", "pte" };

When the test framework is compiled with DEBUG and dumps a 5-level page
table, virt_arch_dump() calculates the starting level for pte_dump() as 0.
Since the array was not updated to include "p4d", debug output for level 0
will print an empty string instead of "p4d".

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-arm64-52bi=
t-va-v2-0-3911cb9d4ad4@fujitsu.com?part=3D1
