Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5AE290D
	for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 21:43:57 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-434eb7c6fa5so68792197b3.14
        for <kvmarm@lists.linux.dev>; Fri, 27 Jan 2023 13:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=m/RabSljBhZ9UUQSJRI1BylATrQl4vx1wTwVBab6KOg=;
        b=hnYIO1DqcXYmL4VaGlmbSIyGBXMwCCofyp10m1F/jucbrsquWi8yL40rOVZz+GqF3H
         s+MgTBvwSlgCYzu8ZykTISF2X/PuamkdRYBuOBoHqk53eo2AK/6CYD3CDsRvcPmdUdZF
         N+fx6+4UiHhw9sFeCx9WWzStdvDs4jSFXwGfIcDobyuu4WhGgTHS/WFcDGdcSA1zL40s
         xTc86+vu09iirLZzNugpZ+rjXWRqX2sTRBq83eafJyCbK4jL81r4h5KCWJnmIgoXyER6
         RHNzt1H8VXwsTk/rfPpTmtvC3nHpOmME2XD+Tq+LNX6TRuM4Hd275MuOi36bS0iKvVVg
         uGsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m/RabSljBhZ9UUQSJRI1BylATrQl4vx1wTwVBab6KOg=;
        b=8A6+qY1eryW3ajvLVvk+kWjq4OzYSzDz9U8QsgjNPzQ/Ocb+Jm9W22NweMRv6IvGBC
         3plTrMdFeYczC/w0LANTMy69rWjzEfR9cUhONVml/nuNmDB6LkxUS4RagOCo64tkDmVc
         YJNjpWXFdPaoVC+FZMtvCCNA/4g2KlGVRnMf+c6Wvc35I+cgTRDE28BCqvDF31+4Jk4e
         P15x1ykG6UlZeJCr/XM8qco0kl33k4NwmF6ZRKlcP/FypBULZ+QQ4egka1t0L7n3JFPT
         SI4PPbv3VlQvNYMveKZtqKtau0/ZDW51ow7LYKaxE2SN4i6opETKhmsWZ2fP/wvTKuXW
         14wA==
X-Gm-Message-State: AFqh2kq6jKLotc1NqKOMkNelTphhVR3u0gnTdsEbiSD0pWLT4pfvsQr2
	CKKDydbldVs6ttdMj8Sk1siLdKzJsInmvg==
X-Google-Smtp-Source: AMrXdXuZFCRsF43mKJP/JrWWay+JHAtZ0w0wGfXsDCq5zzUMO++Q+S7T4cqFlsYVwbhQhkI+936g7Kn62LNPsg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:7589:0:b0:7dc:116c:8499 with SMTP id
 q131-20020a257589000000b007dc116c8499mr4440641ybc.9.1674855835993; Fri, 27
 Jan 2023 13:43:55 -0800 (PST)
Date: Fri, 27 Jan 2023 21:43:49 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230127214353.245671-1-ricarkol@google.com>
Subject: [PATCH v2 0/4] KVM: selftests: aarch64: page_fault_test S1PTW related fixes
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com, 
	eric.auger@redhat.com, oupton@google.com, yuzenghui@huawei.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Commit 406504c7b040 ("KVM: arm64: Fix S1PTW handling on RO memslots")
changed the way S1PTW faults were handled by KVM.  Before this fix,
KVM treated any fault due to any S1PTW as a write, even S1PTW that
didn't update the PTE.  Some tests in page_fault_test mistakenly check
for this KVM behavior and are currently failing.  For example, there's
a dirty log test that asserts that a S1PTW without AF or DA results in
the PTE page getting dirty.

The first commit fixes the userfaultfd check by relaxing all read vs.
write checks.  The second commit fixes the dirtylog tests by only
asserting dirty bits when the AF bit is set.  The third commit fixes
an issue found after fixing the previous two: the dirty log test was
checking for the first page in the PT region.  Finally, commit "KVM:
arm64: Fix S1PTW handling on RO memslots" allows for having readonly
memslots holding page tables, so commit 4 add tests for it.

Changes from v1:
- added sha1's for commit "KVM: arm64: Fix S1PTW handling on RO
  memslots" in all messages. (Oliver)
- removed _with_af from RO macro. (Oliver)

Ricardo Koller (4):
  KVM: selftests: aarch64: Relax userfaultfd read vs. write checks
  KVM: selftests: aarch64: Do not default to dirty PTE pages on all
    S1PTWs
  KVM: selftests: aarch64: Fix check of dirty log PT write
  KVM: selftests: aarch64: Test read-only PT memory regions

 .../selftests/kvm/aarch64/page_fault_test.c   | 187 ++++++++++--------
 1 file changed, 103 insertions(+), 84 deletions(-)

-- 
2.39.1.456.gfc5497dd1b-goog

