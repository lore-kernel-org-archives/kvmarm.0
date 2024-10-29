Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ADC2201265
	for <kvmarm@lists.linux.dev>; Tue, 29 Oct 2024 07:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730187407; cv=none; b=GLFeLcGRJeLVoPvRVvfGtWaDo4QqUjP7hMjI84mUZhxtxBHuVsFAy1zg4XAsaMvurJcTgSJega9jeo41KDS7k3R+soMSnVO5NtdOp8aDTaN0T3F5TswbRxtzRe/oub9PBKUJKvGlkHzeJ/1RAV+OK7eXnLN7/kD22SWo9dhyKEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730187407; c=relaxed/simple;
	bh=yRzoC+KjUUDkGESUErCpOUivqMftMbTVJnBNhXXmmcE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q+4ooTB9AFuF2Tb6vY1o/LdayVWV1yU8rhfJxm7T9XmPPKX2ni4HlRGa7yYM/lQHd+d0IVsxlAscnKWUGP8q1u8QfYtblgo/GVRlFEhVcMs9Wna7W/7ztkwPWwdsE1jC/oTv8Q+eNNMZs2+ZVowF8EG7LKuEvzLl0wvTf9TQ7VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 124F813D5;
	Tue, 29 Oct 2024 00:37:14 -0700 (PDT)
Received: from [10.163.43.192] (unknown [10.163.43.192])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AC0EB3F66E;
	Tue, 29 Oct 2024 00:36:40 -0700 (PDT)
Message-ID: <f65af1fe-b500-499e-84dd-954700583475@arm.com>
Date: Tue, 29 Oct 2024 13:06:38 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
References: <20241001043602.1116991-1-anshuman.khandual@arm.com>
 <20241001043602.1116991-4-anshuman.khandual@arm.com>
 <ZxfGAHAn6I41ZLZV@J2N7QTR9R3> <2310454a-99c6-4ff9-80f7-8707fbfaf5a6@arm.com>
 <Zx-H8IU2wZmyowGe@J2N7QTR9R3>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <Zx-H8IU2wZmyowGe@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/28/24 18:17, Mark Rutland wrote:
> On Wed, Oct 23, 2024 at 01:01:52PM +0530, Anshuman Khandual wrote:
>>
>>
>> On 10/22/24 21:04, Mark Rutland wrote:
>>> On Tue, Oct 01, 2024 at 10:06:02AM +0530, Anshuman Khandual wrote:
> 
> [...]
> 
>>> Wherever this lives it needs a comment explaining what it is doing and
>>> why. I assume this is intended to protect the bank in sequences like:
>>>
>>> 	MSR	MDSELR, <...>
>>> 	ISB
>>> 	MRS	<..._, BANKED_REGISTER
>>
>> Correct, it is protecting the above sequence.
>>
>>>
>>> ... but is theat suffucient for mutual exclusion against
>>> exception handlers, or does that come from somewhere else?
>>
>> Looking at all existing use cases for breakpoint/watchpoints, it should
>> be sufficient to protect against mutual exclusion. But thinking, do you
>> have a particular exception handler scenario in mind where this might
>> still be problematic ? Will keep looking into it.
> 
> Where does the mutual exclusion come from for the existing sequences?

Bank selection followed by indexed read/write, inherently requires mutual
exclusion (ensuring that both these steps executed together) in order to
prevent read/write into wrong registers. That being said, HW breakpoints
get used in multiple different places such as perf, ptrace, debug monitor
based single stepping etc calling platform functions which operate on the
HW breakpoint registers here.

preempt_disable()/enable() sequence in the very last leaf level helpers
such as [read|write]_wb_reg(), will ensure required mutual exclusion.

> We should be able to descrive should be able to describe that in the
> commit message or in a comment somewhere (or better, with some
> assertions that get tested).

Planning to add a comment - something like this both for read and write
helpers.
       /*
        * Bank selection in MDSELR_EL1, followed by indexed read from
        * [break|watch]point registers cannot be interrupted, as that
        * might cause misread from wrong targets. Hence this requires
        * mutual exclusion via preventing any preemption.
        */

But regarding adding assertions, could you give some more details and
it will be great to have some relevant examples as well.

> 
> For example, what prevents watchpoint_handler() from firing in the
> middle of arch_install_hw_breakpoint() or
> arch_uninstall_hw_breakpoint()?

If perf is the only user, watchpoint_handler() will not get triggered
without watchpoints being installed via arch_install_hw_breakpoint().
Similarly once they get uninstalled via arch_uninstall_hw_breakpoint()
there will not be active watchpoints to trigger the handler. Although
there are other users (ptrace, debug monitor etc) besides perf which
could also be active simultaneously and race with each other ? TBH, I
am not sure.

> 
> Is the existing code correct?

I have not tested the concurrency aspects of the HW breakpoints enough
to be able to answer that question. But if there is a particular concern
here, happy to look into that.

But wondering how does this new bank indexed read/write mechanism (after
taking care of the mutual exclusion in the leaf level helpers such as
[read| write]_wb_reg()) still makes the existing concurrency situation
worse off than earlier ?
