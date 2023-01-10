Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67AC615A7
	for <kvmarm@lists.linux.dev>; Tue, 10 Jan 2023 02:24:36 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 11-20020a25050b000000b007b7968a6423so11209422ybf.13
        for <kvmarm@lists.linux.dev>; Mon, 09 Jan 2023 18:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CKD1lmtKDuCBjqGCBiuqowGuY1aodNaM6un/5m3rvw0=;
        b=PYHzJbjYM/+zeNJLwMOqmkGGfyVWRdJFsEjhkrm95k2wVXABDR1sIxWjpgcgMoxQ2b
         TloUdM7n+qSiYD2dHf+fBb0bEwLw70uTchbXKPr2BQdVda4kak9T0agBUTIJLP//g3z4
         xmVEC5A8WEEUEaZuGS5zQL8BHKO4gmGIfPMPdD7+TczGA16ohRt0xgTphpO1wWIU1pdU
         tKhIYtKYEjop47MqkVXkH1mOUTJ21Ee1YpbjJr0E6ed3OFKep3GtGc+CCbvKLKfA/P5o
         IZwg01t9gdetH43ANwU05JvrIPkkcXYLPJDYHSvYug7AbEEgOTI5JE/j4skBh863HXjZ
         mSoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CKD1lmtKDuCBjqGCBiuqowGuY1aodNaM6un/5m3rvw0=;
        b=oIFR7BM05rLMKd5SMRCzkZ6Lw3R25MvxZJVCC4INP0fLWItRHqBS8G0nQ2dz5nub0P
         iF0Aq+kgdIA2UE8e/QYk9Mi0ys1QE6hevusEpnXEEvydUI7cveG9k3fj9xxQ+5hRfrlN
         zdFcFCsWb1eqP4es2J5Bi8Hj3eOQf+DjWGEWrurdEGWwdiosrSYYHrRlXFMaAho4qWTn
         rgOumQ/gIjUr0ByOPwA9k9dKnNGjS9bOUCC/Nz9S67XQdB9GXgdc37D2Z6Ry4yUkttuO
         37XVQmVSf1JHBDP5RFaidBco4jVbYY/Z2FfZhFk8i6Mj+o4N+nPk689irbcyupHXB4Rk
         D50Q==
X-Gm-Message-State: AFqh2kpOm+pJpWDIQCEl9kl/dKQ/ClrJAQ4KF5nV8V3uTXGAKCxNFJ1l
	N3wEu4tz3w3SFtr+BB11J0g5Cm2NPV10jg==
X-Google-Smtp-Source: AMrXdXvsa7bTcCa7+KYaI3L5lEV5PsjGF7et8ZP4rdGklbY/kQWwGma8AuaNkeWmSGe8z08sj+8v0XrsskBvbQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:746:0:b0:6f1:4590:92b9 with SMTP id
 67-20020a250746000000b006f1459092b9mr6892803ybh.430.1673317475240; Mon, 09
 Jan 2023 18:24:35 -0800 (PST)
Date: Tue, 10 Jan 2023 02:24:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230110022432.330151-1-ricarkol@google.com>
Subject: [PATCH 0/4] KVM: selftests: aarch64: page_fault_test S1PTW related fixes
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, oupton@google.com, yuzenghui@huawei.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Commit "KVM: arm64: Fix S1PTW handling on RO memslots" changed the way
S1PTW faults were handled by KVM.  Before this fix, KVM treated any fault
due to any S1PTW as a write, even S1PTW that didn't update the PTE.  Some
tests in page_fault_test mistakenly check for this KVM behavior and are
currently failing.  For example, there's a dirty log test that asserts that
a S1PTW without AF or DA results in the PTE page getting dirty.

The first commit fixes the userfaultfd check by relaxing all read vs. write
checks.  The second commit fixes the dirtylog tests by only asserting dirty
bits when the AF bit is set.  The third commit fixes an issue found after
fixing the previous two: the dirty log test was checking for the first page
in the PT region.  Finally, commit "KVM: arm64: Fix S1PTW handling on RO
memslots" allows for having readonly memslots holding page tables, so
commit 4 add tests for it.

Ricardo Koller (4):
  KVM: selftests: aarch64: Relax userfaultfd read vs. write checks
  KVM: selftests: aarch64: Do not default to dirty PTE pages on all
    S1PTWs
  KVM: selftests: aarch64: Fix check of dirty log PT write
  KVM: selftests: aarch64: Test read-only PT memory regions

 .../selftests/kvm/aarch64/page_fault_test.c   | 183 ++++++++++--------
 1 file changed, 101 insertions(+), 82 deletions(-)

-- 
2.39.0.314.g84b9a713c41-goog

