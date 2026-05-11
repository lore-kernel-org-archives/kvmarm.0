Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B69A3FBEAA
	for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 14:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778509132; cv=none; b=as2HzGHPyi0ep30rygAfunCDdnEY/watGAFNpdeIUCi9evnfc57U/fj3r7iv8NZyE7HSyKh51ipxB78mkOPFpv+utzo8LzLiRGhkUzDMB0G9NhPP1vUpBD7SBsV1MyBU8TGagnoZTO83VfErv+FM7m/MFFAGLrebeH5wEPopurA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778509132; c=relaxed/simple;
	bh=35fAx2DRHYaIyZAtRTiPzerFcANm+T3Dutf9bONwTyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qs3JeICN7x3o4WmpHurLm4RxT+fZTz9rrFHKGSg7FPxn0oTwVYUZoLTuCQfbNJ2Hw+qWsJo/OVm4ZH5J8ce8qyDqsszS4rbSatn6urxN6q7X5yQGJovwocScRJagRBl3a0Y/yIOjEnp4GxpqeRAIH6Zyz7SyfEvjbFIujc3hjXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=I/0zOAm9; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="I/0zOAm9"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8b6dd874471so58063546d6.0
        for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 07:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1778509130; x=1779113930; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nhPDshriKOHBVRsVBlLjs1r/ABM7AzaFK2EEc21Hio4=;
        b=I/0zOAm9pnymIRaMwEzLqlx50E+2SKjV/eSB/cekgIn1VXb1gWYg182RDoCergjQG3
         kXI1MVaqhhOFr0kXZFHxG+Tt8pO23qUt6M3ViafO6BhRoRgxVnxBuh6bcspHKdOwzWEq
         eK/hgYfGK+kDZ856rzgDUYZod64nTOZxJrDkej/XQ00vz6IIZLJskqkWFEtA/BK8gbdx
         jk4c98tr5in2co5ymt/+yanpgKku+dWxjqVoYZqkYB67DKnl0hBwX5zCPp0I7FxDBXdu
         6IL+2a6BXZHLmSVqBcr3TxbbOcL3FDSPCGXpWedGE13vuGTY5oA+1K6p1zbqEXdewgmW
         DAqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778509130; x=1779113930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nhPDshriKOHBVRsVBlLjs1r/ABM7AzaFK2EEc21Hio4=;
        b=HpqLgzCdXQ9CsASFBa/7sAyYiUcDATbYFujr6TILpvUKTP2FxTzD1p+cEfIR31Yf04
         DiD7crsFk9yFaSdihCAMCF0NATP/K7tqX+ywLup9WIECUNZYN2HCSJVr67ovHVgIYTyQ
         oZzUZNDBSSDkjqy57BgtFx+m7HgzoOaNT7xqv6bng2br0cpUaXdSNgIK5eg18DpFhON2
         8EA8Q9meuC54Ion9oiM9eugzduoACYX6dJhNmcnOvakxTIgiQCT+QrLURdsjARDPHKc/
         ny6XfJRgUgQG91p3kv+QYtnx3yEK1dHgN5NTXc4/1P+VutzLV/rGoMgg+KDvUeOD08zG
         XZtQ==
X-Forwarded-Encrypted: i=1; AFNElJ/UHCjrx70r9HZ6qtpwEL64Qix4VLhiaULpWjY8WEn1orIu8P9UYihNu/uQytN8nArabgjzAqI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMtLl+OTnCXs7F4nFCjVGa+rLORtm35O+tUz32ORskgdJ96AHl
	4cdYLjjj5jsM8aCnNzyJKeAqQ2X+WciUGAHUun/lu+2VApZFh/NlU0ol+F3+o3Pz+dQ=
X-Gm-Gg: Acq92OE5Wx/CeuB80WTvqBDCTLhkW+m0WTKP3GQAb0bXqJUB+e3lv0AINO058rA9nwB
	AfkI1FK4al/qXm+17MRXpTFslDZ0aPJpdmDOnZ91sbfe5JiG5kj3uLECDpoqqxHtOFgKpTLiyff
	TKMUa/vE71ctJNLry9D8U8sLBrCInMw41OBQ/U2Tz0SWSwqA6yJtGPZeDI/UdjuAZsyM6yfFjXO
	58cmDfWliOkfEJ6tw1TX9xvKh6qytmCF0otvHQYvDZDxZfUNP2y+tnpZ1NIfjbI2aZz5tfYxmww
	MbG4HaN7T00A1/ZpbOXrgGgUA7RiXkYsATPYqT+JNJFwtrdgFqDngNZKousNLkoBjm7WB9fgpRD
	0xfEe0XAo1w1+HS5OPdcX6dqyUEY7Lpc131eobDM+B13OY8fD2dA/a4vfAFum8c5eDFjW4z14E4
	dbP0qZWBXBevieSUhd0p92+saErSkqstQNuFvafHBKPY5bEt6mnvoH5U1GYMnH1HoiMZf/sRYNY
	jo6P5+/bHN2hZfdUebSJgHFdH8=
X-Received: by 2002:a05:6214:4982:b0:8c0:1d4:4171 with SMTP id 6a1803df08f44-8c001d4430cmr177173846d6.19.1778509130231;
        Mon, 11 May 2026 07:18:50 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8bf3a71be9csm97495666d6.17.2026.05.11.07.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 07:18:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wMRT7-00000004oCe-06zM;
	Mon, 11 May 2026 11:18:49 -0300
Date: Mon, 11 May 2026 11:18:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 06/25] iommu/io-pgtable-arm: Rework to use the
 iommu-pages API
Message-ID: <20260511141849.GO9285@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-7-smostafa@google.com>
 <20260501122424.GA6912@ziepe.ca>
 <afiO2WL4ILGfmUui@google.com>
 <20260509232155.GH9285@ziepe.ca>
 <agG6n4CeuIMD57G1@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agG6n4CeuIMD57G1@google.com>

On Mon, May 11, 2026 at 11:16:47AM +0000, Mostafa Saleh wrote:
> > IDK, why? virt_to_phys() is part of the iommu-pages API, I'd just
> > leave it.. If you want to narrow it then #define it for pkvm when
> > compiling this file..
> 
> It is not going to be part of the iommu-pages API, I meant in
> io-pgtable-arm, we will use something arm_lpae_virt_to_phys()...
> which is then implemented differently for pkvm.

Again why? I think the main goal should be to not mess up the normal
code. 

  #define virt_to_phys pkvm_virt_to_phys

Does that, we should be leaning into this pattern I think, not adding
unnecessary churn...

If anything is needed then it should be an iommu_pages function to
wrapper virt_to_phys() for use by iommu_pages uses but I'd rather
not..

Jason
