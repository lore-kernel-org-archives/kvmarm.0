Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9465195
	for <kvmarm@lists.linux.dev>; Mon, 30 Dec 2024 15:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735571996; cv=none; b=jB9JSgY3hFh2+MiYPXIb5GEmVAoYEt0e7mkY8ZEafmTD+BBMg6GailBURZ00XWdSGfViSNmp8IZ6jzh6ByLHpGgAh2rjeeTXXnBKQzSDEys5Ockd/h6pKdp66PXfXf1vBobXDFm77ViHARz4+SlIp2vWJIxMkPp2uf/2pW4bBfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735571996; c=relaxed/simple;
	bh=S/Ll8f27Fe/EqeKTPX0yHtRu6tAE6lX9HA1plT4XLHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eCQwo7E7nl0k9Vlj8wQqURCzOmznR6AyX7HGm+nOAlkElildMNKs2OPspRbByJd4lseYwEstppW2ulHKl8S13Km5yyNzeUZvd/MYcSycINELpTsqfe2jUdQ7hVw9DLObPhTnQf8TzBLS+rDl4lYddop2l7Hp8DcsxNn1QfJDwSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2683143D;
	Mon, 30 Dec 2024 07:20:20 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DA6913F673;
	Mon, 30 Dec 2024 07:19:51 -0800 (PST)
Date: Mon, 30 Dec 2024 15:19:48 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: kvmarm@lists.linux.dev, nikos.nikoleris@arm.com, andrew.jones@linux.dev,
	eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add basic MTE test
Message-ID: <Z3K6FLG2qfwphAfS@raptor>
References: <20241212103447.34593-1-vladimir.murzin@arm.com>
 <Z2lRk_NLHxDPvmrS@raptor>
 <0fc53bdf-f919-40b9-8530-d11593ec55f7@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fc53bdf-f919-40b9-8530-d11593ec55f7@arm.com>

Hi Vladimir,

On Mon, Dec 23, 2024 at 02:37:40PM +0000, Vladimir Murzin wrote:
> Hi Alexandru,
> 
> On 12/23/24 12:03, Alexandru Elisei wrote:
> > Hi Vladimir,
> > 
> > The patch looks good, but it just occured to me, the tests do a great job
> > checking that tagged accesses fail when they should be failing, but they don't
> > check that taggedd accesses *succeed* when they should not be failing. I think
> > that's useful to have at the start of each test, if nothing just as a sanity
> > check.
> > 
> 
> Well, there are successful tagged access, yet with zero tag :) We can move to
> non-zero tag, something like
> 
> static inline void mte_memset(void *addr, int val, size_t size)
> {
> 	unsigned long old = mte_set_tcf(MTE_TCF_SYNC);
> 	memset(addr, val, size);
> 	mte_set_tcf(old);
> }
> 
> ...
> 
> static void mte_async_test(void)
> {
> 	unsigned int *mem = tagged(alloc_page(), 3);
> 	unsigned int val = 0;
> 
> 	mte_init();
> 	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
> 	mte_set_tag(mem, PAGE_SIZE, 3);
> 	mte_memset(mem, 0xff, PAGE_SIZE);
> 	mte_set_tcf(MTE_TCF_ASYNC);
> ...

I have a few ideas here:

* Tag checked accesses when the address bits [59:55] are 0 are also controlled
with TCR_EL1.TCMA0, and the bit is set to 0 in asm_mmu_enabled() - this is what
we want. But if you want to explicitely check tagged accesses with the zero tag
I would suggest that the bit is explicitely cleared first (probably in
mte_init()), to make sure the tests starts with a known good configuration (very
useful for debugging!) and to avoid surprises if something changes in the
startup sequence of a test.

* All tag checked accesses should probably happen after setting SCTLR_EL1.TCF,
since the field is set to 0b00 in cstart64.S (when SCTLR_EL1 is set to
INIT_SCTLR_EL1_MMU_OFF).

I don't have a preference, up to you to decide (you can even go so far as to
check that TCR_EL1.TCMA0 works as expected if you feel it's useful), I was just
pointing out some of the choices you have.

[..]
> >> +}
> >> diff --git a/arm/run b/arm/run
> >> index efdd44ce..b129e4e0 100755
> >> --- a/arm/run
> >> +++ b/arm/run
> >> @@ -29,7 +29,8 @@ if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
> >>  	exit 2
> >>  fi
> >>  
> >> -M='-machine virt'
> >> +MACHINE="virt"
> >> +M="-machine $MACHINE$MACHINE_PROPS"
> > Sorry, but I still don't understand what $MACHINE_PROPS does, I can't seem to
> > find where it's initialized :(
> > 
> 
> I'm not sure what you are looking/asking for :( 
> 
> My last reply [1] demonstrates usage for $MACHINE_PROPS
> 
> QEMU=qemu-system-aarch64 ACCEL=tcg MACHINE_PROPS=",mte=on" arm/run arm/mte.flat -append "sync"

Sorry about that, I must have missed your reply :( Adding MACHINE_PROPS is a
nifty idea, but I don't think it's good practice to depend on that to be able to
run a test. ./run_tests.sh <testname> should work without user
intervention/configuration.

For your particular example, you don't need to add a new environment
variable if you want to run the test with arm/run, you can do this instead:

QEMU=/path/to/qemu ACCEL=tcg arm/run arm/mte.flat -machine mte=on -append "sync"

arm/run passes all the parameters as they are to qemu.

In general, you can have the machine type in the unit test definition in
arm/unitests.cfg, in the 'extra_params' field, just like for the gicv2 and gicv3
tests. In theory, there's a separate 'machine' field in the test definition (see
docs/unittests.txt), but arm/arm64 ignores it.

This is what I had in mind for the test definition:

diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 9b428c02dabc..fe1011454f88 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -275,18 +275,18 @@ arch = arm64
 # MTE tests
 [mte-sync]
 file = mte.flat
-groups = nodefault
-extra_params = -append 'sync'
+groups = mte
+extra_params = -machine mte=on -append 'sync'
 arch = arm64

 [mte-async]
 file = mte.flat
-groups = nodefault
-extra_params = -append 'async'
+groups = mte
+extra_params = -machine mte=on -append 'async'
 arch = arm64

 [mte-asymm]
 file = mte.flat
-groups = nodefault
-extra_params = -append 'asymm'
+groups = mte
+extra_params = -machine mte=on -append 'asymm'
 arch = arm64

Interestingly though, when I try to run a test (either with ./run_tests.sh
mte-sync, or by trying out your example), I get this error:

qemu-system-aarch64: MTE requested, but not supported by the guest CPU

My guess is that's caused by kvm-unit-tests defaulting to cortex-a57 as the
model CPU. Changing the cpu to 'max' makes the test run. How are you getting
around this on your end?

Thanks,
Alex
