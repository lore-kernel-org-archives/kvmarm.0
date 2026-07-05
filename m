Received: from devianza.investici.org (devianza.investici.org [198.167.222.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3500233721
	for <kvmarm@lists.linux.dev>; Sun,  5 Jul 2026 20:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.167.222.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783282655; cv=none; b=sC0sjg4lvF6uGWH0nokRZCT3Q/tpjfXNlVhIje5leu4Kgr5azLWWbAzsLxDaWRsdo/HtDUWdpiLFu0P1RrqhQZcWeKaz9jUZ+LbQZVZu99i4fp2wHso7qqoX4xB0ng8icD5QA94vdZTF61qthY2vItZ3eFWHYXJjQdla3I1Pwig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783282655; c=relaxed/simple;
	bh=gJnwhF5Jk5BknCg/CRW1sI5PyNZWe8qQ6LYLbNKycWA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=CihIJ2ngjD7+YD/Vw2PDiHlyO/cE7rSUu9qBbXFq6qBVq6ujERFii/66czQTimGogoOMywHMlVjZNZqnY/Z1VlARZsdgwKqQ24CN+nCUzrafUhPs0z55FBZ+m5rWdLBZVU4Pw26E2nMmBdz3ovQI9gybXKjjiSX0L1jRGAf8Xu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net; spf=pass smtp.mailfrom=grrlz.net; dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b=Yp81lp6h; arc=none smtp.client-ip=198.167.222.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=grrlz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=grrlz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=grrlz.net header.i=@grrlz.net header.b="Yp81lp6h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1783282645;
	bh=igEgukfSkxd9Lb0gDtb+b5hHlfZiNI0bOlSQUW3jbLg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Yp81lp6hka566/I/bgdEOy5+VOoNojQqip3RA0McuW/O9kb4fmMHZ8UW6TJviUhE1
	 rAFY/X79D9RDro2RgVmcWAESjKqvPEX7iE7AUAmmaqGPxaEfN8oRbMan8zXdry5rSA
	 XcIPos/X5tz2Zrla5WBlP8ZGuhc1P/vVCooK461M=
Received: from mx2.investici.org (unknown [127.0.0.1])
	by devianza.investici.org (Postfix) with ESMTP id 4gtf114bS8z6vQD;
	Sun, 05 Jul 2026 20:17:25 +0000 (UTC)
Received: by mx2.investici.org (Postfix) id 4gtf111bYnz4y71;
	Sun, 05 Jul 2026 20:17:25 +0000 (UTC)
Date: Sun, 05 Jul 2026 21:17:25 +0100
From: Bradley Morgan <include@grrlz.net>
To: Marc Zyngier <maz@kernel.org>
CC: Dev Jain <dev.jain@arm.com>, Oliver Upton <oupton@kernel.org>,
 Fuad Tabba <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Quentin Perret <qperret@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4=5D_KVM=3A_arm64=3A_Record_whe?=
 =?US-ASCII?Q?ther_pKVM_stage_2_mapping_is_cacheable?=
In-Reply-To: <87cxx16vpw.wl-maz@kernel.org>
References: <20260701192428.17430-1-include@grrlz.net> <a3b2423e-d8bc-4713-90ef-5bfac7079834@arm.com> <87echh6xuh.wl-maz@kernel.org> <8D464B64-27CF-4430-8F7F-9E21B77CE4D3@grrlz.net> <87cxx16vpw.wl-maz@kernel.org>
Message-ID: <E9BEEB06-0617-406E-AAE8-41BCC6739003@grrlz.net>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

On July 5, 2026 9:13:31 PM GMT+01:00, Marc Zyngier <maz@kernel.org> wrote:
>On Sun, 05 Jul 2026 20:29:20 +0100,
>Bradley Morgan <include@grrlz.net> wrote:
>> 
>> On July 5, 2026 8:27:34 PM GMT+01:00, Marc Zyngier <maz@kernel.org>
>wrote:
>> >On Sun, 05 Jul 2026 15:08:58 +0100,
>> >Dev Jain <dev.jain@arm.com> wrote:
>> >> 
>> >> 
>> >> 
>> >> On 02/07/26 12:54 am, Bradley Morgan wrote:
>> >> > pKVM keeps its own mapping list for stage 2 operations. Its flush
>path
>> >> > uses that list directly, so it lost the PTE attribute check done by
>> >the
>> >> > generic stage 2 walker.
>> >> > 
>> >> > Record whether a mapping is cacheable and skip cache maintenance
>for
>> >> > mappings that are not cacheable.
>> >> > 
>> >> > Fixes: e912efed485a ("KVM: arm64: Introduce the EL1 pKVM MMU")
>> >> 
>> >> Is Fixes tag required? If I am reading correctly, Arm ARM says this:
>> >> 
>> >> "For VA-based cache maintenance instructions, the instruction
>operates
>> >on the
>> >> caches regardless of the memory type and cacheability attributes
>marked
>> >for
>> >> the memory address in the VMSA translation table entries. This means
>> >that
>> >> the effects of the cache maintenance instructions can apply
>regardless
>> >of:
>> >>   Whether the address accessed:
>> >>     Is Normal memory or Device memory.
>> >>     Has the Cacheable attribute or the Non-cacheable attribute."
>> >> 
>> >> So nothing goes wrong if we do dcache clean for non-cacheable
>> >> memory.
>> >
>> >Two things:
>> >
>> >- having to perform CMOs for something that is not *expected* to be
>> >  cacheable is both pointless and a contradiction of the intent
>> >
>> >- what you quote is about the nature of the *mapping*, and not the
>> >  memory that is being mapped. Cleaning a dirty cache line on an
>> >  unsuspecting MMIO endpoint is never going to end nicely. Just have a
>> >  try.
>> >
>> >My reading of all this is that a fix indeed is required, and therefore
>> >a Fixes tag *must* be present.
>> >
>> >	M.
>> >
>> >
>> 
>> 
>> Well, fair enough.
>> 
>> It's kind of two things.
>> 
>> 1: A fix
>> 2: a optimization 
>> 
>> I say it's a fix, because it's not fun, no.
>>
>> And I Also say it's a optimization because wasting cycles isn't a good
>> idea, trust me.
>
>This is getting tiresome. Really. And when it comes to wasting cycles,
>you strike me as the expert here.
>
>It's not an optimisation at all. If anything, the test is going to
>cost cycles because there is statistically never a case that you map a
>device with upstream pKVM.
>
>If you call this an optimisation, I'll ask for numbers *proving* this
>is actually one. Do you really want to get down that road?

yeah, lesson learned..

before I embarrass myself more, I'll only respond if I have to...

sorry.

>	M.
>
>

Thanks!
