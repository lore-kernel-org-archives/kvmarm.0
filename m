Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795014138;
	b=UDy5QaYIGqtWXUGf80RXH1ISvsvSePl+JIen3aY9X57ZPBhJba1AUpnWHDngWSMz1SrX
	 baggsRq0xsubz1yWPYiRU640Y8eJXUSGHZ/Iy5Dag0LNgY/dt+2KpedGV00vpre5FBV5F
	 uU1eARvNnZqrkDHm8GPh8WoKDbnOLWsGaXhtYFbdY3lclOG30O2ltH5L7kYEmGJqC5WjS
	 0/tR7ZB6kl/xvnX7+ZQ0vJgB+C3EPAtxXwfztBgyXY7glBkWlIS9Iu1JV0XYWwvNaZ2Wl
	 IMvyCNSP4Ypnt7tuMgsNORqRLXHCtG+iVtpSbZN4Ptj7Gqtgb5ZIzxQbXOG2K5cnHOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795014138;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=2kwEHJ0zAY14W+D7DVHzyRrlyAqJfGf4ZdjjDqVcqa0=;
	b=Uu0Bg+2lZUIA7Mvm96ZIhzecMDzWKdWakHff/RwtTu2l+7Ph+zoMuF27P3aA4vGzrB5H
	 II6sLqP5AEvwqimgoMaep3/6DwIRSXt5DMmGbG6dd1GZrQjB6ew63aq1D2LVJWxSsvwr7
	 ovTcrCwRS206N7VbURSWZN0kF4vPUE5od+FvVMcy7wikhfOQMjkBlREhu71f1CrCMH/7E
	 jMthxKuo5zTvpaZ79QCT73PArEjlGOnbyrIwJEgCb6apM+xGp1dLuG804EB6+We+CruuU
	 730yK7cBlHkEUgMc7gDvnR6bRVJ+IQSVuPquR9mggn3othh1lummdcYAeEgCzbdzf0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="ks/YqX58";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 465EB606A32A
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 465EB606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ks/YqX58
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AFA911477;
	Wed, 18 Nov 2026 07:02:12 -0800 (PST)
Received: from [10.0.136.98] (M0PRX50XMG.cambridge.arm.com [10.0.136.98])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9EFDC3F632;
	Wed, 18 Nov 2026 07:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795014135; bh=eddQ3M+wbwgMfqxpVNkByDx7fx4cxxbX77mqCCMVbJU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ks/YqX58M95FnIt58ZT01dPcThA93N+roIe7hmxnOwt3N/QZlRvprAyk2vog8DRgI
	 Lu5CXOLsy/15FyP70bsDDKK1mdILNG7SPTOWmQO+2WgI5GiMBNrYuYdL8Flhw4Kqt9
	 l1ESlNx5w6bZGnk+W5LPTWbPFOorfODHy5QLr8V8=
Message-ID: <abe9f66d-bf6d-49d2-873c-53ffe3c2c394@arm.com>
Date: Wed, 18 Nov 2026 15:02:13 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kvmtool v4 07/23] irq: Allow the initial interrupt line
 number to be set
To: Vladimir Murzin <vladimir.murzin@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-8-sascha.bischoff@arm.com>
 <204b3dd9-11fb-4639-b749-d14b923dbc6b@arm.com>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <204b3dd9-11fb-4639-b749-d14b923dbc6b@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/11/2026 15:05, Vladimir Murzin wrote:
> On 11/2/26 21:33, Sascha Bischoff wrote:
>> Allow callers to select the initial IRQ line number before allocating
>> any lines. Track the selected offset when reporting the number of
>> allocated lines.
>>
> 
> Interestingly, IRQ line allocation used to be per arch yet changed in
> 9dc5430ce7c9 ("kvm tools: irq: make irq__alloc_line generic") :D

Yeah, and I really wish things could remain as generic!

> 
> 
>> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
>> ---
>>   include/kvm/irq.h |  1 +
>>   irq.c             | 15 ++++++++++++++-
>>   2 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/kvm/irq.h b/include/kvm/irq.h
>> index 2a3f8c9d..17113979 100644
>> --- a/include/kvm/irq.h
>> +++ b/include/kvm/irq.h
>> @@ -23,6 +23,7 @@ extern struct msi_routing_ops *msi_routing_ops;
>>   extern struct kvm_irq_routing *irq_routing;
>>   extern int next_gsi;
>>   
>> +int irq__init_irq_offset(u8 offset);
>>   int irq__alloc_line(void);
>>   int irq__get_nr_allocated_lines(void);
>>   
>> diff --git a/irq.c b/irq.c
>> index cdcf9923..7c4bfec4 100644
>> --- a/irq.c
>> +++ b/irq.c
>> @@ -8,6 +8,7 @@
>>   #include "kvm/irq.h"
>>   #include "kvm/kvm-arch.h"
>>   
>> +static u8 irq_offset = KVM_IRQ_OFFSET;
>>   static u8 next_line = KVM_IRQ_OFFSET;
>>   static int allocated_gsis = 0;
>>   
>> @@ -18,6 +19,18 @@ struct msi_routing_ops *msi_routing_ops = &irq__default_routing_ops;
>>   
>>   struct kvm_irq_routing *irq_routing = NULL;
>>   
>> +/* Override the default offset before the first IRQ allocation. */
>> +int irq__init_irq_offset(u8 offset)
>> +{
>> +	if (irq__get_nr_allocated_lines())
>> +		return -EBUSY;
>> +
>> +	irq_offset = offset;
>> +	next_line = offset;
>> +
>> +	return 0;
>> +}
>> +
>>   int irq__alloc_line(void)
>>   {
>>   	return next_line++;
>> @@ -25,7 +38,7 @@ int irq__alloc_line(void)
>>   
>>   int irq__get_nr_allocated_lines(void)
>>   {
>> -	return next_line - KVM_IRQ_OFFSET;
>> +	return next_line - irq_offset;
>>   }
>>   
>>   int irq__allocate_routing_entry(void)
>> -- 2.34.1
>>
> 
> FWIW
> 
> Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

