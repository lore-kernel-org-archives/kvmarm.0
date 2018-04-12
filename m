From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v11 0/4] set VSESR_EL2 by user space and support
 NOTIFY_SEI notification
Date: Thu, 12 Apr 2018 17:14:48 +0100
Message-ID: <eb65baf4-abb0-570f-f3af-61f505c9de10@arm.com>
References: <1523309796-36423-1-git-send-email-gengdongjiu@huawei.com>
 <d94439b6-9b9a-9bd0-ddec-3bb63ede9461@arm.com>
 <5161fb31-e5bb-872c-3e12-d7d38326aaca@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5161fb31-e5bb-872c-3e12-d7d38326aaca@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: gengdongjiu <gengdongjiu@huawei.com>
Cc: rkrcmar@redhat.com, corbet@lwn.net, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, lenb@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org, huangshaoyu@huawei.com, zhengxiang9@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 12/04/18 07:09, gengdongjiu wrote:
> On 2018/4/10 22:15, James Morse wrote:
>> On 09/04/18 22:36, Dongjiu Geng wrote:
>>> 1. Detect whether KVM can set set guest SError syndrome
>>> 2. Support to Set VSESR_EL2 and inject SError by user space.
>>> 3. Support live migration to keep SError pending state and VSESR_EL2 value.
>>> 4. ACPI 6.1 adds support for NOTIFY_SEI as a GHES notification mechanism, so support this
>>>    notification in software, KVM or kernel ARCH code call handle_guest_sei() to let ACP driver
>>>    to handle this notification.
>>
>> Please don't post code during the merge-window, will this apply to v4.17-rc1? We
>> can't know until its tagged.

Posting code during the merge-window isn't helpful as the kernel is a moving
target, its better to wait for an 'rc' to base it on.

> I do not know when it is merge-window. About the apply version, it does not have limited.

'git fetch' Linus' tree and look at the tags. 'v4.16' lost its '-rc' suffixes,
and there isn't a 'v4.17-rc1' yet, so we are still in the merge window.

Linus sends a message to LKML. eg:
https://lkml.org/lkml/2018/4/1/175

net-next closes shortly before the merge window, and re-opens afterwards. There
is a handy web page:
http://vger.kernel.org/~davem/net-next.html


>> This series is doing two separate things, please split it into two series.
> OK, thanks!
> 
>>
>> But on the ACPI front: I don't see how any OS can support your NOTIFY_SEI when
>> firmware is ignoring the normal world's PSTATE.A.
>>
>> The latest lobe of that discussion was on the list here:
>> https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1611496.html
> I have replied the mail.
> I still have some questions that need to clarify with you.
> After clarification, we will follow that.
> The question is in the reply of this mail "https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1611496.html"

Lets keep that discussion on v9 then.


>> As it is, we would need to spot SError being delivered while SError is masked,
>> spray nasty messages about firmware being horrifically buggy, then panic(). For
>> a corrected error, this looks bad, but its preferable to letting firmware
>> silently overwrite the exception registers, causing linux to spin through the
>> vectors 'eret' with all exceptions masked.
>> I still think its best to wait for firmware that does the right thing.

> Let us  discuss that in another mail.
> In a summary, I think firmware follow below rule can be OK, right?
> 1. The exception came from the EL that SError should be routed to(according to hcr_EL2.{AMO, TGE}),but PSTATE.A was set, EL3 firmware can't deliver SError;

> 2. The exception came from the EL that SError should not be routed to(according to hcr_EL2.{AMO, TGE}),even though the PSTATE.A was set,EL3 firmware still deliver SError

Problem here, more on v9.


Thanks,

James
