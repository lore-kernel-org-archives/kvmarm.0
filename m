Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33957C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 15:17:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 83D9D4C5B7;
	Wed, 23 Feb 2022 10:17:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TwEKX9xpvX9c; Wed, 23 Feb 2022 10:17:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABC794C594;
	Wed, 23 Feb 2022 10:17:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D9DD4C58E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 10:17:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UpDmkcvwDRUv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Feb 2022 10:16:56 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ECE194C581
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 10:16:55 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 92FCB61720;
 Wed, 23 Feb 2022 15:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53D4C340EB;
 Wed, 23 Feb 2022 15:16:50 +0000 (UTC)
Date: Wed, 23 Feb 2022 15:16:46 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v11 20/40] arm64/sme: Implement streaming SVE signal
 handling
Message-ID: <YhZP3gMmAc6mbFTd@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-21-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220207152109.197566-21-broonie@kernel.org>
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

On Mon, Feb 07, 2022 at 03:20:49PM +0000, Mark Brown wrote:
> When in streaming mode we have the same set of SVE registers as we do in
> regular SVE mode with the exception of FFR and the use of the SME vector
> length. Provide signal handling for these registers by taking one of the
> reserved words in the SVE signal context as a flags field and defining a
> flag with a flag which is set for streaming mode. When the flag is set the

Too many "flag" words.

> @@ -593,11 +613,16 @@ static int setup_sigframe_layout(struct rt_sigframe_user_layout *user,
>  	if (system_supports_sve()) {
>  		unsigned int vq = 0;
>  
> -		if (add_all || test_thread_flag(TIF_SVE)) {
> -			int vl = sve_max_vl();
> +		if (add_all || test_thread_flag(TIF_SVE) ||
> +		    thread_sm_enabled(&current->thread)) {
> +			int vl = max(sve_max_vl(), sme_max_vl());
>  
> -			if (!add_all)
> -				vl = task_get_sve_vl(current);
> +			if (!add_all) {
> +				if (thread_sm_enabled(&current->thread))
> +					vl = task_get_sme_vl(current);
> +				else
> +					vl = task_get_sve_vl(current);
> +			}
>  
>  			vq = sve_vq_from_vl(vl);

Nitpick: this looks a bit too complicated, maybe split it in three
separate if/else blocks.

Either way,

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
