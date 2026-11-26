Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795725309;
	b=GoHkIWIDM8czwm4W2tjYJqD9CJNyzAEUctgnBI/b0A2Z1Keltiqf4WXG/k+lOW/jxZOE
	 Dt/jq+zT/Ew/sCJHLeXzZoPWpjhECOCNSQJJFvwdU9FOK2srmNF99OEhYLIK4fQklCYRE
	 +BzMcKADT++XqQcB+IE19zAe984OqRROH7oBXGPRM2yGCmyBKMhw1zBRjWkQZn6uHnSgM
	 OVrgQpNUTV+FHetz+jltFE2beUgiO5TGsKrG3UW+/paCkzNo+1RANA5QxIadQmx6gEUEX
	 mzCxy9QsjUojvfbFYsub182Z6I/77U/HxCILDqXCgMEY1UGCqcDUfFo0Ak3GXgE+r3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795725309;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Xe0tRFQ6oz0C6PHY93xA0SxlfYSQl1kZj6MPIgpGjrU=;
	b=2oVXEmL/aCzJ24f59LG6i9o//+FrMWJ618E0CTwn3gioFuxD1x7Fz3DvofOD08QLyZob
	 PyljoJhrWFAhBBBwLbsh0mx4iNii4grTp1lkuYjtmlADsZ3Q2xy7ElP7++MNFR7KzXabD
	 hXXU9xsa/lMeozBLdw/sQefBlZf/8Q2duRPQnf9u8GPlwclEMyrebEzcGoA0Znvb4hHsf
	 odkMDbEHS4w9omFG1qs40vhtAG3UJnUS4DWStg8sXFrA+0rCq/ULivVXgmv3KLtlIf42S
	 cWaWXxZ7JdxYOOrv36+04RSQw2UlIKUnLGA8ePjDFASxU7TYbAUlafEhFQPK2YnqovQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mGijGKpQ;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FB4606A326
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 20:35:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6FB4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mGijGKpQ
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4bb69f5b161so48474805e9.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 12:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795725307; x=1796330107; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xe0tRFQ6oz0C6PHY93xA0SxlfYSQl1kZj6MPIgpGjrU=;
        b=mGijGKpQjeGxrvvrNh7KGG+hjhMhzVJFdTqVMfwOmHx0+6rdvzO6v/f5pMg1N9FeHJ
         PNijN60dtKTsiFopmDhZw1mZ6QIPLpZfNgTysmM+MtjYv3RJZ89zZVNIcIq2+q/mFdtz
         mHtkCpUfyXmX8PUmNA8Q9jHOgS7jKADZWrdUmtotfJkOCde1eTEicWpObyc0yfY1UzKO
         p1l/pSqSVzGAKygSR4CqZOeotNclfDmmL/7VYclrrIHTWYLwyxGXHR0Q92iZ2qd5/itu
         R6LDh5bYeK0V6uhcCbKv9/GtONS8cLJqMLWLhn0sJ8I/3/jrg1tPy+wGrQMHe19e9tr3
         Wi5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795725307; x=1796330107;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xe0tRFQ6oz0C6PHY93xA0SxlfYSQl1kZj6MPIgpGjrU=;
        b=StYRhzjpb1ddElK6/NLRIrP/Hty/vPPs/mAOQvdXx5izrhFOBLUAVctjjbeOj83Lzf
         jxOwDe0ggfNXSJJMZhf13D7yjPjAViorJ93q0cHXtyM+KPxvtsMHsh4siR7zURn0z/DX
         PyO7VDYe3JUbURVIAItmKjJx52ZC2JqXgahjQISa/2oxmU7Pxyoj7xNkGk3wX6Gb4Xfh
         DS0Z5rnizjbeAciapp9irvpthkM7on8hO4hNd2boU+awErzTOF+jAq8LEbmkiEXcFIyk
         MLaVmJ2yd/5osUo/iWKlKmjfPc2fScS9XAc6XuRn3/nUJRLQ5qoaXDWrc31manScQQ+R
         QU7A==
X-Forwarded-Encrypted: i=1; AL+hErEjPz0h/tanKEjloXyRu85GhpN42P5aQEnp/mUwPPbt2tu3BaIog9U+f1sMMzIxvhwxvOy4Pfg=@lists.linux.dev
X-Gm-Message-State: APuU4Z8ozKhIOJ5151dlRZW7U/kRkQiI188PObulFgb06iD+0QOY7Kdv
	pRpGed5uUtiOzyMW5GCQegcHVOZBIcfCnvLlHKLvrr9WX5+W7L8NTXTjc69q2LkZzg==
X-Gm-Gg: AZFdTZckerBBx7PKNYB/xF0doy+xCYZbv8sB8AccL+71sVsQa8Yj+xVn01fqVKGXfin
	xjU8G/XyLhpeEvMq6igt9+Dk/TmM0l+u4s630wqNtn67YfNaT8tykj9Kq72tIMF4GVc5UC6RGHN
	+myqQRQIvBC/+DTiGqdWEbwNFptjkIIzyz5ngvLiRAcnnywmTp1j9ui3Gw338im85+eR+upe2ix
	dHA4S4XjWQQB3CACTAfnQwPC53Jyi3Z4kkNQ4MmolyPxQJBdEvDQtNur9H+M2Th3kd9rLHnmoL0
	PZ4GkvTCFirwfwMJWpVNmDu1l95FrZUrApa7ffj+4/MA5WMrqYWP6u+ezrOmHCpR6ivcp435W+j
	7hKsLhxapDy2sNXE0sPaZL1JJpO6G47R8kSQFqM/ADI5FNnzy0HSIJ3lLxlhuqyKuvP1SSJM40u
	bWxYJYdLywt4z9MqrrvgkNZ4xsYi5aRWazT+JSNFUzEneSJHYp2yvl42hdB1br9davQPdVFR0bu
	y7iQJpOSztstqXLm02Ldw5YH+upwNMzjqOVuQvUtZ1JGozZqvz9be/2KvmLHTRoHCnwOpNkfRH7
	TjVLsGGfqkJtLS/b5gBsBXPHeWjbDa6M+8Eva0w/oE0GDsdsouvDcmEo1JfODt44Rj9AZ4TlXpD
	5aVRVUYXh+vrOTpyb9L7Wdw==
X-Received: by 2002:a05:600c:19d0:b0:4bb:ac6c:de67 with SMTP id 5b1f17b1804b1-4bbac6ce1aemr59511575e9.14.1795725306615;
        Thu, 26 Nov 2026 12:35:06 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb9066f6e6sm298463905e9.3.2026.11.26.12.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 12:35:06 -0800 (PST)
Date: Thu, 26 Nov 2026 20:35:01 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Will Deacon <will@kernel.org>
Cc: julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
	alexandru.elisei@arm.com, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool] arm64: THPs for systems with pages bigger than 4K
Message-ID: <awiX9cEDByf7d40x@google.com>
References: <20261019145949.1922019-1-vdonnefort@google.com>
 <awhZk3NrkqeGvQxC@willie-the-truck>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awhZk3NrkqeGvQxC@willie-the-truck>

On Thu, Nov 26, 2026 at 04:08:51PM +0000, Will Deacon wrote:
> On Mon, Oct 19, 2026 at 03:59:49PM +0100, Vincent Donnefort wrote:
> > The THP support imposes an alignment of the memslot userspace address to
> > the size of a THP (PMD_SIZE). To do so, kvmtool overallocates the RAM
> > size and aligns it. However it assumes PMD_SIZE is 2MiB, which is only
> > true on 4KiB page systems.
> > 
> > Use a huge-page size, based on the system page size. This value can be
> > massive for a 64KiB page system, so skip the alignment if we couldn't
> > even install one THP.
> > 
> > Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> > 
> > diff --git a/arm64/kvm.c b/arm64/kvm.c
> > index 36b3284e4a92..2c01dc32fa9a 100644
> > --- a/arm64/kvm.c
> > +++ b/arm64/kvm.c
> > @@ -18,6 +18,8 @@
> >  
> >  #include <asm/image.h>
> >  
> > +#define HUGEPAGE_SIZE (PAGE_SIZE * (PAGE_SIZE / 8UL))
> 
> Does this invoke sysconf() twice per invocation?
> 
> Will

It does. 

How about I use for PAGE_SIZE a memoized version of the existing
host_page_size() function?

kvm/util.h:

   unsigned long host_page_size(void);
   
   #define PAGE_SIZE host_page_size()


util.c:

  unsigned long host_page_size(void)
  {
  	static unsigned long page_size;

	if (!page_size)
		page_size = sysconf(_SC_PAGE_SIZE);

	return page_size;
  }

-- 
Vincent
