From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v3 07/12] ACPI / APEI: Make the nmi_fixmap_idx per-ghes to
 allow multiple in_nmi() users
Date: Thu, 17 May 2018 19:11:21 +0100
Message-ID: <8a6fa0e4-98c5-6880-1611-f1ab0534bbbc@arm.com>
References: <20180427153510.5799-1-james.morse@arm.com>
 <20180427153510.5799-8-james.morse@arm.com> <20180505122719.GE3708@pd.tnic>
 <1511cfcc-dcd1-b3c5-01c7-6b6b8fb65b05@arm.com>
 <20180516110348.GA17092@pd.tnic>
 <7c871e15-689c-226d-760d-dd92614de2e9@arm.com>
 <20180517133653.GA27738@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180517133653.GA27738@pd.tnic>
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
To: Borislav Petkov <bp@alien8.de>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Christoffer Dall <cdall@kernel.org>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Borislav,

On 17/05/18 14:36, Borislav Petkov wrote:
> On Wed, May 16, 2018 at 03:51:14PM +0100, James Morse wrote:
>> I thought this was safe because its just ghes_copy_tofrom_phys()s access to the
>> fixmap slots that needs mutual exclusion.

and here is where I was wrong: I was only looking at reading the data, we then
dump it in struct ghes assuming it can only be notified on once CPU at a time. Oops.

> For example:

> ghes->estatus from above, before the NMI fired, has gotten some nice
> scribbling over. AFAICT.

Yup, thanks for the example!


> Now, I don't know whether this can happen with the ARM facilities but if
> they're NMI-like, I don't see why not.

NOTIFY_SEA is synchronous so the error has to be something to do with the
instruction that was interrupted. In your example this would mean the APEI
code/data was corrupted, which there is little point trying to handle.

NOTIFY_{SEI, SDEI} on the other hand are asynchronous, so this could happen.


> Which means, that this code is not really reentrant and if should be
> fixed to be callable from different contexts, then it should use private
> buffers and be careful about locking.

... I need to go through this thing again to work out how the firmware-buffers
map on to estatus=>ghes ...


> Oh, and that
> 
> 	if (in_nmi)
> 		lock()
> 	else
> 		lock_irqsave()
> 
> pattern is really yucky. And it is an explosion waiting to happen.

The whole in_nmi()=>other-lock think looks like a hack to make a warning go
away. We could get the notification to take whatever lock is appropriate further
out, but it may mean some code duplication. (I'll put it on my list...)


Thanks,

James
