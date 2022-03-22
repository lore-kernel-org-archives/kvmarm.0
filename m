Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 760D6C4332F
	for <kvmarm@archiver.kernel.org>; Tue, 22 Mar 2022 18:35:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C46BE49F40;
	Tue, 22 Mar 2022 14:35:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ghd4JpPlCT-B; Tue, 22 Mar 2022 14:35:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 697CD49F19;
	Tue, 22 Mar 2022 14:35:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B22A049E1E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:35:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 957MUlte0b00 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Mar 2022 14:35:44 -0400 (EDT)
Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com
 [209.85.167.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99366405AA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 14:35:44 -0400 (EDT)
Received: by mail-oi1-f201.google.com with SMTP id
 w185-20020aca30c2000000b002ecce746c73so11394431oiw.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Mar 2022 11:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=5SgsMWfo3s1L8LtQzUYqsFC2nGQvlmxjA5TrVXlNF5o=;
 b=NX/BKlXFUX08TaXDOkYcmlRKl5vaPl5VlRDyAV1k+AuDKOzI1MZXJ5+22dygCqBHx0
 cndVmYMiBZ8nmrVLXS7wr6r6xMVjqUptm/oFwkxO8iNVzx+jkh9rRiaya/P07+3MpJ04
 PJViSnNZvSINYM+HXpkl74vp6GVfLa5lg8R/MzRO2JEF9yr9GzaPdDsd1M4R7DOnsPnL
 GY4FOgGYGPB1d8cgw93lNLO7qXMe/gl/08vQDPIOX1VpM1MxuhjQ7CPtWAeOg9CIuqab
 h8WEqyqK+VHesnwGBityrclGfO6IJCwPfj6gqm7TZCeFBV2aliXaT2f3+d6CEFOzHXMT
 ycVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=5SgsMWfo3s1L8LtQzUYqsFC2nGQvlmxjA5TrVXlNF5o=;
 b=Suc9eXRegSWPt1QK85d5bAVttGRscGVlCsPUrKoOyAC+mkV6k3Cjhc4qQxv5aFTXo8
 LQ0iYTwmmaxFYylw1z0fMu9COsKUQ+hnFnwkEFyJ5Aldz8LKfefopKNLFIGHGNhF2aBC
 yAmLM4pBBv4sppZAFU3rHyaN8UWCrtqmaM/KgvnE7K+UqLK5oWO9+kieGZWaBKtrubPy
 Q6vJ4J5STcpcuHMDoeDkTQ8I9uOEP78YJs/1ESX7i9sBT4vZ5JDSpfC7Glrhtiq2HZwf
 QfzGIXNwnAZq0oGgNrKASDebaIj6nOwpBGGqoGFWQAzEeKCTuUHsMurTCwXvRSPSjPP3
 n2fA==
X-Gm-Message-State: AOAM530jKbaXmCxX6kRvwNHAbZXYoiFRNwUhjLNYa+2xTYCEQS64y4e1
 RJqXhF+ujbQqzBbvw18H939g52kqH2ChgASS/OZugMiwn4O7XAcAhZGx+L0cHHyZh/SoZfK6Raw
 cftL239ZPxwB+Kymm5xwqn7LqFqiLIYDyk8enlMjbXZCCzpkWNdfWTINtx1Mi9R0aGgrZ0w==
X-Google-Smtp-Source: ABdhPJzHEAq3Ahy4FlfkKxUuOF9jkElOWpjOAJdQhPLkwUNZPQY2dc71XrglzJC9u5kFBcUHDcv+k9hh18A=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6808:1a97:b0:2ec:a246:ad01
 with SMTP id
 bm23-20020a0568081a9700b002eca246ad01mr2796378oib.54.1647974143817; Tue, 22
 Mar 2022 11:35:43 -0700 (PDT)
Date: Tue, 22 Mar 2022 18:35:35 +0000
Message-Id: <20220322183538.2757758-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 0/3] KVM: arm64: Fixes for SMC64 SYSTEM_RESET2 calls
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org
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

This series addresses a couple of issues with how KVM exposes SMC64
calls to its guest. It is currently possible for an AArch32 guest to
discover the SMC64 SYSTEM_RESET2 function (via
PSCI_1_0_FN_PSCI_FEATURES) and even make a call to it. SMCCC does not
allow for 64 bit calls to be made from a 32 bit state.

Patch 1 cleans up the way we filter SMC64 calls in PSCI. Using a switch
with case statements for each possibly-filtered function is asking for
trouble. Instead, pivot off of the bit that indicates the desired
calling convention. This plugs the PSCI_FEATURES hole for SYSTEM_RESET2.

Patch 2 adds a check to the PSCI v1.x call handler in KVM, bailing out
early if the guest is not allowed to use a particular function. This
closes the door on calls to 64-bit SYSTEM_RESET2 from AArch32.

Lastly, patch 3 is a nit to remove a superfluous check in the hopes of
avoiding trouble the next time we raise KVM's PSCI version.

Applies on top of kvmarm/next at commit:

  21ea45784275 ("KVM: arm64: fix typos in comments")

v1: http://lore.kernel.org/r/20220318193831.482349-1-oupton@google.com

v1 -> v2:
 - Collect Acks and Reviews (Reiji, Will)
 - Hoist SMC64 filtering all the way up to kvm_psci_call() (Reiji)

Oliver Upton (3):
  KVM: arm64: Generally disallow SMC64 for AArch32 guests
  KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from AArch32
  KVM: arm64: Drop unneeded minor version check from PSCI v1.x handler

 arch/arm64/kvm/psci.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
