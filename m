Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 719158828
	for <kvmarm@lists.linux.dev>; Mon, 12 Jun 2023 09:52:08 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE63D1FB;
	Mon, 12 Jun 2023 02:52:51 -0700 (PDT)
Received: from [192.168.13.137] (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8F7973F663;
	Mon, 12 Jun 2023 02:52:04 -0700 (PDT)
Message-ID: <5fb09d21-437d-f83e-120f-8908a9b354c1@arm.com>
Date: Mon, 12 Jun 2023 10:52:00 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, Nadav Amit <nadav.amit@gmail.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com,
 ricarkol@google.com, shahuang@redhat.com
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <CC2B570B-9EE0-4686-ADF3-82D1ECDD5D8A@gmail.com>
 <20230612-6e1f6fac1759f06309be3342@orel>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230612-6e1f6fac1759f06309be3342@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/06/2023 08:52, Andrew Jones wrote:
> On Sat, Jun 10, 2023 at 01:32:59AM -0700, Nadav Amit wrote:
>>
>>> On May 30, 2023, at 9:08 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> wrote:
>>>
>>> Hello,
>>>
>>> This series adds initial support for building arm64 tests as EFI
>>> apps and running them under QEMU. Much like x86_64, we import external
>>> dependencies from gnu-efi and adapt them to work with types and other
>>> assumptions from kvm-unit-tests. In addition, this series adds support
>>> for enumerating parts of the system using ACPI.
>>
>> Just an issue I encountered, which I am not sure is arm64 specific:
>>
>> All the printf’s in efi_main() are before current_thread_info() is
>> initialized (or even memset’d to zero, as done in setup_efi).
>>
>> But printf() calls puts() which checks if mmu_enabled(). And
>> mmu_enabled() uses is_user() and current_thread_info()->cpu, both
>> of which read uninitialized data from current_thread_info().
>>
>> IOW: Any printf in efi_main() can cause a crash.
>>
> 
> Nice catch, Nadav. Nikos, shouldn't we drop the memset() in setup_efi and
> put a zero_range call, similar to the one in arm/cstart64.S which zero's
> the thread-info area, in arm/efi/crt0-efi-aarch64.S?
> 

While I haven't run into any problems with this in this series, I had in 
a previous version and back then the solution was this patch:

993c37be - arm/arm64: Zero BSS and stack at startup

So I agree we should drop the memset and call some macro like zero_range 
in arm/efi/crt0-efi-aarch64.S.

Let me know if you want me to send a patch for this.

Thanks,

Nikos
