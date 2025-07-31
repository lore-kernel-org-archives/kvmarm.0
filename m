Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E771D2C08BF
	for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 12:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753964541; cv=none; b=UrYHGBSOZEldSgb7C9BWpzsf9pQLRNvH/MvDBf/y/vsmx4yhT84n4HXUBSBgumh1VGxPOinQyT54/w8RHudLLCdCdDGAxI5y95FMmNbKBvznPsivrSZdq/sXbRhqQAPVDz2SElc06CmemWyhyRqc6WUwyUilLE/Ueh5YmqkIGB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753964541; c=relaxed/simple;
	bh=X+4QeaSFicbF3O5vX3PUSK7qVCr8plMhgP2gRhF3p+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lx0E+MpbqQUkZ6BAf3TiTGP3fKuDFfqcUNUN6d8HbATo8VqnDN5QgWn/BF/PV9uifg6loo39/nxqF+tAdxo7Ek+RNjGamKwmE8y02ILMftHZ6dofcJNrprStTIduttpPohm+NS9DoA6W/MLSqlKD24gP5IOniHU3Z7RMqdRWybY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Wdxjg2pW; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Wdxjg2pW"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ab71ac933eso6923861cf.2
        for <kvmarm@lists.linux.dev>; Thu, 31 Jul 2025 05:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753964539; x=1754569339; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L1plMRIcW1Bcl6c/s/tE9fzsee7elDjFfonquyZ/HhM=;
        b=Wdxjg2pW3gk79JkX8pp6r+pSX8CbAp0IOAllNj94EpanqAkAiz1/2ZHCOWnjyltTFt
         AyqE/FYF6Z3omtaAomLZIjZUpqOslkPwHg5/HekN6oFR4JfmrYizmq/gfFZXgafc+c2E
         SUZwPnYrurSH7P7ny0f1+ZXbEt5j82ke40b8W7m3unwSqauR/9LzxeU9QTE8R1PKCTKm
         lc6JLUmiv/buoJnFRGOsFuV10Rp1UnAOWRXD7QNJillClAai6tUd5oTIWZAo6v/dUB4l
         rG7Z37jAIzc0ub2IXPF2nJlmCSr7q0WPS7x0+FfcsSxtH8o4C3IlkV2t/YpZ8JonYe7A
         h8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964539; x=1754569339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L1plMRIcW1Bcl6c/s/tE9fzsee7elDjFfonquyZ/HhM=;
        b=CRae3nBM+X4/hIDWV8xceDWr9ir3E+Cw8YWOMqY1QSFonRxL1CWeRMEMguivC7TSLA
         tAqDssgiWx1JDpC7ZSOVZ5pem8SBC+gT74tNk22OMN0F3xOEnQjFa+FLQr2Vj1iPhmgj
         JplyFkxaYa371KAj0T6KNLPhj3W2vsgFB/0QKiMYsWEp1cITxTmwnwOofy2FKJ4KXi0j
         4lwesixjEx6H49TX2bQ3UwmLS4gFpLTRPQb8hBDXlLWP17IDG4p7i+jZt6FW1SJwYnmz
         Tsq4L0po3G/JDln5oM6v3h2tpcyuM42Wq+kagCN1hPmLS8JNnetBPfOWmcTf/Jj2cqYU
         NzgA==
X-Forwarded-Encrypted: i=1; AJvYcCU1eyeoVUZEqLU3n+6caJrtO902uo0NBoyHxQbXzteIgi5zWJkLU5qmOUvuMFEve9pK1GRmDnE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxuyFQuwX4fP1pi9CoFJud3mHFmzCz7GCrAA90JGKKhZnJKxxL
	zz7MntwCUPfvWoXDvPt3/16c3uMFF43EtDO7N5ZIOhuUamo8Z27IJmORZOFFPeT9Ueg=
X-Gm-Gg: ASbGncuD3HV1h6iICDf9PXL3AI1A/MG+tm3UD79CLeK9Equ52jYcmOi3MZG9vRMn4/w
	CAopuDfSCzjiQ15TR/FHG7s0vn0KVWY1Fcjon3lKLcG8y+M6ZMhAJs97TJMBUZXZzgKUX12tMNt
	wb3lrDMfgKaitLGmWk2CXKLpgqmOc0mMOdjCfymsNqGZTy/jVfsAse6nzTQKzw7niUE7YeTfrcP
	eWX2zHiYEqhZevacDTWBy5XJ8Gigm1Fd9vnJmnqLxSrjDPRIs1DWGiabtDwRiJZhT623gODLIu9
	peCT4yuPr457cPNo9b+B2JTTC3mH9LwyI+vs+YKzdW3Ycp2jVrVdobrNaI/N3Jvv0nh2k8H3tPI
	Y4lMqYhcRpj+KTFEvHwcjIhttidbpN6NZdD8RteW7dZV5NdKg+j9xVGqtZUsgFhb1+lA6
X-Google-Smtp-Source: AGHT+IEG9A1JcQH+wdTVAVeKvLLO9IN7xUQV2FzilQVc+xKe0AMZGYYJKSglwslI/+w6Csl5DatYZg==
X-Received: by 2002:a05:622a:ca:b0:4a8:19d5:f8a5 with SMTP id d75a77b69052e-4aedbc45df3mr101058131cf.35.1753964538758;
        Thu, 31 Jul 2025 05:22:18 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4aeeec0a6dasm7661341cf.24.2025.07.31.05.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:22:18 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uhSIb-00000000oYE-2zpl;
	Thu, 31 Jul 2025 09:22:17 -0300
Date: Thu, 31 Jul 2025 09:22:17 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	aik@amd.com, lukas@wunner.de, Samuel Ortiz <sameo@rivosinc.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [RFC PATCH v1 06/38] iommufd: Add and option to request for bar
 mapping with IORESOURCE_EXCLUSIVE
Message-ID: <20250731122217.GR26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
 <20250728135216.48084-7-aneesh.kumar@kernel.org>
 <20250728140841.GA26511@ziepe.ca>
 <yq5a34afbdtl.fsf@kernel.org>
 <20250729142917.GF26511@ziepe.ca>
 <aInBxnVIu+lnkzlV@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aInBxnVIu+lnkzlV@yilunxu-OptiPlex-7050>

On Wed, Jul 30, 2025 at 02:55:02PM +0800, Xu Yilun wrote:
> On Tue, Jul 29, 2025 at 11:29:17AM -0300, Jason Gunthorpe wrote:
> > On Tue, Jul 29, 2025 at 01:58:54PM +0530, Aneesh Kumar K.V wrote:
> > > Jason Gunthorpe <jgg@ziepe.ca> writes:
> > > 
> > > > On Mon, Jul 28, 2025 at 07:21:43PM +0530, Aneesh Kumar K.V (Arm) wrote:
> > > >> Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
> > > >
> > > > Why would we need this?
> > > >
> > > > I can sort of understand why Intel would need it due to their issues
> > > > with MCE, but ARM shouldn't care either way, should it?
> > > >
> > > > But also why is it an iommufd option? That doesn't seem right..
> > > >
> > > > Jason
> > > 
> > > This is based on our previous discussion https://lore.kernel.org/all/20250606120919.GH19710@nvidia.com
> > 
> > I suggested a global option, this is a per-device option, and that
> > especially seems wrong for iommufd. If it is per-device that is vfio,
> 
> I think this should be per-device.

IMHO there is no use case for that, it should arguably be global to
the whole kernel.

> The original purpose of this pci_region_request_*() is to prevent
> further mmap/read/write against a vfio_cdev FD which would be used

No way, the VFIO internal mmap should be controled by VFIO not by
request region. If you want to block that it should be blocked by
iommufd telling VFIO that the device is bound which revokes the
mmaps/dmabufs/etc and prevents opening new ones.

The only thing request region should do is prevent /sys/../resource,
/dev/mem users and so on, which is why it can and should be
global. Arguably VFIO should always block those things but
historically hasn't..

There should only be one request region call in VFIO, it should
ideally happen when the VFIO driver probes the device.

Jason
