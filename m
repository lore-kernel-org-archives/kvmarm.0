Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C47618950D
	for <kvmarm@lists.linux.dev>; Thu,  1 Aug 2024 11:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722510088; cv=none; b=cb18kMj+ABtGmfv77b3AAIUzLd5gkRbysrgHDaaj/AeMEvIr+I7DaEHGYNs1rnRcha2X0XNPygBZJ8ILQq6/3syvvSkqvDp1uVTTm6a41IgRLvK+j6HSv1YwGNRRld4hTU5vkbCNXY8OwRpFVNGW+GQXJEkneqPtMg/HoepvyYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722510088; c=relaxed/simple;
	bh=MT4mTt6b7I60etPsb4pvBF0RKUpmevZxVyAz/MswUJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P83rANkVmr30vY+W4j/noLcV6arRiNEvkqI4seq2hB5mLT2NnUtwgmGJs43Wj3WAhxetJ3Xz1iP2U1+UkwOPbAa+bsuQvvoMgs9vTzgZV1C8EhX4D/3/wS+MKCq0+nDM1qKtXIsU6IlwnQ1gXVjObOnW/Ei9kc2iCe2eOL8xVo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 570E215A1;
	Thu,  1 Aug 2024 04:01:52 -0700 (PDT)
Received: from e133380.arm.com (e133380.arm.com [10.1.197.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCA383F5A1;
	Thu,  1 Aug 2024 04:01:23 -0700 (PDT)
Date: Thu, 1 Aug 2024 12:01:18 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
	aneesh.kumar@kernel.org, aneesh.kumar@linux.ibm.com, bp@alien8.de,
	broonie@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, dave.hansen@linux.intel.com,
	hpa@zytor.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, mingo@redhat.com,
	mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com, npiggin@gmail.com,
	oliver.upton@linux.dev, shuah@kernel.org, szabolcs.nagy@arm.com,
	tglx@linutronix.de, will@kernel.org, x86@kernel.org,
	kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 13/29] arm64: convert protection key into vm_flags and
 pgprot values
Message-ID: <Zqtq/sfCcitfdHkS@e133380.arm.com>
References: <20240503130147.1154804-1-joey.gouly@arm.com>
 <20240503130147.1154804-14-joey.gouly@arm.com>
 <ZqJ0HqR4IbNrgX5y@e133380.arm.com>
 <20240801105502.GA841837@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801105502.GA841837@e124191.cambridge.arm.com>

On Thu, Aug 01, 2024 at 11:55:02AM +0100, Joey Gouly wrote:
> On Thu, Jul 25, 2024 at 04:49:50PM +0100, Dave Martin wrote:
> > On Fri, May 03, 2024 at 02:01:31PM +0100, Joey Gouly wrote:
> > > Modify arch_calc_vm_prot_bits() and vm_get_page_prot() such that the pkey
> > > value is set in the vm_flags and then into the pgprot value.
> > > 
> > > Signed-off-by: Joey Gouly <joey.gouly@arm.com>
> > > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > > Cc: Will Deacon <will@kernel.org>
> > > ---
> > >  arch/arm64/include/asm/mman.h | 8 +++++++-
> > >  arch/arm64/mm/mmap.c          | 9 +++++++++
> > >  2 files changed, 16 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/mman.h b/arch/arm64/include/asm/mman.h
> > > index 5966ee4a6154..ecb2d18dc4d7 100644
> > > --- a/arch/arm64/include/asm/mman.h
> > > +++ b/arch/arm64/include/asm/mman.h
> > > @@ -7,7 +7,7 @@
> > >  #include <uapi/asm/mman.h>
> > >  
> > >  static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
> > > -	unsigned long pkey __always_unused)
> > > +	unsigned long pkey)
> > >  {
> > >  	unsigned long ret = 0;
> > >  
> > > @@ -17,6 +17,12 @@ static inline unsigned long arch_calc_vm_prot_bits(unsigned long prot,
> > >  	if (system_supports_mte() && (prot & PROT_MTE))
> > >  		ret |= VM_MTE;
> > >  
> > > +#if defined(CONFIG_ARCH_HAS_PKEYS)
> > > +	ret |= pkey & 0x1 ? VM_PKEY_BIT0 : 0;
> > > +	ret |= pkey & 0x2 ? VM_PKEY_BIT1 : 0;
> > > +	ret |= pkey & 0x4 ? VM_PKEY_BIT2 : 0;
> > 
> > Out of interest, is this as bad as it looks or does the compiler turn
> > it into a shift and mask?
> 
> Yeah, (gcc 13.2) produces good code here (this is do_mprotect_pkey after removing a lot of branching):
> 
> 	and     w0, w0, #0x7
> 	orr     x1, x1, x0, lsl #32

Neat, good ol' gcc!

Cheers
---Dave
