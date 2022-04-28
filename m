Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E92C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 28 Apr 2022 09:19:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C11E40FAA;
	Thu, 28 Apr 2022 05:19:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JIml1XgWPSmT; Thu, 28 Apr 2022 05:19:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0A7411C7;
	Thu, 28 Apr 2022 05:19:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C673040F9C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 05:19:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4SDyz22EOUJQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2022 05:19:31 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B05F340E62
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2022 05:19:31 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 4F58E612C5;
 Thu, 28 Apr 2022 09:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 700BEC385A0;
 Thu, 28 Apr 2022 09:19:26 +0000 (UTC)
Date: Thu, 28 Apr 2022 10:19:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v14 04/39] arm64/sme: Provide ABI documentation for SME
Message-ID: <YmpcGpSYpoiprngy@arm.com>
References: <20220419112247.711548-1-broonie@kernel.org>
 <20220419112247.711548-5-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220419112247.711548-5-broonie@kernel.org>
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Will Deacon <will@kernel.org>, Luis Machado <luis.machado@arm.com>,
 Szabolcs Nagy <szabolcs.nagy@arm.com>, Marc Zyngier <maz@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 Shuah Khan <shuah@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Salil Akerkar <Salil.Akerkar@arm.com>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Apr 19, 2022 at 12:22:12PM +0100, Mark Brown wrote:
> +* There are a number of optional SME features, presence of these is reported
> +  through AT_HWCAP2 through:
> +
> +	HWCAP2_SME_I16I64
> +	HWCAP2_SME_F64F64
> +	HWCAP2_SME_I8I32
> +	HWCAP2_SME_F16F32
> +	HWCAP2_SME_B16F32
> +	HWCAP2_SME_F32F32
> +	HWCAP2_SME_FA64

Marc pointed out that in combination with FEAT_WFxT, we used all the
HWCAP2 bits (32). While we are ok for now, we'll soon need to look into
what to do when the next features turn up. Some options:

1. Only provide HWCAP2_SME and let the ID_AA64SMFR0_EL1 features be
   probed via MRS emulation. It doesn't solve the problem but it buys us
   a bit of time.

2. Don't bother with any new HWCAPs, just rely on MRS emulation (we have
   HWCAP_CPUID advertising this).

3. Start using the upper 32-bit of HWCAP and HWCAP2 (we initially didn't
   go into these as there was a slight chance of merging ILP32). Does
   the libc rely on the upper bits for anything? Or does it just assume
   a 32-bit HWCAPs layout?

4. Introduce HWCAP3.

Szabolcs, any thoughts?

Thanks.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
