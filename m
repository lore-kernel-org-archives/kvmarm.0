Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30446C04AA5
	for <kvmarm@archiver.kernel.org>; Thu, 25 Aug 2022 05:09:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BD4C4E2BB;
	Thu, 25 Aug 2022 01:09:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cfhsgLJim4A3; Thu, 25 Aug 2022 01:09:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BB724E2BF;
	Thu, 25 Aug 2022 01:09:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E99D4E2BB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:09:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PhQxcjUyjglm for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Aug 2022 01:09:07 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 581F34E2BA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Aug 2022 01:09:07 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-33dbe61eed8so7037947b3.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Aug 2022 22:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
 bh=A7tujPj3gCcslYboIVJEpUnfbTygKXV5SjxwsoVRgPU=;
 b=RA1O0inPqFeLIGQY94aBQVZ8guQpSivAkXorCz90PUXbN9cTieKHfJ1TDbwOg/8TB0
 eP/znMpGKvABSMGtpONSl7cKa3FFjJ5Yns3lEND+didHb0J58sOo35iln4zklcV7iMmA
 KJ36X/BPnhE1PXM0ySnr81ivez7ZW3k/8tJ/5EBFE6tpvVgM5UvRZPBpsFtMT+JDwDP4
 pLDKQNtuNcJGBPrG4f+lV4mlOEv4I26SP+aP7NKGLZ71I/PI/rxuOwju1KeCJy6dlKCN
 5a5g2uSvPR7tID72BJvRohdWoQScMpHW8XTHUNMEjtmnRAy+MbrLA5hI/cIlNA2j7qeY
 a2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
 :from:to:cc;
 bh=A7tujPj3gCcslYboIVJEpUnfbTygKXV5SjxwsoVRgPU=;
 b=5Fdi0EkrH2W9gmkBEsQZp2/MXrfsrk+nFVD1q+ux8fsYz3PBaMoYVSSK4hw6RW9Gof
 oA5LcTolYOdIUTz8Tcfn/zGDmlDyxgjTjyzg7zmswHtxJ6HboeBJkpBLFBWq/jbcSK0h
 IqHgISHMl5UStf52WGb2G1gwOrManlNK+nc7W0FSNXWAE5NA53ksu6Ltt2ceCXuSbZ2a
 ixikQ7txJr+qYuMKFsmU30DiUFwW4AaSTdoZaTebfbw3y7PTzhYe3JwxskOpb+xjY0jD
 BRwB/w1xPjFGkrEKXkgPlKSYpQjiVkSjplzzlX45AGEjChjb5IbRC2OGgRhMS3bOGNq+
 i/9Q==
X-Gm-Message-State: ACgBeo1iVYUKSTLqzIYJyJi7AeQE/gAO3YaOVxN+pny4xhpfTZSV2a/+
 Oo1DYFZ+4FVjAzD/0lDHvauRpidpLuo=
X-Google-Smtp-Source: AA6agR6mA/YLJIHg107zS6XG+THNR8WdRCDmQxkfaR1R/eAzKUfb6FtOdr5p90shIKZNaqWdlGvutxoDXpk=
X-Received: from reijiw-west4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a25:aa81:0:b0:695:88e0:caa1 with SMTP id
 t1-20020a25aa81000000b0069588e0caa1mr1924184ybi.448.1661404146792; Wed, 24
 Aug 2022 22:09:06 -0700 (PDT)
Date: Wed, 24 Aug 2022 22:08:37 -0700
Message-Id: <20220825050846.3418868-1-reijiw@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH 0/9] KVM: arm64: selftests: Test linked {break,watch}points
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

Reiji Watanabe (9):
  KVM: arm64: selftests: Add helpers to extract a field of an ID
    register
  KVM: arm64: selftests: Add write_dbg{b,w}{c,v}r helpers in
    debug-exceptions
  KVM: arm64: selftests: Remove the hard-coded {b,w}pn#0 from
    debug-exceptions
  KVM: arm64: selftests: Add helpers to enable debug exceptions
  KVM: arm64: selftests: Have debug_version() use cpuid_get_ufield()
    helper
  KVM: arm64: selftests: Change debug_version() to take ID_AA64DFR0_EL1
  KVM: arm64: selftests: Add a test case for a linked breakpoint
  KVM: arm64: selftests: Add a test case for a linked watchpoint
  KVM: arm64: selftests: Test with every breakpoint/watchpoint

 .../selftests/kvm/aarch64/debug-exceptions.c  | 281 +++++++++++++++---
 .../selftests/kvm/include/aarch64/processor.h |   2 +
 .../selftests/kvm/lib/aarch64/processor.c     |  15 +
 3 files changed, 262 insertions(+), 36 deletions(-)


base-commit: 1c23f9e627a7b412978b4e852793c5e3c3efc555
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
