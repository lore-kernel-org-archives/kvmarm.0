Received: from out-33.mta0.migadu.com (out-33.mta0.migadu.com [91.218.175.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23C827710
	for <kvmarm@lists.linux.dev>; Tue, 16 May 2023 16:31:36 +0000 (UTC)
Date: Tue, 16 May 2023 16:31:29 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1684254694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1uT5678vYdu1Mhydj6fwo4gp85uMJ7JLyMNfrcXuqD4=;
	b=uYEuGCosTFAO6PtxhVykb0npHnpsVArogzuKafwhxu14acARVet43TgjgS35aP28KVfv4m
	o8weizNlix/9EDbjD0LFisZapuPrmCAI0jWa5ufq/7ZJ1fqn2pjtCw+q1qrpOug2CeN55y
	FRSy9kWr/T+YAQX/7EXGDsfZ9IC1oU4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Cornelia Huck <cohuck@redhat.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
	KVMARM <kvmarm@lists.linux.dev>,
	ARMLinux <linux-arm-kernel@lists.infradead.org>,
	Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v8 0/6] Support writable CPU ID registers from userspace
Message-ID: <ZGOv4ZA9qxcC5wKv@linux.dev>
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <2ef9208dabe44f5db445a1061a0d5918@huawei.com>
 <868rdomtfo.wl-maz@kernel.org>
 <1a96a72e87684e2fb3f8c77e32516d04@huawei.com>
 <87cz30h4nx.fsf@redhat.com>
 <867ct8mnel.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <867ct8mnel.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, May 16, 2023 at 02:11:30PM +0100, Marc Zyngier wrote:
> On Tue, 16 May 2023 12:55:14 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
> > 
> > Do you have more concrete ideas for QEMU CPU models already? Asking
> > because I wanted to talk about this at KVM Forum, so collecting what
> > others would like to do seems like a good idea :)
> 
> I'm not being asked, but I'll share my thoughts anyway! ;-)
> 
> I don't think CPU models are necessarily the most important thing.
> Specially when you look at the diversity of the ecosystem (and even
> the same CPU can be configured in different ways at integration
> time). Case in point, Neoverse N1 which can have its I/D caches made
> coherent or not. And the guest really wants to know which one it is
> (you can only lie in one direction).
> 
> But being able to control the feature set exposed to the guest from
> userspace is a huge benefit in terms of migration.
> 
> Now, this is only half of the problem (and we're back to the CPU
> model): most of these CPUs have various degrees of brokenness. Most of
> the workarounds have to be implemented by the guest, and are keyed on
> the MIDR values. So somehow, you need to be able to expose *all* the
> possible MIDR values that a guest can observe in its lifetime.
> 
> I have a vague prototype for that that I'd need to dust off and
> finish, because that's also needed for this very silly construct
> called big-little...

And the third half of the problem is all of the other IP bits that get
strung together into an SOC :) Errata that live beyond the CPU can
become guest-visible (interconnect for example) and that becomes a bit
difficult to express to the guest OS. So, beyond something like a
big-little VM where the rest of the IP should be shared, I'm a bit
fearful of migrating a VM cross-system.

But hey, userspace is in the drivers seat and it can do as it pleases.

Hopefully we wouldn't need a KVM-specific PV interface for MIDR
enumeration. Perhaps the errata management spec could be expanded to
describe a set of CPU implementations and associated errata...

-- 
Thanks,
Oliver
