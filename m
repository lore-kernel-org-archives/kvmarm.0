Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6AB3EBF37
	for <kvmarm@lists.linux.dev>; Fri, 23 Jan 2026 19:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769196624; cv=none; b=klQ6Mn3C1vIaauZlojvsQGFoYwLO1SlGYKoBYZNMoRZ/4MxK979QLaIwRACHOg7PIjoe1PwtSCnZjd4sVjM4JzC4nTlKFH1S/xmLzkGzSQtpQCDIaC5Rce23vYKuOzIhA1QKNOpRj/ymdS4oVtvYSdkQqtnFLeZTdSG+qBlm/8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769196624; c=relaxed/simple;
	bh=m4C9FkWQ6DigNOyqeX2F2v7JXHfidLNVXp6aVOdOX/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lUVn6F6VMydNnm6PHJF0xKCp2RUwhn5YkRA2TiLvV+v9iejL+fjSTr4OavhOpTF/KAZVK0hUkTH16Oe5vVzdyB1q5g0d2KGNsvGLrMLuHv94mvo6XL9z0nH6f0D4DB0GJ2N4TUG8PS9ED72Lzek/uVYy1EtpD3LJo5EKCVHIipU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E35301476;
	Fri, 23 Jan 2026 11:30:14 -0800 (PST)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5A7A83F632;
	Fri, 23 Jan 2026 11:30:20 -0800 (PST)
Date: Fri, 23 Jan 2026 19:30:15 +0000
From: Joey Gouly <joey.gouly@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com,
	eric.auger@redhat.com, maz@kernel.org, kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v6 00/14] arm64: EL2 support
Message-ID: <20260123193015.GA2258507@e124191.cambridge.arm.com>
References: <20260123165053.2250754-1-joey.gouly@arm.com>
 <ixq5fcyiey4prwl5luzlemznvjd6hk2pqj73rmlinnl233gfdy@b6mns7sf3dv5>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ixq5fcyiey4prwl5luzlemznvjd6hk2pqj73rmlinnl233gfdy@b6mns7sf3dv5>

On Fri, Jan 23, 2026 at 01:23:41PM -0600, Andrew Jones wrote:
> On Fri, Jan 23, 2026 at 04:50:39PM +0000, Joey Gouly wrote:
> > Hi all,
> > 
> > This series is for adding support to running the kvm-unit-tests at EL2.
> > 
> > Changes since v5[1]:
> > 	- make debug bp/wp skip on EL2
> > 	- fix microbench test
> > 	- add to CI
> > 	- applied the fixup's Drew talked about in v5
> > 
> > About this failure in micro-bench:
> > 
> > 	- micro-bench hits the assert in gicv3_lpi_alloc_tables()
> > 		lib/arm/gic-v3.c:183: assert failed: gicv3_data.redist_base[cpu]: Redistributor for cpu0 not initialized. Did cpu0 enable the GIC?	
> > 
> > in micro-bench.c lpi_prep() looks like this:
> > 
> > 	static bool lpi_prep(void)
> > 	{
> > 	        struct its_collection *col1;
> > 	        struct its_device *dev2;
> > 	        if (!gicv3_its_base())
> > 	                return false;
> > 
> > QEMU by default runs with gic-v2, so gicv3_its_base() should have returned
> > false and the lpi tests skipped. However because of the overflow mentioned in
> > the first commit (new to v6), the its_data.base was being overwritten to a
> > non-zero value.  This meant the test tried to do gic-v3 things on a gic-v2.
> 
> Nice work on the micro-bench/gic issue. Unfortunately the timer test still
> times out, and that breaks the new CI since that test is listed.

Can you drop the timer from the CI commit while I investigate? It passes here,
but I can try look more into. If everything else is working will be nice to
merge.


Thanks,
Joey

> 
> # No EL2
> 
> $ ./run_tests.sh -g timer
> PASS timer (18 tests)
> 
> # EL2
> 
> $ EL2=y ./run_tests.sh -g timer
> FAIL timer (timeout; duration=10s)
> 
> $ TIMEOUT=90s EL2=y ./run_tests.sh -g timer
> FAIL timer (timeout; duration=90s)
> 
> $ cat logs/timer.log
> timeout -k 1s --foreground 90s /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,virtualization=on -accel tcg -cpu max -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/timer.flat -smp 1 # -initrd /tmp/tmp.N15fhaPbhB
> CNTFRQ_EL0   : 0x0000000003b9aca0
> CNTPCT_EL0   : 0x00000000001d3a1f
> CNTP_CTL_EL0 : 0x0000000000000000
> CNTP_CVAL_EL0: 0x0000000000000000
> CNTVCT_EL0   : 0x00000000001d5884
> CNTV_CTL_EL0 : 0x0000000000000000
> CNTV_CVAL_EL0: 0x0000000000000000
> INFO: vtimer-busy-loop: After timer: 0x000000000027ae86
> INFO: vtimer-busy-loop: Expected   : 0x000000000027415b
> INFO: vtimer-busy-loop: Difference : 450 us
> PASS: vtimer-busy-loop: latency within 10 ms
> FAIL: vtimer-busy-loop: interrupt received
> PASS: vtimer-busy-loop: not pending before
> FAIL: vtimer-busy-loop: interrupt signal pending
> PASS: vtimer-busy-loop: no interrupt when timer is disabled
> PASS: vtimer-busy-loop: interrupt signal no longer pending
> PASS: vtimer-busy-loop: interrupt signal not pending
> INFO: vtimer-busy-loop: waiting for interrupt...
> qemu-system-aarch64: terminating on signal 15 from pid 112137 (timeout)
> 
> 
> Thanks,
> drew
