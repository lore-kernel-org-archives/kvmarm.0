From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v9 3/7] acpi: apei: Add SEI notification type support for
 ARMv8
Date: Tue, 23 Jan 2018 18:07:52 +0800
Message-ID: <53566b7c-d686-66be-ee84-a6a6257b526a@huawei.com>
References: <1515254577-6460-1-git-send-email-gengdongjiu@huawei.com>
 <1515254577-6460-4-git-send-email-gengdongjiu@huawei.com>
 <5A663DEC.8080804@arm.com> <168c3f61-0d11-13a4-c383-1f6a97d0ef37@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <168c3f61-0d11-13a4-c383-1f6a97d0ef37@huawei.com>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, robert.moore@intel.com, lv.zheng@intel.com, corbet@lwn.net, will.deacon@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

sorry fix a typo.

On 2018/1/23 17:23, gengdongjiu wrote:
>> There are problems with doing this:
>>
>> Oct. 18, 2017, 10:26 a.m. James Morse wrote:
>> | How do SEA and SEI interact?
>> |
>> | As far as I can see they can both interrupt each other, which isn't something
>> | the single in_nmi() path in APEI can handle. I thinks we should fix this
>> | first.
>>
>> [..]
>>
>> | SEA gets away with a lot of things because its synchronous. SEI isn't. Xie
>> | XiuQi pointed to the memory_failure_queue() code. We can use this directly
>> | from SEA, but not SEI. (what happens if an SError arrives while we are
>> | queueing memory_failure work from an IRQ).
>> |
>> | The one that scares me is the trace-point reporting stuff. What happens if an
>> | SError arrives while we are enabling a trace point? (these are static-keys
>> | right?)
>> |
>> |  I don't think we can just plumb SEI in like this and be done with it.
>> |  (I'm looking at teasing out the estatus cache code from being x86:NMI only.
>> |  This way we solve the same 'cant do this from NMI context' with the same
>> |  code'.)
>>
>>
>> I will post what I've got for this estatus-cache thing as an RFC, its not ready
>> to be considered yet.

Yes, I know you are dong that. Your serial's patch will consider all above things, right?
If your patch can be consider that, this patch can based on your patchset. thanks.

> 
>>

