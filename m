Received: from out-67.mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B201D610B
	for <kvmarm@lists.linux.dev>; Mon, 31 Jul 2023 16:41:09 +0000 (UTC)
Date: Mon, 31 Jul 2023 09:41:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1690821667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VOFw4Kj4hJRr7MmhNaCZHU6GMvxI4dnHBIGrUAh9zjc=;
	b=VvIXFTWW6k2oIyw87XotFIxTJjXZuSPPxVwOWsEHKndo+pcHaB450FDHoSsL6Vc3AL7W4I
	a61XEJt5N4DiKGw7HSEnyo/KkHHmk98WZjk/1HZaQ6J8d2PniPZ6CvR7aIRp+ynreRfr1B
	Rp5nYB8V2IxbMyyIF5V6o/UCAwKldhM=
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
Subject: Re: [PATCH v2 2/5] KVM: arm64: PMU: Disallow vPMU on non-uniform
 PMUVer systems
Message-ID: <ZMfkHrRNGNA7XLso@linux.dev>
References: <20230728181907.1759513-1-reijiw@google.com>
 <20230728181907.1759513-3-reijiw@google.com>
 <ZMQckrDB7tg9gPfw@linux.dev>
 <CAAeT=FyC42s=kcS3QTC6A-s6EZjhoQL7XJyxWCb5YyisJrQvdg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeT=FyC42s=kcS3QTC6A-s6EZjhoQL7XJyxWCb5YyisJrQvdg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Jul 31, 2023 at 04:54:04AM -0700, Reiji Watanabe wrote:
> Hi Oliver,
> 
> > This doesn't actually disallow userspace from configuring a vPMU, it
> > only hides the KVM cap. kvm_host_pmu_init() will still insert the host
> > PMU instance in the list of valid PMUs, and there doesn't appear to be
> > any check against the static key anywhere on that path.
> 
> In v6.5-rc3, which I used as the base, or even in v6.5-rc4,
> it appears kvm_reset_vcpu() checks against the static key.
> So, the initial KVM_ARM_VCPU_INIT with vPMU configured will
> fail on the systems.  Or am I missing something ? (Or is that
> going to be removed by other patches that are already queued?)

No, I definitely missed something, sorry for the noise! I had only
checked the PMU attributes, forgot about feature flags for a moment.

> > I actually prefer where we flip the static key, as PMU context switching
> > depends on both KVM support as well as the PMU driver coming up successfully.
> > Instead, you could hoist the check against the sanitised PMU version into
> > kvm_host_pmu_init(), maybe something like:
> 
> Thank you, it looks better.  I will fix this in v3.

Sounds good, thanks!

--
Best,
Oliver
