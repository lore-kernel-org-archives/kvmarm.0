Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D7D212574;
	Mon, 15 Sep 2025 19:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757965239; cv=none; b=aSsyBj56WeVo/VgGbV0Wd6DYWrBRBhNypBRCcBbDi+iO5IqopcXnompjRoC/B8IwqR3NcyZHWrqU692UaTmEUXA7wTG85aiZuHVTd+laemZSc4SSmxzYCT1dwuvauNNhhl2UVxHQNgDGh4owWCIe9lVMSjCCm+pkCQTuzvk7GCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757965239; c=relaxed/simple;
	bh=g5xAknOdfENgPm/cKcyiCHJ9HVP9ZcMgVpHNO/PV2QE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=djFsF1A9XnURolynkW4DxdQaqyjn4an+lnJxfICCZEv65NxsUvdjFlAJzUrLPj0BxUoMfp8AbvsJtgekYgPtZpc2bEap7YFm7RERyPgiy1wAe5P28//2EJda1XaWti08vpYSTk7mAMXoooRnonbAO0rpTzH2gbvVsEo/SptwWPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F133C4CEF1;
	Mon, 15 Sep 2025 19:40:36 +0000 (UTC)
Date: Mon, 15 Sep 2025 20:40:33 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: will@kernel.org, broonie@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, james.morse@arm.com,
	ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v7 4/6] arm64: futex: refactor futex atomic
 operation
Message-ID: <aMhrscd1gz_syMtL@arm.com>
References: <20250816151929.197589-1-yeoreum.yun@arm.com>
 <20250816151929.197589-5-yeoreum.yun@arm.com>
 <aMRQIeIdyiWVR8a0@arm.com>
 <aMfrR0vserl/hfZ3@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMfrR0vserl/hfZ3@e129823.arm.com>

On Mon, Sep 15, 2025 at 11:32:39AM +0100, Yeoreum Yun wrote:
> > On Sat, Aug 16, 2025 at 04:19:27PM +0100, Yeoreum Yun wrote:
> > > diff --git a/arch/arm64/include/asm/futex.h b/arch/arm64/include/asm/futex.h
> > > index bc06691d2062..ab7003cb4724 100644
> > > --- a/arch/arm64/include/asm/futex.h
> > > +++ b/arch/arm64/include/asm/futex.h
> > > @@ -7,17 +7,21 @@
> > >
> > >  #include <linux/futex.h>
> > >  #include <linux/uaccess.h>
> > > +#include <linux/stringify.h>
> > >
> > >  #include <asm/errno.h>
> > >
> > > -#define FUTEX_MAX_LOOPS	128 /* What's the largest number you can think of? */
> > > +#define LLSC_MAX_LOOPS	128 /* What's the largest number you can think of? */
> >
> > I just noticed - you might as well leave the name as is here, especially
> > if in patch 6 you align down address and use CAS on a 64-bit value as
> > per Will's comment (and it's no longer LLSC). I think renaming this is
> > unnecessary.
> 
> Okay. I'll restore to use origin name.
> But I think LSUI wouldn't be used with CAS according to patch 6's
> comments from you and additionally i think
> chaning the CAS would make a failure because of
> change of unrelated field. i.e)
> 
> struct user_structure{
>   uint32 futex;
>   uint32 some_value;
> };
> 
> In this case, the change of some_value from user side could make a
> failure of futex atomic operation.

Yes but the loop would read 'some_value' again, fold in 'futex' and
retry. It would eventually succeed or fail after 128 iterations if the
user keeps changing that location. Note that's also the case with LL/SC,
the exclusive monitor would be cleared by some store in the same cache
line (well, depending on the hardware implementation) and the STXR fail.
From this perspective, CAS has better chance of succeeding.

> So I think it would be better to keep the current LLSC implementation
> in LSUI.

I think the code would look simpler with LL/SC but you can give it a try
and post the code sample here (not in a new series).

BTW, is there a test suite for all the futex operations? The cover
letter did not mention any.

-- 
Catalin
