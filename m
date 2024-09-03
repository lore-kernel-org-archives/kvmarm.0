Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BD5C6F30D
	for <kvmarm@lists.linux.dev>; Tue,  3 Sep 2024 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725375063; cv=none; b=C6xrzYiC7vlpdTKwXGuVdMu/2s3ASySedsPieE8uISDNWMtI1KWHvR2ftmxbAm0qwiaiUd+Re7EbTrnll2rX6RVFONJ3P9gTnqUkfpkonPvL8vaPSW3suaFy72f6Jsr0W+dBczKVAJEYz0OUG4AZYxHBj27bASFOkPp5J2LFJOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725375063; c=relaxed/simple;
	bh=WKiM4yLeUd/5oolwp0d4pIB/T1dCTydTWDLgQ0XfChA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uKHUoNIpgLFWwxuSyuFls8ubR/Y0q1LsZNO52fmYpRLGuMVcBmBUtwWhIi5GuKZXAa8a9jBcfackmHtS7c1VYtqgVawrpcke+hb6W9qfpiTH7XxlhnfvlsGdU5oVCo8OIHym3++P17Gdx5GC2A9XeaWptr85qUXiHnlYh1ENmrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16944FEC;
	Tue,  3 Sep 2024 07:51:21 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 54B823F66E;
	Tue,  3 Sep 2024 07:50:51 -0700 (PDT)
Date: Tue, 3 Sep 2024 15:50:46 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, nd@arm.com,
	akpm@linux-foundation.org, aneesh.kumar@kernel.org,
	aneesh.kumar@linux.ibm.com, anshuman.khandual@arm.com, bp@alien8.de,
	catalin.marinas@arm.com, christophe.leroy@csgroup.eu,
	dave.hansen@linux.intel.com, hpa@zytor.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, maz@kernel.org, mingo@redhat.com,
	mpe@ellerman.id.au, naveen.n.rao@linux.ibm.com, npiggin@gmail.com,
	oliver.upton@linux.dev, shuah@kernel.org, skhan@linuxfoundation.org,
	szabolcs.nagy@arm.com, tglx@linutronix.de, will@kernel.org,
	x86@kernel.org, kvmarm@lists.linux.dev,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 16/30] arm64: handle PKEY/POE faults
Message-ID: <20240903144823.GA3669886@e124191.cambridge.arm.com>
References: <20240822151113.1479789-1-joey.gouly@arm.com>
 <20240822151113.1479789-17-joey.gouly@arm.com>
 <40600b75-68eb-421a-a122-256bd20afb89@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40600b75-68eb-421a-a122-256bd20afb89@sirena.org.uk>

On Thu, Aug 29, 2024 at 06:55:07PM +0100, Mark Brown wrote:
> On Thu, Aug 22, 2024 at 04:10:59PM +0100, Joey Gouly wrote:
> 
> > +static bool fault_from_pkey(unsigned long esr, struct vm_area_struct *vma,
> > +			unsigned int mm_flags)
> > +{
> > +	unsigned long iss2 = ESR_ELx_ISS2(esr);
> > +
> > +	if (!system_supports_poe())
> > +		return false;
> > +
> > +	if (iss2 & ESR_ELx_Overlay)
> > +		return true;
> 
> Does this need an is_data_abort() && is_instruction_abort() check?
> Overlay doesn't appear to be defined for all exception types and it
> wasn't clear enough to me that the callers have done this check.

The only callers are in do_page_fault(), which should only be data or
instruction aborts. I talked with Catalin and he said it's fine to not check
again here.

I can add a permissions check though:

commit 033270f5a9462e998b4dee11fc91b43ac7929756
Author: Joey Gouly <joey.gouly@arm.com>
Date:   Tue Sep 3 15:45:59 2024 +0100

    fixup! arm64: handle PKEY/POE faults

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index a68055150950..f651553a8ab8 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -495,6 +495,9 @@ static bool fault_from_pkey(unsigned long esr, struct vm_area_struct *vma,
        if (!system_supports_poe())
                return false;
 
+       if (!esr_fsc_is_permission_fault(esr))
+               return false;
+
        if (iss2 & ESR_ELx_Overlay)
                return true;
 


Since the ESR_EL1 documentation says:
	If a memory access generates a Data Abort for a Permission fault, then this field holds information
	about the fault.

Thanks,
Joey
