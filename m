Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3ADC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 18:55:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB6F149F29;
	Wed,  4 May 2022 14:55:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x1G-yHE7tchM; Wed,  4 May 2022 14:55:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A65149F17;
	Wed,  4 May 2022 14:55:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F4C649F04
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 14:55:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zxqkFEZMXBuF for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 May 2022 14:55:24 -0400 (EDT)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28B1749EF2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 May 2022 14:55:24 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 1C773CE24B3;
 Wed,  4 May 2022 18:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541E5C385A4;
 Wed,  4 May 2022 18:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1651690517;
 bh=pG712z439yyrRfw7zAynun7bA7UKkGA/RKPiOnQrhG4=;
 h=From:To:Subject:Date:In-Reply-To:References:From;
 b=Dm/k7lXMxID75aVZEcWUsy7Hf2VvRJQExKv/keEOIhPU5ozTD1Oiqb7DRSQgf77ws
 ESGHPpZ1KaFNA2vM5QiNSuJD2AAmSX482BhfAICgVq/RUGzuHfGKkizStx2fne+keZ
 F6DSYaBKee70/IwYEam56JBy27P9vPlLPAk5znqF37utN4i6ToAjQd2ebIcGJFQnZZ
 cTGoU8cCtxbpMxOg/ycWx3sayBHRimjhj4JmfjLrZrW0wX/R4txAN09B5ATn9AM9LP
 u/liENnSp1F8lBDfa7346yN9fxoy8F7fWik3P5eBcxCRHiylE9QiJICQPcCbNeXBJc
 Ajw2KGmdUefOQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nmK9a-0090xB-Qx; Wed, 04 May 2022 19:55:14 +0100
From: Marc Zyngier <maz@kernel.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com
Subject: Re: [PATCH v2 0/2] KVM/arm64: sys_reg_table_init() small improvements
Date: Wed,  4 May 2022 19:55:12 +0100
Message-Id: <165169050533.122765.3708868029385767320.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220428103405.70884-1-alexandru.elisei@arm.com>
References: <20220428103405.70884-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 kvmarm@lists.cs.columbia.edu, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
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

On Thu, 28 Apr 2022 11:34:03 +0100, Alexandru Elisei wrote:
> These are two small improvements to how KVM handles an out-of-order
> sys_reg_desc table. These should only affect KVM developers, as the end
> user should never see an error caused by an unsorted sys_reg_desc table.
> 
> Changes in v2:
> 
> * Tweaked how the error is detected and propagated in kvm_arch_init().
> * Use %pS to print the table name and entry offset (Marc).
> * Tweaked the error message to spell out that magic number refers to the
>   offending entry.
> 
> [...]

Applied to next, thanks!

[1/2] KVM/arm64: Don't BUG_ON() if emulated register table is unsorted
      commit: f1f0c0cfeaa7c10eb536d9919bf3902af0e17bce
[2/2] KVM/arm64: Print emulated register table name when it is unsorted
      commit: 325031d4f39cfb1adf41708c1329e60b9abfbdac

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
