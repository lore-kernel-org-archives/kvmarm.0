Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467E91BC58
	for <kvmarm@lists.linux.dev>; Fri, 22 Aug 2025 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755820938; cv=none; b=LW6dXrpv3OzfFL7YR68uoyHoPPyBda9RCb3vJj1acJtRs3dDc1w2ZWEAt8XbH3tledXqpxVdc2c2k1WcRiESngqzQpcJMo6JbjaN6hKHnoFDpRcvPf/rb8Fhww7+JSz8xWHOXKkKEwMq0wxdOufcU6qLoOvvFMqYWxsOWroBrhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755820938; c=relaxed/simple;
	bh=sB2kd2IaQcw0g1s75bnvdgvxVgOn/b5tYJ5GTBFylKA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U6wPfdIeKM83QR+7l8UrVix5SUiWLDDzp4i8HPj887BUeQF3/N4UeZ75dzYp4WbBItH0RZVBp5yk2ifyRqVOE/gu7+b+xjTKEKlW3grt+iygV6qTnxbpUESVe8Le3Zex4tgV/Sprnk2PUvV2Li/QcHRlT7f7BF+L791X6dRQbgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OGn+aToK; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OGn+aToK"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755820933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vUrDaGrlbnJZ+oxdBPVH9aUM2aDAG/pXEN+zcLc/AKw=;
	b=OGn+aToKUF9886Yb2+U4Tf4NouYzRT+l0M8RBeJjCeLgRpw/Fg7v7pIWjH8xuOxNXujSre
	vgZxqRSelB7SwT30XZBByV7+Pkd8uDKRe2KYir6r6sXfvWWm5QSsGIROsD5Vij6NSvnqGj
	oh3k3Bh3d4B/2G8UaLzDmtNLOdDTI48=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/2] KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables
Date: Thu, 21 Aug 2025 17:02:00 -0700
Message-Id: <175582091313.1266576.4329884314263043118.b4-ty@linux.dev>
In-Reply-To: <20250820162242.2624752-1-rananta@google.com>
References: <20250820162242.2624752-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On Wed, 20 Aug 2025 16:22:40 +0000, Raghavendra Rao Ananta wrote:
> When destroying a fully-mapped 128G VM abruptly, the following scheduler
> warning is observed:
> 
>   sched: CPU 0 need_resched set for > 100018840 ns (100 ticks) without schedule
>   CPU: 0 UID: 0 PID: 9617 Comm: kvm_page_table_ Tainted: G O 6.16.0-smp-DEV #3 NONE
>   Tainted: [O]=OOT_MODULE
>   Call trace:
>       show_stack+0x20/0x38 (C)
>       dump_stack_lvl+0x3c/0xb8
>       dump_stack+0x18/0x30
>       resched_latency_warn+0x7c/0x88
>       sched_tick+0x1c4/0x268
>       update_process_times+0xa8/0xd8
>       tick_nohz_handler+0xc8/0x168
>       __hrtimer_run_queues+0x11c/0x338
>       hrtimer_interrupt+0x104/0x308
>       arch_timer_handler_phys+0x40/0x58
>       handle_percpu_devid_irq+0x8c/0x1b0
>       generic_handle_domain_irq+0x48/0x78
>       gic_handle_irq+0x1b8/0x408
>       call_on_irq_stack+0x24/0x30
>       do_interrupt_handler+0x54/0x78
>       el1_interrupt+0x44/0x88
>       el1h_64_irq_handler+0x18/0x28
>       el1h_64_irq+0x84/0x88
>       stage2_free_walker+0x30/0xa0 (P)
>       __kvm_pgtable_walk+0x11c/0x258
>       __kvm_pgtable_walk+0x180/0x258
>       __kvm_pgtable_walk+0x180/0x258
>       __kvm_pgtable_walk+0x180/0x258
>       kvm_pgtable_walk+0xc4/0x140
>       kvm_pgtable_stage2_destroy+0x5c/0xf0
>       kvm_free_stage2_pgd+0x6c/0xe8
>       kvm_uninit_stage2_mmu+0x24/0x48
>       kvm_arch_flush_shadow_all+0x80/0xa0
>       kvm_mmu_notifier_release+0x38/0x78
>       __mmu_notifier_release+0x15c/0x250
>       exit_mmap+0x68/0x400
>       __mmput+0x38/0x1c8
>       mmput+0x30/0x68
>       exit_mm+0xd4/0x198
>       do_exit+0x1a4/0xb00
>       do_group_exit+0x8c/0x120
>       get_signal+0x6d4/0x778
>       do_signal+0x90/0x718
>       do_notify_resume+0x70/0x170
>       el0_svc+0x74/0xd8
>       el0t_64_sync_handler+0x60/0xc8
>       el0t_64_sync+0x1b0/0x1b8
> 
> [...]

Applied to fixes, thanks!

[1/2] KVM: arm64: Split kvm_pgtable_stage2_destroy()
      https://git.kernel.org/kvmarm/kvmarm/c/0e89ca13ee5f
[2/2] KVM: arm64: Reschedule as needed when destroying the stage-2 page-tables
      https://git.kernel.org/kvmarm/kvmarm/c/e9abe311f356

--
Best,
Oliver
