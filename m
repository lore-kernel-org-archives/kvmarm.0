From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v7 09/25] ACPI / APEI: Generalise the estatus queue's
 notify code
Date: Thu, 10 Jan 2019 18:21:21 +0000
Message-ID: <3f0f9005-f383-8a03-c7f9-15b50c099f94@arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-10-james.morse@arm.com>
 <20181211174449.GM27375@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 251304A46A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 13:21:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LlY+Fa5TnWSY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Jan 2019 13:21:26 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9CD04A433
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Jan 2019 13:21:25 -0500 (EST)
In-Reply-To: <20181211174449.GM27375@zn.tnic>
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
To: Borislav Petkov <bp@alien8.de>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Boris,

On 11/12/2018 17:44, Borislav Petkov wrote:
> On Mon, Dec 03, 2018 at 06:05:57PM +0000, James Morse wrote:
>> Refactor the estatus queue's pool notification routine from
>> NOTIFY_NMI's handlers. This will allow another notification
>> method to use the estatus queue without duplicating this code.
>>
>> This patch adds rcu_read_lock()/rcu_read_unlock() around the list
> 
> s/This patch adds/Add/
> 
>> list_for_each_entry_rcu() walker. These aren't strictly necessary as
>> the whole nmi_enter/nmi_exit() window is a spooky RCU read-side
>> critical section.
>>
>> _in_nmi_notify_one() is separate from the rcu-list walker for a later
>> caller that doesn't need to walk a list.

>> +static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
>> +{
>> +	int ret = NMI_DONE;
>> +
>> +	if (!atomic_add_unless(&ghes_in_nmi, 1, 1))
>> +		return ret;
>> +
>> +	if (!ghes_estatus_queue_notified(&ghes_nmi))
>> +		ret = NMI_HANDLED;
> 
> So this reads kinda the other way around, at least to me:
> 
> 	"if the queue was *not* notified, the NMI was handled."
> 
> Maybe rename to this:
> 
> 	err = process_queue(&ghes_nmi);
> 	if (!err)
> 		ret = NMI_HANDLED;
> 
> to make it clearer...

(yup, that's clearer).

But now we've opened pandora's box of naming-things: This thing isn't really
processing anything, its walking a list of 'maybe it was one of these' and
copying anything it finds into the estatus-queue to be handled later.

I've evidently overloaded 'notified' to mean this.
__process_error() doesn't process anything either, it does the add-to-queue.

'spool' is the word that best conveys what's going on here, I should probably
use that 'in_nmi' prefix more to make it clear this has to be nmi safe.

Something like:
ghes_notify_nmi() -> in_nmi_spool_from_list(list) -> in_nmi_queue_one_entry(ghes).



Thanks,

James
