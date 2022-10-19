Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E2528E8
	for <kvmarm@lists.linux.dev>; Wed, 19 Oct 2022 11:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FE8C433C1;
	Wed, 19 Oct 2022 11:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666180651;
	bh=7dYUeVMl0ljljG/gREOSgn67ek1PhgEFY91pBBbAxwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FhjdSpJQ8uYcQJVX7CfVuAb3mQh4YGQqss/P9iO096UxFvlaBpt8TtUeMiQUKr+3V
	 WcUM4gQVr2OqxxwGV+nwGWU1ZUqiu92l79qBkuCNdrrbvSCqvNdfkhpRDyRQswyL1B
	 3ZyDIN8dqx/moSdaMaGnzcc4cQHPozAtsWQDz3qO5yqJGPucL/QQlP4z62H94vEfum
	 r4OdzPOlDTUErlKTnWVSfvak8jI3ThyYwH6Lh5QOp7zHuwqS9nhH4IRGLvrJzaVPXb
	 PV6CJdmI8XxYHpt1OdJwfLfz0CqX98/5bA8mOa5ruSs1z+O5VCtfA1O6YRa011A240
	 /qdl2LNThAvjA==
Date: Wed, 19 Oct 2022 12:57:24 +0100
From: Will Deacon <will@kernel.org>
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Chao Peng <chao.p.peng@linux.intel.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mark Rutland <mark.rutland@arm.com>, Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/25] KVM: arm64: Add infrastructure to create and
 track pKVM instances at EL2
Message-ID: <20221019115723.GA4067@willie-the-truck>
References: <20221017115209.2099-1-will@kernel.org>
 <20221017115209.2099-13-will@kernel.org>
 <Y07VaRwVf3McX27a@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y07VaRwVf3McX27a@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Oct 18, 2022 at 04:33:45PM +0000, Quentin Perret wrote:
> On Monday 17 Oct 2022 at 12:51:56 (+0100), Will Deacon wrote:
> > +void pkvm_hyp_vm_table_init(void *tbl)
> > +{
> > +	WARN_ON(vm_table);
> > +	vm_table = tbl;
> > +}
> 
> Uh, why does this one need to be exposed outside pkvm.c ?

We need to initialise the table using the memory donated by the host
on the __pkvm_init path. That's all private to nvhe/setup.c, so rather
than expose the raw pointers (of either the table or the donated memory),
we've got this initialisation function instead which is invoked by
__pkvm_init_finalise() on the deprivilege path.

Happy to repaint it if you have a patch?

Will
