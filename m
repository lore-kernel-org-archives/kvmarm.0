Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6EEC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 11:02:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA1E14C49A;
	Wed, 23 Feb 2022 06:02:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SLDCqgIFmyX9; Wed, 23 Feb 2022 06:02:44 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF4E4C4B3;
	Wed, 23 Feb 2022 06:02:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 051D44C40A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 04:28:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iYhiJIUOundn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Feb 2022 04:27:59 -0500 (EST)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88C8F4C3BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 04:27:59 -0500 (EST)
Received: by mail-qv1-f48.google.com with SMTP id h13so7123750qvk.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Feb 2022 01:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=FhQOAPGriaJ90awBuK8zqjdKv78PGZubmhSGXhOpsOU=;
 b=WYvmz1X6IIdRaJ23Vh2yQ2n13gh/YEBa6QbFeHL6Hg+tvYpNdPGs2Yu2PPKeeQv3+e
 qG22nPSJTrT257gOYx3Q38lCw72iwtPISJGPnbgOEWf4UrqUHUHHbaVmX5J91ZsHMny+
 Sf3SSmoVt9kuW+aJgpPzk/jWHEDn9VVfEboLyY6dLhgY7/1+OzK7mtRhmy7uSCFijIyr
 DPNPZ27GmcW3LA2PNV5QhivEIZNmfxLb4ijyB22M7eliIcOyJr7/0jBgSVrvUeZALUDY
 E/A86W3bkAxbwJcOisoR85JnOvJ8yv2gCX0OOuRYnIFIjW3gguw2auSFMBFgjZsy27Zc
 LYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=FhQOAPGriaJ90awBuK8zqjdKv78PGZubmhSGXhOpsOU=;
 b=ou24YkoXefZ5wVp8CK5EQ1w4EitoaNc5jN+WCPCQADnwqaHV+NeEW0GAInF+up+oaY
 6Hp+MFHiqOP/cme64pWqRjDUITslgdivx3aecUWbSnNhWwMie7QzQmQVZxz5RJqNYrVl
 rH5UOOfNp1EjKhcHxUe+DCkdl5ibdAnhOfYXWlfVtydENp7r0Jp3p7lW3c4Wv29D4b4v
 38tdPe1OWKP7HGrxRlOc8y7BWJvwOltM3MuUU8G9dTGp3tjXsYqYh9UmRBmhCMyvP7oR
 jQlSyEEOimeHKrBqchKa2+/ywy+Rzy5wJGlbq0oZsBGaKyG5H6oR/mNTDc+mN55vXU2c
 5b9A==
X-Gm-Message-State: AOAM531UOlRyf0fkVfD/VSX9UWqPhChCijUwegozfCsa3dNQm5SpQ7xR
 eFv06UK3j9odfkRdIixsM1k=
X-Google-Smtp-Source: ABdhPJysnuY1B6OBDOm07qZYHEzp4gc3FPKgkCLtJYvJiUsHxlwskqu3IAXmibYmkfhtVSIXogVIHg==
X-Received: by 2002:a05:622a:1452:b0:2de:6ed5:6230 with SMTP id
 v18-20020a05622a145200b002de6ed56230mr4682893qtx.619.1645608479002; 
 Wed, 23 Feb 2022 01:27:59 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
 by smtp.gmail.com with ESMTPSA id 18sm1691485qtx.88.2022.02.23.01.27.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Feb 2022 01:27:58 -0800 (PST)
From: cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To: maz@kernel.org
Subject: [PATCH] KVM: arm64: Remove unneeded semicolon
Date: Wed, 23 Feb 2022 09:27:50 +0000
Message-Id: <20220223092750.1934130-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Mailman-Approved-At: Wed, 23 Feb 2022 06:02:29 -0500
Cc: will@kernel.org, catalin.marinas@arm.com, Zeal Robot <zealci@zte.com.cn>,
 linux-kernel@vger.kernel.org, Changcheng Deng <deng.changcheng@zte.com.cn>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Fix the following coccicheck review:
./arch/arm64/kvm/psci.c: 379: 3-4: Unneeded semicolon

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 arch/arm64/kvm/psci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 0a00ef250725..3b16dae4ab3d 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -376,7 +376,7 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 				ret = 0;
 			}
 			break;
-		};
+		}
 		fallthrough;
 	default:
 		return kvm_psci_0_2_call(vcpu);
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
