Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D9EC4708E
	for <kvmarm@archiver.kernel.org>; Wed,  7 Dec 2022 14:00:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E2784B636;
	Wed,  7 Dec 2022 09:00:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hmF6lADd4xlO; Wed,  7 Dec 2022 09:00:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E03A4B633;
	Wed,  7 Dec 2022 09:00:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8461D4B3FB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 09:00:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qLNRW0wee-Kz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Dec 2022 09:00:24 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 196D9403AD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Dec 2022 09:00:24 -0500 (EST)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.53])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NRzMs4bWqzqSvX;
 Wed,  7 Dec 2022 21:56:09 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Dec 2022 22:00:18 +0800
Subject: Re: [PATCH v14 16/39] arm64/sme: Implement traps and syscall handling
 for SME
To: Mark Brown <broonie@kernel.org>
References: <20220419112247.711548-1-broonie@kernel.org>
 <20220419112247.711548-17-broonie@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <e57552ea-37fb-07da-8560-e26bae8205cd@huawei.com>
Date: Wed, 7 Dec 2022 22:00:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20220419112247.711548-17-broonie@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>,
 Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Alan Hayward <alan.hayward@arm.com>,
 Salil Akerkar <Salil.Akerkar@arm.com>, linux-kselftest@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Luca Salabrino <luca.scalabrino@arm.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 2022/4/19 19:22, Mark Brown wrote:

> diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
> index c938603b3ba0..92c69e5ac269 100644
> --- a/arch/arm64/kernel/syscall.c
> +++ b/arch/arm64/kernel/syscall.c
> @@ -158,11 +158,36 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
>  	syscall_trace_exit(regs);
>  }
>  
> -static inline void sve_user_discard(void)
> +/*
> + * As per the ABI exit SME streaming mode and clear the SVE state not
> + * shared with FPSIMD on syscall entry.
> + */
> +static inline void fp_user_discard(void)
>  {
> +	/*
> +	 * If SME is active then exit streaming mode.  If ZA is active
> +	 * then flush the SVE registers but leave userspace access to
> +	 * both SVE and SME enabled, otherwise disable SME for the
> +	 * task and fall through to disabling SVE too.  This means

It looks a bit confusing to me that in the current implementation, if
ZA is *not* active, we don't actually go to disable SME for the task
(which IMHO can be disabled as user-space is not actively using it now).

> +	 * that after a syscall we never have any streaming mode
> +	 * register state to track, if this changes the KVM code will
> +	 * need updating.
> +	 */
> +	if (system_supports_sme() && test_thread_flag(TIF_SME)) {
> +		u64 svcr = read_sysreg_s(SYS_SVCR_EL0);
> +
> +		if (svcr & SYS_SVCR_EL0_SM_MASK)
> +			sme_smstop_sm();

As per the SME syscall ABI

| On syscall PSTATE.SM will be cleared and the SVE registers will be
| handled as per the standard SVE ABI.

and the SVE syscall ABI

| On syscall, V0..V31 are preserved (as without SVE).  Thus, bits
| [127:0] of Z0..Z31 are preserved.  All other bits of Z0..Z31, and all
| of P0..P15 and FFR become zero on return from a syscall.

Can we infer from the documentation that V0-V31 should be preserved on
return from a syscall? But with sme_smstop_sm(), all implemented bits of
Z0-Z31 are set to zero by hardware. Is this intentional?

Please fix me up if I've mis-read things here.

> +	}
> +
>  	if (!system_supports_sve())
>  		return;
>  
> +	/*
> +	 * If SME is not active then disable SVE, the registers will
> +	 * be cleared when userspace next attempts to access them and
> +	 * we do not need to track the SVE register state until then.
> +	 */
>  	clear_thread_flag(TIF_SVE);
>  
>  	/*

Thanks,
Zenghui
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
