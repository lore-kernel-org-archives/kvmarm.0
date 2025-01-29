Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2C11DE2AA
	for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 14:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738159731; cv=none; b=tVUVlQrxcttXR9PafzOGkG6s67iBHuOCkhp2w5lNMgfWegLhKCSC17qqS1VK0EVxwuJpqaANgx9+iG209B/KIHg4Wuw/4GlLWEi+zm0FQuzVp/kJIhSvj0vWSJU6xjIqryXQQAdKH2bkze76IXGOE/eR+Wz7a5MMlkWLUvXqRSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738159731; c=relaxed/simple;
	bh=gT2PZen3KYaZzX/+EwPdZUZa3eaq/QOFJ2UlB6rCuFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YfTyeBembEyGa1AgdB2Z2NJPaGA/aBvMurmfzIT33VdELNGH0sRuGITaA1ntTRUKqssaS81oZp78jq7VdyKifoMyZBBzxCt/GAwIfvYsZi1dY57yp2UphS3Pg6GXWx/BXSTGxh8R7x2EGNRPmjbPO87IVHha6nogOGJcU6w/e0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FiTDhk5i; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FiTDhk5i"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4368a290e0dso114275e9.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 06:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738159728; x=1738764528; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mwnygbMsmdCq2LJyfsumivo8IAZG4XDnKYNgemYLbF4=;
        b=FiTDhk5iWHSPcPYYcKmgiLu2+hOGNtHavKNxZhBEOy9XNQlTKFQNWk7pD2mVt1exXC
         oKx/PkXRVvaEHYYZjGrVb3zCLZ8iQHxekfqu21/QBN55CpV8/LU/HEFvT9UrXmMWUq6V
         HUqtOMNCfCGwuspAN46CbJCY08JDRiHq1fYPELCmTiKm6GbWFA8uPGbiipKPVGCKs6E6
         WCEVo4A4esH6tHN9X9N75m2qcxGEtepMHHHGItNMHG2NJXV2wljlkiriQZOjNpt8Ia7E
         PX23ZZE6qJcu0rwYST/BMWvo3P6csrMIC/7w2OLzlVg1vt+XCrc30Cffr1qtTjNi0+pr
         y4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738159728; x=1738764528;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mwnygbMsmdCq2LJyfsumivo8IAZG4XDnKYNgemYLbF4=;
        b=xGezGWmZSEYIL8vFfrptY2HQY2+T6Z1HynJDQH4U/Vh3C55u4hjJlhozqE4oYNbz0L
         VJ/4UWG4iTyhP+etrTNGv/2d9dBr8nc8cyWR+VY07t+qMB1mZtorztbsgPr28Y2cae2e
         4yXA5rXXCgJNAjXJ/KKHIyeTKQDienQkui6CJyHmn2pRuwbSqxnmfGV57MclobjgwjRy
         NNp/eYlbdQINu4SbCmSUFkDLX9trxZ395jQPpZAyZBYG3naz/yXnUIymGJGrFIQ2kLIe
         4j0+B5BooGf9IDPwlpVuGPDwQ+ODrHBARnVsiVWe74XrxqQgoOaM2hOp+h8lBvmORt3y
         YuhQ==
X-Forwarded-Encrypted: i=1; AJvYcCWzgGMOU9O078oQjcUfXO9+oFYwXl2JifzshiWfsX0VzLmoNVXbIB2lHHDUnS1ZDH7rOyAJ4QM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy6nv5MOGH49Ch7onLWg4Qkq/R3kIZ4GjtbIXEpmxrlkIKYZX5Q
	IAneIYw744GSL7Tjur/FG3A5/xbH/S2+DuIXmyLoVem3dEvxP44yYIA6/kVRbA==
X-Gm-Gg: ASbGncv4s12ofFEwBUavRGGkSBBWqY6YSb0RKgVwZa02IyWm8IXi3MtUmdQipx+Ih3C
	2PbAP/+eNBy6Lv3OXWeEugxFS74yIAGbkn8PlZd3C3QxAQ3qN4dQajnzrmh135ytSDAmPhYBQfi
	KquFDRaUOKeb33ZIZiiVEJlo7GrvoDUCiGb4SwmllJKdFmVYL6CGjSbNby5nYGHw/5lpG5LaLFY
	kmF6Hx5lHEnvPNr4bmDcZJnqlyPoHwIRzZLrazBWUBOHRfKKibpfflM7Ja7c57DxT8fkXXkfvPT
	ryrE72OFHw2MHBDkY9vTa0aoL4qMmwb0S396j9mbGi/dqjko9Fc=
X-Google-Smtp-Source: AGHT+IEBmc8wE9vCyM9jLK6IJcRV2lIxnHwIYu6bH9hjFBBeHTH+WuqVZsZJrlcZA0Sb+Jn5z82GDQ==
X-Received: by 2002:a05:600c:3585:b0:434:9d0b:bd7c with SMTP id 5b1f17b1804b1-438dcbf4e2fmr913185e9.3.1738159727917;
        Wed, 29 Jan 2025 06:08:47 -0800 (PST)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc6de2dsm24352725e9.26.2025.01.29.06.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 06:08:47 -0800 (PST)
Date: Wed, 29 Jan 2025 14:08:43 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"robdclark@gmail.com" <robdclark@gmail.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"jean-philippe@linaro.org" <jean-philippe@linaro.org>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"vdonnefort@google.com" <vdonnefort@google.com>,
	"qperret@google.com" <qperret@google.com>,
	"tabba@google.com" <tabba@google.com>,
	"danielmentz@google.com" <danielmentz@google.com>,
	"tzukui@google.com" <tzukui@google.com>
Subject: Re: [RFC PATCH v2 00/58] KVM: Arm SMMUv3 driver for pKVM
Message-ID: <Z5o2a-RSiWqQOISc@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca>
 <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca>
 <Z35rEeSVwfZVA9IF@google.com>
 <BN9PR11MB52760686ABB3145E44BAD95A8C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z5DWag7ZKCPl1Eje@google.com>
 <BN9PR11MB5276B783D518DB354BF58A3C8CE02@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z5odLXPZPAwu4oqe@google.com>
 <20250129135053.GB2120662@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250129135053.GB2120662@ziepe.ca>

On Wed, Jan 29, 2025 at 09:50:53AM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 29, 2025 at 12:21:01PM +0000, Mostafa Saleh wrote:
> > levels) and can’t be separated from the kernel as that defeats the
> > point of KVM, that means that all hypercalls have to be stable ABI,
> > same for the shared data, shared structs, types...
> 
> Sorry, just trying to understand this sentance, today pkvm has no
> stable ABI right? That is the whole point of building it into the
> kernel?

Yes.

> 
> Things like the CC world are creating stable ABIs for their pkvm like
> environments because they are not built into the kernel? And thus they
> take the pain of that?

Yes, my point is, we can't just separate pKVM as Kevin was mentioning as
they has no ABI and it is tightly coupled with the kernel.


Thanks,
Mostafa

> 
> Jason
