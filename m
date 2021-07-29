Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8762DC432BE
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 19:56:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F022560F46
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 19:56:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F022560F46
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 680AA4B0D2;
	Thu, 29 Jul 2021 15:56:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IQnerxvm44q4; Thu, 29 Jul 2021 15:56:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F2B64B0C5;
	Thu, 29 Jul 2021 15:56:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FCBF4B0B2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 15:56:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zczuASTQpgpk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 15:56:43 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7212F40287
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 15:56:43 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 w10-20020a0cfc4a0000b0290335dd22451dso2368097qvp.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 12:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=AybauKNFPo3SsUjhjkW3rvaT9nCugcHZc2DTga5rD+Y=;
 b=pDjWXDMBoqce2Uo3OFtJqZEiF7+0tG6fbwCkYp/QACm55I5LeZi6KGbTuMrSoe1cpk
 cKB3vxAThRuWvsRaBsGqDa70j0yjXUL+jIyrVksRTaHkqWIM7fjB12MJIG2DFRppBsET
 OS+SgpYNdabohr+fskGck9XrjK1I9TB5SGCPbSFDRFCvXaVN/wK3x+926RV2yAWtXm92
 2RLXmBhRr2WiNQi5NX86D6YFvwO+mh5X+GudOeiT1cU81ScCAw9pXLpWtAYUlsvlEwny
 7LTUROpCB9f6RyfBw38ElnczcBXFnU+VcCD28lRKwo+UoPXYplSCMMbxGekOT21/omPJ
 aMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=AybauKNFPo3SsUjhjkW3rvaT9nCugcHZc2DTga5rD+Y=;
 b=Ko2a2fuPyRMl3koRoZxlrJFUrwrWNqs0cgHuUhJ8N2REXRb1V3sYnuWpj5X3Ficj0Y
 lCGINJGVSDqC9eRwIogbxNspQ8jPUWkFE1+i4DjpfO1cMEJcbZ1B9YwtOXTPthpMahNW
 h+THO2BgilbWPttv2vc1Rlx02nKKiLx0XdZhv7utYQy2aQs3yQU1A8p3Zzp6IDWPdwiQ
 qgiFTbTVpv/rzB9LLIzJChAQOAJKP0Ctk5Y1iHqfss91e9AfVoH8n1SX0AF00ZmZ8oAn
 emOlmmBeZBGwWlekiXfPFFXNpeTw5it7kUqioezixP63KmiKMH5j0L08BMt1d33qi8FC
 UlGg==
X-Gm-Message-State: AOAM533KAZ84YDW9wQ6iBFuLWqp7Wtf7Rsq4k9csh+g7CQ4WmcRpEgl4
 s4dzrR8i0SqiPDbUAqwJz7XLSs+04dZGGd55/Vf9NKZC+F4ZXnEc1LSElILRPebhd+1/kqdp8Vu
 3QYWpMnDkXqW/FXkw1Bobeou5wk543UC90GsoZGdrcXZqcPZ5ZEpW16A6c321EW4/N7MiKQ==
X-Google-Smtp-Source: ABdhPJwU8WQNmo1zhH1aQzP5f0AXaA7UbdvB2nIHEOEw8XVOvuCKD7pK9ur3hioyHd+oC0Rya2glIwWuYlI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:ad4:5c49:: with SMTP id
 a9mr6517273qva.27.1627588602907; 
 Thu, 29 Jul 2021 12:56:42 -0700 (PDT)
Date: Thu, 29 Jul 2021 19:56:29 +0000
Message-Id: <20210729195632.489978-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 0/3] KVM: arm64: Use generic guest entry infrastructure
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Shakeel Butt <shakeelb@google.com>, kvm@vger.kernel.org,
 Peter Zijlstra <peterz@infradead.org>, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Guangyu Shi <guangyus@google.com>, Will Deacon <will@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel@lists.infradead.org
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

The arm64 kernel doesn't yet support the full generic entry
infrastructure. That being said, KVM/arm64 doesn't properly handle
TIF_NOTIFY_RESUME and could pick this up by switching to the generic
guest entry infrasturture.

Patch 1 adds a missing vCPU stat to ARM64 to record the number of signal
exits to userspace.

Patch 2 unhitches entry-kvm from entry-generic, as ARM64 doesn't
currently support the generic infrastructure.

Patch 3 replaces the open-coded entry handling with the generic xfer
function.

This series was tested on an Ampere Mt. Jade reference system. The
series cleanly applies to kvm/queue (note that this is deliberate as the
generic kvm stats patches have not yet propagated to kvm-arm/queue) at
the following commit:

8ad5e63649ff ("KVM: Don't take mmu_lock for range invalidation unless necessary")

Oliver Upton (3):
  KVM: arm64: Record number of signal exits as a vCPU stat
  entry: KVM: Allow use of generic KVM entry w/o full generic support
  KVM: arm64: Use generic KVM xfer to guest work function

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/Kconfig            |  1 +
 arch/arm64/kvm/arm.c              | 26 ++++++++++++++------------
 arch/arm64/kvm/guest.c            |  3 ++-
 include/linux/entry-kvm.h         |  6 +++++-
 5 files changed, 23 insertions(+), 14 deletions(-)

-- 
2.32.0.554.ge1b32706d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
