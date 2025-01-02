Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B651B4257
	for <kvmarm@lists.linux.dev>; Thu,  2 Jan 2025 20:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735849115; cv=none; b=C0rzU6VHwx1V2jVJV/UrmuY4cyA2boAYP0y1/H7T3F80rQjDj73/LZyiBQSOyglrqjZzwjGsumAKwxfLpr1/yKP5XHoBFZ5OZ7jFQP2VgFWjvBF4YserMXdIqpIhN3PBF2C0VcvBvN8ODPxKHZtuNgRhwVgUyOyRcO/naSmQgRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735849115; c=relaxed/simple;
	bh=4e1IdUvGapScSUpgK7R6llp+8eAfEdh0yOfh5Obu5/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agJj0iTJGzLq9FLJ/eMiGoI52hTtflN3erBGtwHDoSXQXZY3BoosWLsbMaF77uOKtsmtn74CNTwQ6NF0PvztthHb4wXDTRQI//6nAkXGQ4gy2SiGg9d8yAPiHv58XtC22rjr0RSorth7aivW8qYKvG7/2tSjdFV6hLMALLy+O4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=kMPQDZLC; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="kMPQDZLC"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-46792996074so114953321cf.0
        for <kvmarm@lists.linux.dev>; Thu, 02 Jan 2025 12:18:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1735849112; x=1736453912; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4e1IdUvGapScSUpgK7R6llp+8eAfEdh0yOfh5Obu5/E=;
        b=kMPQDZLCKrLiEYmepXWxkJF7vuDJhl/aRjPxXnCQ98ey+3JCawZ0s9Dmk92qjFvAZk
         u9/kMBnMAGrTVs+jIfePMTFuvQlaw9Z2wwDAqkiXTIbDj/fi6H68OGyTy2nEJgY4d+Yw
         C8cEjDA5skbP5oLq8V3AUDXYPYLIxr1FkEq3WJBRTRZEsHtSVBU7yFphExGPQY/axkXH
         UfXDXQ97vQy3ogLbh8zzTz5y2aj9ur2EK0eJYfGJHiy9/BwU1CAU5m3pGrK+zs175N2V
         DY+rljaOQOpXZkTC7KPOrCB2pAP6kh512YIuQDj+Z43XcQ8oByAPpyf0utbYNn3bNcpd
         aiNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735849112; x=1736453912;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4e1IdUvGapScSUpgK7R6llp+8eAfEdh0yOfh5Obu5/E=;
        b=TJgClSsqOziMWd7Yq2rCmC8AWcAscj0HC3t3vKzcuBEZIr6rvwg3O4ItFMfdHmSVm9
         d0lqXrT7d2VI+3dXkrUyuFzngwPFokLiBKEp/b3zyoGv3dki8kRC8aQf24Q9MhTvwj/J
         jEMxJBLNcBy8KZg1n6mYkkQUbfgB/qo2HeDNDLG7LVTebttJ+cjZnvR57bGugeub66oF
         /iayqgvkuDPCss21B/hJ8i87nn4dcS0Eyw31Bxl4eyCQavrDf0h3n+rsUSit6O6lrrgj
         5wOAol8kpaN9tALh4ZT1jDQtneleNo3MKMxfMOyNX9AhsOQNfGDs9grRM/unCLqRg6/m
         w6/A==
X-Forwarded-Encrypted: i=1; AJvYcCWufCAyTI//dim0g8fD8EWeRd51h4L7IkKSMBwU+udZ9isbv2HoeXzAtCFOsf4FuM5mHp5RFQc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqaCkgKByZYBOZ8uHXe/fyZMCMPUNJDbkCyBihIswT46zF3Lz8
	Z9G07UMDKsVAeQd7x0UKc01z+QXpgirsywq5tCG9lqDs8S8C4Xw6gRXTp/scR8o=
X-Gm-Gg: ASbGncvbWwu2gbEgylT6T+X2AGro3iAidDHigHUoWCwIy9NHqpU2vcx+Gf2Z39GB8eG
	wrGx4NzXz0vgJp5aEIDPQrUkj7OTQWC+ptopqrojzjvMiY4wO4UViMaIfVZeK9uXpmSobnACAuz
	xghcc+CiZI+oVQ+ae7QdlwiqOqBFAYFB2+0R0H0esuevkuou6sQVHGYZlfkohtGg1/qxoFDMBee
	UHFkP+OJhYuoXVJJqq7EOrRth4OA+RkA+ORPALJElykGh2DZRc6DIcclB1u3pE9COCn6ByNgRCO
	kOufRRfU4sAG0+z4NoDXXOBqUULJwg==
X-Google-Smtp-Source: AGHT+IEubZlgbIa9gMEMKah3ttFKamsGoFQpk1RjIrpqZNlNGIW4EdOxYKL1s14UXV0ZPoQHIA67hQ==
X-Received: by 2002:ac8:5d02:0:b0:467:6461:e143 with SMTP id d75a77b69052e-46a4a8efe3bmr794078931cf.33.1735849112516;
        Thu, 02 Jan 2025 12:18:32 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46afc4597d3sm21460311cf.50.2025.01.02.12.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2025 12:18:31 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tTReJ-00000000MFl-10vf;
	Thu, 02 Jan 2025 16:18:31 -0400
Date: Thu, 2 Jan 2025 16:18:31 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	robdclark@gmail.com, joro@8bytes.org, jean-philippe@linaro.org,
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com,
	tabba@google.com, danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 55/58] drivers/iommu: Add deferred map_sg
 operations
Message-ID: <20250102201831.GB26854@ziepe.ca>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-56-smostafa@google.com>
 <ce4c8db4-4895-426b-8d9d-97dc5d74fbc4@arm.com>
 <Z2Qshft8lQjI-x7c@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z2Qshft8lQjI-x7c@google.com>

On Thu, Dec 19, 2024 at 02:24:05PM +0000, Mostafa Saleh wrote:
> I had a quick look now at s390, and it seems a bit different as they only
> notify the hypervisor about the iova range being changed, and don’t need
> to provide iova->paddr mapping which pKVM does.

Can you explain this statement some more. It seems strange to me, why
would the pkvm side, which has it's own page table, need to be be told
about the iova->paddr during range unmapping requests - and why would
the host/guest side have to unnecessarily store this information?

Jason
