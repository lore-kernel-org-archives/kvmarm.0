Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A25ECAAA1
	for <kvmarm@archiver.kernel.org>; Mon, 19 Sep 2022 17:19:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B19D4B6B6;
	Mon, 19 Sep 2022 13:19:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5M93qUZ-qJeW; Mon, 19 Sep 2022 13:19:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD2D04B62B;
	Mon, 19 Sep 2022 13:19:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 048A14B62B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 13:19:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bXfbrjfeQTJF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Sep 2022 13:19:13 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD7A54B253
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Sep 2022 13:19:13 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 46CC8B80AF4;
 Mon, 19 Sep 2022 17:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C937C433D6;
 Mon, 19 Sep 2022 17:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663607951;
 bh=/6Dpa36lpQvVkyg4qWX2MshLEYQ4S8uTcS2pu3wX/cU=;
 h=From:To:Cc:Subject:Date:From;
 b=e7CBgrh8bngeE5AEml19WKF239x2wfE7bJdgY62sxaMbCf8BkJmR6nprIe8MUcY3Y
 ba9SGg4iNSfzAfcZQfzDKPR7lvlTqTwLvdJYGItQb/NtS5fYECO8ua3WzXuLfY6CfY
 Kq2qwWz78K0+10IOOFLrs6IGVYrMP5ZG9wZxLLFg06YhLeiFWKdTUpbLH7U0nnwW2H
 SY0Hka/otgNTlS8Xjp1nHcT1mthAMiOjXuhZSH4GlL3m6JvKDJkeEx7QAArCTzlwSU
 Q0MTtcQvY8Awcuz7llWPALnTqoSQ7Sx0f2GS7tkrrmT+XiQeBDgfS63Tl3J9PcDM11
 Gq2MTo2l4DgVg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.95)
 (envelope-from <maz@kernel.org>) id 1oaKQG-00BAdf-Pb;
 Mon, 19 Sep 2022 18:19:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [GIT PULL] KVM/arm64 fixes for 6.0, take #2
Date: Mon, 19 Sep 2022 18:18:43 +0100
Message-Id: <20220919171843.2605597-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, catalin.marinas@arm.com,
 oliver.upton@linux.dev, yuzenghui@huawei.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
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

Paolo,

Here's the last KVM/arm64 pull request for this cycle, with
a small fix for pKVM and kmemleak.

Please pull,

        M.

The following changes since commit 1c23f9e627a7b412978b4e852793c5e3c3efc555:

  Linux 6.0-rc2 (2022-08-21 17:32:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-6.0-2

for you to fetch changes up to 522c9a64c7049f50c7b1299741c13fac3f231cd4:

  KVM: arm64: Use kmemleak_free_part_phys() to unregister hyp_mem_base (2022-09-19 17:59:48 +0100)

----------------------------------------------------------------
KVM/arm64 fixes for 6.0, take #2

- Fix kmemleak usage in Protected KVM (again)

----------------------------------------------------------------
Zenghui Yu (1):
      KVM: arm64: Use kmemleak_free_part_phys() to unregister hyp_mem_base

 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
