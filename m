Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC1DC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 25 Feb 2022 15:50:30 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 373B14B9D2;
	Fri, 25 Feb 2022 10:50:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F-QRnp2wKdQl; Fri, 25 Feb 2022 10:50:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E519E4B9C4;
	Fri, 25 Feb 2022 10:50:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 194634B9C3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 10:50:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rnLXFd+85qEM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Feb 2022 10:50:25 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B1C724B950
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Feb 2022 10:50:25 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 9C21B619AC;
 Fri, 25 Feb 2022 15:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D90C340E7;
 Fri, 25 Feb 2022 15:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1645804224;
 bh=6zeaKhd1cDa2VHznk9BHK/J+rUpp98k9PC6C1x/CCcA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=OmQogqEMrHFY/J4fGPzzzQHFACVS3JY4bSut9uF3yhpbwzWJrxULaAJsdBbdLt9G8
 cl5vYyO+5zhZ+F2+6PpBTzuWjzAB65KOxo/+Yi+ANh5kiOmHT4mtyFAwYkYH/WmcOR
 Ash2BtQr0e5U6V6cfHsQ2LPParHbx/cRaI6JNCEcnqgZHai+7cFTvchQcIaV1c3Dl1
 D3CBaSzPYzSV4w5rzOWIzvAK/kO0GYqNq2IKK5smD6uhD9onns158aLqmOiExCIofm
 t9mPL3g0VnSWQF2omRJ4dQA+PfCszH+udd2TajYiX/WHMtnRnxgBz8ki6JslOavKLP
 9jSwUFz0f+aaQ==
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v11 00/40] arm64/sme: Initial support for the Scalable
 Matrix Extension
Date: Fri, 25 Feb 2022 15:50:12 +0000
Message-Id: <164579991080.3691228.14311210559888008730.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220207152109.197566-1-broonie@kernel.org>
References: <20220207152109.197566-1-broonie@kernel.org>
MIME-Version: 1.0
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

On Mon, 7 Feb 2022 15:20:29 +0000, Mark Brown wrote:
> This series provides initial support for the ARMv9 Scalable Matrix
> Extension (SME).  SME takes the approach used for vectors in SVE and
> extends this to provide architectural support for matrix operations.  A
> more detailed overview can be found in [1].
> 
> For the kernel SME can be thought of as a series of features which are
> intended to be used together by applications but operate mostly
> orthogonally:
> 
> [...]

Applied patch 5 to arm64 (for-next/kselftest), thanks!

[05/40] kselftest/arm64: signal: Allow tests to be incompatible with features
        https://git.kernel.org/arm64/c/32de73e89099

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
