Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C57F6C4332F
	for <kvmarm@archiver.kernel.org>; Thu, 20 Oct 2022 05:42:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F4224B904;
	Thu, 20 Oct 2022 01:42:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q7dPpFl03pdh; Thu, 20 Oct 2022 01:42:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08C8A4B90C;
	Thu, 20 Oct 2022 01:42:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B8A14B908
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:42:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZY90YoROm5wI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Oct 2022 01:42:13 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 640614B904
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Oct 2022 01:42:13 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 y65-20020a25c844000000b006bb773548d5so18141418ybf.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Oct 2022 22:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=F1xEy2N0X8jXyctTALyEQ2NLmUaEeJbt2DbPDEOdM5U=;
 b=qtupEmU2u9RZ171OaNaBBrtCDFPwuHznyd/3vhQPoSFoPHGUbjnNyra7t2LPVYTZUU
 V4GCVvcoV1wvGWYVoohLHP+XiSJnLrNgy/Rzq0n0QLYOnAmESpGTKLnoVAMAJdHuaiID
 gvJuGJKt2/Taj6K3D62Ki5E+CaSOLLcx9KSwmUJ3TtEPuYinkpl1Frj62adRZUgO41BN
 wqE+Ox4SnxtN0qzVPM+ZkU8xrfqWxaPT3jC4KOIczdSpdX2MfYt6Ozz6+X27LykpWWBp
 CW/JOwdvtJANIJYWaljsOW9uZ/pbeE4eDZOyP9QDliMjnNFOfyYpqy6FTsrx6tQooBJu
 LOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=F1xEy2N0X8jXyctTALyEQ2NLmUaEeJbt2DbPDEOdM5U=;
 b=WoQZua7j3feifZHVODU+2ch91rbYfG61O9EIcpAKXsegPLAeaM0go8mSOmFA1nNxSP
 zj800atVPY7mZy+ewK6TX+CAvjtyqR59/LupymLIWAQJGbNfETnSziZMe5VoTHWao4e7
 8JxAvHnmjlwGKl/bOq/4iEiPYEDXgH1MjM081K4JGXwnzmA83zelk8n0Gd/MctCTeiTE
 nE+2d0uBHOHktMhBzE/ksP7qsIKFHm8SV4bw12NMmhfiog8eaPT4vAYID0TK0fh+MLGQ
 pOJc9nIQ3A9X3I3knguKa3kXcB9Ytgu8EYKLrH7pqhRObg+7QcL/YE9fh7jWwkvyIun2
 ao9g==
X-Gm-Message-State: ACrzQf1nnygL15Q5Ya0GOKx3h3VLfcjOORnUbt/R6KLCwfka70gK2AYW
 tcwJCHCbBvpC1GPGxmb6vxNK8bDROzY=
X-Google-Smtp-Source: AMsMyM7ssFcQRUTNFhxmazkE2SsVdFrFjqptAicWealf1kK7A/U7g3JYAWktNfywh02ITvG0hf7hTwi930A=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a81:1c53:0:b0:354:ce32:2d82 with SMTP id
 c80-20020a811c53000000b00354ce322d82mr9755582ywc.249.1666244532954; Wed, 19
 Oct 2022 22:42:12 -0700 (PDT)
Date: Wed, 19 Oct 2022 22:41:53 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221020054202.2119018-1-reijiw@google.com>
Subject: [PATCH v2 0/9] KVM: arm64: selftests: Test linked {break, watch}points
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
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

This series adds test cases for linked {break,watch}points to the
debug-exceptions test, and expands {break,watch}point tests to
use non-zero {break,watch}points (the current test always uses
{break,watch}point#0).

Patches 1-6 add some helpers or do minor refactoring for
preparation of adding test cases in subsequent patches.
Patches 7-8 add test cases for a linked {break,watch}point.
Patch 9 expands {break,watch}point test cases to use non-zero
{break,watch}points.

The series is based on v6.1-rc1 with the patch [1] applied.

v2:
 - Use FIELD_GET() to extract ID register fields (Oliver, Ricardo)
 - Try to make function/variable names more clear (Oliver, Ricardo)
 - Make the context number more unlikely to happen by mistake (Ricardo)
 - Remove unnecessary GUEST_SYNC for test stage tracking
 - Collect Reviewed-bys from Oliver and Ricardo (thanks!)

v1: https://lore.kernel.org/all/20220825050846.3418868-1-reijiw@google.com/

[1] https://lore.kernel.org/all/20221017195834.2295901-6-ricarkol@google.com/

Reiji Watanabe (9):
  KVM: arm64: selftests: Use FIELD_GET() to extract ID register fields
  KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r helpers in
    debug-exceptions
  KVM: arm64: selftests: Remove the hard-coded {b,w}pn#0 from
    debug-exceptions
  KVM: arm64: selftests: Add helpers to enable debug exceptions
  KVM: arm64: selftests: Stop unnecessary test stage tracking of
    debug-exceptions
  KVM: arm64: selftests: Change debug_version() to take ID_AA64DFR0_EL1
  KVM: arm64: selftests: Add a test case for a linked breakpoint
  KVM: arm64: selftests: Add a test case for a linked watchpoint
  KVM: arm64: selftests: Test with every breakpoint/watchpoint

 .../selftests/kvm/aarch64/aarch32_id_regs.c   |   3 +-
 .../selftests/kvm/aarch64/debug-exceptions.c  | 311 ++++++++++++++----
 .../selftests/kvm/lib/aarch64/processor.c     |   7 +-
 3 files changed, 245 insertions(+), 76 deletions(-)


base-commit: 0ecb0791b2af9bde4389d5ee9ee2a64ddf55ea85
-- 
2.38.0.413.g74048e4d9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
