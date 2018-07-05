From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v5 00/20] APEI in_nmi() rework and arm64 SDEI wire-up
Date: Thu, 5 Jul 2018 16:42:51 +0100
Message-ID: <1246af75-eaf4-e306-2276-65859be053e6@arm.com>
References: <20180626170116.25825-1-james.morse@arm.com>
 <4409985.sv3PbRGN0l@aspire.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <4409985.sv3PbRGN0l@aspire.rjw.lan>
Content-Language: en-US
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>
Cc: jonathan.zhang@cavium.com, Punit Agrawal <punit.agrawal@arm.com>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi guys,

On 05/07/18 10:50, Rafael J. Wysocki wrote:
> On Tuesday, June 26, 2018 7:00:56 PM CEST James Morse wrote:
>> The aim of this series is to wire arm64's SDEI into APEI.
>>
>> On arm64 we have three APEI notifications that are NMI-like, and
>> in the unlikely event that all three are supported by a platform,
>> they can interrupt each other.
>> The GHES driver shouldn't have to deal with this, so this series aims
>> to make it re-entrant.
>>
>> To do that, we refactor the estatus queue to allow multiple notifications
>> to use it, then convert NOTIFY_SEA to always be described as NMI-like,
>> and to use the estatus queue.
>>
>> From here we push the locking and fixmap choices out to the notification
>> functions, and remove the use of per-ghes estatus and flags. This removes
>> the in_nmi() 'timebomb' in ghes_copy_tofrom_phys().
>>
>> Things get sticky when an NMI notification needs to know how big the
>> CPER records might be, before reading it. This series splits
>> ghes_estatus_read() to let us peek at the buffer. A side effect of this
>> is the 20byte header will get read twice. (how does it work today? it
>> reads the records into a per-ghes worst-case sized buffer, allocates
>> the correct size and copies the records. in_nmi() use of this per-ghes
>> buffer needs eliminating).
>>
>> One alternative was to trust firmware's 'max raw data length' and use
>> that to allocate 'enough' memory. We don't use this value today, so its
>> probably wrong on some sytem somewhere.
>>
>> Since v4 patches 5,8-15 are new, otherwise changes are noted in the patch.

> Tony, I need your help with reviewing the APEI-related material here.
> Can you please have a look at this series and let me know if there are
> any concerns regarding it?

Thanks.

I think the only context from earlier versions is where Borislav spotted some
issues with the ghes_proc() call at probe time and NMI-like notifications.

>From https://www.spinics.net/lists/arm-kernel/msg653332.html :
| Which means, that this code is not really reentrant and if should be
| fixed to be callable from different contexts, then it should use private
| buffers and be careful about locking.

... the patches for which have bloated this series.


Thanks,

James
