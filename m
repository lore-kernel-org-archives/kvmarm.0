Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81CDB18C903
	for <kvmarm@lists.linux.dev>; Thu,  2 Jan 2025 12:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735821253; cv=none; b=JJ+oBkTnRMbVhx4Q5lWK22jU84DcUJEJFpyys6ArEIsL0LG/R8Fxf6A4Z/oyKKJTb3WGoMX2kG17l7cb85F7REgij6WRwOGFp8u1tt6Tv9ZeYYZyUhtoa5ITM6WBzPbLfiEWucvdRRUAH03uLJ9y8LhBT4avmVCReZInYv3kvqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735821253; c=relaxed/simple;
	bh=FJdR2n/noBslzLW0g9phdlMT2J8JN0ttwI6fUdHh7qg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGHGh0noNTfElkQpPwPs4pzmWX2n6pfnIuC2qE098cMhFUwBAB3t9x9txUo8pDIrTDBzUk4Jyh9WBUuVRoH/emfkVXZfeuah4gNvBBLcL6yIq39VQKkSbYve4Mh81SEauBZ5A1gFewqG1dd6B6quEkRRGSHR7sASJgikh4FXfGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EaP1GsV+; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EaP1GsV+"
Date: Thu, 2 Jan 2025 13:34:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735821247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WyLgVAvnU84rWbs3BydgFKXcjlVQM93t8r0hK9CLkKA=;
	b=EaP1GsV+zpcbcYntYPAP/RqEMVF7tRUBjHr1fBcw5FjcGMYYxO7BXDNXJ13boMWhtyT/5R
	fbLCg5m0Mnk16s6mJmcjfLltSHhMc7nhgLJhNYszpGPVd4iarzEeb6rf247s4UYQ/ULzwx
	DzkisrphFgIExaLMtJ1sgR0gPkqn6Qc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.linux.dev, 
	nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add basic MTE test
Message-ID: <20250102-ed20423136d7184a12792d22@orel>
References: <20241212103447.34593-1-vladimir.murzin@arm.com>
 <Z2lRk_NLHxDPvmrS@raptor>
 <0fc53bdf-f919-40b9-8530-d11593ec55f7@arm.com>
 <Z3K6FLG2qfwphAfS@raptor>
 <20241230-3c7d660ca38c9b390ec74b01@orel>
 <Z3LKLvkLjId1SeTI@raptor>
 <20241230-bccb6213d3a71a09a7d32834@orel>
 <Z3aGP00bYI9fspi_@raptor>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z3aGP00bYI9fspi_@raptor>
X-Migadu-Flow: FLOW_OUT

On Thu, Jan 02, 2025 at 12:27:43PM +0000, Alexandru Elisei wrote:
> Hi Drew,
> 
> On Mon, Dec 30, 2024 at 05:52:54PM +0100, Andrew Jones wrote:
> > On Mon, Dec 30, 2024 at 04:28:30PM +0000, Alexandru Elisei wrote:
> > > Hi Drew,
> > > 
> > > On Mon, Dec 30, 2024 at 04:45:01PM +0100, Andrew Jones wrote:
> > > > On Mon, Dec 30, 2024 at 03:19:48PM +0000, Alexandru Elisei wrote:
> > > > ...
> > > > > Interestingly though, when I try to run a test (either with ./run_tests.sh
> > > > > mte-sync, or by trying out your example), I get this error:
> > > > > 
> > > > > qemu-system-aarch64: MTE requested, but not supported by the guest CPU
> > > > > 
> > > > > My guess is that's caused by kvm-unit-tests defaulting to cortex-a57 as the
> > > > > model CPU. Changing the cpu to 'max' makes the test run. How are you getting
> > > > > around this on your end?
> > > > >
> > > > 
> > > > We can (and I think should) change to 'max' for the default model.
> > > 
> > > I think so too, something like this maybe?
> > > 
> > > diff --git a/configure b/configure
> > > index 86cf1da36467..4babbd5f5e74 100755
> > > --- a/configure
> > > +++ b/configure
> > > @@ -286,7 +286,7 @@ fi
> > >  [ -z "$processor" ] && processor="$arch"
> > > 
> > >  if [ "$processor" = "arm64" ]; then
> > > -    processor="cortex-a57"
> > > +    processor="max"
> > >  elif [ "$processor" = "arm" ]; then
> > >      processor="cortex-a15"
> > >  fi
> > > 
> > > Can't do the same for arm, because Makefile.arm passes the processor to
> > > -mcpu and that causes a build error.
> > 
> > I wonder if we can improve the mcpu thing by just selecting some generic
> > cpu type at this point? Or just dropping it and counting on the compiler
> > to use generic cpu type? It'd be nice to use max for both arm and arm64,
> 
> I tried setting the default to 'max' for both arm and arm64. If I pass
> 'max' as the cpu type to arm, I get the build error above. If I don't pass
> -mcpu to the arm compiler when $PROCESSOR=max, I get different errors
> because of unsupported instructions:
> 
> /tmp/ccOHIrg7.s: Assembler messages:
> /tmp/ccOHIrg7.s:46: Error: selected processor does not support `yield' in ARM mode
> /tmp/ccGCB0zP.s: Assembler messages:
> /tmp/ccGCB0zP.s:55: Error: selected processor does not support `ldrex r2,[r4]' in ARM mode
> /tmp/ccGCB0zP.s:59: Error: selected processor does not support `strex r3,r2,[r4]' in ARM mode
> /tmp/ccGCB0zP.s:71: Error: selected processor does not support `dmb ish' in ARM mode
> /tmp/ccGCB0zP.s:99: Error: selected processor does not support `dmb ish' in ARM mode
> /tmp/ccGCB0zP.s:144: Error: selected processor does not support `dmb ish' in ARM mode
> [..]
> 
> and the errors go on. This means that the default cannot be 'max' for arm.
> 
> I also realized that the configure --processor option for arm64:
> 
>    --processor=PROCESSOR  processor to compile for (aarch64)
> 
> does not work as advertised, because the $PROCESSOR variable is not passed
> down to the compiler.
> 
> So what I'm proposing is this:
> 
> - Patch #1: pass $PROCESSOR to the arm64 compiler, to reconcile the help
>   text for --processor and to achieve parity with arm.
> 
> - Patch #2: have arm64 ignore $PROCESSOR when compiling if it's 'max.  By
>   ignore I mean don't add a -mcpu argument to the compiler invocation.
>   Change configure to raise an error if --processor=max is used for arm
>   (users might think that if it works for arm64, it also works for arm).
> 
> - Patch #3: change the default for arm64 to 'max', but don't touch the
>   default for arm.
> 
> What do you think?

Works for me.

Thanks,
drew

> 
> Thanks,
> Alex
> 
> > but if nobody has time to do the arm work / testing to be sure we can,
> > then I'm fine with just a patch changing arm64.
> > 
> > Thanks,
> > drew
