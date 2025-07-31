Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746BA23B63A
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 16:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753980264; cv=none; b=nEHMZi+ZUJAKW5T4Msu/xlR2DLujl1+thixor+HqfmDYnuDJJyfg6Au48M5aX4wPm7AY6Mlhlxljm7OZ2b2Thxaf5p0Yt6f4ngmr+LGxxVxmq1/fpuaRcXkrE3psf1FUhS5VDNrL0K8HZGQQhy1IluzqilPn2tUap65/rtfQnnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753980264; c=relaxed/simple;
	bh=0ydWxwjD9XEC5CUiTws7bnBflFo19mkRu4g2JfonLVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQNUXAjQPCDdY9aMwlkaJwBWK/2+sMjaJ7XXNgrw1C4fRExLt69ntezTOGb35Mo6Dr2Jn+l49DMOB4hCexO9+npOyv1kzkrElqShqTp60bWeQfKV5ERUmdfrrusRMjJky7wqmnD3xP8eeE+U9Fcy3df+na2Peq8/5SwrfJBvAc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=dwLBwt9V; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="dwLBwt9V"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7e050bd078cso104849885a.3
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 09:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753980261; x=1754585061; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tcmilfvF9ZQoGR+FnM2Pm4UtduREsySGygmbtoMGep0=;
        b=dwLBwt9VxqRTW/IPOmB36wo+1S3+KdN4LtMK/IF5cVHgqvrdlxS/Jrzi9GsfBsCbJk
         w8YxfMXXYvXdQYXqnS/XHaSATpsuAYeGp+hdjCJcr6oNaS3GSMKq24YIOwsbffoF5a5k
         L3OlNgCZFy4ErIN+31mO4vLQ2Lex/D1ytjKAcgqwOj1RhsMEbkvG9AtAEYtnQsrUI6+M
         Jv/IXa0kxF1rd/91UMKI8DMaYlQmKtzagFN1lNE76IiWoKIl/5Bz6svxdC1vzFnbPbDC
         pwJbz80SvQFuvCCXRlDanhEZ6svvdrzc9Hco342XdDuhH/7PL9fX6f/THtu6VlBg0OtZ
         mSmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753980261; x=1754585061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tcmilfvF9ZQoGR+FnM2Pm4UtduREsySGygmbtoMGep0=;
        b=h0WL8rNhIL35T956rTaj5ei1gjs1M9JOPUxQvZuHkX8AGk3TFUBVSGHXeRhec91rUo
         Y0V68puu+4+C0Lzr7R9BfkgbJDver28sDtNvDC13NXBEdjDsUXptzFtuup/7/aSf3mSX
         tJSJVkwnjGkbUccR202JyO8XtVXyti8nuQmF1eyHpbyqty+QqTSwErqBob2tW8c0lz8z
         smle8kJKeCJWltc6eStSUd26yPnPyH3pA3YNB9gyu/3uJoMog3cCi/l9agcEdOHbSEmv
         VDJyQ6ILK3ZHLkidD6/ysdDx7570VMmJJAUeYHfkb1ykauX7jteTHv/irmDNjwtRV6QX
         khcw==
X-Forwarded-Encrypted: i=1; AJvYcCV946P2J17i81wImBIwg/9m1FO8qSR7uRwAQsWX68cISbw6hFjq8dCtWWN7fx6pGNOKRqwtLFE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3CvwyecfMKWnBdyiYdeJ6cOYM9ZMYInzwyubWRk/OaWt29X2l
	uNpPx1KX7CNoX+9togYYqtAs8J2Sk26QbTwcBSKerGd6pOFLLcogkNiNRiNlw1pH8f0=
X-Gm-Gg: ASbGncvEMZ1CBRkJeTmVnlBQ/r5lYz6hDTy8OQHdbBiEIzdiEONO6Zk2bOhhfYlFZyc
	pmslMc1bXGJQcIPxkZWDfWQaN3RfsK17cBhCbj0aTgja61Nem9bekaIq+gk0CpqENfKTct+scer
	0TgmvK4ZBFB/rpar0+cELXoYFr6NMHNx2lssgpLRB+gYe9HgzL6pn0Ok4hR0Ycv+uSPhpeiXa9+
	4Kjhl8LdI0GzgytbnoRLP82mLkjP1OtXW500yG2wEHYqrUjqITdy8D9EIgrIDR/b/cDQ7+izgky
	b5XXzp0RNJVhXSZHzu3Dsie+f5vtoSYpiwaljv1OAmIomep0BdpFEbRTE81CzNXDJ96zrWIUbW6
	xHJKGb6RjZzPa3rh4ta3PST37B+xBIk8mXqFlwgIMS+FoP4Wg01hV/dpe+0ooE2JJSVVY
X-Google-Smtp-Source: AGHT+IGezk+WkJhds2uXLxdfTtDWHWkQhul0EkxScNsiZbu9fh3mwabmeFpESJ116Y7P+FXm+MFLoA==
X-Received: by 2002:a05:620a:4447:b0:7e6:7c5e:61a4 with SMTP id af79cd13be357-7e67c5e6a28mr597979385a.62.1753980261143;
        Thu, 31 Jul 2025 09:44:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeec005c2sm10224741cf.16.2025.07.31.09.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 09:44:20 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhWOC-00000000qAm-0Z6k;
	Thu, 31 Jul 2025 13:44:20 -0300
Date: Thu, 31 Jul 2025 13:44:20 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 04/38] tsm: Support DMA Allocation from private
 memory
Message-ID: <20250731164420.GW26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-5-aneesh.kumar@kernel.org>
 <20250728143318.GD26511@ziepe.ca>
 <yq5a5xfbbe35.fsf@kernel.org>
 <20250729143339.GH26511@ziepe.ca>
 <bbe2a41a-8f72-4224-a0bc-225c1e35a180@arm.com>
 <20250731121740.GQ26511@ziepe.ca>
 <1388fb70-3d2d-4c41-9526-521cb75eb422@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388fb70-3d2d-4c41-9526-521cb75eb422@arm.com>

On Thu, Jul 31, 2025 at 02:48:23PM +0100, Suzuki K Poulose wrote:
> On 31/07/2025 13:17, Jason Gunthorpe wrote:
> > On Wed, Jul 30, 2025 at 11:09:35AM +0100, Suzuki K Poulose wrote:
> > > > > It is unclear whether devices would need to perform DMA to shared
> > > > > (unencrypted) memory while operating in this mode, as TLPs with T=1
> > > > > are generally expected to target private memory.
> > > > 
> > > > PCI SIG supports it, kernel should support it.
> > > 
> > > ACK. On Arm CCA, the device can access shared IPA, with T=1 transaction
> > > as long as the mapping is active in the Stage2 managed by RMM.
> > 
> > Right, I expect that the T=0 SMMU S2 translation is a perfect subset of
> > the T=1 S2 rmm translation. At most pages that are not available to
> > T=0 should be removed when making the subset.
> 
> Yes, this is what the VMM is supposed to do today, see [0] & [1].

Okay great!

> > I'm not sure what the plan is here on ARM though, do you expect to
> > pre-load the entire T=0 SMMU S2 with the shared IPA aliases and rely
> > on the GPT for protection or will the hypervisor dynamically change
> > the T=0 SMMU S2 after each shared/private change? Same question for
> 
> Yes, share/private transitions do go all the way back to VMM and it
> is supposed to make the necessary changes to the SMMU S2 (as in [1]).

Okay, it works, but also why?

From a hypervisor perspective when using VFIO I'd like the guestmemfd
to fix all the physical memory immediately, so the entire physical map
is fixed and known. Backed by 1G huge pages most likely.

Is there a reason not to just dump that into the T=0 SMMU using 1G
huge pages and never touch it again? The GPT provides protection?

Sure sounds appealing..

> As for the RMM S2, the current plan is to re-use the CPU S2 managed
> by RMM.

Yes, but my question is if the CPU will be prepopulated
 
> Actually it is. But might solve the problem for confidential VMs,
> where the S2 mapping is kind of pinned.

Not kind of pinned, it is pinned in the hypervisor..
 
> Population of S2 is a bit tricky for CVMs, as there are restrictions
> due to :
>   1) Pre-boot measurements
>   2) Restrictions on modifying the S2 (at least on CCA).

I haven't dug into any of this, but I'd challenge you to try to make
it run fast if the guestmemfd has a full fixed address map in 1G pages
and could just dump them into the RMM efficiently once during boot.

Perhaps there are ways to optimize the measurements for huge amounts
of zero'd memory.

> Filling in the S2, with already populated S2 is complicated for CCA
> (costly, but not impossible). But the easier way is for the Realm to
> fault in the pages before they are used for DMA (and S2 mappings can be
> pinned by the hyp as default). Hence that suggestion.

I guess, but it's weird, kinda slow, and the RMM can never unfault them..

How will you reconstruct the 1G huge pages in the S2 if you are only
populating on faults? Can you really fault the entire 1G page? If so
why can't it be prepopulated?

Jason
