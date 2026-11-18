Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015021;
	b=KGlI3mb14IKMGqjKXEEhCmDIgrfUcNsSvcPHbpwrw184y4NlPHh1bRgS49TLVIImMZ7w
	 R0c58huDXyL+wIog4p/o78zDumPcFSG+ITUg6KeJR56NQrsi0naGukqD8e6WqtGVB+EIM
	 0KGxfCORQzvWrSRd4+KaoDKu8zO1vt/LwNj9UV2sP9uXrdqw0/2eI2ze2WXlo7cfqskUY
	 Z6N8nHCggJ8bWeWu1PO3uQI5XMDU4EM9Rs1brKum9cemMmPi23oUEpJilF729IXG+k3XM
	 4DAQYFjOvn+zs/juOVs1tV54qIVNpmCXV5s8b28vmZBzLCY6S2MJaHA3vqREoDeRL/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015021;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=de0/cTu3T+jrVL0KRaILAEooiHY5vn/RFGHis6/8Bi4=;
	b=RehSgenBA7BayExIoKkJn9kBiDTtDGT0KA1VojdnggQIIiXUIxJ8fOgLTxmE+k8EWaEi
	 XhqH1cde7qh2mse41Frj5Yc9I+FmfxGMLiuHnWZrkpJsaODbd/WJCrhG7RRaaIXn8GOOO
	 9BUMnV3xLDzx+weWloovfbr3Z3W8jxiDDsUaBhYSXySt0UNDkUTDBvuboDJb++8Veuhly
	 QKaVIvCHB5w5WFqpVucODmZejM9WLoMCaqQgbyJLqp8gr0BmwhKclQkajMJPneN+ndZOM
	 P51OC7KBpI8Y48hZ8XivpeHLIJuiK69a2xSgoIR9tQudZpza0s/1hHcwjpJY4YOolPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="k/pAJ9XY";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E021606A32F
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:17:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E021606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=k/pAJ9XY
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F05C11477;
	Wed, 18 Nov 2026 07:16:57 -0800 (PST)
Received: from [10.0.136.98] (M0PRX50XMG.cambridge.arm.com [10.0.136.98])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACF3E3F632;
	Wed, 18 Nov 2026 07:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795015020; bh=N4rZz7WjbLMSngB7gJRDKNm69LzXiajw+dBw411Mr4Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k/pAJ9XYT6oi6POZDpraxWipRQRFohoLChiDMJ6PlHan7ZBjC5kV+oJqs8dL0aWT3
	 xCgdFfhJMNwiLZTLYy8rSHqWLPYUQwyhw+Vghzib0QR0GP0Mp6XkRRgEQXKFK5kXTz
	 h5Z0uAe2bg9L4fwfSo/60yBuXzx8CKa40T3Qn5Zw=
Message-ID: <df9268c6-2137-47f7-8ab7-35859b3c92b0@arm.com>
Date: Wed, 18 Nov 2026 15:16:58 +0000
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
Subject: Re: [PATCH kvmtool v4 13/23] arm64: Assign CPU DT phandles
To: Vladimir Murzin <vladimir.murzin@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261102213413.4136118-1-sascha.bischoff@arm.com>
 <20261102213413.4136118-14-sascha.bischoff@arm.com>
 <19db29e9-ef49-44c0-a42b-e9da5c7a54b4@arm.com>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <19db29e9-ef49-44c0-a42b-e9da5c7a54b4@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/11/2026 15:24, Vladimir Murzin wrote:
> On 11/2/26 21:34, Sascha Bischoff wrote:
>> Assign stable phandles to all arm64 CPU nodes. The GICv5 IRS DT node
>> uses them to map IAFFIDs to CPUs; they remain unreferenced for earlier
>> GIC models.
>>
> 
> Who knows maybe one day we would need them for anything other than GIC :)

Yup, maybe :) The main reason I hadn't previously emitted these in 
general was that I was worried about affecting non-GICv5 guests due to 
an unexpected DT change, but unreferenced phandles don't seem to make it 
into the final FDT.

> 
>> Tested-by: Vladimir Murzin <vladimir.murzin@arm.com>
>> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
>> ---
>>   arm64/fdt.c                  | 1 +
>>   arm64/include/kvm/fdt-arch.h | 1 +
>>   2 files changed, 2 insertions(+)
>>
>> diff --git a/arm64/fdt.c b/arm64/fdt.c
>> index 3cbd36e2..5413956d 100644
>> --- a/arm64/fdt.c
>> +++ b/arm64/fdt.c
>> @@ -54,6 +54,7 @@ static void generate_cpu_nodes(void *fdt, struct kvm *kvm)
>>   			_FDT(fdt_property_string(fdt, "enable-method", "psci"));
>>   
>>   		_FDT(fdt_property_cell(fdt, "reg", mpidr));
>> +		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_CPU_BASE + cpu));
>>   		_FDT(fdt_end_node(fdt));
>>   	}
>>   
>> diff --git a/arm64/include/kvm/fdt-arch.h b/arm64/include/kvm/fdt-arch.h
>> index 8a0a460e..2b667c53 100644
>> --- a/arm64/include/kvm/fdt-arch.h
>> +++ b/arm64/include/kvm/fdt-arch.h
>> @@ -11,4 +11,5 @@ enum phandles {
>>   
>>   void generate_dma_region_prop(void *fdt);
>>   
>> +#define PHANDLE_CPU_BASE PHANDLES_MAX
>>   #endif /* ARM__FDT_H */
>> -- 2.34.1
>>
> 
> FWIW,
> 
> Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

