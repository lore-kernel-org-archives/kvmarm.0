Received: from out-204.mta1.migadu.com (out-204.mta1.migadu.com [95.215.58.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1078C1B29B
	for <kvmarm@lists.linux.dev>; Wed, 11 Oct 2023 16:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NFolT7SQ"
Date: Wed, 11 Oct 2023 16:43:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697042602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W5lOz35M0x1aN2ysT8ZX9nxH+qHqZrHg933+lted7Yk=;
	b=NFolT7SQWnRYnQepsthcPuiyATqHBgCcNZXqHbOKimGiOGTnYkFFfNXdysdtNYqaVtEPHI
	el9MaHHAZbCw8+pKn7XFv76rQP/vrnmdhO6u4WsuMCqKPMmTW3OU7Yx3CqgNl8Pg9l92pL
	EgH1ry7d7mCRRSF/00mRb+hS3GbQn9w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
	James Clark <james.clark@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm64: Disallow vPMU for NV guests
Message-ID: <ZSbQpJADvMOHgs3A@linux.dev>
References: <20231011081649.3226792-1-oliver.upton@linux.dev>
 <20231011081649.3226792-2-oliver.upton@linux.dev>
 <281b88c0d74b9260b659e6be579a4984@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <281b88c0d74b9260b659e6be579a4984@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 11, 2023 at 04:54:49PM +0100, Marc Zyngier wrote:
> On 2023-10-11 09:16, Oliver Upton wrote:
> > The existing PMU emulation code is inadequate for use with nested
> > virt. Disable the feature altogether with NV until the hypervisor
> > controls are handled correctly.
> 
> Could you at least mention *what* is missing? Most of the handling
> should identical, and the couple of bits what would need to be
> handled (such as MDCR_EL2) are not covered by this disabling.

Heh, I could've spelled it out a bit more :)

The part that caught my attention is that we don't honor the NSH bit
(hence the next patch), and doing that correctly isn't going to be
trivial. In cases where event filtering is mismatched between vEL2
and EL1 I think we need to reprogram the associated perf events on
nested transitions. We could probably optimize this by using two sets of
perf events to make the switch a bit faster, but that's beside the
point.

Looks like MDCR_EL2.{HPMN,HPME} aren't handled yet either. These are all
easy enough to work on (and my interest is certainly piqued), but it
seems to me PMU+NV isn't going to work out of the gate. It'd be nice to
permit the combination only when we're confident the feature is
complete.

I haven't any strong opinions here though, and you're the one carrying
the whole NV pile in the first place. Up to you what to do here.

-- 
Thanks,
Oliver
