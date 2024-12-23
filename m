Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53BB0CA6F
	for <kvmarm@lists.linux.dev>; Mon, 23 Dec 2024 14:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734964667; cv=none; b=UMjmIR9v2SHRfc314WIR9UyhK/EGfi5B7GA2SoemjdqtiQWLSLeqsN+haRWqgMFwKGgHNjgy0TxHWwjgRCTfFklAJXMJqSKNMG92u79roa5Ouzvh7lObUT4RIPjYx/7l3/ROpzwrMfC3SGTwgPF03PDwnGhyMHoAV3CZrrJM6xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734964667; c=relaxed/simple;
	bh=lw7lIvErJaBbCirvsGojhEfatCngB8nndlwtgua5WJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hT3f/lI5hAQULhlXz9/seb/ENVMby30dFomjJbCTpRmggyZeENNw67wtWdYe4o8fm1qZuoRWoBexZk5dqOhgVY+gj01fx/ArI66San2jk7gJgmsbi1ylw4TaqfEw1aiWPEY1xxAlZNOfH8ffLS/1dD/BvLmEx9ItEZq5Qr/ZthY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DFA8150C;
	Mon, 23 Dec 2024 06:38:11 -0800 (PST)
Received: from [10.1.31.134] (e121487-lin.cambridge.arm.com [10.1.31.134])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A3EE3F59E;
	Mon, 23 Dec 2024 06:37:42 -0800 (PST)
Message-ID: <0fc53bdf-f919-40b9-8530-d11593ec55f7@arm.com>
Date: Mon, 23 Dec 2024 14:37:40 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add basic MTE test
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: kvmarm@lists.linux.dev, nikos.nikoleris@arm.com, andrew.jones@linux.dev,
 eric.auger@redhat.com
References: <20241212103447.34593-1-vladimir.murzin@arm.com>
 <Z2lRk_NLHxDPvmrS@raptor>
Content-Language: en-GB
From: Vladimir Murzin <vladimir.murzin@arm.com>
In-Reply-To: <Z2lRk_NLHxDPvmrS@raptor>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alexandru,

On 12/23/24 12:03, Alexandru Elisei wrote:
> Hi Vladimir,
> 
> The patch looks good, but it just occured to me, the tests do a great job
> checking that tagged accesses fail when they should be failing, but they don't
> check that taggedd accesses *succeed* when they should not be failing. I think
> that's useful to have at the start of each test, if nothing just as a sanity
> check.
> 

Well, there are successful tagged access, yet with zero tag :) We can move to
non-zero tag, something like

static inline void mte_memset(void *addr, int val, size_t size)
{
	unsigned long old = mte_set_tcf(MTE_TCF_SYNC);
	memset(addr, val, size);
	mte_set_tcf(old);
}

...

static void mte_async_test(void)
{
	unsigned int *mem = tagged(alloc_page(), 3);
	unsigned int val = 0;

	mte_init();
	mmu_set_tagged(current_thread_info()->pgtable, (unsigned long)mem);
	mte_set_tag(mem, PAGE_SIZE, 3);
	mte_memset(mem, 0xff, PAGE_SIZE);
	mte_set_tcf(MTE_TCF_ASYNC);
...

<snip>

>> -CFLAGS += -mgeneral-regs-only
>> +CFLAGS += -mgeneral-regs-only -save-temps
> Hmm.. I can't seem to figure out why -save-temps is required for the MTE test.
>>From man gcc, -save-temps is a knob that tells gcc not to delete the
> intermediate files that it generates. Am I missing something?

No, it is not required and just leftover from my other debug...

<snip>

>> +
>> +	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_DABT_EL1, mte_fault_handler);
>> +
>> +	mem_read(mem, 1, &val);
> When I came back to the patch, I read this and I thought that the value 1
> represents what the value of 'val' should be. Do you think the code would be
> easier to read if mem_read() took a tagged address directly, i.e:
> 
> 	mem_read(tagged(mem, 1), &val);
> 
> Up to you what you prefer.
> 

Ack.

<snip>

>> +	report((*mem == 0xaaaaaaaa) && (get_clear_tfsr() == 1), "write");
> Do you think it would be easier to understand the code if TFSR_EL1_TF0 would be
> used here instead of 1? Up to you what you prefer, but if you do decide to use
> a define, please also add TFSR_EL1_TF1, just in case someone decides to expand
> the test some day with an address in the upper virtual address space.

Ack.

<snip>
>> +int main(int argc, char *argv[])
>> +{
>> +
>> +	unsigned int version = mte_version();
>> +
>> +	if (version < 2) {
>> +		report_skip("No MTE support, skip...\n");
>> +		return -1;
> Can you change the return to:
> 
> 		return report_summary();
> 
> Explanation below.

Ack.

> 
>> +	}
>> +
>> +	if (argc < 2)
>> +		report_abort("no test specified");
>> +
>> +	report_prefix_pushf("mte");
> report_prefix_push() (without the 'f' at the end).
> 

Ack.

<snip>

>> +}
>> diff --git a/arm/run b/arm/run
>> index efdd44ce..b129e4e0 100755
>> --- a/arm/run
>> +++ b/arm/run
>> @@ -29,7 +29,8 @@ if ! $qemu -machine '?' | grep -q 'ARM Virtual Machine'; then
>>  	exit 2
>>  fi
>>  
>> -M='-machine virt'
>> +MACHINE="virt"
>> +M="-machine $MACHINE$MACHINE_PROPS"
> Sorry, but I still don't understand what $MACHINE_PROPS does, I can't seem to
> find where it's initialized :(
> 

I'm not sure what you are looking/asking for :( 

My last reply [1] demonstrates usage for $MACHINE_PROPS

QEMU=qemu-system-aarch64 ACCEL=tcg MACHINE_PROPS=",mte=on" arm/run arm/mte.flat -append "sync"

>>  
>>  if [ "$ACCEL" = "kvm" ]; then
>>  	if $qemu $M,\? | grep -q gic-version; then
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index 2bdad67d..9b428c02 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -271,3 +271,22 @@ smp = 2
>>  groups = nodefault
>>  accel = kvm
>>  arch = arm64
>> +
>> +# MTE tests
>> +[mte-sync]
>> +file = mte.flat
>> +groups = nodefault
>> +extra_params = -append 'sync'
>> +arch = arm64
>> +
>> +[mte-async]
>> +file = mte.flat
>> +groups = nodefault
>> +extra_params = -append 'async'
>> +arch = arm64
>> +
>> +[mte-asymm]
>> +file = mte.flat
>> +groups = nodefault
>> +extra_params = -append 'asymm'
>> +arch = arm64
> I think it would be better if the tests are not in the nodefault group. As far
> as I can tell, they are in the nondefault group because not all hardware and KVM
> versions support MTE (please correct me if I'm wrong).
> 
> If the tests are in the nodefault group, then a CI administrator must
> keep track of those machine that have MTE and manually run them, otherwise they
> will never get run, even if the machines support it.
> 
> If you remove them from the nondefault group, with the change I proposed to
> main() the test runner will not mark them as failed on systems that don't
> support MTE:
> 
> $ ./run_tests.sh
> [..]
> SKIP mte-sync (1 tests, 1 skipped)
> SKIP mte-async (1 tests, 1 skipped)
> SKIP mte-asymm (1 tests, 1 skipped)
> 
> but they will get automatically run on systems that support MTE.
> 

Looks really neat!

> Also, would you mind putting the tests in the mte group:
> 
> 	groups = mte
> 
> so they can be run with ./run_tests.sh -g mte.
> 

Ack.

[1] https://lore.kernel.org/all/c2d9b61b-7dce-422b-8a3c-898f1003c9e4@arm.com/T/#t

Cheers
Vladimir
