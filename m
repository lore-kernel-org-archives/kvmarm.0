Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F6C47DD76;
	Thu, 24 Sep 2026 12:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790252048; cv=none; b=QYfzznACzIydnSCfhyFaOQvHooMc1J6BlaVnq9fxike6XnMeXWNuqEmqNBfan7UJDtliCtKqaGM+S6cee3ooDwyZSevz83QTo7GuhISgL8cAzZjB/hgh2YI1ZRzzKEObU1cas9vgrLMIC2e5TVIGxy8sYMxW6SL4bxTy/iHcLvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790252048; c=relaxed/simple;
	bh=rsAn2KeX2+WQ5TV0HToZYuawnaTCR3LFzkUhDdID7oI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KP4eZ10PW36qzTtNa0BARJAb0fRkCdIid1o01uyQrv/8xhOQePLbcgUqlv7xBb+ZRANXXaML6E8vqBind2ynfwODQxv/AiyGwK1sb02VqwNcW2b7zUe6c71JYQZk1diL2KQYaJP/a2qOrpq+pqasa9TtTdlyWGUuQ1XW6xnpxT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OnMD1tUM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OnMD1tUM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040451F000FF;
	Thu, 24 Sep 2026 12:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790252046;
	bh=505orE5OpmF0rqgVrMUI2fkr4bM3eg+OhX8WPM6vgh0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OnMD1tUMoY172Zuqhc6k4sQDczxnt/xSjWt5fb0mFNF8AFsCYlsRj9UVVsdG3ExB4
	 rCC0g+fh+YoPb3LIxF48kpXphBeotD+Yy13z0+TuNYbMG8fLz0Ap5odtNVNe7/5Yrx
	 icRT35m5mDtlzz8XcqONoajG5RjWIZ/drMfLHwgZKvQ9nDkLuXhjhoHs/3smj1ho5f
	 CPyPEm9i3q1GdTiffSaCZ2o0ukewZei7I/cj0ejUxAc3t7VQpaqbr/yBLc+J4BkM0w
	 xlM02lNJJY+duviRgIv/Ca8wLoyyvrgKZJyjfXpuyuSo8DXu2gs8maipQC2yqAg73E
	 dKRqj2RQc2FDg==
Date: Thu, 24 Sep 2026 13:14:00 +0100
From: Will Deacon <will@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>
Cc: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org,
	oupton@kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, joey.gouly@arm.com, seiden@linux.ibm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com, mark.rutland@arm.com,
	steven.price@arm.com, qperret@google.com
Subject: Re: [PATCH v3 10/18] KVM: arm64: Handle PSCI calls for protected VMs
 at EL2
Message-ID: <arUUCFHamX1nOrB1@willie-the-truck>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
 <20260914113338.159227-11-fuad.tabba@linux.dev>
 <arK1tHUEJsCQEKzn@google.com>
 <CA+EHjTx+foVF4CRU5D8bQv8bAqDphMN12UrV+_doUryn2ow6bg@mail.gmail.com>
 <arTfjgvZIhmXLrw1@willie-the-truck>
 <CA+EHjTxe0JE-tCX4YcEEafdnxjuZLj3EBucZfZF0HCP2PQAekg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTxe0JE-tCX4YcEEafdnxjuZLj3EBucZfZF0HCP2PQAekg@mail.gmail.com>

On Thu, Sep 24, 2026 at 12:26:25PM +0100, Fuad Tabba wrote:
> On Thu, 24 Sep 2026 09:30:06 +0100, Will Deacon <will@kernel.org> wrote:
> [...]
> > Sorry, but I'm really confused by this and it appears to be different to
> > what we've got in Android as well. Why do we need release semantics for
> > the store to 'hyp_vcpu->power_state' in pvm_psci_vcpu_off()? What is it
> > that we are publishing here? The comment talks about pkvm_reset_vcpu(),
> > but how is that relevant to the vCPU _off_ path? You say the comment is
> > wrong, but what _should_ it say?
> >
> > I'm a bit baffled!
> 
> It's not publishing data, it's handing reset_state back.

What's the difference? The usual pattern for acquire/release is:

<write data>
<store-release flag>

on one CPU and then on another:

<load-acquire flag>	// If this reads from the release above...
<read data>		// ... then this is guaranteed to read the written data

That's a message-passing shape and you would normally say that the first
CPU (the producer) is publishing the data to the other CPU (the consumer).

Is this what is happening with the 'reset_state' (data) and the
'power_state' (flag)? If not, then what is the shape?

> The CPU_ON winner writes reset_state.{pc, r0, be}, then reset_state.reset
> with a release. The target reads them and clears reset in pkvm_reset_vcpu()
> on its next run

By 'next run' you mean, at EL2 on the entry path into the guest following
a successful CPU_ON operation?

> and its CPU_OFF hands reset_state on to the next
> CPU_ON. The release on OFF orders those reads and that clear before
> OFF, and an acquire on the winner's cmpxchg orders its writes after
> it: release on the way out, acquire on the way in, like a lock.

That doesn't make sense to me, sorry. You're saying that the release
store in the EL2 CPU_OFF hypercall handler is ordering stores that were
made during the initial CPU_ON handling on that vCPU? Since then, we've
been in and out of the guest. We really shouldn't need extra barriers to
create order there.

> Without the release, the target's clear of reset can become visible
> after the next winner's reset = true, and the target's next
> pkvm_reset_vcpu() then reads a clear flag and returns -ECANCELED,
> leaving the vCPU stuck at ON_PENDING.

This needs a litmus test because I can't see it myself. As above,
CPU_OFF does not clear the reset state, so it's bizarre to put the
release there.

> The comment described the flag ordering, which holds through the
> winner's release on reset even with a relaxed cmpxchg, and named the
> cmpxchg as its pair when the cmpxchg wasn't an acquire. The acquire is
> for the winner's plain writes of pc/r0/be: nothing else orders them
> after the target's reads. v4 has cmpxchg_acquire() and the two
> comments name what's ordered and each other:
> 
>         /*
>          * Orders pkvm_reset_vcpu()'s accesses to reset_state before OFF. Pairs
>          * with the acquire cmpxchg in pvm_psci_vcpu_on().
>          */
>         smp_store_release(&hyp_vcpu->power_state, PSCI_0_2_AFFINITY_LEVEL_OFF);
> 
> and in pvm_psci_vcpu_on():
> 
>         /*
>          * vCPUs race to power on the same target. The acquire pairs with the
>          * release of OFF in pvm_psci_vcpu_off(): the target's accesses to
>          * reset_state in pkvm_reset_vcpu() precede the writes below.
>          */
>         power_state = cmpxchg_acquire(&target->power_state,
>                                       PSCI_0_2_AFFINITY_LEVEL_OFF,
>                                       PSCI_0_2_AFFINITY_LEVEL_ON_PENDING);

This confused me more :( Why are you talking about accesses preceding an
acquire? An acquire only orders later accesses.

I really think we need some litmus tests to understand the general ordering
problems we have here before adding the memory barriers.

Will
