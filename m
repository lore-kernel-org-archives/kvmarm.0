From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 02/11] ACPI / APEI: Generalise the estatus queue's
 add/remove and notify code
Date: Tue, 17 Apr 2018 17:10:18 +0200
Message-ID: <20180417151018.GE20840@pd.tnic>
References: <20180215185606.26736-1-james.morse@arm.com>
 <20180215185606.26736-3-james.morse@arm.com>
 <20180301150144.GA4215@pd.tnic>
 <87sh9jbrgc.fsf@e105922-lin.cambridge.arm.com>
 <20180301223529.GA28811@pd.tnic> <5AA02C26.10803@arm.com>
 <20180308104408.GB21166@pd.tnic> <5AAFC939.3010309@arm.com>
 <20180327172510.GB32184@pd.tnic>
 <d15ba145-479c-ffde-14ad-ab7170d0f06e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <d15ba145-479c-ffde-14ad-ab7170d0f06e@arm.com>
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Mar 28, 2018 at 05:30:55PM +0100, James Morse wrote:
> -----------------%<-----------------
>     ACPI / APEI: don't wait to serialise with oops messages when panic()ing
> 
>     oops_begin() exists to group printk() messages with the oops message
>     printed by die(). To reach this caller we know that platform firmware
>     took this error first, then notified the OS via NMI with a 'panic'
>     severity.
> 
>     Don't wait for another CPU to release the die-lock before we can
>     panic(), our only goal is to print this fatal error and panic().
> 
>     This code is always called in_nmi(), and since 42a0bb3f7138 ("printk/nmi:
>     generic solution for safe printk in NMI"), it has been safe to call
>     printk() from this context. Messages are batched in a per-cpu buffer
>     and printed via irq-work, or a call back from panic().
> 
>     Signed-off-by: James Morse <james.morse@arm.com>
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 22f6ea5b9ad5..f348e6540960 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -34,7 +34,6 @@
>  #include <linux/interrupt.h>
>  #include <linux/timer.h>
>  #include <linux/cper.h>
> -#include <linux/kdebug.h>
>  #include <linux/platform_device.h>
>  #include <linux/mutex.h>
>  #include <linux/ratelimit.h>
> @@ -736,9 +735,6 @@ static int _in_nmi_notify_one(struct ghes *ghes)
> 
>         sev = ghes_severity(ghes->estatus->error_severity);
>         if (sev >= GHES_SEV_PANIC) {
> -#ifdef CONFIG_X86
> -               oops_begin();
> -#endif
>                 ghes_print_queued_estatus();
>                 __ghes_panic(ghes);
>         }
> -----------------%<-----------------

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
