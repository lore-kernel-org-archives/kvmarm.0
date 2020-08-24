Return-Path: <SRS0=9KKW=CC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9A5AC433E1
	for <kvmarm@archiver.kernel.org>; Mon, 24 Aug 2020 18:36:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6989A2074D
	for <kvmarm@archiver.kernel.org>; Mon, 24 Aug 2020 18:36:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p8uWuE3f"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6989A2074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E404D4CC8E;
	Mon, 24 Aug 2020 14:36:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RPEn2qMvGYLk; Mon, 24 Aug 2020 14:36:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 06DBE4CC82;
	Mon, 24 Aug 2020 14:36:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CC5C4CB32
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 14:36:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tyrp8-CNxdz4 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Aug 2020 14:36:14 -0400 (EDT)
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com
 [209.85.210.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EDBC4CB4F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 14:36:14 -0400 (EDT)
Received: by mail-pf1-f195.google.com with SMTP id u20so5309948pfn.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 11:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id;
 bh=Mgi/edooXghW4Zd3yyd7WPGuqwOMM4D+bYL209pO5J4=;
 b=p8uWuE3fPiZ0Pp9qw8tSQq7BTjAxEiI1WOb832pnYuHQt7KTp8jjD0cPiATO1Q5lNy
 bpQPk+tTF+nqLEesz9eWpZEU4/iy3M3FHb2rOUmUEsOKwqtH+ZYeXYNFMzNdfZj2o+o5
 7Fr3ad+9k73160OYspVSgPMHaCzaPBba5hhqQijOWqYeMjFXkGaZIag5juiW6mWyILz9
 bY0ffb8W7J6eCap6bY1ocxGZ43DFGGcuo/Eb+vk+TfGlrKavIa3uhGyGj1eo7y0HuDxQ
 H0LrTuxO1PPSLwsISrcLe37NQ6KVgigfKjasCIs/cxNoIRgz2+OsO5agYDgDmGt01oem
 2DGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=Mgi/edooXghW4Zd3yyd7WPGuqwOMM4D+bYL209pO5J4=;
 b=erA6hqJJHCoLb7Ft4ZHCPuHKwTfyVQ+inkpW/mm2X1mLbIyfsMvZr3fTdmXNz6fLdU
 RKp9oaPoMnrR1wGHE5xTXyvzyridF+yfA08rFimS+Oa2SKxlWCJuxlgD6S8QK4J1Qsrs
 WrlKHYaRWxrJbUCRuljTGb3lW9EpQMLveN9X5dvITzMik+C9PBD+3pn/bLpO37P7LYsE
 fT4/RLgen2pO4TN3J+64e05PWEgc9MLpH7lD/n9OVtbz2l3DWN/yJRBEMgdlblFmywFL
 0KXHciy/e+dIFAGZWXNGUG5cU0zg+3ieq4uVfOVObthIF/v8oWXixOh3Hx7jmT0dTH4B
 gkyg==
X-Gm-Message-State: AOAM533ofVqx8N2BbzFog4hfHZcEhk6cCqTbo3iESJedqicyGstNbJDz
 erdTFujxoMahJ91vHfjJxE4=
X-Google-Smtp-Source: ABdhPJwrIQSp72HY9BabcaRIpogAc40IuObj3piSlJR2SSB27J8pMVUHLXVwMPG0jF+LjKVPvA+O5w==
X-Received: by 2002:a17:902:c111:: with SMTP id
 17mr4540232pli.265.1598294173294; 
 Mon, 24 Aug 2020 11:36:13 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id n5sm10523099pgt.24.2020.08.24.11.36.11
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 24 Aug 2020 11:36:12 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH stable 4.14 v2 0/2] arm64: entry: Place an SB sequence
 following an ERET instruction
Date: Mon, 24 Aug 2020 11:36:08 -0700
Message-Id: <1598294170-24345-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.7.4
Cc: Florian Fainelli <f.fainelli@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Fangrui Song <maskray@google.com>,
 Marc Zyngier <maz@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>,
 open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Mark Brown <broonie@kernel.org>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 Sami Tolvanen <samitolvanen@google.com>, Greg KH <gregkh@linuxfoundation.org>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
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

Changes in v2:

- included missing preliminary patch to define the SB barrier instruction

Will Deacon (2):
  arm64: Add support for SB barrier and patch in over DSB; ISB sequences
  arm64: entry: Place an SB sequence following an ERET instruction

 arch/arm64/include/asm/assembler.h  | 13 +++++++++++++
 arch/arm64/include/asm/barrier.h    |  4 ++++
 arch/arm64/include/asm/cpucaps.h    |  3 ++-
 arch/arm64/include/asm/sysreg.h     |  6 ++++++
 arch/arm64/include/asm/uaccess.h    |  3 +--
 arch/arm64/include/uapi/asm/hwcap.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 12 ++++++++++++
 arch/arm64/kernel/cpuinfo.c         |  1 +
 arch/arm64/kernel/entry.S           |  2 ++
 arch/arm64/kvm/hyp/entry.S          |  2 ++
 arch/arm64/kvm/hyp/hyp-entry.S      |  4 ++++
 11 files changed, 48 insertions(+), 3 deletions(-)

-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
