From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/5] arm64: alternative: Allow immediate branch as
 alternative instruction
Date: Thu, 26 Mar 2015 22:03:23 +0000
Message-ID: <20150326220323.GA23836@arm.com>
References: <1426773576-14062-1-git-send-email-marc.zyngier@arm.com>
 <1426773576-14062-3-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A603849DBD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 17:56:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oV7m9vtiBIOy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Mar 2015 17:56:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2B4749DBB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Mar 2015 17:56:28 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <1426773576-14062-3-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <Andre.Przywara@arm.com>, Dave P Martin <Dave.Martin@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Mar 19, 2015 at 01:59:33PM +0000, Marc Zyngier wrote:
> Since all immediate branches are PC-relative on Aarch64, these
> instructions cannot be used as an alternative with the simplistic
> approach we currently have (the immediate has been computed from
> the .altinstr_replacement section, and end-up being completely off
> if we insert it directly).
> 
> This patch handles the b and bl instructions in a different way,
> using the insn framework to recompute the immediate, and generate
> the right displacement.
> 
> Reviewed-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/kernel/alternative.c | 55 +++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 53 insertions(+), 2 deletions(-)

[...]

>  static int __apply_alternatives(void *alt_region)
>  {
>  	struct alt_instr *alt;
> @@ -40,16 +83,24 @@ static int __apply_alternatives(void *alt_region)
>  	u8 *origptr, *replptr;
>  
>  	for (alt = region->begin; alt < region->end; alt++) {
> +		u32 insn;
> +		int i;
> +
>  		if (!cpus_have_cap(alt->cpufeature))
>  			continue;
>  
> -		BUG_ON(alt->alt_len > alt->orig_len);
> +		BUG_ON(alt->alt_len != alt->orig_len);
>  
>  		pr_info_once("patching kernel code\n");
>  
>  		origptr = (u8 *)&alt->orig_offset + alt->orig_offset;
>  		replptr = (u8 *)&alt->alt_offset + alt->alt_offset;
> -		memcpy(origptr, replptr, alt->alt_len);
> +
> +		for (i = 0; i < alt->alt_len; i += sizeof(insn)) {
> +			insn = get_alt_insn(origptr + i, replptr + i);
> +			*(u32 *)(origptr + i) = insn;

My brain's not firing on all cylinders right now, but do you need a
cpu_to_le32 here?

Will
