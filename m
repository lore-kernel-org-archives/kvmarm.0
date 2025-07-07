Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817B527713
	for <kvmarm@lists.linux.dev>; Mon,  7 Jul 2025 23:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932673; cv=none; b=hPw1NgpXYj3bKEcpsiq3w7n3L5SrkZhhK+pYDhOkQKpGnN7hnvr7slINQy3/2Vc0BEdvjMfW6LDOeHxH6+pwh5UZNUOHFe1IpLzeoj6SWSi5TVtgIe2nmyz96N2lwxJfqL9VOffwbo4r5g+VnF8wgg4rZ484OlTHI7PetYaT+m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932673; c=relaxed/simple;
	bh=RvvEwJiSD+3SI0wXqFBptrxHRXaLDKR3oEsDJrWyR4k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PZjtaFXi0ZoGB9m0IxUm09Q91SkZ+j7ZEFbwOcO/lXFCnf7pY6STc1fHjTh10yLBxP7NwBNye341SpnsiI2ojpI/r11p64G0ZkljDxwdWBQakdxr/GsmSqXdqNm20VLP536+c0qW8O0RMVqFsErzWaX3ZRlvmPdCMZ3sAlC0DNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iCB7Z7v+; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iCB7Z7v+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1751932668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ID9d9BcvZSRiBAL43tNvk/za2oURSldztZwoYSZZSRw=;
	b=iCB7Z7v+qgC1UWXo11wDeTQYTDq197Mo2PfW2D13YQg3yqRj6c3A6ST4556ikTQqdozS3O
	j4raBn9VW285hppCFSam1N59OXM37/ATWcv3SJciEGO9YoW9HTTNmSOSp8xIhlV5mFouXV
	6VErk7tOb4bvc4aPcMwXIMUx/2NXg+k=
From: Oliver Upton <oliver.upton@linux.dev>
To: maz@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	ryan.roberts@arm.com,
	shahuang@redhat.com,
	lpieralisi@kernel.org,
	david@redhat.com,
	ddutile@redhat.com,
	seanjc@google.com,
	Jason Gunthorpe <jgg@ziepe.ca>,
	ankita@nvidia.com
Cc: Oliver Upton <oliver.upton@linux.dev>,
	aniketa@nvidia.com,
	cjia@nvidia.com,
	kwankhede@nvidia.com,
	kjaju@nvidia.com,
	targupta@nvidia.com,
	vsethi@nvidia.com,
	acurrid@nvidia.com,
	apopple@nvidia.com,
	jhubbard@nvidia.com,
	danw@nvidia.com,
	zhiw@nvidia.com,
	mochs@nvidia.com,
	udhoke@nvidia.com,
	dnigam@nvidia.com,
	alex.williamson@redhat.com,
	sebastianene@google.com,
	coltonlewis@google.com,
	kevin.tian@intel.com,
	yi.l.liu@intel.com,
	ardb@kernel.org,
	akpm@linux-foundation.org,
	gshan@redhat.com,
	linux-mm@kvack.org,
	tabba@google.com,
	qperret@google.com,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	maobibo@loongson.cn
Subject: Re: [PATCH v10 0/6] KVM: arm64: Map GPU device memory as cacheable
Date: Mon,  7 Jul 2025 16:57:30 -0700
Message-Id: <175193253138.1687959.6241606194423745301.b4-ty@linux.dev>
In-Reply-To: <20250705071717.5062-1-ankita@nvidia.com>
References: <20250705071717.5062-1-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Sat, 05 Jul 2025 07:17:11 +0000, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Grace based platforms such as Grace Hopper/Blackwell Superchips have
> CPU accessible cache coherent GPU memory. The GPU device memory is
> essentially a DDR memory and retains properties such as cacheability,
> unaligned accesses, atomics and handling of executable faults. This
> requires the device memory to be mapped as NORMAL in stage-2.
> 
> [...]

I've gone through one additional round of bikeshedding on the series,
primarily fixing some typos and refining changelogs/comments. Note that
I squashed the kvm_arch_supports_cacheable_pfnmap() into the patch that
adds its caller and unwired it from arch-neutral code entirely.

Please do shout if there's an issue with any of this and thanks for
keeping up with the several rounds of review.

Applied to next, thanks!

[1/6] KVM: arm64: Rename the device variable to s2_force_noncacheable
      https://git.kernel.org/kvmarm/kvmarm/c/8cc9dc1ae4fb
[2/6] KVM: arm64: Update the check to detect device memory
      https://git.kernel.org/kvmarm/kvmarm/c/216887f79d98
[3/6] KVM: arm64: Block cacheable PFNMAP mapping
      https://git.kernel.org/kvmarm/kvmarm/c/2a8dfab26677
[5/6] KVM: arm64: Allow cacheable stage 2 mapping using VMA flags
      https://git.kernel.org/kvmarm/kvmarm/c/0c67288e0c8b
[6/6] KVM: arm64: Expose new KVM cap for cacheable PFNMAP
      https://git.kernel.org/kvmarm/kvmarm/c/f55ce5a6cd33

--
Best,
Oliver
