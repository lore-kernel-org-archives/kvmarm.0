Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075A5C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 15:22:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E4774C5DC;
	Wed, 23 Feb 2022 10:22:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id V-62Z8GYHOJi; Wed, 23 Feb 2022 10:22:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C0314C5DF;
	Wed, 23 Feb 2022 10:22:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEEA74C5DC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 10:22:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g6bHCzqRcO-b for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Feb 2022 10:22:49 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 423144C5DB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 10:22:49 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E49CFB82079;
 Wed, 23 Feb 2022 15:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8B7C340E7;
 Wed, 23 Feb 2022 15:22:43 +0000 (UTC)
Date: Wed, 23 Feb 2022 15:22:40 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v11 22/40] arm64/sme: Implement ptrace support for
 streaming mode SVE registers
Message-ID: <YhZRQH+C4RzrSdn5@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-23-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220207152109.197566-23-broonie@kernel.org>
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Mon, Feb 07, 2022 at 03:20:51PM +0000, Mark Brown wrote:
> diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
> index 2242c14a5a05..8b111b7f2006 100644
> --- a/arch/arm64/kernel/fpsimd.c
> +++ b/arch/arm64/kernel/fpsimd.c
> @@ -645,14 +645,19 @@ static void __fpsimd_to_sve(void *sst, struct user_fpsimd_state const *fst,
>   */
>  static void fpsimd_to_sve(struct task_struct *task)
>  {
> -	unsigned int vq;
> +	unsigned int vq, vl;
>  	void *sst = task->thread.sve_state;
>  	struct user_fpsimd_state const *fst = &task->thread.uw.fpsimd_state;
>  
>  	if (!system_supports_sve())
>  		return;
>  
> -	vq = sve_vq_from_vl(task_get_sve_vl(task));
> +	if (thread_sm_enabled(&task->thread))
> +		vl = task_get_sme_vl(task);
> +	else
> +		vl = task_get_sve_vl(task);

I saw this construct in the signal patches as well. Can we have a
function/macro that checks the SM enabled and returns the proper vl?

Otherwise,

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
