Return-Path: <SRS0=xfyP=MU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80084C4320A
	for <kvmarm@archiver.kernel.org>; Wed, 28 Jul 2021 15:32:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F141860F9D
	for <kvmarm@archiver.kernel.org>; Wed, 28 Jul 2021 15:32:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F141860F9D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F68149D50;
	Wed, 28 Jul 2021 11:32:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L6gyirP7jk1s; Wed, 28 Jul 2021 11:32:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 827DD4A524;
	Wed, 28 Jul 2021 11:32:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6028740CC5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 11:32:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dG0nf-PGGQTn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jul 2021 11:32:41 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A830407A0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 11:32:41 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 132-20020a1c018a0000b029025005348905so1060718wmb.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jul 2021 08:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=woxBdtlGB6zB1Cvm58/DELTClL+Pi4ueOkLDe2VMF2M=;
 b=epz07g1EaavCivdoVuxcYOGCNXaoqnHhC/UGhLJRF+Pky/IvXdl3JWJ/nFWpj1Ynvf
 KjegyFAa2rqJf5VkvBzIf5tCpmdFnEuEi+3GKS+sfYVz+flelYUipvnrD5flmnVoNSdp
 HYObj4QGfiMOQmAIe3/I4itJkSqJwj8bKMkVQhbx8UQejc84bFjgnN//b2YSK0Shovvv
 3TSYIRoZRvbXhh+oXXVNHCOqLH/Neby0qKwUGuDd+xPKZOK21+GKxBiI4nRE4D8Ba8dS
 O7SJsrFOZwe9huviD1vNwjgYFKYApbdca566DIHnHOgoMQmwf7QVMBBFhB6CARGzEuDw
 sotQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=woxBdtlGB6zB1Cvm58/DELTClL+Pi4ueOkLDe2VMF2M=;
 b=DeYLCNAIH4DCrsSdyClG5w+1k8HmS54kEevr/b0FXRDEDr55l10OvP0C85kGqkY7jv
 PjLARmq0BnVWCyKsJF9p0Famy7haZCQwLp0wBLnQP5uJOWyRkHJ8f9SEHP1cUiYg/YAg
 PhCZIiW7oje+Pamsgui+6DElGGtia1eOAOPs2BW2qe5qkRpqupIBMqO/r0980JQ7s7l1
 eZhPQDwMBlMgcFI324aVD9hxV5ZWgobqJ4XgDecSca1/wP0vW4LZDgmuErTFl/ifwx9B
 +Vx8L1Ontaw05m8aUyYy60aBhA63GhMeY3XcQqeIPu9Lb+7psQtwN+LDMGJLe6PBE1uC
 STVg==
X-Gm-Message-State: AOAM533Rg3Q6cI+Dv/GXWp6Uk2bjSjhX2iM5LAdcwEaodVoHl/rr1MCn
 3KEDMM5kF9ONdxJh8UCG94FYSLyyibreCqH4+MOjlJ93Ha/m47UovdDL/zXxxVG/oCddVjFEf1M
 pxcOD+9vm3auGeYdWd8BW7HLcxBsjlPB8qHzfmSwL0Y4XaJrJ+IpP2wb5RIqQeGhnKxfhaoXOHU
 8=
X-Google-Smtp-Source: ABdhPJxcC9G+bs+7QxWK7qVmeijPTYfUQ0BkmUenPrMR4B9UrgEdp6IuwoWBJPGRXAZh21n0pgqNMUrPMGxJ/g==
X-Received: from dbrazdil.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:7f9b])
 (user=dbrazdil job=sendgmr) by 2002:a1c:7c04:: with SMTP id
 x4mr331814wmc.48.1627486360245; Wed, 28 Jul 2021 08:32:40 -0700 (PDT)
Date: Wed, 28 Jul 2021 15:32:30 +0000
Message-Id: <20210728153232.1018911-1-dbrazdil@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH 0/2] Fix off-by-one in range_is_memory
From: David Brazdil <dbrazdil@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
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

Hi, here is an off-by-one bug fix and a very minor improvement for
the range_is_memory function in hyp.

David Brazdil (2):
  KVM: arm64: Fix off-by-one in range_is_memory
  KVM: arm64: Minor optimization of range_is_memory

 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
