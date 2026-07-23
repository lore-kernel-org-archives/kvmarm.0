Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1142930F924
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 15:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784819522; cv=none; b=CpS41MBT1EgjJ9E4R8wTqQDHE8Nl8wYj1aptyAa5o1s9TS1XTuGUqg+dnEwrPYdTY01tcbVPIFnu+Jc3XnbgTqZtuRkIG3Q94foeyLCye3xgd29xq9G+2s+P0uV9KOJAmGxTYzikYycGCFJGGj5LZJXuFGE4JCMf8S3gAGhFZws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784819522; c=relaxed/simple;
	bh=mOmPK2eIGoTxHG2lR4zIq/eSAi4WmC/yfNmKPHDWZDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jS1qpFXBY3RPQO5mHNNPEQ9GtQC7W/CesppJr9rjC/CXIvzrR2aJwGxLLk49XQ3Ru47PJyDAeJKkRQhdowNg66nPbDySHsUsCFdbsdx8/Z7lt4wJ58zEnZPSRrJTEwetSlDEv6cd/XY4n+ZBLiVe2Z8e/YOA8/KtqNW6Hxwd5Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nRRAtb6W; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nRRAtb6W"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4955de8797cso5076145e9.3
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 08:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784819487; x=1785424287; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IYpHP3NN7o6cY+8WOSgLS6195biQhMZQGaK4qqozNH4=;
        b=nRRAtb6WFLeEM75eyEI/dW+60Ia5BlVqKdt61JqaONFBhdft5ZVt1Jd73Yxx4aEcCn
         hbJmY4APJX6LvsPooSg2qP5WG8KOBSNEqNOG6/ckAKncpN9Y/M48T27CBBxUR8CPjyqt
         YTO2ZGROBOqeGOjVIYdZRxji9cbfOZRTYYJ0w3eK0/DVOwHch8gN3aoU7ZhPRwon4ThR
         Kg8envgnE6hu3AOFmiHQFY5vCngghN60vjLBXWjWiQzAr7RpWOWTw9KBBvcZaPchqlAv
         CYsUfQroVtZMhsAqYnlenR6jIFXBhEG7G2tDPDa/vErJ6dvvOCGs+JU3QkqS3ZEOdX9R
         Bd/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784819487; x=1785424287;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IYpHP3NN7o6cY+8WOSgLS6195biQhMZQGaK4qqozNH4=;
        b=VLvg/E0kQLJ8pI+S0D9Oe/b/U51d8E6ZBQvuToiGbx8dkuOGeXId7db8RUl/1keHW4
         oO/WSrm0nxFvrB6WBowY2SZw3Vli+9EF/MFHC2iJwjcrvHoTaT7nMaWYHjQDGyIZ4aJK
         oHWjPHmtaJ07DyKZIRbBaeTDkIJfTjbu5e03ah0OmPS0E5CABn+PMmmZcwQ6YFUobgmW
         B4YdMEFQS/Zkb9icX/tMCFi4IcIp+QpuPlrjaWvsqfxSmB+ujWxAzTwAfSO1YNFcc6D1
         rkeut3EMPrL6Dx5lSwDcEDm6rRnHKd4JXCUj53URjW8K1WVmq55jt8Bp9WovycZp0j1w
         9X+w==
X-Forwarded-Encrypted: i=1; AHgh+RrFGYsg6hdLqygzb8NeM+JeURl8Wbne7iPoiEYXiRBHbsvap3oeNDpw79ljftBCk+B6ixmQo6E=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrOQajMifulqYBlNdBoeeMF/TVOcwk1KPewWaSDsGtShhh148B
	G7gyJWFfsM9bILrFgSOBkWyA57C2n37cDjO+Bj4QDa6KyxI5PSntMhGpju+Jx+pR6A==
X-Gm-Gg: AR+sD13zdR0NhDfKHX9SD5u/mzKA0Mg0oIa6fyo4GSvPx8ruBqY6+ytLIeWL2RLA5GH
	TlZ5pHNcbVplBc7SUYSRxHStTqH1QGjJG2t2osdij+fUom17Q7RE48rox6A0oIgbF+ximcFEAhR
	r/wUxUZAbWyRhgXRNU+87PrBzvKGublgIkMs1IqUUTJ020eAVq6RfWBSWYLYIUvvlpFvXE0EPRW
	Ekv2q0NaDSbttGPx4tSGxr9i8RWR8gJ4TQumt+gCy4j9XxllSZNpP3OnZjc6c9RSTlSd5fHXVZg
	GQ6RLl1/WGYdCFkOEmdTieyh0xEAYdnKhOllh+bPUFbstD7yl8XubZfdzCQgS8BDWy3KZjrMwFt
	B2sTQRRSY5OKZ3J/uyT9WP07x5ZFqyGlnVeuHmmMum5ooUILJTkG32OmOyxQxac/CI4Hn7wIqaG
	mQOk7fEOMW5uyaBVEC3rOz9O2m+2q7guWs8gL1cCzml1aaTA==
X-Received: by 2002:a05:600c:3b02:b0:495:4a34:16e3 with SMTP id 5b1f17b1804b1-49573c8d556mr34382785e9.1.1784819486164;
        Thu, 23 Jul 2026 08:11:26 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm17181563f8f.31.2026.07.23.08.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 08:11:25 -0700 (PDT)
Date: Thu, 23 Jul 2026 16:11:20 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com,
	qperret@google.com
Subject: Re: [PATCH v3 04/17] KVM: arm64: Add a heap allocator for the pKVM
 hyp
Message-ID: <amIvGH7UmZRUPmJT@google.com>
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-5-vdonnefort@google.com>
 <CA+EHjTwZftoD=D2G_1S271CPTdYhCcRwQGHYzwVS4OMLzAx-HA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTwZftoD=D2G_1S271CPTdYhCcRwQGHYzwVS4OMLzAx-HA@mail.gmail.com>

On Thu, Jul 23, 2026 at 02:19:00PM +0100, Fuad Tabba wrote:
> Hi Vincent,
> 
> On Mon, 20 Jul 2026 at 18:15, Vincent Donnefort <vdonnefort@google.com> wrote:
> 
> > +static unsigned long hyp_allocator_reclaimable(struct hyp_allocator *allocator)
> > +{
> > +       unsigned long reclaimable = 0;
> > +       struct chunk_hdr *chunk;
> > +
> > +       guard(hyp_spinlock)(&allocator->lock);
> > +
> > +       chunk = allocator->head;
> > +       while (chunk) {
> > +               reclaimable += hyp_allocator_chunk_reclaimable(allocator, chunk, NULL, NULL);
> > +               chunk = chunk_get_next(chunk);
> > +       }
> 
> Sashiko raised this, again, confusingly in a different patch.
> hyp_allocator_reclaimable() counts only the per-chunk reclaimable
> pages, but hyp_allocator_reclaim() drains allocator->mc first, so the
> memcache pages are reclaimable yet not counted here. When mc holds the
> only free pages and there are no reclaimable chunks, this returns 0,
> pkvm_shrinker_count() reports SHRINK_EMPTY, and scan() is never called
> to free them. Should you add allocator->mc.nr_pages to the total?

Yes of course, this should be added. We actually have it in the Android version.

> 
> Cheers,
> /fuad
