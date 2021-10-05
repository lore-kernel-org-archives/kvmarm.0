Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26461C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 09:02:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B2CC8613B5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 09:02:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B2CC8613B5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 661404B2E2;
	Tue,  5 Oct 2021 05:02:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J06VMGJtVy9i; Tue,  5 Oct 2021 05:02:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CA494B2B4;
	Tue,  5 Oct 2021 05:02:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B4ED4B2A7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 05:02:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ORXyR3jV2sRb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 05:02:33 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6FF94B267
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 05:02:33 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 hf12-20020a0562140e8c00b00382cdfe644eso7099099qvb.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 02:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=wkyuiZINwNBLMyCf2gjjqTHN+Go0IESaSFToIb6F4Fw=;
 b=EKFnh/sXPfL6SyxAQSUAY6zRBxqFcb3PSl/vj5lGE5JSiKVIYXjqNkN1c3ma+yItZf
 Sk0o0NPthUFScy8hUZ0wwOootL0G4y2vL/YJuxg3Dtw4kvPj4ocxd0/gXRLX1ih/LGSv
 kJieebl7g9OC5vkrvzjJ+WIu1oy3uhPGasNwC17W2CNL4nezRMLhlsl77YmYptBherI1
 RgFFqaUthvhyo277EzH+4gHTmvxLf9dWDJ31uiYuUcGjUlwSsAR0phVTLp8+gM3LfCBk
 kOW+OG0MAYoB5rguVBaWbIDO/tcBdGv7n83nZne3vgNNIs3aqfeDZM4jt3A7FSzg85LE
 AMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wkyuiZINwNBLMyCf2gjjqTHN+Go0IESaSFToIb6F4Fw=;
 b=Wv+RtrC0PD7x7lnCqzMJBGAFNdVeZlzM+D326BnUK5HgnRrA97NrgoekwcTmWRWBoN
 4odcOHo2Esi04pjfay5wM0nGbWbo/ohrWT2aLgAVEOqr9uG/cy2dxzBawolhp0O7Bqz0
 x69v+JYvge9cp+23zTHrDnsnQVenht1lTsPAah9K+7XVE7QFgs3o0+yHehGRFB+L7E8k
 nCLlyW3M8TSing12gqcMAs9TKUNad5+iVLukuLfAM0Nc5Ngz2quX4YeXwE7ZfkeXrsbb
 mId/SX5BwZWeNtlaYsJwQrDZ/0hoyrSPPVPcoxQJTx4KZ3dtmMzmtGkSKXKe9Cstrus2
 8GiQ==
X-Gm-Message-State: AOAM530EJLCCNydNgVfmc5T0SuoXWzzo0/NxhVMY2xkHjuY9MIqkK39u
 PiYwXchu+x1RPsnYMqt+V9Cxvuk/qv0q
X-Google-Smtp-Source: ABdhPJwLRnkFWRvGHIY32Rqa3Eiquzx86qZPVIsgO2JHnhRBY0a0MNCuAi59I89wj4Q70Jl6kpZxagSP7sBv
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:5700:9128:3106:b389])
 (user=qperret job=sendgmr) by 2002:a05:6214:1267:: with SMTP id
 r7mr9710216qvv.16.1633424553449; Tue, 05 Oct 2021 02:02:33 -0700 (PDT)
Date: Tue,  5 Oct 2021 10:01:39 +0100
In-Reply-To: <20211005090155.734578-1-qperret@google.com>
Message-Id: <20211005090155.734578-3-qperret@google.com>
Mime-Version: 1.0
References: <20211005090155.734578-1-qperret@google.com>
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
