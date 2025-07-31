Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531392C08DA
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 12:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753964916; cv=none; b=AEHeit9SWDtWfeUT/10uOiXvhebihpeA3nBHakY/6Q0tnRZXv3HcaYj4XRDSMIvW/RBuFM9vZWl9pS+Dv2TvipANm3nKOSDjU7XbH92Ik8PHXKYohAxl7K7QKgrGKN8qiMzzMKOjM/LexGipjV+isshugREpGL03y0tPincUWhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753964916; c=relaxed/simple;
	bh=b7z5hjyg2X+VeoFo1PgyUE9sKzY0a5OOB4fYEBfffec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YX/ASQxOzrjMzzrNkWQm0+wpQssw4D1ncJZjId/wTs9HtpLA3VdUQW4i+wTIbLuYBMOPiJfhmxoHUDOVZf+U1zB+Vfx4rQYTcHUeemweoSo8Y8HKw7KVltqpgBhX6HKWyp+DugPg+Jb5Nj9kwhb1ElBeT0nPr88DTofSl0vgl2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=bR2Sf9x6; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="bR2Sf9x6"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7e623a12701so29617385a.2
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 05:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753964914; x=1754569714; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OW/Iya9h0ABUEfHeAI61tqBJP6UR+IkHJ9+YZwygnb0=;
        b=bR2Sf9x6yTPZzAm0ythtQGEspqQPKX/8lUFOBcufrLCZ/VV2moz1qYqBxask8YwW33
         DvT1pffBP8vrM/z4ZwOO8W8s9c6Ok3guL/gnUz5BtUDAYDyXpPvuCJ2k+etHhnYPrGTp
         X0XRrTuTk+2VN5Uye6xElT6+Oh9Ej+ZgOqJWmIkoBngQRDBFwB42+1TgVQSFQ+qXOAjZ
         v9MT5RqWe5v6v+CEBSCvPIjX7Vk7i7WULmWMR5xxmRAaWbtuEkrnKKNKA/wL0/ZQ7j8p
         D+C4EBnspSbc/KHK02gFG1POrUb+aQ5Lp5ZSt+9cfcSlQ6DuIyaLqvO2Tax870X22/OU
         3k8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964914; x=1754569714;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OW/Iya9h0ABUEfHeAI61tqBJP6UR+IkHJ9+YZwygnb0=;
        b=j/llSICpn0DvzrvklP63AOTmPzTJ3T42stt3pTmlCOu8kixIq32HvVnyqZxJAIKeA9
         Pa8GJAF2YAM2cCLZo7SjIm5R/BOokNc3h0kkp4ooQIwsubZ+QfJ12gDov6XNeF+o9XUR
         +a8kuMcmw9cRf4cpo2yBQyK/ls8it16dg9iYHq+CNzeY6egq9m5PukUtsHdOj1LcER7X
         Wb9jl3ip46HjWKpgSDuOSgeWIjapxQMizdAFeBwdjBIpUTR4QtQJlJu+fioyqkEd9918
         U3EFyRp8ajBkLHuvCjZyvdxB1qM+FzLyBpss9FPujTIl8e5RcrfIdd8KYECZJ7nUWRP9
         2n2g==
X-Forwarded-Encrypted: i=1; AJvYcCVZfWflJS+F1INAQeb1mUpAr4AuTHB1omRlXAZrZu5qlvQuTO4OzkEyjnWxJpvH3yvrGzCZ5Pg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyTQjy/pgDBe5ETEuQWcJu15H8Nuz4uLEu5izIYPMZwzoxbaYCt
	MP/yeCPSAFP6cW8LHJhv1WGtuRLGxLgBOxLecoJTLJH0n3j4v8XEa1ku1Kl06msUTWo=
X-Gm-Gg: ASbGnctaBdfHLnqu6o4c/PNBfE8S7n39PooUYsopv9Cd6yfGMOOT1jvdy8Pe4SlftYY
	if3TA6qTd2LdDM8PPVt7/sZBUYuPPEWjU7rnX95Cpsu35YfElXxXrl6JH7LngyyP9pkg0kEnaps
	S+UQPEl1/Sj4a1nThZxwCSJvrqd5JeAaj6vvM4ZvHnsAp3DGjFBS20dtMmdTUupb2RtYgW+EJKT
	uhugbqREotjQrNkSsPWvz+tVBkdQvYpHyPo2ErOSp5fGyJq7lr09Z5kGIpQCGG0eyq9W2Yow6ki
	VQswTpm24Q6zZOiePMwERpXJ/NQfam+siMBRQHkWZNl6ZwjM63rdck82UtD22eiDwU+2jkvD3UA
	oTDPi3M9OY1OYWTSsdNEc21MvSVtxNgTiMGymNjEmWxSSMYGX7cVRF1TS9H/SGoZlf59g
X-Google-Smtp-Source: AGHT+IGB5rbfhCfpEBxYzQb9tShfBv5DP1x7P0EzX5XLP6rdIVy17VMQfI03BZoFiDbqj4lwUzglhg==
X-Received: by 2002:a05:620a:571:b0:7e3:5129:db49 with SMTP id af79cd13be357-7e66f3515edmr758031285a.45.1753964914155;
        Thu, 31 Jul 2025 05:28:34 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f702578sm77242785a.57.2025.07.31.05.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:28:33 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhSOf-00000000oaS-0Yjj;
	Thu, 31 Jul 2025 09:28:33 -0300
Date: Thu, 31 Jul 2025 09:28:33 -0300
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
Subject: Re: [RFC PATCH v1 14/38] coco: host: arm64: Device communication
 support
Message-ID: <20250731122833.GT26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-15-aneesh.kumar@kernel.org>
 <20250730145248.000043be@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730145248.000043be@huawei.com>

On Wed, Jul 30, 2025 at 02:52:48PM +0100, Jonathan Cameron wrote:
> > +static int init_dev_communication_buffers(struct cca_host_comm_data *comm_data)
> > +{
> > +	int ret = -ENOMEM;
> > +
> > +	comm_data->io_params = (struct rmi_dev_comm_data *)get_zeroed_page(GFP_KERNEL);
> 
> Hmm. There isn't a DEFINE_FREE() yet for free_page().  Maybe time to add one.
> If we did then we'd use local variables until all allocations succeed then
> assign with no_free_ptr()

Maybe think carefully if you really need a "page".

What would prevent just using kzalloc(PAGE_SIZE)? Under the covers it
is almost the same thing.

Jason
