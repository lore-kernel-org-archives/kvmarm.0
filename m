Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12593C43334
	for <kvmarm@archiver.kernel.org>; Sun, 17 Jul 2022 10:46:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 923F64C913;
	Sun, 17 Jul 2022 06:46:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id omPazwQ-c4E2; Sun, 17 Jul 2022 06:46:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B7674C90C;
	Sun, 17 Jul 2022 06:46:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 167994C913
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Jul 2022 06:46:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oxo3DzMU2n1E for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Jul 2022 06:46:47 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 143964C8FE
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Jul 2022 06:46:47 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id E1B9A61129;
 Sun, 17 Jul 2022 10:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECBFC3411E;
 Sun, 17 Jul 2022 10:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1658054805;
 bh=QNZQ2MZGQpxSYRr7TfR+EAN42ddO5VU2MTMf/qjwilQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=WJWIR1yGZWYGsqQM1lyLeN5MS7r/pKyJtHbApPHuamPyCo2gLPQw02jGyIQQUVtQ3
 4M+7+jEqRF15IbwPRW+inPL9/pWIhFU9tASwyZCMG7LcYvgACn0gsKu0Mz8HavlgT4
 4DLpOq5rW8jxMaAUmUTeRPRMFkEpk1L08jAel81Mrj66x6LD4uKByD4p/RyrlHloQM
 rB4Ep6kjYRSCDhTOK/dl1V/bU2Kxv7L9aZ8ZzNHt0pR4JWNL5GCU0rQdEpAvYRxrSA
 /T1kKzq6x/QjpalenOb6ELyfoXYsCKrnGdmgVohZq1oGx1c+VwgehYFlmYPGGfK3M+
 7cEVq8pud+Nwg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oD1nP-007zrB-5U;
 Sun, 17 Jul 2022 11:46:43 +0100
From: Marc Zyngier <maz@kernel.org>
To: mark.rutland@arm.com, broonie@kernel.org,
 Kalesh Singh <kaleshsingh@google.com>, tabba@google.com,
 madvenka@linux.microsoft.com
Subject: Re: [PATCH] KVM: arm64: Fix hypervisor address symbolization
Date: Sun, 17 Jul 2022 11:46:39 +0100
Message-Id: <165805475449.3537183.8979480362090216052.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220715235824.2549012-1-kaleshsingh@google.com>
References: <20220715235824.2549012-1-kaleshsingh@google.com>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: mark.rutland@arm.com, broonie@kernel.org,
 kaleshsingh@google.com, tabba@google.com, madvenka@linux.microsoft.com,
 linux-arm-kernel@lists.infradead.org, suzuki.poulose@arm.com,
 james.morse@arm.com, will@kernel.org, alexandru.elisei@arm.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu, qperret@google.com,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
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

On Fri, 15 Jul 2022 16:58:24 -0700, Kalesh Singh wrote:
> With CONFIG_RANDOMIZE_BASE=y vmlinux addresses will resolve correctly
> from kallsyms. Fix this by adding the KASLR offset before printing the
> symbols.
> 
> Based on arm64 for-next/stacktrace.

Applied to next, thanks!

[1/1] KVM: arm64: Fix hypervisor address symbolization
      commit: ed6313a93fd11d2015ad17046f3c418bf6a8dab1

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
