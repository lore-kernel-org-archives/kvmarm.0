Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C538DC43217
	for <kvmarm@archiver.kernel.org>; Wed, 12 Oct 2022 17:46:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 36F0E4966F;
	Wed, 12 Oct 2022 13:46:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gc4BGhahV55k; Wed, 12 Oct 2022 13:46:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D2E148FA4;
	Wed, 12 Oct 2022 13:46:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54C8940BFA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Oct 2022 12:59:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oxitkjloFQoa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Oct 2022 12:59:32 -0400 (EDT)
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com
 [209.85.215.177])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3BD6F40801
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Oct 2022 12:59:32 -0400 (EDT)
Received: by mail-pg1-f177.google.com with SMTP id 78so15985724pgb.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Oct 2022 09:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=ewQpo6SyzsCd+TVr4dngzoh/1LumYtAxcdZG9494fvM=;
 b=DzwjZ6oCSiR0/0Xe5yTo5hS4sfi1Qf3T72pp5dGmxcxXxT6xgKZaRowQ0eOCKSrFqW
 NPdaBbujgUM/v4LsY4eYOoV9mqeKbBXdXgrtMXIxWXwmXqOaQvuuzsgwtUa1mtfkTirK
 qUXL4QjIF2PUCPNZtLlNPgFm8RHMOsURdLD2iKzmgASYJJNOSPZGG4np/+/BLiJ2dOxq
 qiS6tUSX80LtJvGXW/5SNO73P01DSDJCDa6w3qh3YGoQioZRJErV7wKiqVjTaN+56Uxu
 PCOEqIZf9emRspCJ9Xjwf0a8rOunDS1URjX8v3ap42r7l70bV5tCORGN49cTznXnV8mr
 oMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=ewQpo6SyzsCd+TVr4dngzoh/1LumYtAxcdZG9494fvM=;
 b=aG0uozCM1mqjXejC55nJ84D48nP84uBsOAJnaTbXjWugSbOkJJHRp5fTXE/T0OMOCo
 cXyyCBYOQRRJRVhBd1Jegc3hsanuYj9aCLV0D4GwqoRqXApSqcldopdv5yV0rlMoF3xA
 8j+erRCQlsbVGPjmaQCJhR3wcL+UWI7xHhi4fHSfwBsqX1W5ka+SrVqPfBV/ZUCb2gkB
 5KmNzvOp1vc6DBIwnAcipo+u97kHt7izu/luMqdqtgAoDdENHYoBeKm5thMm+Jtu51MK
 fuCi0hvt8yUxB9bcW0U5qMbBPRJWopxXvdLSzctZwgdgErM7RHHBeHzpu+11nk4l+dKO
 vofg==
X-Gm-Message-State: ACrzQf0eCIFRIEou6vjjoQPOtzONt3P24r+zgjHFuLXISakL7a9RjKxt
 vF+Za84m1J4c/WDjTCQpLkM=
X-Google-Smtp-Source: AMsMyM6QlAXDkvBArVj2SUglXYsmsrSFS9PDQRCfhtMH5c2TRBrdF5AGwHU929t3lHrPygD60k1epA==
X-Received: by 2002:aa7:9057:0:b0:565:d7dd:a453 with SMTP id
 n23-20020aa79057000000b00565d7dda453mr305113pfo.33.1665593971047; 
 Wed, 12 Oct 2022 09:59:31 -0700 (PDT)
Received: from e69h04161.et15sqa.tbsite.net ([140.205.118.126])
 by smtp.gmail.com with ESMTPSA id
 f8-20020a170902684800b0017534ffd491sm4462697pln.163.2022.10.12.09.59.29
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Wed, 12 Oct 2022 09:59:30 -0700 (PDT)
From: Eric Ren <renzhengeek@gmail.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: vgic: fix wrong loop condition in scan_its_table()
Date: Thu, 13 Oct 2022 00:59:25 +0800
Message-Id: <acd9f1643980fbd27cd22523d2d84ca7c9add84a.1665592448.git.renzhengeek@gmail.com>
X-Mailer: git-send-email 1.8.3.1
X-Mailman-Approved-At: Wed, 12 Oct 2022 13:46:02 -0400
Cc: marc.zyngier@arm.com, cdall@linaro.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Reproducer hints:
1. Create ARM virt VM with pxb-pcie bus which adds
   extra host bridges, with qemu command like:

```
  -device pxb-pcie,bus_nr=8,id=pci.x,numa_node=0,bus=pcie.0 \
  -device pcie-root-port,..,bus=pci.x \
  ...
  -device pxb-pcie,bus_nr=37,id=pci.y,numa_node=1,bus=pcie.0 \
  -device pcie-root-port,..,bus=pci.y \
  ...

```
2. Perform VM migration which calls save/restore device tables.

In that setup, we get a big "offset" between 2 device_ids (
one is small, another is big), which makes unsigned "len" round
up a big positive number, causing loop to continue exceptionally.

Signed-off-by: Eric Ren <renzhengeek@gmail.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 24d7778d1ce6..673554ef02f9 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2141,7 +2141,7 @@ static int scan_its_table(struct vgic_its *its, gpa_t base, int size, u32 esz,
 			  int start_id, entry_fn_t fn, void *opaque)
 {
 	struct kvm *kvm = its->dev->kvm;
-	unsigned long len = size;
+	ssize_t len = size;
 	int id = start_id;
 	gpa_t gpa = base;
 	char entry[ESZ_MAX];
-- 
2.19.1.6.gb485710b

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
