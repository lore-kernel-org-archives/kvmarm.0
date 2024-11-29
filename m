Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1EF189B83
	for <kvmarm@lists.linux.dev>; Fri, 29 Nov 2024 11:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732879859; cv=none; b=HHLUYJKaClP9LE7atRBURo37HZsQWi/yrUMGEc4vEgV/otBfdMbsfNL8En/qkpEbcSWAwingj/kK83EmdKY9wX/DyoKcZlWDXIwvTHgknQvMTFhdaEQD3UNXwaCCv8eVAFY3X+z7d7DeJpngRzIPhRfscL8VQPrkuz3T1V9xAWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732879859; c=relaxed/simple;
	bh=ugoTjvbf/T2Gt9bHlOx3mUSknD42xX3aOf3aUVASCUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qfJ8HbofTvEZQkBn5mY1LcZN2O2W+Oj3zVDKujMaKNHA6EWR/FSzCX965xLncDtxzkWMsA2LfUCQa16Nyn0KSpWaRAOGB/2XMM3a3VAMg/15BEAUcohimvcbG/4h+C+sXjF/y113ujCFzmIr5oG8bxs8XbLwcf3t3j4fu8WYARI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=LBVDCAIn; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="LBVDCAIn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/Q3XjPb0Ey2Y1XcJHGYpRebmTpz9c8xwwCA/EQuTE0A=;
  b=LBVDCAInW9HTBdXVSGmbuq9y9xWtFXiyE7uk36AfLiZc40znbZaiiq6f
   +OJoP24YFaAdG3BIHqrUlz3SHkb7hFs0CkAyD1VbMQyxYQULhx/R8MolU
   hQcPxzyyUqJeIySjTrfflcfeOa16EWDt40PwMV+9HCYNj1wEF0/st2mjB
   Q=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=keisuke.nishimura@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.12,195,1728943200"; 
   d="scan'208";a="102991282"
Received: from dt-aponte.paris.inria.fr (HELO [128.93.67.66]) ([128.93.67.66])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2024 12:30:54 +0100
Message-ID: <e85e92f9-8387-4021-885e-a379a2898c9c@inria.fr>
Date: Fri, 29 Nov 2024 12:30:52 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm/arm64: vgic-its: Add error handling in
 vgic_its_cache_translation
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
References: <20241128134534.361144-1-keisuke.nishimura@inria.fr>
 <Z0iujBMl1ypdwfBu@linux.dev> <a62e682d-c2e8-424d-84c5-4e64468124a9@inria.fr>
 <Z0lrWynd3O8a1pG_@linux.dev>
Content-Language: en-US
From: Keisuke Nishimura <keisuke.nishimura@inria.fr>
In-Reply-To: <Z0lrWynd3O8a1pG_@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 29/11/2024 08:20, Oliver Upton wrote:
> On Thu, Nov 28, 2024 at 08:04:01PM +0100, Keisuke Nishimura wrote:
>> Hello Marc and Oliver,
>>
>> Thank you for the replies.
>>
>> On 28/11/2024 18:55, Oliver Upton wrote:
>>> On Thu, Nov 28, 2024 at 02:45:34PM +0100, Keisuke Nishimura wrote:
>>>> The xa_store() may fail because there is no guarantee that the cache_key
>>>> index is already used in its->translation_cache. This fix (1) resolves
>>>> the kref inconsistency on failure and (2) returns the error code.
>>>
>>> xa_store() doesn't fail if an entry is already present at the specified
>>> index. It returns the old entry, which is why we have a vgic_put_irq()
>>> on the "error" path.
>>
>> Sure. But to my understanding, this could be the first store to
>> its->translation_cache with cache_key, and that is why old can be NULL? I am
>> not very familiar with this code, so please correct me if I am wrong.
> 
> So we take a reference on @irq to represent the pointer to it that's
> stored in the translation cache. There are 3 possible outcomes after the
> store:
> 
>   - Store succeeds and no pre-existing entry.
> 
>   - Store succeeds and there's a pre-existing entry. put the reference on
>     @old since it was evicted from the translation cache
> 
>   - Store fails because of a failed memory allocation / error in xarray
>     library.
> 
> We don't handle #3, and the correct thing to do in this case is to put
> @irq since it was never made visible in the translation cache.
> 
> So I think we'd want to do something similar to the following.
> 

Hello,

Thanks for the comment. xa_reserve() can allocate the memory in advance and 
ensure the success of the subsequent xa_store(). FYI, the document of 
xa_reserve() says:

 > Ensures there is somewhere to store an entry at index in the array. If there 
is already something stored at index, this function does nothing. If there was 
nothing there, the entry is marked as reserved. Loading from a reserved entry 
returns a NULL pointer.


I am thinking of calling it before the reference in v2. Here is the suggestion:

---
  arch/arm64/kvm/vgic/vgic-its.c | 9 +++++++++
  1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 198296933e7e..1422812ad6d7 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -561,11 +561,20 @@ static void vgic_its_cache_translation(struct kvm *kvm, 
struct vgic_its *its,
  {
  	unsigned long cache_key = vgic_its_cache_key(devid, eventid);
  	struct vgic_irq *old;
+	int ret;

  	/* Do not cache a directly injected interrupt */
  	if (irq->hw)
  		return;

+	/*
+	 * Ensure the following xa_store() will not fail. Intentionally do
+	 * not return the error as the translation cache is best effort.
+	 */
+	ret = xa_reserve(&its->translation_cache, cache_key, GFP_KERNEL_ACCOUNT);
+	if (ret)
+		return;
+
  	/*
  	 * The irq refcount is guaranteed to be nonzero while holding the
  	 * its_lock, as the ITE (and the reference it holds) cannot be freed.
-- 
2.34.1

