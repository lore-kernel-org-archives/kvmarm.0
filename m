Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251C12F363E
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 13:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760104768; cv=none; b=MdwSOQxvE6okz91rxrld+EUS6tbkoFMLC+pQafvLg16SjDayFi0Jp2Yap36pExQMuUYKIx9ZQmJ0Vt7DfXghsGQjl26FHLlGdermz1YCNrqV2F+MT74mrUoty7kq1+LDj4JFbsJssrDTiyMo5JQngJgH5qkzcQbzsOzwmpJBGR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760104768; c=relaxed/simple;
	bh=hZPZVS2QtrtI/5LeWNnPEpjPSsnogRA4qP9cGK1n1G4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tCwMQdEJuBi+bZWRj+TCu0aS9lNKvbOkJqvFf/aTAvwJHgrG5JFnG7wPpXFd7RhzZXatTS0k+JvUx+7Gl9lNtaT6FyqNVKXKp/t2nTaj2CGaGnf6oOG3FRv/l/lpXdwaCoCeIA+wWYLRcWSndDcQgv5ZBsOcRu0cfEQ8iSIzG9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=fzZAQ3Py; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="fzZAQ3Py"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-858183680b4so271560285a.2
        for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 06:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1760104765; x=1760709565; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VNvJ31G0uSRPH3SSYUmcqBJNw8nBZA0aR9UpQ5R7KAM=;
        b=fzZAQ3Py2bcUm9lYJvHwciv9/R4mEv57MOeJU8xSjk1ltDnKdJXPDNmWnYaz1Gct8t
         JYkZk26dhPFinb49VUjUOL5/0+W1UktkX1/W7yKVJiKeNx0SeQHnKHAnEHsAENdG7WnR
         +GZ4J8d/zC++yPa8E9QQYZ/eDh7I0aV4JlQHBTE5b/EE5fYN7+dEgZl1WJ1nxdjyqzNo
         fqe4+0SRgkOiHCIZ1qF/9GcfWNcJ7FR+mZkf3qEXLbnb5CyyHLgZzy4FE3VMeZ7Vnsiy
         +GCF+Yox+m/9RR0YoegkPPNbTNDapQVAVpFqBKtNn5a7osMUW9ZvffZBj2wSsuiQaZwG
         0P0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760104765; x=1760709565;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VNvJ31G0uSRPH3SSYUmcqBJNw8nBZA0aR9UpQ5R7KAM=;
        b=RDDgT6yzbVyXU8CL4LtQcGIJHC6tTbahOMaOBYMVBdayjF5sJG4TdoR9syrhQ3YDbb
         5IoaiZiZGoFDytM088BgKkjZ4vAQgWq6cSQef7JEyiE5WjVG8NYGLBWNNjig28cOIA7x
         krq5hlstux6liI7bUAZ3iOACvJpvVXPK8z6cH6fm+4svzN8/FIkL2XUa0iltpC7ID11z
         qzY2DX0fzjXegX25gvbOkSRyOLJnJQIA2UKt4Tvqv0DkWz5mQFWV0M5OrKjWtA6tFyhD
         0sLJDf9BaWFgNegVBfDoxPjBnArJxWu8NBFbsMQDyeolIV//VE7fXosm4peFJHK6v90E
         5teQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLCxMp/MG6RtJBELN6BIe/Y6Y4uAgdl2Uq2k56EfF8zNzKzfHjzl3SOLt48rzprqk6M7DL45k=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywwev1x4l3bEA+hBDFZHK8RaOZ+MxaC15is0B5l3LHqC63mHmzi
	EYLeSGslCpugnWGkNVaI/hnb6M5L6XNI5JhnL5cm858rjwDUEDSRJbszfunygkJVa40=
X-Gm-Gg: ASbGncv/SGNJ4e/x49d8lRn7VNAz/ZvJMuACQfJ3Gq/x0XxVvca1Tjyz3zzZ16wiKyN
	FbFp+rDr9wEGk1+c0lfce5t+gupOIe0N4iWWAbUkPxxN48QjEBx6OeV3VLSH4bi2+b2QaD8kn4g
	PDvNyrkbeUAqUA1RuleDGNE5UZZ8G/9Bz6rp4/w6s1P+WatLwYR82MJe6ih7bKr5pJwRLcp0Vcy
	Pbd3FHOIs534eSN81Dd2W/vTejBQ63OnrnJZ5sgQEFwepUGnaurJk9v/0LNsgmQs/5+kgtWRtA+
	LOoKPmvlGDg6y51mPFGwPM9RRihVdtcqq70Imr1bAXLYeA6nMIblubl6HAqkY6zA99HFsrSvHYF
	Z0qkVwj86D3V3WgL/pH248OEYGMmP5OEB+sAn1STE2OYr8WIiXhJUWIBctI9+0ovvNK+mQf1NwV
	60hLgLaDsqbFaMGn/KV3OmVw==
X-Google-Smtp-Source: AGHT+IExPwaL1TTGwP76ooAIbGqIBucYWqZgImMdJPw3egaQEtYFbCr/oHIOKZgGp1qijtOpyq8L8A==
X-Received: by 2002:a05:620a:414f:b0:86f:4009:dea6 with SMTP id af79cd13be357-883527c7719mr1533083385a.59.1760104764491;
        Fri, 10 Oct 2025 06:59:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a293bcbasm413337685a.58.2025.10.10.06.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 06:59:23 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v7DeU-0000000GVew-44jV;
	Fri, 10 Oct 2025 10:59:22 -0300
Date: Fri, 10 Oct 2025 10:59:22 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jeremy Linton <jeremy.linton@arm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, aik@amd.com, lukas@wunner.de,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 11/38] KVM: arm64: CCA: register host tsm platform
 device
Message-ID: <20251010135922.GC3833649@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-12-aneesh.kumar@kernel.org>
 <20250729181045.0000100b@huawei.com>
 <20250729231948.GJ26511@ziepe.ca>
 <yq5aqzxy9ij1.fsf@kernel.org>
 <20250730113827.000032b8@huawei.com>
 <20250730132333.00006fbf@huawei.com>
 <2025073035-bulginess-rematch-b92e@gregkh>
 <b3ec55da-822a-4098-b030-4d76825f358e@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3ec55da-822a-4098-b030-4d76825f358e@arm.com>

On Fri, Oct 10, 2025 at 07:10:58AM -0500, Jeremy Linton wrote:
> > Yes, use faux_device if you need/want a struct device to represent
> > something in the tree and it does NOT have any real platform resources
> > behind it.  That's explicitly what it was designed for.
> 
> Right, but this code is intended to trigger the kmod/userspace module
> loader.

Faux devices are not intended to be bound, it says so right on the label:

 * A "simple" faux bus that allows devices to be created and added
 * automatically to it.  This is to be used whenever you need to create a
 * device that is not associated with any "real" system resources, and do
 * not want to have to deal with a bus/driver binding logic.  It is
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^
 * intended to be very simple, with only a create and a destroy function
 * available.

auxiliary_device is quite similar to faux except it is intended to be
bound to drivers, supports module autoloading and so on.

What you have here is the platform firmware provides the ARM SMC
(Secure Monitor Call Calling Convention) interface which is a generic
function call multiplexer between the OS and ARM firmware.

Then we have things like the TSM subsystem that want to load a driver
to use calls over SMC if the underlying platform firmware supports the
RSI group of SMC APIs. You'd have a TSM subsystem driver that uses the
RSI call group over SMC that autobinds when the RSI call group is
detected when the SMC is first discovered.

So you could use auxiliary_device, you'd consider SMC itself to be the
shared HW block and all the auxiliary drivers are per-subsystem
aspects of that shared SMC interface. It is not a terrible fit for
what it was intended for at least.

Jason
