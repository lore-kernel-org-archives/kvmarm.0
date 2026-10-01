Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B673A3264D2;
	Thu,  1 Oct 2026 12:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790859489; cv=none; b=Gtgy9kbst+DekP3k3QdX07aUWy09Cx7y4xs7bYlaG8YbBEb2aUl+kweZDvJKHr4XVi29dBRcMuhp+WaqE53vbiLM5ruD0no8mr8+BmzfmXPkiV6v0zowebPAsBmGh57pThsdjLiCYvTKjfy6+ZNXIIQK5DXbMQGkOrJOZGNSlFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790859489; c=relaxed/simple;
	bh=53iGFckNAtzlYdaPK5wA1/DG6ONI/SJmmU19JICmKFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tW+J6Z7NzjxEnGob2Ug6o+CTcuknTmyRFVjKPBThBv9mUi7Eco/oW71ZyfwhsUzodCtQWtvaQaJc3adSzY62BI21ICeTIN2Cls688Iwt7yU9UGHD8TE0MH7t8PkOnavTpEyxjHjF9XpA8AaoAlY2ZMgHVyVkDYpm7a+ugZ5ZGfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JgTap4em; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JgTap4em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16091F000FF;
	Thu,  1 Oct 2026 12:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790859488;
	bh=Ofxw+nNqHHck2YVK0/lJTxddH3AOiZIZesVw4/g00qU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JgTap4emyIHq48r1ywQvwCqqBpo7r/9A1gTrgU+WuBDh8y9el/s2BICtvmahoRfaO
	 gYff8nAJ9x85B+le3pqdbHuq/6C4x5IqNfmIiovEoCqbSR3j0SLHAGivsyVmr2mzr1
	 vItqZkMkpeTvInRZEHRJywdYLOL4cGctG8f0yyPKBOxQ+3dChx6LmN/lJI6M2TCYQ0
	 qzybafiqj0Z2YjshGJlqDGqEj+oBA2Y4mUtrMMxJJb8weEIL9XFUcyy9nwVwiD9Fzb
	 peuySg1rucjrjnM8vSjG1+8jMvxvemvryatPhxscgYtMly4YsI7OtE9zpqsFioF5wl
	 FtkJ14uk8AHKw==
Date: Thu, 1 Oct 2026 13:58:01 +0100
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
Message-ID: <ar5Y2Usv-t0FggVA@willie-the-truck>
References: <20260914113338.159227-1-fuad.tabba@linux.dev>
 <20260914113338.159227-11-fuad.tabba@linux.dev>
 <arK1tHUEJsCQEKzn@google.com>
 <CA+EHjTx+foVF4CRU5D8bQv8bAqDphMN12UrV+_doUryn2ow6bg@mail.gmail.com>
 <arTfjgvZIhmXLrw1@willie-the-truck>
 <CA+EHjTxe0JE-tCX4YcEEafdnxjuZLj3EBucZfZF0HCP2PQAekg@mail.gmail.com>
 <arUUCFHamX1nOrB1@willie-the-truck>
 <CA+EHjTyWDvVc4B0mF8+N3QJ=gVPGEY-pxPGZWuTLK6Y=PZnF1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTyWDvVc4B0mF8+N3QJ=gVPGEY-pxPGZWuTLK6Y=PZnF1w@mail.gmail.com>

Hi Fuad,

On Thu, Sep 24, 2026 at 04:21:01PM +0100, Fuad Tabba wrote:
> On Thu, 24 Sep 2026 13:14:00 +0100, Will Deacon <will@kernel.org> wrote:
> [...]
> > > It's not publishing data, it's handing reset_state back.
> >
> > What's the difference? The usual pattern for acquire/release is:
> >
> > <write data>
> > <store-release flag>
> >
> > on one CPU and then on another:
> >
> > <load-acquire flag>     // If this reads from the release above...
> > <read data>             // ... then this is guaranteed to read the written data
> >
> > That's a message-passing shape and you would normally say that the first
> > CPU (the producer) is publishing the data to the other CPU (the consumer).
> >
> > Is this what is happening with the 'reset_state' (data) and the
> > 'power_state' (flag)? If not, then what is the shape?
> 
> I don't think so, it's the other direction. That pattern is the pair
> on reset_state.reset, and it isn't in question. The pair on
> power_state, as I see it, runs the other way: the target's last
> accesses to reset_state are its reads of the payload and its clear of
> the flag in pkvm_reset_vcpu(), and the next CPU_ON's accesses are
> stores. Release on OFF, acquire on the cmpxchg: unlock then lock, with
> power_state as the lock word. The winner takes it with the cmpxchg,
> hands it to the target through reset, and the target gives it up at
> CPU_OFF. Nothing is published. What I was after is the winner's stores
> being ordered after the target's reads and its clear.

For the benefit of everybody else, we had a fire alarm in the office
yesterday evening so Fuad and I sat outside a bar with a beer and a
piece of paper and went through this together...

There are two confusing aspects to the current code:

1. The OFF->ON_PENDING transition happens on the vCPU requesting CPU_ON
   whereas the ON_PENDING->ON transition happens on the incoming
   (target) vCPU, with reset_state->reset used to synchronise between
   the two.

2. reset_state->reset is cleared to false by the target vCPU on the
   guest entry path, rather than on the CPU_OFF path.

If we address (2), then I think the sequence becomes a little easier to
reason about. The OFF->ON_PENDING transition on the requestor looks
like:

	// PSCI CPU_ON
	cmpxchg_relaxed(power_state): OFF -> ON_PENDING
	<ctrl>
	write_reset_state();
	smp_store_release(reset_state->reset, true);

and then the whole ON_PENDING -> ON -> run_guest() -> OFF sequence on
the target looks like:

	// Target vCPU comes online
	smp_load_acquire(reset_state->reset) == true;
	cmpxchg_relaxed(power_state): ON_PENDING -> ON;
	read_reset_state();

	<run guest>

	// PSCI CPU_OFF
	WRITE_ONCE(reset_state->reset, false);
	smp_store_release(power_state, OFF);

which I think makes sense. WDYT? If you agree, I wonder if we can
include a comment similar to the above in the code?

Will
