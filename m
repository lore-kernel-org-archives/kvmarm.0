Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710700;
	b=vP5D0uROmWiGrbwlDzZ80dvhDkrhZ6iN3893AInJi0ziypYRitqvIuPoO8j3C8pp1aeo
	 TCXs5xwsOu0M90x3XK4nM5GDa7HOMoH9ArBFYZmXHjttfIE8DmDPJZamwtUQDmYtxFKr2
	 /v0NrMYDRlaY+2YCCdTBx3PeKkPZh16wlLicbeKvVapWf3kyAovGDD6B/tj5j/VhvC7Ov
	 LLr4sKRXQ6oG/l4xUakkUWzyYvYSjpe6GtxT6Ho5mt5DysZrUTcp9K0oCoLztKt6+oJ/5
	 uEwTAUsfwh3AN8mVlN2O8HGtuCRnhHW2nwUGkEHI0EAukoqXwV/yo8kWZRgQ562H3Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710700;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=mKMGXbvF/sfX9s9vl5jaq/5p/tKCIj66clg+e7onQEc=;
	b=L+YwcPVfvZhugJbq6XYAzO0bv4wPq5RETzKMZorkx4WJMtnIG9ddOsJv/v6ie9iNVXaR
	 NguepHe2yeL778sAR2CDk1xLnDQuMpBSmev2X3bo8Cgy93bGllAS+/QYajioqtE1fd/rI
	 7MtewhJjiVKJf4pwFEZ5b1BZLTAiZQBVHBGEjnbQQ9OYJAqQENLegtoUJkvkWVlQrCRPr
	 Lx8TA8ekt7ziqPOUsz3oT0vpUZGgGCmRsrQ/Ic8svT/NGKRtxS2LafOAFQlUMfffn3Rxh
	 BptqcmPCen+aS5V748bQq37pGpIxK/nqEg+A3jGjPKFQgON65IgukfltHMN0DVAkstA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=USPS9Ylb;
	arc=none smtp.remote-ip=74.125.224.43
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582F6606A321
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 16:31:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 582F6606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=USPS9Ylb
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-67db1f6f50eso7418212d50.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 08:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795710699; x=1796315499; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mKMGXbvF/sfX9s9vl5jaq/5p/tKCIj66clg+e7onQEc=;
        b=USPS9YlbJy5Ee1rwwfQWEP3Ve8SszpGtAS0zjskI9LSW4enHGz0fXGUdGEm+LK2972
         q5LEmzTswauSlTatatKd33PcPM9u4+158FxDRvHWjqXyxYoASoS6c6YPM4TnF9urJ9MT
         IgmM4Gx6HK1qbaace+7wbEhWbBvqwSlSxnTJ/VhiO+YuRflew2gVqOgI0AOLx5oHFA3P
         V9PfQ5ful+N5KDidIg9e490r6aQNC1G82sTszz84kN1NtqcivRgxNpkmynhWJh5GO0a3
         EiyKr0vW8w7uPEpUkoyVl8SOBLtSmxlEIxgA7DktcODzrb+DhrdQZ/UOwSfE2AoNrqVd
         veMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795710699; x=1796315499;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mKMGXbvF/sfX9s9vl5jaq/5p/tKCIj66clg+e7onQEc=;
        b=AFVoa+kM8fSkS9UsEyF7raNim6TcwZjIy/msIUMdCVTjDujIRerZ/Q6fwgqRpKCS8O
         Y+QINj/31TvY/Q1qhHEPe/qZ29obPVfD/GlW4oBU3BVQGVUyTXh7VR6I+toAVcBCRoXS
         BvffQM+QuZ8X6XXvgpy4mERhvynnosBf6x+TCN4U0+5q8F9OmcUQDMmWJpJJDeDIfk8X
         JfgZwqeeSNWFHXCNl0oG96/9Oekbd/tPvB1ewVn9G/1EzVhEEfxjtgbgotp0m9nPMwoI
         EmJZGfqx6NT673Xk2K18qldA5nKu7z76dK3aZmo92MLb3fRYywW4aK6UmjOEGCxC+mYu
         qJhw==
X-Forwarded-Encrypted: i=1; AL+hErEc3sp6ndp5mev0+o5nH1dTXlDkQlrOCjCvLatepJF4JjSgwU9foJvAI+9kL8zGNkk0Ei9DfG8=@lists.linux.dev
X-Gm-Message-State: APuU4Z9tlJ4JS3hGVnDKbaV2ZClWxRUM15f2x5j6cKY+CK8zdW2Xso/6
	oJXND+d+1HALrC+u++JPE3bfPja7+JP52uRyciRIbbq0CxkIYmXfX8fYVGYeeDo4L6s=
X-Gm-Gg: AZFdTZe2ayoChWrzk4n9rr/ugMJEEfWg2hWQ1WE12TpTcf73794Sazyeph4EoR5Ec0k
	gzWuPtI1QtLzcwg/9GSdqntJDVqYrXLoSu8ppk1GmvwTfW9eb5BIQeEn2lhKlz8x71/m8fBNT3L
	HZYEyvr3JJq3HPXuHYWppBATVOGFX//C60LAXmQpuW9Lon6ti0bkPV8oKXAs/t63Jpcq+oRrJer
	1VuLuV0t9vH5x/xzN6YG5hBzbV17y0w+ZzZkue/RIILIJZOQ1OQ0x0+Xm7jf+pZn9heF47gPoMh
	rSXfpSQE945CmQKMFA+jXNBixp9V4ZICDGqyAAL+Lkch9Gz6WPBqDrhRs1tg0K+gd/3W0XvrrpM
	jZjDJKqSm3fpKKR+DB6poiWV9D010jyAtmQ7g8T8VtltyHv4qKERz7e2kwgEkCYKY53vrGq09m1
	5FgEZZ9+WKDWE5DCKUlk3bsJQgQsWY9T4UOTdoZrcuRtukHzErmzD+/vCTvreeLFDo5ZYYF1AeM
	cxJIdwalHWW152bSJH9XP4hDLtWfCy+eu7rAIUsWHrg7eYlAOZJaWXCkHIH0zanMyccQz+EMcoj
	TYRCEg==
X-Received: by 2002:a05:690e:13cb:b0:66f:c1be:a64f with SMTP id 956f58d0204a3-67df4444c30mr10219064d50.65.1795710699306;
        Thu, 26 Nov 2026 08:31:39 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a15b99sm192865986d6.38.2026.11.26.08.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:31:38 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWcNl-00000004WQW-3ltS;
	Thu, 26 Nov 2026 12:31:37 -0400
Date: Thu, 26 Nov 2026 12:31:37 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian K?nig <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <20261126163137.GQ246011@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
 <yq5aa4mybbmv.fsf@kernel.org>
 <20261124134621.GI9566@ziepe.ca>
 <awhVoDXluqpncgcd@arm.com>
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
In-Reply-To: <awhVoDXluqpncgcd@arm.com>

On Thu, Nov 26, 2026 at 03:52:00PM +0000, Catalin Marinas wrote:
> On Tue, Nov 24, 2026 at 09:46:21AM -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 24, 2026 at 07:00:00PM +0530, Aneesh Kumar K.V wrote:
> > 
> > > Taking Jason's feedback into account, we could have the allocator
> > > request compound pages and recover the actual allocation order with
> > > compound_order(). That would avoid passing an order to free:
> > > 
> > > void *alloc_cc_shared_node(int nid, gfp_t gfp, unsigned int order);
> > > void *alloc_cc_shared(gfp_t gfp, unsigned int order);
> > > void free_cc_shared(void *addr);
> > 
> > It probably shouldn't be order here, that is hard to use. Just size_t
> > len
> > 
> > And round up internally
> 
> Minor point in favour of keeping the '_pages' naming and order is that
> it makes it more obvious what alignment is returned for code that needs
> it like the ITS. Otherwise we can just document it, I don't have a
> strong opinion either way (only that it's simpler than what was proposed
> earlier).

All our allocators return things aligned to their size, does ITS need
higher alignment than that?

Jason
