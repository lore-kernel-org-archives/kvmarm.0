Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66009C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 22 Apr 2022 18:27:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFAA04A369;
	Fri, 22 Apr 2022 14:27:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hHY93HjjDjFT; Fri, 22 Apr 2022 14:27:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F33F4B08A;
	Fri, 22 Apr 2022 14:27:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2929A4A369
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:27:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id food35A7gH8O for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Apr 2022 14:27:00 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D344C4A193
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Apr 2022 14:27:00 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2B59E61776;
 Fri, 22 Apr 2022 18:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58777C385A0;
 Fri, 22 Apr 2022 18:26:55 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Shuah Khan <shuah@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: (subset) [PATCH v14 00/39] arm64/sme: Initial support for the
 Scalable Matrix Extension
Date: Fri, 22 Apr 2022 19:26:52 +0100
Message-Id: <165065199613.1610925.15958452310991530163.b4-ty@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419112247.711548-1-broonie@kernel.org>
References: <20220419112247.711548-1-broonie@kernel.org>
MIME-Version: 1.0
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Salil Akerkar <Salil.Akerkar@arm.com>, linux-kselftest@vger.kernel.org,
 Alan Hayward <alan.hayward@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Luca Salabrino <luca.scalabrino@arm.com>
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

On Tue, 19 Apr 2022 12:22:08 +0100, Mark Brown wrote:
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

Applied to arm64 (for-next/kselftest), thanks!

[28/39] kselftest/arm64: Add manual encodings for SME instructions
        https://git.kernel.org/arm64/c/b5d3f4daf4d3
[29/39] kselftest/arm64: sme: Add SME support to vlset
        https://git.kernel.org/arm64/c/0fea47609e48
[30/39] kselftest/arm64: Add tests for TPIDR2
        https://git.kernel.org/arm64/c/f442d9edcff0
[31/39] kselftest/arm64: Extend vector configuration API tests to cover SME
        https://git.kernel.org/arm64/c/7e387a00d640
[32/39] kselftest/arm64: sme: Provide streaming mode SVE stress test
        https://git.kernel.org/arm64/c/aee8a834e3f0
[33/39] kselftest/arm64: signal: Handle ZA signal context in core code
        https://git.kernel.org/arm64/c/f2608edbc17b
[34/39] kselftest/arm64: Add stress test for SME ZA context switching
        https://git.kernel.org/arm64/c/659689a61912
[35/39] kselftest/arm64: signal: Add SME signal handling tests
        https://git.kernel.org/arm64/c/8d41f50ade02
[36/39] kselftest/arm64: Add streaming SVE to SVE ptrace tests
        https://git.kernel.org/arm64/c/e4bbc3f2c589
[37/39] kselftest/arm64: Add coverage for the ZA ptrace interface
        https://git.kernel.org/arm64/c/8f6bb75334f4
[38/39] kselftest/arm64: Add SME support to syscall ABI test
        https://git.kernel.org/arm64/c/5bbfaf598476
[39/39] selftests/arm64: Add a testcase for handling of ZA on clone()
        https://git.kernel.org/arm64/c/fb146c8a0ad9

-- 
Catalin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
