From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 00/18] APEI in_nmi() rework
Date: Wed, 3 Oct 2018 18:50:38 +0100
Message-ID: <c04d1b78-122b-d7f2-5a75-3d9c56386b11@arm.com>
References: <20180921221705.6478-1-james.morse@arm.com>
 <20180925124526.GD23986@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6714B49E3E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Oct 2018 13:50:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xu57WYU9ugnw for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Oct 2018 13:50:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46F2A4A2AF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Oct 2018 13:50:47 -0400 (EDT)
In-Reply-To: <20180925124526.GD23986@zn.tnic>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Borislav Petkov <bp@alien8.de>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Boris,

On 25/09/18 13:45, Borislav Petkov wrote:
> On Fri, Sep 21, 2018 at 11:16:47PM +0100, James Morse wrote:
>> Hello,
>>
>> The GHES driver has collected quite a few bugs:
>>
>> ghes_proc() at ghes_probe() time can be interrupted by an NMI that
>> will clobber the ghes->estatus fields, flags, and the buffer_paddr.
>>
>> ghes_copy_tofrom_phys() uses in_nmi() to decide which path to take. arm64's
>> SEA taking both paths, depending on what it interrupted.
>>
>> There is no guarantee that queued memory_failure() errors will be processed
>> before this CPU returns to user-space.
>>
>> x86 can't TLBI from interrupt-masked code which this driver does all the
>> time.
>>
>>
>> This series aims to fix the first three, with an eye to fixing the
>> last one with a follow-up series.
>>
>> Previous postings included the SDEI notification calls, which I haven't
>> finished re-testing. This series is big enough as it is.

> Yeah, and everywhere I look, this thing looks overengineered. Like,
> for example, what's the purpose of this ghes_esource_prealloc_size()
> computing a size each time the pool changes size?

The size to grow the pool by, because each error-source described by a GHES
entry has its own worst-case size.

Today ghes_nmi_add() does this each time its called. You could have multiple
GHES entries in the HEST that describe NMI as the notification. The worst-case
size for the records is described in the GHES entry, and could be different for
each one. (error_block_length and records_to_preallocate, or table 18-379 of
acpi v6.2)

These different error-sources could be delivered on different CPUs at the same
time, so need their own pre-allocated reserved memory. ghes_notify_nmi()'s
atomic_add_unless() suggests this can happen on x86, but I don't know the
arch-specifics. It definitely can happen on arm64.


> AFAICT, this size can be computed exactly *once* at driver init and be
> done with it. Right?

We could do two passes of the HEST to pre-compute the total size of this
estatus-queue memory, allocate it, then do the notification registration stuff.
But this doesn't really work with the way this driver acts as platform-driver
for a ghes device...

The non-ghes HEST entries have a "number of records to pre-allocate" too, we
could make this memory pool something hest.c looks after, but I can't see if the
other error sources use those values.

Hmmm,
The size is capped to 64K, we could ignore the firmware description of the
memory requirements, and allocate SZ_64K each time. Doing it per-GHES is still
the only way to avoid allocating nmi-safe memory for irqs.


Thanks,

James
