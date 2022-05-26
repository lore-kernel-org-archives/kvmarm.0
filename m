Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C6CC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 26 May 2022 09:17:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C364A4B2EE;
	Thu, 26 May 2022 05:17:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1QAshzGLdihx; Thu, 26 May 2022 05:17:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6B084B2F5;
	Thu, 26 May 2022 05:17:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFA9A4B2F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 05:17:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tebrgJTJhDxa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 May 2022 05:17:50 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C7E84B2F2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 May 2022 05:17:49 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 6E1C2CE2156;
 Thu, 26 May 2022 09:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325D5C385A9;
 Thu, 26 May 2022 09:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1653556661;
 bh=A7E8HX9ioSMT4howvL7QCUCL8On18sEyBw4bWfTnRSE=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=qaKHOTXEF2aNN1FS9XL+1Ealfi7aP+lBf4MKrMrV5xqOLgN5THg9DRoK4WztcKH/Y
 QjM8qvzEb0B+inLsZk4b1VGpKdS1RQbG4vbLIwtZqQ+7Ybz0AOWRBxLVCHOn1SJx49
 jUVkMM9l+Ckk4d3UBJYJ2IqlNiRzwxxFExEsWk/m1VOCNj11lmtIY3HGhY6I0O70bi
 ITqslaj7ngZWqCKnWGoffYcd7Cishau3UjAUlU7UKmz0zEI3M6N8fFYo9QesMYkQVT
 sAdFb+1MWfQzwAdYfytzmLx/UvWNM59ZdeCbDmspB1Popn2/pmHtm5hhEOZmikQjeS
 KO69ynLKy1gXg==
From: Will Deacon <will@kernel.org>
To: julien.thierry.kdev@gmail.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, andre.przywara@arm.com,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool 0/2] Fixes for arm64 and MIPS
Date: Thu, 26 May 2022 10:17:33 +0100
Message-Id: <165355588444.3704118.4392474645066571578.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220525165704.186754-1-alexandru.elisei@arm.com>
References: <20220525165704.186754-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: catalin.marinas@arm.com, kernel-team@android.com,
 Will Deacon <will@kernel.org>
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

On Wed, 25 May 2022 17:57:02 +0100, Alexandru Elisei wrote:
> The first fix is for arm64, where the VCPUs weren't pinned correctly with
> --vcpu-affinity when creating an aarch32 guest. Hopefully the patch is
> straightforward.
> 
> The last patch is a fix for MIPS not compiling for a year now, ever since
> hw/serial.c was changed to use a different address for arm/arm64 in commit
> 45b4968e0de1 ("hw/serial: ARM/arm64: Use MMIO at higher addresses"). Did
> some digging and it turns out that the serial never worked on MIPS since
> RAM starts at 0 for the architecture. So I just removed hw/serial.o from the
> list of compilation objects, which revelead that kvm-ipc assumes that all
> architectures use the 16550/8250 UART. Added a stub for
> serial8250__inject_sysreg() to MIPS to fix that.
> 
> [...]

Applied to kvmtool (master), thanks!

[1/2] arm64: Honor --vcpu-affinity for aarch32 guests
      https://git.kernel.org/will/kvmtool/c/8ec1e8bf3bc2
[2/2] mips: Do not emulate a serial device
      https://git.kernel.org/will/kvmtool/c/6f6f384cef27

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
