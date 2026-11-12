Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490364;
	b=TZwMgr7gZ/Bi3Ack5YdWmoixLm9HOMJqn3/Rt2jTdJdo7WnsBxwQzm6XE5sAUFA33w3a
	 iNVIYuLpjKDfzEX9fgsk1LiKXL4qe/pd4sMmr4F0pPYOCG+bIy7BTpX9q31i2Z4TykFUo
	 ZiwaE+rnsDsBZ20ygHme9FhSqN70uAp9HlbA3JfJnYkbHPPH93cdPPzg8NBagnCHdKpA2
	 Hk9lLIEvOm3r2i4pZ7WOFZFSzc4Vi6dR3CvnuSpO8XgF2uYuBYt7qug5gU8jUVKjiRQOk
	 ZcjDFAqUFYeAkfHT9yjkb18moFY+JsrXurC2/Pwv0uLNmpFSViQrc0bPyzWKmfzPwJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490364;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=y4NWcGpyLAF/FiolKWe6/Gbz2ERucyrW993TXlYX5t8=;
	b=kv+YBJg+i8ZmHzScab7jCx5jVlY33kEz59cCCmfskDQ9FS5MaP+HMGZBLUO+Zwa5/RBn
	 1cIzP0XySzHDjW9dJM96glPrQ7ASpZgXBCoVL3pWaORFncG2exNZAJLxH0SKTwd+Qn+PS
	 BFeaz9ZDuoYLMZj4imINBmKznSx7QKVClA/uPfc7U+IKrlmliwFbIT4CzmPhMWCgcZCLs
	 M5oeqvUlNDBCJGE7flCXgXKCx0s1rbSwzCA/eR2UqqzgCKGTmVjDMXXQwGMgnWLDIXRGl
	 gg1WJTVvHFdFp2He/1EhI3LLXobyGX0BbHX+hzDdYIcgd0rGUF2+F1jRe+43qNiMEeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XcQ0APyV;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABE5606A323
	for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 13:32:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2ABE5606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XcQ0APyV
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a206f0b95bso43805e9.0
        for <kvmarm@lists.linux.dev>; Thu, 12 Nov 2026 05:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794490362; x=1795095162; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y4NWcGpyLAF/FiolKWe6/Gbz2ERucyrW993TXlYX5t8=;
        b=XcQ0APyVr216CU2SFI0vtOk1H3orJnIti5YPG/UAK4emrz+nBRZtOpcfwQnJzMRO8l
         cHztwfM6LEk1ocX3ScTLHnta5fo1t/m+EkoTerlF+3RX3TtU+bkBPz5uINKQz9y3qdIl
         4hy+SnOX2gg4EBpFFlg6kupPPy8kzi5/53QVG1JN5jv29ynVUqsaS0hu6Mv2OM1sywXF
         rNtZtAK8nMw5Iwa4LOf/hdzUFuBAOCtaCBGwSLJcmrMlGDhegt1xnCRUNPZLlljQatzj
         sd7tB284EIt6Vis4qB1svCCD9W23bm23Gj/f1258g6SgDZ0IP4Z9d5lJmMJUCKfOxUTj
         s9lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794490362; x=1795095162;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y4NWcGpyLAF/FiolKWe6/Gbz2ERucyrW993TXlYX5t8=;
        b=C7OQ4jAp5MS7GL6BPRZ+twu0D+FjPLnF6fjhRu2MDyeiO6Xv00XEJZzCbxnbfSKp/A
         HUNvl8KPypcv2mk5HFaWbpucCUZgnTKT+iq7yFFPZ8djubDZWjGbGj9gcI9TRBYLTBjA
         4UMloPXRo3q1wzyP5iIaaiMXQaAi83fJI6rM8D2YAUPRkOH0IXtPV44L4Bk5+7y9euAv
         YLIM4zH03LXpyY27hBgvyT8Jx7qOJgsvBCj55+yghuxj5ie6frT/S3hnHm6/3pOb4q1Z
         70y5WFwMIXgn8D9utUcIFJDqmmXeFUjyQe2TnOUB9IMznuH1cMgmluDdFW46gpo/D/KS
         qDoA==
X-Forwarded-Encrypted: i=1; AL+hErGbgVu4HaPpeQ/D7TQfOeVDd9VyRmPk9SBy32F6BW5rGYXX/SdORU6pURHD+g98tvYn59QLlAM=@lists.linux.dev
X-Gm-Message-State: APuU4Z9uhlGMGIYCEa05iBCbbZ+m5F8CTlfni85XOjhzyqYoISuIOCga
	ZS8Q5awF9fDxWaxBuNrU5kDgN3JsG/pmBDIwj9xTJ5hgc+OuHZATivRianYBLnMMZA==
X-Gm-Gg: AYBFou3vTlTqMWS3mjCb/5V123YvS05n5icdEwBUgLu6odbrq2kwOkZOq9EC/yAq+gU
	nyTENCbu6G4CWtvb54d02L8Zx5D2sBJw2a/fRgvgcpKopuueHzD17EX1WuuUZRLBTwXqKv4eUX0
	dgOGcfD9tu9fTNJkpJ8nKrH0P+weDpirfrhR13isJJ/Ydjr3qBDB4vpKlUHSKYBXlg0pbezz3r4
	OWNUwrO220ijB9aUjXbVzYHRoSrIEg2gQNeRnBqsfiAg5vOPumzAVN9UFU4TSqgwsnJWIauuNvK
	n/DmRksAEncdwCYnp07jAmJMunWYnPV+qmmuUCITo898ZtTnzueEEeF6t6QCnfgeCk9qIVcLO47
	lcz97wZ9br3uWDf38U7O7SIXIL+u1AcodC9p4XNCH8n6LC4m3+O4zSyKW4KPAU4Ri9KdAGqczBO
	v1zhWRkLFEMGxpuByhBGGCn/Lha8rLvtLFKSi9I9mvn3s0+0XbkRHrxvGnDL2sbv70El9pCobAf
	JnFI2spqtaf2VzIiSAjutvvZXM0W2t1zXKQgONasYpy/6jv1ibj3h2R0ooIZtEDvgJ/xZ5Yvdf4
	7KC59NtNs+wbhfMix5/dScIDHlBjRCEfUcOMnXrFJlbFedu2r2CkVBJ31rjDROoINFrUuCcEszi
	BDapQpVqSC4P1ev7r
X-Received: by 2002:a05:600c:a115:b0:4b6:c939:3bfe with SMTP id 5b1f17b1804b1-4bb4ff4ad18mr794835e9.8.1794490362201;
        Thu, 12 Nov 2026 05:32:42 -0800 (PST)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4983585923bsm17339835f8f.11.2026.11.12.05.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 05:32:40 -0800 (PST)
Date: Thu, 12 Nov 2026 13:32:36 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com
Subject: Re: [PATCH v9 11/25] iommu/arm-smmu-v3-kvm: Add the kernel driver
Message-ID: <avW_9A48mtnK383x@google.com>
References: <20261015200903.2735565-1-smostafa@google.com>
 <20261015200903.2735565-12-smostafa@google.com>
 <auzvygiGRTWgJXzF@nvidia.com>
 <avGk0ilyJh3obmKx@google.com>
 <avJidXM9yQOX4VBJ@nvidia.com>
 <avL016l_xASN5paR@google.com>
 <avNhekBYqiiZ9IM2@nvidia.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avNhekBYqiiZ9IM2@nvidia.com>

On Tue, Nov 10, 2026 at 10:24:58AM -0800, Nicolin Chen wrote:
> On Tue, Nov 10, 2026 at 10:41:27AM +0000, Mostafa Saleh wrote:
> > On Mon, Nov 09, 2026 at 04:16:53PM -0800, Nicolin Chen wrote:
> > > On Mon, Nov 09, 2026 at 10:47:46AM +0000, Mostafa Saleh wrote:
> > > > On Thu, Nov 05, 2026 at 01:06:18PM -0800, Nicolin Chen wrote:
> > > > > On Thu, Oct 15, 2026 at 08:08:42PM +0000, Mostafa Saleh wrote:
> > > > > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > > > > +#ifdef CONFIG_ARM_SMMU_V3_PKVM
> > > > > > +/*
> > > > > > + * Two devices are involved: the aux device bound to this driver, and the
> > > > > > + * physical platform device bound to the pKVM init driver, which only uses it
> > > > > > + * for discovery. This driver keeps using the platform device, as it carries
> > > > > > + * the fwnode the IOMMU core and consumers link to, the DMA configuration and
> > > > > > + * the IRQs.
> > > > > 
> > > > > It would be nicer to have a diagram or so to show the co-relationship
> > > > > among different devices and drivers.
> > > > > 
> > > > > I assume the regular arm-smmu-v3 driver is a part of the picture too,
> > > > > when the pkvm driver binding fails?
> > > > > 
> > > > 
> > > > I can add some ASCII diagram.
> > > > If pKVM driver fails, no aux devices are created and the main driver
> > > > probes the platform SMMUv3 devices as usual.
> > > 
> > > I didn't check closely, but would it be safe to do so?
> > > 
> > > Is pkvm aware of the missing SMMU device and handling it properly?
> > > 
> > > When pkvm is enabled and the SMMU device is supposed to be a pkvm
> > > device, should it not fall back to the main driver?
> > 
> > If pKVM fails to init for any reason (unsupported layout or non-coherent
> > HW) the SMMU will be bound to the main driver so the system remains
> > functional.
> > 
> > However, pKVM will not be safe in that case regarding DMA isolation
> > as the status quo.
> > In Android, in that case, pKVM clears the FW (called pvmfw) that loads
> > the protected VM and authenticate it so any protected VM knows the
> > system is not trusted. This part is not upstream yet. [1]
> 
> You might want to double check a dual-SMMU case, where one gets
> accepted by pkvm driver and the other fails and so bound to the
> main driver.
> 
> It seems the pkvm driver would still pkvm_iommu_register_driver
> and carry on with an untrusted SMMU. Would it also clear the FW
> and mark the system as not trusted?
> 

That shouldn't be possible, if one SMMU fail the whole thing will
and the driver should clean up after as the probe is done through:
	ret = platform_driver_probe(&smmuv3_nesting_driver, smmuv3_nesting_probe);

In that case, that system will be considered untrusted.

Thanks,
Mostafa

> Nicolin
