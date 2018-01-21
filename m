From: gengdongjiu <gengdj.1984@gmail.com>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by categorization
Date: Sun, 21 Jan 2018 10:54:45 +0800
Message-ID: <CAMj-D2AkqEbWRhaDFdgGsED0+yO6wd6YKbVPxXKmQhg=mgO-JQ@mail.gmail.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
 <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com>
 <5A0B1334.7060500@arm.com> <CAMj-D2CwHWNpXzeNMEVKGTveAwuJvja219NF6PZ7xqYMUY17Kw@mail.gmail.com>
 <5A58F8EB.9080909@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <5A58F8EB.9080909@arm.com>
Sender: kvm-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: Dongjiu Geng <gengdongjiu@huawei.com>, wuquanming <wuquanming@huawei.com>, linux-doc@vger.kernel.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux@armlinux.org.uk, linuxarm@huawei.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org, arm-mail-list <linux-arm-kernel@lists.infradead.org>, Huangshaoyu <huangshaoyu@huawei.com>, kvmarm@lists.cs.columbia.edu, devel@acpica.org
List-Id: kvmarm@lists.cs.columbia.edu

2018-01-13 2:05 GMT+08:00 James Morse <james.morse@arm.com>:
> Hi gengdongjiu,
>
> On 16/12/17 04:47, gengdongjiu wrote:
>> [...]
>>>
>>>> +     case ESR_ELx_AET_UER:   /* The error has not been propagated */
>>>> +             /*
>>>> +              * Userspace only handle the guest SError Interrupt(SEI) if the
>>>> +              * error has not been propagated
>>>> +              */
>>>> +             run->exit_reason = KVM_EXIT_EXCEPTION;
>>>> +             run->ex.exception = ESR_ELx_EC_SERROR;
>>>> +             run->ex.error_code = KVM_SEI_SEV_RECOVERABLE;
>>>> +             return 0;
>>>
>>> We should not pass RAS notifications to user space. The kernel either handles
>>> them, or it panics(). User space shouldn't even know if the kernel supports RAS
>>
>> For the  ESR_ELx_AET_UER(Recoverable error), let us see its definition
>> below, which get from [0]
>
> [..]
>
>> so we can see the  exception is precise and PE can recover execution
>> from the preferred return address of the exception,
>
>> so let guest handling it is
>> better, for example, if it is guest application RAS error, we can kill
>> the guest application instead of panic whole OS; if it is guest kernel
>> RAS error, guest will panic.
>
> If the kernel takes an unhandled RAS error it should panic - we don't know where
> the error is.
OK, here I will panic.

>
> I understand you want to kill-off guest tasks as a result of RAS errors, but
> this needs to go through the whole APEI->memory_failure()->sigbus machinery so
> that the kernel knows the kernel can keep running.
>
> This saves us signalling user-space when we don't need to. An example:
> code-corruption. Linux can happily re-read affected user-space executables from
> disk, there is absolutely nothing user-space can do about it.
> Handling errors first in the kernel allows us to do recovery for all the
> affected processes, not just the one that happens to be running right now.
>
>
>> Host does not know which application of guest has error, so host can
>> not handle it,
>
> It has to work this out, otherwise the errors we can handle never get a chance.
>
> This kernel is expected to look at the error description, (which for some reason
> we aren't talking about here), e.g. the CPER records, and determine what
> recovery action is necessary for this error.
> For memory errors this may be re-reading from disk, or at the worst case,
> unmapping from all user-space users (including KVM's stage2) and raining signals
> on all affected processes.
>
> For a memory error the important piece of information is the physical address.
> Only the kernel can do anything with this, it determines who owns the affected
> memory and what needs doing to recover from the error.
>
> If you pass the notification to user-space, all it can do is signal the guest to
> "stop doing whatever it is you're doing". The guest may have been able to
> re-read pages from disk, or otherwise handle the error.
> Has the error been handled? No: The error remains latent in the system.
>
>
>> panic OS is not a good choice for the Recoverable error.
>
> If we don't know where the error is, and we can't make progress, its the only
> sane choice.
Ok, I will panic here.

>
> This code is never expected to run! (why are we arguing about it?) We should get
> RAS errors as GHES notifications from firmware via some mechanism. If those are
> NOTIFY_SEI then APEI should claim the notification and kick off the appropriate
> handling based on the CPER records. If/when we get kernel-first, that can claim
> the SError. What we're left with is RAS notifications that no-one claimed
> because there was no error-description found.
>
>
>
> James
