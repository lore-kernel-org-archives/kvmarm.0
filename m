Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50AD02222B6
	for <kvmarm@lists.linux.dev>; Wed, 17 Sep 2025 13:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758117466; cv=none; b=iR/Aio2juYbg1SoxSi0kVc9ldPJQk51QxOTkjLFSk20TuN/BPjeuAppBfdSkUh5rg3kPGlGfbfIa6BMdab8IZa76GtfotWyuGRGIAX8JdgNGT3oUN7sZPB3RRQtBFolPSWUdnzbUvXys2GQiHHrdB+XStZCX9yl2DhEoKsW8nCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758117466; c=relaxed/simple;
	bh=e378j9eQX5jKML3DSHKPegERxGYFyNqYw9rBaZUA128=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tBEfMsSSwiHEvqe6z8ceQyOi1JT71+S8lKR6nMHQ+pfPJ0oF8eeqN//vaoiPefd/ScsiPVJ7n7cKkHN9t/ku26vNBIfqiwHU/aYwhZxicahssevxtwoMQqMcZmBGOCh7zR0bpuAXpAveQUZ5YS7u75d80KrJZPlX7GHzswytfBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D0DC2659;
	Wed, 17 Sep 2025 06:57:36 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 892213F673;
	Wed, 17 Sep 2025 06:57:42 -0700 (PDT)
Date: Wed, 17 Sep 2025 14:57:40 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: catalin.marinas@arm.com, will@kernel.org, broonie@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	james.morse@arm.com, ardb@kernel.org, scott@os.amperecomputing.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 5/5] arm64: futex: support futex with FEAT_LSUI
Message-ID: <aMq-VKIo-tYoGRSz@J2N7QTR9R3>
References: <20250917110838.917281-1-yeoreum.yun@arm.com>
 <20250917110838.917281-6-yeoreum.yun@arm.com>
 <aMqx67lZZEgYW-x5@J2N7QTR9R3>
 <aMq5DbqsXj6vP7Xe@e129823.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMq5DbqsXj6vP7Xe@e129823.arm.com>

On Wed, Sep 17, 2025 at 02:35:09PM +0100, Yeoreum Yun wrote:
> Hi Mark,

Hi Levi,

Please can you keep the relevant reply headers (i.e. the bit that says
"On ${DATE} ${PERSON} wrote:")? You kept yours from your first reply,
but dropped mine from the reply you're replying to, which is a bit
awkward for anyone following the thread.

> > Aside from the retry issue, I *think* you can simplify this to something
> > like:
> >
> > static __always_inline int
> > __lsui_cmpxchg32(u32 __user *uaddr, u32 oldval, u32 newval, u32 *oval)
> > {
> > 	uaddr64 = (u64 __user *)PTR_ALIGN_DOWN(uaddr, sizeof(u64));
> > 	u64 oval64, nval64, orig64;
> >
> > 	if (get_user(oval64, uaddr64)
> > 		return -EFAULT;
> >
> > 	if (IS_ALIGNED(addr, sizeof(u64)) == IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))  {

Note: typo here, this should be 'uaddr', not 'addr'. Importantly it is
*NOT* 'uaddr64'

> > 		FIELD_MODIFY(GENMASK_U64(31, 0), &oval64, oldval);
> > 		FIELD_MODIFY(GENMASK_U64(31, 0), &nval64, newval);
> > 	} else {
> > 		FIELD_MODIFY(GENMASK_U64(63, 32), &oval64, oldval);
> > 		FIELD_MODIFY(GENMASK_U64(63, 32), &nval64, newval);
> > 	}
> > 	orig64 = oval64;
> >
> > 	if (__lsui_cmpxchg64(uaddr_al, &oval64, nval64))
> > 		return -EFAULT;
> >
> > 	if (oval64 != orig64)
> > 		return -EAGAIN;
> >
> > 	*oval = oldval;
> > 	return 0;
> > }
> 
> Hmm I think this wouldn'b cover the case below when big-endianess used.
> 
> struct {
>   u32 others 0x55667788;
>   u32 futex = 0x11223344;
> };
> 
> In this case, memory layout would be:
> 
>   55 66 77 88 11 22 33 44
> 
> So, the value of fetched oval64 is 0x5566778811223344;

Ok, so the entire struct is aligned to 8 bytes, and the 'futex' field is
4 bytes after that (and not itself aligned to 8 bytes). In that case:

	IS_ALIGNED(uaddr, sizeof(u64)) is false, becuase 'futex' is not
	aligned to 8 bytes.

	IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN) is false, since this is
	big-endian.

... so the condition becomes:

	if (false == false)

... which is true, and hence we execute the first branch:

	FIELD_MODIFY(GENMASK_U64(31, 0), &oval64, oldval);
	FIELD_MODIFY(GENMASK_U64(31, 0), &nval64, newval);

> So, it should modify the GENMASK_U64(31, 0) fields.
> But, it tries to modify GENMASK_U64(63, 32) fields.

As above, I think the code does the right thing in this case, but the
typo didn't help -- sorry about that.

Mark.
