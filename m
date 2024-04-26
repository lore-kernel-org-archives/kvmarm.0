Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F041482EF;
	Fri, 26 Apr 2024 13:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714139543; cv=none; b=lT/kkCRt3tKDJGeE9n7w0OUFQP2dl8e5UXiGRKwkrOEgVm9pvYvRZ+5ezZ1Of7Mi1qDNx3JYIskis/U8mqaXiUa7t5zh1YGQKGrapEFBMZu8h0amEKOYmZr2u57XbrxeE8F0GGj6s4W2uCFuNSarFB4lv0F9Vabai3kqra2a3Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714139543; c=relaxed/simple;
	bh=I7DyYnWfaXAhtV3qheVggsvxgrFqxIxpkCx87pssTs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQpnQ9cz9Oxf4M7vkls5l67/F7p5X3NUbVyw6TUOu25EbDFm2xnXqLxlryB0KnUmtr8XZ87+wsqzt4xcpLxffogevfBetmidI7H7G0lZobJRNMgXj552GBiJ3oe+B2Eb4HRMP3oLMoBg79iNR1iy2CpE0QfMdSnNrf+//Y49bOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9970C1007;
	Fri, 26 Apr 2024 06:52:47 -0700 (PDT)
Received: from arm.com (unknown [10.57.65.161])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0FAB3F793;
	Fri, 26 Apr 2024 06:51:38 -0700 (PDT)
Date: Fri, 26 Apr 2024 14:51:18 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, maz@kernel.org,
	joey.gouly@arm.com, steven.price@arm.com, james.morse@arm.com,
	oliver.upton@linux.dev, yuzenghui@huawei.com,
	andrew.jones@linux.dev, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 08/33] arm: realm: Make uart available
 before MMU is enabled
Message-ID: <ZiuxVk3l7sM0ukQt@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
 <20240412103408.2706058-9-suzuki.poulose@arm.com>
 <ZiaEkwQmPf2dKGwC@arm.com>
 <c485b0b9-b467-469d-a6ef-4df0c52d0987@arm.com>
 <ZiaNJz3WJUcBPWMs@arm.com>
 <3c5e473a-b2ad-45dd-9f3f-6b691ec73a41@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c5e473a-b2ad-45dd-9f3f-6b691ec73a41@arm.com>

Hi,

On Fri, Apr 26, 2024 at 12:15:53PM +0100, Suzuki K Poulose wrote:
> On 22/04/2024 17:15, Alexandru Elisei wrote:
> > Hi,
> > 
> > On Mon, Apr 22, 2024 at 05:05:54PM +0100, Suzuki K Poulose wrote:
> > > On 22/04/2024 16:38, Alexandru Elisei wrote:
> > > > Hi,
> > > > 
> > > > On Fri, Apr 12, 2024 at 11:33:43AM +0100, Suzuki K Poulose wrote:
> > > > > From: Joey Gouly <joey.gouly@arm.com>
> > > > > 
> > > > > A Realm must access any emulated I/O mappings with the PTE_NS_SHARED bit set.
> > > > 
> > > > What entity requires that a realm must access I/O mappings with the
> > > > PTE_NS_SHARED bit set? Is that an architectural requirement? Or is it an
> > > > implementation choice made by the VMM and/or KVM?
> > > 
> > > RMM spec. An MMIO access in the Protected IPA must be emulated by Realm
> > > world. If an MMIO access must be emulated by NS Host, it must be in the
> > > Unprotected IPA.
> > 
> > That's not exactly what I was asking. I was curious to know how a realm
> > knows if a MMIO access is emulated by the Realm, and thus it must use a
> > protected address, or it's emulated by the non-secure host, and it must use
> > an unprotected address.
> 
> With Arm CCA-1.0, there cannot be an emulation in the Realm world.
> Everything is by the NS Host. It may change in the future, but the
> RSI version would make the Realm aware of the difference.

Wouldn't that be a breaking change for existing software, though? For
example, existing software running in a realm assumes that all devices use
unprotected addresses, and when the VMM/KVM/realm manager gets updated to
implement the newer spec, that ceases to be the case.

Also, would you mind pointing me to the section in the existing spec where
that is specified? I'm curious about the exact wording.

Thanks,
Alex

> 
> 
> Suzuki
> 
> 
> 
> > 
> > Thanks,
> > Alex
> > 
> > > 
> > > Technically, a VMM could create a memory map, where the NS emulated I/O
> > > are kept in the unprotected (upper) half.
> > > 
> > > Or the VMM retains the current model and expects the Realm to use the
> > > "Unprotected" alias.
> > > 
> > > 
> > > Either way, applying the PTE_NS_SHARED attribute doesn't change anything and
> > > works for both the models, as far as the Realm is concerned.
> > > 
> > > 
> > > Suzuki
> > > 
> > > 
> > > 
> > > 
> > > > 
> > > > Thanks,
> > > > Alex
> > > > 
> > > > > This is modelled as a PTE attribute, but is actually part of the address.
> > > > > 
> > > > > So, when MMU is disabled, the "physical address" must reflect this bit set. We
> > > > > access the UART early before the MMU is enabled. So, make sure the UART is
> > > > > accessed always with the bit set.
> > > > > 
> > > > > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > > > > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > > > > ---
> > > > >    lib/arm/asm/pgtable.h   |  5 +++++
> > > > >    lib/arm/io.c            | 24 +++++++++++++++++++++++-
> > > > >    lib/arm64/asm/pgtable.h |  5 +++++
> > > > >    3 files changed, 33 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
> > > > > index 350039ff..7e85e7c6 100644
> > > > > --- a/lib/arm/asm/pgtable.h
> > > > > +++ b/lib/arm/asm/pgtable.h
> > > > > @@ -112,4 +112,9 @@ static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
> > > > >    	return pte_offset(pmd, addr);
> > > > >    }
> > > > > +static inline unsigned long arm_shared_phys_alias(void *x)
> > > > > +{
> > > > > +	return ((unsigned long)(x) | PTE_NS_SHARED);
> > > > > +}
> > > > > +
> > > > >    #endif /* _ASMARM_PGTABLE_H_ */
> > > > > diff --git a/lib/arm/io.c b/lib/arm/io.c
> > > > > index 836fa854..127727e4 100644
> > > > > --- a/lib/arm/io.c
> > > > > +++ b/lib/arm/io.c
> > > > > @@ -15,6 +15,8 @@
> > > > >    #include <asm/psci.h>
> > > > >    #include <asm/spinlock.h>
> > > > >    #include <asm/io.h>
> > > > > +#include <asm/mmu-api.h>
> > > > > +#include <asm/pgtable.h>
> > > > >    #include "io.h"
> > > > > @@ -30,6 +32,24 @@ static struct spinlock uart_lock;
> > > > >    static volatile u8 *uart0_base = UART_EARLY_BASE;
> > > > >    bool is_pl011_uart;
> > > > > +static inline volatile u8 *get_uart_base(void)
> > > > > +{
> > > > > +	/*
> > > > > +	 * The address of the UART base may be different
> > > > > +	 * based on whether we are running with/without
> > > > > +	 * MMU enabled.
> > > > > +	 *
> > > > > +	 * For realms, we must force to use the shared physical
> > > > > +	 * alias with MMU disabled, to make sure the I/O can
> > > > > +	 * be emulated.
> > > > > +	 * When the MMU is turned ON, the mappings are created
> > > > > +	 * appropriately.
> > > > > +	 */
> > > > > +	if (mmu_enabled())
> > > > > +		return uart0_base;
> > > > > +	return (u8 *)arm_shared_phys_alias((void *)uart0_base);
> > > > > +}
> > > > > +
> > > > >    static void uart0_init_fdt(void)
> > > > >    {
> > > > >    	/*
> > > > > @@ -109,9 +129,11 @@ void io_init(void)
> > > > >    void puts(const char *s)
> > > > >    {
> > > > > +	volatile u8 *uart_base = get_uart_base();
> > > > > +
> > > > >    	spin_lock(&uart_lock);
> > > > >    	while (*s)
> > > > > -		writeb(*s++, uart0_base);
> > > > > +		writeb(*s++, uart_base);
> > > > >    	spin_unlock(&uart_lock);
> > > > >    }
> > > > > diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
> > > > > index 5b9f40b0..871c03e9 100644
> > > > > --- a/lib/arm64/asm/pgtable.h
> > > > > +++ b/lib/arm64/asm/pgtable.h
> > > > > @@ -28,6 +28,11 @@ extern unsigned long prot_ns_shared;
> > > > >    */
> > > > >    #define PTE_NS_SHARED		(prot_ns_shared)
> > > > > +static inline unsigned long arm_shared_phys_alias(void *addr)
> > > > > +{
> > > > > +	return ((unsigned long)addr | PTE_NS_SHARED);
> > > > > +}
> > > > > +
> > > > >    /*
> > > > >     * Highest possible physical address supported.
> > > > >     */
> > > > > -- 
> > > > > 2.34.1
> > > > > 
> > > 
> > > 
> 
