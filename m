Received: from out-32.mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9399C3D99
	for <kvmarm@lists.linux.dev>; Wed, 14 Jun 2023 12:42:01 +0000 (UTC)
Date: Wed, 14 Jun 2023 12:41:53 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686746518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vVgohHr+8y/naKxQ8awxRJilZdLTVuzyEw7fAcdG64A=;
	b=vXtoWCWGoWUj4X5qVEdoEmWU3Lyx+lZaNsCO4a9ZC729SBpKTdzHAGvXWIq1eE6BaF+f5C
	I3pxRCZKlinyC6IeKMy0sqHImLvoZTu17N/DA0fxQBR4wOWyX1CWIFKgz0mI3m8GDtNr7l
	D7Q2U/q5bDPVLB5U2ddsJl1pTPLiTaI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Reiji Watanabe <reijiw@google.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Jing Zhang <jingzhangos@google.com>,
	Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 1/1] KVM: arm64: PMU: Avoid inappropriate use of host's
 PMUVer
Message-ID: <ZIm1kdFBfXYMdfbV@linux.dev>
References: <20230610194510.4146549-1-reijiw@google.com>
 <ZIUb/ozyloOm6DfY@linux.dev>
 <20230611045430.evkcp4py4yuw5qgr@google.com>
 <ZIV7+yKUdRticwfF@linux.dev>
 <20230611160105.orvjohigsaevkcrf@google.com>
 <ZIdzxmgt8257Kv09@linux.dev>
 <20230613002633.gdttlmn5bnkr4l5i@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613002633.gdttlmn5bnkr4l5i@google.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jun 12, 2023 at 05:26:33PM -0700, Reiji Watanabe wrote:
> On Mon, Jun 12, 2023 at 09:36:38PM +0200, Oliver Upton wrote:
> > I'd rather we start exposing the feature when we provide all the
> > necessary detail.
> 
> To confirm, are you suggesting to stop exposing the event even on hosts
> w/o PMMIR_EL1 until KVM gets ready to support PMMIR_EL1 ?
> (guests on those hosts won't get PMMIR_EL1 in any case though?)
> Could you please explain why ?
> 
> Perhaps I think I would rather keep the code as it is?
> (since I'm simply not sure what would be the benefits of that)

I'd rather not keep confusing code hanging around. The fact that KVM
does not support the STALL_SLOTS event is invariant of both the hardware
PMU implementation and the userspace value for the ID register field.
Let's make sure the implementation exactly matches this position.

-- 
Thanks,
Oliver
