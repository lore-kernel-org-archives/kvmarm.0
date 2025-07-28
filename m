Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5DE26B76D
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 14:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753711830; cv=none; b=B848OyATJp5OgMJcHs0GqrkbMSCU6uxDTGihzGubUtF18o6ugkAc2NiQs44YKidFoaWmhW1iica7pG5x+v2Yx9SS0qm3CtERBVdaxk6n9dgnBOu8DGPC3uNKo8VejW6BFGPfcnI4268OXx82V8igWufl05Ld4gRAv24cTeES22E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753711830; c=relaxed/simple;
	bh=I9ZeIDzhsLC+Rw6BB2ZpsuLCUCI15ECbtPmeNUTuSxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TXNQUQZARz+rVpK5/R1+ZrAm2FMtoOtYnVPD5fNDt4cRChnZ9BkKVD6LuzhREkTT6rsbXBlux9oOlkNTKgo6Fmh+/U0w+1Plk4cCHamKe9+bmdka1WTQGDctYn6BnlWb3in/8XUJ8XQXKcRX7OGhwolJ8wzrJDymJ27RurOYX+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XC44TTlI; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XC44TTlI"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7e32c5a174cso405775585a.1
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 07:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753711828; x=1754316628; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+eqiZhyg+ZCBOtjufQJyy2X2RHAGHLhNx9NLb+2h7ug=;
        b=XC44TTlIi1jcD9qvsUzIoFEwxqP5vaRVQqY+RU49sjj458oEYNJKL5Jno9yMG1oQTW
         COGlf/JPIzfmHt7FPvUc13K/0wdoPAarGoXOovObKjSxnVLvpE+mckVNsJjnARCuQkeZ
         TLMEwwMnlSV1xSMdgW/ndGYMxmTglbCXm22jskT4L3kbxruiTNCkQd+00kgmbIbd/crY
         BNvFjDAfWuvxmMVrutivfemHExljH+kBFXV4oeyMBPGQ9BTVMq52qzthPh3E+HAQjCRM
         sVed7CW2ZI7k9s/Zk1eCb9Mgapxb48cJZAlUTulD7usxIVmX/Gvk6wTXq8M+a/fNCyuS
         Cjfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753711828; x=1754316628;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+eqiZhyg+ZCBOtjufQJyy2X2RHAGHLhNx9NLb+2h7ug=;
        b=DMBPDDfhCMIha+FvbMbzD7E+zIMJoi672GQNTIDnXkzPiwOugPkkQGdOFN8qIEM7Up
         WKNmy2Ddqs7mtJf+IO+CJCEA9+N9QRhf6igFqylMJoURoy5B7Q77TIu+uoaXn776h/us
         HnT1mquAsTGqLTbp9tG8rzjPjxrnr3A1mq35JJlBqIZ3dKVKEkMC1+ZbriOhZqVioUpy
         ame21jJSK0kM7A9NbJXZadWi8XF7TOaZJfNn6gUe8PeBJQydloxOCiAvVOpvdGLt4CmJ
         OqtCXczXRWALrF5VszmzgD7+NAkekuzRbczMbq2s35oRwTuLhrQ8GXV8M8HqTUNnrCmo
         1glQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0xpmshuI/pMm5UuCjyrFv3vF6+96BrZfu4+EC8iPaw/NIYQ/Fd5+IZXV9bKocx/lT9W0CZ88=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRoVwEn00rr0W1j0eMu8MbRazG4MbSqVkcPi81WCCFym+CuI1k
	DJqJqsxoIiV5ATQC3+MViT0l/RnXfoO2g7q6/qs0oC+yUj3lGHyDJdiDUTsUgzSA8Fk=
X-Gm-Gg: ASbGnct3EfEmEaHhbfv0w9vLX5TGnX1cTD2vvxNe5DDzpphu7TvDHOHCwmM8i8g/zsB
	Y/SSPQDuSVDhuJFzGue8z+mrAAiSr3CqaKZzijvW1CaLIr0HJwPpQJjt2EjmHsYhj5mdRLga4+X
	swqo2u76vWRqysFRYS+If6BfD//RYodss9uJykeMuYvN5AZQ5AuM4iCeZTwOvR43am6VjDbJReG
	S+cNCv/x6QW99oZf/Ha7iiDwgSIgPX1Un+QjTzc43lD7qrrkcmiUY7NzHuTy2RXYM+hBaMLt/I/
	PNIWO7KEWFUTOFKFjx9HT7DyCErWjoFZNAZFxaXPMe6c/bncotZ63w4TKQd8yttoHeK9W3X7N3r
	d+TNdLDgw0AYKID/XMz3OozINPvk6GqFrTGEprmI2dVspMKYa2P6cRKTrixnRnj0cVlXv
X-Google-Smtp-Source: AGHT+IG4AMn3fFLDW2xb11IBx2YQ2BaQYNWmVWPx/pnTmFR/H2yiwHIFP+BF1HqcDvdzFfnmN7sa7w==
X-Received: by 2002:a05:620a:2a11:b0:7e6:3c25:b69b with SMTP id af79cd13be357-7e63c25b6bbmr1410127285a.13.1753711827688;
        Mon, 28 Jul 2025 07:10:27 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e64327b33csm296288885a.3.2025.07.28.07.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 07:10:27 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ugOYc-00000000AQN-25tk;
	Mon, 28 Jul 2025 11:10:26 -0300
Date: Mon, 28 Jul 2025 11:10:26 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
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
Message-ID: <20250728141026.GB26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-8-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728135216.48084-8-aneesh.kumar@kernel.org>

On Mon, Jul 28, 2025 at 07:21:44PM +0530, Aneesh Kumar K.V (Arm) wrote:

> +#if IS_ENABLED(CONFIG_KVM)
> +#include <linux/kvm_host.h>
> +
> +static int viommu_get_kvm(struct iommufd_viommu *viommu, int kvm_vm_fd)
> +{
> +	int rc = -EBADF;
> +	struct file *filp;
> +
> +	filp = fget(kvm_vm_fd);
> +
> +	if (!file_is_kvm(filp))
> +		goto err_out;
> +
> +	/* hold the kvm reference via file descriptor */
> +	viommu->kvm_filp = filp;
> +	return 0;
> +err_out:
> +	viommu->kvm_filp = NULL;
> +	fput(filp);
> +	return rc;
> +}
> +
> +static void viommu_put_kvm(struct iommufd_viommu *viommu)
> +{
> +	fput(viommu->kvm_filp);
> +	viommu->kvm_filp = NULL;
> +}
> +#endif

Missing stub functions for !CONFIG_KVM?

Looks like an OK design otherwise

> @@ -1057,6 +1068,7 @@ struct iommu_viommu_alloc {
>  	__u32 data_len;
>  	__u32 __reserved;
>  	__aligned_u64 data_uptr;
> +	__u32 kvm_vm_fd;

fds are __s32, they are signed numbers.

Jason
