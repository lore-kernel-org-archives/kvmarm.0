Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651704;
	b=I1FFc94JDmmawZ3YUX7RwV1R3roF7d6g5A7gv2hYIIfM3bCC0u9mZzRAQkxCkyfRgM+r
	 2+CA2g24aPK7Czwk4kC1WBkC5p+FDbnxql9jwVYxqTNm0Jl3mWGQObV4RfyJEmXf7WEeC
	 KMBTeP6v9l2mDVAqywRFbumy4NgwOhVQZoruGQU21jAmF5ulbPST6lXABCP42pe0dXE4+
	 dRftmbLj4c+W1PpzzzQ7KrBpyUQK4BRmk3tF2HhO/coJl6LxiV0Ttg7TpWGbeoMrnK/qA
	 ++oLWUkYFbE5iR+AgKzROUfBtfFwm7usMpV1fmKh0p4aTzILTCFRl9kK0VoDYaBSKFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651704;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=fVrdTInYLrRvxbYB/XixLqPaHg4vKcQOHbKR4Xq9psA=;
	b=CAwGa/6+LXY2NvxFUXMZWfR1NR57SQ/WSLZeYVic8vIjfzHvf2DafLrrKNVI7FeaRVZH
	 RAul9kr5IqhswQ6m6TEMrOtaYQBDKJcjZm4C8wey+xl6JAozGJlAdkscpHrCUwu9X+BCF
	 7DmfEksaHMyVPprSswbMUoJX/PJZ26gPnMLIvr9j5ZG9YnVxuhaSp2Vb1jckRbJCRV7fx
	 ZgHryMyZ+yaOaZA7h+lnr20D2d6QBS/vstRcCkoLxYy470YkE1kFwr9hi3IZrxnuNxttk
	 ILP0Xcn8yLsfEqEDvGFgUCs88ATMjo3rJIGmQgX5wB4No72T1RQFSDKx/BbVtw0nqmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QIrAqOTk;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FB37606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:35:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5FB37606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=QIrAqOTk
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CE2216A3;
	Mon,  2 Nov 2026 12:34:59 -0800 (PST)
Received: from [10.57.89.36] (unknown [10.57.89.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5CCA13F59E;
	Mon,  2 Nov 2026 12:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793651702; bh=725ybgwJOHxvoUcVecTQi5DQqHyETUmEkAV+ZJ9LX1s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QIrAqOTk84L/BSjZitTtpAM9Cp89xzVYRTOS7Ao+Gqu/H6rIBfxcQcS+iARkyabD2
	 4mZeDuAvv8TIujccZ5BJk0t2KqT3AMHKUEpOdgB2e4rW0obNhgImgjzlxFjxfWai5E
	 iL2bn8/WlEACpgPytDROnCgXl3pA6jmIKi5RD6j0=
Message-ID: <2e04c316-d5e4-4f9b-953f-b7e930cccfac@arm.com>
Date: Mon, 2 Nov 2026 20:34:59 +0000
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
Subject: Re: [PATCH kvmtool v3 05/21] arm64: Track whether the VM uses GICv5
To: Vladimir Murzin <vladimir.murzin@arm.com>, will@kernel.org,
 julien.thierry.kdev@gmail.com
Cc: maz@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 timothy.hayes@arm.com, Peter Maydell <peter.maydell@linaro.org>
References: <20261016153939.913764-1-sascha.bischoff@arm.com>
 <20261016153939.913764-6-sascha.bischoff@arm.com>
 <4fcaa349-6c0c-4660-89cc-5cd34872fa7a@arm.com>
Content-Language: en-GB
From: Sascha Bischoff <sascha.bischoff@arm.com>
In-Reply-To: <4fcaa349-6c0c-4660-89cc-5cd34872fa7a@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/10/2026 19:22, Vladimir Murzin wrote:
> On 10/16/26 16:39, Sascha Bischoff wrote:
>> Expose the selected GIC generation to interrupt and DT setup code that
>> does not receive the irqchip type directly. Set the state only after
>> the GIC device has been configured successfully.
>>
>> Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
>> ---
>>   arm64/gic.c             | 7 +++++++
>>   arm64/include/kvm/gic.h | 1 +
>>   2 files changed, 8 insertions(+)
>>
>> diff --git a/arm64/gic.c b/arm64/gic.c
>> index 5c8a33b5..c1bd0771 100644
>> --- a/arm64/gic.c
>> +++ b/arm64/gic.c
>> @@ -21,6 +21,12 @@ static u64 gic_redists_size;
>>   static u64 gic_msi_base;
>>   static u64 gic_msi_size = 0;
>>   static bool vgic_is_init = false;
>> +static bool vgic_is_v5;
>> +
>> +bool gic__is_v5(void)
>> +{
>> +	return vgic_is_v5;
>> +}
>>   
>>   struct kvm_irqfd_line {
>>   	unsigned int		gsi;
>> @@ -230,6 +236,7 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
>>   	if (err)
>>   		goto out_err;
>>   
>> +	vgic_is_v5 = type == IRQCHIP_GICV5;
>>   	return 0;
>>   
>>   out_err:
>> diff --git a/arm64/include/kvm/gic.h b/arm64/include/kvm/gic.h
>> index 630f0bbd..991aa912 100644
>> --- a/arm64/include/kvm/gic.h
>> +++ b/arm64/include/kvm/gic.h
>> @@ -34,6 +34,7 @@ enum irqchip_type {
>>   
>>   struct kvm;
>>   
>> +bool gic__is_v5(void);
>>   int gic__alloc_irqnum(void);
>>   int gic__create(struct kvm *kvm, enum irqchip_type type);
>>   int gic__create_gicv2m_frame(struct kvm *kvm, u64 msi_frame_addr);
>> -- 2.34.1
>>

Hi Vladimir,

I've made your suggested changes here. Thanks to making these changes, 
gic__is_v5() is now gone altogether, which makes me rather happy. I was 
always annoyed by the GICv5 tentacles throughout the code, so being able 
to make those things more generic is much better. Thanks again!

> 
> I noticed that gic__is_v5() is used later on in places which, in theory,
> should not care about what exact gic type is in use. Those places are
> 
> 1. adjustments for fdt generations
> 
> For that case, can we have some helpers, say
> 
> int gic__get_spi_base(void)
> {
>          return gic_spi_base;
> }
> 
> int gic__get_ppi_base(void)
> {
>          return gic_ppi_base;
> }
> 
> int gic__get_spi_fdt_type(void)
> {
>          return gic_spi_fdt_type;
> }
> 
> int gic__get_ppi_fdt_type(void)
> {
>          return gic_ppi_fdt_type;
> }
> 
> which we configure from
> 
> static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
> {
> ...
>          err = gic__set_spi(type);
>          if (err)
>                  goto out_err;
> 
>          err = gic__set_ppi(type);
>          if (err)
>                  goto out_err;
> ...
> }
> 
> where
> 
> static int gic__set_spi(enum irqchip_type type)
> {
>          switch (type) {
>          case IRQCHIP_GICV5:
>                  gic_spi_base = GICV5_SPI_IRQ_BASE;
>                  gic_spi_fdt_type = GICV5_FDT_IRQ_TYPE_SPI;
>                  break;
>          default:
>                  gic_spi_base = GIC_SPI_IRQ_BASE;
>                  gic_spi_fdt_type = GIC_FDT_IRQ_TYPE_SPI;
>                  break;
>          }
> 
>          return irq__init_irq_offset(gic_spi_base);
> }
> 
> static int gic__set_ppi(enum irqchip_type type)
> {
>          switch (type) {
>          case IRQCHIP_GICV5:
>                  gic_ppi_base = GICV5_PPI_IRQ_BASE;
>                  gic_ppi_fdt_type = GICV5_FDT_IRQ_TYPE_PPI;
>                  break;
>          default:
>                  gic_ppi_base = GIC_PPI_IRQ_BASE;
>                  gic_ppi_fdt_type = GIC_FDT_IRQ_TYPE_PPI;
>                  break;
>          }
> 
>          return 0;
> }
> 
> so
> 
> void pci__generate_fdt_nodes(void *fdt, struct kvm *kvm)
> {
> ...
>          int_type = gic__get_spi_fdt_type();
>          int_id = irq - gic__get_spi_base();
> ...
> }
> 
> and
> 
> void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
> {
> ...
>          irq_prop[0] = cpu_to_fdt32(gic__get_ppi_fdt_type());
>          irq_prop[1] = cpu_to_fdt32(irq - gic__get_ppi_base());
> 
> ...
> }
> 
> and
> 
> void timer__generate_fdt_nodes(void *fdt, struct kvm *kvm)
> {
> ...
>          type = gic__get_ppi_fdt_type();
>          offset = gic__get_ppi_base();
> ...
> }

Done.

> 
> 2. adjustment for IRQ line
> 
> With helpers introduced above
> 
> static int gic__init_gic(struct kvm *kvm)
> {
> ...
>          nr_irqs += gic__get_spi_base();
> ...
> }
> 
> and
> 
> void kvm__irq_line(struct kvm *kvm, int irq, int level)
> {
> ...
>          if (irq < gic__get_spi_base() || irq > GIC_MAX_IRQ)
> ...
> }
> 
> }

Done.

> 
> 3. PMU initialisation
> 
> Can we introduce another helper
> 
> int gic__encode_ppi_irq(enum irqchip_type type, int irq)
> {
>          switch (type) {
>          case IRQCHIP_GICV5:
>                  return irq | (GICV5_IRQ_TYPE_PPI <<  GICV5_IRQ_TYPE_SHIFT);
>          default:
>                  return irq;
>          }
> }
> 
> so
> 
> int pmu__init(struct kvm *kvm)
> {
> ...
>          irq = gic__encode_ppi_irq(kvm->cfg.arch.irqchip, irq);
> ...
> }

Done.

> 
> 4. phandle generation for CPU node(s)
> 
> We can either guard by kvm->cfg.arch.irqchip == IRQCHIP_GICV5 or, perhaps
> generate it unconditionally?

And done - I've chosen to always emit them as they should not be 
harmful. However, if we are worried about changing existing VMs though 
this change, it might be better to omit them. IIRC, even unused phandles 
will affect the final FDT.

> 
> 
> Cheers
> Vladimir

Thanks,
Sascha
