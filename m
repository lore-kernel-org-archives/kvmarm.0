Received: from out-209.mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14E0C153
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 05:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CpzQZCPj"
Date: Tue, 17 Oct 2023 05:55:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697522119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PDw0gF01ql4reoKKcsChe+eJJjJlQChkycqYZXo087I=;
	b=CpzQZCPjIgSyy+TVXsiZSJsljM+rypsTxolK50cQs8vm+k+ybPDlpClfb7BT2iAujvoHed
	MBbHByMOp1dlPjF7/HOTbHrGb7hqfxuFjnIXVqzTeRx/KERpa7yQxgFbtLfEEvIV6eu0ch
	4fh5JVCsa8Eo9h1i/BNSxRDHPv+OTVg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Sebastian Ott <sebott@redhat.com>, Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [PATCH v7 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
Message-ID: <ZS4hwr4Y4b-9aFYy@linux.dev>
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com>
 <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
 <ZS2L6uIlUtkltyrF@linux.dev>
 <CAJHc60wvMSHuLuRsZJOn7+r7LxZ661xEkDfqxGHed5Y+95Fxeg@mail.gmail.com>
 <ZS4hGL5RIIuI1KOC@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZS4hGL5RIIuI1KOC@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 17, 2023 at 05:52:24AM +0000, Oliver Upton wrote:
> On Mon, Oct 16, 2023 at 02:35:52PM -0700, Raghavendra Rao Ananta wrote:
> 
> [...]
> 
> > > What's the point of doing this in the first place? The implementation of
> > > kvm_vcpu_read_pmcr() is populating PMCR_EL0.N using the VM-scoped value.
> > >
> > I guess originally the change replaced read_sysreg(pmcr_el0) with
> > kvm_vcpu_read_pmcr(vcpu) to maintain consistency with others.
> > But if you and Sebastian feel that it's an overkill and directly
> > getting the value via vcpu->kvm->arch.pmcr_n is more readable, I'm
> > happy to make the change.
> 
> No, I'd rather you delete the line where PMCR_EL0.N altogether.

... where we set up ...

> reset_pmcr() tries to initialize the field, but your
> kvm_vcpu_read_pmcr() winds up replacing it with pmcr_n.

-- 
Thanks,
Oliver
