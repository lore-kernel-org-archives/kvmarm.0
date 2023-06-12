Received: from out-52.mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3B7A937
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 19:36:42 +0000 (UTC)
Date: Mon, 12 Jun 2023 21:36:38 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686598600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sHOwRria8WiDlXjDW/If+zix7QRbjzZycNIlyopWw1E=;
	b=Nj+wHbsVq4H20uyeoZmzpV3GNcl+aFzofDCBDUjH8vFfG4bXqmwGfba/FxsZ6f85vVQkNG
	auPFdIo+2EyWYeqMP52EbjfW4bPtAO7c8YmtM5iqaBcW7Dk+CKeHhnu3yvwm7DOMtzZEd2
	/AFLIrJncbFjbydlQWl6+teycrVojzE=
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
Message-ID: <ZIdzxmgt8257Kv09@linux.dev>
References: <20230610194510.4146549-1-reijiw@google.com>
 <ZIUb/ozyloOm6DfY@linux.dev>
 <20230611045430.evkcp4py4yuw5qgr@google.com>
 <ZIV7+yKUdRticwfF@linux.dev>
 <20230611160105.orvjohigsaevkcrf@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230611160105.orvjohigsaevkcrf@google.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 11, 2023 at 09:01:05AM -0700, Reiji Watanabe wrote:

[...]

> > Suppose KVM is running on a v3p5+ implementation, but userspace has set
> > ID_AA64DFR0_EL1.PMUVer to v3p0. In this case the read of PMCEID1_EL0 on
> > the preceding line would advertise the STALL_SLOT event, and KVM fails
> > to mask it due to the ID register value. The fact we do not support the
> > event is an invariant, in the worst case we wind up clearing a bit
> > that's already 0.
> 
> As far as I checked ArmARM, the STALL_SLOT event can be supported on
> any PMUv3 version (including on v3p0).  Assuming that is true, I don't
> see any reason to not expose the event to the guest in this particular
> example. Or can the STALL_SLOT event only be implemented from certain
> versions of PMUv3 ?

Well, users of the event don't get the full picture w/o PMMIR_EL1.SLOTS,
which is only available on v3p4+. We probably should start exposing the
register + event (separate from this change).

> > This is why I'd suggested just unconditionally clearing the bit. While
> 
> When the hardware supports the STALL_SLOT event (again, I assume any
> PMUv3 version hardware can support the event), and the guest's PMUVer
> is older than v3p4, what is the reason why we want to clear the bit ?

What's the value of the event w/o PMMIR_EL1? I agree there's no
fundamental issue with letting it past, but I'd rather we start
exposing the feature when we provide all the necessary detail.

--
Thanks,
Oliver
