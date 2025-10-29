Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793AE34CFB9
	for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 17:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761758381; cv=none; b=k7bemVdVYMdflVJnYgAmFeI4T2aRCmIRYpJSQhwsVtQ6BsgdUt2QqrGJIdMm9sbjKunrR5+jEGK07iJQDkv57lpl+B8EDe4xc3W6RLps/JL0aKDerXC6+MplZAbNmU2TkzgZbNOd3VIuZg2vohsM3AxAqpZT+hwU4KQ7r7TKhlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761758381; c=relaxed/simple;
	bh=bSNd3wWUQQy2YBLmw8YBigmBKjZAe88REZ3E0Gos148=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DJFkacIIxlICQOFowsX5Sx90wnddrCoep79pidWkhraewkvvTYMdxXw5lfqpS+YYlJIdeDlgEyYhqzYzGOmOAiKyLCuwZ7pdd+Js33ndF+J1Kiry0S4eWTaJWP2pkcF+bVfaJ2dS8xN6ba+XUxlZ6wKhbRyiRRTlelJzEgFs1es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=hib+IaEm; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="hib+IaEm"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-89e93741814so7637785a.0
        for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 10:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761758378; x=1762363178; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bSNd3wWUQQy2YBLmw8YBigmBKjZAe88REZ3E0Gos148=;
        b=hib+IaEmI0n8nxZWdWACo30UWvmBDEOHshVqHVH2zczE4BObOXLFtiu29Bp8GjIqur
         xj6Plh/xeAay2qEgH2OLAhB8S5f19gqH9iN1I9ywtjpa6/PUtvKqr4+bvHqZNY2aWIkj
         jvpmU/+ac5P7xMrPw4q2XHZ6ADLYeQcWQIA1McxOJefyZZlFTaCJWWZqFEXNi9LFyL12
         mcbWysJbxHv+8PGK3vBhiYY0+C3dHeC6SOfdGugxNtZJcHKrKov2HREaHdpYlgCuEt5C
         A4odrkM8ae0AWQ+69N17nApt4PBX7kdC3Yy56+gil0QJbC4gFlWU7C50imP0Sd4BRPKg
         z4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761758378; x=1762363178;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bSNd3wWUQQy2YBLmw8YBigmBKjZAe88REZ3E0Gos148=;
        b=XMYJ6mkq6ySgOH66001v2G73/i0FMAvOEvajWeCG3n/HtXzQ1mCsjmDkXZ7ucLhP2r
         lzkryLlOwx/v/GyM6FpskeO7EnJqAdP+5tivDxBMIfdB5JbU6PEgEijQlrSCS44FYqts
         272MuhFG2zuRJWWaoJKNSKNclBAdoexqg9ueCqhXxO+ZWskw/O+kjMpNurzG6TqtsH2U
         SkCZF5+k3rkFA+cJn08t5FSRckFZo7XjyN2E7Yk77UO3QCAn0TLc56M4XK+uAsnnvRKR
         XSOflkAVX6fGS8ni1XS3chKoz9DTUgRcbqupk2oS8enhlgp7KCbtofSCgdsJEZjN5YlR
         Wi1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWqmpVUl3N4/b3W75NpgD1US/c+E7GIy3eUQ4gRp6junq+wDLtsU+Ltli7W5ZNJaiQ5MFQ62aw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAiryjZ0Z4GxGhN49mwQ66XuwBjTuDzCdC4oY2F36mBMlnQW3g
	kjwbeGejOW86J5oSen8aoq1UNVRMDxBJB3HNPDLvJjZWFsGEh9rpDpjeKPcFstbKaXU=
X-Gm-Gg: ASbGncuOlwhbp43WdPkUG8ecxVU/X5TWr20DSdHOb2iSX5uxFPRXr6iGOJv+dQXhxir
	Il9zcHzRdagi4c3hRaCMAHTm8ZnMh8on7WmShg/4hy6qsWSnmnVkZV9pX8szHIrNUEfRtyQu32k
	f4/8CyGOifCGu3zLM7cJw1cXfNoIK0gXsOTihRFgYTlvkzeXEaee4uv6IQvQokVJyjkTQqdvMQ2
	RIgODfYyN26fXHlmFVMJQQRhX0WTq/DPE8Et5cWSW+22aosI+MzRP+gf5lQcvgWm6AI2dZo3zw3
	XC4H/TqWx4sWmpiHQvND+8I0THJOWl7o31jbk4WR/cV2Lu+jbOrgWoiFl/U37hmue+cjXryYIsu
	cENM9ORTJR4dzI+9skzMPje06yDpSc1pZdyS/W7bhpFlocABFhanmOYN6ZnHELWlSUa87AnYnZV
	a+C7aAyu1C+Gb2fcADioUFt5P0Bl/al8V3mevv8hDJcQcuqAg5ajgnN5XX
X-Google-Smtp-Source: AGHT+IEE6XGe0cEoiRKL4NLOLkjviUWVkKq1s/Sgdt6ffSSTAqyCXCbcME2UvP5qWSwdJ9Al+rYJjg==
X-Received: by 2002:a05:620a:bcc:b0:8a4:6ac1:ae9 with SMTP id af79cd13be357-8a8e436110dmr482308385a.3.1761758378351;
        Wed, 29 Oct 2025 10:19:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f247fe594sm1089845885a.16.2025.10.29.10.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 10:19:37 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vE9pg-000000050Jg-2H4f;
	Wed, 29 Oct 2025 14:19:36 -0300
Date: Wed, 29 Oct 2025 14:19:36 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	dan.j.williams@intel.com, aik@amd.com, lukas@wunner.de,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH RESEND v2 12/12] coco: host: arm64: Register device
 public key with RMM
Message-ID: <20251029171936.GR760669@ziepe.ca>
References: <20251027095602.1154418-1-aneesh.kumar@kernel.org>
 <20251027095602.1154418-13-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027095602.1154418-13-aneesh.kumar@kernel.org>

On Mon, Oct 27, 2025 at 03:26:02PM +0530, Aneesh Kumar K.V (Arm) wrote:

> +DEFINE_FREE(free_page, unsigned long, if (_T) free_page(_T))

Please put these sorts of things in their proper headers

Jason
