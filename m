Return-Path: <SRS0=VYoy=N6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9877AC433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 21:03:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F3D976115B
	for <kvmarm@archiver.kernel.org>; Wed,  8 Sep 2021 21:03:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F3D976115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 717604B091;
	Wed,  8 Sep 2021 17:03:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TPF-CWthlR3J; Wed,  8 Sep 2021 17:03:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6274F4B0ED;
	Wed,  8 Sep 2021 17:03:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 095604B0C2
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 17:03:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YkMgo9-nkBeq for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 17:03:24 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE7EC4B091
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 17:03:23 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 o130-20020a62cd88000000b004053c6c1765so2098664pfg.6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 14:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=JC16aUwWh6VH1dHIMo/8cnVTyU7yQibp113aKDOygMY=;
 b=OXtBrVZQuDsj1Xd11yEKs6/hnslMSZ5qwPiSLFnQtXEJzAEZDxdwJ0oylLEAJYnpAY
 N/uIjCw9BAaW9hztD862iMgGgd2iUeKJm0Io91e8UK+7beow+rrfR7qBsanX5C4OYBkB
 oxyblXxt0sc1T5zq775Psfnb4LGYHas68I0MtlJwO/tXadr+oh0mmJV5uJVzqpVCC1wg
 6vtkOxb0K71cdgMcQ7CEjZzB7i77/VeUued+2jJ5yLu+5jwm1nOq4Xmy3QX8Kgaj3Kkk
 Ib6Jrsz/EkXMWQPxU0zFo3452qgS0gBFH1G8cG7+oNkg4JSxllrFBy1EHWljpHeD/2Bj
 dQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=JC16aUwWh6VH1dHIMo/8cnVTyU7yQibp113aKDOygMY=;
 b=tfLbxW7RSEK2oEOWVKDgbu55K0tn4HfgU6+7kD5jctBcZFL49CufmxPeVe9fOBPvcW
 rdL7q4FzSt9oI+zHHMCP/VLEgGCRyj/DqahvBgzNEqiq5kiltI2puuk8jjuhOR/7tBLQ
 Sd62WugY+z9JTTumoqyoUq9TTl94LKk+BKlzfWrT07KVrVhmiOkQb3Eh1UUPJkdrW7PZ
 tTXX4AAtJu517ZunGU1Js+OSo1A1OZAalC3N+QGDiXBE5QkOw60bDHreiNI6AhmLlDaA
 Ck4S2Kf5WCV+rTyr8aI9O3Cy2IgiToFw/U6tjYD+UFg1mRdtABXpxP64ZZRrba26/S5W
 7SFA==
X-Gm-Message-State: AOAM532tURiymhY9eiuDu6CYgUMrp1DYWPk1nLQ0S8PExXSXZlP6fCbK
 VyUb3g12U5lAvtO+oWR5Aa2EuSg5ZjviAw==
X-Google-Smtp-Source: ABdhPJzla16tMBCgG9E0q1xwBqSq8LzrlZo3pCb2r/5jjfDudDDoT/FtwgmHXvdHMdSKQAJYM1AtIxoy9XZR+w==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:1e02:: with SMTP id
 pg2mr6190361pjb.35.1631135002966; Wed, 08 Sep 2021 14:03:22 -0700 (PDT)
Date: Wed,  8 Sep 2021 14:03:18 -0700
Message-Id: <20210908210320.1182303-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 0/2] KVM: arm64: vgic-v3: Missing check for redist region
 above the VM IPA size
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, 
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

KVM doesn't check for redist regions that extend partially above the
VM-specified IPA (phys_size).  This can happen when using the
KVM_VGIC_V3_ADDR_TYPE_REDIST attribute to set a new region that extends
partially above phys_size (with the base below phys_size).  The issue is that
vcpus can potentially run into a situation where some redistributors are
addressable and others are not.

Patch 1 adds the missing check, and patch 2 adds a test into aarch64/vgic_init.

Ricardo Koller (2):
  KVM: arm64: vgic: check redist region is not above the VM IPA size
  KVM: arm64: selftests: test for vgic redist above the VM IPA size

 arch/arm64/kvm/vgic/vgic-v3.c                 |  4 ++
 .../testing/selftests/kvm/aarch64/vgic_init.c | 44 +++++++++++++++++++
 2 files changed, 48 insertions(+)

-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
