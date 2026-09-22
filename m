Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3CF544D55;
	Tue, 22 Sep 2026 13:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082438; cv=none; b=Y1y4MG4FjBolXUUdGbYivB+lQq44QmuPLd5CWty0Y7g97JK111gAPfnnSWdH/CY5q6OvAM2F7HkRpZUz5liiVlCL97c2s+zCmW4EceL2D333NuppP88cY/5GTZue1yUuoaQ1PPymYiHck9V+jp6Jk1LSehW8vdSxbiGedv6FWRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082438; c=relaxed/simple;
	bh=9feO8jW6RAb6EQNHE4b5q7Qo8TwdCz9gi79AiYIq2tY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HK2zDo1wfEwyUYOLJg7FpEjnk9svNTFhlfQObfIbaxTxp7KM3+8dogHcN9/K01zlI2RmUyaCzz0jvls9I7ohg6Y0v7cOe8PqugvoBUhFfJ9RaBb94IDeS38OXPeazrO1E76Qg8BkZoXD+PJchdThsLtNyO5+I1f5vwuf2HAmghg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VdlNOHdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VdlNOHdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAA91F000FF;
	Tue, 22 Sep 2026 13:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790082436;
	bh=aHQl5p9sQAY9/zxya+ObUaa13h85sMUF9P0ssFuwzDg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VdlNOHdACDAc7b8xtcwHdLrXhTtZt4/tmONM2O45OuWA7k2PW4mXWxpcwjlhGX88y
	 7pr64y+yxcXtSN3h+sK4hYTZDVwzHIg55H+1w3jq5kqYDVCneoxOoWzpv4JduwXmtZ
	 y+z5DcDaFbJ79zNbKjIlE9ac2nM2KzSwQ6Hv//SM5hKcQMZH6Q2sGrta3SjQ5z6I48
	 O7vcq0cxQ1Tje0vwIkNYafgq/ZKpgxBKRKmMVm91o7gj8nRG63agpj3JY25N9m2PRH
	 cNdG0i6LALMT4QJsSVsmulhpujl0s1R9YKGExxkyvs91i65ihDH+YW/zHMM9WYQuiR
	 dXYIbA1dolPZg==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Jack Thomson <jackabt@amazon.com>,
	Jack Thomson <jackabt.amazon@gmail.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Leo Soares Passos <Leo.Bras@arm.com>
Subject: Re: [PATCH v2 00/13] KVM: arm64: Add KVM_PRE_FAULT_MEMORY support
In-Reply-To: <arJ1BDEzY5CANjjB@gremlin>
References: <20260914-kvm-arm-prefault-v2-0-26fb47f74b73@kernel.org>
 <yq5abj9p38vq.fsf@kernel.org> <arJ1BDEzY5CANjjB@gremlin>
Date: Tue, 22 Sep 2026 18:37:04 +0530
Message-ID: <yq5a8q4t305j.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

"Lorenzo Stoakes (ARM)" <ljs@kernel.org> writes:

> On Tue, Sep 22, 2026 at 03:28:33PM +0530, Aneesh Kumar K.V wrote:
>> > This is because pKVM instantiates vCPUs upon run,
>> >
>>
>> Can pKVM instantiate the hyp vCPU during pre-faulting ?
>
> It would be an unusual and unexpected thing to do - suddenly a pre-fault
> operation is initialising a vCPU explicitly for pKVM.
>
> A caller is not going to reasonably expect this and might treat a failure to
> pre-alloc as fine to carry on whereas in fact it was a failure to initailised a
> pKVM vCPU.
>
> It'd also require significant changes to how pKVM is set up, right now it's
> hardcoded to be done unconditionally at run via kvm_arch_vcpu_run_pid_change()
> -> pkvm_create_hyp_vcpu(), so all that would have to change and be checked and
> tested and... that'd be really out of scope I think :)
>
> And pre-faulting really makes most sense BEFORE you run a VM. It doesn't make so
> much sense mid-run.
>
> But more fundamentally, the stage 2 page tables, as I understand it, are owned
> by pKVM and so aren't really available to be pre-faulted.
>
> Maybe unprotected-under-pKVM VMs but then it's questionable as to how useful
> that would be given that it would be confusing to users vs. how it works for
> other VMs.
>
> So in general, no I don't think it's a good idea.
>
> And even if we wanted to pursue some version of this, it's _definitely_ out
> of scope for the initial pre-faulting bring-up series.
>
>>
>>
>> > but pre-faulting is  typically performed before a vCPU is run.  It would be confusing and
>> > inconsistent to error out on non-running vCPUs but to pre-fault running
>> > ones.
>>
>>
>> I use KVM pre-faulting when transitioning pages from shared to private
>
> You mean you'd prefer to use? Or you are using it on another arch?
>
>> with CoCo guest. This ensures that a trusted device can DMA to private
>> memory before the guest accesses it.
>
> Hm what do you mean by private memory?
>
> I see:
>
> #ifndef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> {
> 	return false;
> }
> #endif
>
> And only x86 selects KVM_GENERIC_MEMORY_ATTRIBUTES?
>
> Do you mean something else?
>

I am using this with ARM CCA-DA, based on the patch series from Jack Thomson <jackabt.amazon@gmail.com>.

https://gitlab.arm.com/linux-arm/kvmtool-cca/-/commit/80e7aad61c5639de2f0cb4a5525dad0c96156428

We do this while the VM is running.

-aneesh
