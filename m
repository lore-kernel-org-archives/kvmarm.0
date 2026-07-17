Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322DC2E5B21
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 14:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784297729; cv=none; b=sMEOor5T1gdl3IS4SlnJoj8UffriDosQDPdk7fZyKL7wTeQ3Z+PIEpi6sXJxxeFtrqchQyEByiL193FiyUvMAsYq9ivh3nkjsdcLGTje3vO0xeiiVzDqDJ23/RdezREsX7IBZzBk4my3cl8CCZBPVuVOT+Jyghutu8YbQYG4sjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784297729; c=relaxed/simple;
	bh=RM1hOBqe41YQpTvamNFSraYKKzqvGr7XM19iPvWqC6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l8YhwoQXmG3LoeE5YUZxUS4QEclBDR8v5Qo/y/eL55mK27cM8TBgw4qiRr+a0pqYZR9y/8ST1h8jLCtItjQvYx5A+Rw/ZMydWxG++4JfuJ8TPJPbOm7PohDBjUavjd4jNZK9m+T/vSsFqHlcUR3v31EqjPr11paiP0iFxZPam1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VkbdwdyP; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VkbdwdyP"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-69a19eb2e6dso14108a12.1
        for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 07:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784297725; x=1784902525; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YXWH6Jhwl8wi1iKMhYEPExb/6oMzNFQqYI2WByMT/XQ=;
        b=VkbdwdyPB+BUo7kxpX49NJPrLLOvfK7OI/01fVBf8DWbZFQaA56yFpI+IfDzEasyS3
         fIJcg8j5ZJtIrDGsJKwfjyGzGeiKjMO/Y3N3ncGFPrKs/DAhtW3vR7jbr90i2UaYeul6
         Uuur9NT23hkodE6kbz9nUAJC4NjfIF/vi9h1DawwIwXx5vx0F8E1vcxnYd//jU8eHnCn
         BZ7LlVy+CrWWyjAOS03rAQGZr8tALrv+tb0UwpoWVKKfx2ikd/Id95TdVWO2289At0aW
         hANIM80WS+8qb7N/BQV0Wjh0KTOtObDz9W8hcSl7Q/QQewY08OpUik1sVjtJFOASq7qY
         9LKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784297725; x=1784902525;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YXWH6Jhwl8wi1iKMhYEPExb/6oMzNFQqYI2WByMT/XQ=;
        b=U7BwVO2NHJ1y+RakWRvvEBpnuZqBQCmYGGYK51PuY8ZIC5UpLNHIxiVYDCqBWhu+3F
         TH5qQY8aVUabxWORlH36uspbv8xQ3tSHqWz6ulf72I47aLyDoqYZiQUX+INLX7TvD+tf
         7p157nB1hV/1kc2XV61M9+rH5KpsbhYDvtrqmrqB1CZEF3JB4XCXgv7cjnOOyK69IeyP
         EIaQ0hino+corH68ritLle3s6U/ZgX92hGchB30LMg2R3XILS8CPG7/kqqrmothS6wCu
         n8+b1M41DjdXNrpAEm0gMdF0tvsOSzv4/h+45SZsstRlF5ZfhK47/jieoKjcL/Qs/T2p
         kvjw==
X-Forwarded-Encrypted: i=1; AHgh+RpytbBT/BRo7Rz+dKc8uxei7LaiTPdwlcih+h8Yes/t2LCndyVBSqMYrjnxsEP1e46H/f48FmI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOc0ogX6JdBDYfR+cmitEUQTrcSBT5++PLHDPMTB1/411z/Ksa
	fNVTeIB/2jApEbV/1MGp4/7NjJ7xahzBUy5LDizty9iaDg5TKuPx2j6BZOzkwRCZj2mCS3rTN5B
	aYzsFQw==
X-Gm-Gg: AfdE7clVzXXZn3dQqBWgupL3dgkmZXhwM+ZDBK6xmpKsAxha/V3DUtrXEW900gThtjn
	dikcMtED7a91gBqQz9meHfwCikUll8BW67wXBTTsQIEQruk3WsC4GjWF6R3M3bKSjSQHHwx2wou
	9Ck8gP/T5oVO5h9fF/L/o73p7KpBsbRyKLNSvUKDuoBNrxkSmBAQcGiZ1m2dDh1gZE5n1eBrUiT
	Krk6jukg8YnmUrIjQnXB1z4DVP1XLLKZdmG+PTBMMvIQK3GH9++GKu1nopQ++QU7owpJni5rcqY
	dBC5zf0axFMAsd+JGJWnL3+fJjZt9ImEbChlLhvJlmJ1nLqS8ekr66iJ9but8eT4PnJS/TJ/FOQ
	cWfun884e423N82PWP2aGsODC31AXV1Z0wUrZZR1zCuxX9EucoWImQ+r5vEgMRgI1Uij2VdxfGo
	Tipy79VXiPMfOMsX+EfBiW5yLnkU6Z1yvAIFEpLSw=
X-Received: by 2002:a05:6402:b32:b0:69c:39f5:7e36 with SMTP id 4fb4d7f45d1cf-69e85fbe0damr3218a12.0.1784297725014;
        Fri, 17 Jul 2026 07:15:25 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1712a5f837sm82465066b.32.2026.07.17.07.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 07:15:23 -0700 (PDT)
Date: Fri, 17 Jul 2026 14:15:20 +0000
From: Mostafa Saleh <smostafa@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	Oliver Upton <oupton@kernel.org>
Subject: Re: [RFC PATCH 2/2] KVM: arm64: Support BBM level 3
Message-ID: <alo4-GK0K012OppT@google.com>
References: <20260717130901.2239134-1-smostafa@google.com>
 <20260717130901.2239134-3-smostafa@google.com>
 <20260717132857.AC30A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260717132857.AC30A1F00A3A@smtp.kernel.org>

On Fri, Jul 17, 2026 at 01:28:57PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] Replacing a block mapping with an empty table mapping using BBML3 violates architectural requirements and causes TLB conflict aborts.
> --
> 
> --- Patch [2]: [RFC PATCH 2/2] KVM: arm64: Support BBM level 3 ---
> commit ea79cffc563af3beac80c1a139cbab5674ecb7f0
> Author: Mostafa Saleh <smostafa@google.com>
> 
> KVM: arm64: Support BBM level 3
> 
> This patch introduces support for hardware Break-Before-Make (BBM) level 3
> to replace stage-2 PTEs directly instead of using the software sequence.
> It atomically updates the PTE and relies on hardware features to handle
> the transition.
> 
> > --- a/arch/arm64/kvm/hyp/pgtable.c
> > +++ b/arch/arm64/kvm/hyp/pgtable.c
> 
> [ ... ]
> 
> > @@ -1069,7 +1102,10 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
> >  	 * will be mapped lazily.
> >  	 */
> >  	new = kvm_init_table_pte(childp, mm_ops);
> > -	stage2_make_pte(ctx, new);
> > +	if (!stage2_make_pte(ctx, data->mmu, new)) {
> > +		mm_ops->put_page(childp);
> > +		return -EAGAIN;
> > +	}
> >  
> >  	return 0;
> >  }
> 
> [Severity: Critical]
> Does using BBML3 to replace a block mapping with an empty table mapping risk
> a TLB conflict abort?
> 
> In stage2_map_walk_leaf(), the code allocates a zeroed page for the new
> table and installs it. With BBML3, stage2_make_pte() atomically overwrites
> the valid block PTE with the new empty table PTE, bypassing the software
> break step.
> 
> Because the new table is unpopulated, if another CPU takes a stage-2 fault
> on this range before the TLBI completes, it can populate a 4KB page in the
> new table. That CPU will then cache the new 4KB mapping while still holding
> the old 2MB block mapping in its TLB. The overlapping entries will trigger
> a fatal TLB Conflict Abort, panicking the host.
> 
> Would it be necessary to either fall back to the software break-before-make
> sequence when splitting a block, or ensure the new table is populated with
> equivalent translations before the atomic swap?

The point of BBML3 is not to get conflict aborts, so I do not believe
that can happen.

Thanks,
Mostafa


> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260717130901.2239134-1-smostafa@google.com?part=2
