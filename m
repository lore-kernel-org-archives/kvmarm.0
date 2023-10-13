Received: from out-198.mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819EB3D022
	for <kvmarm@lists.linux.dev>; Fri, 13 Oct 2023 05:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jkgwCzZd"
Date: Fri, 13 Oct 2023 05:43:01 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1697175786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kNOrYS3RMfC5VKdrToezk3EhKhJLCblPKD1dYpu7e7w=;
	b=jkgwCzZdgR6Cy7Nxg0J2L6ZbhwD2AYaH05MjAPmavXrL+f/Ted3isynWFPqLew/aumeUEm
	0A1hjn4ytpw3uAB3ndcMAWlioMqa34wozVbL7CpE6XgPmcHcZRTdpRd2ru0zGHDlTPekzM
	amc7Z8vcQfHQ7nsCKnjdzfQtdWaHjNc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [PATCH v7 06/12] KVM: arm64: PMU: Add a helper to read the
 number of counters
Message-ID: <ZSjY5XCCoji6MjqC@linux.dev>
References: <20231009230858.3444834-1-rananta@google.com>
 <20231009230858.3444834-7-rananta@google.com>
 <ZSXQh2P_l5xcj7zS@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZSXQh2P_l5xcj7zS@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 10, 2023 at 10:30:31PM +0000, Oliver Upton wrote:
> On Mon, Oct 09, 2023 at 11:08:52PM +0000, Raghavendra Rao Ananta wrote:
> > Add a helper, kvm_arm_get_num_counters(), to read the number
> > of counters from the arm_pmu associated to the VM. Make the
> > function global as upcoming patches will be interested to
> > know the value while setting the PMCR.N of the guest from
> > userspace.
> > 
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/pmu-emul.c | 17 +++++++++++++++++
> >  include/kvm/arm_pmu.h     |  6 ++++++
> >  2 files changed, 23 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index a161d6266a5c..84aa8efd9163 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -873,6 +873,23 @@ static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
> >  	return true;
> >  }
> >  
> > +/**
> > + * kvm_arm_get_num_counters - Get the number of general-purpose PMU counters.
> > + * @kvm: The kvm pointer
> > + */
> > +int kvm_arm_get_num_counters(struct kvm *kvm)
> 
> nit: the naming suggests this returns the configured number of PMCs, not
> the limit.
> 
> Maybe kvm_arm_pmu_get_max_counters()?

Following up on the matter -- please try to avoid sending patches that
add helpers without any users. Lifting *existing* logic into a helper
and updating the callsites is itself worthy of a separate patch. But
adding a new function called by nobody doesn't do much, and can easily
be squashed into the patch that consumes the new logic.

-- 
Thanks,
Oliver
