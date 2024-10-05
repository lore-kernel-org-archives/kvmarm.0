Received: from metis.whiteo.stw.pengutronix.de (metis.whiteo.stw.pengutronix.de [185.203.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E9115B99D
	for <kvmarm@lists.linux.dev>; Sat,  5 Oct 2024 18:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.203.201.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728153526; cv=none; b=Xu7I04LQzycYqtehnAnhuPNhcMiWnYlCBnf/LhlsSsNCNvBo22uxvD9yzOpi78irkT1iEUEDXRi92exEoILI2QZe96F9i8Lh6IovP75U3TChyygRfywVqSqqdnK0GjEnNvuI0hzP5VWD9rAFjrByld7bUnrqEgMq64UK3V5YqL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728153526; c=relaxed/simple;
	bh=WSgpTwUCUNoFVg372JpUaT18YN3U/v0nRdWuQbBYqPw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ouolRSMNMYPgUtHB8B8D9hL68vdRF1+mK46ZbjP87XJ7P7H5UJ5uEkyeMPHQmn6xQg1W27iHQ0SCpuzl2PPWKoKsynSZaLtDRXuuc8FauJ+p8BRUSNavwSjDLGBRKwq2JLmOrYr1El1sQ7z673s9iXQIqQjkKsh0fn5l8EBnlnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de; spf=pass smtp.mailfrom=pengutronix.de; arc=none smtp.client-ip=185.203.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pengutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pengutronix.de
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
	by metis.whiteo.stw.pengutronix.de with esmtp (Exim 4.92)
	(envelope-from <a.fatoum@pengutronix.de>)
	id 1sx9fd-0001EL-CD; Sat, 05 Oct 2024 20:38:25 +0200
Message-ID: <65ab10d7-6594-490c-be07-39f83ac3559a@pengutronix.de>
Date: Sat, 5 Oct 2024 20:38:23 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] ARM64 KVM: Data abort executing post-indexed LDR on MMIO
 address
To: Marc Zyngier <maz@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org,
 Pengutronix Kernel Team <kernel@pengutronix.de>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, Enrico Joerns <ejo@pengutronix.de>
References: <89f184d6-5b61-4c77-9f3b-c0a8f6a75d60@pengutronix.de>
 <CAFEAcA_Yv2a=XCKw80y9iyBRoC27UL6Sfzgy4KwFDkC1gbzK7w@mail.gmail.com>
 <a4c06f55-28ec-4620-b594-b7ff0bb1e162@pengutronix.de>
 <CAFEAcA9F3AR-0OCKDy__eVBJRMi80G7bWNfANGZRR2W8iMhfJA@mail.gmail.com>
 <4d559b9e-c208-46f3-851a-68086dc8a50f@pengutronix.de>
 <864j5q7sdq.wl-maz@kernel.org>
Content-Language: en-US
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <864j5q7sdq.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.whiteo.stw.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: kvmarm@lists.linux.dev

Hello Marc,

On 05.10.24 12:31, Marc Zyngier wrote:
> On Fri, 04 Oct 2024 20:50:18 +0100,
> Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
>> With readl/writel implemented in assembly, I get beyond that point, but
>> now I get a data abort running an DC IVAC instruction on address 0x1000,
>> where the cfi-flash is located. This instruction is part of a routine
>> to remap the cfi-flash to start a page later, so the zero page can be
>> mapped faulting.

[snip]

>> Any idea what this is about?
> 
> IIRC, the QEMU flash is implemented as a read-only memslot. A data
> cache invalidation is a *write*, as it can be (and is) upgraded to a
> clean+invalidate by the HW.

So it's a write, even if there are no dirty cache lines?

> KVM cannot satisfy the write, for obvious reasons, and tells the guest
> to bugger off (__gfn_to_pfn_memslot() returns KVM_PFN_ERR_RO_FAULT,
> which satisfies is_error_noslot_pfn() -- a slight oddity, but hey, why
> not).
> 
> In the end, you get an exception. We could relax this by
> special-casing CMOs to RO memslots, but this doesn't look great.
> 
> The real question is: what are you trying to achieve with this?

barebox sets up the MMU, but tries to keep a 1:1 mapping. On Virt, we
want to map the zero page faulting, but still have access to the first
block of the cfi-flash.

Therefore, barebox will map the cfi-flash one page later
(virt 0x1000,0x2000,... -> phys 0x0000,0x1000,...) and so on, so the first
page can be mapped faulting.

The routine[1] that does this remapping invalidates the virtual address range,
because the attributes may change[2]. This invalidate also happens for cfi-flash,
but we should never encounter dirty cache lines there as the remap is done
before driver probe.

Can you advise what should be done differently?

[1]: https://elixir.bootlin.com/barebox/v2024.09.0/source/arch/arm/cpu/mmu_64.c#L193
[2]: https://lore.kernel.org/barebox/20230526063354.1145474-4-a.fatoum@pengutronix.de/

Thanks,
Ahmad

> 
> 	M.
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
