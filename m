Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A30940D58B;
	Thu, 20 Aug 2026 11:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787224422; cv=none; b=g6QTS5M1mdALBSTqYGRDYt0Gx9gXRhFSqjome4dj7XveXN3S6MLSLlrjmW3qYfCASy5czzRP6WkywcG97kbOAdUorRixc3LsdS+LyYWLIcZbXwxr5xTLgN6Vm6bZ0/+OJHfxVbUxRVwlamkvwxvpmO8yNV+SIXomYBuvijrdMk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787224422; c=relaxed/simple;
	bh=KtI5T5Ka930wbyhgmgqkQ4FepflWZdHZnI8uHPdT3NQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Q+fNiJRGcWSzRH6cLi4QQEDcvB7ga0djLb8Cxivmu7q8LbJnHq6wBzrzvGtT+oEIekb3JAJKZMH2CC6NhKoaX8f7tcI8Ep3KkvqBu/GNT1pj6cGphbehW6e5SuLbAA5vRpbo0Bfq3qOe8iwr3yzn9+HCZgDf0G3FkS3LJrtR+wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gSYNUhgr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gSYNUhgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0C551F000E9;
	Thu, 20 Aug 2026 11:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787224421;
	bh=bi8kks1t9xNKvGVo/6jcNJzZIGuN6UX788iT+MOzMzA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gSYNUhgrqzk238wabITHC7PbgxskdNvBkQ8ykYb8gYbi3wBC4TZl4R6bUTv8izpKV
	 kqPIwwiZtspW6BlEqv9a1P6ZZARrkSzP2n3GzchQVb+zyzQj6Z7WEDwBOpZvQz6unT
	 Dzmz2+vGr8Pk1MWkENMwDieuYaxT+Ut/6cU3hKMJtUqnxBa0f/9OzdEL2xdJQ0dfw7
	 w2dOUqXtFFOaQ4ddtKCaFbMV4Ezvz4kSRNOxfeCwyW1bbN98aLSSf4n99HPepvs7nY
	 MvLV78GOznFSvpsIgXQhNbqzNIIwav8ngBFYVuC8aMBhbKESKLXTkbVjG1IFxqJukA
	 8DWpK7rnYR4eQ==
X-Mailer: emacs 30.2 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Kameron Carr <kameroncarr@linux.microsoft.com>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 07/11] coco: guest: arm64: Add guest APIs to read
 host-cached DA objects
In-Reply-To: <36877aa6-3f70-4da1-aecb-7209a33f8595@linux.microsoft.com>
References: <20260427082805.931832-1-aneesh.kumar@kernel.org>
 <20260427082805.931832-8-aneesh.kumar@kernel.org>
 <36877aa6-3f70-4da1-aecb-7209a33f8595@linux.microsoft.com>
Date: Thu, 20 Aug 2026 16:43:29 +0530
Message-ID: <yq5ao6exvycm.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Kameron Carr <kameroncarr@linux.microsoft.com> writes:

>> diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.h b/drivers/virt/coco/arm-cca-guest/rsi-da.h
>> index 297cb800edc0..88067d2230ab 100644
>> --- a/drivers/virt/coco/arm-cca-guest/rsi-da.h
>> +++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
>> @@ -10,6 +10,8 @@
>>  #include <linux/pci-tsm.h>
>>  #include <asm/rsi_smc.h>
>>  
>> +#define MAX_CACHE_OBJ_SIZE	SZ_16M
>
> Why is the limit 16 MiB? I don't see that limitation in the RHI spec.
> Does the limit come from PCI TSM?
>

I based that on the SPDM MeasurementRecordLength, which is 16 MB.

-aneesh
