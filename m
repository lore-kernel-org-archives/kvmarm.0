Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B6280604
	for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 22:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760135688; cv=none; b=TGDY8DwtqHLYAOS7QlT8XALKoFSWmOwITxxhlOFJ4qywa7k11h7gAc++69BTTtDA46OePY82B/8ELvhkwwglngT9R6Nz0XDEQcdl+evKGo03Bi64rPjJUTyHbFbXu2fIDx+yGo4XwFBHpcmlfJhq6g3BekVMNy2XC/7VhiOHc8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760135688; c=relaxed/simple;
	bh=Pk2+8/IwqNSzhAu614JVEvZm09rKZH8rHw8rZM0DYaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpNMi9PAzKYsyFGfQgtoUfavTxahfDQdkVBaOgMD1IHeG0zGMSTc76lYhudtB3XrSgvkM28PJPLDBZdxGyB+rzai627dabvsDWS14+deed4/CX6BQlOtMYhToe5CmsiXU+qT1TBGzodbhqu1pi0z06wlKZAfP5YWdMXSG6H7BK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=MroeFHwW; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="MroeFHwW"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-7f7835f4478so21378606d6.1
        for <kvmarm@lists.linux.dev>; Fri, 10 Oct 2025 15:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1760135685; x=1760740485; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=e2mC6oaVhDB8uY07Xh45M+WrV8K3BihoQCe6CsvnzAk=;
        b=MroeFHwWHKWFSzKjv9MfOQ2TOYSqNme52LLuOQoVFjuCIcLariskw63j6BjaJ16Q08
         vpAYJC2rk+/LLWoXFxuRl58YBh5gltbzSnOi4NjRv1iq2dHbS29FuQZFi4bsMtwR1S3j
         AfAuS0LzO7iFCrtSH8LACQ+4BAnHRsUVsbB3KBhz9pZwJ0QXJHZ7+f5/sahOzTocl2Nn
         z4K9cAHUb1UT8uNmG6dwKKCnGwoyTcIFteFH6+AWxSsFh4tB9gxkGS4u9SaIAiVQBRRR
         Pd+HTC6KNvjcrM+uDdB8TP9fAGKJw0lka5LSKMdIq/SN8pMGpM/LAWj8Bf+OTuOQYTt8
         iMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760135685; x=1760740485;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e2mC6oaVhDB8uY07Xh45M+WrV8K3BihoQCe6CsvnzAk=;
        b=a/KpD0yXr9OTHKnroo+DnV2r7oDdaxpGT+Dbveb0hmN+AErHmeuomH8++Bwilxtx+1
         7ectE6/4ZhUbeYK/rYcy46pWXi8NTpYf/aQD4MKNpieTNJvt/I4Er73RVqCCgIDHltWj
         YmvyOYxgOOOGEV4NiB8FfRZoT3Ehpjn+ZPQCExDSMZtfdfETL+M84dZjcUpnlAXQ0gIi
         tphOFTvlAx5IMMUE8WPzC2tqgo3m0IYRnwAkSyEv69gZczOcKOGahHyH47dlNO8zfOic
         sK0THm5j26RTH8nNElGtgFiRDoyHSAer1tXqf5CsSA4GLQ4PacbFCY5tGy+63hVpCSi9
         q1qw==
X-Forwarded-Encrypted: i=1; AJvYcCUfA8CxK8yeEyP3pwIXX9/Om4cZdwRe8bZkyXSuHMzgAKFmj+J4cznycHL0uXmIJ9HeH6hLK2U=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9y8dDvRyhUgJnaxe5xOyGrxWtMD1P9MahxvFzIEUVuUya1ZTj
	nK3pBVAu8fMQRmzu6EisjiNNQaajPr+aWUYexiVQJswDC6jV2bVycZAk9PTwOtPriPY=
X-Gm-Gg: ASbGncsWu+GGOcrvpPfaMB2rfbjDbs0RB6afH764COV5j3V3HsXRLzG3SyuGJUDJpdi
	DtYU1jaSQ/z51W/aSyg9OZH0NFqTRdbRL6IzLAhC4hlrzUcNF/WINe6vUJuiHD15pfJ6TMAyHfk
	AyvmWTCydp687G8a2/6ou67JnxLIc90gCb82ujXgsaT6zwMotLS9HT+P1+E0OAFoivBumHNh4xG
	8WBScgyV1ePdigHJqDXD5UIltU5WBAflkO8QdNb5qBOnxVzqIq2kON9pJF5RkarGlgR+DV3k/gt
	LORlnmON3GOHAfbm4PW4FCAzoVmmDMiLEosqYJUgFlCJFeXaCr+LAkHteaEQttwEUKOefHnxmWG
	q7LxROq8vPPldhVO7XsR0546+41jcRw1ncdr45LHHxj0vgn/7e0BdsVDNzfk3lTf8VW4iRn8Eu2
	p8qkSyFwTwl6E=
X-Google-Smtp-Source: AGHT+IECAcR/KGy/e7wbySPEFRjHLCdMYKTul/IVB6jvzNGBmryovZWE46iccPi7Pk1ulqBzRKwDww==
X-Received: by 2002:a05:622a:5984:b0:4cb:57b4:4d6c with SMTP id d75a77b69052e-4e6eaccc73cmr181726641cf.12.1760135685384;
        Fri, 10 Oct 2025 15:34:45 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e706de73ccsm26004611cf.45.2025.10.10.15.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 15:34:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1v7LhE-0000000Ghev-0UWp;
	Fri, 10 Oct 2025 19:34:44 -0300
Date: Fri, 10 Oct 2025 19:34:44 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: dan.j.williams@intel.com
Cc: Jeremy Linton <jeremy.linton@arm.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
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
Message-ID: <20251010223444.GA3938986@ziepe.ca>
References: <yq5aqzxy9ij1.fsf@kernel.org>
 <20250730113827.000032b8@huawei.com>
 <20250730132333.00006fbf@huawei.com>
 <2025073035-bulginess-rematch-b92e@gregkh>
 <b3ec55da-822a-4098-b030-4d76825f358e@arm.com>
 <20251010135922.GC3833649@ziepe.ca>
 <4a7d84b2-2ec4-4773-a2d5-7b63d5c683cf@arm.com>
 <20251010153046.GF3833649@ziepe.ca>
 <f6cf20f6-0f19-4814-b917-4f92dad39648@arm.com>
 <68e953f484464_1992810065@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68e953f484464_1992810065@dwillia2-mobl4.notmuch>

On Fri, Oct 10, 2025 at 11:44:04AM -0700, dan.j.williams@intel.com wrote:
> Jeremy Linton wrote:
> > On 10/10/25 10:30 AM, Jason Gunthorpe wrote:
> > > On Fri, Oct 10, 2025 at 10:28:36AM -0500, Jeremy Linton wrote:
> > > 
> > >>> So you could use auxiliary_device, you'd consider SMC itself to be the
> > >>> shared HW block and all the auxiliary drivers are per-subsystem
> > >>> aspects of that shared SMC interface. It is not a terrible fit for
> > >>> what it was intended for at least.
> > >>
> > >> Turns out that changing any of this, will at the moment break systemd's
> > >> confidential vm detection, because they wanted the earliest indicator the
> > >> guest was capable and that turned out to be this platform device.
> > > 
> > > Having systemd detect a software created platform device sounds
> > > compltely crazy, don't do that. Make a proper sysfs uapi for such a
> > > general idea please.
> > 
> > Yes, I agree, its just at the time the statment was around what is the 
> > most reliable early indicator, and since there isn't a hwcap or anything 
> > that ended up being the choice, as disgusting as it is.
> > 
> > Presumably once all this works out the sysfs/api surface will be more 
> > 'defined'
> 
> It has definition today.
> 
> All guest-side TSM drivers currently call tsm_report_register(), that
> establishes /sys/kernel/config/tsm/report which is the common cross-arch
> transport for retrieving CVM launch attestation reports.

I suspect this ins't a TSM question but an existing question if any of
the underlying CC frameworks are enabled. 

It is this stuff:

https://github.com/systemd/systemd/blob/main/src/basic/confidential-virt.c
https://github.com/systemd/systemd/commit/2572bf6a39b6c548acef07fd25f461c5a88560af

  Like the s390 detection logic, the sysfs path being checked is not labeled
  as ABI, and may change in the future. It was chosen because its
  directly tied to the kernel's detection of the realm service interface
  rather to the Trusted Security Module (TSM) which is what is being
  triggered by the device entry.

Maybe a /sys/firmware/smc/rsi file might be appropriate?

Given how small a deployed fooprint ARM CCA has right now (ie none) it
would be good to fix this ASAP so it doesn't become entrenched.

Jason
