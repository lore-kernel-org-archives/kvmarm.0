Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E2331DDBF;
	Wed, 26 Aug 2026 23:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787786350; cv=none; b=ZDVjR1IDJLuky/C2T+Ab7mdbvqnCPjxyEDjyxEAl9+4dLeDF2jFsUH1Tv6DQpmQMchgShha50sd4Iuibw6pJAH506naTQLw5rUZI6hJgCPgQIuQOcbp2Cy8yMsAtAb2v8MOxVu+u1GRKaaKDehOOyl9OPJsXTSKBTOZo7rS/FvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787786350; c=relaxed/simple;
	bh=ckA3a27gnDBELqvJ32J4/yd+E6yxKqlJ0OeK+cyrCfc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H6phWv4kt/k44+FhelKE6AEa7a37a/+bAND9FeM7t1B04dA/nuAxORdB6i8dhB2J9+6WP+2RBOrHby7u27is49GUA02DMs2ZY5YpWI7IK6al7SFVXKQtU4b+ZmK6Teh4Vog9S6UXdI22VRPBr3DsBCIuhi5NZB3zdmzgKtzbUBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=euu1r2r6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="euu1r2r6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3001F000E9;
	Wed, 26 Aug 2026 23:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787786348;
	bh=9idGDynj+/naQFf4lNovnXEl5p3tzkod/MPtiCq7PPQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=euu1r2r6C5VZsAucnDRMlc35Bu5r1c/tmNTCg9OQB6gefxZpGkQlwlvjMxBTKMmSd
	 TBPoBs5e+Wj2Bo3ZNGoW+eu/3Fc9qxbpAmKBkuPqkRmPY3QV9VY0KooKRXLfAEwROr
	 kkld906yL6HTMFeZQd51+q8LU1O/7SJT+eZWiJlIxEusPQS22CPEebF3OqMvJ+osTf
	 6nszdn/WOB5IlEN/zLD0CJF6dEpkXvoja+lNb/uuabD83YxTp6dbFK6PwrnbtwoO2U
	 IH/5sqerEWQggaHBZWr1EPuEuQv6zjjrY5IZi+MIU+f0DunAIPuhIZlUirKVhiqx0I
	 GvO6tIuZqrn5g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 19/20] KVM: selftests: Automatically pick min_gpa for
 allocations based on region type
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvm@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260826230511.972824-20-seanjc@google.com>
References: <20260826230511.972824-1-seanjc@google.com>
 <20260826230511.972824-20-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 23:19:08 +0000
Message-Id: <20260826231908.8A3001F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The static global variable `gpa_base` is no longer used outside of =
`setup_memslot()` after this patch and should be converted to a local varia=
ble.
--

commit 1b35d93b3db739cce7476eddad2ce87d3cb799ed
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Automatically pick min_gpa for allocations based on region =
type

This patch modifies the memory allocation logic to automatically choose the
minimum GPA for physical page allocations based on the region type. It
streamlines how minimum GPAs are handled across various wrappers and tests
by categorizing them into default minimums, page tables, and custom memslot=
s.

> diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/=
testing/selftests/kvm/arm64/vgic_lpi_stress.c
> index a45c0849a47a9..b4c651ea385d8 100644
> --- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
> +++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
> @@ -191,28 +191,25 @@ static void setup_test_data(void)
>  	gpa_t cmdq_base;
> =20
>  	test_data.device_table =3D vm_phy_pages_alloc(vm, pages_per_64k,
> -						    gpa_base,
>  						    MEM_REGION_TEST_EXTRA);

[Severity: Low]
Does this change leave the static global variable gpa_base with no uses out=
side
of setup_memslot()?

Since it is no longer used here in setup_test_data(), could it be converted=
 to
a local variable where it is still used?

tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c:setup_memslot() {
	...
	gpa_base =3D ((vm_compute_max_gfn(vm) + 1) * vm->page_size) - sz;
	vm_override_mem_region(vm, MEM_REGION_TEST_EXTRA, VM_MEM_SRC_ANONYMOUS,
			       gpa_base, TEST_MEMSLOT_INDEX, pages);
	...
}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826230511.9728=
24-1-seanjc@google.com?part=3D19
