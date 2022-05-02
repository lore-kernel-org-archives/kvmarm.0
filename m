Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4EE9C433F5
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 23:39:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 603524B1BD;
	Mon,  2 May 2022 19:39:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eq43k7cvGwRd; Mon,  2 May 2022 19:39:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6934C4B1FA;
	Mon,  2 May 2022 19:39:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 974BD4B23A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 19:39:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GnKH4Auju9HH for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 19:39:07 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 909A24B1C9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 19:39:07 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 bj12-20020a170902850c00b0015adf30aaccso7183895plb.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 16:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=mpC3gngOJnTYNbZIy5XpBZE4tNfXvg4sSdGII/rINPg=;
 b=kwJzZU08zTMMYRTPGul44netZRFM/Fn7mp2jbTMXigZFZjwIWzKp7+vSa1nCB8qwgS
 kCbrRB58JNwK9MoOO12gCVsZ1DM+1nuUeA98O7urT8dIDnngCH704X7hz0NU8r1zvpat
 wcnNFYuTZ4XW1B6+wWWG43FqBL56s+0FTwQGVOOpie0v1F0ZphBbDiIoVstFw3HISQHo
 0SuqofRCG5wZcjFZVbOcarkCL/9CBE0/mqvaXhokdaQJppOXdi/iIR2L2gpYpyzsDj1h
 lL4DO4OXCo4BSRFALMwUYoqFOLGiQueq4HT8CsYDiYofE9GPbh6PvRZTzCBd8Ujzg0PD
 /Zrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=mpC3gngOJnTYNbZIy5XpBZE4tNfXvg4sSdGII/rINPg=;
 b=j3Vig6xnivCSLd0Znd6MJ0YKTSh4yTJ5uG2luGp90BMoP3o68mRu1f2GPYVuaDumM7
 pKdZcuAc+DDPmaHnO/7AzIhBhBWFQXlPCtK9O3fUCFCwjcFUIbm67qM7P/+Klk+CKFox
 mQ3/aAw9lePXe4FM5+DeDu31eciQVJE4ER2wgcLE3pwcfig8MwXbh5HWXoSgKpaAhw8M
 kgfLHq2nMAdIQuEIZO9UKkR44mpWZUeKQIGsjymIUu2DTCS49UZ/lt7Tqm5LChJifYld
 +OQocSvKAVDgxVD3o+xdLwL62G33lq6TEzPeQVRa4IVgvu65vMMh1CkjXJzZRSsmUwl7
 NbNQ==
X-Gm-Message-State: AOAM532wBq39G1aLB1tw8V40W7Bq2Cz8UKtaJF9a0+wbK0GBKcxPvKKd
 51qckILoEcShH64n8/gQ1dUeFwKaTsf+
X-Google-Smtp-Source: ABdhPJyaZXXkFRI0DH02jQSgoTliFZw6c6KZBZFaTXiesw7Fo73NRrlthGbaEga6iWfIyzRxWO1La6dDWR5Z
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a17:902:d4d2:b0:15e:a9b0:3b21 with SMTP id
 o18-20020a170902d4d200b0015ea9b03b21mr5688864plg.142.1651534746776; Mon, 02
 May 2022 16:39:06 -0700 (PDT)
Date: Mon,  2 May 2022 23:38:49 +0000
In-Reply-To: <20220502233853.1233742-1-rananta@google.com>
Message-Id: <20220502233853.1233742-6-rananta@google.com>
Mime-Version: 1.0
References: <20220502233853.1233742-1-rananta@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v7 5/9] Docs: KVM: Rename psci.rst to hypercalls.rst
From: Raghavendra Rao Ananta <rananta@google.com>
To: Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>, 
 James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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

Since the doc also covers general hypercalls' details,
rather than just PSCI, and the fact that the bitmap firmware
registers' details will be added to this doc, rename the file
to a more appropriate name- hypercalls.rst.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)

diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/psci.rst
rename to Documentation/virt/kvm/arm/hypercalls.rst
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
