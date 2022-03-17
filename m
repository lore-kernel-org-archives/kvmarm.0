Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CD1BC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 17 Mar 2022 00:56:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07CE649F1D;
	Wed, 16 Mar 2022 20:56:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HTb8ljF3U2CV; Wed, 16 Mar 2022 20:56:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06BFF49EFB;
	Wed, 16 Mar 2022 20:56:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D45A249E2B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 20:56:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s-nIY6-HsQMI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Mar 2022 20:56:39 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A929C49E08
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 20:56:39 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 y7-20020a626407000000b004f6d39f1b0fso2621923pfb.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Mar 2022 17:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=f7NVp4rKotjqIcTFxrLFKx5kAJIcRb+37x0j8pTptqo=;
 b=h1z5DqgHKp/WZp7bzBxVpJZVKJEw/mPutBhovv7AoQN2g0WeDgqpAMBJ6YgztUYSQW
 +CnB6TjHShzhiA56pO9ZPjacbgb75Sv/ZPNn01EQIDFRzk8GXA8CqrlV8X1J6C1qmok2
 gPIzz96AebT2+AAQa17hZAOsbqilmmf41Sw3YYEBDhblHmwGTje4hwBy575B2Lth7Pfp
 mRlWVuHXH/hCQIcFj6t1pUZDFe4jFwOj4P132YKhzxsmsDMuJwv/Jo3spPKVFk3J8UV5
 WH7tvOy6t00N8jmoc6IKLWDUYE0sJ9aojVu179oS0HFtw2MdYOU6yNImn24W0YQr5kbG
 bakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=f7NVp4rKotjqIcTFxrLFKx5kAJIcRb+37x0j8pTptqo=;
 b=YkmUcFJLvSI+exeMUvBIAPzzOUC4+7IML5uQcpb75AcZfE59YsqUvfPA/PaCVdsryE
 1fMaWwyYO8c12sLezIT0cs0oL3IYeQmwFoT8r5kxe2nvn34Ah8u4FVxsl0t7BarLofDj
 ak25S0mTBrdVBdPjuoOAgGDfKqe51739aZeAeqXx6IK3tOc0moI8vHB5pqPHeGIAasU4
 RzK8KVvJvHraqQjGA0U1PBe4JBg+8bMnH2WxZ656fJaEqH/rWwLfhtRGpa1OXlNmTApo
 RZP7aB1PUjg8va4GBkzc182e56tp2uBAkrLQlzd9lQQeNeh1A3m7uQqbF1u58SVU/Ita
 Xjwg==
X-Gm-Message-State: AOAM533NmN4AUKvvNQmQnGEAnpf27Bq/gwsBT/0dZ++LqCQjO4OkCHnf
 O10IkKGKjuxum1sPPgiW38zbnVDy67WAqysdNg==
X-Google-Smtp-Source: ABdhPJwm3DMofZADMi9xGwcDOf9Zq74NL25LFZfh2hKVbdqy841M5MGduVxTgmAxzSIj+ImiNKFEMLH2qOpj21/HEg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by
 2002:a17:90a:858b:b0:1c6:5bc8:781a with
 SMTP id m11-20020a17090a858b00b001c65bc8781amr220213pjn.0.1647478598524; Wed,
 16 Mar 2022 17:56:38 -0700 (PDT)
Date: Thu, 17 Mar 2022 00:56:28 +0000
Message-Id: <20220317005630.3666572-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v1 0/2] Add arm64 vcpu exit reasons and tracepoint
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>, 
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 David Matlack <dmatlack@google.com>, Sean Christopherson <seanjc@google.com>, 
 Oliver Upton <oupton@google.com>, Reiji Watanabe <reijiw@google.com>, 
 Ricardo Koller <ricarkol@google.com>,
 Raghavendra Rao Ananta <rananta@google.com>
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

This patch adds a field in arm64 arch vcpu structure to save the last exit
reason, which could be poked by the hook provided by the tracepoint.
A previous solution adding vcpu exits stats was discussed here:
https://lore.kernel.org/all/20210922010851.2312845-3-jingzhangos@google.com.
As Marc suggested, a tracepoint is preferred for those heavy arm64 vcpu exit
reason stats.

Jing Zhang (2):
  KVM: arm64: Add arch specific exit reasons
  KVM: arm64: Add debug tracepoint for vcpu exits

 arch/arm64/include/asm/kvm_emulate.h |  5 +++
 arch/arm64/include/asm/kvm_host.h    | 36 ++++++++++++++++
 arch/arm64/kvm/arm.c                 |  2 +
 arch/arm64/kvm/handle_exit.c         | 62 +++++++++++++++++++++++++---
 arch/arm64/kvm/mmu.c                 |  4 ++
 arch/arm64/kvm/sys_regs.c            |  6 +++
 arch/arm64/kvm/trace_arm.h           |  8 ++++
 7 files changed, 118 insertions(+), 5 deletions(-)


base-commit: 9872e6bc08d6ef6de79717ff6bbff0f297c134ef
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
