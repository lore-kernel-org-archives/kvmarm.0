Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28047C433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Apr 2022 20:06:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C656D4B131;
	Fri,  8 Apr 2022 16:06:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OM3ziGsHFiFs; Fri,  8 Apr 2022 16:06:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD7C74B216;
	Fri,  8 Apr 2022 16:06:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 992C94B216
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:06:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eIff-ljfo1XW for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Apr 2022 16:06:46 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8C43B4B20A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Apr 2022 16:06:46 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-2dc7bdd666fso84856417b3.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Apr 2022 13:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:cc;
 bh=YMe3PswfejdLgJcOM+IwePz8bwgUsFhWIzC+X7TRk74=;
 b=SDDZXBLIrGsW+et2Gk7b5lo7cEr1tJz/aR/cf3Ij4+ew35M0VT5KBR5KSGpmpjWNs0
 t//I6PG91dmLQ0L+GdOs4DwU1OMe/Yx/qSbV1k+7vZXFzx0QN0lXXF/ixYjhR6PWOIQr
 TC/ECs0qk7HJ+kjf1KaePs3tnhpyqqwGpVGAOFK7RDKhHd//d00+yQtTVz+GbcUMjapS
 AEH8oI4W4DR8MfAuz6MzB3DsLtsTCcGT4X1Nv3ztd4QU1eun1xaJ2Oc64ok+h3V7kGye
 tN1MF+NuBtLwdfT4tEm/Hj+1ZFpWvjHUKG96fLQaAeenDWrFjcYU8knrJIHYkDWJf2H9
 ufVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:cc;
 bh=YMe3PswfejdLgJcOM+IwePz8bwgUsFhWIzC+X7TRk74=;
 b=VHuYV23vBRBI/duiCfhfU2j1eHTbIVs5TgpItWeHzpnhjUqj4d/Jz26CNqrjGw+1j3
 ujzVcdePu/6kuCp77mvsew0U4jdOSkTv20/0Ukaug2G+gcmFwlltBSVUJBG2DOvpHkoJ
 MmRZqU5GdzIJQlNZkQVjSNLvJpAB81whjyEsOXeWZxGjQoT9fDQ9gr1z6QoF1ytOi/jY
 UzykY6NpOZAfkgr+QWpg282Z0933KIoSU22Uqq8DLEGZ+8Ebh0hDXRGPx/DAcNzMpGjL
 E3rqfrLAPkVVrRwJ7FMcA2TErzMalIcHjVg1MPrKiaQXE8c3K0CIn2jF3HZhUMolTPBZ
 iuTQ==
X-Gm-Message-State: AOAM532J0tLFzzuGPCm03q5zco/GZZexa/COt4scZVgxpI8WT98rp3jC
 ebCaovir+qzXe+QfpDyf6RsQ3v1qxveFCAEjPQ==
X-Google-Smtp-Source: ABdhPJz7Xbg+YMlZC29IRqjeFluZOMCZUAs3P4FohGI67MZiTVA+Oxev9PNRndMoOAcC1cQHGV4y5em9Xs6NahFteg==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:f0ed:c8a:dab7:ecc2])
 (user=kaleshsingh job=sendgmr) by 2002:a25:9845:0:b0:628:99a6:55ed with SMTP
 id k5-20020a259845000000b0062899a655edmr15089978ybo.221.1649448406098; Fri,
 08 Apr 2022 13:06:46 -0700 (PDT)
Date: Fri,  8 Apr 2022 13:03:29 -0700
In-Reply-To: <20220408200349.1529080-1-kaleshsingh@google.com>
Message-Id: <20220408200349.1529080-7-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220408200349.1529080-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v7 6/6] KVM: arm64: Symbolize the nVHE HYP addresses
From: Kalesh Singh <kaleshsingh@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, will@kernel.org,
 kvmarm@lists.cs.columbia.edu, Andrew Walbran <qwandor@google.com>,
 maz@kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
 kernel-team@android.com, Nathan Chancellor <nathan@kernel.org>,
 linux-arm-kernel@lists.infradead.org, surenb@google.com,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Changbin Du <changbin.du@intel.com>
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

Reintroduce the __kvm_nvhe_ symbols in kallsyms, ignoring the local
symbols in this namespace. The local symbols are not informative and
can cause aliasing issues when symbolizing the addresses.

With the necessary symbols now in kallsyms we can symbolize nVHE
addresses using the %p print format specifier:

[   98.916444][  T426] kvm [426]: nVHE hyp panic at: [<ffffffc0096156fc>] __kvm_nvhe_overflow_stack+0x8/0x34!

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
---

Changes in v6:
  - Add Fuad's Reviewed-by and Tested-by tags.
  
Changes in v2:
  - Fix printk warnings - %p expects (void *)


 arch/arm64/kvm/handle_exit.c | 13 +++++--------
 scripts/kallsyms.c           |  2 +-
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 97fe14aab1a3..a377b871bf58 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -295,13 +295,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 	u64 elr_in_kimg = __phys_to_kimg(elr_phys);
 	u64 hyp_offset = elr_in_kimg - kaslr_offset() - elr_virt;
 	u64 mode = spsr & PSR_MODE_MASK;
+	u64 panic_addr = elr_virt + hyp_offset;
 
-	/*
-	 * The nVHE hyp symbols are not included by kallsyms to avoid issues
-	 * with aliasing. That means that the symbols cannot be printed with the
-	 * "%pS" format specifier, so fall back to the vmlinux address if
-	 * there's no better option.
-	 */
 	if (mode != PSR_MODE_EL2t && mode != PSR_MODE_EL2h) {
 		kvm_err("Invalid host exception to nVHE hyp!\n");
 	} else if (ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
@@ -321,9 +316,11 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 		if (file)
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
-			kvm_err("nVHE hyp BUG at: %016llx!\n", elr_virt + hyp_offset);
+			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
+					(void *)panic_addr);
 	} else {
-		kvm_err("nVHE hyp panic at: %016llx!\n", elr_virt + hyp_offset);
+		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
+				(void *)panic_addr);
 	}
 
 	/*
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 8caabddf817c..ad2c93640a92 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -111,7 +111,7 @@ static bool is_ignored_symbol(const char *name, char type)
 		".L",			/* local labels, .LBB,.Ltmpxxx,.L__unnamed_xx,.LASANPC, etc. */
 		"__crc_",		/* modversions */
 		"__efistub_",		/* arm64 EFI stub namespace */
-		"__kvm_nvhe_",		/* arm64 non-VHE KVM namespace */
+		"__kvm_nvhe_$",		/* arm64 local symbols in non-VHE KVM namespace */
 		"__AArch64ADRPThunk_",	/* arm64 lld */
 		"__ARMV5PILongThunk_",	/* arm lld */
 		"__ARMV7PILongThunk_",
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
