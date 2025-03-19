Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D952D35963;
	Wed, 19 Mar 2025 13:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742392634; cv=none; b=O75VTNV2bN9//h1FKz+TxzahdHxhzT1ZTUklWgD6hIWIzjflLIUpPUVRYSww+a4NLTDvY5NwLrIf0DFO6A+06EJ8rozKWoqPkLk0Qlbf/PFHuRxub9U2L3u5KSHpemzyOR5wisv4dssskPiGbrqXXvy3cUQ1h7FcSbDI/yOdoPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742392634; c=relaxed/simple;
	bh=jQ1cEr/6AbNtz49EtndMJS/a0gCN5LVsu6g9KKQFAjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDkD/f0fAlZRFGiso+rjCRqyTJfJmMINVymfFeLsK0SoUEg438jO3TM5Arp5b/x7yi6P9EnheVHFG5c/bLD9pP0PTjVEhF4gzzbmHuqZPUlUwS9vlx4t6C/o1wUGs/o2Ey/1l17nOQ4R9uQojr3nTydxmEgEs4GOl8uhvqpna7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=psc+4RN6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="psc+4RN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1DEC4CEE4;
	Wed, 19 Mar 2025 13:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742392633;
	bh=jQ1cEr/6AbNtz49EtndMJS/a0gCN5LVsu6g9KKQFAjQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=psc+4RN60eKgIkfk01Oa1tQs/VmjegMBVZjtFSq6b9IDRKqtw4ZIqGWlPZxAhNtKf
	 Z3y8ChxfZjafO6QobtaPFvXcfn2CMjZMi3wGeT8Efr6UpPHeoC3ZizHPZm3kuV13q7
	 Vo4rJOeaqm3nYPa8M4rmbFQnI2BUJw0ic37STMQY=
Date: Wed, 19 Mar 2025 06:55:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>,
	Gavin Shan <gshan@redhat.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Fuad Tabba <tabba@google.com>
Subject: Re: [PATCH 6.12 8/8] KVM: arm64: Eagerly switch ZCR_EL{1,2}
Message-ID: <2025031946-myself-underling-0f4d@gregkh>
References: <20250314-stable-sve-6-12-v1-0-ddc16609d9ba@kernel.org>
 <20250314-stable-sve-6-12-v1-8-ddc16609d9ba@kernel.org>
 <019afc2d-b047-4e33-971c-7debbbaec84d@redhat.com>
 <86r02tmldh.wl-maz@kernel.org>
 <Z9qaW_H9UFqdc1bI@J2N7QTR9R3>
 <83ba4e5b-7700-4527-8376-2c60507bd0d7@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83ba4e5b-7700-4527-8376-2c60507bd0d7@sirena.org.uk>

On Wed, Mar 19, 2025 at 01:02:30PM +0000, Mark Brown wrote:
> On Wed, Mar 19, 2025 at 10:20:11AM +0000, Mark Rutland wrote:
> > On Wed, Mar 19, 2025 at 09:15:54AM +0000, Marc Zyngier wrote:
> 
> > > The result is that this change is turning a perfectly valid HYP VA
> > > into... something. Odds are that the masking/patching will not mess up
> > > the address, but this is completely buggy anyway. In general,
> > > kern_hyp_va() is not an idempotent operation.
> 
> > IIUC today it *happens* to be idempotent, but as you say that is not
> > guaranteed to remain the case, and this is definitely a logical bug.
> 
> I think so, yes.  I suspect the idempotency confused me.
> 
> > > Greg, it may be more prudent to unstage this series from 6.12-stable
> > > until we know for sure this is the only problem.
> 
> > As above, likewise with the v6.13 version.
> 
> Yes, please unstage these.  I'll send out new versions.

All now dropped from both queues, thanks.

greg k-h
