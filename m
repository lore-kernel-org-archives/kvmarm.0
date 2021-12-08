Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656F9C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 19:33:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C71674B10E;
	Wed,  8 Dec 2021 14:33:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4rLJCCcdXBrF; Wed,  8 Dec 2021 14:33:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E9711406E0;
	Wed,  8 Dec 2021 14:33:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD77E4B10B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 14:33:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id s+QmJyNFHmsY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 14:33:01 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D99BE406E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 14:33:00 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 g11-20020a1c200b000000b003320d092d08so1788177wmg.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 11:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=9Ozq1E9fW4dW9xlif6PxBzdPpjCT1vbETE8Iafrn13o=;
 b=ltGFmUPDJi8nIt/HfOa4aeS+LltkLsQ/Qmhh0JtVpvH2eI2Y/Usq0N1+yWxN6iTRtc
 YLbIFlRzjVQfSM42KSbkDf/j7nSzEax58K8Wm8dxQDx+K/ihjlkd73jbPEDGw3vdFY7R
 adLHmxSD8o6DcMcVS2DWSzxuhJrT3PyVjCaUv/VgasXsfH5nCq9rd6OOXMec251pvkv9
 l21HtfSzvyoS4jsNOzrKT2iZz5B+muahrFsy+Sg/hjvcKywIHwnhcAVhQugZSv1BnMEk
 9aLaooOt5gdcUpd4f+zEDIWAYDKbHLYRZvQsUwMAYe3sAXra92BpDmylQf7Amcc/EkE4
 Vbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=9Ozq1E9fW4dW9xlif6PxBzdPpjCT1vbETE8Iafrn13o=;
 b=0LMX38LVLSXPWO2r0JLDf9XUGylDNP2zWqgDo6nrgjiNiEmSBMX0jyE11qjja5IOEV
 LsuYy2A0Dnx2lzSIdhwtQCocEGQ0FOoqCBb3YYFs7j/BZuJPOOaFgDfVjswRTHgHmJ3k
 KSKQPflD4bFWLvDylPzQbUeTL1isFRN0bAOHdxx/IvRMI2HkrmntFe7GtRe8T3iHLYva
 1DKPtNNFOzQgwRfZ0ov/12pEluXQyFJhtuAlZsRx7OusoJRzYFeES9iuL7vEsJXpRUqz
 vfuMw7+dFBCmrGMG5/VNZ7RTo5//Qb+IWrQwBzU2WNcPH4LhMF4TE2gI0CY8RLsqNLaH
 gEXQ==
X-Gm-Message-State: AOAM532m/lf9tRkjVwxQoRSttjJ3SGCSqLrefGK7YZE91dlI+Eh9lzYg
 uh6rLBOi0ZosUogjitk+Fg80XYs9/GaQXRcWFfZmKIqFSl9/0YHAugkEfE/KJWjTTdQYDy4+WFN
 5dC0d40j0VGwbn2Jckfa8K1VtyEh7m2aQY7oFIlggeByh+xchTLu6Ey0RerMitjaHfk0=
X-Google-Smtp-Source: ABdhPJztwn2ZlVWldgEFMPn5nNzizlDmJ5/EF57npKfjLcR9AnY03w4lpd55TC3bPR5Y3DjvvNRX0vRxOw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:adf:f44c:: with SMTP id
 f12mr764093wrp.620.1638991979739; 
 Wed, 08 Dec 2021 11:32:59 -0800 (PST)
Date: Wed,  8 Dec 2021 19:32:55 +0000
Message-Id: <20211208193257.667613-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 0/2] KVM: arm64: Fix documentation for PSCI related functions
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, will@kernel.org
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

Hi,

This patch series fixes a couple of comments relating to PSCI and the reset
state that are either typos, or refer to an earlier version of the code.

Thanks,
/fuad

Fuad Tabba (2):
  KVM: arm64: Fix comment for kvm_reset_vcpu()
  KVM: arm64: Fix comment on barrier in kvm_psci_vcpu_on()

 arch/arm64/kvm/psci.c  | 2 +-
 arch/arm64/kvm/reset.c | 7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)


base-commit: 1f80d15020d7f130194821feb1432b67648c632d
-- 
2.34.1.400.ga245620fadb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
