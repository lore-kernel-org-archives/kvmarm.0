Return-Path: <SRS0=Wuko=OY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F91DC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 09:04:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D09D96139F
	for <kvmarm@archiver.kernel.org>; Mon,  4 Oct 2021 09:04:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D09D96139F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 852704B26D;
	Mon,  4 Oct 2021 05:04:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id r4Nrg-boUMjA; Mon,  4 Oct 2021 05:04:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9850B4B236;
	Mon,  4 Oct 2021 05:04:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E8FB4B236
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 05:04:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fPLZOwgu79nP for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 05:04:13 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8B46A4B211
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 05:04:13 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 m1-20020a05620a290100b0045e5e0b11e6so23226837qkp.23
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 02:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wkyuiZINwNBLMyCf2gjjqTHN+Go0IESaSFToIb6F4Fw=;
 b=TMjOfQHcr/Buzl+oIVWhFVyiArxE1cZ3vpKMWyLANeP2U9TxY8SYN5pke9uBTQYz+U
 RIB1ZRrnPZHnfENtF9YmVzL5b2dsm+8nezApYrkcELyYsTgIxCXqXNO1hgtl+kxWOHqt
 YYimqCXssd0CsMUdzG3aiDaPHuW0jO1FRRSQN9CmPVoQKROHZ0soqL+iSp+ePqyxkxJ4
 aBBfUHuRZy/2zMpYKVQ68s/iuanxLmWb85P3CroP0EVlbrCmCoq91Okjk9cJ5jEAWbgt
 MbAZGlaksbCy17axlm5ayqNk85VH9Kb4lIdjYPdiad/U6IoxI4yhM1WcNa0iTDKHwSHP
 B1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wkyuiZINwNBLMyCf2gjjqTHN+Go0IESaSFToIb6F4Fw=;
 b=20vHxaXB7zi3UYYoY8RrqN7rUhl8SGfxZgyOm0g+vMnqNHMMwtUdwg3SE1dvA/KhHT
 JwX7Ov3HwU6pJdejRThqULLZ30A3eJLK8Bouw/KbIC9YUW+yiBflCheKHf3lFMPaB+U0
 /dPgwcpQvirUeVI57k1yncYcX97ZWiDTw5nI3qQEdNZu6dxy5Nka0BYL2ZW9VMgw8+97
 cmMqsuUkR0ouF4u6NeJEbZcqKv2lsU2Dcae3N15YXKrnq5Xz5vx/rlvAEImzAgKj+t4w
 Mn2gK/l+kvrpwM1VsPRErh4cXdnybAvDQWkVMHnXAfisbdK6+KO4rBZcZbTs35FgBa24
 orjQ==
X-Gm-Message-State: AOAM530RRDlkyrG54oeuLHXmHkwgghMmF3yh9BwcwGGUcsX1wshn3ACU
 LJUkB6k7yzrTE+eBWMiZ/wdWGAe2wTL2
X-Google-Smtp-Source: ABdhPJz17Z7ue1W7hq3hrv29ed/PiZ+fLhUfwKMW5antWu0eaJWy3bZ4lxRPpDIEYNfIk8cbjwcuEEkEbV4g
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:669b:5b16:60b7:a3d4])
 (user=qperret job=sendgmr) by 2002:a0c:85e6:: with SMTP id
 o93mr21326866qva.16.1633338253264; Mon, 04 Oct 2021 02:04:13 -0700 (PDT)
Date: Mon,  4 Oct 2021 10:03:14 +0100
In-Reply-To: <20211004090328.540941-1-qperret@google.com>
Message-Id: <20211004090328.540941-3-qperret@google.com>
Mime-Version: 1.0
References: <20211004090328.540941-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH 2/2] KVM: arm64: Report corrupted refcount at EL2
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
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

Some of the refcount manipulation helpers used at EL2 are instrumented
to catch a corrupt state, but not all of them are treated equally. Let's
make things more consistent by instrumenting hyp_page_ref_dec_and_test()
as well.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index a6e874e61a40..0bd7701ad1df 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -152,6 +152,7 @@ static inline void hyp_page_ref_inc(struct hyp_page *p)
 
 static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
 {
+	BUG_ON(!p->refcount);
 	p->refcount--;
 	return (p->refcount == 0);
 }
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
