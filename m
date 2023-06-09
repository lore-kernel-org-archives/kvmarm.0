Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 476DB747F
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 14:06:41 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 94222AB6;
	Fri,  9 Jun 2023 07:07:24 -0700 (PDT)
Received: from [10.57.25.151] (unknown [10.57.25.151])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 150F23F663;
	Fri,  9 Jun 2023 07:06:37 -0700 (PDT)
Message-ID: <32f41722-2941-55b5-d11b-200e43319c8e@arm.com>
Date: Fri, 9 Jun 2023 15:06:36 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [kvm-unit-tests PATCH v6 12/32] arm64: Add support for
 discovering the UART through ACPI
Content-Language: en-GB
To: Andrew Jones <andrew.jones@linux.dev>, Nadav Amit <nadav.amit@gmail.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Paolo Bonzini <pbonzini@redhat.com>, alexandru.elisei@arm.com,
 ricarkol@google.com, shahuang@redhat.com
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
 <20230530160924.82158-13-nikos.nikoleris@arm.com>
 <7DA92888-3042-4036-A769-E9F941AF98A5@gmail.com>
 <BB231709-0C9D-4085-ABFA-B6C37EF537CA@gmail.com>
 <20230609-2ef801d526b6f0256720cf24@orel>
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230609-2ef801d526b6f0256720cf24@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09/06/2023 08:21, Andrew Jones wrote:
> On Thu, Jun 08, 2023 at 10:24:11AM -0700, Nadav Amit wrote:
>>
>>
>>> On Jun 8, 2023, at 10:18 AM, Nadav Amit <nadav.amit@gmail.com> wrote:
>>>
>>>
>>> On May 30, 2023, at 9:09 AM, Nikos Nikoleris <nikos.nikoleris@arm.com> wrote:
>>>
>>>>
>>>> +static void uart0_init_acpi(void)
>>>> +{
>>>> + struct spcr_descriptor *spcr = find_acpi_table_addr(SPCR_SIGNATURE);
>>>> +
>>>> + assert_msg(spcr, "Unable to find ACPI SPCR");
>>>> + uart0_base = ioremap(spcr->serial_port.address, spcr->serial_port.bit_width);
>>>> +}
>>>
>>> Is it possible as a fallback, is SPCR is not available, to UART_EARLY_BASE as
>>> address and bit_width as bit-width?
>>>
>>> I would appreciate it, since it would help my setup.
>>>
>>
>> Ugh - typo, 8 as bit-width for the fallback (ioremap with these parameters to
>> make my request clear).
>>
> 
> That sounds reasonable to me. Nikos, can you send a fixup! patch? I'll
> squash it in.
> 

I am not against this idea, but it's not something that we do when we 
setup the uart through FDT. Should ACPI behave differently? Is this 
really a fixup? Either ACPI will setup things differently or we'll 
change the FDT and ACPI path.

Thanks,

Nikos
