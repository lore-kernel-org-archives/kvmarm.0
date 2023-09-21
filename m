Received: from out-220.mta1.migadu.com (out-220.mta1.migadu.com [95.215.58.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B074E26F
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 18:20:31 +0000 (UTC)
Date: Thu, 21 Sep 2023 18:20:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1695320429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eDVj7vBYL4POoo6A10PvdiayJKcc6WHRQ4O+JZKL8UQ=;
	b=PUfudyk6ReRH+2s9ORiXaDcNJc1LVPsIdVjHGxtialJrGPv8q0nhuk/Zz2yjSMIP2NuhYt
	g2PsOwBPZiuEvi/YVVdOIYS3BH9lalo4i7M/KfR11Yk/7yg2TN7/Wp7ZdsKxFpLRN33oDm
	aoMzv/WbffsVif7m0tpLKUgfICd9A7I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Cornelia Huck <cohuck@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v10 01/12] KVM: arm64: Allow userspace to get the
 writable masks for feature ID registers
Message-ID: <ZQyJaUVZZEKHiUMe@linux.dev>
References: <20230920183310.1163034-1-oliver.upton@linux.dev>
 <20230920183310.1163034-2-oliver.upton@linux.dev>
 <874jjn26oq.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jjn26oq.fsf@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Sep 21, 2023 at 11:53:41AM +0200, Cornelia Huck wrote:
> On Wed, Sep 20 2023, Oliver Upton <oliver.upton@linux.dev> wrote:
> 
> > From: Jing Zhang <jingzhangos@google.com>
> >
> > While the Feature ID range is well defined and pretty large, it isn't
> > inconceivable that the architecture will eventually grow some other
> > ranges that will need to similarly be described to userspace.
> >
> > Add a VM ioctl to allow userspace to get writable masks for feature ID
> > registers in below system register space:
> > op0 = 3, op1 = {0, 1, 3}, CRn = 0, CRm = {0 - 7}, op2 = {0 - 7}
> > This is used to support mix-and-match userspace and kernels for writable
> > ID registers, where userspace may want to know upfront whether it can
> > actually tweak the contents of an idreg or not.
> >
> > Add a new capability (KVM_CAP_ARM_SUPPORTED_FEATURE_ID_RANGES) that
> > returns a bitmap of the valid ranges, which can subsequently be
> > retrieved, one at a time by setting the index of the set bit as the
> > range identifier.
> >
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Suggested-by: Cornelia Huck <cohuck@redhat.com>
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> 
> <process>I think you need to add your s-o-b here.</process>

Whoops, I thought I gave the right mix of flags to b4... clearly not.

> > ---
> >  arch/arm64/include/asm/kvm_host.h |  2 +
> >  arch/arm64/include/uapi/asm/kvm.h | 32 +++++++++++++++
> >  arch/arm64/kvm/arm.c              | 10 +++++
> >  arch/arm64/kvm/sys_regs.c         | 66 +++++++++++++++++++++++++++++++
> >  include/uapi/linux/kvm.h          |  2 +
> >  5 files changed, 112 insertions(+)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Appreciated!

-- 
Thanks,
Oliver
