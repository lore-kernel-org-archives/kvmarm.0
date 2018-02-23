From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 01/11] ACPI / APEI: Move the estatus queue code up, and
 under its own ifdef
Date: Fri, 23 Feb 2018 18:02:21 +0000
Message-ID: <5A90572D.9010704@arm.com>
References: <20180215185606.26736-1-james.morse@arm.com>
 <20180215185606.26736-2-james.morse@arm.com> <20180220192852.GB24320@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180220192852.GB24320@pd.tnic>
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Borislav,

On 20/02/18 19:28, Borislav Petkov wrote:
> On Thu, Feb 15, 2018 at 06:55:56PM +0000, James Morse wrote:
>> +#ifdef CONFIG_HAVE_ACPI_APEI_NMI
>> +/*
>> + * While printk() now has an in_nmi() path, the handling for CPER records
>> + * does not. For example, memory_failure_queue() takes spinlocks and calls
>> + * schedule_work_on().
>> + *
>> + * So in any NMI-like handler, we allocate required memory from lock-less
>> + * memory allocator (ghes_estatus_pool), save estatus into it, put them into
>> + * lock-less list (ghes_estatus_llist), then delay printk into IRQ context via
>> + * irq_work (ghes_proc_irq_work).  ghes_estatus_size_request record
>> + * required pool size by all NMI error source.
> 
> Since you're touching this, pls correct the grammar too, while at it,
> and correct them into proper sentences.
> Also, end function names with "()".
> Also the "we" pronoun and tense sounds funny - let's make it passive.

Sure. I reckon your English grammar is better than mine, is this better?:

| In any NMI-like handler, memory from ghes_estatus_pool is used to save
| estatus, and added to the ghes_estatus_llist. irq_work_queue() causes
| ghes_proc_in_irq() to run in IRQ context where each estatus in
| ghes_estatus_llist are processed. Each NMI-like error source must grow
| the ghes_estatus_pool to ensure memory is available.



Thanks,

James
