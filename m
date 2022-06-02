Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8128BC433EF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jun 2022 08:56:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED1FE4B33E;
	Thu,  2 Jun 2022 04:56:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id agKyvcQd2rDE; Thu,  2 Jun 2022 04:56:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71B174B2D2;
	Thu,  2 Jun 2022 04:56:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB7814B26A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 22:48:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6MKgPXVKdl4s for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jun 2022 22:48:14 -0400 (EDT)
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com
 [209.85.215.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4ECD74B239
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jun 2022 22:48:14 -0400 (EDT)
Received: by mail-pg1-f193.google.com with SMTP id x12so3563066pgj.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Jun 2022 19:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=3Qfj25vgUy2vlco/zeYZvtjrkAOyeuWII5kfYsnOot4=;
 b=iyT3s4vc8TEPLRG7y0CG4QqFHA9bY7CIXg0cfL8UfJUL6xAj+EGtJwpVvqbvmWikip
 z1OL9HMXJ5f48LULyuSEmWzlDz64+2ZCWPKqVKlWS2ePApCFvbfUR19ZG/2aZpa3q70W
 Qhwpod3IUASWTZ6M4ns9VmX0CSs8jmJfTIFkn82srWvWtWfNcZqD8ZphHCszrJb9foj0
 Bux1Tf45K457djBsKMci3pvPo8OIJNbSToChxd1xucHyv32NVN2NEEUJjuqhNesdoIt0
 w8tnGznFoiljnnD4/P5/kiz3Y6N3Idk9ZZ4wvMFUUyHdEOffYYV6ooCutS0Lu75Ow1e4
 0iTw==
X-Gm-Message-State: AOAM531OittIRiEzD7xxOeGGzM3pazOmVk2s+tQmm9/LzY7/eClML+64
 TaJ/F5sVGM9hap1bE5cYnw==
X-Google-Smtp-Source: ABdhPJwj97f92+oKYJX3/nM4SU6Juy4SkU5cImZOTxgJnaFU3BKykF87LgnQ1Evw/0j5RBZ2qtDh1A==
X-Received: by 2002:a63:6a84:0:b0:3fa:e914:79b5 with SMTP id
 f126-20020a636a84000000b003fae91479b5mr2234833pgc.365.1654138093288; 
 Wed, 01 Jun 2022 19:48:13 -0700 (PDT)
Received: from localhost.localdomain (ns1003916.ip-51-81-154.us.
 [51.81.154.37]) by smtp.gmail.com with ESMTPSA id
 i3-20020a170902eb4300b00161ccdc172dsm2159645pli.300.2022.06.01.19.48.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 01 Jun 2022 19:48:12 -0700 (PDT)
From: sunliming <sunliming@kylinos.cn>
To: maz@kernel.org, julien.grall@arm.com, james.morse@arm.com, will@kernel.org,
 catalin.marinas@arm.com, suzuki.poulose@arm.com
Subject: [PATCH] KVM: arm64: fix the inconsistent indenting
Date: Thu,  2 Jun 2022 10:48:05 +0800
Message-Id: <20220602024805.511457-1-sunliming@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 02 Jun 2022 04:56:53 -0400
Cc: kernel test robot <lkp@intel.com>, kelulanainsley@gmail.com,
 linux-kernel@vger.kernel.org, sunliming@kylinos.cn,
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

Fix the inconsistent indenting in function flush_context.

Fix the following smatch warnings:

arch/arm64/kvm/vmid.c:62 flush_context() warn: inconsistent indenting

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: sunliming <sunliming@kylinos.cn>
---
 arch/arm64/kvm/vmid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vmid.c b/arch/arm64/kvm/vmid.c
index 8d5f0506fd87..d78ae63d7c15 100644
--- a/arch/arm64/kvm/vmid.c
+++ b/arch/arm64/kvm/vmid.c
@@ -66,7 +66,7 @@ static void flush_context(void)
 	 * the next context-switch, we broadcast TLB flush + I-cache
 	 * invalidation over the inner shareable domain on rollover.
 	 */
-	 kvm_call_hyp(__kvm_flush_vm_context);
+	kvm_call_hyp(__kvm_flush_vm_context);
 }
 
 static bool check_update_reserved_vmid(u64 vmid, u64 newvmid)
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
