Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E18C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 16:12:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76E074B1DD;
	Wed, 15 Dec 2021 11:12:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IMtWZy2AkFwJ; Wed, 15 Dec 2021 11:12:56 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 581304B1C0;
	Wed, 15 Dec 2021 11:12:56 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BED74B139
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:12:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kEfM2O1BqUEG for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 11:12:53 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 569004B1E3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:12:53 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id
 y4-20020adfd084000000b00186b16950f3so6015120wrh.14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 08:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=MMV17RJGBqBIJSSqtbn1eP7i2KWhmG0Xg4IIILFGbk4=;
 b=TsX1J3w5V1i1HiSUsll+2W48tuChkMnwn+NtSsjIf5wMQ/88zmPZGculZ89WOyPr3y
 j7pfWDg3rD3EXldiIIgv8sTtXjmPWmn51rcw1Ws2CkNWVjJXW5VokmWSB1gwCxhyuMKM
 SUISMwNLFpghQZ4k/mzBK3Bq4d4t3/yH52+nPjJQ7j4y7zkpM0AnUwaMaAceawUvM6GI
 JOi+15VpsBSiAkh94aO7LxLWQaPi2fx8ajh9TuBtNOxv5QBBiWiQdfzxPYloLQh6qbQQ
 DRaNQ4HCuH9Ny/kX7+8XHgzmsXoKhF3r3Loka1NP2RKyZk8zSa4QplVyKQPCLZ64AhNE
 emhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=MMV17RJGBqBIJSSqtbn1eP7i2KWhmG0Xg4IIILFGbk4=;
 b=4x4hdQtx1Oexmb8eUv3+laAECHUCgSvxHrucxSGXR7FzLothkxOghIM+0Ap/6dv7NB
 3xp8Y6zo5D/bdfJRIV3AVrYhSszVT5U9fkKpKxUESSWNuAZY8OmDNv6BICpYQBCDlBld
 pwywJL1P/0CsLt4jb+wycQRP8cPBcPwKkzMd7FJJ58F4ouQFL1v0n7C4qqtzdwetIR6Q
 CtnnOsPnkInPxvfUNOF1bAyvN7QMAw8ksdEQNK0jT4fajp89eYbKeu0bkGKDrhHicyb3
 /p5bI/KVqqJTFtwNCxmNu9bribrA/kaieHwQV7zIk11nJMDaHzszVUYFY6afSs7veWSQ
 kjYg==
X-Gm-Message-State: AOAM530i4IP9fMEJ5e5bFvzesfSaT78YATfMbL5djnQRpkDEmnLfQ49s
 EUDFcq6jkKS/25qTWRCoZBje7tHJnfSR
X-Google-Smtp-Source: ABdhPJyfCs0Hha3nCPUt4YLDazw5cpbIxT+GVyubvLUpddKOfvogqT7sUw4CAzf8KJFy2IBZwJrNH4Y6lhHT
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:fc03:4f5b:4e9b:3ec1])
 (user=qperret job=sendgmr) by 2002:a5d:650f:: with SMTP id
 x15mr5133650wru.201.1639584772363; Wed, 15 Dec 2021 08:12:52 -0800 (PST)
Date: Wed, 15 Dec 2021 16:12:21 +0000
In-Reply-To: <20211215161232.1480836-1-qperret@google.com>
Message-Id: <20211215161232.1480836-5-qperret@google.com>
Mime-Version: 1.0
References: <20211215161232.1480836-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 04/14] KVM: arm64: Hook up ->page_count() for hypervisor
 stage-1 page-table
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: qwandor@google.com, linux-kernel@vger.kernel.org, kernel-team@android.com,
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

From: Will Deacon <will@kernel.org>

kvm_pgtable_hyp_unmap() relies on the ->page_count() function callback
being provided by the memory-management operations for the page-table.

Wire up this callback for the hypervisor stage-1 page-table.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index ab44e004e6d3..27af337f9fea 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -258,6 +258,7 @@ void __noreturn __pkvm_init_finalise(void)
 		.virt_to_phys = hyp_virt_to_phys,
 		.get_page = hpool_get_page,
 		.put_page = hpool_put_page,
+		.page_count = hyp_page_count,
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
