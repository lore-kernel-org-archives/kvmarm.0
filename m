From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3] KVM: arm/arm64: Signal SIGBUS when stage2 discovers
 hwpoison memory
Date: Thu, 22 Jun 2017 17:48:04 +0100
Message-ID: <c2978b32-5636-fdbf-23c5-7a0c38b918a6@arm.com>
References: <20170620161148.31653-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CC3140A66
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jun 2017 12:43:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WkRS6sP0OHfN for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Jun 2017 12:43:31 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CC58340296
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Jun 2017 12:43:31 -0400 (EDT)
In-Reply-To: <20170620161148.31653-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: Punit Agrawal <punit.agrawal@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi James,

On 20/06/17 17:11, James Morse wrote:
> Once we enable ARCH_SUPPORTS_MEMORY_FAILURE on arm64, notifications for
> broken memory can call memory_failure() in mm/memory-failure.c to offline
> pages of memory, possibly signalling user space processes and notifying all
> the in-kernel users.
> 
> memory_failure() has two modes, early and late. Early is used by
> machine-managers like Qemu to receive a notification when a memory error is
> notified to the host. These can then be relayed to the guest before the
> affected page is accessed. To enable this, the process must set
> PR_MCE_KILL_EARLY in PR_MCE_KILL_SET using the prctl() syscall.
> 
> Once the early notification has been handled, nothing stops the
> machine-manager or guest from accessing the affected page. If the
> machine-manager does this the page will fail to be mapped and SIGBUS will
> be sent. This patch adds the equivalent path for when the guest accesses
> the page, sending SIGBUS to the machine-manager.
> 
> These two signals can be distinguished by the machine-manager using their
> si_code: BUS_MCEERR_AO for 'action optional' early notifications, and
> BUS_MCEERR_AR for 'action required' synchronous/late notifications.
> 
> Do as x86 does, and deliver the SIGBUS when we discover pfn ==
> KVM_PFN_ERR_HWPOISON. Use the hugepage size as si_addr_lsb if this vma was
> allocated as a hugepage. Transparent hugepages will be split by
> memory_failure() before we see them here.
> 
> Cc: Punit Agrawal <punit.agrawal@arm.com>
> Signed-off-by: James Morse <james.morse@arm.com>
> 
> ---
> arm64 has ARCH_SUPPORTS_MEMORY_FAILURE in linux-next, so can enable
> MEMORY_FAILURE. This patch will build without those changes as
> KVM_PFN_ERR_HWPOISON is always defined.
> 
> Changes since v2:
>  * Just the commit message.
> 
> Changes since v1:
>  * Pass the vma to kvm_send_hwpoison_signal(), used Punit's huge_page_shift()
>    calculation to find the block size.
>  * ... tested against hugepage not transparent huge page ...

Applied to -next.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
