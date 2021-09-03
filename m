Return-Path: <SRS0=P5lD=NZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 089A8C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 23:12:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 863A7610A1
	for <kvmarm@archiver.kernel.org>; Fri,  3 Sep 2021 23:12:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 863A7610A1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0022E4B26C;
	Fri,  3 Sep 2021 19:12:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qrS51D59zCZy; Fri,  3 Sep 2021 19:12:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F17D54B267;
	Fri,  3 Sep 2021 19:11:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C01104B265
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 19:11:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id beOe2eXFtVks for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Sep 2021 19:11:57 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DD0304B264
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Sep 2021 19:11:57 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 c22-20020ac80096000000b0029f6809300eso1963506qtg.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Sep 2021 16:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=1IikKeiNBiI+661feqxQfbwdUTfKgQ/MgsLAZgB0GvY=;
 b=nnYsIrdngqs4rCZL60vqh/oslFzMghTxYs91Lvaxg9FUDbizKwLT/y5dBKvZItyjYB
 2SbHmreK5Dh/eAvEK7u0uZ8PQ0RhNw7IEbhqHi08gtDkIJRJfrHmmMTSPEFtqmkD8d0q
 hDUjQLrzl08MiCyVDUEK5nrAJMfdnGTqKwPwI7IAhnhgtFTbpk432m7oDb4Az2cLurKx
 ouqYjPK1Vfe/kpvWqf0i0zOjYDPgeSqIfxy/87KDQnfC52sgIVu/wJwohWGgwLQX4Zlq
 eWJSemqfNfIv5SCN3gp8SJG6mJed+nEMAHVilxzaA8XSMw69qqyGT0+qZF7jinl0RZPr
 LN2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=1IikKeiNBiI+661feqxQfbwdUTfKgQ/MgsLAZgB0GvY=;
 b=E8jmNjmO0KIAT7j2093rFiq9JseHL2Y+y0BpyZe78cMIbNPXfNVYSG0qg/jytKCfK7
 vRnBhy4l6jEXQapTV+GkxLATthzcbW+HbR18qQR7CTllVVI9cZknT/IAggO7VyNdKDHS
 UOaWCM65HFuyJZm8V8iZGUZJKtm9njFo2GqJle+8cUEMwBj52kaATQmqXegcxoadP4k9
 v8S3547cOMk9IEz3Z0PXMBac+kt/I/5aEfAsFRcZak4qVuXw4z8k8PyVK7LELTCDZ2gy
 N0mc2V5j8R555CN64OvuUj1Tw4LgaUrDIVWJ4SAyiwYmDOCmZlZ6EUShEF1lGnLGCdPW
 KDUA==
X-Gm-Message-State: AOAM533HEVCxRpHmO5UGfsYNrDGDjndl/HvFppEg4BrWQDh/6vTXKLDH
 MmPgK7SGjguhOMDHVKsm+zKe8XbQFUhcMQ==
X-Google-Smtp-Source: ABdhPJydyx6I9B32wXw0UwQZpNOLWE1nKUmlH3p8le+Vok/KTo3OivGxp8atC3n/FdlY3d/g7fuw77oUHxX1Rw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6214:54e:: with SMTP id
 ci14mr1567870qvb.3.1630710717409; Fri, 03 Sep 2021 16:11:57 -0700 (PDT)
Date: Fri,  3 Sep 2021 16:11:52 -0700
Message-Id: <20210903231154.25091-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 0/2] KVM: selftests: enable the memslot tests in ARM64
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>,
 maciej.szmigiero@oracle.com
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

Enable memslot_modification_stress_test and memslot_perf_test in ARM64
(second patch). memslot_modification_stress_test builds and runs in
aarch64 without any modification. memslot_perf_test needs some nits
regarding ucalls (first patch).

Ricardo Koller (2):
  KVM: selftests: make memslot_perf_test arch independent
  KVM: selftests: build the memslot tests for arm64

 tools/testing/selftests/kvm/Makefile          |  2 +
 .../testing/selftests/kvm/memslot_perf_test.c | 56 +++++++++++--------
 2 files changed, 36 insertions(+), 22 deletions(-)

-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
