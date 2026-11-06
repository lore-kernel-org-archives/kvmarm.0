Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989453;
	b=e+n9uAwBnMYA1ukDNf6rqy68I7CsJX6+jxKThxnG5rxpnuc4H1L3yt3LSfAGBAnU7c46
	 LUX9YzuzgPQ/LwbJ1wVuS/j0qDpBe7ZAWr8103n/Y2VX6FXARvHdlxtit/QBkUfASWV5i
	 iorwVEQANGUqtOg0IIMBf+i99ob3IIJii8O5d8NTzwTAJLZRKvsj+Pb+GmBDF0T51nYkM
	 cZPJNEyMfmU2U7aQ5mkzyrPjt+Vi6790BDsoHVNJB1WX1R1OdTW7BLTgaone+pZLoGNPq
	 4rVscC2Nd2Q6VjlWX1Nr+gWIzT7wdBJ/KstObEQUk9QalMdYT+4H+21N0CWQNxCbXsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989453;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=zPz7D1qRjAoTApHfFjD0MYySVm6Tf+TnnJY4cVeogls=;
	b=4CMEYT280KzwbOmbkpAYDkF2EKSb2cg+dAqpLqS2tGWwyzzQzWHSn9LjeXJwH3Rg2yUl
	 3PTAZfiyZEJ/5RUTJdCUXNBy4RC6pUwUhx9iZ14aXWao1zw2L+keEBbJc63cIas97Ci75
	 l4NkVPROpnYkZ42t6NGOC3nKaDFfhUHAqY73+LvGzR7ZCuVqbRVeBHPGh3ZSyKNHd+ija
	 wnDlcvXg8/Yl2Zt0NHtRpY1NM7xWBJB39RX1pWWpQqAse5naqHvGHsXqeXjU5HP1VznDd
	 5RwoEUZgDctUaX1pO31EqATkuEms4vFN6Dol8E4Ta4OnSEzmSMzw2bcmQQZiTfzUaHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vvmwmrUj;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3434606A326
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 18:24:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3434606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vvmwmrUj
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCAAE1650;
	Fri,  6 Nov 2026 10:24:08 -0800 (PST)
Received: from thinkpad-e142931.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E90B3F673;
	Fri,  6 Nov 2026 10:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793989451; bh=zW7wDirRGVdZ5qlB3lgk1mFuk3vtrQm1wHc2VbORwQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vvmwmrUjQAakrb7T7s4tZh9qRzwz3/+JYs882u1UT58QsIQip4/RuokFwFbPapqzI
	 NzFkDs9ltWwJ6ATddic1q6cSJgm+1QlR3PT9ggpkLEHbV3ta/iuIojjcrRkhnpJe3y
	 Bn4MGLaxy6nViT150Cd6EFNwHzVhV/XXXMx8b2NA=
Date: Fri, 6 Nov 2026 18:24:03 +0000
From: Wei-Lin Chang <weilin.chang@arm.com>
To: Oliver Upton <oupton@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev, 
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <fuad.tabba@linux.dev>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v3 4/5] KVM: arm64: Convert TCR_EL2 to config-driven
 sanitisation
Message-ID: <giyzumuc6nrlmu77s77nphdr77z6nl4mvzehbgdckf5nweippl@eu77j3iekugc>
References: <20261029223732.103785-1-oupton@kernel.org>
 <20261029223732.103785-5-oupton@kernel.org>
 <5e8a61c2-24ff-46a1-819f-94fcd91c9688@sirena.org.uk>
 <3pof5ftjdhngkbwn3ixnlynryabl67gfhwrfr54xnizo3iytwi@cicn7hku5i74>
 <au4SKGsAAdsPm9SD@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au4SKGsAAdsPm9SD@kernel.org>

On Fri, Nov 06, 2026 at 09:45:12AM -0800, Oliver Upton wrote:
> Hi,
> 
> On Fri, Nov 06, 2026 at 05:30:57PM +0000, Wei-Lin Chang wrote:
> > On Fri, Nov 06, 2026 at 11:34:47AM +0000, Mark Brown wrote:
> > > On Thu, Oct 29, 2026 at 03:37:31PM -0700, Oliver Upton wrote:
> > > > From: Wei-Lin Chang <weilin.chang@arm.com>
> > > > 
> > > > Feature dependencies of the fields in TCR_EL2 are extracted from
> > > > Registers.json of the BSD licenced AARCHMRS
> > > > (AARCHMRS_OPENSOURCE_A_profile_FAT-2026-06).
> > > > 
> > > > Places where we slightly deviate from the above:
> > > > 
> > > >  - Stick to the ARM ARM M.c requirement for TCR_EL2.TCMA*, which only
> > > >    depends on FEAT_MTE2. This avoids updating ID_AA64PFR2_EL1 with new
> > > >    VMTE* definitions that we don't know the meaning of, as they aren't
> > > >    present in the ARM ARM yet.
> > > > 
> > > >  - Ignore TCR_EL2.DS's requirement of needing the effective value of
> > > >    TCR2_EL2.D128 be 0. This requires runtime detection of TCR2_EL2.D128
> > > >    and we don't have D128 support yet.
> > > > 
> > > >  - TCR_EL2.AS is dependent on FEAT_ASID16, this information is missing
> > > >    from the json.
> > > 
> > > I'm seeing a regression in -next for the pre_fault_memory_test selftest
> > > when run on qemu with EL2 and NV enabled which bisects to this commit in
> > > -next:
> 
> Thanks for reporting this Mark. Next time can you also include the QEMU
> command line that reproduces the issue?
> 
> > > # selftests: kvm: pre_fault_memory_test
> > > <47>[ 1358.708301] systemd-journald[75]: Sent WATCHDOG=1 notification.
> > > # Random seed: 0xe322a57
> > > # Testing guest mode: PA-bits:52,  VA-bits:48,  4K pages
> > > # Testing memory backing src type: anonymous
> > > #
> > > # ==== Test Assertion Failure ====
> > > #   pre_fault_memory_test.c:260: false
> > > #   pid=1888 tid=1888 errno=2 - No such file or directory
> > > # sh: 1: addr2line: not found
> > > #   Unknown ucall 0x0.
> > > not ok 48 selftests: kvm: pre_fault_memory_test # exit=254
> > > 
> > > The NV pre fault test appears to run fine in the same run, and the test
> > > passes when run on the same qemu version in vanilla VHE mode.
> > > 
> > > Full log:
> > > 
> > >   https://lava.sirena.org.uk/scheduler/job/196379#L2476
> > > 
> > 
> > The selftests are running vCPUs in vEL2 with 52-bit page tables it seems
> > like. NV doesn't support 52-bit and this commit enforces that by forcing
> > vCPU TCR_EL2.DS (hardware TCR_EL1.DS) to 0, so bad things happen.
> > 
> > aarch64_get_supported_page_sizes() asks KVM for the preferred target,
> > which does not include KVM_ARM_VCPU_HAS_EL2. Without
> > KVM_ARM_VCPU_HAS_EL2, 52bit ipa is permitted if the host supports it.
> > 
> > Then with 52-bit PA deemed supported, the selftest builds page tables
> > with the 52-bit format for that case.
> > 
> > Then when creating the actual vCPU to run, kvm_get_default_vcpu_target()
> > includes KVM_ARM_VCPU_HAS_EL2.
> > 
> > One potential solution is make vm_supports_el2() return false when
> > vm->pa_bits > 48.
> 
> Bit of a hack but gets the job done, do you have time to send a patch?
> I'm sure we'll get around to doing LPA2 long before anything useful
> actually shows up anyway.

Ack, I can do it.

Thanks,
Wei-Lin Chang

> 
> Thanks,
> Oliver
