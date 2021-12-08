Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB22C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 19:28:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FABF4B10B;
	Wed,  8 Dec 2021 14:28:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7xd-paTgQqDH; Wed,  8 Dec 2021 14:28:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B0884B125;
	Wed,  8 Dec 2021 14:28:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3910D4B10B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 14:28:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TkxT6fzYR0Yp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 14:28:13 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F2A2C4B090
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 14:28:12 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 l4-20020a05600c1d0400b00332f47a0fa3so1721428wms.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 11:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=uFbTewYPIohmdOsJ5vp7sbi30zzOHewDKLeIlU197Fo=;
 b=I1qKv+eLPwQiFUQsEh47h7AKXKrOT2s/kYR/89wlawfCEiq+pk5dVVroGUDsXWQM3b
 /lbe2jTw50DrUPzbTOE3V0rfcGKrDRpwbBCHwUnFn/vilaBcBYl1dJxl0U9fkx86Ri4T
 qPrGyT5K6b+5O79W4p6HV2MqhpU5kO9bkuuuHMiJYzrmJstvtGH4gPRTSFWj6fkFvnGJ
 8donjBNUIx+cbaSPZccQGQ93QnFvmP19Zvb62QRKgRZ+C1ADEYPtwOXOu3XYZ7komjK+
 FDbju9NmaBaMr9a0T6zy6knSoUcNNYjyAPHy/Zw2LLklIfMYXqrYmPbihkwSM8zVp0xv
 Znnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=uFbTewYPIohmdOsJ5vp7sbi30zzOHewDKLeIlU197Fo=;
 b=dRIn6jcsyRqH2dFuG+gXMCNmSSzlTh/IyGuSPXUM7DxG233tlwXykIBL0WUAFjuPm7
 tssY9iz8iYBu78Z3HjtCXZupyidS0w/wHDQqnBp2w6XSmFilPODR205bz0wIjpkO9oqO
 3Yz4f/kV795563Y3jg7hPOOyd7e721r4GUS3lw7DRdIhin1/L41uXS5IOHqUOjmQngUU
 ilYoDYu+hTXus8KzgDaUeazdn84rRVWn1H2rsVJ5bsFV8QYwgHfqcQIOuSkw8xZauayP
 a6wzo4Pwhw7qzJZePfnI8mTPIV2+/rK0jSuBm3AKiuwEU3nOpzYDlL0/WLGhyGLEJ/Wi
 1sow==
X-Gm-Message-State: AOAM530bmaWMeCseLj/6vo5/49Gr2apDSevXCOfYhPG4loQTL7hjoU5E
 4RPagYuFd/87+5he3czBaV8NpMwKAKlffYluJd60RJuuMFy07ep9GEWBorbB/rDL5md0aqWUZCI
 oyQffZYOh6+5Wm1v0LbaoMAm2Jpb8SU7QXtSiQVEV4Gp43kK0FqmQvtlwNUU94kztUys=
X-Google-Smtp-Source: ABdhPJxczzY7Z1F5bpB61l4SwAYHgac34yybGImOr/h5YO8e2u/axy2wxHlHoBGPlesTVvlL30qroA3ddg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:46d0:: with SMTP id
 g16mr710895wrs.605.1638991691851; 
 Wed, 08 Dec 2021 11:28:11 -0800 (PST)
Date: Wed,  8 Dec 2021 19:28:10 +0000
Message-Id: <20211208192810.657360-1-tabba@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH] KVM: arm64: Use defined value for SCTLR_ELx_EE
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

Replace the hardcoded value with the existing definition.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f4871e47b2d0..cd5fd9b92b04 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -386,7 +386,7 @@ static inline void kvm_vcpu_set_be(struct kvm_vcpu *vcpu)
 		*vcpu_cpsr(vcpu) |= PSR_AA32_E_BIT;
 	} else {
 		u64 sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
-		sctlr |= (1 << 25);
+		sctlr |= SCTLR_ELx_EE;
 		vcpu_write_sys_reg(vcpu, sctlr, SCTLR_EL1);
 	}
 }
-- 
2.34.1.400.ga245620fadb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
