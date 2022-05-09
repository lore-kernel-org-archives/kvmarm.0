Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77FDC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 16:26:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DD2E4B302;
	Mon,  9 May 2022 12:26:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id M65mLcRHX9KS; Mon,  9 May 2022 12:26:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C8204B306;
	Mon,  9 May 2022 12:26:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 046714B1B5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:26:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OtQqNCAYxmIZ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 12:26:15 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA6DD4B20F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:26:15 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 cn13-20020a056a00340d00b0050e0f04e467so4931983pfb.21
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 09:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ramO0+cEkxqJX3F8coHgv6jkuFbFeK102oolsavMu20=;
 b=dzr2hls94IW3ClUuA2BSr4qrrnhWvuyEZI8nmXUIdiJHGzCNV42d2pewDNyyq80z8v
 bWsUx/m5Ue/BW1YKhvz5ey2N7GtbjeXfSalL431rTrIhm9CbPH2N7m/FTSxFsyeD3qUp
 vXJqArAH9zH6NJ6jgi3AYOdxSAZQ/zZ5hPibtfe7o8lwCwTgu6Cz50/+wdJ7XGjzpShB
 ARsg0FK+LbtIxB0pYfEVUWq8IWxV5K/BYzouxazPSfK7emCZnaAacA2ohaNp1x+3aIGa
 jyR/0vEsVlbDWN+XzL8wXDCFCcrU9hSGVTMq87y7rn8FTavQQDuIBOI5u0j2wnP/e64n
 LqNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ramO0+cEkxqJX3F8coHgv6jkuFbFeK102oolsavMu20=;
 b=tPcCmrM+ugbgMB7Hs2djcPBuh5Sk7gYhYX+sYM3e0qbJ+NYV2UohfWjdqC0mpK03sh
 9TTwVfgwSwpv8sbwCzYd825tIJ5/ZJYL4Y2gsi0181oNcn1dROgSEH6h2w+InNGVDYkv
 plGgBfrTfLYUqDvOn63vEAyBZOYaPEbguwZfSS8zfzajbwjISSiJUahnSxQTHRAxxIgZ
 2NnJWLpG7BH1tW3dx9fu5th0qlkRidMLncRM7D8gaTKntsj4V+8qdW188Ati/X0l1ulj
 oAdxm7pg+fdWgQzye+TWhaJZkpusFEx1tUzbOEnOL0CHnggFRZnAkoZ6jwwjsuEuWbO4
 OB8w==
X-Gm-Message-State: AOAM531xp3uELram83X8SARk8QUKF4nK72GK8YSdaTurbq1voEWW/fkK
 tWL+r6N5xFgvH94qxdhd/o4vH6RtBEase3eTC+lG/uzKd2L6R1ErLWYBqFLIve9AVqwlg/uXR+H
 MMcZHxv2rTyvTGyWnKryWvTTQdmuszDct94Hl9ocrWYCKi3xN7J0mJKfNTdwvpledpYvoPw==
X-Google-Smtp-Source: ABdhPJzdjvmm33Xww7qbolbHONdNzfLPiXVqOOHjncbxPv2g5srfZyPR6YVyWtFPJJJKmTvTXT956abVHGQ=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:902:e74d:b0:15e:94f7:611e with SMTP id
 p13-20020a170902e74d00b0015e94f7611emr17008035plf.37.1652113574927; Mon, 09
 May 2022 09:26:14 -0700 (PDT)
Date: Mon,  9 May 2022 16:25:58 +0000
In-Reply-To: <20220509162559.2387784-1-oupton@google.com>
Message-Id: <20220509162559.2387784-2-oupton@google.com>
Mime-Version: 1.0
References: <20220509162559.2387784-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH 1/2] KVM: arm64: pkvm: Drop unnecessary FP/SIMD trap handler
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

The pVM-specific FP/SIMD trap handler just calls straight into the
generic trap handler. Avoid the indirection and just call the hyp
handler directly.

Note that the BUILD_BUG_ON() pattern is repeated in
pvm_init_traps_aa64pfr0(), which is likely a better home for it.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6410d21d8695..3dee2ad96e10 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -175,23 +175,6 @@ static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
 		kvm_handle_pvm_sysreg(vcpu, exit_code));
 }
 
-/**
- * Handler for protected floating-point and Advanced SIMD accesses.
- *
- * Returns true if the hypervisor has handled the exit, and control should go
- * back to the guest, or false if it hasn't.
- */
-static bool kvm_handle_pvm_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
-{
-	/* Linux guests assume support for floating-point and Advanced SIMD. */
-	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_FP),
-				PVM_ID_AA64PFR0_ALLOW));
-	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_ASIMD),
-				PVM_ID_AA64PFR0_ALLOW));
-
-	return kvm_hyp_handle_fpsimd(vcpu, exit_code);
-}
-
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
@@ -207,7 +190,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
 	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
-	[ESR_ELx_EC_FP_ASIMD]		= kvm_handle_pvm_fpsimd,
+	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
