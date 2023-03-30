Received: from out-38.mta0.migadu.com (out-38.mta0.migadu.com [91.218.175.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78EE1C05
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 06:42:54 +0000 (UTC)
Date: Thu, 30 Mar 2023 06:42:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1680158572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UUNTmfY0fOvsY7bCYHRcY0CifEjhLb/ZBB0rxOVTkWw=;
	b=diSsM9vVRakxTDZtGuQYw6QXrbLjEJp1FY2lxYGXXgZJYd2XODjZapKBAQ05I717+/PMmA
	Sfmsekn6yMOLJWjfEq/9DUrrHY8rgQv96YwNTJLz+ea7Qrcu5yeXXD8Uzzz7uUXhQfx8Ot
	KHgrDaLYVm+XPEs9Gtr5EtgdMB4vVR8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>, Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: Re: [PATCH v3 05/18] KVM: arm64: timers: Allow physical offset
 without CNTPOFF_EL2
Message-ID: <ZCUvZ9yhfRSKRb3n@linux.dev>
References: <20230324144704.4193635-1-maz@kernel.org>
 <20230324144704.4193635-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324144704.4193635-6-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

Hey Marc,

On Fri, Mar 24, 2023 at 02:46:51PM +0000, Marc Zyngier wrote:
> CNTPOFF_EL2 is awesome, but it is mostly vapourware, and no publicly
> available implementation has it. So for the common mortals, let's
> implement the emulated version of this thing.
> 
> It means trapping accesses to the physical counter and timer, and
> emulate some of it as necessary.
> 
> As for CNTPOFF_EL2, nobody sets the offset yet.

Did you consider implementing a 'fast' exit handler for counter reads?
When I took a stab at this a long time ago I had something similar [*].
Since physical counter emulation is going to effectively be used by all
systems out there right now it might be worth giving the best emulation
implementation we can.

[*]: https://lore.kernel.org/kvmarm/20210916181510.963449-9-oupton@google.com/

-- 
Thanks,
Oliver
