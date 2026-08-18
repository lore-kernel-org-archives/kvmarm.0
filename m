Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4093B45D5F0;
	Tue, 18 Aug 2026 11:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787052977; cv=none; b=DDdT7XcGreYMsgNYvG/Ops+6POYd/HvUpetnxUCnIMAE/ZAtU7uNlCHl+rmS/NNRf2YznYdCoL0N2rBWNrLjTDAMnA4LpXPduSRnzplUaAcPUc4dxgUCZYEKSh4dd7kpOedfiA5QyBcrCrGF2GOWvUbiORWF1fI+0HgbjCQuugQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787052977; c=relaxed/simple;
	bh=SDrk44kTRj4TRTSAmbA1J5vWjrR9V/Z8exhnWzX0c4k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HzRY+WEZj6Twdz6+WBMcK+fAt7PDXAVX9PmHiiWDG3ziRiq0OYkk1AuBXeSi+nEF0o+YStqDaRRgKgVhQOr/JT/St01Zr71iXhJteGDzv0ZHoHwvErH3Y/2ohjrxtsQQY2I1uttUt+iXzs20gSBZPUwInCiWu5Ujqeb5QZIywKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BdolXdlB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BdolXdlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBE01F000E9;
	Tue, 18 Aug 2026 11:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787052975;
	bh=py9xx2uXceZKFDfKNas78/LkJKxC4Dn0BzEB9QcOhLU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BdolXdlB4PVKP3MYL81etOw8s7aE34BD5V2h6BDDNDci076OV59O7F6SWPeOjY5ci
	 rQqx7Yw4u5Cro5cObDtpbQ0MO0HfCcolbKLd93ZnwE6rAi+h4dPAWB0T9nsm4lrKmh
	 mvKNToado2d7nPB2Zf89tHcHTradPWE0OFZi+IpC8wVTNQ2cnjq7NZxDQRMpiqgLwQ
	 dt0nI/RVtAZrulgjU46JF1FRwkXzFjib5vlR5KpoHRPuYzXN/fwesRcv8aeSmpy+sy
	 8tqdEbIc5kpmjdeC+7WCfESG5wYXO+bG3+tJI43u9AmFvNZsXY14cW2mAN1t/RPJWJ
	 8AZZeSksFVrrg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] KVM: selftests: arm64: Skip sea_to_user without
 1GB hugepages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Like Xu" <like.xu.linux@gmail.com>
Cc: kvmarm@lists.linux.dev, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20260818112920.26252-3-likexu@tencent.com>
References: <20260818112920.26252-1-likexu@tencent.com>
 <20260818112920.26252-3-likexu@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 18 Aug 2026 11:36:14 +0000
Message-Id: <20260818113615.5CBE01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] get_free_hugepages() overestimates available hugepages by ignori=
ng reserved pages, which allows the test to proceed and crash with ENOMEM o=
n systems with reserved pools.
--

--- Patch [2]: [PATCH v2 2/3] KVM: selftests: arm64: Skip sea_to_user witho=
ut 1GB hugepages ---
commit 5fa5666824342b3dd28a5ef6a04bb5ac183257c8
Author: Like Xu <like.xu.linux@gmail.com>

KVM: selftests: arm64: Skip sea_to_user without 1GB hugepages

This commit adds a check to skip the sea_to_user test if the host does not
have enough 1GB hugepages available, preventing a hard failure on systems
without an empty pool.

[ ... ]
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/=
selftests/kvm/lib/test_util.c
> index bab1bd2b775b6..29f9c1d60b1b7 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -222,6 +222,21 @@ size_t get_def_hugetlb_pagesz(void)
>  	TEST_FAIL("Error in reading /proc/meminfo");
>  }
> =20
> +size_t get_free_hugepages(size_t page_size)
> +{
> +	char path[128];
> +	size_t free;
> +
> +	snprintf(path, sizeof(path),
> +		 "/sys/kernel/mm/hugepages/hugepages-%zukB/free_hugepages",
> +		 page_size >> 10);
> +	if (!test_sysfs_path(path))
> +		return 0;
> +
> +	free =3D get_sysfs_val(path);
> +	return free * page_size;

[Severity: Medium]
Does this calculation overestimate the available hugepages by ignoring the
reserved pool?

The sysfs free_hugepages value includes pages that are already committed to
other mappings but not yet allocated (which are tracked via resv_hugepages)=
.=20

If the test runs on a host where free_hugepages meets the VM_MEM_SIZE
requirement but some or all of those pages are reserved, the test will
incorrectly proceed and still crash with an -ENOMEM abort instead of cleanly
skipping.

Could we also read and subtract resv_hugepages to determine the actual
allocatable count?

> +}
> +
>  #define ANON_FLAGS	(MAP_PRIVATE | MAP_ANONYMOUS)
>  #define ANON_HUGE_FLAGS	(ANON_FLAGS | MAP_HUGETLB)
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818112920.2625=
2-1-likexu@tencent.com?part=3D2
