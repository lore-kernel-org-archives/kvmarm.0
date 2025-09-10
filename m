Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689B131A069
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 14:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757514075; cv=none; b=pOC8l3pfAwxvCK484DZtc4peCDdD2Xx0dKXXoa+ruGdR3CFpClIlSXmmqOPiKV/aEpdhTMhS0PJ9/TAMpxW4OgcM/LNXebMkgq/xpsqIsAtPI88WFQGgchsrV4ESPHWYqD+IFSXfsV34XACTckJUs8um4VhH8dmD1Fb1lAtUG5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757514075; c=relaxed/simple;
	bh=LNKhKhA6C3nXEhiScX2h3yeOP0cYoVecRbWOHC2eAUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VyYZxlPrpJSFKC2rqDNS0dqxd0dJFO8xUughoHn5iIwZ0fjD+iDCrtCdqSK+41OUrdACywIVrYH2qTIICaLDEJOFuF2buys2+A28c+h0poBo11P37QEP4ECsL/xKOrbg01lUDCxQGg2sONsXdbfoq0raE/1n+DbgaugiebDJiyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Rf2KQtZI; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Rf2KQtZI"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8126c6c3564so69897885a.0
        for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 07:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1757514072; x=1758118872; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LNKhKhA6C3nXEhiScX2h3yeOP0cYoVecRbWOHC2eAUU=;
        b=Rf2KQtZIcASJxmT9QJWSuBlQuA1sW1v39fIMOungMiMOjx0jKJJKMkU2KTI5sWATly
         VqBZcY68kTedJQQv4EO0/qR8RM4GWFeWmRA39T/mdoe7jGigUmd0verYlm9Db95tDDpM
         O+pRhY2b/NTDw3b+9vT6PN01s/WlXP1j8Efqp2ksTWy40d2aqPJvPdXVT2svoEmx0QGu
         xMuJTZN9+sPOae0Jnr/04bT7Xk0QHsR2Qf8WP0Czctz/erOIgxXvQCv4Q8jE/C3RatHu
         u9wT8Lpm/BLn1K1TWRjZhWOvn2yhvzKVJEffeH7K8c85lvDGDxw4D6OkB7OnQBWdoUua
         Ktkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757514072; x=1758118872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LNKhKhA6C3nXEhiScX2h3yeOP0cYoVecRbWOHC2eAUU=;
        b=r4qWjByQ2GCCRIqTnE5IjeKlmFOWmkZucztdNk4pTAMrXt7fXXjt+oYTtIsVd6ak2v
         6YBBirtrYAQvjsmKZWMREm9CHyqDfdU5LiBQAuL7+Y9fBx0dALF2+Z/irPDXEPGNSbbl
         YGsCnp0tVsu1jfGdu1NHs/G2zyjyB5bodkNyX/EQ1iu96U5kIyxO4h5zkZQPj59p0hDm
         V0YnVLEWLfUvGJcYu6QlH1yOsG9GhstCwZV9Qz+X27dF8rlSAwLdUMLVrdyKTVdQJfLi
         n8AM4p2FYC7BpBmmjpLU8rQRVG4J82MoDRG7pqVoKQbRPgc3jiypLLy2U4iFnYmkE5rF
         R28Q==
X-Forwarded-Encrypted: i=1; AJvYcCWG5+zl6um+dcUAMP0c7oKN8CR2DKfPNXF7h0iFAf2alWQwhPSmr/j9KmPjPspgftmEFahWr/8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyl1Naz1ddrFoGOe132b64ttIWSQt2bY1QFzPCY/9vPBsFGRAmj
	+Rv3H/Nxd96P6Fvp4dMkaV8aEGcVbUvDcC+Lx5SWT2DBEjYWMVUE504XxRDjZC5mfng=
X-Gm-Gg: ASbGncv9RIyeEhUWrC56132JGNK9jjiYBMsH+/psSuzGlEzVmFsFWWjflZE/p+9iomV
	zfr5pdmscoiPioUcK/dicxBljj+3zTzXar/mPGdi4FVJA088wWJOSy9VEYzo+4F5JcW1Rjb0GWd
	/5JaL7leCmcPFE0C+bRnSmwqvP8yWXRDhfQ4ScsM4MGW085Q+jpGGAEFCwHN9lBHA5rWHralq7s
	G+Q8gO37RBFgm9lPUqYF90LjlVKSOAhG5LIWAnxFp9fbi1azT8I27qAn1COWWmVcz2U8QaTuqeF
	e39q2+flOyEtr/sCGGCVnzmAUM6N/o3S51jF2Cl7h9gcYaXiEh3SSAbSGL5NX1Dk4CfjyzfLLk9
	Jw8Q4xzSRCdSkIEZJdWFJ8HxJTdEJBNUCuPxSkYpUj3f1BxcYq7KZg5Zic/RBvB2YoGf8
X-Google-Smtp-Source: AGHT+IFQUqXdlLFuZHw73Bg4VN3PcnM2gIuoqeeTT9gq8x5We6/aliAOx3fJNb9QKgrD/fgUoao2tw==
X-Received: by 2002:a05:620a:4054:b0:7f2:8bef:93c8 with SMTP id af79cd13be357-813c443dcbdmr1375146585a.40.1757514072083;
        Wed, 10 Sep 2025 07:21:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-81b5ed732f1sm299020385a.49.2025.09.10.07.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 07:21:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uwLh8-00000003roy-2q61;
	Wed, 10 Sep 2025 11:21:10 -0300
Date: Wed, 10 Sep 2025 11:21:10 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev,
	linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH v1 34/38] coco: guest: arm64: Validate mmio range
 found in the interface report
Message-ID: <20250910142110.GE882933@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-35-aneesh.kumar@kernel.org>
 <d57d12ce-78c6-4381-80eb-03e9e94f9903@nvidia.com>
 <c3291a06-1154-4c89-a77b-73e2a3ef61ee@nvidia.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3291a06-1154-4c89-a77b-73e2a3ef61ee@nvidia.com>

On Wed, Sep 10, 2025 at 08:47:43AM +0300, Arto Merilainen wrote:
> This creates a tricky problem given that RSI_VDEV_VALIDATE_MAPPING requires
> both the ipa_base and pa_base which should correspond to the same location.
> In above scenario, the PA of the first range would correspond to the BAR
> base whereas the second range would correspond to a location residing after
> the MSI-X table.

This seems like a defect in the RSI_VDEV_VALIDATE_MAPPING - it should
be able to consume the same format of data that the tdisp report emits
to validate it.

From a kernel side we also should be careful that the driver isn't
tricked into mapping MMIO that is not secure when it should
be. Presumably all the default io access functions should demand
secure memory in T=1 mode, and special ones like the MSI-X code would
have some special version to accept either?

Jason
