Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843CA3F20EB
	for <kvmarm@lists.linux.dev>; Wed,  6 May 2026 09:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778061187; cv=none; b=GArPPiyX0OanmL2w1ZbrvU3yQYtn+v1l84e+PhwS7tqYaHn/XKlVVJg9mPaLBRGgrxe/Ng/lGFgqoDz3Xa+ytGjkKAXaX6ZZwrNdOeOrj9RoQi/n6jOlYmEr2KraPdaGPJF4A2hE0h1kGUnU4qEt50C0qZixbeZdLpr4LVHl3z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778061187; c=relaxed/simple;
	bh=iy0/b1/iujcmeLTqUoVHzOR2Klz/M0/2Lh//DNx0Le0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+mvCiTg7nC9tjKsFCvMaC+Wi3NDoT65Q/5VWZvRYLeX410ChgJ539MmMEv8JQ97usYkWVbBFLsUYon/5PxFO388Rr9zSeqDrBLn4K22HQt/WGNHeLvgnv2jzapLOA3JA6NVd1ZR1+rhhd6TVwhKvm700knMhkzUIttQV/qbo6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Xh6ENKr2; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Xh6ENKr2"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso65476345e9.3
        for <kvmarm@lists.linux.dev>; Wed, 06 May 2026 02:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778061182; x=1778665982; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+7tvgQz0muvH8bYR5hJSB+XsuzIRTcHXfFlIskt4q6c=;
        b=Xh6ENKr2gs42we4Q4nWl/uH896rTudLAx45TVu3uy/JovouuhHGWT4ThfKFmHnukl6
         CDkpPjGuoI8nfaf8+9+sS3sAmgCqrxZcm6VOomgeZxUQSGR84gjJbrExdV/ovvMPz0fU
         EE2ITMEligdIPt+JBrVY75/dXV2/ib8g1rdPNd2Ga1EJ/N4X90ZzKkmygVfxVcSDP0Rk
         yKHisSOX8cDGYLnNtSemy8kHP4+heV1ng4DqBi7rnp5cJ+xhc5fCuL/03ZROFwnc7iBZ
         nx0Q1AAtht5LPz7A0KMXzziOU5w0LPdE3ki8G7yhaRNlg33WTGckXwI9/qPmA4rSQPmJ
         ok6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778061182; x=1778665982;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+7tvgQz0muvH8bYR5hJSB+XsuzIRTcHXfFlIskt4q6c=;
        b=NRc2jdSVG2GV4dzFRpzkgxAb2MDx5EuUbxx9WJq9Hig77nN69QrfyJzHeaySJEBEVE
         LxFlCHR596eSgKAs7qhdi6vpu7B/Fr/NxSxJi+VYK+1uS/Ua7d86fO/zH2DCjwOaGYGJ
         YciQ1g9uaL+HkPtcqjcaH8gTdEFhCE4pr+omKCEyhFeBw0At5AsYDLISUAOPdCFeeIW4
         V/ZUJU6EtTl4b8EGRKrD+Pb5Gwk2V7uE0hBccp1drnhYStP9n7Ss32ALpq6uj2J/gjxv
         Pd+N4Ly8Z+tZKiof4yY0Uagz8MXolkvaz4C/u+JkKGx2KBEKWV6fxbE0anou5x3+NP3R
         Wg2A==
X-Forwarded-Encrypted: i=1; AFNElJ9GqBlztkEkNuR16BwiqBVyKkN5wJbyMgVytGLjbSGgyli7lhGw1vT7x1A+V9HLDJsV/G9JPIE=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYgWTNZVcJaYq1JnyZ03PEKHReY9/pBEkdzfF40EgAN8K6Fdi2
	0Os1DbToshC7Qs4vHCfnlfw/tvR9gbJojK8R+Awc08M7uptKn2rj3kkFo6IblPtkM7A=
X-Gm-Gg: AeBDies+aoAXztpc0SFtk0ylyigC9SwEOrVeIlbuMpeTnqO3YmPJ9DEzZ2rcRY2p7vI
	SbFlBcuMCMIYVOuk6s5BZ/QrwYgze6rVy0KZtkKhTtdxcv29vXa+9M1N5/Iz0mzTZpVSqnL1s2V
	+NpbpOVMu2K230RJvhN1i8DWtRPJJcOi6EErzAMX0r2SZS4G2JvjfvHJ8Ort4x7uZf1MU85IHN5
	YUXotaSIeQ1qzPzzhudnQUdpzQsL+DEt15+3u5rYHRQVYEc0FryCmoB+oUpYVZWEpR154d2hX/+
	xHpMqPsAGQw6dF79SsvqzyZqjRcNprrAVAi0X0zFa3N79dWUif2i2hDlDTmREOVJXhJSeEyNvI8
	+b8bVaiVEU589gHPlCCu9io8ZlsXsKVpFfIt7nAZUPg4zTY1a5yctyvuiobHysFtPEb8LIYECLL
	HfVKyTFq2ecIujL2ckNQ==
X-Received: by 2002:a05:600c:b8a:b0:48a:5574:3a48 with SMTP id 5b1f17b1804b1-48e51f32bf7mr46777065e9.16.1778061182206;
        Wed, 06 May 2026 02:53:02 -0700 (PDT)
Received: from ziepe.ca ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e538ca8c0sm33324735e9.13.2026.05.06.02.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 02:53:01 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1wKYw8-0001fR-Fw;
	Wed, 06 May 2026 06:53:00 -0300
Date: Wed, 6 May 2026 06:53:00 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 04/25] iommu/arm-smmu-v3: Move TLB range invalidation
 into common code
Message-ID: <afsPfEzgGtAFrN5P@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-5-smostafa@google.com>
 <20260501124143.GB6912@ziepe.ca>
 <afiN1UwS9q6F6A_v@google.com>
 <afoYBYIJOTClsdLS@ziepe.ca>
 <afoeIVIGE-JjYy22@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afoeIVIGE-JjYy22@google.com>

On Tue, May 05, 2026 at 04:43:13PM +0000, Mostafa Saleh wrote:
> On Tue, May 05, 2026 at 01:17:09PM -0300, Jason Gunthorpe wrote:
> > On Mon, May 04, 2026 at 12:15:17PM +0000, Mostafa Saleh wrote:
> > 
> > > I am not sure if it’s worth it, the hypervisor is much simpler, there
> > > is a single page table, it’s locked (also identity mapped), it’s
> > > updated on VM boot/teardown only, we don’t even use iotlb_gather at
> > > the moment, although possible but I wanted to keep this series as
> > > simple as I can then we can add more features later.
> > > So this patch is the least intrusive change, as whatever the main SMMUv3
> > > driver does, the range tlb invalidation logic is the same.
> > > But I am happy to experiment with that when posted.
> > 
> > Okay, then maybe just always push a full invalidation?
> 
> Like full address space invalidation? that will not be optimal and
> will affect every device on the system, why would we do that if we
> know the address?

Not every device, just wipe the VMID. If you say it is rare then keep
it simple. If you need to be narrow then use the proper infastructure
with a gather. No reason to make something boutique for pkvm here.

Jason
