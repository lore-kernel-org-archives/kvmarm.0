Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2ECAD23
	for <kvmarm@lists.linux.dev>; Fri, 29 Nov 2024 16:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.134.164.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732899592; cv=none; b=ceQPztAQkN7/Wwc80rZUSsqoxbQxjwhFrpa0m/3xuLH3fqG4y8zTiwbqWpujz98MzBQ37trWljsPKXkDHOoyLisvaSXs9jicdxp7seW+mRyJZ31h0cfp3MUexEN8NwDYZGC2T9fYK7WSPwSKiI23eDQcn+i2pJ/5HTqIMBQCR90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732899592; c=relaxed/simple;
	bh=7EzYpKYUAqHg8xi5ZzUSz1Ss+zdRpJ7nOjnASD2r6Gc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O7bZ8xuHu67SZZ2bMHAqv9R15DIGT2534y6ab0CCmPBYkmyMUryHn9IG7DV45xgDMpcZZgE4tD2fCpc2VXEQO6B1ZHI2kLAVYlRzFWqzwCqHz7E5TMyPxrtGGty58LdT+e5QUqFnbAmTXgv6pUAgfOl3cLN8CUseUjaHDHPq7Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr; spf=pass smtp.mailfrom=inria.fr; dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b=fG64fQye; arc=none smtp.client-ip=192.134.164.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=inria.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inria.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=inria.fr header.i=@inria.fr header.b="fG64fQye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=D6aq0+YEsHGkgmUSZzzVz7k8Q+OO2efr1KuDOccak9k=;
  b=fG64fQyeJKeJb5Pl5zLDAOaykqwo/5H5qxU5XbIwQ9qkpfF34tSIqSHW
   ecYGTvcT3gAkMjgl5Rn+uR1wVyu8vuoLATFb07gNueMLUAl9rqK8/2Ij2
   sofxdx9JVAbWVIMg0a/U7SPI7LfXE23KPINsyAYvSgonFhVbplaSVITQ2
   k=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=keisuke.nishimura@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.12,196,1728943200"; 
   d="scan'208";a="103026726"
Received: from dt-aponte.paris.inria.fr (HELO [128.93.67.66]) ([128.93.67.66])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2024 17:59:41 +0100
Message-ID: <d8152993-081e-4d0f-b318-bbec645f2cbb@inria.fr>
Date: Fri, 29 Nov 2024 17:59:40 +0100
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
 <Z0lrWynd3O8a1pG_@linux.dev> <e85e92f9-8387-4021-885e-a379a2898c9c@inria.fr>
 <Z0nsvvRNzjWTLI7A@linux.dev>
Content-Language: en-US
From: Keisuke Nishimura <keisuke.nishimura@inria.fr>
In-Reply-To: <Z0nsvvRNzjWTLI7A@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 29/11/2024 17:33, Oliver Upton wrote:
> On Fri, Nov 29, 2024 at 12:30:52PM +0100, Keisuke Nishimura wrote:
>> On 29/11/2024 08:20, Oliver Upton wrote:
>>>    - Store fails because of a failed memory allocation / error in xarray
>>>      library.
>>>
>>> We don't handle #3, and the correct thing to do in this case is to put
>>> @irq since it was never made visible in the translation cache.
>>>
>>> So I think we'd want to do something similar to the following.
>>>
>>
>> Hello,
>>
>> Thanks for the comment. xa_reserve() can allocate the memory in advance and
>> ensure the success of the subsequent xa_store().
> 
> Yes, but xa_store() can fail for other reasons than a failed memory
> allocation. Which is why I recommended adding an explicit error handling
> path to cover *all* failures to store in the xarray.
> 


Okay. Then, in the next version, I will send the change you suggested in the 
previous mail:)

thanks,
Keisuke
