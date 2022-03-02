Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD50C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Mar 2022 16:29:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85E0749F28;
	Wed,  2 Mar 2022 11:29:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NX5wownd9p23; Wed,  2 Mar 2022 11:29:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36DC249F11;
	Wed,  2 Mar 2022 11:29:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 916F449ED9
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 11:29:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A+dfXMii-o9G for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2022 11:29:39 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30C6B49ECA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2022 11:29:39 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 8714FB81F52;
 Wed,  2 Mar 2022 16:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA5AC340ED;
 Wed,  2 Mar 2022 16:29:32 +0000 (UTC)
Date: Wed, 2 Mar 2022 16:29:29 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v12 10/40] arm64/sme: Basic enumeration support
Message-ID: <Yh+bafhTeVpJct3M@arm.com>
References: <20220225165923.1474372-1-broonie@kernel.org>
 <20220225165923.1474372-11-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220225165923.1474372-11-broonie@kernel.org>
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

On Fri, Feb 25, 2022 at 04:58:53PM +0000, Mark Brown wrote:
> +HWCAP2_SME
> +
> +    Functionality implied by ID_AA64PFR1_EL1.SME == 0b0001, as described
> +    by Documentation/arm64/sme.rst.
> +
> +HWCAP2_SME_I16I64
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.I16I64 == 0b1111.
> +
> +HWCAP2_SME_F64F64
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.F64F64 == 0b1.
> +
> +HWCAP2_SME_I8I32
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.I8I32 == 0b1111.
> +
> +HWCAP2_SME_F16F32
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.F16F32 == 0b1.
> +
> +HWCAP2_SME_B16F32
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.B16F32 == 0b1.
> +
> +HWCAP2_SME_F32F32
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.F32F32 == 0b1.
> +
> +HWCAP2_SME_FA64
> +
> +    Functionality implied by ID_AA64SMFR0_EL1.FA64 == 0b1.

Without any strong opinion only exposing MRS emulation for these, I
guess we go ahead with adding all these new HWCAPs.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
