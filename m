Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CC01E5207
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 23:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753831192; cv=none; b=PQYmOdsno2vvJ3pzQ/MAxXMLSfYh2xUKYI5kTu0qYbUcoN3AEKT5MFF+v7t7Kb/3nX62ndfPMgN8oDNcFdkUdCH8ZJfNHKvsa3hqhHVY8a/qDfpQlQZzvvzur0d34Pvmce3JhRVuccKp+sonE2ILst5iTGfzOyLeu7mljkdRWFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753831192; c=relaxed/simple;
	bh=c+qevVRK65+YEsONllF903kUYgjJYX41JiZtG9/l2tM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s/6WltczSsZiNVjNomRJOaeYvTISgWKI/DxmfibtsKUVkr3jxqNUsOXVfXEypeoF89vpfKNrbkr5yi+p6CyplfnqGyqGYioRk1I42ekFGJTXmknmy02kP3r1/b6FiXAsg3+wcoJn+cGxxhYG+4uQozs++ZsmVCaR1B0L/DZhe+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=XMmcwBYH; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="XMmcwBYH"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4aeb5eb611bso24295911cf.1
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 16:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753831190; x=1754435990; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AMNPBYRiksp7mCFMd1azqDvewT0I1SAEyDTPXzSObOQ=;
        b=XMmcwBYHD/LTP3EI7IBOnUTwcvN2zNNbu6HTaEl7cn5huAjgq2eMRLhZfNHUIf/W+p
         T80wBPPV25lofIavXpGEEmuRdpSjshhXVn+Pwm9b7InZaDuk73KSyOOfrlP5LyOevW/6
         7IxQ/uwFUYZIwxz5sXAEdnd+KAwOYlfslEn3q/DLjzZ4QEqUH6vKGKdM7nVtezHsiT4F
         F8dHlQ86NFypg6G9Mux5o+4oPxyrwHfGwp+DCnxC6Ip/saitfPg2isimO9nmCjzDnhtK
         lRSHi+rzk/jdhxTcaT9ZrBYsaIPO6J48Xj9h2IrUq1yqVoWKnTf0TGGV6eKZk5SZx8oB
         o12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753831190; x=1754435990;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AMNPBYRiksp7mCFMd1azqDvewT0I1SAEyDTPXzSObOQ=;
        b=rfk3Ed5tVbJK3G92ZlQrasRnJiRJLUDiAbpOa1yyR+p5Pb15sca4fC2cN0IWyH/v3T
         oavx46KurQ5XYLybvq19BHfVhhAJ9cEYqaikyfGgdKsY7K7rVSbcua/zNUbzg4YG5WsA
         cbSI/3PM5e4MnncXAw7ud6Uhfq4UyYjUQbrHFeEj4v1LGa0LQ0tn2SFxnehHUpvepNB6
         uAr4S6yxXHLQGbW9nn4WqzSsjPEXWBRqYnvt/6qtBsLscUq29tULcQ4p7XTKJ2l/o6uq
         Qf5YwI5DsOxXURhWoMm900/VQMrWV7QXFoJiG/QYYEA//IK5dCE9E4B+iNqbSSV3rHLV
         L9Uw==
X-Forwarded-Encrypted: i=1; AJvYcCWoB3JSgGXn6JCO4V6RbxxhltT+zunEN1M0ABIFrcjrjcw6s9EizEDFuIsjTG26ofbvNoN0d/s=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywq8ybPcpsvn4vaexP+2Wc93lHb+nHJ6jQMCM8U+rRtSHXEwhxU
	mvHOjLkazdhcNOTNgvmUK6LBqnUsZraixOmubu2otcmf4G9CtVrBxDlny2k4OX1m20Y=
X-Gm-Gg: ASbGnctWRK5hMe8/NzUvUBsuUwJvgQsiEhI4fdK7lEZDiWzN7sV7KA2g4F6YeS9ibxS
	UbJygW4gnv2eskPwqxLaf/eQ2fXzxY5ooqUHeWaWmPiGfp4bQbj3bgpM/KA1SaM9yE99pI3cIdW
	E+abyaHT5u+AYkjLlwshqn2GjVRKrjw2ERk4X0uchMc08OmcjWCg5sN6zrmx53dU+Lu+lL52Trf
	635SsWEcnsLulcYLPaaTQiE2Di5Aqo2fwQ3JS49CZEMdZQwCBfOmsdn/SfutawXqqAkcnuFV8/F
	xGs8lc1p4voDyHFwarjCJCp4YoKUIubll2a5pMEp5QGyBB1Nd+KU4tgQbf5N2Ze6lWmcrxxbjks
	m2lojcMOGdl9ffTj6Dg6IbViuVVhPVUPrSLD8nm0LF9WPRUJ7CSdSdq68ZDiHzFmw+pEZwW10TK
	2Iqbo=
X-Google-Smtp-Source: AGHT+IEYB+v/aC52I3ETJqWCtvUpxpSoF5Ed5PqfVqNjoX+1qc9FE31iT0mWajpl0SB8iOsRrvOo2g==
X-Received: by 2002:a05:622a:351:b0:4a9:a90a:7233 with SMTP id d75a77b69052e-4aedb97af80mr26047401cf.12.1753831189896;
        Tue, 29 Jul 2025 16:19:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ae9963ba4bsm54605101cf.31.2025.07.29.16.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 16:19:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ugtbo-00000000Mhy-3zTQ;
	Tue, 29 Jul 2025 20:19:48 -0300
Date: Tue, 29 Jul 2025 20:19:48 -0300
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
Subject: Re: [RFC PATCH v1 11/38] KVM: arm64: CCA: register host tsm platform
 device
Message-ID: <20250729231948.GJ26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-12-aneesh.kumar@kernel.org>
 <20250729181045.0000100b@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729181045.0000100b@huawei.com>

On Tue, Jul 29, 2025 at 06:10:45PM +0100, Jonathan Cameron wrote:

> > +static struct platform_device cca_host_dev = {
> Hmm. Greg is getting increasingly (and correctly in my view) grumpy with
> platform devices being registered with no underlying resources etc as glue
> layers.  Maybe some of that will come later.

Is faux_device a better choice? I admit to not knowing entirely what
it is for..

But alternatively, why do we need a dummy "hw" struct device at all?
Typically a subsystem like TSM should be structured to create its own
struct devices..

I would expect this to just call 'register tsm' ?

Jason
