From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH 05/11] arm64: KVM/mm: Move SEA handling behind a single
 'claim' interface
Date: Tue, 20 Feb 2018 18:30:05 +0000
Message-ID: <87lgfnzf82.fsf@e105922-lin.cambridge.arm.com>
References: <20180215185606.26736-1-james.morse@arm.com>
 <20180215185606.26736-6-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
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
Cc: Rafael Wysocki <rjw@rjwysocki.net>, Tony Luck <tony.luck@intel.com>, Xie XiuQi <xiexiuqi@huawei.com>, linux-mm@kvack.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Tyler Baicar <tbaicar@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, linux-arm-kernel@lists.infradead.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

One typo in the commit log otherwise looks good.

James Morse <james.morse@arm.com> writes:

> To split up APEIs in_nmi() path, we need the nmi-like callers to always
> be in_nmi(). Add a helper to do the work and claim the notification.
>
> When KVM or the arch code takes an exception that might be a RAS
> notification, it asks the APEI firmware-first code whether it wants
> to claim the exception. We can then go on to see if (a future)
> kernel-first mechanism wants to claim the notification, before
> falling through to the existing default behaviour.
>
> The NOTIFY_SEA code was merged before we had multiple, possibly
> interacting, NMI-like notifications and the need to consider kernel
> first in the future. Make the 'claiming' behaviour explicit.
>
> As we're restructuring the APEI code to allow multiple NMI-like
> notifications, any notification that might interrupt interrupts-masked
> code must always be wrapped in nmi_enter()/nmi_exit(). This allows APEI
> to use in_nmi() so choose between the raw/regular spinlock routines.
                  ^
                  to

Thanks,
Punit

>
> We mask SError over this window to prevent an asynchronous RAS error
> arriving and tripping 'nmi_enter()'s BUG_ON(in_nmi()).
>
> Signed-off-by: James Morse <james.morse@arm.com>
> CC: Tyler Baicar <tbaicar@codeaurora.org>
> ---
> Why does apei_claim_sea() take a pt_regs? This gets used later to take
> APEI by the hand through NMI->IRQ context, depending on what we
> interrupted.
>
>  arch/arm64/include/asm/acpi.h      |  3 +++
>  arch/arm64/include/asm/daifflags.h |  1 +
>  arch/arm64/include/asm/kvm_ras.h   | 20 +++++++++++++++++++-
>  arch/arm64/kernel/acpi.c           | 30 ++++++++++++++++++++++++++++++
>  arch/arm64/mm/fault.c              | 31 +++++++------------------------
>  5 files changed, 60 insertions(+), 25 deletions(-)
>

[...]
