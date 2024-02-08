Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A7D7B3EA
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 15:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707406934; cv=none; b=XKk4Lz+T2WC+pxN/F2kuAGOT8qhOasKaYAoA1zrPe8sa5jAc6mdoRtwcMXHngO6BvH4gu0d4204enqkqDRjuXgMHcR1JKlhs6mDUXoIVjeOJluUZXhH8OwNyBGrGtkeNYOKU3Gg9MITVbiNP4H9gXeC+5CNMhDt/77erVFiO03Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707406934; c=relaxed/simple;
	bh=w9YAG1hrdOLKVRmU2Ju+UZHvL6wgIxI0glE9I2YcTx0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nlOMqmivF2ZyOjKKblTZTAxm9greQj3qsu75dSgPXFedtUjowGQx1kiW6uBZPNi3BsReuCB4CDgiRlkb3b5A75Pt/oSu0OPhKbHLzTGR9HfZMu1QsuxmD7QeEUTXbJt8kgONCOGsM9Nvd3DzaC+ury9g76jSOWx4eKh+qRrBPnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=WwWVdabc; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="WwWVdabc"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-59a87156cb8so703389eaf.2
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 07:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1707406932; x=1708011732; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EZJRasN3voplU9h3tHiXSxFIE9VtiGQfUESd73+6hoQ=;
        b=WwWVdabc62y2LPfnhysNk7upzpvozPcFf42Y7bVZZG40UK5nsOhQWpgsMGetWFSz/5
         8t4xBFRRf2FmvNXzUod2Sra2eHniosrNWrwPm+Mu2mDMPYBwRn6Sscw/HV49au8I54bD
         jti/FVx29hBkPrkTfFSCJM2tYiuoprHHRxo38RoWnJ5E3+ZpLSwQ3mZfDpiTVH6WN2uF
         v9LVT5JG3cogmLGRWiKdkUhv2DFZJPIbtoxRdhBrOa+882VTu1KHoytwwRJ7y7aSUx8c
         5t7w2xUIoRfSJmPk0kRuMvWv5YBuz8rmSHENV9JG242YcUxu9lpp6sCvV+LRQ50tzlga
         xPdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707406932; x=1708011732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EZJRasN3voplU9h3tHiXSxFIE9VtiGQfUESd73+6hoQ=;
        b=uRnGQEf7wfe4RMNPJhy/pNwY9QRSUJP3wzFieTw9PehaCtBhlYutak9HJ6ykga3qxs
         iwlGPcq2BAXy1QE/jCJ2N7alJUBvX/+KMefcTp/na4rm9xgVTE57HuMvpu1IohvQNPBO
         R0CSy8JPfkrrkFMcjQ8VVVNiocIiuu3UphkVctsuNrfOumzgTjRgq3zMB4HqAYW+vpRn
         LGweH0Gp6OgrDKjRqL3AChtaBdFmVIRPe38WK5+AItj1pb+CT6zwhTvIXbDjizEndpO8
         jz3yxcsJliT0VTDB1uSDL7q89GtQns493zYqSQz32ZBbHwayX8ccWYYBhLVWCN04KHH0
         l5vg==
X-Gm-Message-State: AOJu0YzDxjiEGj673nS+0wG74dT6r486dAtFpyOi4LAECBteywM+kobe
	l4q6EPLH2GGqUDgD0dHgyM3giTd3W7j3WxqSGh0pY7pcI/q3N+oj4PwTMdvJiTo=
X-Google-Smtp-Source: AGHT+IE3PwfxQpURBGAAKaS3krlWGtNcCQFNQCbN63NLhkJIwKeSQRRw4QXog/PeEJJ9jtMeD7pbPQ==
X-Received: by 2002:a05:6870:a549:b0:219:6e95:c0b with SMTP id p9-20020a056870a54900b002196e950c0bmr9212306oal.31.1707406932405;
        Thu, 08 Feb 2024 07:42:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUJRKIjOTasKsfvjMG41fg04Gz0N8nhUWcyJoueInvQQj1iWgoAI0nY50rdIYU8xWMPhvKfmuq3c9Sby/wV8segekKILQ9yhLUq1xIoDEYUkUfJt03JzScQHC1VvH4cfiroLmGzW07CPGzqv94eX9A2WbgOLad9lAKDmF7zEXJY1tQaY+USY4MyH+ArCgX50PFUXuVoeR4yFn7EaG+60KuYq0TVz60HhXknNfm5Zz7YzZTXEzV77E4ZWRmzFmrnQtd4aaZ7Gd+ejrROXK9Eb9q4yoIx14Bomks+X8zxEI1Tq/tTWuxGys7Ysi0+nxjO296l1W6GLgmF+VxI3SQ6DYqCWr/WpchzRutRQCJFBASfcXA4Rm+P0OV7j51wkihCQFJVDS/hHzWLflTcWcpOyW5rIVSb0lB5JWUBiphnWaxKfXnfl16OLYdWaJCU
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id eg50-20020a05687098b200b00210cc6cc9eesm777401oab.33.2024.02.08.07.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 07:42:11 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rY6XS-00Etmp-Pg;
	Thu, 08 Feb 2024 11:42:10 -0400
Date: Thu, 8 Feb 2024 11:42:10 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
	kevin.tian@intel.com, alex.williamson@redhat.com, maz@kernel.org,
	oliver.upton@linux.dev, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH v2 4/7] iommufd: Associate kvm pointer to iommufd ctx
Message-ID: <20240208154210.GP31743@ziepe.ca>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208151837.35068-5-shameerali.kolothum.thodi@huawei.com>

On Thu, Feb 08, 2024 at 03:18:34PM +0000, Shameer Kolothum wrote:

> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index 991f864d1f9b..28ede82bb1a6 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -16,6 +16,7 @@ struct iommu_domain;
>  struct iommu_group;
>  struct iommu_option;
>  struct iommufd_device;
> +struct kvm;
>  
>  struct iommufd_ctx {
>  	struct file *file;
> @@ -27,6 +28,8 @@ struct iommufd_ctx {
>  	/* Compatibility with VFIO no iommu */
>  	u8 no_iommu_mode;
>  	struct iommufd_ioas *vfio_ioas;
> +	/* Associated KVM pointer */
> +	struct kvm *kvm;
>  };

Associating the KVM with the entire iommufd is a big hammer, is this
what we want to do?

I know it has to be linked to domain allocation and the coming
"viommu" object, and it is already linked to VFIO.

It means we support one KVM per iommufd (which doesn't seem
unreasonable, but also the first time we've had such a limitation)

The other option would be to pass in the kvm to the individual sub
objects.

Kevin?

Sean would you be OK with this approach considering your other series
to try to make more of this private?

Jason
