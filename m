Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D82A95E
	for <kvmarm@lists.linux.dev>; Thu,  2 Jan 2025 12:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735820871; cv=none; b=EdcgNvrWbjMNcT6uieKY9mwtsT7Lh7U/jeKWnNMu7JPBOf1gK0B3Ip68a3jCr2fArxCY3ISi2fM/bk6hX8NTn6EPtRpIqPvNC2KTuFXooP3ZNKc0y60oYmrV6OR2x5ylGie18Xpv756LEemsT1zOUWr+PFPjE7Er87tsJVaKeb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735820871; c=relaxed/simple;
	bh=sHFO7ciR9xKgxrnAQGOwnRQxJiwwFYDdVxZ6XDxf12U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZuRZILiJT5Fvyw5Oj5GgTFu1IvVAvYQCwXTnoyU8qiso8t0hgfI2FPEZHkE19QJL2mardHkpgO4PSBtS7InxMRKXU0bth6gZIZSRwKAztRp6YlCH7GBJxQ12VPROsfe4yGm6EcS7k6UMAFC5j2CfAzgXxbInfeHhuxelorjIw+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB05D11FB;
	Thu,  2 Jan 2025 04:28:15 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF0A03F673;
	Thu,  2 Jan 2025 04:27:46 -0800 (PST)
Date: Thu, 2 Jan 2025 12:27:43 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.linux.dev,
	nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add basic MTE test
Message-ID: <Z3aGP00bYI9fspi_@raptor>
References: <20241212103447.34593-1-vladimir.murzin@arm.com>
 <Z2lRk_NLHxDPvmrS@raptor>
 <0fc53bdf-f919-40b9-8530-d11593ec55f7@arm.com>
 <Z3K6FLG2qfwphAfS@raptor>
 <20241230-3c7d660ca38c9b390ec74b01@orel>
 <Z3LKLvkLjId1SeTI@raptor>
 <20241230-bccb6213d3a71a09a7d32834@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241230-bccb6213d3a71a09a7d32834@orel>

Hi Drew,

On Mon, Dec 30, 2024 at 05:52:54PM +0100, Andrew Jones wrote:
> On Mon, Dec 30, 2024 at 04:28:30PM +0000, Alexandru Elisei wrote:
> > Hi Drew,
> > 
> > On Mon, Dec 30, 2024 at 04:45:01PM +0100, Andrew Jones wrote:
> > > On Mon, Dec 30, 2024 at 03:19:48PM +0000, Alexandru Elisei wrote:
> > > ...
> > > > Interestingly though, when I try to run a test (either with ./run_tests.sh
> > > > mte-sync, or by trying out your example), I get this error:
> > > > 
> > > > qemu-system-aarch64: MTE requested, but not supported by the guest CPU
> > > > 
> > > > My guess is that's caused by kvm-unit-tests defaulting to cortex-a57 as the
> > > > model CPU. Changing the cpu to 'max' makes the test run. How are you getting
> > > > around this on your end?
> > > >
> > > 
> > > We can (and I think should) change to 'max' for the default model.
> > 
> > I think so too, something like this maybe?
> > 
> > diff --git a/configure b/configure
> > index 86cf1da36467..4babbd5f5e74 100755
> > --- a/configure
> > +++ b/configure
> > @@ -286,7 +286,7 @@ fi
> >  [ -z "$processor" ] && processor="$arch"
> > 
> >  if [ "$processor" = "arm64" ]; then
> > -    processor="cortex-a57"
> > +    processor="max"
> >  elif [ "$processor" = "arm" ]; then
> >      processor="cortex-a15"
> >  fi
> > 
> > Can't do the same for arm, because Makefile.arm passes the processor to
> > -mcpu and that causes a build error.
> 
> I wonder if we can improve the mcpu thing by just selecting some generic
> cpu type at this point? Or just dropping it and counting on the compiler
> to use generic cpu type? It'd be nice to use max for both arm and arm64,

I tried setting the default to 'max' for both arm and arm64. If I pass
'max' as the cpu type to arm, I get the build error above. If I don't pass
-mcpu to the arm compiler when $PROCESSOR=max, I get different errors
because of unsupported instructions:

/tmp/ccOHIrg7.s: Assembler messages:
/tmp/ccOHIrg7.s:46: Error: selected processor does not support `yield' in ARM mode
/tmp/ccGCB0zP.s: Assembler messages:
/tmp/ccGCB0zP.s:55: Error: selected processor does not support `ldrex r2,[r4]' in ARM mode
/tmp/ccGCB0zP.s:59: Error: selected processor does not support `strex r3,r2,[r4]' in ARM mode
/tmp/ccGCB0zP.s:71: Error: selected processor does not support `dmb ish' in ARM mode
/tmp/ccGCB0zP.s:99: Error: selected processor does not support `dmb ish' in ARM mode
/tmp/ccGCB0zP.s:144: Error: selected processor does not support `dmb ish' in ARM mode
[..]

and the errors go on. This means that the default cannot be 'max' for arm.

I also realized that the configure --processor option for arm64:

   --processor=PROCESSOR  processor to compile for (aarch64)

does not work as advertised, because the $PROCESSOR variable is not passed
down to the compiler.

So what I'm proposing is this:

- Patch #1: pass $PROCESSOR to the arm64 compiler, to reconcile the help
  text for --processor and to achieve parity with arm.

- Patch #2: have arm64 ignore $PROCESSOR when compiling if it's 'max.  By
  ignore I mean don't add a -mcpu argument to the compiler invocation.
  Change configure to raise an error if --processor=max is used for arm
  (users might think that if it works for arm64, it also works for arm).

- Patch #3: change the default for arm64 to 'max', but don't touch the
  default for arm.

What do you think?

Thanks,
Alex

> but if nobody has time to do the arm work / testing to be sure we can,
> then I'm fine with just a patch changing arm64.
> 
> Thanks,
> drew
