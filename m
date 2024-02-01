Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05FD5338E
	for <kvmarm@lists.linux.dev>; Thu,  1 Feb 2024 14:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706796460; cv=none; b=UFHyzSQDw9AhVeVkRc4h1nGbL8LHPhuIbAKlsQN+/NO68kSMBgavlHLg7ek77l0wIa1GxnIzD2FB14nuNNr/8XogP4wa1tCvklIpxeGdc9jXrmDxXGHvIam1MAoR9Vs/GZhxN4dRFZx2W2XpyRL+yW+QV+yL3WuXwFaQJx2EVVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706796460; c=relaxed/simple;
	bh=YtLtuVt5vQKSAoGXbjHiPmAHSNvylt8YcQtO+iRY/Pg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7AHzoDCkND+YukSH5Ecm8V72m2ZQIHZeGajy6yV56xyeF1qZr82DmRDqGPLRnBzQUMJBSMhUTz/uHI7Qp2UxcVolcrMvlhkAtAYCdrI6yJf9V5b9YTTOPmY4sHaSB3qYgMV1yfOvRDqa24KwvxYsC6onUiERQwepvzIS39x/34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v8EGgKte; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v8EGgKte"
Date: Thu, 1 Feb 2024 15:07:33 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706796455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3ntF7DWN6F8I0OAuVeni8p7DVjwqpl4tVp6WRDH3YQo=;
	b=v8EGgKtenv72eLmWDr1zepVo2BZCviDOXDc54vso1yf79P4b21OE6OTSEj93VaLz7ApGWz
	L3Tq2PoHEL0zugtqPFHYlbDx9zjodP15uSvCWInkePahq4j4RJrF6ztzR4+8XGF7p4Gpb4
	8M7I4ton9TNUrqD0JJa/jNVKAJv6z5s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvmarm@lists.linux.dev, ajones@ventanamicro.com, anup@brainfault.org, 
	atishp@atishpatra.org, pbonzini@redhat.com, thuth@redhat.com, alexandru.elisei@arm.com
Subject: Re: Re: [kvm-unit-tests PATCH v2 02/24] riscv: Initial port, hello
 world
Message-ID: <20240201-404e7aa6ecc346953b825dc5@orel>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
 <20240126142324.66674-28-andrew.jones@linux.dev>
 <b015765b-9833-4879-88fd-1c457b9c292f@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b015765b-9833-4879-88fd-1c457b9c292f@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 01, 2024 at 09:29:36AM +0100, Eric Auger wrote:
...
> > --- /dev/null
> > +++ b/riscv/cstart.S
> > @@ -0,0 +1,92 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/*
> > + * Boot entry point and assembler functions for riscv.
> > + *
> > + * Copyright (C) 2023, Ventana Micro Systems Inc., Andrew Jones <ajones@ventanamicro.com>
> > + */
> > +#include <asm/csr.h>
> > +
> > +.macro zero_range, tmp1, tmp2
> For my education what were the tmp3/4 args used for on arm?
> > +9998:	beq	\tmp1, \tmp2, 9997f
> > +	sd	zero, 0(\tmp1)
> > +	addi	\tmp1, \tmp1, 8
> > +	j	9998b
> > +9997:
> > +.endm
> > +

arm doesn't have a zero register like arm64 and riscv32/64 have, so at
least one extra tmp register is needed to hold the zero stored to the
memory. We use two tmp registers because arm has a 'strd' instruction
allowing us to write two at once, as long as the first register is
an even-numbered register and the second is the immediately following
odd-numbered register. (We should probably write a comment about the
purpose and even/odd constraints of tmp3/4 above the zero_range macro
in arm/cstart.S)

Thanks,
drew
