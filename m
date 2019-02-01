From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 3/4] arm64: hyp-stub: Forbid kprobing of the hyp-stub
Date: Fri, 1 Feb 2019 12:02:08 +0000
Message-ID: <195916cb-03ac-6d83-03a8-e09fec90b247@arm.com>
References: <20190124163257.233929-1-james.morse@arm.com>
 <20190124163257.233929-4-james.morse@arm.com>
 <20190131080421.GJ13482@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EE274A32D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 07:02:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AETX6JZ1YgTI for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Feb 2019 07:02:12 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F3774A319
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Feb 2019 07:02:12 -0500 (EST)
In-Reply-To: <20190131080421.GJ13482@e113682-lin.lund.arm.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 31/01/2019 08:04, Christoffer Dall wrote:
> On Thu, Jan 24, 2019 at 04:32:56PM +0000, James Morse wrote:
>> The hyp-stub is loaded by the kernel's early startup code at EL2
>> during boot, before KVM takes ownership later. The hyp-stub's
>> text is part of the regular kernel text, meaning it can be kprobed.
>>
>> A breakpoint in the hyp-stub causes the CPU to spin in el2_sync_invalid.
>>
>> Add it to the __hyp_text.

>> This has been a problem since kprobes was merged, it should
>> probably have been covered in 888b3c8720e0.
>>
>> I'm not sure __hyp_text is the right place. Its not idmaped,
>> and as it contains a set of vectors, adding it to the host/hyp
>> idmap sections could grow them beyond a page... but it does
>> run with the MMU off, so does need to be cleaned to PoC when
>> anything wacky, like hibernate happens. With this patch,
>> hibernate should clean the __hyp_text to PoC too.
> 
> How did this code get cleaned before?

It didn't need to be cleaned as KVM executes it with the MMU on.
KVM's MMU-off code lives in the hyp_idmap, which is cleaned. (as is the kernel's
idmap).

The hibernate-cache-cleaning was trying to do the absolute minimum, but the
hyp-stub got forgotten.


> Is there a problem you can identify with putting it in __hyp_text?

> Seems to me we should just stick it there if it has no negative
> side-effects and otherwise we have to make up a separate section with a
> specialized meaning.

Yup, there is no problem with the extra cache-maintenance.
The hyp-stub is the odd one out, its runtime code that runs with the MMU off,
but isn't idmaped. I wasn't sure if we wanted to create some special
section.(having to name it is a good enough reason not to!)


Thanks,

James
