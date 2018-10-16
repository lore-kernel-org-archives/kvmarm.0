From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 17/18] mm/memory-failure: increase queued recovery
 work's priority
Date: Tue, 16 Oct 2018 09:43:51 +0200
Message-ID: <20181016074351.GC4030@hirez.programming.kicks-ass.net>
References: <20180921221705.6478-1-james.morse@arm.com>
 <20180921221705.6478-18-james.morse@arm.com>
 <20181015164913.GE11434@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20181015164913.GE11434@zn.tnic>
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
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Punit Agrawal <punit.agrawal@arm.com>, James Morse <james.morse@arm.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 15, 2018 at 06:49:13PM +0200, Borislav Petkov wrote:
> On Fri, Sep 21, 2018 at 11:17:04PM +0100, James Morse wrote:
> > @@ -1463,11 +1465,14 @@ void memory_failure_queue(unsigned long pfn, int flags)
> >  
> >  	mf_cpu = &get_cpu_var(memory_failure_cpu);
> >  	spin_lock_irqsave(&mf_cpu->lock, proc_flags);
> > -	if (kfifo_put(&mf_cpu->fifo, entry))
> > -		schedule_work_on(smp_processor_id(), &mf_cpu->work);
> > -	else
> > +	if (kfifo_put(&mf_cpu->fifo, entry)) {
> > +		queue_work_on(cpu, system_highpri_wq, &mf_cpu->work);
> > +		set_tsk_need_resched(current);
> > +		preempt_set_need_resched();
> 
> What guarantees the workqueue would run before the process? I see this:
> 
> ``WQ_HIGHPRI``
>   Work items of a highpri wq are queued to the highpri
>   worker-pool of the target cpu.  Highpri worker-pools are
>   served by worker threads with elevated nice level.
> 
> but is that enough?

Nope. Nice just makes it more likely, but no guarantees what so ever.

If you want to absolutely run something before we return to userspace,
would not task_work() be what we're looking for?
