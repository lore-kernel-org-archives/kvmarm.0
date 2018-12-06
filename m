From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 14/25] arm64: KVM/mm: Move SEA handling behind a
 single 'claim' interface
Date: Thu, 6 Dec 2018 16:17:30 +0000
Message-ID: <20181206161730.GM54495@arrakis.emea.arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-15-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F80D4A2BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 11:17:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VfyTdr+fV3ih for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Dec 2018 11:17:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F38054A2FB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 11:17:35 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181203180613.228133-15-james.morse@arm.com>
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
Cc: Tony Luck <tony.luck@intel.com>, Fan Wu <wufan@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>, Will Deacon <will.deacon@arm.com>, Rafael Wysocki <rjw@rjwysocki.net>, Dongjiu Geng <gengdongjiu@huawei.com>, linux-mm@kvack.org, linux-acpi@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Len Brown <lenb@kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 03, 2018 at 06:06:02PM +0000, James Morse wrote:
> To split up APEIs in_nmi() path, the caller needs to always be
> in_nmi(). Add a helper to do the work and claim the notification.
> 
> When KVM or the arch code takes an exception that might be a RAS
> notification, it asks the APEI firmware-first code whether it wants
> to claim the exception. A future kernel-first mechanism may be queried
> afterwards, and claim the notification, otherwise we fall through
> to the existing default behaviour.
> 
> The NOTIFY_SEA code was merged before considering multiple, possibly
> interacting, NMI-like notifications and the need to consider kernel
> first in the future. Make the 'claiming' behaviour explicit.
> 
> Restructuring the APEI code to allow multiple NMI-like notifications
> means any notification that might interrupt interrupts-masked
> code must always be wrapped in nmi_enter()/nmi_exit(). This will
> allow APEI to use in_nmi() to use the right fixmap entries.
> 
> Mask SError over this window to prevent an asynchronous RAS error
> arriving and tripping 'nmi_enter()'s BUG_ON(in_nmi()).
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Tested-by: Tyler Baicar <tbaicar@codeaurora.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
