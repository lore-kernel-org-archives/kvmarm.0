Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0F213664B
	for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 22:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719268539; cv=none; b=DBGqAzDb1Oc1ZbYdfuFCByuqWIoyoMSjR8x29FD+GVP99FzGIdTa7ONClYOA430owITAf7+7Wuppqg0HlUMGMxExww8pUVA1PBTa9WJffmtTudk7bCJK7B+9lK3zmmVUZYJ1e3hUpxb6H6/44WJ6jJ+tZG9tKNVLMNnR86M3SYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719268539; c=relaxed/simple;
	bh=aT2qy8ye9kgiry9WC4F+sGOsviYcZPjeN5uNOxlkGfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hSARaLnM6I2+i1rGZhuROgTdkFi4H98YsctWDsTod75yc0A3UndTscJg4uCLON3HaDyBbaK/F7DuFoBEATEDKGsVtCa9XUhjYG0qp4Ix3tIfw9wmguwmiwmehSe8v/K9MjYW2oXoDVmrJPESRfDK+Kw9cp9KPuxnuAncxQs2Wqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=YiJXStyA; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="YiJXStyA"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7954dcf3158so268186985a.3
        for <kvmarm@lists.linux.dev>; Mon, 24 Jun 2024 15:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1719268536; x=1719873336; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MtTp+BqiuzS7EIIVZNGGCWhCGJWEUGz0/p9POpsvwrQ=;
        b=YiJXStyAyiwdbYhVRmEEeZVq3fw2jh5ZkLSVe8AfWvZDWeOFXUap5W99GBIlyryO4R
         wGfQuKvZHQkt/aef1LIxPn+GJPpw08JZr0XnWSR0TrTzdeeNDk+us8apu7718ut9qp32
         y4aW8RZH2HKnII4XBKyYIUeZ6aND0rdHVjspjMV0J7WsoYEMqgJGdIRP+Uck2FSh/50M
         qlQlAx2pmsKZMweyzKj9O71RV/G930XA2LNzSDP/qM8Fj/IM2jsAjbj6d0Seh4zY2fY6
         dZlLGemMylGS6STbasxt0/1G/NfNdd22f/YCjzoHshAe5ZsJN5VA7emDQHcMShPw1kcz
         qhZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719268536; x=1719873336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MtTp+BqiuzS7EIIVZNGGCWhCGJWEUGz0/p9POpsvwrQ=;
        b=CNYeaz0SWWTRMYlcqgJYyc/2sO+KDSTFugqbECpC4Lgoz1yBKDpy3fRhDwimUT+fLl
         C9OqY2xy4RGp4K1cjQIvZdcpS+2J7kywY8nsAdNgCzsHlqTPlZ52p3i52SaBvtgV9tEt
         /DhQPUiTOX1+HTHxyi+0WZjSo91ZwJYd8xMSbuXcZ4aot4J/tBu9lKtA4qKwqj1OIoLG
         SKlu9LLPJdRZMF2TkAjlMSNagL2C+yD5/hSGG9rJDG5HD/z94LJhbSGDR3IliuFMVSZ8
         fahh82kYt5TcBMTJ9xxQDlhhiIiM3Dc5aqRTRxX7IwWgGsU0cScGdAMf0je3HYdMlxHJ
         NsgA==
X-Forwarded-Encrypted: i=1; AJvYcCWFCChlwC0AjjzoF/PHd49b0aPRpT1AjQOssdodb7/QDSUNppU84WzDogwZzW/uZAvTozfkWDWsiHCjR+Sh+BgvK/dqJpir
X-Gm-Message-State: AOJu0YwezD/21WJk2vD1SSBIUzddcQzS6D+T20j/MtbQ198Y1pUDsUfp
	nGbDvS+aO8gXynWDY7OYITsXwrRqbk1CQmyprxqj0ysgULPy53tXh2r4KqoNop8=
X-Google-Smtp-Source: AGHT+IEt1C3MFNaCsLFJB/VCC9aFQBtXdDV0dColoFeVqztX4eRvEXQuqixZ/9chLmqAWqi9C18PTw==
X-Received: by 2002:a0c:f8c4:0:b0:6b0:7f83:adad with SMTP id 6a1803df08f44-6b56d379671mr2817056d6.39.1719268536573;
        Mon, 24 Jun 2024 15:35:36 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b5255f441csm33785236d6.113.2024.06.24.15.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 15:35:35 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1sLsHf-007WFC-Cq;
	Mon, 24 Jun 2024 19:35:35 -0300
Date: Mon, 24 Jun 2024 19:35:35 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
	kevin.tian@intel.com, alex.williamson@redhat.com, maz@kernel.org,
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
	jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Message-ID: <20240624223535.GA1781035@ziepe.ca>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>
 <20240208154210.GP31743@ziepe.ca>
 <ZnmkbOfWBJHrO2sx@google.com>
 <20240624170747.GA1515249@ziepe.ca>
 <Znmy3QPAUIX9SnGx@google.com>
 <20240624180148.GV791043@ziepe.ca>
 <ZnnFML-P1dzHdraI@linux.dev>
 <ZnnJA3ueCXsDtyB7@google.com>
 <ZnnORmCHrEI0KkGz@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnnORmCHrEI0KkGz@linux.dev>

On Mon, Jun 24, 2024 at 12:51:34PM -0700, Oliver Upton wrote:

> Having the SMMU participate in broadcast TLB maintenance means TLBI
> instructions on the CPU invalidate translations in the SMMU, which is
> useful for SVA usecases. However, if the host is using different VMIDs
> for the CPU and SMMU, then guest TLBIs no longer match the guest's SMMU
> context...
> 
> Pinning / sharing the VMID between CPU and SMMU is a hard requirement if
> you advertise BTM support to the guest.

Yes, and the extra detail that the SMMU *must* always have a unique
VMID for the specific VM, we can't leave it in a state without one.

Meaning there is little purpose to changing the VMID at runtime as you
can't multiplex more VM's than you have IDs once the SMMU is using it
anyhow.

Jason
