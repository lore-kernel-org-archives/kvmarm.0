From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 06/19] arm64: insn: Add N immediate encoding
Date: Mon, 15 Jan 2018 12:26:13 +0100
Message-ID: <20180115112613.GG21403@cbox>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-7-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6377A49E00
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 06:21:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HRjQjDlr21KG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jan 2018 06:21:17 -0500 (EST)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 686C349DF9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 06:21:17 -0500 (EST)
Received: by mail-wm0-f68.google.com with SMTP id b141so1208073wme.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 03:26:16 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20180104184334.16571-7-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 04, 2018 at 06:43:21PM +0000, Marc Zyngier wrote:
> We're missing the a way to generate the encoding of the N immediate,
> which is only a single bit used in a number of instruction that take
> an immediate.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
>  arch/arm64/include/asm/insn.h | 1 +
>  arch/arm64/kernel/insn.c      | 4 ++++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/insn.h b/arch/arm64/include/asm/insn.h
> index 4214c38d016b..21fffdd290a3 100644
> --- a/arch/arm64/include/asm/insn.h
> +++ b/arch/arm64/include/asm/insn.h
> @@ -70,6 +70,7 @@ enum aarch64_insn_imm_type {
>  	AARCH64_INSN_IMM_6,
>  	AARCH64_INSN_IMM_S,
>  	AARCH64_INSN_IMM_R,
> +	AARCH64_INSN_IMM_N,
>  	AARCH64_INSN_IMM_MAX
>  };
>  
> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> index 2718a77da165..7e432662d454 100644
> --- a/arch/arm64/kernel/insn.c
> +++ b/arch/arm64/kernel/insn.c
> @@ -343,6 +343,10 @@ static int __kprobes aarch64_get_imm_shift_mask(enum aarch64_insn_imm_type type,
>  		mask = BIT(6) - 1;
>  		shift = 16;
>  		break;
> +	case AARCH64_INSN_IMM_N:
> +		mask = 1;
> +		shift = 22;
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> -- 
> 2.14.2
> 
