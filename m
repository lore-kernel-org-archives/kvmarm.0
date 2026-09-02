Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3E134AA1FA;
	Wed,  2 Sep 2026 16:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367989; cv=none; b=Mo3/wkHrd49spBU7IDZfs5wLubOQEyDGqmEohy/7o+WrPQqn+CYeirpvNQH2MDrXjbvFInHyPmMms6hMTDj5u1PMj54ehmcxWqhMj1MeIAIfjEzCtRAOUcMAAW0SbbjAZwSslTxCdXboxVoiuHYYpMh2nsTR9VYBCeYgZ4bkUb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367989; c=relaxed/simple;
	bh=TWuxlgNyRltsRMOfVANnXuYjaphvak+L34+J9r9TsSk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bqTJh44eeGVr2yT9l/zdk73zyuR4b7Ory89UR14ZP80e2MUYlpgG/Lu2bf5bkJkQco2QgHZIf2YcmXCOpfSY4P1ryuOu/VpqHZkdFwouNiBwhVAUHCj04d86/bnH7HXl1/WJB02joMDWLR7Vnu96H//JyehXK/YKoxF/jh68qLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yomaj2i0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yomaj2i0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E48D1F000E9;
	Wed,  2 Sep 2026 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788367988;
	bh=sji3+rrCfAZ5I7yadAID4Mbm51SJPf3CMAj23bHgC5o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yomaj2i0gKIlF505ERKv4/5EegqonQ0FrbQ1ZksywnSoaXxmVaso41/F57jfWvXTo
	 MHYPVSB7KAxRWf7BzCaOlp8iOaA5rKwj8XaxqpK/29nyp9K8+1ar3iO0azXwFYrdYY
	 QkoOL8s7m5283WmPXN+Vp+UmQj+BJvJYxaCdaP8+yZ/y/LYtRdEg3t9eSeqOB/eVRl
	 0zvzh09+FXWcY96vRI54pXrcqTe+y9+9wFCvgaw6vg5imyDGcYg9x87IjRpYpCI7p2
	 5QcjoqrnbObbQTtGVg/C7F3AyZfBSsiIhw3aaLDY9GroIunp7tjlqqKQo5x9DlHVQj
	 P6+YxyKKWNuLg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/20] KVM: selftests: Add TEST_EXTRA memory region
 type for "special" memslots
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260902164123.2546762-14-seanjc@google.com>
References: <20260902164123.2546762-1-seanjc@google.com>
 <20260902164123.2546762-14-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 16:53:07 +0000
Message-Id: <20260902165308.1E48D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Typo in the documentation comment for memory region types ('TEXT_EX=
TRA' instead of 'TEST_EXTRA').
--

commit 72083c9d1df29879d635314499b7e5b9848895ef
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Add TEST_EXTRA memory region type for "special" memslots

And another memory region type to deal with extra, one-off memory regions,
and use the new type to manage x86's SMRAM memslot, as another step towards
taking the region type instead of the raw memslot in the physical page
allocator APIs.

> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
> index c8faa8a02b93c..b6b96d6978b21 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -82,11 +82,45 @@ struct userspace_mem_regions {
>  	DECLARE_HASHTABLE(slot_hash, 9);
>  };
> =20
> +/*
> + * Memory region types are passed to various page allocators to communic=
ate
> + * various properties and metadata related to the allocation.  Note, the
> + * descriptions below described the primary usage of each type.  Individ=
ual
> + * tests may allocate memory for other purposes.
> + *
> + * By default, all regions except TEST_EXTRA are mapped to memslot '0'. =
 The
> + * TEXT_EXTRA region is left unmapped as it's intended to be used only f=
or test
       ^^^^^^^^^^

[Severity: Low]
Is there a typo here ("TEXT_EXTRA" instead of "TEST_EXTRA")?

> + * specific allocations, i.e. should never be used by core/infrastructur=
e code.
> + * Tests can override the memslot for any or all types, e.g. so that all=
 test
> + * data is allocated from a curated memslot.
> + */
>  enum kvm_mem_region_type {

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902164123.2546=
762-1-seanjc@google.com?part=3D13
