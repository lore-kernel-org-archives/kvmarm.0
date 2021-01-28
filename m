Return-Path: <SRS0=rJEk=G7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 254BCC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 10:47:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6600764DD8
	for <kvmarm@archiver.kernel.org>; Thu, 28 Jan 2021 10:47:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6600764DD8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BC234B1F2;
	Thu, 28 Jan 2021 05:47:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F8zd1RiDhZLH; Thu, 28 Jan 2021 05:47:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 979944B1A6;
	Thu, 28 Jan 2021 05:47:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D700C4B1F9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 01:05:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tX7ocICHxgTk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Jan 2021 01:05:28 -0500 (EST)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BE2324B1DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Jan 2021 01:05:28 -0500 (EST)
Received: by mail-pf1-f169.google.com with SMTP id u67so3328246pfb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 22:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Il8qZNLJiUnVs1yENR7U+/PHj95Y8fthqxWVAqkzlPM=;
 b=FOBAuUwtS7jVTeXxIChL9bNsz+Er77qc8WeJTUw3A9nq5VmzNwUAKBriJKft/2FquC
 lZ1AHyh5KOkJj9MCdwK+uRaOkDxeiWtZsQ5uhyci9WKjrgU878iPVblmqSfMotl3qqsZ
 AadDpgG2cJ01V8kMSBtXZ7XoVEWtzV5RpOGlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Il8qZNLJiUnVs1yENR7U+/PHj95Y8fthqxWVAqkzlPM=;
 b=f9I5lRdTyJ04A5Ze+6gLqQNlq4FIsJOqW9hL+cGaxBTz5kplac7hblqjndMP7M6y+N
 XejmCUEnhPks//HXVoopqhZFH/LuIwpgp32jsuc240DfrOr3H/6OuQRSKG65lnpSCdNa
 WDDZgrwRw+CL+n26N/hdpGNZwVGiP65KUEQDYb15ncW+uSBYAkWIBSFpMGQgkuP0WM6L
 z90Hz4Q8RzWsSeWpCYUpE7wcTDZKrUZolPaEklliPSC0XQt6nNn7z42XXHL01RVLTuw2
 ZQ6I/wn588GI5Vctr8R2zTnKeMMJ2Prdd+3tp/AJ1QfAFiDpNnRuAjba1fDmCs/ZFwyZ
 dbXw==
X-Gm-Message-State: AOAM531VHoKQHTlp6G+eVZzk7Sza+x6VumLaVl98/uEVVdsjmD6QGF2K
 2N3aWJLT8Zd5ZtsLrbVbdjDDiw==
X-Google-Smtp-Source: ABdhPJxidwWhR7mlBTuFlylUNvopLRyxeu+Iq8ZjCqlH84G6RemXi1bI0gdxZW+QAPoQaFarpqDzPg==
X-Received: by 2002:a62:1690:0:b029:1c6:fdac:3438 with SMTP id
 138-20020a6216900000b02901c6fdac3438mr6879262pfw.43.1611813927818; 
 Wed, 27 Jan 2021 22:05:27 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:919f:d6:7815:52bc])
 by smtp.gmail.com with ESMTPSA id z6sm4345903pfr.133.2021.01.27.22.05.23
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 27 Jan 2021 22:05:27 -0800 (PST)
From: David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To: Sean Christopherson <seanjc@google.com>
Subject: [PATCH v3 0/2] KVM: x86/mmu: Skip mmu_notifier changes when possible
Date: Thu, 28 Jan 2021 15:05:13 +0900
Message-Id: <20210128060515.1732758-1-stevensd@google.com>
X-Mailer: git-send-email 2.30.0.280.ga3ce27912f-goog
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 28 Jan 2021 05:47:29 -0500
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, David Stevens <stevensd@google.com>,
 linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

These patches reduce how often mmu_notifier updates block guest page
faults. The primary benefit of this is the reduction in the likelihood
of extreme latency when handling a page fault due to another thread
having been preempted while modifying host virtual addresses.

v2 -> v3:
 - Added patch to skip check for MMIO page faults
 - Style changes

David Stevens (1):
  KVM: x86/mmu: Consider the hva in mmu_notifier retry

Sean Christopherson (1):
  KVM: x86/mmu: Skip mmu_notifier check when handling MMIO page fault

 arch/powerpc/kvm/book3s_64_mmu_hv.c    |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  2 +-
 arch/x86/kvm/mmu/mmu.c                 | 16 ++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h         |  7 ++++---
 include/linux/kvm_host.h               | 25 +++++++++++++++++++++-
 virt/kvm/kvm_main.c                    | 29 ++++++++++++++++++++++----
 6 files changed, 65 insertions(+), 16 deletions(-)

-- 
2.30.0.280.ga3ce27912f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
