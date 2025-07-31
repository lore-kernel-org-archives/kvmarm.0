Received: from sinmsgout01.his.huawei.com (sinmsgout01.his.huawei.com [119.8.177.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0372C08C2;
	Thu, 31 Jul 2025 13:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=119.8.177.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753968190; cv=none; b=WYktB58cTvMZoUt8OH0UFydwzbFM4elEc8fAE5TKM7vn8DOEu711pixpsVAQwwnSMweVYljJriyk4QnBtvA3cpGDx25n2A7a2Zu7uCAKJaxKeTQOcj7vGM0ciraYtWvUlV3rN/Pz5R00u967se3XpqoEWF/nKJf3tx2zFrmcNDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753968190; c=relaxed/simple;
	bh=ylSWYew4DfoO+Ep4rDDeoRAOzKWkyzsvf10jdAPVJKs=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BjdIijPdzZ3LERtbynCFdSW74di4XPJzc5UHOXklyTFkB+omV1gPsYLJCtl5jT+5PfDtao6Rhr6tMhcsYh6B0fQQfB/SxcUbNMFJJHvH8mGD07JiitF3oCHjZVOoMt48X1nS/Wsibw6H6CGLq5j0o6Sx8sVgcl2N3aUQGQM3+mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=jrorTtlG; arc=none smtp.client-ip=119.8.177.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="jrorTtlG"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=++Ul7pOXhQYTZqPFLwUChurRVzJ0hpxMT+1uztC97zc=;
	b=jrorTtlGUACY8MmSwYPSOO/hRhiHt/OPDkn5sJe79/18ur0SnNXeM0hAVOpnMKascymsch3pd
	iSMH5orswV5xVxBDRUSMBrF6lPmVarteVIBUNYr50kJalaHWE4I1ciniVVsNXRx9DpjGEmYOH/o
	uo5Z/mnqudZINFvTnLHB4lE=
Received: from frasgout.his.huawei.com (unknown [172.18.146.35])
	by sinmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4bt8qd4P3Bz1P7Jt;
	Thu, 31 Jul 2025 21:21:33 +0800 (CST)
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bt8qH75V2z6D9Ym;
	Thu, 31 Jul 2025 21:21:15 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 8373A1402EA;
	Thu, 31 Jul 2025 21:22:53 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 31 Jul
 2025 15:22:52 +0200
Date: Thu, 31 Jul 2025 14:22:50 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Aneesh Kumar K.V <aneesh.kumar@kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, <linux-coco@lists.linux.dev>,
	<kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <aik@amd.com>, <lukas@wunner.de>, Samuel
 Ortiz <sameo@rivosinc.com>, Xu Yilun <yilun.xu@linux.intel.com>, Suzuki K
 Poulose <Suzuki.Poulose@arm.com>, Steven Price <steven.price@arm.com>,
	"Catalin Marinas" <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
	"Will Deacon" <will@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	<gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH v1 11/38] KVM: arm64: CCA: register host tsm
 platform device
Message-ID: <20250731142250.00005651@huawei.com>
In-Reply-To: <20250731121133.GP26511@ziepe.ca>
References: <20250728135216.48084-1-aneesh.kumar@kernel.org>
	<20250728135216.48084-12-aneesh.kumar@kernel.org>
	<20250729181045.0000100b@huawei.com>
	<20250729231948.GJ26511@ziepe.ca>
	<yq5aqzxy9ij1.fsf@kernel.org>
	<20250730113827.000032b8@huawei.com>
	<20250731121133.GP26511@ziepe.ca>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500001.china.huawei.com (7.191.163.213) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Thu, 31 Jul 2025 09:11:33 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Wed, Jul 30, 2025 at 11:38:27AM +0100, Jonathan Cameron wrote:
> > On Wed, 30 Jul 2025 14:12:26 +0530
> > "Aneesh Kumar K.V" <aneesh.kumar@kernel.org> wrote:
> >   
> > > Jason Gunthorpe <jgg@ziepe.ca> writes:
> > >   
> > > > On Tue, Jul 29, 2025 at 06:10:45PM +0100, Jonathan Cameron wrote:
> > > >    
> > > >> > +static struct platform_device cca_host_dev = {    
> > > >> Hmm. Greg is getting increasingly (and correctly in my view) grumpy with
> > > >> platform devices being registered with no underlying resources etc as glue
> > > >> layers.  Maybe some of that will come later.    
> > > >
> > > > Is faux_device a better choice? I admit to not knowing entirely what
> > > > it is for..  
> > 
> > I'll go with a cautious yes to faux_device. This case of a glue device
> > with no resources and no reason to be on a particular bus was definitely
> > the intent but I'm not 100% sure without trying it that we don't run
> > into any problems.
> > 
> > Not that many examples yet, but cpuidle-psci.c looks like a vaguely similar
> > case to this one.  
> > 
> > All it really does is move the location of the device and
> > smash together the device registration with probe/remove.
> > That means the device disappears if probe() fails, which is cleaner
> > in many ways than leaving a pointless stub behind.
> > 
> > Maybe it isn't appropriate it if is actually useful to rmmod/modprobe the
> > driver.   
> 
> Yeah, exactly. Can a TSM driver even be modular? If it has to be built
> in then there is no reason to do this:
> 
> > > The goal is to have tsm class device to be parented by the platform
> > > device.  
> 
> IMHO the only real point of that is to trigger module autoloading.
> 
> Otherwise the tsm core should accept NULL as the parent pointer during
> registration, it probably already does..

If you mean create a class device with no parent, that's also something
we are slowly trying to fix.  Reminds me that fixing up more perf devices
is still on my todo list.

Should be a child of something, so maybe that is a good reason for a
faux_device here if there is nothing else to use.

Jonathan

> 
> Jason

