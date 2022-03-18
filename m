Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44F1AC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Mar 2022 19:38:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9909E49ED1;
	Fri, 18 Mar 2022 15:38:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C6lTBDY-1fLq; Fri, 18 Mar 2022 15:38:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8437540C0A;
	Fri, 18 Mar 2022 15:38:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5539249ED4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 15:38:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ac-fShCct8Jx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Mar 2022 15:38:51 -0400 (EDT)
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com
 [209.85.166.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21875405C1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 15:38:51 -0400 (EDT)
Received: by mail-io1-f73.google.com with SMTP id
 e27-20020a056602045b00b00645bd576184so5697397iov.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Mar 2022 12:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=H8l1nRqzc+GH0BYge+CcpqHIz0FnRWt0KDTVYGKXJUU=;
 b=bY3JkUnzKDMAFmYEofE7g0/RUbdybRqH8McyL3QCx/wwKqxP1R9oyMHfVxLU5Rn4au
 FQ01pJ+bKjV63b/BCTyaEsUMyYtRT80x+3wKXVcME/neBa76g27i9HbIvWdUltAeJHcy
 JCCC8QEiBVS0FlkELwjk1JW6HbLmmjbCn8gjott5uKeZYtMyOpS4gbqEQ9OHhjb1RMDG
 v9D3fEDlSHu0jaYcfOcoEHaZs/YaN6yiFk21fcmdpWc4tqQMHlb0VVEr9ERPjBnN7Pxh
 gv6Wr+muHYlEezdujn0d4ObZu+RHGGZAOpm7c8GEGOmAA+JbioAndNxPLUuDwMUFCuEe
 SzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=H8l1nRqzc+GH0BYge+CcpqHIz0FnRWt0KDTVYGKXJUU=;
 b=oJhSDgAwYhECoeg/laYcAlHpBVz6i+h0tZ+oXcvubnK9bHvixPAUCHAQZrloRLsrD5
 avBHlsECiP9qxiuTI03InIctkFE0xtJFSLb1iEcSTUUnzoohir5RAtDGqDa8AumK6AvE
 8H6umRSd6e2iwngcz3zb6ak4KLWYNGbWteOccgfARXBF6Rhs+Cf5NY4jjlHtkbCH5DKD
 k5SHahykP1Xj0H2nK0bDLLKxpRFj/FRNHZtjgTXI810AFVMEpeg5qtUCCm4HTLLAuHK0
 lNKve+0Sz1ENfDDN5WkyifJBa8jYyd0DlTTxc8D1eXXRDE6PKI9gGOeH6VitI7TStQ0C
 RTqg==
X-Gm-Message-State: AOAM533ZuyfpLaEVOL4VzImPBuMUShwk56l8tfO6K9we89N5juPz2N9i
 NXJK8T3y2A3mUdY0nKdfBVfFBwFB/k1feO/X6UexwacnK8yf85jY2t/3CAUXpJWnJiesyW8OeF5
 h1+5ZrB1e2yc25yl6Psp8/gfnVx1mJRlIXZNLvJSHrHcHlVqdE8/rjwlWGsYtbGRfLPfWfg==
X-Google-Smtp-Source: ABdhPJyFMO/w4ywussCXIJDpEfAaloVYed9xixsAdo9QBRfZRiXxwrIxNYxqhyOTk46we5JCHvMjyNz5a4k=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:ca08:0:b0:2c7:f1c6:3377 with
 SMTP id
 j8-20020a92ca08000000b002c7f1c63377mr3395684ils.28.1647632330197; Fri, 18 Mar
 2022 12:38:50 -0700 (PDT)
Date: Fri, 18 Mar 2022 19:38:29 +0000
Message-Id: <20220318193831.482349-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH 0/2] KVM: arm64: Fixes for SMC64 SYSTEM_RESET2 calls
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

My first crack at this [1] was missing the fix for direct calls to
SYSTEM_RESET2. Taking the patch out of that series and sending
separately.

Applies on top of today's kvmarm pull, commit:

  21ea45784275 ("KVM: arm64: fix typos in comments")

[1]: https://patchwork.kernel.org/project/kvm/patch/20220311174001.605719-3-oupton@google.com/

Oliver Upton (2):
  KVM: arm64: Generally disallow SMC64 for AArch32 guests
  KVM: arm64: Actually prevent SMC64 SYSTEM_RESET2 from AArch32

 arch/arm64/kvm/psci.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

-- 
2.35.1.894.gb6a874cedc-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
