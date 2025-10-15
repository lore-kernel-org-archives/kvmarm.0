Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4764324B23
	for <kvmarm@lists.linux.dev>; Wed, 15 Oct 2025 12:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760530537; cv=none; b=iBBtj/PQg57h9J5Voo8IvvKifxjHAppiazfeGkZpKhk+ARGCzsjbs1ytl1bDyqwgY/+rfCNPUPSXzhz/eGLngOuRAMTEClVmreczIeUVEgqif645cfwXUGkOfQrIyhPieOHz0cu3k77bmR7tp2r2ahTm2bdJ6RQAI9wTh6rZtPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760530537; c=relaxed/simple;
	bh=mjHQrbbDrwX6GQ7o9PGjEA7im+oTQeT6k/wmhYoPpbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GQwKSVKpvLlWU5q2yb6/YrIjHUkQT7puCjkPtweuubKVHp9tU3q1yhzgg+2++mpFxoonGHk2EAbu1mSwgNn1/aHNa+cGuber3rzcCajYDy0OmBSIxppNYRt6YH2XapiBy0GIqNEfyIJU+RhKa3/5SXNDLUGK/IYAzIB9dLcvg+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=legGRLvy; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="legGRLvy"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-33067909400so4745083a91.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Oct 2025 05:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1760530535; x=1761135335; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j3fPSrHORtZHq6E/vA63d68c0Rr3vVgkT2wP5kavB8E=;
        b=legGRLvyGvPgShmHNxzyKaRVIHBNwOwepM9ggFet9w9QEtffSJGEmFhKqUVTZ2Np9J
         7G8HJufFqFmODiLqYQgBqNfr7Jj+GBGtnVmRp9YcUsnwfl1+OK0BoqSz4seds59tTLxL
         bSk4QCswcRDF5E5gIYN1x00zGa6M8eFoh+rkpvqoRIRoHedRunkzsM0fCwXI6Fp4MV4W
         Dy7M1IH2iLtno0Cx5wL+bkLC7OAnlzE7AT6yp2C6ElIggGPq+JMjtwjMc3dU3KFzZNP3
         NVv8YX2lotAdEaMx7VdBe/y5ebLaMXVI0mRSQKe5k10jh1hlZaC9tUED19TngiJ0qNFG
         jfGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760530535; x=1761135335;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3fPSrHORtZHq6E/vA63d68c0Rr3vVgkT2wP5kavB8E=;
        b=HtRFJRu99yG7uoW+MuoQw2owh/QBkMttAsBtn9HPlvNNKCFA5rQlh/2GSd9jwCFe1Z
         5KAKt5uhiiRnISUi2Lm99gUVKozKcfe/Fz/oJmWPWn8onqkx0HFhsGA/IeHXFoBOJ1BI
         70tPu55jVeNpGlmfYrSRg35Mdt0Lu8VAaotl2nZvU8PwLYCFf4G8xvhBoFUQzMShF18j
         o3RxuoOVFhBtn13vR7jkweINRy/sz7UgbGAUVpT0mlnFzkc0EX81fva6kC+HcwLGItQu
         kH78mkulEuqxheLpXyJHPbuaL5u+WlKsgf79xEwPu0EMkBrbYbZu0uaRGjmwH3rmUSZ2
         1ImQ==
X-Forwarded-Encrypted: i=1; AJvYcCUciUYIuh19b05seWAWeYsWdXGHcD8V+Vb4AOi1on9ZxGp/rH6+MFyGPTT78cro0eAkOSxr4QM=@lists.linux.dev
X-Gm-Message-State: AOJu0YykQy4pP8yT1XEuKhnHHC76TriRqL2cd9k6MdWbhvaKqtfomcsi
	+TkGtbN8hYWVOc9H8DgdZqtyK5mERn/lFyzuJ9/nneLqZwN49OvTRLqS93fDdBudbyc=
X-Gm-Gg: ASbGncu5Q0l6RTHZWwnh1ku0EQwovolZVH5S7awvtEwCeDVP7DtL5r8oqPZex4qAevA
	hRoHis/9jut8LYHSInd04y1f6OPJMlKwpMN/pSj7L/0ZqRlMsIINxz5M3MzHkC/CxYTS9BUpELX
	AJVmUpxmFeS9+ldFmqRJwTNwJ+uQ5lzL8LknKtj1IgZ0qM68ZAGsQtEzV2Mos4io1UArGU7fO9/
	n91K20zOMFGZCgJVKwd2cviHUHW8DQzPGS7jmrhf7SLc5RVQBXSGuggrN6Zuy2VV4HO+EhSPy35
	BqRTLB/Mfe94qamKuTzabSGh25CtxBuYP3D1vk1BFzaTGQMzn426SRgsmexZIfE3Ao+7Be6+ueL
	zkrWmw5q/zJHzopv5DKm+nv9xP86Zmkg2hlaJfAIp4hE4eZxUbC3Cr2KaR0Ws
X-Google-Smtp-Source: AGHT+IH0oN0GQSOhSxcUM3EYcPBObyIHiYZ5l2qwqp0SzcDahjgm/x0qX3kZMHorNm24TIg/Rs94NA==
X-Received: by 2002:a17:90b:4d05:b0:32e:96b1:fb70 with SMTP id 98e67ed59e1d1-33b51118904mr41185997a91.12.1760530534910;
        Wed, 15 Oct 2025 05:15:34 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b67d313e7f9sm6775819a12.12.2025.10.15.05.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 05:15:34 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v90Pl-0000000HOiL-1Vvt;
	Wed, 15 Oct 2025 09:15:33 -0300
Date: Wed, 15 Oct 2025 09:15:33 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
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
Message-ID: <20251015121533.GF3938986@ziepe.ca>
References: <yq5aqzxy9ij1.fsf@kernel.org>
 <20250730113827.000032b8@huawei.com>
 <20250730132333.00006fbf@huawei.com>
 <2025073035-bulginess-rematch-b92e@gregkh>
 <b3ec55da-822a-4098-b030-4d76825f358e@arm.com>
 <20251010135922.GC3833649@ziepe.ca>
 <yq5a347kmqzn.fsf@kernel.org>
 <2025101523-evil-dole-66a3@gregkh>
 <20251015115044.GE3938986@ziepe.ca>
 <2025101534-frosty-shank-00b1@gregkh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025101534-frosty-shank-00b1@gregkh>

On Wed, Oct 15, 2025 at 01:57:38PM +0200, Greg KH wrote:

> If this really is a firmware thing, and you have a firmware device, then
> I am confused why this was even brought up at all?  Use a real platform
> device, with the resources that are needed to talk to this platform
> device and you should be fine.

I think the issue today is the PSCI does not always get a
platform_device, fixing that seems straightforward then all the
downstream things can switch from using more platform devices to using
an aux device with the PSCI as the parent..

> BUT, if you are making child devices that are NOT actually talking to
> the firmware,

This thread is about how to bind various subsystems to this shared
firmware interface.

Jason
