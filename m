From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v2 1/3] arm64: mm: Support Common Not Private translations
Date: Wed, 18 Oct 2017 16:00:14 +0100
Message-ID: <59E76C7E.2060108@arm.com>
References: <1507724395-13735-1-git-send-email-vladimir.murzin@arm.com>
 <1507724395-13735-2-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4F1849D3E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 11:00:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eBWOtr+MdEwO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Oct 2017 11:00:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 70F67406BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Oct 2017 11:00:53 -0400 (EDT)
In-Reply-To: <1507724395-13735-2-git-send-email-vladimir.murzin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, kbuild-all@01.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Vladimir,

On 11/10/17 13:19, Vladimir Murzin wrote:
> Common Not Private (CNP) is a feature of ARMv8.2 extension which
> allows translation table entries to be shared between different PEs in
> the same inner shareable domain, so the hardware can use this fact to
> optimise the caching of such entries in the TLB.
> 
> CNP occupies one bit in TTBRx_ELy and VTTBR_EL2, which advertises to
> the hardware that the translation table entries pointed to by this
> TTBR are the same as every PE in the same inner shareable domain for
> which the equivalent TTBR also has CNP bit set. In case CNP bit is set
> but TTBR does not point at the same translation table entries or a
> given ASID and VMID, then the system is mis-configured, so the results
> of translations are UNPREDICTABLE.
> 
> This patch adds support for Common Not Private translations on
> different exceptions levels:
> 
> (1) For EL0 there are a few cases we need to care of changes in
>     TTBR0_EL1:
>     - a switch to idmap
>     - software emulated PAN
>     we rule out latter via Kconfig options and for the former we make
>     sure that CNP is set for non-zero ASIDs only.

I've been looking at how CNP interacts with the asid allocator. I think we
depend on a subtlety that wasn't obvious to me at first.

Can you check I'm reading this properly:
The ARM-ARM's 'D4.8.1 Use of ASIDs and VMIDs to reduce TLB maintenance
requirements' reads as if you can only share a TLB entry if both CPUs are using
that ASID at the same time:

> When the value of a TTBR_ELx.CnP field is 1,

(on CPU-A)

> translation table entries pointed to by that TTBR_ELx are shared with all
> other PEs in the Inner Shareable domain for which the following conditions
> are met:

>         The corresponding TTBR_ELx.CnP field has the value 1.

(CPU-B's corresponding TTBR right?)

This would suggest CPU-A stops sharing its TLB entries for an asid when it
changes asid by scheduling a new task. A single-threaded task would never
benefit from CNP.


We will depend on this behaviour when we re-use an asid that was previously used
on a remote CPU that hasn't yet noticed the rollover and invalidated its TLB.


> diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
> index 1e3be90..f28c44a 100644
> --- a/arch/arm64/kernel/suspend.c
> +++ b/arch/arm64/kernel/suspend.c
> @@ -46,6 +46,9 @@ void notrace __cpu_suspend_exit(void)
>  	 */
>  	cpu_uninstall_idmap();


> +	/* Restore CnP bit in TTBR1_EL1 */
> +	cpu_replace_ttbr1(lm_alias(swapper_pg_dir));

Could you wrap this in system_supports_cnp(). Otherwise it replaces ttbr1
unnecessarily.

This function is called with the idmap loaded, it seems unnecessary to remove it
twice. You could refactor cpu_replace_ttbr1() to have a __version that is called
with the idmap loaded, then call that before the cpu_uninstall_idmap() above.


Thanks,

James
