Return-Path: <SRS0=ArS2=HK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA79C433E0
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 14:33:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C53BD64E8C
	for <kvmarm@archiver.kernel.org>; Mon,  8 Feb 2021 14:33:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C53BD64E8C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BAC34B1C8;
	Mon,  8 Feb 2021 09:33:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SaXcBRJIoitl; Mon,  8 Feb 2021 09:32:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3345F4B201;
	Mon,  8 Feb 2021 09:32:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 544714B1A4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 09:32:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0pIMlqnN4F4t for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Feb 2021 09:32:57 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24CF24B0F1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Feb 2021 09:32:57 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF0E464E30;
 Mon,  8 Feb 2021 14:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612794776;
 bh=6KdzPmYqB+bGvxQs/MeqN8+No+/dd/gL7m2Dw37//uo=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=YRxcx/CzDqmm4c++0Yqjr8ULS70s5iUOjyryFfltC8Nh1jciCm4FVQCFWeC6lf2l/
 NCxLd1tT3BNbg4MKtkYidcnaLY0NZV0KKXXJMJDKvBkcvsUh2N2qjunOr0EZSEUZo2
 5ol0kGGH+7wX+DPe1MLj7koxS0sUJJoVUjuWrB795/sQhFe4fczU8cmM6BSeFYHOgr
 CCH0NA/qYle0yA0DxCBrBvu5TMjLax1+Ti+xUKyuIoKbsrj33arc3d7FFfRNnrBEUj
 /pFtS3a8uvOELDElhswdUPrmFfnScr9Q3DXldE0Y62WcypCettcUoOX8LDuap+CWFQ
 dl/NkZ6/RmH2Q==
Date: Mon, 8 Feb 2021 14:32:49 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v7 00/23] arm64: Early CPU feature override, and
 applications to VHE, BTI and PAuth
Message-ID: <20210208143248.GA25934@willie-the-truck>
References: <20210208095732.3267263-1-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210208095732.3267263-1-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Hector Martin <marcan@marcan.st>,
 linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 Ajay Patil <pajay@qti.qualcomm.com>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On Mon, Feb 08, 2021 at 09:57:09AM +0000, Marc Zyngier wrote:
> It recently came to light that there is a need to be able to override
> some CPU features very early on, before the kernel is fully up and
> running. The reasons for this range from specific feature support
> (such as using Protected KVM on VHE HW, which is the main motivation
> for this work) to errata workaround (a feature is broken on a CPU and
> needs to be turned off, or rather not enabled).
> 
> This series tries to offer a limited framework for this kind of
> problems, by allowing a set of options to be passed on the
> command-line and altering the feature set that the cpufeature
> subsystem exposes to the rest of the kernel. Note that this doesn't
> change anything for code that directly uses the CPU ID registers.

I applied this locally, but I'm seeing consistent boot failure under QEMU when
KASAN is enabled. I tried sprinkling some __no_sanitize_address annotations
around (see below) but it didn't help. The culprit appears to be
early_fdt_map(), but looking a bit more closely, I'm really nervous about the
way we call into C functions from __primary_switched. Remember -- this code
runs _twice_ when KASLR is active: before and after the randomization. This
also means that any memory writes the first time around can be lost due to
the D-cache invalidation when (re-)creating the kernel page-tables.

Will

--->8

diff --git a/arch/arm64/kernel/idreg-override.c b/arch/arm64/kernel/idreg-override.c
index dffb16682330..751ed55261b5 100644
--- a/arch/arm64/kernel/idreg-override.c
+++ b/arch/arm64/kernel/idreg-override.c
@@ -195,7 +195,7 @@ static __init void parse_cmdline(void)
 /* Keep checkers quiet */
 void init_feature_override(void);
 
-asmlinkage void __init init_feature_override(void)
+asmlinkage void __init __no_sanitize_address init_feature_override(void)
 {
        int i;
 
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 61845c0821d9..33581de05d2e 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -170,12 +170,12 @@ static void __init smp_build_mpidr_hash(void)
 
 static void *early_fdt_ptr __initdata;
 
-void __init *get_early_fdt_ptr(void)
+void __init __no_sanitize_address *get_early_fdt_ptr(void)
 {
        return early_fdt_ptr;
 }
 
-asmlinkage void __init early_fdt_map(u64 dt_phys)
+asmlinkage void __init __no_sanitize_address early_fdt_map(u64 dt_phys)
 {
        int fdt_size;
 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
