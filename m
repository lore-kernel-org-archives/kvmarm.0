Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6723C418368;
	Wed, 23 Sep 2026 13:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790170364; cv=none; b=tC+V6rshXqILg02DYsFxXOM1hJJP1+20NwIM2i9t8UvZIYi0NHwij8NEaXKX8Ymy+XIidG18CQcGPnSq6b7vw7W9tPvmqXhlfku2p1jHx+N2C6fWHN9Y4j79UTr+KOFW4L+9wzSAS2FgH9mQTqHZQH33y5kwtRN2foFdq4/Z79I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790170364; c=relaxed/simple;
	bh=bX5FPY31KMiVzCHvE4fVrWQ4xNzBZnVOBmyul4lFIqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mDn1EfaxNx95cZGm+Jkbqlyqp+2AiYQF4E/lSFr51Kd2+bi1KpbSjd8oCpW7UboIDwemtzsMhZSUR+mL4q33bUfsya7J1+veHts2lAO7cEmVSvBVDsMlbm7GC0yANdJb6FFsIvl9FMLOrQA1ik8Hi82Q5WWQv/eDM6qhH01KvYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDWCxWxG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDWCxWxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DAF1F000FF;
	Wed, 23 Sep 2026 13:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790170363;
	bh=NdvfcIHzuDUv22cT6IMsimyb9EhpnmvYvHKeIurV9RM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LDWCxWxG6X3KqX3olCxZLvcMShWHXNh0Ds4io8xzigKHebnQIK2A3qf1Lqbn8c6zk
	 T7t3MC00oUALrAiTwhKyBxc8B6FazZjNZ0mhuim0LeGrrxg220oXkshspOHYIrA0x1
	 ZByJT3nbdHSIqp6sPLJ2dfRawd/kuBZGW0icvQlxx0+Ih7+bjU/PJp3fwpMGxsDONw
	 c0eZlRA/kPq0MRqs8kUL1evkBsLUahmLYYRB0i+OGH6qQQ9LUjNhUmaWFEuQIyqFjr
	 Hu2XlKwowF85CdcJaJxVVb/oeuVQMygFXFg7uVNlTrJpbtU1TWQjKz2MfJ9Mjswx9U
	 1L3qaz6usABEg==
Date: Wed, 23 Sep 2026 14:32:33 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Mark Rutland <mark.rutland@arm.com>, Randy Dunlap <rdunlap@infradead.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jack Thomson <jackabt@amazon.com>, Jack Thomson <jackabt.amazon@gmail.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Leo Soares Passos <Leo.Bras@arm.com>, 
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: Re: [PATCH v3 10/14] KVM: arm64: Implement KVM_PRE_FAULT_MEMORY
Message-ID: <arPU4O4_oDUzPcod@gremlin>
References: <20260922-kvm-arm-prefault-v3-0-787bd3bc7e3f@kernel.org>
 <20260922-kvm-arm-prefault-v3-10-787bd3bc7e3f@kernel.org>
 <CA+EHjTyCc=T+HkvWv1g2Fg3OxGaa1i8Hdv296ivPc94jQqZq9g@mail.gmail.com>
 <arPTt4WuVxcdvThs@gremlin>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arPTt4WuVxcdvThs@gremlin>

On Wed, Sep 23, 2026 at 02:28:59PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 23, 2026 at 12:18:10PM +0100, Fuad Tabba wrote:
> > Hi Lorenzo,
> >
> > On Tue, 22 Sep 2026 15:18:04 +0100, "Lorenzo Stoakes (ARM)"
> > <ljs@kernel.org> wrote:
> > [...]
> > > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > [...]
> > > +static long __pre_fault_s2(struct kvm_s2_mmu *mmu, struct kvm_vcpu *vcpu,
> > > +                           gpa_t gpa, struct kvm_memory_slot *memslot, s8 level)
> > [...]
> > > +        if (is_gmem)
> > > +                ret = gmem_abort(&s2fd, &result);
> > > +        else
> > > +                ret = user_mem_abort(&s2fd, &result);
> >
> > When kvm_gmem_get_pfn() fails, gmem_abort() calls
> > kvm_prepare_memory_fault_exit() before returning, which on this path
> > writes vcpu->run's exit_reason and memory_fault fields outside
> > KVM_RUN. If that happens on a vCPU between its KVM_EXIT_MMIO and its
> > next KVM_RUN, kvm_arch_vcpu_ioctl_run() reads KVM_EXIT_MEMORY_FAULT
> > instead, skips kvm_handle_mmio_return(), and the guest repeats the
> > access. Could gmem_abort() skip that exit when result is set?
> > user_mem_abort() never writes kvm_run.
>
> Ack yeah we shouldn't be updating vcpu->run like that in that case, will
> update to avoid doing that in v4.

(Folded into 5/14)

--
Cheers, Lorenzo
