Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47793149C4D
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 23:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753830996; cv=none; b=hpBRjwouFhYIVz3MFbTArTA2Bw7JRWrhS1TbLuWp6WNfuzLTCzNOSiObIXucLZjY18Sql5J0olvQy7GbYnehwhJq1c3PckqVD8HvgvPuUbF93fBjwq40zB+ak+AcvUmOTs9kCYLBgYm4FSuk0ppOrmpTvP3NpKo0+qnwLGEVql0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753830996; c=relaxed/simple;
	bh=bq2RlWHsFjj3W7R7JIUlOjH7x9ItqrAb031ifSmshcc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Va6y+/7vX0fd5up8aXlg6mA0mqgQShRK8d1jrw/pRlxtZLereXu8KDbqv+fHOgVopHxfmweN9FMdf9iSOULQVXL2vpshh6OUL33UG+rp4NoUYUu0g+8tw8fXRHCIwvGt2ZCFZqmv6sJpTbSfYoLjEsSSeRozeK6lfNGfptFQgC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=IqLs4uwr; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="IqLs4uwr"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ab9ba884c6so5225111cf.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 16:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753830992; x=1754435792; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8wQLLnlIOT2tj87satzYfNp/smzLn3IXRBaMhgwLr/E=;
        b=IqLs4uwrpMIEvDL+gxlCeRy0B7JMz2yapAtefYX+QlioHP0NVktmDjZbBm/kerE/8c
         +40J51DZ34/F49NYqYxCqjR9yUaMEUbYo+yBEzGb+FdEA+wv3oARZE/Sa5V9YY6Wb/Ib
         596lhmjBcYvOSgSe7y3Rg350z4PcVKAET2CkgS9A0Id9ezGPSLJrDlWCXx1dOezZLRyc
         lPh0aLZkcnaaPuNNZ6DgfDlJV3yBZOWUVA5p+NwIn4sT/agSrC65RK1/PKwQC0sWAvkl
         IvxWEpy6MSSswTF44+tgkKWsJszYfR7IFsZLGFhJix81PznfKCOxyjT3VucbpWLGTRI8
         4txw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753830992; x=1754435792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8wQLLnlIOT2tj87satzYfNp/smzLn3IXRBaMhgwLr/E=;
        b=NEaXSocMgIgTyajbh9GatZ8aCd4hB07HeV3l7wqn0dplgpU/PKnpvlPa/kUEyfwJ1C
         qPV/xbPQ2xECIliwSRbGxQKw070nAGpQjMFmdm7z5KFGXpSo9G4aPv9poCaJDJm/qcTL
         m5MSGitQNjrcaXFcxT2/W7y3SKAhzaSX94+WmJaDCrmgApJ67+MbsXsDbzFJSiEnBFVn
         Nr60zqv706ybFq3RXG+/TPXutzaIYnK9ACCNAuKTt8bqrDHkrcFU6b6w2Bx6BFDhwq+w
         l83pNfeQo7eJbrWz1J5xhrLvQCxmltNxgLOROHc+M9QZZCU88DqJZZ9GVttTIz1alnOF
         wEEg==
X-Forwarded-Encrypted: i=1; AJvYcCUVslVPi9xXpvT6buYu4O7jy6QJB1sAUty8mmqdh2ZL24tHDt6kalCPjbHDJVgvPlwN+CyvGA8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOJUEqHmXp/IUH45T/2+w0H0qwKqrW+no1w2LQPd815Qv11Juq
	qMv/poaAnK96REDfz/wLCL4ab6vOmZ2BQpAsFyNkFhu20on7f3fgVEaIEzlmHe2oH6KLdwu/s2h
	ipcAC
X-Gm-Gg: ASbGncuU1enRA3Byx2k3fOnVCgJjQctg9J57U8upHq7HCsGiGsEV+FhK3H9dBSHgOTX
	LYZXcICW2+qCpsU03VAG5qzeIYdNX0fVkgpfUDth/GZW0z+EQ1y+Aa81cdqoll18QxnpEI0l3uu
	jVoF9TeeOZk+RHIocU0A5PPekGa3mMvqbRfUV+MxaYqJD+rEt5AJkuCh+n3PpFWK4rdQsOgDu3E
	76vq6hEX908kdPlEXCkckPq2mGY3DG/Fqo1gua2pTxoAIRl6A+33QVKhPIwP5bgcgaLMzaI8V8W
	bPm5gVVegjc9NUIGLDThg2Z4d043jVoy2hvZXk6RKb2mL7o9T/C9NumIlwVJawJ/4dhFWNa5EpU
	K6qoCKTf4W0WA9IxJCac+jJd8Vq8cVQ9MQn8LDNbmqLkAq7s/cayx+6JszXlg90d1GlRR
X-Google-Smtp-Source: AGHT+IEwE6N4arL2Nfp7kwi5xzmxE5rT1vejHQ7TsbwA2ZmSnSBM/dGl+o0EjInQ6KuJFac70KrvZQ==
X-Received: by 2002:ac8:5846:0:b0:4ab:552a:fac9 with SMTP id d75a77b69052e-4aedc4361f2mr22773811cf.10.1753830992101;
        Tue, 29 Jul 2025 16:16:32 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ae9963b732sm55042891cf.39.2025.07.29.16.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 16:16:31 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ugtYd-00000000Meu-02WY;
	Tue, 29 Jul 2025 20:16:31 -0300
Date: Tue, 29 Jul 2025 20:16:30 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 07/38] iommufd/viommu: Add support to associate
 viommu with kvm instance
Message-ID: <20250729231630.GI26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-8-aneesh.kumar@kernel.org>
 <20250729172621.00006344@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729172621.00006344@huawei.com>

On Tue, Jul 29, 2025 at 05:26:21PM +0100, Jonathan Cameron wrote:
> On Mon, 28 Jul 2025 19:21:44 +0530
> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
> 
> > The associated kvm instance will be used in later patch by iommufd to
> > bind a tdi to kvm.
> > 
> > Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> > ---
> >  drivers/iommu/iommufd/viommu.c | 45 +++++++++++++++++++++++++++++++++-
> >  include/linux/iommufd.h        |  3 +++
> >  include/uapi/linux/iommufd.h   | 12 +++++++++
> >  3 files changed, 59 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iommu/iommufd/viommu.c b/drivers/iommu/iommufd/viommu.c
> > index 2ca5809b238b..59f1e1176f7f 100644
> > --- a/drivers/iommu/iommufd/viommu.c
> > +++ b/drivers/iommu/iommufd/viommu.c
> > @@ -2,6 +2,36 @@
> >  /* Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
> >   */
> >  #include "iommufd_private.h"
> > +#include "linux/tsm.h"
> > +
> > +#if IS_ENABLED(CONFIG_KVM)
> > +#include <linux/kvm_host.h>
> > +
> > +static int viommu_get_kvm(struct iommufd_viommu *viommu, int kvm_vm_fd)
> > +{
> > +	int rc = -EBADF;
> > +	struct file *filp;
> > +
> > +	filp = fget(kvm_vm_fd);
> > +
> > +	if (!file_is_kvm(filp))
> > +		goto err_out;
> > +
> > +	/* hold the kvm reference via file descriptor */
> > +	viommu->kvm_filp = filp;
> > +	return 0;
> > +err_out:
> > +	viommu->kvm_filp = NULL;
> 
> Is this to undo side effects from this function on error?
> 
> kvm_filp is only set after all error paths so maybe this isn't
> needed?

Looks like you are right to me

> If this isn't needed then use __free(fput) and no_free_ptr() to
> deal with filp more simply and in teh erorr path can just return -EBADF
> directly rather than the goto.
> 
> Or are we avoiding that stuff in iommufd?

Nope, gentle obvious use is fine :)

Jason
