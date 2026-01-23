Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E8D28A3FA
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 19:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769196234; cv=none; b=aBMHMmRjbqjFUANhxoaDzHcu+cWfniWV56e3yEt49XIk8k3DMPbU7lqjC7pgH4owEevtah7AUbvpQzR6iDlgTEgVikiPhm2IVsCq5vOVR4kz454MPZ1vn5lzeM/hkQDsUiSjCg6Xu3PJh5/vyTu2ptVttsySpaVqc9xKxjPsDxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769196234; c=relaxed/simple;
	bh=ACfRcKHgQFUI4e3SZ6RwDZkzm7PXEJjxfGWgb+B+2ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EL7FzEnTMKUKmVxxJLsMOCfMJgtrproiXVW+Oc9exhU/Eqy0FeE07mIv2Hm18+EwVQTm9sbh812WeQjCfHRY5d9Dh86fKIkmd78NWjRnBWY27mljaS/urtwBDB4Ogf5mgkZVQTs10jdHqGr9WQlST2uWCKpc18dQ3uq8XccIwO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D/Odg4pP; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D/Odg4pP"
Date: Fri, 23 Jan 2026 13:23:41 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769196227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oa7iGNimmxf4NkLdFCeEfPikE1lPlYJxPyIsdcse1T4=;
	b=D/Odg4pPv448bA8y0YfiFsAHYHxAnTqkRNcAYUpsZzhVdTENW4aD4cedde5+qiGI2BWtMx
	sVIGf+jvSVk79VF9eRThVaBq42D8VC6aqWsqecC7MZup6EwV6wuMfy+XkZhLWyjb+gyQPi
	G50wkMTcVVzzxqeryfqEZP8yYpFQN18=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, maz@kernel.org, kvmarm@lists.linux.dev, 
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v6 00/14] arm64: EL2 support
Message-ID: <ixq5fcyiey4prwl5luzlemznvjd6hk2pqj73rmlinnl233gfdy@b6mns7sf3dv5>
References: <20260123165053.2250754-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123165053.2250754-1-joey.gouly@arm.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 23, 2026 at 04:50:39PM +0000, Joey Gouly wrote:
> Hi all,
> 
> This series is for adding support to running the kvm-unit-tests at EL2.
> 
> Changes since v5[1]:
> 	- make debug bp/wp skip on EL2
> 	- fix microbench test
> 	- add to CI
> 	- applied the fixup's Drew talked about in v5
> 
> About this failure in micro-bench:
> 
> 	- micro-bench hits the assert in gicv3_lpi_alloc_tables()
> 		lib/arm/gic-v3.c:183: assert failed: gicv3_data.redist_base[cpu]: Redistributor for cpu0 not initialized. Did cpu0 enable the GIC?	
> 
> in micro-bench.c lpi_prep() looks like this:
> 
> 	static bool lpi_prep(void)
> 	{
> 	        struct its_collection *col1;
> 	        struct its_device *dev2;
> 	        if (!gicv3_its_base())
> 	                return false;
> 
> QEMU by default runs with gic-v2, so gicv3_its_base() should have returned
> false and the lpi tests skipped. However because of the overflow mentioned in
> the first commit (new to v6), the its_data.base was being overwritten to a
> non-zero value.  This meant the test tried to do gic-v3 things on a gic-v2.

Nice work on the micro-bench/gic issue. Unfortunately the timer test still
times out, and that breaks the new CI since that test is listed.

# No EL2

$ ./run_tests.sh -g timer
PASS timer (18 tests)

# EL2

$ EL2=y ./run_tests.sh -g timer
FAIL timer (timeout; duration=10s)

$ TIMEOUT=90s EL2=y ./run_tests.sh -g timer
FAIL timer (timeout; duration=90s)

$ cat logs/timer.log
timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,virtualization=on -accel tcg -cpu max -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/timer.flat -smp 1 # -initrd /tmp/tmp.N15fhaPbhB
CNTFRQ_EL0   : 0x0000000003b9aca0
CNTPCT_EL0   : 0x00000000001d3a1f
CNTP_CTL_EL0 : 0x0000000000000000
CNTP_CVAL_EL0: 0x0000000000000000
CNTVCT_EL0   : 0x00000000001d5884
CNTV_CTL_EL0 : 0x0000000000000000
CNTV_CVAL_EL0: 0x0000000000000000
INFO: vtimer-busy-loop: After timer: 0x000000000027ae86
INFO: vtimer-busy-loop: Expected   : 0x000000000027415b
INFO: vtimer-busy-loop: Difference : 450 us
PASS: vtimer-busy-loop: latency within 10 ms
FAIL: vtimer-busy-loop: interrupt received
PASS: vtimer-busy-loop: not pending before
FAIL: vtimer-busy-loop: interrupt signal pending
PASS: vtimer-busy-loop: no interrupt when timer is disabled
PASS: vtimer-busy-loop: interrupt signal no longer pending
PASS: vtimer-busy-loop: interrupt signal not pending
INFO: vtimer-busy-loop: waiting for interrupt...
qemu-system-aarch64: terminating on signal 15 from pid 112137 (timeout)


Thanks,
drew
