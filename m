From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v8 7/7] arm64: kvm: handle SError Interrupt by
 categorization
Date: Fri, 12 Jan 2018 18:05:31 +0000
Message-ID: <5A58F8EB.9080909@arm.com>
References: <1510343650-23659-1-git-send-email-gengdongjiu@huawei.com>
 <1510343650-23659-8-git-send-email-gengdongjiu@huawei.com>
 <5A0B1334.7060500@arm.com>
 <CAMj-D2CwHWNpXzeNMEVKGTveAwuJvja219NF6PZ7xqYMUY17Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D381349DB8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 13:02:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T6QeaxG2CFG0 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jan 2018 13:02:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C59849DB3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jan 2018 13:02:58 -0500 (EST)
In-Reply-To: <CAMj-D2CwHWNpXzeNMEVKGTveAwuJvja219NF6PZ7xqYMUY17Kw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: gengdongjiu <gengdj.1984@gmail.com>
Cc: wuquanming <wuquanming@huawei.com>, kvm@vger.kernel.org, linux-doc@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linuxarm@huawei.com, linux@armlinux.org.uk, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Huangshaoyu <huangshaoyu@huawei.com>, kvmarm@lists.cs.columbia.edu, arm-mail-list <linux-arm-kernel@lists.infradead.org>, devel@acpica.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi gengdongjiu,

On 16/12/17 04:47, gengdongjiu wrote:
> [...]
>>
>>> +     case ESR_ELx_AET_UER:   /* The error has not been propagated */
>>> +             /*
>>> +              * Userspace only handle the guest SError Interrupt(SEI) if the
>>> +              * error has not been propagated
>>> +              */
>>> +             run->exit_reason = KVM_EXIT_EXCEPTION;
>>> +             run->ex.exception = ESR_ELx_EC_SERROR;
>>> +             run->ex.error_code = KVM_SEI_SEV_RECOVERABLE;
>>> +             return 0;
>>
>> We should not pass RAS notifications to user space. The kernel either handles
>> them, or it panics(). User space shouldn't even know if the kernel supports RAS
> 
> For the  ESR_ELx_AET_UER(Recoverable error), let us see its definition
> below, which get from [0]

[..]

> so we can see the  exception is precise and PE can recover execution
> from the preferred return address of the exception, 

> so let guest handling it is
> better, for example, if it is guest application RAS error, we can kill
> the guest application instead of panic whole OS; if it is guest kernel
> RAS error, guest will panic.

If the kernel takes an unhandled RAS error it should panic - we don't know where
the error is.

I understand you want to kill-off guest tasks as a result of RAS errors, but
this needs to go through the whole APEI->memory_failure()->sigbus machinery so
that the kernel knows the kernel can keep running.

This saves us signalling user-space when we don't need to. An example:
code-corruption. Linux can happily re-read affected user-space executables from
disk, there is absolutely nothing user-space can do about it.
Handling errors first in the kernel allows us to do recovery for all the
affected processes, not just the one that happens to be running right now.


> Host does not know which application of guest has error, so host can
> not handle it,

It has to work this out, otherwise the errors we can handle never get a chance.

This kernel is expected to look at the error description, (which for some reason
we aren't talking about here), e.g. the CPER records, and determine what
recovery action is necessary for this error.
For memory errors this may be re-reading from disk, or at the worst case,
unmapping from all user-space users (including KVM's stage2) and raining signals
on all affected processes.

For a memory error the important piece of information is the physical address.
Only the kernel can do anything with this, it determines who owns the affected
memory and what needs doing to recover from the error.

If you pass the notification to user-space, all it can do is signal the guest to
"stop doing whatever it is you're doing". The guest may have been able to
re-read pages from disk, or otherwise handle the error.
Has the error been handled? No: The error remains latent in the system.


> panic OS is not a good choice for the Recoverable error.

If we don't know where the error is, and we can't make progress, its the only
sane choice.

This code is never expected to run! (why are we arguing about it?) We should get
RAS errors as GHES notifications from firmware via some mechanism. If those are
NOTIFY_SEI then APEI should claim the notification and kick off the appropriate
handling based on the CPER records. If/when we get kernel-first, that can claim
the SError. What we're left with is RAS notifications that no-one claimed
because there was no error-description found.



James
