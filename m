Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02EAFC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 15:40:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B71E4C613;
	Wed, 23 Feb 2022 10:40:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Xa5h4l+WPp2o; Wed, 23 Feb 2022 10:40:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05BC34C5C7;
	Wed, 23 Feb 2022 10:40:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4967B4B235
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 10:40:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ewoCuI38F0g3 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Feb 2022 10:40:46 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA0AC4B308
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 10:40:46 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 7B97BB820C9;
 Wed, 23 Feb 2022 15:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1019CC340E7;
 Wed, 23 Feb 2022 15:40:40 +0000 (UTC)
Date: Wed, 23 Feb 2022 15:40:37 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v11 28/40] KVM: arm64: Handle SME host state when running
 guests
Message-ID: <YhZVdRLF7RMBbfjG@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-29-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220207152109.197566-29-broonie@kernel.org>
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

On Mon, Feb 07, 2022 at 03:20:57PM +0000, Mark Brown wrote:
> While we don't currently support SME in guests we do currently support it
> for the host system so we need to take care of SME's impact, including
> the floating point register state, when running guests. Simiarly to SVE
> we need to manage the traps in CPACR_RL1, what is new is the handling of
> streaming mode and ZA.
> 
> Normally we defer any handling of the floating point register state until
> the guest first uses it however if the system is in streaming mode FPSIMD
> and SVE operations may generate SME traps which we would need to distinguish
> from actual attempts by the guest to use SME. Rather than do this for the
> time being if we are in streaming mode when entering the guest we force
> the floating point state to be saved immediately and exit streaming mode,
> meaning that the guest won't generate SME traps for supported operations.
> 
> We could handle ZA in the access trap similarly to the FPSIMD/SVE state
> without the disruption caused by streaming mode but for simplicity
> handle it the same way as streaming mode for now.
> 
> This will be revisited when we support SME for guests (hopefully before SME
> hardware becomes available), for now it will only incur additional cost on
> systems with SME and even there only if streaming mode or ZA are enabled.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
