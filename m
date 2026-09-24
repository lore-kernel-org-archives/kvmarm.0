Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B671470139
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790245150; cv=none; b=lXKcM7lDhZM3T6+LqBiuQGobZTTAAguJzqDwZpfwXO8xnyfO9Mk4RAbkYP95oN4UvB86cgImR3QuvbXHKpUCX/68p20XZYOeOCa+b8Zjg3kJGabFIvZucaj8ZBUTL0eBfmrmarSykypByir8ntVJsdkCz3rKXHOX3Zg1Co8we6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790245150; c=relaxed/simple;
	bh=kd/bnDOt/8UiWtWgaEnLygaWvFuGxfVn/eDNFi4Znjs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZulfAJizUOdXWTYX0wDgQ6HdEblx9TwycUcNB/63czzrJxTGQU2j7ISXLLzeEl61QFsGrDNFI7tnV4KW1xpw0W/b1ylF1gkUO/DLXUZxWeR7PuVJuwgS6vSt+6msdti3GTyNgSaYeqBHSKUKhgwIhQhCVSAKqqaRWhb0k6pds4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j2yN0y6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j2yN0y6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6261F000FF;
	Thu, 24 Sep 2026 10:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790245147;
	bh=Tbrr7J6E2HeXxkSKuLh9nUnClr0ZU1/BUwzAxPApq2k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j2yN0y6k4mm+PzayMQwfe58boRPOo/pom2eLmQtMu+/HLt2tevug/3Gkksx7SP0yt
	 mWh+rcMG/x4nFWJBr9WDoULFgYt8M2EqU6CYRtjYtl/LTWfVEVKLbdQJXyhJ9gcdrH
	 4p0hJbl6iprxRAdKR6ExjX/JHA+r5q5hOw1pm2tyMw3Ubch59yRo4gKl5O3N0nOQiz
	 22BYd5xxV07cOx8W/cmoDm97p4J1+j//IM39Gy1J6ZbF9zH9fqXNihL7sx/UCy46tt
	 OtqWaGLLbhQ217qAW3LOe2TIp5kuNZaIDxlbaGGsYBK7/TgtxNelUop+ZAqkcieA2/
	 dpuImRpmnsroA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v8 01/14] mm: Add an allocator for CoCo shared
 memory
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5lZXNoIEt1bWFyIEsuViAoQXJtKQ==?= <aneesh.kumar@kernel.org>
Cc: dri-devel@lists.freedesktop.org, media-ci@linuxtv.org, "Marc Zyngier" <maz@kernel.org>, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>
In-Reply-To: <20260924100529.1398790-2-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
 <20260924100529.1398790-2-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 10:19:06 +0000
Message-Id: <20260924101907.5C6261F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] mm: alloc_cc_shared_pages_node fails to strip __GFP_MOVABLE
- [Medium] mm: alloc_cc_shared_pages_node fails to strip __GFP_HIGHMEM in f=
allback path
- [Medium] mm: cc_make_shared and cc_make_private are not exported for modu=
lar callers
--

commit 3978c8ce72bbc2aa23e57a460b585808665262a4
Author: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
mm: Add an allocator for CoCo shared memory

This commit introduces a common allocator for confidential-computing guests
to allocate shared memory. It provides helpers to allocate properly aligned
contiguous pages and transition them to shared state. It also adds helpers
for transitioning memory states when callers manage their own backing memor=
y.

> diff --git a/mm/cc_shared.c b/mm/cc_shared.c
> new file mode 100644
> index 0000000000000..85e16f4504b8f
> --- /dev/null
> +++ b/mm/cc_shared.c
[ ... ]
> +int cc_make_shared(void *addr, size_t size)
> +{
> +	int ret =3D cc_validate_transition(addr, size);
> +
> +	if (ret)
> +		return ret;
> +
> +	return set_memory_decrypted((unsigned long)addr, size >> PAGE_SHIFT);
> +}

[Severity: Medium]
Will this function be unavailable to dynamically loadable modules since it
is missing an EXPORT_SYMBOL_GPL() macro?

The commit message states it should be usable by callers managing their own
backing memory, but virtio or guest drivers won't be able to link to it
without an export.

> +
> +int cc_make_private(void *addr, size_t size)
> +{
> +	int ret =3D cc_validate_transition(addr, size);
> +
> +	if (ret)
> +		return ret;
> +
> +	return set_memory_encrypted((unsigned long)addr, size >> PAGE_SHIFT);
> +}

[Severity: Medium]
Does this function also need an EXPORT_SYMBOL_GPL() macro so that modules
can successfully link and call it?

[ ... ]
> +static int __alloc_cc_shared_pages_node(int nid, gfp_t gfp,
> +					size_t requested,
> +					struct cc_shared_pages *mem)
> +{
[ ... ]
> +	/*
> +	 * State transitions require a linear-map address and may modify memory.
> +	 * Allocate from low memory and defer requested zeroing until afterward=
s.
> +	 */
> +	gfp &=3D ~(__GFP_HIGHMEM | __GFP_ZERO);

[Severity: High]
Does this code inadvertently leave __GFP_MOVABLE intact if passed by the
caller?

Pages are returned as shared memory, but they lack migration hooks
(movable_operations) to handle encryption state transitions during page
migration.

If a caller passes __GFP_MOVABLE, the page might be placed in ZONE_MOVABLE.
Since the kernel migration code does not know how to handle encryption state
transitions, the page cannot be safely migrated. Could this permanently pin
the movable zone, thereby breaking memory hot-unplug and compaction?

> +	if (nid =3D=3D NUMA_NO_NODE)
> +		page =3D alloc_pages(gfp, order);
[ ... ]
> +int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
> +			       size_t requested,
> +			       struct cc_shared_pages *mem)
> +{
[ ... ]
> +	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT))
> +		return __alloc_cc_shared_pages_node(nid, gfp, requested, mem);
> +
> +	order =3D get_order(requested);
> +	if (order > MAX_PAGE_ORDER)
> +		return -EINVAL;
> +
> +	if (nid =3D=3D NUMA_NO_NODE)
> +		page =3D alloc_pages(gfp, order);
> +	else
> +		page =3D alloc_pages_node(nid, gfp, order);

[Severity: Medium]
Can this fallback path inadvertently allocate a highmem page?

The function's kernel-doc explicitly guarantees: "A memory-state transition
requires a valid linear-map address, so such allocations never come from
high memory".=20

In the non-encrypted fallback path, the caller's unmodified gfp flags
(potentially containing __GFP_HIGHMEM) are passed directly to alloc_pages()
or alloc_pages_node() without any masking.

If a caller passes a flag mask containing __GFP_HIGHMEM (e.g., GFP_HIGHUSER)
on a system without memory encryption, the fallback path will allocate a
highmem page. Any subsequent attempt by the caller to access the memory via
page_address() could return NULL and cause a crash, breaking the API
contract. Should the gfp flags be sanitized in this path as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924100529.1398=
790-1-aneesh.kumar@kernel.org?part=3D1
