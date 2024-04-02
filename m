Received: from toucan.tulip.relay.mailchannels.net (toucan.tulip.relay.mailchannels.net [23.83.218.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B37156F33
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.254
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712077705; cv=pass; b=no1HqU1EWpusYhk6qw6D/5Nfdl3mUi2Cfu6KA1yebsbBxZx61XkwGw691uE0y5QSHG6Wftdz3ScjCp/IcThLs1N13s8h5dVU1I0oCe9nge801TrR939c2g++/EhW2BwlTXWAwRUdWeY40T8cU1pVpIu4XygOStMImXuzp509lMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712077705; c=relaxed/simple;
	bh=S01J31mF1D/coS7MLGT9idAqj4JYATbmov5yg7Rfp60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OvtvbBUabsetpuHGlUpiAy9pNF2CXzZeF2+Y9QI784GbHU40uqnfE/Ww+pBpgbmWCSbo0EKitNkspKAfkDPUGSh7cBfr3uiPWhDDi+D9R5ssvTr34XioMU41VXNFvNyhxmQ+8KpVpmlZBk9KBdL8rVAxAA/0WALUHJJWyV3HTWs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=W+RGHknR; arc=pass smtp.client-ip=23.83.218.254
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="W+RGHknR"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id AB08081CF8
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 17:00:58 +0000 (UTC)
Received: from pdx1-sub0-mail-a309.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 3D3D9822D7
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 17:00:58 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1712077258; a=rsa-sha256;
	cv=none;
	b=I2V1zTMwiZz+OeUnPTQkyGTul8Fs2MQJYwLxRl7YeE9ZwiN/ug7crOoVeksKymSDyG152g
	+Q2lsBNRSSgyomXcakk3PoFgpHfaz8lOaltOMigjsfCa7j6dl0GG0/Ema27fc+WIJ/cO/h
	+Ppg65ca3T8I4Vvu2e8pKiIV2k3LIld+zinHlRxvptolvEY9auIxONIQ6TOzMWlDm+0Dlp
	uT0iCoI9NP2wp61jQgbsQ0igXqYSj+xmvi9Q8VhHATUZPshOoDrTpju3+Pa3xXRQSAqCX7
	gs4J9GpLgkgGA1KczcV9e3u3KpfN2Epd7//K5YCzfN625OfxXcxCfL4UTRWBXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1712077258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYG+1dFMQK089kCWsOzfLTsoNX83jIbm79QFok+yJmc=;
	b=fEd0884+SetS8z3yANonvE4gp9rJuRHaTz7/gFBVNCgMci4utRAUDv56tsBNsF59FSY6lo
	1eYXtvT0OYPAfT39TVCIXq3lQpV5Z5Pj/fr5S1nGPP4M/FG7trP9xhU7D+ko0SOBMlMdTg
	uOUxuAsbmH1lr+hdHiAiucp8CSVhWuFOZq/01sosPh/gnvDrhbwjcJSJHD8+KdM4hKflJ8
	tw0oL61E7zXZJhMZI49t+wYUNK5Ku2JK/GLNQrxPHyepN6uJbM9Nnz8QndzB58+jXy1YjD
	/rRuZlHWWT5tkA2jLN2ysZ56oWl0jtNzD8I/kx0bT+sv8YNFX1QtQRfPkjVTtg==
ARC-Authentication-Results: i=1;
	rspamd-5ffc56d49c-cqr79;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Turn-Soft: 254ccadc542e806d_1712077258569_2930869458
X-MC-Loop-Signature: 1712077258568:3918453814
X-MC-Ingress-Time: 1712077258568
Received: from pdx1-sub0-mail-a309.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.119.87.146 (trex/6.9.2);
	Tue, 02 Apr 2024 17:00:58 +0000
Received: from kmjvbox.templeofstupid.com (c-73-222-159-162.hsd1.ca.comcast.net [73.222.159.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a309.dreamhost.com (Postfix) with ESMTPSA id 4V8Dfd384pz17j
	for <kvmarm@lists.linux.dev>; Tue,  2 Apr 2024 10:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1712077257;
	bh=ZYG+1dFMQK089kCWsOzfLTsoNX83jIbm79QFok+yJmc=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=W+RGHknRfIsysmdVJTnu8kOUoFZiUgFbgCaQ7q3pC92XSC7G2VxZ0gIChnOkh013m
	 S2quLRfNbRq+s4CqPqLMNdcZ/ewL1nedKNcQEqdmP64WiM1nXb1izyCTATj7zzl6Zy
	 uoFqpDSD5SQ+5wAzEvHaSYJQEWK94GV7DbBwo0yHMGooZ6gCJs9w9029ZTZEE6Cir8
	 8YU6riqU8Lrh2/dIJzSRjWzpG/p10TQBvMpJywF9cPNotp2aR6LJzdyBaLdQp6zSwx
	 prwGRV1WbLb3UGirjBuBO9BzgKwQ3vJfmfkeGwNNtrO6YIS/fBOeIEl5jvM+OSwLkT
	 0MGDX1VssPNhQ==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e009c
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Tue, 02 Apr 2024 10:00:52 -0700
Date: Tue, 2 Apr 2024 10:00:52 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Krister Johansen <kjlx@templeofstupid.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ali Saidi <alisaidi@amazon.com>,
	David Reaver <me@davidreaver.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Limit stage2_apply_range() batch size to
 smallest block
Message-ID: <20240402170052.GA1988@templeofstupid.com>
References: <cover.1711649501.git.kjlx@templeofstupid.com>
 <ebf0fac84cb1d19bdc6e73576e3cc40a9cab0635.1711649501.git.kjlx@templeofstupid.com>
 <ZgbGtpj5mStTkAkn@linux.dev>
 <20240329191537.GA2051@templeofstupid.com>
 <87r0fsrpko.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0fsrpko.wl-maz@kernel.org>

Hi Marc,

On Sat, Mar 30, 2024 at 10:17:43AM +0000, Marc Zyngier wrote:
> On Fri, 29 Mar 2024 19:15:37 +0000,
> Krister Johansen <kjlx@templeofstupid.com> wrote:
> > On Fri, Mar 29, 2024 at 06:48:38AM -0700, Oliver Upton wrote:
> > > On Thu, Mar 28, 2024 at 12:05:08PM -0700, Krister Johansen wrote:
> > > > stage2_apply_range() for unmap operations can interfere with the
> > > > performance of IO if the device's interrupts share the CPU where the
> > > > unmap operation is occurring.  commit 5994bc9e05c2 ("KVM: arm64: Limit
> > > > stage2_apply_range() batch size to largest block") improved this.  Prior
> > > > to that commit, workloads that were unfortunate enough to have their IO
> > > > interrupts pinned to the same CPU as the unmap operation would observe a
> > > > complete stall.  With the switch to using the largest block size, it is
> > > > possible for IO to make progress, albeit at a reduced speed.
> > > 
> > > Can you describe the workload a bit more? I'm having a hard time
> > > understanding how you're unmapping that much memory on the fly in
> > > your workload. Is guest memory getting swapped? Are VMs being torn
> > > down?
> > 
> > Sorry I wasn't clear here.  Yes, it's the VMs getting torn down that's
> > causing the problems.  The container VMs don't have long lifetimes, but
> > some may be up to 256Gb in size, depending on the user.  The workloads
> > running the VMs aren't especially performance sensitive, but their users
> > do notice when network connections time-out.  IOW, if the performance is
> > bad enough to temporarily prevent new TCP connections from being
> > established or requests / responses being recieved in a timely fashion,
> > we'll hear about it.  Users deploy their services a lot, so there's a
> > lot of container vm churn.  (Really it's automation redeploying the
> > services on behalf of the users in response to new commits to their
> > repos...)
> 
> I think this advocates for a teardown-specific code path rather than
> just relying on the usual S2 unmapping which is really designed for
> eviction. There are two things to consider here:
> 
> - TLB invalidation: this should only take a single VMALLS12E1, rather
>   than iterating over the PTs
> 
> - Cache maintenance: this could be elided with FWB, or *optionally*
>   elided if userspace buys in a "I don't need to see the memory of the
>   guest after teardown" type of behaviour

This approach would work for this workload, I think.  The hardware
supports FWB and AFAIK isn't looking at the guest memory after teardown.
This is also desirable because in the future we'd like to support
hotplug of VFIO devices. A separate path for unmap the memory used by
the device vs unmap all of the guest seems smart.

> > > Also, it seems a bit odd to steer interrupts *into* the workload you
> > > care about...
> > 
> > Ah, that was only intentionally done for the purposes of measuring the
> > impact.  That's not done on purpose in production.
> > 
> > Nevertheless, the example we tend to run into is that a box may have 2
> > NICs and each NIC has 32 Tx-Rx queues.  This means we've got 64 NIC
> > interrupts, each assigned to a different CPU.  Our systems have 64 CPUs.
> > What happens in practice is that a VM will get torn down, and that has a
> > 1-in-64 chance of impacting the performance of the subset of the flows
> > that are mapped via RSS to the interrupt that happens to be assigned to
> > the CPU where the VM is being torn down.
> > 
> > Of course, the obvious next question is why not just bind the VMs flows
> > to the CPUs the VM is running on?  We don't have a 1:1 mapping of
> > network device to VM, or VM to CPU right now, which frustrates this
> > approach.
> > 
> > > > Further reducing the stage2_apply_range() batch size has substantial
> > > > performance improvements for IO that share a CPU performing an unmap
> > > > operation.  By switching to a 2mb chunk, IO performance regressions were
> > > > no longer observed in this author's tests.  E.g. it was possible to
> > > > obtain the advertised device throughput despite an unmap operation
> > > > occurring on the CPU where the interrupt was running.  There is a
> > > > tradeoff, however.  No changes were observed in per-operation timings
> > > > when running the kvm_pagetable_test without an interrupt load.  However,
> > > > with a 64gb VM, 1 vcpu, and 4k pages and a IO load, map times increased
> > > > by about 15% and unmap times increased by about 58%.  In essence, this
> > > > trades slower map/unmap times for improved IO throughput.
> > > 
> > > There are other users of the range-based operations, like
> > > write-protection. Live migration is especially sensitive to the latency
> > > of page table updates as it can affect the VMM's ability to converge
> > > with the guest.
> > 
> > To be clear, the reduction in performance was observed when I
> > concurrently executed both the kvm_pagetable_test and a networking
> > benchmark where the NIC's interrupts were assigned to the same CPU where
> > the pagetable test was executing.  I didn't see a slowdown just running
> > the pagetable test.
> 
> Any chance you could share more details about your HW configuration
> (what CPU is that?)  and the type of traffic? This is the sort of
> things I'd like to be able to reproduce in order to experiment various
> strategies.

Sure, I only have access to documentation that is publicly available.

The hardware where we ran into this inititally was Graviton 3, which is
a Neoverse-V1 based core.  It does not support FEAT_TLBIRANGE.  I've
also tested on Graviton 4, which is Neoverse-V2 based.  It _does_
support FEAT_TLBIRANGE.  The deferred range based invalidation
support, was enough to allow us to teardown a large VM based on 4k pages
and not incur a visible performance penalty.  I haven't had a chance to
test to see if and how Will's patches change this, though.

The tests themselves were not especially fancy. The networking hardware
was a ENA device on an EC2 box with 30Gbps limit (5/10 Gbps per flow,
depending on the config).  The storage tested was a gp3 EBS device
configured to max IOPS/throughput (16,000 IOPS / 1000Mb/s).

Networking tests were iperf3 with a 9001 byte packet size.  The storage
tests were fio's randwrite workload in directio mode using the libaio
backend.  The "IOPS" test used a 4k blocksize and a queue depth of 128.
The "throughput" test used a blocksize of 64k and an iodepth of 32.  For
the fio tests, it was a 10gb file and 2 workers, mostly because the EBS
devices have two hardware queues for data.

I ran the kvm_page_table_test with a few different sizes, but settled on
64G with 1 vcpu for most tests.

Let me know if there's anything else I can share here.

-K
