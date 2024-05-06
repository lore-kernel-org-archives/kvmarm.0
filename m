Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C774157461
	for <kvmarm@lists.linux.dev>; Mon,  6 May 2024 17:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715016949; cv=none; b=l/CHmMNlywbXA/HeZhqiJ52paWI1vCBZyW2vli54t8xrhyb5+5XnZSlPkhFs2ol75HAuUElQfir4T1vEdB2BwxGmI4hEDduvNiRR2nbnPS3e7kceyMy2YQ3otzOqdFUPf8la+aZgZ5eHDbELmJuG8sE6x3+s+qyig757pHG72io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715016949; c=relaxed/simple;
	bh=I+RW6veN4unpTEFFJXNx4pgzJttst04sYwFP54UO7nQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BbCBfZRyxw5BbGtko/Sfel6LoE+juCjIQtlgK1NvMpMQu3dfLkZ0LVEQX+wKCTayXQQZjjMo+GPcfQLTlG7hezNYBp5SNo+P6d+9C43mh7eZyOoEk9BBwZsJEOACWRSLvr1VBjotdhPBGWOUegZhhV1Lv+q7rYkVcboNX8Zoc4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=T/fNKyNO; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="T/fNKyNO"
Date: Mon, 6 May 2024 17:35:38 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1715016944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RgKXusuHKHkq5SgVIZ+1zKT/7zi+FklfTPfVp22pWBQ=;
	b=T/fNKyNO24FaKcrUIRzbjfH2nva1HAe9HtRGPfJMYqv3481QWFoaZpHSwMwVcy5vWLWPgV
	A3rF5llZjnPnHNzAiV+CC5KpFoly1UO/rcAV/1qW4o4gQ0Ij76L68+Y9ge3V0MnIEam3HZ
	IJo+M20Qlvwf43gH6F3Mbci0Oi3xXUg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 1/2] KVM: arm64: Fix hvhe/nvhe early alias parsing
Message-ID: <ZjkU6qyd2IRcUi2M@linux.dev>
References: <20240501163400.15838-1-will@kernel.org>
 <20240501163400.15838-2-will@kernel.org>
 <ZjJ_mdsCa_fAy_NT@linux.dev>
 <20240502102030.GA16965@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240502102030.GA16965@willie-the-truck>
X-Migadu-Flow: FLOW_OUT

On Thu, May 02, 2024 at 11:20:30AM +0100, Will Deacon wrote:
> Hey Oliver,
> 
> On Wed, May 01, 2024 at 05:44:57PM +0000, Oliver Upton wrote:
> > On Wed, May 01, 2024 at 05:33:59PM +0100, Will Deacon wrote:
> > > Booting a kernel with "arm64_sw.hvhe=1 kvm-arm.mode=nvhe" on the
> > > command-line results in KVM initialising using hVHE, whereas one might
> > > expect the latter option to override the former.
> > > 
> > > Fix this by adding "arm64_sw.hvhe=0" to the alias expansion for
> > > "kvm-arm.mode=nvhe".
> > 
> > Hmm, I wonder if it'd be better to just evaluate the sanitised VH field
> > in hvhe_possible(). Otherwise I worry about keeping aliases in sync when
> > new command line options come along.
> > 
> > This is similar to what we had before commit 35876f35f482 ("arm64:
> > cpufeature: Add helper to test for CPU feature overrides") w/ the added
> > use of the sanitised reg.
> > 
> > Thoughts?
> 
> I think that goes wonky when you have the arguments the other way around:
> 
> 	"kvm-arm.mode=nvhe arm64_sw.hvhe=1"
> 
> would end up using nVHE.

Right... What I was hoping to get at is a simple set of arguments to
test protected + nVHE, even on systems that support VHE. Although I
suppose:

  "kvm-arm.mode=protected id_aa64mmfr1.vh=0 arm64_sw.hvhe=0"

isn't that bad and would preserve precedence of later args. So, FWIW:

Acked-by: Oliver Upton <oliver.upton@linux.dev>

-- 
Thanks,
Oliver
