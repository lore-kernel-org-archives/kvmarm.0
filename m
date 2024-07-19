Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B730639FF3
	for <kvmarm@lists.linux.dev>; Fri, 19 Jul 2024 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721389488; cv=none; b=V33ZDAb+oPvODUtCpnytJukA6cgjB/gcNAnWOIkS6hM2Vi9eYeCIuWnfdiMyz/AnWgT93qgCYeM3oV6u32ywHD0q3Q0MT3Xoacjg3eF5xhpFEA+w7OkLCEpiEJW1pclhR5BI4FQvBlKICClq7j99P0XxaiK8N9Ve65ot/ibRDXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721389488; c=relaxed/simple;
	bh=kgKTLoK6aEF7j5uUJdbhIC+g+jKuvnbnfAisvztFBcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FR9RbOCDA4Nw+a7Ta/k5rc/knND/A1D3VNaCjGxSbglT6xqBYykExG863O4SEjpfLeobMJAoDe1BgIkrBA9h27E4kn+PYOxy0EJCiL58qgNnZya9VtX/JFnR6gQcK4prW7vXWRwE8SKa9sVWv7wcl/ngXQ4Hngbo7x+bqzBJo3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wWBPvO47; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wWBPvO47"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4266edcc54cso40235e9.0
        for <kvmarm@lists.linux.dev>; Fri, 19 Jul 2024 04:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721389485; x=1721994285; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PqiXhGjOSYu1xQZgH96GVDYB8na0EBhm6a6MmbmS/gs=;
        b=wWBPvO47Or0taxHB9LoIjiJvTsExiddCWKWWj3eSfeNZ6Mnf1ipLMKzAoUsYfnjzRW
         wwqR2/4dnuyoWRr7viXIILnsLTJq36ugCIUIWXNegnc2V4hNZAzzTXb6wuNX3eYMCJCU
         zRf4gefP1YxNx6djEqRqNzpVci1sHSv4bgMOLLe5dglL0PC10FyvdD0NMlbLY2Im3OaF
         1KgdWSdXNQrCMNLGpbm6++5IMHAXwDjpcXo8brFEv3dtBVq5NA0HWBoG5BQqAB3DNFwc
         0/TdVkLa7n0C9wZlw71P0GmIeVqYnP6WjUaBhv5/6/g4gqmezYzfa/FUAzoCMuxAhqpE
         ozFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721389485; x=1721994285;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PqiXhGjOSYu1xQZgH96GVDYB8na0EBhm6a6MmbmS/gs=;
        b=GHWqZN4WfoH5STzXC+p3lDNgTyuqoQT+584ZA+8AfftCxAyunc/hBC/Hm6jcFz5GWM
         N7eBPFY6FpQb2Me/KLGwfq5PNeA6GIjQ7F4B4zCgl2paVUqxBzkiUdL2qbD+dyuO1pCC
         tqpaT+titAo+yvznFuiqsbtbKY/yBfb4pU3ikxIE0RRBLj8jxPR5OIXeoOEiIpVHMQOR
         QLMqapLla1rMwCuf70mKufaOUDDT8P46/64Shfa5C+7s09QgvBCTC3X7v+R3O5QlogxZ
         dt9EGYuyn55d1A+bQ7+clzZZ9kXbG2tgBpKd30BgeIqzTnMU3Ld8hHzktpL1FVjcxXXe
         2FqQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2apv8kG64hXTYUNJJanoNrZ98uOxlwtzfuQsWZSxjQZzi+zl4D2uI6zFr5Qwl9OzSePjd/BvJQKvvujNwf+pX6TgnGMb6
X-Gm-Message-State: AOJu0YxoCwukdO93MLsDX4IMwL8PYLKb2IcTtqoAcLAYfIYJmi/Sm+6Z
	9O0q424MDOdJXfuUWhu3C5fKUsyx89hNLVUAiKZw3qRILNACdvSg3NJvKEYkjw==
X-Google-Smtp-Source: AGHT+IFU0Zkx2Sq301T9KLS1Qev+gl2hXlS+YMiIjix2LoeRgr3gvV/t6LaUnZWd6GxnVJkmx3HXGQ==
X-Received: by 2002:a05:600c:511e:b0:426:5ef2:cd97 with SMTP id 5b1f17b1804b1-427d5812246mr1214575e9.2.1721389484609;
        Fri, 19 Jul 2024 04:44:44 -0700 (PDT)
Received: from google.com (49.222.77.34.bc.googleusercontent.com. [34.77.222.49])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427d2a95099sm47533645e9.48.2024.07.19.04.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 04:44:44 -0700 (PDT)
Date: Fri, 19 Jul 2024 11:44:42 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	vdonnefort@google.com, mark.rutland@arm.com, maz@kernel.org,
	oliver.upton@linux.dev, rananta@google.com, ryan.roberts@arm.com,
	shahuang@redhat.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v7 2/6] arm64: ptdump: Expose the attribute parsing
 functionality
Message-ID: <ZppRqmuL2ORp2uNC@google.com>
References: <20240621123230.1085265-1-sebastianene@google.com>
 <20240621123230.1085265-3-sebastianene@google.com>
 <20240705110747.GA9231@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240705110747.GA9231@willie-the-truck>

On Fri, Jul 05, 2024 at 12:07:48PM +0100, Will Deacon wrote:
> On Fri, Jun 21, 2024 at 12:32:26PM +0000, Sebastian Ene wrote:
> > Reuse the descriptor parsing functionality to keep the same output format
> > as the original ptdump code. In order for this to happen, move the state
> > tracking objects into a common header.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/include/asm/ptdump.h | 41 ++++++++++++++++++++++++++++++++-
> >  arch/arm64/mm/ptdump.c          | 37 ++---------------------------
> >  2 files changed, 42 insertions(+), 36 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> > index 5b1701c76d1c..c550b2afcab7 100644
> > --- a/arch/arm64/include/asm/ptdump.h
> > +++ b/arch/arm64/include/asm/ptdump.h
> > @@ -9,6 +9,7 @@
> >  
> >  #include <linux/mm_types.h>
> >  #include <linux/seq_file.h>
> > +#include <linux/ptdump.h>
> >  
> >  struct addr_marker {
> >  	unsigned long start_address;
> > @@ -21,14 +22,52 @@ struct ptdump_info {
> >  	unsigned long			base_addr;
> >  };
> >  
> > +struct prot_bits {
> > +	u64		mask;
> > +	u64		val;
> > +	const char	*set;
> > +	const char	*clear;
> > +};
> > +
> > +struct pg_level {
> > +	const struct prot_bits *bits;
> > +	char name[4];
> > +	int num;
> > +	u64 mask;
> > +};
> > +
> > +/*
> > + * The page dumper groups page table entries of the same type into a single
> > + * description. It uses pg_state to track the range information while
> > + * iterating over the pte entries. When the continuity is broken it then
> > + * dumps out a description of the range.
> > + */
> > +struct pg_state {
> > +	struct ptdump_state ptdump;
> > +	struct seq_file *seq;
> > +	const struct addr_marker *marker;
> > +	const struct mm_struct *mm;
> > +	unsigned long start_address;
> > +	int level;
> > +	u64 current_prot;
> > +	bool check_wx;
> > +	unsigned long wx_pages;
> > +	unsigned long uxn_pages;
> > +};

Hello Will,

> 
> Minor nit, but if we're moving these structure definitions into the
> header then I'd be inclined to give them some more specific names (e.g.
> prefix them with 'ptdump_'). Granted, this header isn't used widely, but
> it's included by arch/arm64/mm/mmu.c and claiming 'struct prot_bits' is
> a bit over-reaching imo!
> 
> Will

Thanks for having a look. I applied the prefix.

Cheers,
Seb
