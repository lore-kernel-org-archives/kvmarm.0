Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0734C4332F
	for <kvmarm@archiver.kernel.org>; Fri,  4 Nov 2022 06:21:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABA534B133;
	Fri,  4 Nov 2022 02:21:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@bytedance-com.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tdvE5Y9ktGMB; Fri,  4 Nov 2022 02:21:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE1824B17C;
	Fri,  4 Nov 2022 02:21:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 381D84B17C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 02:21:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JsTzhM8zHsCp for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2022 02:21:22 -0400 (EDT)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com
 [209.85.221.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5D524B0D7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2022 02:21:20 -0400 (EDT)
Received: by mail-wr1-f48.google.com with SMTP id bk15so5627020wrb.13
 for <kvmarm@lists.cs.columbia.edu>; Thu, 03 Nov 2022 23:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=bytedance-com.20210112.gappssmtp.com; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date
 :message-id:reply-to;
 bh=lCXwZ5vfNe4SOPsgVDOzi3k6ifSwUdOjW1NH0sg+5rM=;
 b=zcl272foHL4KaayQq1kq5oJeQSUrmBhZUd7b4kRoVJiQ5379j2ZkkOfI1EwRxRzFbE
 8rvWRUY2sP15++X3oRb2vdl6yJGi0+bKBKI6aS3gNmHmrJjKoyDsAQoHcPv8kv5lLrhr
 +CVusvt/P6/aSZM3mL5e9GYEj9TX3cZIG10RgXGN4aOK1aQZbxs/VQrNJ6Yh01d4SJmw
 2j6WPlHvWC98Hi8oBUVjYV06h3Z9xVvnI+/Wk8kTNMg904MfJ9BgQg5j8lew/yNY7m77
 M59jT/uKm3xEaphlt/qItM9WVOx7TqB7BRo8gJGkU7ZHLJnEvNi8hmUfQIdffryUu+y6
 F4Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=lCXwZ5vfNe4SOPsgVDOzi3k6ifSwUdOjW1NH0sg+5rM=;
 b=P0dZBUwtncpTUGsl73v4YsQD/4kUGEy+u3Xvl2QJFEtZct2cQ3MjEDpHOYsQWtWRw7
 SqMdfPgD8rfI0NmJ+kaNEjOyRIcZCivd15dUm8Bbp8Jq1ytGjK8xvJuydWYyKuI0IMRe
 jvGFXtId/2tMtBpcyrFgJXfA71ollvC7XfDXCOZewXoygmGvil7mF1KYCelQIbitZdmH
 iZFp7zocbsd2Zx2QQ8s4edF0Uk3VYRuGxbKfRcQrBaZxbtuUzxaV5KxoHPYBz52ZEQhv
 R4+82VFvrgHsqo7rSo6Emb0oDbVgmT0UtGuB/DUBfS5xAi+FX6iSy8Rgur7i0CSqO4vZ
 MkjQ==
X-Gm-Message-State: ACrzQf0p6xpFwTHanjv6jtxWlYtldU1d7ucLtXonWOJHMuJRj8JckJ/g
 GMZk5vAwa4e7C+7MQmIHYfF4vUViji3KGg==
X-Google-Smtp-Source: AMsMyM68wJEa3smABHPK3YXkguRUiNr4QZx08ls9uFNkEujnEZnJ0igA3c8PEyj/dIjxjaBk9yTbDw==
X-Received: by 2002:adf:fe8e:0:b0:236:6860:e55a with SMTP id
 l14-20020adffe8e000000b002366860e55amr20229508wrr.105.1667542879959; 
 Thu, 03 Nov 2022 23:21:19 -0700 (PDT)
Received: from usaari01.cust.communityfibre.co.uk
 ([2a02:6b6a:b4d7:0:c7c:f931:dd4c:1ea6])
 by smtp.gmail.com with ESMTPSA id
 w11-20020a5d608b000000b002366f9bd717sm3099924wrt.45.2022.11.03.23.21.19
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 03 Nov 2022 23:21:19 -0700 (PDT)
From: Usama Arif <usama.arif@bytedance.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, virtualization@lists.linux-foundation.org,
 linux@armlinux.org.uk, yezengruan@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, maz@kernel.org, steven.price@arm.com,
 mark.rutland@arm.com, bagasdotme@gmail.com
Subject: [v2 6/6] KVM: selftests: add tests for PV time specific hypercall
Date: Fri,  4 Nov 2022 06:21:05 +0000
Message-Id: <20221104062105.4119003-7-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104062105.4119003-1-usama.arif@bytedance.com>
References: <20221104062105.4119003-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Cc: punit.agrawal@bytedance.com, fam.zheng@bytedance.com, liangma@liangbit.com,
 Usama Arif <usama.arif@bytedance.com>
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

This is a vendor specific hypercall.

Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 tools/testing/selftests/kvm/aarch64/hypercalls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/hypercalls.c b/tools/testing/selftests/kvm/aarch64/hypercalls.c
index a39da3fe4952..c5c304e886a5 100644
--- a/tools/testing/selftests/kvm/aarch64/hypercalls.c
+++ b/tools/testing/selftests/kvm/aarch64/hypercalls.c
@@ -78,6 +78,8 @@ static const struct test_hvc_info hvc_info[] = {
 	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID,
 			ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID),
 	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID, 0),
+	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID,
+			ARM_SMCCC_VENDOR_HYP_KVM_PV_LOCK_FUNC_ID),
 	TEST_HVC_INFO(ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID, KVM_PTP_VIRT_COUNTER),
 };
 
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
