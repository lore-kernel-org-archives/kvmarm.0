Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883EBC6FA91
	for <kvmarm@archiver.kernel.org>; Thu, 22 Sep 2022 09:53:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1402E40DAE;
	Thu, 22 Sep 2022 05:53:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@chromium.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3nHsDc9JXMtS; Thu, 22 Sep 2022 05:53:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A26143C8C;
	Thu, 22 Sep 2022 05:53:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DB61410F3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 01:32:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9X3lzmC0zQvs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2022 01:32:55 -0400 (EDT)
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com
 [209.85.216.42])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A459440AF2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2022 01:32:55 -0400 (EDT)
Received: by mail-pj1-f42.google.com with SMTP id go6so8681136pjb.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2022 22:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chromium.org; s=google;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
 bh=eaz6ZZzobVs4ZGOrwYHQM/Kk9ITDhPdxEg8Bt1PkbOo=;
 b=gp1syXD960EDwksWcE/cXsJC6FBR/7T41asUdURa6KbF0WHbYvX/7JgyZkJnR31xSW
 R2QN4ser1APqmuvLWX5c8pdcbH/HbZE40zup5CLKwRM9kbiBNW5PyqcUthnYUF2uQzro
 3+082TC7dgU7d9QVdJdjgUL9PoeIRL0iJy1x0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date;
 bh=eaz6ZZzobVs4ZGOrwYHQM/Kk9ITDhPdxEg8Bt1PkbOo=;
 b=lrhyv2DsSsKeTp2aak3OxTtSp/3XoGS002cVpMFcBfjZbU0gzFM0rvmPDOPmPvl+Us
 +KLhdEnPsjoNlBrMRQUvIyGBhBJTdDcCwpiWT45t/MO61qrc0LNBuDAWP0Q9YSKQcVTd
 XXNCCMFKT9GNaYyxbu94XgT6SK3LZka5LvVOUmMHyKWWt5nsZzdQTzl0GhHFETfz5zzo
 liUGushpsQGeLFRIpg54ybkQb/OQUhcsnFTkhPzkRe5RVOgnzUL3t0SdMscPBpmTJ1iE
 f5vFAk/RmNNqj019PSj/kGFtu2uyYyGz0V5qgn7LfXeTFsD9Slcvx+qqqu2uQCI/bjsv
 vewg==
X-Gm-Message-State: ACrzQf343TQ+NYtmUxPdXBZxRhAdgxIDQjvArNOBZiiaV0JNn/vwHANz
 JN0+ztakDTMnU7txC5QfX9N+cQ==
X-Google-Smtp-Source: AMsMyM7HqZ7Z3byol1GnlGc5Fi7MDzpmzIZjyH6g+1U93zDQm5u+l5l7g/ZrmPjsCSBhDGWebRc+FQ==
X-Received: by 2002:a17:903:41cb:b0:178:36c2:a98 with SMTP id
 u11-20020a17090341cb00b0017836c20a98mr1553573ple.47.1663824774600; 
 Wed, 21 Sep 2022 22:32:54 -0700 (PDT)
Received: from localhost ([2620:15c:2ce:200:5e9f:5b94:af12:8e6d])
 by smtp.gmail.com with UTF8SMTPSA id
 m1-20020a170902bb8100b0016d5b7fb02esm2984746pls.60.2022.09.21.22.32.53
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 21 Sep 2022 22:32:54 -0700 (PDT)
From: Denis Nikitin <denik@chromium.org>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
Subject: [PATCH v2] KVM: arm64: nvhe: Fix build with profile optimization
Date: Wed, 21 Sep 2022 22:31:45 -0700
Message-Id: <20220922053145.944786-1-denik@chromium.org>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
In-Reply-To: <20220920082005.2459826-1-denik@chromium.org>
References: <20220920082005.2459826-1-denik@chromium.org>
MIME-Version: 1.0
X-Mailman-Approved-At: Thu, 22 Sep 2022 05:53:07 -0400
Cc: Denis Nikitin <denik@chromium.org>,
 Nick Desaulniers <ndesaulniers@google.com>, linux-kernel@vger.kernel.org,
 Manoj Gupta <manojgupta@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Kernel build with clang and KCFLAGS=-fprofile-sample-use fails with:

error: arch/arm64/kvm/hyp/nvhe/kvm_nvhe.tmp.o: Unexpected SHT_REL
section ".rel.llvm.call-graph-profile"

Starting from 13.0.0 llvm can generate SHT_REL section, see
https://reviews.llvm.org/rGca3bdb57fa1ac98b711a735de048c12b5fdd8086.
gen-hyprel does not support SHT_REL relocation section.

Remove ".llvm.call-graph-profile" SHT_REL relocation from kvm_nvhe
to fix the build.

Signed-off-by: Denis Nikitin <denik@chromium.org>
---
V1 -> V2: Remove the relocation instead of disabling the profile-use flags.
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index b5c5119c7396..49ec950ac57b 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -78,8 +78,10 @@ $(obj)/kvm_nvhe.o: $(obj)/kvm_nvhe.rel.o FORCE
 
 # The HYPREL command calls `gen-hyprel` to generate an assembly file with
 # a list of relocations targeting hyp code/data.
+# Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profile'
+# when profile optimization is applied. gen-hyprel does not support SHT_REL.
 quiet_cmd_hyprel = HYPREL  $@
-      cmd_hyprel = $(obj)/gen-hyprel $< > $@
+	cmd_hyprel = $(OBJCOPY) -R .llvm.call-graph-profile $<; $(obj)/gen-hyprel $< > $@
 
 # The HYPCOPY command uses `objcopy` to prefix all ELF symbol names
 # to avoid clashes with VHE code/data.
-- 
2.37.3.968.ga6b4b080e4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
