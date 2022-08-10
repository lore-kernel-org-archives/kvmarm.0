Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F5DC00140
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 19:30:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A9844DA88;
	Wed, 10 Aug 2022 15:30:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wECHsM7Mgro9; Wed, 10 Aug 2022 15:30:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 429DE4DA94;
	Wed, 10 Aug 2022 15:30:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7A74DA63
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 15:30:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cz1QZMaWXy8X for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 15:30:53 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 491A44DA7E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 15:30:53 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31f46b4759bso132564357b3.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 12:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=+yNPE0YtwokNPZdowqkCFFxMTcHqUO1hXxky5MuupRY=;
 b=oZ5EETOvVLFNFJcFvJs5CUWFZV2YZx1lZtCVYg3Xpam3/6hJePg2ArdHUJxsspg7R5
 kYnk9btdizwNCjiWTgj6vhaG+Ln/haQoW/pUsdjAvXGRUtwyTKhYaNbVGIqa4N0knmX5
 Y6Bf8Sp0myosiRXqgzgjzzrxNgMTvUamymRKjYhHFjm5HuDY7N2HLKT82K2ZR3tI6a2I
 TkfL2xlNiTx9SHZbWxe0/jGZ8EVR0bP+e7g+tySRt7UNKn82GSElS85ZLEZQitwkkwIT
 z43wgykSu9Orgytw+Yk5q/JCadYNjdaFTKqRIDXR1Haw0of7kw8Io57Gij0cmraUd7F0
 vpZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=+yNPE0YtwokNPZdowqkCFFxMTcHqUO1hXxky5MuupRY=;
 b=bdYW+e1y2vrCFzj5mOxYUTGRLuH8kErbhVvZrLiGSwyR2nbtcduKwPq7JutdzTbbTN
 5VYJOX9FM680qyk3qG7CXQjlDLjqWGGNhmaI9dNcwXMQY8ARNqSgY9ij/xW46LlwSh9K
 P5lN7n+unzzga2xRelxb5T7NQX6o0ratE+TPSkMzAapwrbXWnyZLafjUa5RlMWfwtKHm
 AYU4uKLEWFzUsziA+ZDZHA0NIP+KOGgKoMzUsgZ9dSyYVYvkFxltRGB4W2ZWMwSKx8/7
 sQBwQb5BT5EM3p1Cf3wZqQBAkYV4RwilTlWM/pRyWlgI4XgWbSUzI1OfTaa3k+TpfgNf
 TnpA==
X-Gm-Message-State: ACgBeo1608DCMdlf5BObjwdbxvC6m46Nxi2Rl+2S1fZBPOGnAK1V0z7Z
 Q17LSlu+2wBl20Im/stR27D9Gbs=
X-Google-Smtp-Source: AA6agR6moG62zPERwU4Dk26hNOp5DcD21DJAex4OmPFxWG3fnAGG1z1V+i1T2gQ2yJV0LxVv859Fqu0=
X-Received: from pcc-desktop.svl.corp.google.com
 ([2620:15c:2ce:200:4d8b:fb2a:2ecb:c2bb])
 (user=pcc job=sendgmr) by 2002:a25:b951:0:b0:67b:93e9:1ff9 with SMTP id
 s17-20020a25b951000000b0067b93e91ff9mr21338230ybm.101.1660159852914; Wed, 10
 Aug 2022 12:30:52 -0700 (PDT)
Date: Wed, 10 Aug 2022 12:30:32 -0700
In-Reply-To: <20220810193033.1090251-1-pcc@google.com>
Message-Id: <20220810193033.1090251-7-pcc@google.com>
Mime-Version: 1.0
References: <20220810193033.1090251-1-pcc@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 6/7] KVM: arm64: permit all VM_MTE_ALLOWED mappings with
 MTE enabled
From: Peter Collingbourne <pcc@google.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Cornelia Huck <cohuck@redhat.com>,
 Steven Price <steven.price@arm.com>, Marc Zyngier <maz@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>, Evgenii Stepanov <eugenis@google.com>
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

Certain VMMs such as crosvm have features (e.g. sandboxing) that depend
on being able to map guest memory as MAP_SHARED. The current restriction
on sharing MAP_SHARED pages with the guest is preventing the use of
those features with MTE. Now that the races between tasks concurrently
clearing tags on the same page have been fixed, remove this restriction.

Signed-off-by: Peter Collingbourne <pcc@google.com>
---
 arch/arm64/kvm/mmu.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d54be80e31dd..fc65dc20655d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1075,14 +1075,6 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 
 static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 {
-	/*
-	 * VM_SHARED mappings are not allowed with MTE to avoid races
-	 * when updating the PG_mte_tagged page flag, see
-	 * sanitise_mte_tags for more details.
-	 */
-	if (vma->vm_flags & VM_SHARED)
-		return false;
-
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
-- 
2.37.1.559.g78731f0fdb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
