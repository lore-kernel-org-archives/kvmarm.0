From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v3 01/12] ACPI / APEI: Move the estatus queue code up,
 and under its own ifdef
Date: Tue, 01 May 2018 11:43:19 +0100
Message-ID: <877eonr708.fsf@e105922-lin.cambridge.arm.com>
References: <20180427153510.5799-1-james.morse@arm.com>
 <20180427153510.5799-2-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180427153510.5799-2-james.morse@arm.com> (James Morse's
 message of "Fri, 27 Apr 2018 16:34:59 +0100")
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: James Morse <james.morse@arm.com>
Cc: jonathan.zhang@cavium.com, Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Christoffer Dall <cdall@kernel.org>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

James Morse <james.morse@arm.com> writes:

> To support asynchronous NMI-like notifications on arm64 we need to use
> the estatus-queue. These patches refactor it to allow multiple APEI
> notification types to use it.
>
> First we move the estatus-queue code higher in the file so that any
> notify_foo() handler can make use of it.
>
> This patch moves code around ... and makes the following trivial change:
> Freshen the dated comment above ghes_estatus_llist. printk() is no
> longer the issue, its the helpers like memory_failure_queue() that
> still aren't nmi safe.
>
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
>


> Notes for cover letter:
> ghes.c has three things all called 'estatus'. One is a pool of memory
> that has a static size, and is grown/shrunk when new NMI users are
> allocated.
> The second is the cache, this holds recent notifications so we can
> suppress notifications we've already handled.
> The last is the queue, which hold data from NMI notifications (in pool
> memory) that can't be handled immediatly.


I am guessing you intended to drop the notes before sending the patch
out.

Calling this out as it'd make sense to clean-this up if the series is
ready for merging.

Thanks,
Punit

[...]
