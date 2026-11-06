Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793987113;
	b=qs6JqVL2izV0hdj21S2j81W7BI1wzKFjx7jt5KxxPmZn0WGhxrDRqtttsojhjleWbrXy
	 cUlKYgyXt45Vypp/lhBAOmjrbtnMGcmwdFgKrcJnbYKddSk2yf6ogaQ927Vk5TUyR2mYO
	 kOGqdqio7pyQMoVks/dzL7m9YDQCe4CstZlpD/sU/TyXTXo2GNdpgTF71u0l0Ou3QSeHJ
	 siu+xCBWvunnsICpiBbXj8sh3XNM3yQ90b954U3YoTzWfIUtOCQeJDYGXyEHImZtqhgbx
	 crtxUfv+YVf4fmhrLpmCAH7O09IV66GrF5sw2e0gAdJfCo343WGlA5MHtbu1tNbH0dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793987113;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=xp0OQbCL2sJOSaJbxnDT2s8b4hQsI5rqREveuXAdz7o=;
	b=ehWN0Sd6r5ueUQDMrLqV1WcCvNzUgB5gFy+Tm/iW90j1YjJjEZrcYPTt2AlfH8wCRtyh
	 604QDDiEDV0egxIvUBV3ARtt+DH02URshwNDoEWumZIqsnO+Rxrxi6ywUjTebAm1YAIlR
	 EZUplJCF9ULoSnMqLK4woQo1NQ8FE/eFe6eQSLuv7mHmce0n7kS5GMvUvY5Whea3LUqQj
	 6NkXBPtlfETJX/QXBawhwg9H5Vf3qZRwJx1onEqjZdQuzglatSL6IuLM8bobrMSEkxk9t
	 LjrWE77l3kSpDX8S8wYMH/uMoOOB6ZFVbF6AHM6gNIA/NWy5IwCFSAOOnNhOljTwALw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eINJokh1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F98606A326
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 17:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eINJokh1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BD21F0089F;
	Fri,  6 Nov 2026 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793987113;
	bh=xp0OQbCL2sJOSaJbxnDT2s8b4hQsI5rqREveuXAdz7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eINJokh1DW0Puh8DZWKlpAMnLFnUUgvJwE9J1cCCZCmOMPt729ghCPayYLhsmiLvn
	 EvrMmoO2GJ5ykJVq5TtA6phYkTYJ8nkVUlQ8c5aFkk+DaPzC8Rygt/M7vWzigfML8e
	 pAXu5QxI5AIsIar8gVgC5OSumSm3iEwii0dTrWuvCYibkxfBcn3ruQ3B+r/HTb6T8W
	 aMeMwBAJLHyn4eWR9wqGvDV67/MMj1bu6Sx8nPiKAQKvFAp9AfYKF79DsAByL+A5HD
	 W9v5S0//OqMSokMW+974ZGg4D3UIr+vCPR/msAco2dJHT3bTnU1ALDwCjgIH8gY9Dx
	 25KUiOXh5gSEg==
Date: Fri, 6 Nov 2026 09:45:12 -0800
From: Oliver Upton <oupton@kernel.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH v3 4/5] KVM: arm64: Convert TCR_EL2 to config-driven
 sanitisation
Message-ID: <au4SKGsAAdsPm9SD@kernel.org>
References: <20261029223732.103785-1-oupton@kernel.org>
 <20261029223732.103785-5-oupton@kernel.org>
 <5e8a61c2-24ff-46a1-819f-94fcd91c9688@sirena.org.uk>
 <3pof5ftjdhngkbwn3ixnlynryabl67gfhwrfr54xnizo3iytwi@cicn7hku5i74>
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
In-Reply-To: <3pof5ftjdhngkbwn3ixnlynryabl67gfhwrfr54xnizo3iytwi@cicn7hku5i74>

Hi,

On Fri, Nov 06, 2026 at 05:30:57PM +0000, Wei-Lin Chang wrote:
> On Fri, Nov 06, 2026 at 11:34:47AM +0000, Mark Brown wrote:
> > On Thu, Oct 29, 2026 at 03:37:31PM -0700, Oliver Upton wrote:
> > > From: Wei-Lin Chang <weilin.chang@arm.com>
> > > 
> > > Feature dependencies of the fields in TCR_EL2 are extracted from
> > > Registers.json of the BSD licenced AARCHMRS
> > > (AARCHMRS_OPENSOURCE_A_profile_FAT-2026-06).
> > > 
> > > Places where we slightly deviate from the above:
> > > 
> > >  - Stick to the ARM ARM M.c requirement for TCR_EL2.TCMA*, which only
> > >    depends on FEAT_MTE2. This avoids updating ID_AA64PFR2_EL1 with new
> > >    VMTE* definitions that we don't know the meaning of, as they aren't
> > >    present in the ARM ARM yet.
> > > 
> > >  - Ignore TCR_EL2.DS's requirement of needing the effective value of
> > >    TCR2_EL2.D128 be 0. This requires runtime detection of TCR2_EL2.D128
> > >    and we don't have D128 support yet.
> > > 
> > >  - TCR_EL2.AS is dependent on FEAT_ASID16, this information is missing
> > >    from the json.
> > 
> > I'm seeing a regression in -next for the pre_fault_memory_test selftest
> > when run on qemu with EL2 and NV enabled which bisects to this commit in
> > -next:

Thanks for reporting this Mark. Next time can you also include the QEMU
command line that reproduces the issue?

> > # selftests: kvm: pre_fault_memory_test
> > <47>[ 1358.708301] systemd-journald[75]: Sent WATCHDOG=1 notification.
> > # Random seed: 0xe322a57
> > # Testing guest mode: PA-bits:52,  VA-bits:48,  4K pages
> > # Testing memory backing src type: anonymous
> > #
> > # ==== Test Assertion Failure ====
> > #   pre_fault_memory_test.c:260: false
> > #   pid=1888 tid=1888 errno=2 - No such file or directory
> > # sh: 1: addr2line: not found
> > #   Unknown ucall 0x0.
> > not ok 48 selftests: kvm: pre_fault_memory_test # exit=254
> > 
> > The NV pre fault test appears to run fine in the same run, and the test
> > passes when run on the same qemu version in vanilla VHE mode.
> > 
> > Full log:
> > 
> >   https://lava.sirena.org.uk/scheduler/job/196379#L2476
> > 
> 
> The selftests are running vCPUs in vEL2 with 52-bit page tables it seems
> like. NV doesn't support 52-bit and this commit enforces that by forcing
> vCPU TCR_EL2.DS (hardware TCR_EL1.DS) to 0, so bad things happen.
> 
> aarch64_get_supported_page_sizes() asks KVM for the preferred target,
> which does not include KVM_ARM_VCPU_HAS_EL2. Without
> KVM_ARM_VCPU_HAS_EL2, 52bit ipa is permitted if the host supports it.
> 
> Then with 52-bit PA deemed supported, the selftest builds page tables
> with the 52-bit format for that case.
> 
> Then when creating the actual vCPU to run, kvm_get_default_vcpu_target()
> includes KVM_ARM_VCPU_HAS_EL2.
> 
> One potential solution is make vm_supports_el2() return false when
> vm->pa_bits > 48.

Bit of a hack but gets the job done, do you have time to send a patch?
I'm sure we'll get around to doing LPA2 long before anything useful
actually shows up anyway.

Thanks,
Oliver
