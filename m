Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B92B38F92D;
	Mon, 21 Sep 2026 06:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789973865; cv=none; b=ehrafjAan5fywZw4B/sIHUZw0HB9p3dI9M1NDH4AiXzQAwz/pjQlhGxJ1ny44IuNlDxdjkeNW7Bm3VSr+B12xC0g0fc0+ltOL3zhTj00Qg1dBuY/djaI7OaPIa6FYVG/nxDupNQyRpVyS576WZ1vFAuLbXICtGZ+OAAvJMr2Dy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789973865; c=relaxed/simple;
	bh=3k0P7egRJAwhHGXAhVPjJL8SDOJ7IUNyGn8/gepYaG8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=du33/vvHYAcJoPdETDasA297TC1SLxXsE7aGEyCZOs1rCmCrRpKjuuIbqqYU1qLvZjayT7+P75HmlZLirQpdpAGZR0hmDyesvGGMNnqIevc2DeqtucVF+tO+fwxwwzZ6OXnfEcTt7akKjZogxjuQ2tEluqqTlSRIoEL28Sm3PYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CsdfJbqG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CsdfJbqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED401F000FF;
	Mon, 21 Sep 2026 06:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789973864;
	bh=8AbV6ioiEGOWrXlJd0nFCFw/BQn3PCB4bJsD0M3s6ZI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=CsdfJbqGXWpoA8CDYUjjF6BytwF09mEWBrwRs12h1PFAOuUvpL1ulZBI77Odkr6e3
	 k85k4aDhb3EqzqIyrQITn1tMNskmhogMSS0PWqF5df/fnFQnhjSXEAcLHXdYEgHLgU
	 Px6YjimUVJ3qyf78tMk5kL4sD2CGJlG871MTZFZFVWC+6df4fApeulWSVhtBZK2qYy
	 UI04iL/LNqwWfHfGfIJLa5xde5D/6EIVOKhW8xmYdRqG0hSIoXAPaT69WnW40l/Yz0
	 Vy+anCIK/AnSktEacdFkzptTcGHU5wTjSlNaJrEwEJD9jzO98b0cPJVafPi6VnmUw6
	 xeVMlskKehpPQ==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian K?nig <christian.koenig@amd.com>
Subject: Re: [PATCH v6 7/9] dma-buf: system_heap: Enforce shared-granule
 alignment for cc-shared buffers
In-Reply-To: <aq1V3oeDdvXobt8J@arm.com>
References: <aq1V3oeDdvXobt8J@arm.com>
Date: Mon, 21 Sep 2026 12:27:35 +0530
Message-ID: <yq5afqz33xcw.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Catalin Marinas <catalin.marinas@arm.com> writes:

> First, none of the DMA-BUF maintainers have been cc'ed. It might be fine
> for an RFC but this series got to version 6. We need their feedback.
>
> On Fri, Sep 04, 2026 at 04:04:50PM +0530, Aneesh Kumar K.V (Arm) wrote:
>> The system heap can allocate buffers that are decrypted and shared with the

 [ ... 107 lines skipped ... ] 

>
> You need to get a proper base so that Sashiko can review this series. I
> ran it through Claude and the above is wrong to go to free_buffer which
> walks over the pages list that has not been initialised yet.
>

There is a dependency on the file-movement changes in the arm-smccc bus
patch series. This was done because we agreed to move the RSI changes
out of arch/arm64 before considering further CCA-related changes for
merging.

Do you have any suggestions on how to handle this? I could include the
dependent patches when posting the new series so that Sashiko has a base
on which to apply it, and clearly mark those patches as not for merging.

-aneesh
