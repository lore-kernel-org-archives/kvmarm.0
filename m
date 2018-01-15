From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 03/19] arm64: asm-offsets: Remove potential circular
 dependency
Date: Mon, 15 Jan 2018 09:34:49 +0100
Message-ID: <20180115083449.GD21403@cbox>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
 <20180104184334.16571-4-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C1F249DEF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 03:29:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NG2yd6coe0Tr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jan 2018 03:29:54 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA41E49DBE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 03:29:53 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id i11so83594wmf.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jan 2018 00:34:52 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20180104184334.16571-4-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jan 04, 2018 at 06:43:18PM +0000, Marc Zyngier wrote:
> So far, we've been lucky enough that none of the include files
> that asm-offsets.c requires include asm-offsets.h. This is
> about to change, and would introduce a nasty circular dependency...
> 
> Let's now guard the inclusion of asm-offsets.h so that it never
> gets pulled from asm-offsets.c. The same issue exists between
> bounce.c and include/generated/bounds.h, and is worked around
> by using the existing guard symbol.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm64/include/asm/asm-offsets.h | 2 ++
>  arch/arm64/kernel/asm-offsets.c      | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/asm-offsets.h b/arch/arm64/include/asm/asm-offsets.h
> index d370ee36a182..7d6531a81eb3 100644
> --- a/arch/arm64/include/asm/asm-offsets.h
> +++ b/arch/arm64/include/asm/asm-offsets.h
> @@ -1 +1,3 @@
> +#if !defined(__GENERATING_ASM_OFFSETS_H) && !defined(__GENERATING_BOUNDS_H)

I don't understand why we need to check __GENERATING_BOUNDS_H here?
What is the interaction between asm-offsets and bounds?

Thanks,
-Christoffer
