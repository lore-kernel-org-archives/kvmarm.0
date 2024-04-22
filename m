Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89929153BFE
	for <kvmarm@lists.linux.dev>; Mon, 22 Apr 2024 18:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713810912; cv=none; b=de4xytsmqMOKixcFnHBFjT7UXQHrswbKJZ6tm2qlkwzdCmlshvACe5HmEDon1aM/KPATcmXoq3rm91WsPp3PshV68KM4yHmPZq0dPBNjSM5GwxGiqgFC4yerY7xwui1xZ9V8t/ElSuGKMG0kR/I+N8YLCEtlbnt3FCgh8bO0G6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713810912; c=relaxed/simple;
	bh=vPW2i05EJnPPweuULNzL9jISmZ7tGJHxGpSZTuYIqiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Me7X12QX3NrH4pqCFmFjTM13MO70DKcjtKVcTYmSU1bZz/pS8ROsWgN5NB+b86YpZsNWSGtwFHOll7i1kaYCdURuJAN0vJBhT9nEr0wrCtdDduiwc99XlE1QEFcDGzakEHuYiVmYG1jqSGfAXDjZkrfYTWqMjtnVbupdYiH8rAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AcAkorhm; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AcAkorhm"
Date: Mon, 22 Apr 2024 18:35:00 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713810908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ySQUiDA2RVwsyiUV/iGE9jeOeI33cd+uXoIm7xgoIK0=;
	b=AcAkorhmxQ8X+vEZNmaoInjwjz4FKEHiUwdTZxP3DQf6FTVts70QMcE15wV8SyNNPSEUXy
	dHJTI/cSPBCDUU+xEXnalcWXexgQ7W/5oBHFIP4/aRXu+x8Z71DhAQGKFtMd/gG3OqINnJ
	g47N6vt+y5N2sqrtnaMSn8Q2CNBdYmM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 01/19] KVM: Treat the device list as an rculist
Message-ID: <Ziat1I2zvEg1HGoQ@linux.dev>
References: <20240419223842.951452-1-oliver.upton@linux.dev>
 <20240419223842.951452-2-oliver.upton@linux.dev>
 <ZiasvXKbunQwDgJ6@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZiasvXKbunQwDgJ6@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Apr 22, 2024 at 11:30:21AM -0700, Sean Christopherson wrote:
> On Fri, Apr 19, 2024, Oliver Upton wrote:
> > A subsequent change to KVM/arm64 will necessitate walking the device
> > list outside of the kvm->lock. Prepare by converting to an rculist. This
> > has zero effect on the VM destruction path, as it is expected every
> > reader is backed by a reference on the kvm struct.
> > 
> > On the other hand, ensure a given device is completely destroyed before
> > dropping the kvm->lock in the release() path, as certain devices expect
> > to be a singleton (e.g. the vfio-kvm device).
> 
> Oof, that vfio-kvm code is nasty.  To help prevent future breakage, and to make
> it more obvious that this code *doesn't* introduce a bug in kvm_vfio_create(),
> what about added a lockdep assertion?

Agreed, and great timing, I was just about to send v3.

-- 
Thanks,
Oliver
