Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C107EC4338F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 22:09:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38A6560FE7
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 22:09:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 38A6560FE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A57BB4B0D3;
	Thu, 29 Jul 2021 18:09:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3zQhQDkhsDZC; Thu, 29 Jul 2021 18:09:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90B3F4B0D7;
	Thu, 29 Jul 2021 18:09:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3ED14B0D2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 18:09:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DoG+BjUaFmqy for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 18:09:26 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA8B34B0B9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 18:09:25 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 j21-20020a25d2150000b029057ac4b4e78fso8180953ybg.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 15:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=Y1FozKgR1OGtch4GBgu/T53ekVcZG3++UIur3cT4k1g=;
 b=KCVCCjvfgPmT2bb35uWb5YZDXm5qgf3gJxeSBmXlrVF1vncKlfaP8Wzzg1bfZi5Nkr
 T8v+aNTulTf6jbCZMm835Z7w86SM4E2eEqKDSBtbNqNvwJqd1ScPCOp0Ppmlru9mdffm
 2PjMw4XxdccM8Am6I5NOcHkW9SIi6d5kd/NOAMDmNU4AT0AtBagT7M03wnlA7CmKb395
 D5Bhao5isUgygnfi8Jw5PgpS4XM74rDfLMjm2dFm0CYi7EcZcLhU7AzADCylciD28fEy
 aVUkLMiMdzIfZcktnJjBcPjav6cUYulnE9PWO19nsbfIJ9H+tszoSYfrdd5VQDoykvdb
 fBBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=Y1FozKgR1OGtch4GBgu/T53ekVcZG3++UIur3cT4k1g=;
 b=LLb5PMRCsH5LwHMTef9cCD5ccT7X5+8ih2vSVv0fPfO6+gf8bMNshC6ybFKl0YlBTi
 dLMZMSc+z/hF4xKlLolAXLI5DuxgCl01HhxEkyttQXMTJay0bQclnauqYICdTpUR2JZ4
 2p6tgX9RyfOPnfDmb3TqWIQ5JAUIPsqudmxFfY6Hiterr1BzSxVX8ws5xKU2loVWifLx
 UcLGjjVvRp4v07FyYLnkDoCRFj+eGc/Vf0pstt8aC1ro/UxjhQWpoHq2UpN2ft4N9+F4
 1sBxDpG9NvSUFY6BALTtmK8OCfy1VmHfvgWrHUAYGaVJJ4JrYJvvHKwwkcLgZZYUWwUd
 2ecA==
X-Gm-Message-State: AOAM532pkeItLTy4XcXy3MAkeT4hUCWmfFtVa0cchfXq31u9xq9ML65N
 4dh1D8LZPWPRLxJe2de1HohMlJjxfrhywEx3Z6bRZBP6GOB7x4DKfNoEdiQxVIyju5yeTlcRBqB
 fyj5gBXSG6AUuwbcoe0A4jsH/fGW3zC20RlWOZS+XqxXIfRSdoDYlAEIeQM22cqoXX8GjnA==
X-Google-Smtp-Source: ABdhPJweYbkW6ntZKyVJeSlR2LDQ77+i9PG1QNakarKHqxX2ZyAz6vYGDXkzuixuoiNM0eHVpr8gTAurhys=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:3503:: with SMTP id
 c3mr7258148yba.316.1627596565260; 
 Thu, 29 Jul 2021 15:09:25 -0700 (PDT)
Date: Thu, 29 Jul 2021 22:09:13 +0000
Message-Id: <20210729220916.1672875-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v2 0/3] KVM: arm64: Use generic guest entry infrastructure
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

v1 -> v2:
 - Address Jing's comment
 - Carry Jing's r-b tag

v1: http://lore.kernel.org/r/20210729195632.489978-1-oupton@google.com

Oliver Upton (3):
  KVM: arm64: Record number of signal exits as a vCPU stat
  entry: KVM: Allow use of generic KVM entry w/o full generic support
  KVM: arm64: Use generic KVM xfer to guest work function

 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/Kconfig            |  1 +
 arch/arm64/kvm/arm.c              | 26 ++++++++++++++------------
 arch/arm64/kvm/guest.c            |  1 +
 include/linux/entry-kvm.h         |  6 +++++-
 5 files changed, 22 insertions(+), 13 deletions(-)

-- 
2.32.0.554.ge1b32706d8-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
