Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E821C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A48FE611C9
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A48FE611C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 486C14B0D9;
	Wed, 22 Sep 2021 08:47:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xgTFfMFSDvmR; Wed, 22 Sep 2021 08:47:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ADE04B0CB;
	Wed, 22 Sep 2021 08:47:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F2AB4024F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5000rcypzZHk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 08:47:11 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 701784B08A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:11 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 61-20020aed2143000000b002a6a0f52ce7so9712587qtc.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 05:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=RXQp8EhHyhXXySKkvUjyl1brDMjtu4rtTGvd2k1suTI=;
 b=s3+Mgqu8sfSi0tCYFDk4JwgQAxV1pz/6CO4GlvQdNLDT7G6pSVteqrVOUbJoNQUICx
 LPAepd4yvGh/3gSXd2CJz1kK14w6Nm8zL7ncfnx9iJ1CAINHfXbGYrOzC7+nUK9sOwDJ
 TRTbDtDkBYd2yp9w7m5pbi8ISYYfo5tAJQ+iiB2U0e7oNl0yZpepUFhPgrXK+zQxz2gq
 qPATu9Av7z25m0JBFjYVY4Gdy1woTsZHYxjRVdMn9Tu+zs3Ldi+eyk6f1OFiqe9uCn4o
 AMyzKKS4CA9z9xgmDH/DgDUCCRAKw+/tN4deBLr5pwMD+TSO5M8pPOU7OrlX2Zwhbr1c
 /alQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=RXQp8EhHyhXXySKkvUjyl1brDMjtu4rtTGvd2k1suTI=;
 b=GBiaN8ycXXZdH/nsXUFHub66bRVjggXB5mauVZPefjqSe2gaOH/b/Ur544ikWWLPzm
 4uwfMPOMedSxW+4t1tB/+TP/9zI/tEMm8UHgRwhHMYt3TCYrnMy4xdB7yOwfpM4Miaxg
 MFUglKHmR5byLOcgN+RVzbI399OqHx+wULjF6TXLCeHNAeIw36j/zWRWqnGMVNl2CxiN
 Z8kmzoZG8iNN6dNvHWFSbNWVNSEnpBkub8FHE5QFxdNUcWVC4aFQ3LJN5XnJVgSRXp7F
 JVgejt9jLFhjGrm7iczIkVpaKN2AigxP/inOAVI/PbV/PknPW75wuqkOF4uxz/a1tUrL
 dEjg==
X-Gm-Message-State: AOAM533/P/l1L4dva0hO/p6jap6XL8nSuVI5S5hLqhk5GVuTwTjnj6mk
 uytvY/yUzIqr+10MQo93FcXg204zqa7Xd1MCHZn1MDLzxsUFi36yMDKKKGX6wi9HrI39MgFFG4B
 gsu8KSRsnfrIefY+OC2zH25ENOregQ3cOha8thIaJfg/JaHCDbe34DKqRgnPousG/RfY=
X-Google-Smtp-Source: ABdhPJzaj/UlUNVyzlfyuYkTDj+4eIBqbXRkw5oe7YW85EAs0vshHaSjcz6Z29FkHRA7oZj25ajpysCUvQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:45c3:: with SMTP id
 v3mr37263884qvt.41.1632314830924; 
 Wed, 22 Sep 2021 05:47:10 -0700 (PDT)
Date: Wed, 22 Sep 2021 13:46:54 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-3-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 02/12] KVM: arm64: Don't include switch.h into
 nvhe/kvm-main.c
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

From: Marc Zyngier <maz@kernel.org>

hyp-main.c includes switch.h while it only requires adjust-pc.h.
Fix it to remove an unnecessary dependency.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 2da6aa8da868..8ca1104f4774 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -4,7 +4,7 @@
  * Author: Andrew Scull <ascull@google.com>
  */
 
-#include <hyp/switch.h>
+#include <hyp/adjust_pc.h>
 
 #include <asm/pgtable-types.h>
 #include <asm/kvm_asm.h>
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
