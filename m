Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0ED0C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 21 Feb 2022 15:57:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55EF84B1D1;
	Mon, 21 Feb 2022 10:57:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lQfU6XCtLexc; Mon, 21 Feb 2022 10:57:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BE274B133;
	Mon, 21 Feb 2022 10:57:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 362424B128
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 10:57:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MCSyyrMRji90 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 Feb 2022 10:57:29 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EDA64B120
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 Feb 2022 10:57:29 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 1863EB81239;
 Mon, 21 Feb 2022 15:57:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C24BC340E9;
 Mon, 21 Feb 2022 15:57:23 +0000 (UTC)
Date: Mon, 21 Feb 2022 15:57:20 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v11 11/40] arm64/sme: Identify supported SME vector
 lengths at boot
Message-ID: <YhO2YJ1mliDYjy67@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-12-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220207152109.197566-12-broonie@kernel.org>
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

On Mon, Feb 07, 2022 at 03:20:40PM +0000, Mark Brown wrote:
> @@ -977,6 +984,14 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
>  		vec_init_vq_map(ARM64_VEC_SVE);
>  	}
>  
> +	if (id_aa64pfr1_sme(info->reg_id_aa64pfr1)) {
> +		init_cpu_ftr_reg(SYS_SMCR_EL1, info->reg_smcr);
> +		if (IS_ENABLED(CONFIG_ARM64_SME)) {
> +			sme_kernel_enable(NULL);
> +			vec_init_vq_map(ARM64_VEC_SME);
> +		}
> +	}

Why do we need to call sme_kernel_enable() here? It's called again later
via the cpufeature framework. I guess you need the CPACR_EL1 setup but
we don't seem to do this for SVE.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
