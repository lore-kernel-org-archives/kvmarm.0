Received: from out-202.mta0.migadu.com (out-202.mta0.migadu.com [91.218.175.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD436208AB
	for <kvmarm@lists.linux.dev>; Tue, 24 Oct 2023 19:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H0ZDTUBj"
Date: Tue, 24 Oct 2023 19:21:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1698175273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XkPBe+q2Fd8HwrowwRNbd02bJEcCWTElAobJsH4r7wQ=;
	b=H0ZDTUBjF9ElzypQp7tDrswPltNTX86gbYWyDZZcr37nX42M7lC0JCUdH66liiWLqEf62x
	vbAateyLcy9vQZBTrutUI12pqaXhm6I/9kqU5mOOjEiE+QXGw4Tih7l7eyYc0ZVmx3+WZD
	8AfOKRM+Aa5R2lVAU8sPoOnpjzQqJ3Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Ananta <rananta@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 00/13] KVM: arm64: PMU: Allow userspace to limit the
 number of PMCs on vCPU
Message-ID: <ZTgZJNbtzyGcwhwt@linux.dev>
References: <20231020214053.2144305-1-rananta@google.com>
 <86r0ll4267.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86r0ll4267.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 23, 2023 at 07:35:44PM +0100, Marc Zyngier wrote:
> On Fri, 20 Oct 2023 22:40:40 +0100,
> Raghavendra Rao Ananta <rananta@google.com> wrote:
> > 
> > Hello,
> > 
> > The goal of this series is to allow userspace to limit the number
> > of PMU event counters on the vCPU.  We need this to support migration
> > across systems that implement different numbers of counters.
> 
> FWIW, I've pushed out a branch[1] with a set of fixes that address
> some of the comments I had on this series. Feel free to squash them in
> your series as you see fit.

I did a second round of fixes on top of what Marc has and pushed that to
a branch [*]. If everything looks good I'll take it for 6.7.

[*] https://git.kernel.org/pub/scm/linux/kernel/git/oupton/linux.git/log/?h=kvm-arm64/pmu_pmcr_n

-- 
Thanks,
Oliver
