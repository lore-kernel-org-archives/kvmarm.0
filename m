Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8F12F9C38
	for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 12:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759235924; cv=none; b=o57wYh0MJp8YrHcucNki2GRsY649/9rd4it2sOL1fLZyFfZSmju4bTR4um6TQAAy4E1fHFdKVaaJiei2YDmCxOWGm87jlHWLVqmbwIJTqEcNifKPV+9A5LLV6R8U6TJ4k9rYAmNa+sKlKBQh/OqdfZhuPnr4SAh8Qkj8EclPsUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759235924; c=relaxed/simple;
	bh=xV29DIU2TbOmuryVDQ1P7PnHetrjWHc87hnpdn8mfxU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FjZeANbDmRNIa0H2nT+vRDL96Xhs0C0YPaAA/90XaOA9vpooex9THaggG6a5TDkvqiQ63Z+hszLrww3znPf1Ymx/uQcMkz3Ni08atlUrLoQaJxNthYmVpKzLXHMvIz7PxlorzGR8PjGrGhkO+JinPUVkKLWmjw8XtJ6sHdsNLjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=AhX2tddi; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="AhX2tddi"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4dfbab4fb0dso15889591cf.3
        for <kvmarm@lists.linux.dev>; Tue, 30 Sep 2025 05:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1759235921; x=1759840721; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VBYh4sqVRv985C07Huopg2HBOyHMdBgVTsPZLDQuV38=;
        b=AhX2tddi6iFLdishtUGVnFkXmVwz9mr5GyyqzFyse7/PueBvApYAB8cPlJet7fHH3h
         mu/+SzZfS4Hv9Vy3oaVOxu2BOFMqs27+T7FsVbNlyM3NYDt+wO5qIm+r7J2L7UyHWpg/
         i5FseoDyd47jevTS2mQw69RD9K4wSB6dNT3vhOg+i0C2IyTv9jM7PzIi3e+eg951N9Um
         4UsE+iziGhhcljWbYj5GUiXuUzvJNum1VYffaP0htRmRrGwRG5XHQXx2j2jg3Z7vLQ7A
         I37pKddwN59dsx4+tvphIs2cJFi/sL/yRbLfbpJhxPq6YPTQghnWW9FswGJxNwxBL8s8
         VlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759235921; x=1759840721;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VBYh4sqVRv985C07Huopg2HBOyHMdBgVTsPZLDQuV38=;
        b=P/ZcmQMlo5km4N5LMsF6JLdvX3HmP0ENf+fyMVC+8MxSTlfzirVaTfVjoxGmOd5w/A
         NKqubYSdxBAc7VcLtaE1qqWxo2BVRBvKuZs/ImXpjlnNMKR0/JD0xPMFBS9Ebe5kRsAw
         G0kdkS/dxBFpV4d7TcoZNjbSpbTh3T0KzfQBDTZyJ/aenrriGchXX9FCoIM+lUF4kA7r
         rpebUFaWQRcGgqVn/duueLtry6SzL4081eNrgK9UyK3X2Bjs5mOyo0a+EmSVSH4Dhp8R
         sHOSRTvRQ2G+B36B1ZFVxK/Z26kT2dR6jT2q3qfzaVMxbCdvrIuV3Hk7gsFY43Vye2z/
         6QZw==
X-Forwarded-Encrypted: i=1; AJvYcCWATnra8f/iK5piuHFFn3G4P2HnGox8CIpiRPr1EfWZ662RM3VBYOxjdIGN2NX7iJkWk7sAquU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzfb+/fnRcyvafqycLzjLXo8m80BaFJpJnMPHHiITpOVrJM1UEM
	bXLzVrlUEWlZLJl8MF391Geke6To9rq8YYvX6wSmSP+QKk0456SLEp4rAl2RR3lvSiE=
X-Gm-Gg: ASbGnctkUqbaxguWQGVCr2l1ecverRj+gQg0KCbKsPH4V/z3n9c9xOOfEugsqa/FUeM
	c3ZN0qZ5sd54nOegxR6ptW1Cv/e8v8gBIrDKQRH+uQneFnNFYr/hi2lIa+tCegL6adCUKFHJo3k
	pOvohEWAjI1krbCZovZ21gUwyQ+C7QBzhraLxEKRUZr4/llUeKrlTPQDP2tOGojf3x0CV+VQyzl
	Tw2D5fVknbq84PQ/0+7a/Mb+TOSi3YzR3EPvQY8wta9G7NGneG12SKKRB3kC9+R2X/sdiGiGb5k
	UyBHQ0RBqHWAppazKzYQ7PBS8EVJNlebJataLjZkfd1sFZlODDqW8VObYZFAFixApeje3AWWQ6W
	HFCEkPB9l6ZBE668wnnQ58NxFNf/X3ZSzqYCJC0DfIQ==
X-Google-Smtp-Source: AGHT+IHgKpbQVt29fnjPpYGRGvSeW5uUhJfqcsuhp73OzWARyNjA6lxGY/bFMFic1Y10TeqPQbcyEw==
X-Received: by 2002:ac8:5c88:0:b0:4b1:247f:4e0f with SMTP id d75a77b69052e-4da4cd41ec5mr281429761cf.57.1759235921370;
        Tue, 30 Sep 2025 05:38:41 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e34ef75712sm8696611cf.7.2025.09.30.05.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 05:38:40 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v3Zct-0000000CWSm-3Tg2;
	Tue, 30 Sep 2025 09:38:39 -0300
Date: Tue, 30 Sep 2025 09:38:39 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: Will Deacon <will@kernel.org>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v4 10/28] KVM: arm64: iommu: Shadow host stage-2 page
 table
Message-ID: <20250930123839.GL2695987@ziepe.ca>
References: <20250819215156.2494305-1-smostafa@google.com>
 <20250819215156.2494305-11-smostafa@google.com>
 <aMA8vz0v0Vn-02QP@willie-the-truck>
 <aMlzLsj5slPQhWEr@google.com>
 <aNamXlTErXDs1K8Z@willie-the-truck>
 <aNpm9odmzv__2RyA@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNpm9odmzv__2RyA@google.com>

On Mon, Sep 29, 2025 at 11:01:10AM +0000, Mostafa Saleh wrote:

> > If the SMMU is in stage-1 bypass, we still have the incoming memory
> > attributes from the transaction (modulo MTCFG which we shouldn't be
> > setting) and they should combine with the stage-2 attributes in roughly
> > the same way as the CPU, no?
> 
> Makes sense, we can remove that for now and map all stage-2 with
> IOMMU_CACHE. 

Robin was saying in another thread that the DMA API has to use
IOMMU_MMIO properly or it won't work.. I think what happens depends on
the SOC design.

Yes, the incoming attribute combines, but unlike the CPU which will
have per-page memory attributes in the S1, the DMA initiator will
almost always use the same memory attributes.

In other words, we cannot rely on the DMA initiator to indicate if the
underlying memory should be MMIO or CACHE like the CPU can.

I think you have to set CACHE/MMIO correctly here.

Jason
