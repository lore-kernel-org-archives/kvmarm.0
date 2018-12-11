From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v7 09/25] ACPI / APEI: Generalise the estatus queue's
 notify code
Date: Tue, 11 Dec 2018 18:44:49 +0100
Message-ID: <20181211174449.GM27375@zn.tnic>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-10-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC3244A1DC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 12:45:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zPYQpTwUMxDu for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 12:45:00 -0500 (EST)
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 073044A0CC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 12:45:00 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181203180613.228133-10-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 03, 2018 at 06:05:57PM +0000, James Morse wrote:
> Refactor the estatus queue's pool notification routine from
> NOTIFY_NMI's handlers. This will allow another notification
> method to use the estatus queue without duplicating this code.
> 
> This patch adds rcu_read_lock()/rcu_read_unlock() around the list

s/This patch adds/Add/

> list_for_each_entry_rcu() walker. These aren't strictly necessary as
> the whole nmi_enter/nmi_exit() window is a spooky RCU read-side
> critical section.
> 
> _in_nmi_notify_one() is separate from the rcu-list walker for a later
> caller that doesn't need to walk a list.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
> Tested-by: Tyler Baicar <tbaicar@codeaurora.org>
> 
> ---
> Changes since v6:
>  * Removed pool grow/remove code as this is no longer necessary.
> 
> Changes since v3:
>  * Removed duplicate or redundant paragraphs in commit message.
>  * Fixed the style of a zero check.
> Changes since v1:
>    * Tidied up _in_nmi_notify_one().
> ---
>  drivers/acpi/apei/ghes.c | 63 ++++++++++++++++++++++++++--------------
>  1 file changed, 41 insertions(+), 22 deletions(-)

...

> +static int ghes_notify_nmi(unsigned int cmd, struct pt_regs *regs)
> +{
> +	int ret = NMI_DONE;
> +
> +	if (!atomic_add_unless(&ghes_in_nmi, 1, 1))
> +		return ret;
> +
> +	if (!ghes_estatus_queue_notified(&ghes_nmi))
> +		ret = NMI_HANDLED;

So this reads kinda the other way around, at least to me:

	"if the queue was *not* notified, the NMI was handled."

Maybe rename to this:

	err = process_queue(&ghes_nmi);
	if (!err)
		ret = NMI_HANDLED;

to make it clearer...

And yeah, all those static functions having "ghes_" prefix is just
encumbering readability for no good reason.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
