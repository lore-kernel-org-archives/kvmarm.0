From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 10/16] arm64: kernel: Survive corrected RAS errors
 notified by SError
Date: Thu, 14 Sep 2017 13:58:54 +0100
Message-ID: <59BA7D0E.6020500@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
 <20170728141019.9084-11-james.morse@arm.com>
 <eba92679-bbb7-6cb7-843c-7cfdbc793b6b@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7505749C19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 08:57:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RyxwXFzAn30m for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Sep 2017 08:57:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5615940FAE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Sep 2017 08:57:43 -0400 (EDT)
In-Reply-To: <eba92679-bbb7-6cb7-843c-7cfdbc793b6b@codeaurora.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Baicar, Tyler" <tbaicar@codeaurora.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, Wang Xiongfeng <wangxiongfeng2@huawei.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Tyler,

On 13/09/17 21:52, Baicar, Tyler wrote:
> On 7/28/2017 8:10 AM, James Morse wrote:
>> On v8.0, SError is an uncontainable fatal exception. The v8.2 RAS
>> extensions use SError to notify software about RAS errors, these can be
>> contained by the ESB instruction.
>>
>> An ACPI system with firmware-first may use SError as its 'SEI'
>> notification. Future patches may add code to 'claim' this SError as
>> notification.
>>
>> Other systems can distinguish these RAS errors from the SError ESR and
>> use the AET bits and additional data from RAS-Error registers to handle
>> the error.  Future patches may add this kernel-first handling.
>>
>> In the meantime, on both kinds of system we can safely ignore corrected
>> errors.

> Here you just have corrected and restartable errors being ignored and all other
> errors panic. For corrected and restartable errors, we should at least be
> logging that an error happened and provide the syndrome info (address, context,
> etc.). 

Yes, that would be great, but its all wrapped up in 'kernel first handling' for
RAS... which we don't yet have.

This series is 'fixing' the kernel's SError mask behaviour so that the SEI
firmware-first mechanism can (almost) always deliver its notifications, and has
somewhere to hook the APEI code into, (like you did for do_sea()).

Of course not all systems will have this firmware, so if we took a v8.2 RAS
SError on bare-metal we need to do something. This selective-ignoring is an
interim fudge to avoid bringing the machine down for something that isn't (yet?)
a problem.


>From the commit message:
> Future patches may add this kernel-first handling.
> In the meantime, on both kinds of system we can safely ignore corrected
> errors.


> We also should be triggering a trace event to notify the user space that
> an error happened so that tools like RAS Daemon can report the error. This will
> involve a new trace event since the current ones are based of the CPER
> structures from the firmware-first case.

Hmm, so RAS Daemon is going to end up knowing whether an error was handled
kernel-first or firmware-first, that is unfortunate for RAS-Daemon (more code)
and means we have duplicate trace points.


> Recoverable UEs should not need to trigger the panic, we should be able to do
> the recovery similar to the memory fault handling in mm/memory-failure.c code.
> The recoverable UEs should also trigger a trace event to user space since they
> won't cause a panic as well.

I agree, but only once we have code to dig in v8.2's RAS ERR registers to pick
out the class of error and affected component or address. Until then we can't
know the component or address, so can't handle the error.

This is still an improvement over a non-v8.2-RAS aware kernel, as that would
panic() for corrected errors too, (depending on when they arrived ... the SError
masking is somewhat broken).


Thanks,

James
