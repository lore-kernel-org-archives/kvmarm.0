From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 13/25] KVM: arm/arm64: Add kvm_ras.h to collect kvm
 specific RAS plumbing
Date: Thu, 6 Dec 2018 16:17:08 +0000
Message-ID: <20181206161707.GL54495@arrakis.emea.arm.com>
References: <20181203180613.228133-1-james.morse@arm.com>
 <20181203180613.228133-14-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0F414A2F8
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 11:17:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gZ9twzmUebgj for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Dec 2018 11:17:14 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FBA34A2BE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Dec 2018 11:17:14 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20181203180613.228133-14-james.morse@arm.com>
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

On Mon, Dec 03, 2018 at 06:06:01PM +0000, James Morse wrote:
> To split up APEIs in_nmi() path, the caller needs to always be
> in_nmi(). KVM shouldn't have to know about this, pull the RAS plumbing
> out into a header file.
> 
> Currently guest synchronous external aborts are claimed as RAS
> notifications by handle_guest_sea(), which is hidden in the arch codes
> mm/fault.c. 32bit gets a dummy declaration in system_misc.h.
> 
> There is going to be more of this in the future if/when the kernel
> supports the SError-based firmware-first notification mechanism and/or
> kernel-first notifications for both synchronous external abort and
> SError. Each of these will come with some Kconfig symbols and a
> handful of header files.
> 
> Create a header file for all this.
> 
> This patch gives handle_guest_sea() a 'kvm_' prefix, and moves the
> declarations to kvm_ras.h as preparation for a future patch that moves
> the ACPI-specific RAS code out of mm/fault.c.
> 
> Signed-off-by: James Morse <james.morse@arm.com>
> Reviewed-by: Punit Agrawal <punit.agrawal@arm.com>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> Tested-by: Tyler Baicar <tbaicar@codeaurora.org>

For the arm64 bits here:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
