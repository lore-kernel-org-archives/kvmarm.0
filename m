From: gengdongjiu <gengdongjiu@huawei.com>
Subject: Re: [PATCH v5 04/13] arm64: kernel: Survive corrected RAS errors
 notified by SError
Date: Sat, 16 Dec 2017 10:53:51 +0800
Message-ID: <43942acd-f6ff-ec58-aafb-a6f3ba40fab9@huawei.com>
References: <20171215155101.23505-1-james.morse@arm.com>
 <20171215155101.23505-5-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64EE649D19
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 21:51:26 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YInu28bbPyfV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Dec 2017 21:51:24 -0500 (EST)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 03174406D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 21:51:23 -0500 (EST)
In-Reply-To: <20171215155101.23505-5-james.morse@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: James Morse <james.morse@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


On 2017/12/15 23:50, James Morse wrote:
> +asmlinkage void do_serror(struct pt_regs *regs, unsigned int esr)
> +{
> +	nmi_enter();

        How about firstly let APEI kernel driver to handle it by adding patch[1]? if the handling is successful, do_serror() direct return;
        Otherwise continue check the ESR value, for example:
	if (!ghes_notify_sei())
		return;

	[1] https://patchwork.kernel.org/patch/10053027/
> +
> +	/* non-RAS errors are not containable */
> +	if (!arm64_is_ras_serror(esr) || arm64_is_fatal_ras_serror(regs, esr))
> +		arm64_serror_panic(regs, esr);
>  
> -	panic("Asynchronous SError Interrupt");
> +	nmi_exit();
>  }
>  
