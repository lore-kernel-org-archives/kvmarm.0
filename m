Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E7E1B87C0;
	Wed, 26 Aug 2026 23:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787786133; cv=none; b=Xjytyw8BjtXej1vLYLoYQoAHzpfnw9bRKYn4gpJE1yorOINPBGCc2SBb7v6A9wLIS0ug7JhtmhiCDNT04QOdcJNe3tgcvdLjqu5EO5lNbZxUlRTsDcxCkEavBcgx0hwHAfmCkRd5nG4I3hSSwsJPnWSK3/04mMNvFl0AMMinubY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787786133; c=relaxed/simple;
	bh=EsRjqUd7DYVY67wmC+o6mSu2AZPG9PREbxXImSC5tJM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=r3RmYWbJ1e8xSaUEI5s1dF00laKuC2+kVWbqjbF2yIu6MoM/YcVuWYJOQioMChGE6VBwlNNJX8pP56Mm4d9awEJdXb0SxhEcC7sbEHO7vRY/8ziBApSK7KVKtkf3UhksJ2CfQvdLHwqLzBdvJds8lIMrnOUkoR6C1f2fATxT4fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAXnhSfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAXnhSfD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40D71F000E9;
	Wed, 26 Aug 2026 23:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787786132;
	bh=inhWLjY9DI48pvEQ9Y1kVYzvTyrAPly5Ug5CfioFaz4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aAXnhSfDTuEZ580LZuqc+C4EuoszcLC8XgrENMpQVQCY1BmTjlO9iiRVKCSRSZI+B
	 xSMLvBWlcdWwvpKMWoj0KJtjn4Wiq0oZYqgQnHDccFOlSmJkqb/gdvyHjyrTYOx006
	 q0tqIYQf8zTV+TRQxzM6mZHH9eNsmo2tQCGbRQhai3IFvVsNJXUM9cNyl/405hCEee
	 qoIsBHFsNcJjq7FCXV/HA+GZDy02TkKLdTsoDZw/6QQECwvfNcvyJy8ingVHduBut6
	 rNNk1YxaJnduMlRyQetZ1OHRWcO1WfnOIuE+aB7XVt1Qg9pWAkbe2c+/n32oqcFWgi
	 lWs6DBw6VXU9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 13/20] KVM: selftests: Add TEST_EXTRA memory region type
 for "special" memslots
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sean Christopherson" <seanjc@google.com>
Cc: kvm@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev
In-Reply-To: <20260826230511.972824-14-seanjc@google.com>
References: <20260826230511.972824-1-seanjc@google.com>
 <20260826230511.972824-14-seanjc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 23:15:31 +0000
Message-Id: <20260826231531.B40D71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The newly added documentation comment for `enum kvm_mem_region_type=
` incorrectly states that all regions are mapped to memslot '0' by default.=
 This is false for the new `MEM_REGION_TEST_EXTRA` type.
--

commit 80ca587b6992ae5dadcd1c12481741cde386a790
Author: Sean Christopherson <seanjc@google.com>

KVM: selftests: Add TEST_EXTRA memory region type for "special" memslots

This commit introduces a new MEM_REGION_TEST_EXTRA memory region type for
managing one-off extra memslots, such as x86's SMRAM memslot. It also adds
documentation comments explaining the intended usage of each memory region
type.

> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
> index 14f87c8a00ec6..f4f4f360a10b7 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -82,11 +82,43 @@ struct userspace_mem_regions {
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
> + * By default, all regions are mapped to memslot '0'.  Tests can overrid=
e the
> + * memslot for any or all types, e.g. so that all test data is allocated=
 from a
> + * curated memslot.
> + */
>  enum kvm_mem_region_type {

[Severity: Low]
Does this comment accurately reflect the behavior of the newly added
MEM_REGION_TEST_EXTRA type?

It appears that MEM_REGION_TEST_EXTRA is left unmapped by default (initiali=
zed
to KVM_INVALID_MEMSLOT in ____vm_create()) rather than mapped to memslot '0=
'.
This allows it to be safely overridden later without triggering the asserti=
on
in ____vm_override_mem_region().

Could this documentation be misleading for developers writing new tests who
might assume MEM_REGION_TEST_EXTRA has a valid fallback memslot and try to
use it without explicitly overriding it first?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826230511.9728=
24-1-seanjc@google.com?part=3D13
