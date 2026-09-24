Received: from mta1.migadu.com (out-42.mta1.migadu.com [95.215.58.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9039B4A0906
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 15:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263305; cv=none; b=q+5WFxmrKdoWp4u/M1o1VVCCIuf9nDZaKN2WGkK4myEJBK3kvHiNDXA6oqum4bCUSZKaQqeHUcz1//N6CZHXgom2XKpU97BWjlJ+5I0hHeENn/4td1Bm9izhmwHnV6vk5Lq22sW1kf0PAirjBcvJZjrH37RxLAr1ZRVl8w6yFVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263305; c=relaxed/simple;
	bh=AvUxZyX/tO3G52TZtdDe5cDkHKT09asHJ5InA7+aTqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SPrQ3S9p4S7yu+Gyg7DoQDhKq58C8b4ZdyDxtgZv+u5atNAzqMCGGuYNnjLWtaKd8ybPsZGzUm9amJIVkU85RFDz/rYF7AjEpEQc9AF3hy5jsdcDci2FcbT5ufY1hqmJyRdLCyRxsaJQa13la6UPzD/mOyC3Jc6VMirt1PsxJD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zw8M073H; arc=none smtp.client-ip=95.215.58.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zw8M073H"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=AvUxZyX/tO3G52TZtdDe5cDkHKT09asHJ5InA7+aTqk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790263299; v=1; x=1790868099;
 b=Zw8M073H7aniGH3/9Qz3P+rY8GoYS9SPcmtY22bsXRnwkP2KSkx4F1q8h2hWUMXks2lY8+UK
 KuuhgJsxfngYgmEq01Gj70Hn2opZjice59cKNJ7kGVy2h0+XfANCBO8lXx+qOE0wxsDipQZakKp
 c2+EsQtpbMVPEUVqspy5NyXI=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 5c7a12de467cf88a;
	Thu, 24 Sep 2026 15:21:39 +0000
X-Mizu-Trace-ID: 5c7a12de467cf88a
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b83c1421ecso8283e87.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 08:21:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxoADU2l3UmKDceHMtl3cMTCQCC8Ldh7fnS4SiorpJ0Fve11IA0JBFxK5+/wDXwWhfNLiTTxuM=@lists.linux.dev
X-Gm-Message-State: AFuF++nzAQ1+lsL+bvqmTkU8ct2Wfu3mtoY/IrgJDA57fugbyjrBMgiv
	h0Jlspjqu2C37J64jTXwtm814VKX/RlxUgchp3YA7rUHyfKw5JV8wqEYUepwxJGRK67QGuT6bF1
	86JSAXvZH6LHq615n8ZIdaC1nbnvPFnir39yAIeH3
X-Received: by 2002:a05:6512:238b:b0:5b8:d830:be30 with SMTP id
 2adb3069b0e04-5b8dda259a4mr187251e87.16.1790263298205; Thu, 24 Sep 2026
 08:21:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260914113338.159227-1-fuad.tabba@linux.dev> <20260914113338.159227-11-fuad.tabba@linux.dev>
 <arK1tHUEJsCQEKzn@google.com> <CA+EHjTx+foVF4CRU5D8bQv8bAqDphMN12UrV+_doUryn2ow6bg@mail.gmail.com>
 <arTfjgvZIhmXLrw1@willie-the-truck> <CA+EHjTxe0JE-tCX4YcEEafdnxjuZLj3EBucZfZF0HCP2PQAekg@mail.gmail.com>
 <arUUCFHamX1nOrB1@willie-the-truck>
In-Reply-To: <arUUCFHamX1nOrB1@willie-the-truck>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Thu, 24 Sep 2026 16:21:01 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyWDvVc4B0mF8+N3QJ=gVPGEY-pxPGZWuTLK6Y=PZnF1w@mail.gmail.com>
X-Gm-Features: AclHuK-Tr-CYuhyqLL3dKaG6eneOkpkAbwBzpQx--EX-XebKJ0QSmyPMwRUhQwc
Message-ID: <CA+EHjTyWDvVc4B0mF8+N3QJ=gVPGEY-pxPGZWuTLK6Y=PZnF1w@mail.gmail.com>
Subject: Re: [PATCH v3 10/18] KVM: arm64: Handle PSCI calls for protected VMs
 at EL2
To: Will Deacon <will@kernel.org>
Cc: Vincent Donnefort <vdonnefort@google.com>, maz@kernel.org, oupton@kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, catalin.marinas@arm.com, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	mark.rutland@arm.com, steven.price@arm.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Will,

On Thu, 24 Sep 2026 13:14:00 +0100, Will Deacon <will@kernel.org> wrote:
[...]
> > It's not publishing data, it's handing reset_state back.
>
> What's the difference? The usual pattern for acquire/release is:
>
> <write data>
> <store-release flag>
>
> on one CPU and then on another:
>
> <load-acquire flag>     // If this reads from the release above...
> <read data>             // ... then this is guaranteed to read the written data
>
> That's a message-passing shape and you would normally say that the first
> CPU (the producer) is publishing the data to the other CPU (the consumer).
>
> Is this what is happening with the 'reset_state' (data) and the
> 'power_state' (flag)? If not, then what is the shape?

I don't think so, it's the other direction. That pattern is the pair
on reset_state.reset, and it isn't in question. The pair on
power_state, as I see it, runs the other way: the target's last
accesses to reset_state are its reads of the payload and its clear of
the flag in pkvm_reset_vcpu(), and the next CPU_ON's accesses are
stores. Release on OFF, acquire on the cmpxchg: unlock then lock, with
power_state as the lock word. The winner takes it with the cmpxchg,
hands it to the target through reset, and the target gives it up at
CPU_OFF. Nothing is published. What I was after is the winner's stores
being ordered after the target's reads and its clear.

> > The CPU_ON winner writes reset_state.{pc, r0, be}, then reset_state.reset
> > with a release. The target reads them and clears reset in pkvm_reset_vcpu()
> > on its next run
>
> By 'next run' you mean, at EL2 on the entry path into the guest following
> a successful CPU_ON operation?

Yes. The target's first __kvm_vcpu_run hypercall after the host's
kvm_psci_vcpu_on() has woken it. handle___kvm_vcpu_run() reads
power_state as ON_PENDING and calls pkvm_reset_vcpu() before entering
the guest.

> > and its CPU_OFF hands reset_state on to the next
> > CPU_ON. The release on OFF orders those reads and that clear before
> > OFF, and an acquire on the winner's cmpxchg orders its writes after
> > it: release on the way out, acquire on the way in, like a lock.
>
> That doesn't make sense to me, sorry. You're saying that the release
> store in the EL2 CPU_OFF hypercall handler is ordering stores that were
> made during the initial CPU_ON handling on that vCPU? Since then, we've
> been in and out of the guest. We really shouldn't need extra barriers to
> create order there.

The target's own accesses at its reset, its reads of the payload and
its clear of the flag. You're right that the hardware orders them:
__kvm_vcpu_run() runs dsb(nsh) before it restores the guest's state,
and since R24234 the NSH is only a TLBI/IC scope, so that DSB orders
the target's accesses before OFF for every PE. My reasoning for the
release and the acquire was that the protocol shouldn't rest on a
barrier that is there for the translation regime, that nothing
documents as ordering EL2 state for other CPUs, and that the LKMM,
having no dsb(), can't see: under the model the target's accesses and
the next winner's are unordered without them. Would you rather rely on
the world switch and say so at that dsb(nsh)?

> > Without the release, the target's clear of reset can become visible
> > after the next winner's reset = true, and the target's next
> > pkvm_reset_vcpu() then reads a clear flag and returns -ECANCELED,
> > leaving the vCPU stuck at ON_PENDING.
>
> This needs a litmus test because I can't see it myself. As above,
> CPU_OFF does not clear the reset state, so it's bizarre to put the
> release there.

I'd actually done that earlier.

The flag, under the LKMM (herd7 7.58 with mainline's tools/memory-model):

        C CPU_OFF-flag

        (*
         * P0, the target: its reset clears reset_state.reset, its
         * CPU_OFF stores power_state = OFF. P1, the next CPU_ON:
         * cmpxchg(OFF -> ON_PENDING), then a release of reset.
         * OFF=0 ON=1 ON_PENDING=2.
         *)

        {
                power_state = 1;
                reset = 1;
        }

        P0(int *power_state, int *reset)
        {
                *reset = 0;
                WRITE_ONCE(*power_state, 0);
        }

        P1(int *power_state, int *reset)
        {
                int r1;

                r1 = cmpxchg_relaxed(power_state, 0, 2);
                if (r1 == 0)
                        smp_store_release(reset, 1);
        }

        exists (1:r1=0 /\ reset=0)

As written: Sometimes, and a data race. With smp_store_release() for
the OFF store: Never. CPU_OFF doesn't touch reset_state, but its OFF
store is what a CPU_ON takes with the cmpxchg, so it seemed to me the
store the target's accesses should be ordered before.

> > and in pvm_psci_vcpu_on():
> >
> >         /*
> >          * vCPUs race to power on the same target. The acquire pairs with the
> >          * release of OFF in pvm_psci_vcpu_off(): the target's accesses to
> >          * reset_state in pkvm_reset_vcpu() precede the writes below.
> >          */
> >         power_state = cmpxchg_acquire(&target->power_state,
> >                                       PSCI_0_2_AFFINITY_LEVEL_OFF,
> >                                       PSCI_0_2_AFFINITY_LEVEL_ON_PENDING);
>
> This confused me more :( Why are you talking about accesses preceding an
> acquire? An acquire only orders later accesses.

Agreed, it reads as if the acquire ordered earlier accesses. For v4:

        /*
         * vCPUs race to power on the same target. The acquire orders the
         * writes below after the cmpxchg's read of OFF, and with the release
         * of OFF in pvm_psci_vcpu_off() that puts them after the target's
         * reads and clear of reset_state in pkvm_reset_vcpu().
         */

> I really think we need some litmus tests to understand the general ordering
> problems we have here before adding the memory barriers.

The other direction, the payload:

        C CPU_ON-payload

        (*
         * P0, the target: its reset reads reset_state.pc, its CPU_OFF
         * stores OFF with a release. P1, the next CPU_ON:
         * cmpxchg(OFF -> ON_PENDING), then a plain store to pc.
         * OFF=0 ON=1 ON_PENDING=2.
         *)

        {
                power_state = 1;
                pc = 0;
        }

        P0(int *power_state, int *pc)
        {
                int r0;

                r0 = *pc;
                smp_store_release(power_state, 0);
        }

        P1(int *power_state, int *pc)
        {
                int r1;

                r1 = cmpxchg_relaxed(power_state, 0, 2);
                if (r1 == 0)
                        *pc = 1;
        }

        exists (1:r1=0 /\ 0:r0=1)

As written: Sometimes, and a data race. With cmpxchg_acquire(): Never.
Those two are what's behind the release (v3) and the acquire (v4). The
rollback's ON_PENDING -> OFF cmpxchg in handle_pvm_entry_hvc64() has
the same pattern on the source side, so v4 makes it a release too.

My head is spinning now :)

Cheers,
/fuad
