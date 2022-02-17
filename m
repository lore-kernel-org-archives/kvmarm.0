Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F033CC433F5
	for <kvmarm@archiver.kernel.org>; Sun, 20 Feb 2022 19:04:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DE8E4B1C9;
	Sun, 20 Feb 2022 14:04:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OBOVogQw2w8l; Sun, 20 Feb 2022 14:04:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC4234B131;
	Sun, 20 Feb 2022 14:04:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9092411BD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 12:11:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zHO0OWEVmkn8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Feb 2022 12:11:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 84F4C407EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Feb 2022 12:11:07 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8EB88113E;
 Thu, 17 Feb 2022 09:11:06 -0800 (PST)
Received: from [10.57.39.132] (unknown [10.57.39.132])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B02833F70D;
 Thu, 17 Feb 2022 09:11:05 -0800 (PST)
Message-ID: <9e3389dd-2d29-4eb8-60d6-f67724be1f4a@arm.com>
Date: Thu, 17 Feb 2022 17:11:03 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [kvm-unit-tests PATCH] configure: arm: Fixes to build and run
 tests on Apple Silicon
Content-Language: en-GB
To: Andrew Jones <drjones@redhat.com>
References: <20220217102806.28749-1-nikos.nikoleris@arm.com>
 <20220217161022.krzj2g37natxrj6x@gator>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20220217161022.krzj2g37natxrj6x@gator>
X-Mailman-Approved-At: Sun, 20 Feb 2022 14:04:07 -0500
Cc: pbonzini@redhat.com, thuth@redhat.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, jade.alglave@arm.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 17/02/2022 16:10, Andrew Jones wrote:
> On Thu, Feb 17, 2022 at 10:28:06AM +0000, Nikos Nikoleris wrote:
>> On MacOS:
>>
>> $> uname -m
>>
>> returns:
>>
>> arm64
>>
>> To unify how we handle the achitecture detection across different
>> systems, sed it to aarch64 which is what's typically reported on
> 
> Was "sed" a typo or a new verb for "sedding" stuff :-)

A much needed amendment to English  :)

> 
>> Linux.
>>
>> In addition, when HVF is the acceleration method on aarch64, make sure
>> we select the right processor when invoking qemu.
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   arm/run   | 3 +++
>>   configure | 2 +-
>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/arm/run b/arm/run
>> index 2153bd3..0629b69 100755
>> --- a/arm/run
>> +++ b/arm/run
>> @@ -27,6 +27,9 @@ if [ "$ACCEL" = "kvm" ]; then
>>   	if $qemu $M,\? 2>&1 | grep gic-version > /dev/null; then
>>   		M+=',gic-version=host'
>>   	fi
>> +fi
>> +
>> +if [ "$ACCEL" = "kvm" ] || [ "$ACCEL" = "hvf" ]; then
>>   	if [ "$HOST" = "aarch64" ] || [ "$HOST" = "arm" ]; then
>>   		processor="host"
>>   		if [ "$ARCH" = "arm" ] && [ "$HOST" = "aarch64" ]; then
>> diff --git a/configure b/configure
>> index 2d9c3e0..ff840c1 100755
>> --- a/configure
>> +++ b/configure
>> @@ -14,7 +14,7 @@ objcopy=objcopy
>>   objdump=objdump
>>   ar=ar
>>   addr2line=addr2line
>> -arch=$(uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/')
>> +arch=$(uname -m | sed -e 's/i.86/i386/;s/arm64/aarch64/;s/arm.*/arm/;s/ppc64.*/ppc64/')
>>   host=$arch
>>   cross_prefix=
>>   endian=""
>> -- 
>> 2.32.0 (Apple Git-132)
>>
> 
> So, with this, we've got kvm-unit-tests running on HVF now?
>  

Just a step to get everything up and running. Not all tests pass, but I 
haven't had the time to understand what's supported with HVF and what's not:

PASS selftest-setup (2 tests)
FAIL selftest-vectors-kernel (timeout; duration=90s)
PASS selftest-vectors-user (2 tests)
PASS selftest-smp (1 tests)
SKIP pci-test (KVM is needed, but not available on this host)
SKIP pmu-cycle-counter (0 tests)
SKIP pmu-event-introspection (0 tests)
SKIP pmu-event-counter-config (0 tests)
SKIP pmu-basic-event-count (0 tests)
SKIP pmu-mem-access (0 tests)
SKIP pmu-sw-incr (0 tests)
SKIP pmu-chained-counters (0 tests)
SKIP pmu-chained-sw-incr (0 tests)
SKIP pmu-chain-promotion (0 tests)
SKIP pmu-overflow-interrupt (0 tests)
PASS gicv2-ipi (3 tests)
PASS gicv2-mmio (17 tests, 1 skipped)
FAIL gicv2-mmio-up (17 tests, 2 unexpected failures)
FAIL gicv2-mmio-3p (17 tests, 3 unexpected failures)
FAIL gicv3-ipi
PASS gicv2-active (1 tests)
FAIL gicv3-active
PASS its-introspection (5 tests)
FAIL its-trigger
SKIP its-migration
SKIP its-pending-migration
SKIP its-migrate-unmapped-collection
PASS psci (4 tests)
FAIL timer (10 tests, 1 unexpected failures)
SKIP micro-bench (test marked as manual run only)
PASS cache (1 tests)
PASS debug-bp (6 tests)
SKIP debug-bp-migration
PASS debug-wp (8 tests)
SKIP debug-wp-migration
PASS debug-sstep (1 tests)
SKIP debug-sstep-migration

> Applied to arm/queue
> 
> https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue
> 

Thanks for the review!

Nikos

> Thanks,
> drew
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
