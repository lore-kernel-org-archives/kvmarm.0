Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DBCC433F5
	for <kvmarm@archiver.kernel.org>; Fri, 10 Dec 2021 16:58:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D96A64B1C1;
	Fri, 10 Dec 2021 11:58:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xHGFoD5-GFMZ; Fri, 10 Dec 2021 11:58:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8071F4B1AA;
	Fri, 10 Dec 2021 11:58:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 767104B126
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 11:58:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c1jVOM5Cl4zK for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Dec 2021 11:58:09 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 188D64B11F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 11:58:09 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 b11-20020a17090acc0b00b001a9179dc89fso8563322pju.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 08:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=fSK6uHWpIJtKlImgMjXDQsAlhLi/T4fDrdTrYPdabAk=;
 b=gmoRl0JH3HLkq9IL2jXGgIdQqdHGIeAGwBt+zx0S/xteTkOC1hfbnn6ff+JIlgbAoh
 O/I593FGaV5VSWeswt0lLn1YRwvhjnN43y/RHE+tbBtrFXzzi5cJ16TZ5+QmPqljIxcV
 dCwF7OoROFOL1Q4z/AuWHgxdeGMWyf/T7lngi1HjEaItOXrqxN7s9acLAyqlxEP/f9eI
 QRlzC5VrcypA/suqvn+whHN0KndQHjAWpveakO+R0IsNDsADFbfqtH5nPfqLdRiRbW73
 LR45QEm3Oazr60IaY0Jm6a/Hu+aYvMDQjtC/ixdkWIV8pLtqt1u+rioUqHt0gpgiAlED
 2SKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=fSK6uHWpIJtKlImgMjXDQsAlhLi/T4fDrdTrYPdabAk=;
 b=CC1/W//mOPmUBM6fob2bicE+hMbCjT3MwR97LxqN72ubXT81N3RT5Yjb0QgwDdtr+u
 pN/LbNtskfuX6F7czNTbyq4vizzedS5eShm1e0HQan0YmI0sGbCxWbvYUBc9oGcNf804
 eP5gHDKLyAYOJ8sHt2ediVc+DxWY2PjW3+hDJNMx+c0z1+sSw1U1Vc5xM8SIEXAmaolS
 oiPbEUWDPguRc24TXQ/ZhnCpf6WKFI8Teq7AoBGnqMYF6i5au5TZT3e6EjWQEA9xQW1a
 Jg38Us6nADbS2FDe079srrnWAMuYmLBeUdB9lMBSU74VDLqmWK8gyHT1ieldikhfILoS
 9opQ==
X-Gm-Message-State: AOAM530zsZscZhimgL8gJR7zKQLocnrvqgIy/GzLs6/PZrCG2d+oeTNi
 Pyp+QRNq8Y+jjOhFO0BITIiuIOo8dG86sg==
X-Google-Smtp-Source: ABdhPJw9a4fTHT/klzsxj+qfZk9tqXdFz3Y92zbP0NFlSiAPFcP7FkkuxV6XyfkLNiDuI4EvRD6YfEfxyb/mow==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a63:6342:: with SMTP id
 x63mr40205115pgb.295.1639155487878; Fri, 10 Dec 2021 08:58:07 -0800 (PST)
Date: Fri, 10 Dec 2021 08:58:01 -0800
Message-Id: <20211210165804.1623253-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [kvm-unit-tests PATCH 0/3] arm64: debug: add migration tests for
 debug state
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>
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

Add some tests for checking that we can migrate debug state correctly: setup
some breakpoints/watchpoints/single-stepping, migrate, and then check that we
get the expected exceptions.

The 3 patches in this series add tests for breakpoints, watchpoints, and
single-stepping one patch at a time.  Each patch adds a migration test and a
sanity test (to test that debugging works with no migration).

Note that this is limited to 64-bits and a single vcpu. Also note that some of
the code, like reset_debug_state, is borrowed from kvm selftests.

Ricardo Koller (3):
  arm64: debug: add a migration test for breakpoint state
  arm64: debug: add a migration test for watchpoint state
  arm64: debug: add a migration test for single-step state

 arm/Makefile.arm64 |   1 +
 arm/debug.c        | 420 +++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg  |  37 ++++
 3 files changed, 458 insertions(+)
 create mode 100644 arm/debug.c

-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
