Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 752D93ED5AC;
	Thu,  1 Oct 2026 09:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790846082; cv=none; b=FoYA8YdTkHpIY4E/VATGAgUdxp4+tB+eWs8J9YoWPDqA2Y/223z+ic1omU2tntUAsPz5yxyL3VZhycQQNUVWPFexm6EOt2prKLSzEYX2LB2bDMMQ/1Zfx3yNlkoEBwgxfSihu6CjzN1q2fbp6/l2jZFKi9IWwXhuwDXOty+5Bog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790846082; c=relaxed/simple;
	bh=H4KAcg/TcOwcWtk3FP0WPH5xLuC+It6LDGQUshJ5z8Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qPDl7GGC2L/ZCIyZkrA/gKW3sFaIcCG7j1fwCLnG9K3kO3Q7EdrOMHRH5tu4stUXvvXhQt++Jft0L89xjd8ptWoAYeZtwcSF5teIowXIL/b+oq77BXgskDz2appkk5v40+KGoY1BqtGzBzDKQo7PGmTibsMg1cFlfZ3R4NKdexE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hV3c3pyY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hV3c3pyY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 811A1497;
	Thu,  1 Oct 2026 02:14:36 -0700 (PDT)
Received: from [10.57.9.178] (unknown [10.57.9.178])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2EEB03F86F;
	Thu,  1 Oct 2026 02:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790846079; bh=H4KAcg/TcOwcWtk3FP0WPH5xLuC+It6LDGQUshJ5z8Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hV3c3pyYHn330jDH9/CuC2eSUKPK0ZUkWe4layh/lySL7NZRx0npki/CNt9C7Pc3Z
	 zdW+o9QVcFZ2XgjbwQu44uwxXPyJxnu5H6JpXEBJWA8LZcajvot0VlbZyXXtxT8KRb
	 mJnN8ADS9QUh6a6WgtRQTJUhZnEGEnW57qzLjT8s=
Message-ID: <38cb4a33-7313-4115-b3c4-d01b3f5d5643@arm.com>
Date: Thu, 1 Oct 2026 10:14:37 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 4/9] firmware: arm_rmm: Add support for SRO
Content-Language: en-GB
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
 Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
References: <20261001084555.1456543-1-suzuki.poulose@arm.com>
 <20261001084555.1456543-5-suzuki.poulose@arm.com>
 <20261001090150.1F3381F000FF@smtp.kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261001090150.1F3381F000FF@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/10/2026 10:01, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [Medium] arm_rmm: spurious SRO cancellation when contig donate cache fills up
> - [Medium] arm_rmm: infinite loop in SRO execution if RMM consumes zero granules
> --
> 
> commit 11de55b0945f49bf7651f24a6bc346b286810815
> Author: Steven Price <steven.price@arm.com>
> 
> firmware: arm_rmm: Add support for SRO
> 
> The commit introduces support for Stateful RMI Operations (SRO) in RMM v2.0.
> It adds logic to handle memory donate and reclaim operations, allowing SMCs
> to return in progress and track state using an rmi_sro_state structure.
> Wrappers for SRO RMI commands are also provided to integrate with the stateful
> command infrastructure.
> 
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
>> index b558965a05a2c..7d4e04a5d7c0a 100644
>> --- a/drivers/firmware/arm_rmm/rmi.c
>> +++ b/drivers/firmware/arm_rmm/rmi.c
> [ ... ]
>> +static int rmi_sro_donate_contig(struct rmi_sro_state *sro,
>> +				 unsigned long sro_handle,
>> +				 unsigned long donatereq,
>> +				 struct arm_smccc_1_2_regs *out_regs,
>> +				 gfp_t gfp)
>> +{
> [ ... ]
>> +	/* Reuse the cached address range if we have one */
>> +	for (int i = 0; i < sro->addr_count; i++) {
>> +		unsigned long entry = sro->addr_list[i];
>> +
>> +		if (RMI_ADDR_RANGE_BLOCK_SIZE(entry) == block_size_fld &&
>> +		    RMI_ADDR_RANGE_COUNT(entry) == count &&
>> +		    RMI_ADDR_RANGE_STATE(entry) == state &&
>> +		    IS_ALIGNED(RMI_ADDR_RANGE_ADDR(entry), size)) {
>> +			sro->addr_count--;
>> +			swap(sro->addr_list[sro->addr_count],
>> +			     sro->addr_list[i]);
>> +
>> +			goto mem_donate;
>> +		}
>> +	}
>> +
>> +	ret = rmi_sro_ensure_capacity(sro, 1);
>> +	if (ret)
>> +		return ret;
> 
> [Severity: Medium]
> When the cache fills up with unconsumed fragments, rmi_sro_ensure_capacity()
> returns -ENOSPC. Does returning the error here cause a valid SRO command to be
> spuriously cancelled?


Agree, we could handle this better like we do for the noncontig case 
with the following hunk:

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index a01ab69a64c7c..0941cd8c34d66 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -343,8 +343,9 @@ static int rmi_sro_donate_contig(struct 
rmi_sro_state *sro,
         }

         ret = rmi_sro_ensure_capacity(sro, 1);
+       /* In the odd case we have filled up the cache, free up the 
entire list */
         if (ret)
-               return ret;
+               rmi_sro_free(sro);


> 
> Unlike rmi_sro_donate_noncontig() which handles a full cache by calling
> rmi_sro_free() to flush the unconsumed fragments, the contiguous path simply
> bails out. Could this be triggered if the firmware requests memory in patterns
> that fragment the cache?
> 
>> +
>> +	virt = alloc_pages_exact(size, gfp);
>> +	if (!virt)
>> +		return -ENOMEM;
> [ ... ]
>> +mem_donate:
>> +	rmi_op_mem_donate(sro_handle,
>> +			  virt_to_phys(&sro->addr_list[sro->addr_count]), 1,
>> +			  0, out_regs);
>> +	donated_size = out_regs->a1 << PAGE_SHIFT;
>> +
>> +	if (WARN_ON(out_regs->a1 > (size >> PAGE_SHIFT)))
>> +		donated_size = size;
>> +
>> +	/* All granules consumed by the RMM */
>> +	if (donated_size == size)
>> +		return 0;
>> +	/* No granules were consumed by the RMM, cache them */
>> +	if (donated_size == 0) {
>> +		sro->addr_count++;
>> +		return 0;
>> +	}
> 
> [Severity: Medium]
> If a buggy or interrupted RMM consumes 0 granules, does caching the block and
> returning 0 here create an infinite loop?
> 
> Because 0 is a success return code, the execution loop in
> rmi_sro_memxfer_execute() will skip the cancellation logic and re-issue the
> same request, as shown below:

RMM not consuming any granules is a valid case, where another thread of
host donated the memory that we were also trying to donate. Thus RMM
could report 0. Also, as for the infinite loop, there are other ways the
buggy RMM could trigger this. Keep on asking the host to continue
(forever) ! So, I wouldn't worry about this  pathological case.


Suzuki
