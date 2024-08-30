Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0676B170822
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 12:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725022044; cv=none; b=uYuvq+FDvNxcygb0GCf3mSm3vOui9qgtyVO2jtnzgRNYoqZETJLF+pxZ8sklFbGlijoKRm/mZhk9Ksp/b/b775fnrWCbASd+D7e1jacd54/rBEFQcodAcIwfCj0Qm+8iEimWI9dk1W+NsTxlWV4GFHyeiH3XvKEU5BYip/3yG6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725022044; c=relaxed/simple;
	bh=lWiucSN6zXhG3X717OejSkyo1yUhj7w0KySk1SkYMIE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YCUpOxy17cbKCne/axpShm+KM4f6YjKaRYrSVwEktsJ5+bWMmd5gjVFiTUwh4JrouA+GYdLI/LrInEcJSmzDJa4+Zt1aRt17TTGopsU619I9ceJJyJ00sMR/ycRpiGTqsB19Obk0+MTC53912d+adfOA2UpoL5u84+2kRTyLxws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=F7pICdVa; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="F7pICdVa"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6bf9ddfc2dcso8448976d6.1
        for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 05:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1725022042; x=1725626842; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WmShJpOz/GOmUnd0xKeTBcV3P2NCGM0BHpjZiSl8WN0=;
        b=F7pICdVaGBkO+Hy4IFeIdRWj2tnu38rmAwgY3maHzPq0O+IGtgpOXnYslTGnUjsr5o
         sjbUpqB1DdNNkFYJdGf/RAxE8PsTjW3CljpZV5tT/4I7c6eQnZ/gcyGjY/TmmWFM2S6f
         64gIk7qMFqBd3KsR4Bqhb51AMwQfy2Y867m/AoerpuwHHoIkavSMwBnDSYHTfmfRwdb/
         c/xqu7iB4SetKUyNBB8N7N3T8rKTVntlfjDwF4Kcv9XE662pEFtZcLHRNayUjYNz1+Dw
         W8h1mq9/LT/QsHt9KK+eLjv0Pm6eUNQZj/p7na9qyCdiB4PZJ52g0f0flC5WKh7qSUuo
         SQlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725022042; x=1725626842;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WmShJpOz/GOmUnd0xKeTBcV3P2NCGM0BHpjZiSl8WN0=;
        b=RopC6wh/itmuZayw+3vVAYVOYF6suCgWZRfpEPeQxrnxH970KTKSBjSEObswxz4nya
         Vz52ymRByGfg7EcgfPYuUCFiJ9w0DSyhY7yzJeHgCCR1dMaJmekukNFe/hmN79AIlzwZ
         6F6B2ntM2ZBB7bSly1MNKOTZ8Fy3iuWg6yWpuFFA0hfneAC105wl4ffnHZeWSWNSYXt1
         KoRgZgY1c+7VDlvM1qnZCLkHwTrl1wC2rbkst3g+d9wcNGv+0eoPQdQ4PxjQV/HHRQ+2
         8pct+zvkN9QsOi89Q4QVwqjuwW3TZn3NNpU7ALv81i7/hhWH0MNXeD4/xk7poVVFCd9p
         ZPIw==
X-Forwarded-Encrypted: i=1; AJvYcCU/9P/ylBgwrOn6MPeNK7EAwNXhIJ9n8U4jZcMkbSW6C3LsWwvczSnirH3t4f/8qPvYvvlvgyk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFeyw7fbvBUpm8Zf6U50QWHomdFmLCT+e/5/Y3AtvXTawjFJJX
	SIc/qIqeIBBhdwKXEsN3/yrg/d3YRLBbX20FIRRfXSaha0MnMhoMQcQmU28EXck=
X-Google-Smtp-Source: AGHT+IF1zgT2NlSjbSBC4mUiCoFIEUsoyt95nAEze677a3G7gSdAzBNVY6enBBsIy8xyElYIQbGvzA==
X-Received: by 2002:a05:6214:3c8b:b0:6c1:70c8:ead6 with SMTP id 6a1803df08f44-6c33e69695bmr78641056d6.50.1725022041738;
        Fri, 30 Aug 2024 05:47:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6c34c04f512sm3869726d6.37.2024.08.30.05.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 05:47:21 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sk128-00DlJD-Gs;
	Fri, 30 Aug 2024 09:47:20 -0300
Date: Fri, 30 Aug 2024 09:47:20 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Christopherson <seanjc@google.com>
Cc: James Houghton <jthoughton@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	James Morse <james.morse@arm.com>, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>,
	Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 02/11] KVM: x86: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
Message-ID: <20240830124720.GX3468552@ziepe.ca>
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-3-jthoughton@google.com>
 <Zr_3Vohvzt0KmFiN@google.com>
 <CADrL8HWQqVm5VbNnR6iMEZF17+nuO_Y25m6uuScCBVSE_YCTdg@mail.gmail.com>
 <ZtFA79zreVt4GBri@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtFA79zreVt4GBri@google.com>

On Thu, Aug 29, 2024 at 08:47:59PM -0700, Sean Christopherson wrote:
> On Thu, Aug 29, 2024, James Houghton wrote:
> > On Fri, Aug 16, 2024 at 6:05 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > +static __always_inline bool kvm_tdp_mmu_handle_gfn_lockless(
> > > > +             struct kvm *kvm,
> > > > +             struct kvm_gfn_range *range,
> > > > +             tdp_handler_t handler)
> > >
> > > Please burn all the Google3 from your brain, and code ;-)
> > 
> > I indented this way to avoid going past the 80 character limit. I've
> > adjusted it to be more like the other functions in this file.
> > 
> > Perhaps I should put `static __always_inline bool` on its own line?
> 
> Noooo. Do not wrap before the function name.  Linus has a nice explanation/rant
> on this[1].

IMHO, run clang-format on your stuff and just be happy with 99% of
what it spits out. Saves *so much time* and usually arguing..

clang-format will occasionally decide to wrap in the GNU way, if it
can put the arguments all on one line. People will never agree on
small details of style, but it would be really nice if we can at least
agree not to nitpick clang-format's decisions :) :)

Jason
