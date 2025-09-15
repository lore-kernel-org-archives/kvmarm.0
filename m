Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564631D9346;
	Mon, 15 Sep 2025 20:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757968563; cv=none; b=aG91wR2Kgmq3W4YgUstR9dQJT5IJuzo/vc/tL0CR6OM7aWotrLdEFMn9P7qjgbTdCSaMYwMX+t1cZbwSx38byPOh2OeyQSKmENzJs0v6SuJqFEBCZmOH78QCZzdpqsQ21pBav43c4YHsyQ+/cmksOdqLK8Hznn9H3f1wi+NEbx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757968563; c=relaxed/simple;
	bh=UgxWkx20mLbjGJHtFMXRZBk/r8XEEjLc3+vaV13RdrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eHe3NrP1P66Q8jlcbkJ+3JrqaAU1FWsNTIIgNXcDDzYffjtWCr92qyilKiJLH+vPC7BkcXR0LG3aHCyfkpLt3/Fu07FevSLyFiFr4KNkBmL8iwrw4z4Gk15BPSAHlzlZWo1cN0UzKkBzwA472vzDI3vH+w2TU8SDUCUqLQ4/aIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A87y8xXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A87y8xXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278FDC4CEF1;
	Mon, 15 Sep 2025 20:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757968560;
	bh=UgxWkx20mLbjGJHtFMXRZBk/r8XEEjLc3+vaV13RdrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A87y8xXLRWfDVnc+cHUjCPS+b9h5AghuQgjUK7aBXiqXRbq3+IINnm4/0dZR6C2xA
	 IIwgHW0srU4nv7wUOUDJGv78gDfqSQkMqkWgdroNaf/sSZgQ2h0MPg937mgTBtAATk
	 ewwujp5TfLHg78mUCSWBAAA/KLaJ6xMvc/dESC9l5Ud7aPc1k+WQegv7fpGEtkyU77
	 KordH3nm+iDSikLGG13Jlmr6jDAzyJ1noshxpEkVKePOV8A0tUDdYuBdyMpCXRIeKv
	 DDebXA4JuXc35gA1MXmBoU3Q0Z9kRHsejZQIasuz+g34BWTKw2J+O9hvxlKmlehZo3
	 n+cKwCOdznzPA==
Date: Mon, 15 Sep 2025 21:35:55 +0100
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMh4q4-xAPHnaOul@willie-the-truck>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
 <aMhrscd1gz_syMtL@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMhrscd1gz_syMtL@arm.com>

On Mon, Sep 15, 2025 at 08:40:33PM +0100, Catalin Marinas wrote:
> On Mon, Sep 15, 2025 at 11:32:39AM +0100, Yeoreum Yun wrote:
> > > On Sat, Aug 16, 2025 at 04:19:27PM +0100, Yeoreum Yun wrote:
> > > > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > > > index bc06691d2062..ab7003cb4724 100644
> > > > --- a/arch/arm64/include/asm/futex.h
> > > > +++ b/arch/arm64/include/asm/futex.h
> > > > @@ -7,17 +7,21 @@
> > > >
> > > >  #include <linux/futex.h>
> > > >  #include <linux/uaccess.h>
> > > > +#include <linux/stringify.h>
> > > >
> > > >  #include <asm/errno.h>
> > > >
> > > > -#define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
> > > > +#define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */
> > >
> > > I just noticed - you might as well leave the name as is here, especially
> > > if in patch 6 you align down address and use CAS on a 64-bit value as
> > > per Will's comment (and it's no longer LLSC). I think renaming this is
> > > unnecessary.
> > 
> > Okay. I'll restore to use origin name.
> > But I think LSUI wouldn't be used with CAS according to patch 6's
> > comments from you and additionally i think
> > chaning the CAS would make a failure because of
> > change of unrelated field. i.e)
> > 
> > struct user_structure{
> >   uint32 futex;
> >   uint32 some_value;
> > };
> > 
> > In this case, the change of some_value from user side could make a
> > failure of futex atomic operation.
> 
> Yes but the loop would read 'some_value' again, fold in 'futex' and
> retry. It would eventually succeed or fail after 128 iterations if the
> user keeps changing that location. Note that's also the case with LL/SC,
> the exclusive monitor would be cleared by some store in the same cache
> line (well, depending on the hardware implementation) and the STXR fail.
> From this perspective, CAS has better chance of succeeding.
> 
> > So I think it would be better to keep the current LLSC implementation
> > in LSUI.
> 
> I think the code would look simpler with LL/SC but you can give it a try
> and post the code sample here (not in a new series).

If you stick the cas*t instruction in its own helper say, cmpxchg_user(),
then you can do all the shifting/masking in C and I don't reckon it's
that bad. It means we (a) get rid of exclusives, which is the whole
point of this and (b) don't have to mess around with PAN.

> BTW, is there a test suite for all the futex operations? The cover
> letter did not mention any.

I was thinking that too. I'm sure I remember a 'futextest' kicking
around when we did the arm64 port but nowadays there's something in
tools/testing/selftests/futex/ which might be better.

Will
