Received: from out-22.mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92888659
	for <kvmarm@lists.linux.dev>; Thu, 15 Jun 2023 08:59:51 +0000 (UTC)
Date: Thu, 15 Jun 2023 08:59:39 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686819589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L7gLMuGKceimfr6zrz+UW6frOfSWL8pcQ8YFkxEcKcg=;
	b=WcLfv8fuISsDvB7xPmZgRm5n6aYo+ElQv1T1BYpmC/cLA5tG4/H28Xhfof3HhBOlca/3y5
	c5Or+cPi7fY+EiZ/5gtEEwMMgxc0LnVuH/sVNSANXJDLw16K1yzIVXF2S+a/gT3TnNcpjw
	6ISnkXOchkXSXMM1CwQOIS0n5KU+qHk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>,
	Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH kvmtool 12/21] Add helpers to pause the VM from vCPU
 thread
Message-ID: <ZIrS+wRuzzp3BZ9L@linux.dev>
References: <20230526221712.317287-1-oliver.upton@linux.dev>
 <20230526221712.317287-13-oliver.upton@linux.dev>
 <10695b6a-65d5-2df3-e89e-8cc2cd75b8ac@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10695b6a-65d5-2df3-e89e-8cc2cd75b8ac@redhat.com>
X-Migadu-Flow: FLOW_OUT

Hi Shaoqin,

On Fri, Jun 09, 2023 at 06:59:53PM +0800, Shaoqin Huang wrote:
> Hi Oliver,
> 
> I have a play with this series, the guest always hang when hotplug two more
> cpus, it seems the kvm_cpu_continue_vm forget to continue the current cpu.

Thanks for testing the series out. Heh, a bit of a silly bug on my part,
sorry about that.

> > +void kvm_cpu__pause_vm(struct kvm_cpu *vcpu)
> > +{
> > +	/*
> > +	 * Mark the calling vCPU as paused to avoid waiting indefinitely for a
> > +	 * signal exit.
> > +	 */
> > +	vcpu->paused = true;
> > +	kvm__pause(vcpu->kvm);
> > +}
> > +
> > +void kvm_cpu__continue_vm(struct kvm_cpu *vcpu)
> > +{
> Here should add:
> 	vcpu->paused = false;
> > +	kvm__continue(vcpu->kvm);
> > +}
> > +

LGTM, I'll stick this in v2.

> >   int kvm_cpu__start(struct kvm_cpu *cpu)
> >   {
> >   	sigset_t sigset;
> 
> -- 
> Shaoqin
> 

-- 
Thanks,
Oliver
