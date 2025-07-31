Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B7D2222D8
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 12:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753964992; cv=none; b=n9WN4fge9qShDQWk/liHiyV9Kv+SstXxFgk8H9oOUzwhQe0rZ6t2g5817FCJ7UPwnuBP4klNHwDrx6SF/ePhay5fI5e3lD1gnMUE7aXb3FVBKWZR22yXVor5jaHPmjnt1HO5Z9ZvTSeHf2UBRaGzx1fW2hBzzB8ZlJ1sYcocHEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753964992; c=relaxed/simple;
	bh=stFuxurLK8Z8AnaZ49l9W8w7aFsmtWO77oIxpAGLTIw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s1H0mJvCNNf0rPO0Mab/qKM4FAWmV8CITdAHGDwFSyQdGOkx+nNiEzcbWVVkZhT/Va7rM5MPArQeUkiXrNGlhzY+LF+lOwGU59/a9f074SWD2himA5Agv2RvX6Xi74tlmRhpu0KMF6l7giE/A2RVjbVINGBkV9G7PmN9yBVsn9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=W2eSco0I; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="W2eSco0I"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-7074710a809so3055486d6.1
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 05:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753964990; x=1754569790; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r16L0lPAepHRljLoRD2C+qwfP2TiLc2fMDqSQ/mjsSA=;
        b=W2eSco0IBoyrIjfBDcnjSPTMaH+x1lng7XSUqlc9XkC7FU506RBhuCUlfBkV8LLYT4
         lEUgNASQYXRlH7K/qEjO8l/wQrpjpO/oe7uMgufkgamTd9s/A6wjr8aVIL3cd5OqRqs2
         laGwVwKqkNypsc7c09cmZfBmRymzLKBdYx6QpH2rOWhrXzB6+BVzP96erYDnBLi1RwT2
         gwZzVrt+S+kOLTgmGs6VEp604nA4GZbRaVa8P7XOiKg/NQyqF+751NgCVRRn3wrRXsnm
         wtvvFNbYuILO76XbOVWQmPbvIyJDHBHkj2RJEbYID/i1s/uktUPwItZvtrLDbxdBv7NY
         cLFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964990; x=1754569790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r16L0lPAepHRljLoRD2C+qwfP2TiLc2fMDqSQ/mjsSA=;
        b=cXjb03uQrXvvGb+U+WDhveIuur8J6ny2bbWkKForgaSOwkxyBKcbv/gt/UR0U7LORt
         SEyC9btjDD9bW5QZwq7dRjvCmPa3MVMIF7SsbvzfVD9zM2rtBgbfBdaCPQqp5KHTwEKe
         X4E9btbDQOBykdS/BSbPRQvU0LqdHZyl/MgGzosiWwd2hHha8by/5lnosiaow/Uj4fBS
         mrD+CyA8TjH8tiWGTIgMPfsSdMGCIOxnZYXJF2qdOr9ru0U+hnYRkvhStUCnltorvzAB
         LFYK9TyoFcLjZcS+WbRMCj/nxEV/hf2xUHMceh7t2Evcmmn8WaFE6sNqdRyHAS9S5xNm
         IEmg==
X-Forwarded-Encrypted: i=1; AJvYcCU58Q19wwhuQGGu89suxSs53L6swxEFLm2CB0oaGljZZaHRiE2C8J6UwVbOSSzABH6/c8S37Yg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWk3fvC4mL2Unt4q0hFY1Abiz2XFMoaKJsMHMhKUWupx9xRv/E
	xUwpYFv/uKbZarIQ4HSfuZDKiCTiXCJePR3H5nMWyFpX3HSQzxvYFmdbgv4Br1ZTr9A=
X-Gm-Gg: ASbGncunzUm7asI2ENs+wMng+baORaArEoPNfEPTKyI2wO0m1U/ERyyBTFuJcLL+8kT
	chQCTJ6mqKS/0tQEykBpJFSTQtIzKkRDzTvmr2XkRsXi7SJaKZ43W9eJG4Bd1GdNuR09vfYQ/Sb
	0tunCEwOiqID3x8nCOaZx/XFfw6aA+30UTCyDo2X5Rx0ok62D483cpYDxXzrInWZau3+IGa9b/F
	Nf35yiR9TkY697GuoNQhcQaWHaim/7tVUv0avoRB7fpxj2dhdS8rwk+NgtE1lF2HPnjrP+JHQNv
	N8H4nveqGnUCrj1Gl4JfDUJ6k8JU8ZDl2zPP5fMMasGtZIXd+U8miICOSAUzeGuJ9J1TVarUEU7
	Fg4mAJwti9ZcmrL6mp2+FPS6E2Eo3xj5zXFW2Bfw7uBQ8XH9jhJmqa20FpWC8LG8V/yjCaoyt2r
	uAA5o=
X-Google-Smtp-Source: AGHT+IGFRiq4QY4lDaxJA1kOgdG4s98/jc148KJ+4RcbhXD0Gv7ljg9jqdQ+tgIuoEfTT/tXWxH4vA==
X-Received: by 2002:a05:6214:248a:b0:6fa:fddf:734b with SMTP id 6a1803df08f44-7076710c664mr94449716d6.24.1753964989913;
        Thu, 31 Jul 2025 05:29:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077c9d98ecsm6607476d6.2.2025.07.31.05.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:29:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhSPs-00000000obJ-3nd7;
	Thu, 31 Jul 2025 09:29:48 -0300
Date: Thu, 31 Jul 2025 09:29:48 -0300
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
Subject: Re: [RFC PATCH v1 23/38] coco: guest: arm64: Update arm CCA guest
 driver
Message-ID: <20250731122948.GU26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-24-aneesh.kumar@kernel.org>
 <20250730152204.00006f79@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730152204.00006f79@huawei.com>

On Wed, Jul 30, 2025 at 03:22:04PM +0100, Jonathan Cameron wrote:
> > -static void __exit arm_cca_guest_exit(void)
> > -{
> > -	tsm_report_unregister(&arm_cca_tsm_ops);
> > +	return ret;
> 
> 	return devm_add_action_or_reset()
> 
> Mind you, Jason probably won't like this ;)

devm in a module __exit function? How ?

Jason
