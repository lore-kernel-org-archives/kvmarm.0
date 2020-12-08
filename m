Return-Path: <SRS0=0wdR=FM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA81C4361B
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4843123A69
	for <kvmarm@archiver.kernel.org>; Tue,  8 Dec 2020 14:25:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4843123A69
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B1FB4B279;
	Tue,  8 Dec 2020 09:25:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4tyv0ZfYrkw9; Tue,  8 Dec 2020 09:25:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9589F4B265;
	Tue,  8 Dec 2020 09:25:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 723B14B263
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bzbuItuG0STN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2020 09:25:00 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6B1BE4B232
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2020 09:25:00 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id y17so6997564wrr.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2020 06:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=bkCxpWePsFfevlDcUEyEPGxcsnjzxasA1OIQEvsNU/o=;
 b=UH8R3RfyY4sPynLquFWkpqy2WTWXSSzIuSAp+rSQhizic1tnp9KlTS7Y7efZGAqAMw
 MuWmN0VcSOE7Y1ATcEcSGkT9NY58W2weDYlFHdCmmJ+OvSiaDfwuiKRe3Gt4FFvbiP64
 4azh0WSYbt0mS/zs2fxByv6me6YjHQQj4xGUXsYsFovPpv6vD+gk1npQf9zndpaXWfnx
 1TmuF62lTL29fBChAox+JnPUBpEgrxEK6x4ocItr0OEy88xJz+tpcpolNsKsxYkdFY3u
 w+oVXT2DBgxcBjpOIk2J4+Gj7R721q8NZdsa5uC9Q61VagBrwHxgA+J86j3TUZNUQPG8
 4FaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=bkCxpWePsFfevlDcUEyEPGxcsnjzxasA1OIQEvsNU/o=;
 b=kAS16+I8wM4iXLIEnTQjVvkXpfVcdzF9s6KEuLZcMOKx7dcKedXRLpUTshL0HgHT/U
 hv8kTqOunn35MVp8mzE2bmu+shJjgNqqzuufikHW+gthkdwbtAXPn0qCCDNyxo3VMq0g
 gdtvputWoWtlMHTJ2ic+ohEifP170y/JNqbZBIeVIwdFAh7Oz6ge4zAYowhvSqWfV1v4
 OqlGgEMUlsIjs+ZUVuK4ivv8ARNd5yqI0s7McqChFDyQn19dKxQ/XXaMpo3DC1nAfz0v
 rdEtJ/L+9znrA+G0+L2epVkZQmy+8TXkHORfgtbAN4WuSDFhpDbQTqYiECGWw9JLbavm
 aRow==
X-Gm-Message-State: AOAM530Pbz3oXCecpj905y8yryTAKVANTkTrAmCzrt9vylnPxeCsu2pD
 vM8+HBfdQamrJZJtwLH7zqQXYTUW5KSczQ==
X-Google-Smtp-Source: ABdhPJwsb7RVuNDV5tHluPT3itlJhGZvi8mvDtVcsmCOFtJE87agLeOo3053LrTTOxV3LtILOYbdww==
X-Received: by 2002:a5d:6ccb:: with SMTP id c11mr7906522wrc.224.1607437498694; 
 Tue, 08 Dec 2020 06:24:58 -0800 (PST)
Received: from localhost ([2a01:4b00:8523:2d03:258e:cb26:cef:a620])
 by smtp.gmail.com with ESMTPSA id w10sm20739956wra.34.2020.12.08.06.24.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 08 Dec 2020 06:24:57 -0800 (PST)
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/6] Fixes and cleanups of PSCI relay for kvmarm/next
Date: Tue,  8 Dec 2020 14:24:46 +0000
Message-Id: <20201208142452.87237-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

Small batch of improvements for the 'Opt-in always-on nVHE hypervisor'
series, now merged in kvmarm/next.

Patch #1 fixes potential use of invalid v0.1 functions IDs reported
by Mark Rutland, patch #2 fixes a warning reported by Qian Cai.
Patch #3 avoids a code path not used in VHE, can be dropped if any
concerns arise. The remaining patches are minor cleanups from review.

-David

David Brazdil (6):
  kvm: arm64: Prevent use of invalid PSCI v0.1 function IDs
  kvm: arm64: Use lm_alias in nVHE-only VA conversion
  kvm: arm64: Skip computing hyp VA layout for VHE
  kvm: arm64: Minor cleanup of hyp variables used in host
  kvm: arm64: Remove unused includes in psci-relay.c
  kvm: arm64: Move skip_host_instruction to adjust_pc.h

 arch/arm64/include/asm/kvm_host.h          | 26 ++++++++++
 arch/arm64/kernel/smp.c                    |  2 +-
 arch/arm64/kvm/arm.c                       | 18 ++++---
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h |  9 ++++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c         | 12 +----
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c          |  6 +--
 arch/arm64/kvm/hyp/nvhe/psci-relay.c       | 56 +++++++++++++++-------
 arch/arm64/kvm/va_layout.c                 |  7 ++-
 8 files changed, 95 insertions(+), 41 deletions(-)

--
2.29.2.576.ga3fc446d84-goog
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
