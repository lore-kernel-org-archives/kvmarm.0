Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7529C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 22 Feb 2022 12:53:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 118844B0B4;
	Tue, 22 Feb 2022 07:53:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zf1tHuiteA93; Tue, 22 Feb 2022 07:53:23 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 187FD4B0BA;
	Tue, 22 Feb 2022 07:53:23 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 840114B0AC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 07:53:22 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zj1zcGAWwebi for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 07:53:21 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A67D49EF2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 07:53:21 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 85968B819B6;
 Tue, 22 Feb 2022 12:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 248D4C340E8;
 Tue, 22 Feb 2022 12:53:14 +0000 (UTC)
Date: Tue, 22 Feb 2022 12:53:11 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v11 16/40] arm64/sme: Implement streaming SVE context
 switching
Message-ID: <YhTct2Cy1fMOsjuZ@arm.com>
References: <20220207152109.197566-1-broonie@kernel.org>
 <20220207152109.197566-17-broonie@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220207152109.197566-17-broonie@kernel.org>
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

On Mon, Feb 07, 2022 at 03:20:45PM +0000, Mark Brown wrote:
> When in streaming mode we need to save and restore the streaming mode
> SVE register state rather than the regular SVE register state. This uses
> the streaming mode vector length and omits FFR but is otherwise identical,
> if TIF_SVE is enabled when we are in streaming mode then streaming mode
> takes precedence.
> 
> This does not handle use of streaming SVE state with KVM, ptrace or
> signals. This will be updated in further patches.

I think I get this but a state diagram somewhere would help ;).

IIUC you don't disable SM on a context switch, you just leave it in
place until a task_fpsimd_load(). It shouldn't be a problem as
kernel_neon_begin() disables it anyway.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
