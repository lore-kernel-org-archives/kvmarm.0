Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371F015533F
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 23:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753831366; cv=none; b=cmTxSptTPLZg2wzLxP65d/yTOWgektQ2XW4Dswv/7JHcQ9FLU5bbtVDbK6Mfwg8lgPx5BnOSv8nAf+EwBpWuYQJ+qwKNN3LL0zlf1zhIPRMJHKi91/G3PVmHMeLZb6cu1T+YiQv5yTSuzRRsm2BgxCSutEZWYpZQFPaGr7aORw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753831366; c=relaxed/simple;
	bh=5+SxyYSHlUovT7nMO8KUUry70XX33hvq1YMeYnlBo24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBS/GNjaJVY/G7ZqBUlx+UYZNgKqdf5VTi6vQfGViAws9nUvfqnU5IIJTeYtTXOSXbsaYDsPK0G25oqNyK9x7YczxEIpUcrMxIebJ0G9WkTWNz6LC/0tq9nsjUiruYT63hKcs0PolhcARXWy4wgpIo23AzQEECfc3O2SBOz//LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=QckLUOE7; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="QckLUOE7"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4aaaf1a63c1so42670561cf.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 16:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753831364; x=1754436164; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=evOEy7fuRGdGypQDmd9QZXrLo8EABIsGfXRQCCvlWq8=;
        b=QckLUOE7wdM7sGMSqACx7Fnfla4aIIrLMKSV56+eDs5pvk2hnvOSZjiVg1OPRhpOet
         n2JBlGQoO6Vc3hHGDENRZBM17/RyCWx4zGPGQFahi7+OTA50XkH+Jh4CE3ozw8o/RRmz
         LuwWU+mkXwcQlryALd1rx2y0eyakOuJkbJ30sbQEjfB7J0Hx2sgIf9rVw8dbvfjqMhid
         veMDj9lbhI6qLgQaSLxTPKlBZvRdb+8TQvbvw5HS1wJV+rZUITD6RYV0iYzdU7yd3nPH
         3QONlTfFeI3dKChHyVdzn71+H0UJ2J9EoopVyfPAArUAnqN4tE/rVdYxXrU/CCJxULea
         2Y2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753831364; x=1754436164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=evOEy7fuRGdGypQDmd9QZXrLo8EABIsGfXRQCCvlWq8=;
        b=XPP8kJ9gyvcNPGSvI38PA9b4ZvdaNBZyKvnDuXGfIqIERhM/uVSgcKrVXwyKd7nq8Q
         cgTvURwv5x2/V6mGvUwnNKNn6muHqUEca6gRhNFDbAm0J4jVWfCkChNq870WI7fUzeKN
         v14sv+TNXdYxAE8Qfx91rjPIpICajbmQdfHhZxTSgf0CAARRuQ2pWNBNvLdlIFfRJGeo
         5H4mD3y00i40sDNz3J3QpYWlI5ApF9JwF+pBTufcLw63XmUHoeE/2c4gXI88LblTwFEc
         fxt8oxoOnREbSsNxFp+6vM2GdpWEO2xQ+HBfFobC4fuiQMolEfuzx051Uo3bYB3ZBeoj
         6Krg==
X-Forwarded-Encrypted: i=1; AJvYcCXUvQ+fxRNPXmKTzyuHJ3qkGHK34aljB6nm8Oon/P4RJcC8p//PFq/H3+H4ELXjr71u3xGKdZA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBrdgK9nwX9EUNGHkFZ4n0G/iquJS7KQxOijiU8ddDSmqCzdNJ
	77/v1+VUDGT71SlQCjCMQJCmp+fNSTuqii8ZSqA3JfZyZ7pGwDo1gbqOLqm3Z8trPy8=
X-Gm-Gg: ASbGnctNRDdIdQLs8MWEJozFkmQnQKS8u46fUmFll1EuPqq4gSSwsVq8d8Vgr51Lxzj
	nd6oYGDXMgqmdfnPbVVIj+kNXyvlMEEShHuhfTA1J8jOBl8/gKYxqncKkmHtF94rAwsz6Tqoiok
	hRIfHUIR/k7J6u/AJUw4vsVP8W6DMUqooo1LsEuChlJwnc+D/tn33SHKPNAXYiygEEtuqoxojgY
	RZIESH43zYJEYEYf6SrlocsjtIYx86Rnq638mXFte30SokX5EHsUrEFToGyyrYzntgalMru9+HZ
	N8TjxrMzRjDm9ruw224UATjC3L4lQgy8hQBVxVWoeu3H9Ccn36lkOtiePT1zg8QNwn7/Tzk4C0t
	BhEC/HNPfsQ47Jzcmnxhir6VbAzoC912yiBPTkAx8XbSWJFif00Cl983z4pSEYKhPSPhTmI7Fb3
	VmfHM=
X-Google-Smtp-Source: AGHT+IEp29JmYKPTEUTfX9T0WcQPt09uHVFFYXFI1jbMPkfOwjEBLhDqzXpFec1njO1HN+oSVaPRoQ==
X-Received: by 2002:a05:622a:8f:b0:4ab:95a7:71d7 with SMTP id d75a77b69052e-4aedbc7919dmr24915231cf.53.1753831364093;
        Tue, 29 Jul 2025 16:22:44 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ae9951a6casm56688261cf.13.2025.07.29.16.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 16:22:43 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ugted-00000000MjD-0XUr;
	Tue, 29 Jul 2025 20:22:43 -0300
Date: Tue, 29 Jul 2025 20:22:43 -0300
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
Subject: Re: [RFC PATCH v1 12/38] coco: host: arm64: CCA host platform device
 driver
Message-ID: <20250729232243.GK26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-13-aneesh.kumar@kernel.org>
 <20250729182244.00002f4f@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729182244.00002f4f@huawei.com>

On Tue, Jul 29, 2025 at 06:22:44PM +0100, Jonathan Cameron wrote:
> > +}
> 
> > +static void cca_tsm_remove(void *tsm_core)
> > +{
> > +	tsm_unregister(tsm_core);
> > +}
> > +
> > +static int cca_tsm_probe(struct platform_device *pdev)
> > +{
> > +	struct tsm_core_dev *tsm_core;
> > +
> > +	tsm_core = tsm_register(&pdev->dev, NULL, &cca_pci_ops);
> > +	if (IS_ERR(tsm_core))
> > +		return PTR_ERR(tsm_core);
> > +
> > +	return devm_add_action_or_reset(&pdev->dev, cca_tsm_remove, tsm_core);
> 
> So this makes two with the one in Dan's test code. 
> devm_tsm_register() seems to be a useful generic thing to add (implementation
> being exactly what you have here.

Pelase no, this is insane, you have a probed driver with a
probe/remove function pairing already. Why on earth would you use devm
just to call a remove function :(

Just put tsm_unregister() in the normal driver remove like it is
supposed to be done and use the drvdata to pass the tsm_core_dev
pointer. It is easy and normal, look at fwctl for a very simple
example.

devm is useful to solve complex things, these trivial things should be
done normally..

Jason
