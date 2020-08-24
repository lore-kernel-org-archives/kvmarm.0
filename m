Return-Path: <SRS0=9KKW=CC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01DCC433E3
	for <kvmarm@archiver.kernel.org>; Mon, 24 Aug 2020 18:36:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A3EE52074D
	for <kvmarm@archiver.kernel.org>; Mon, 24 Aug 2020 18:36:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oqFFumLn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A3EE52074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CA904CC8A;
	Mon, 24 Aug 2020 14:36:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1dIb-Jy7b+6c; Mon, 24 Aug 2020 14:36:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65B984CC23;
	Mon, 24 Aug 2020 14:36:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AD014CB32
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 14:36:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a4bm7d+Sj7f9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Aug 2020 14:36:26 -0400 (EDT)
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com
 [209.85.210.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 57A8F4CC89
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 14:36:26 -0400 (EDT)
Received: by mail-pf1-f193.google.com with SMTP id d188so5304048pfd.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Aug 2020 11:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id;
 bh=zpnmRNIKkvjV2LPN01BqZu47Eb5w1mM1AyOClAtFrXI=;
 b=oqFFumLnpfknRGNiLUr2NDUPgiJonX285ro4dRlKv26w5hXD7FQPXcSSmJFKFNOrfu
 mJ/7vbLmealdw4NJnHRCKxzyKgsz159CS8BlAqAyf2gn6Tz5M4vrU3AhXQ1RlyNDZP8k
 5y2gkUjrArlhXwYAM7L4HywPst/WB1TP1BL/LWgJSpZAXIIDeoF5mbvWg2ntUSaVa4Zy
 YzfV+KH4TDu22vFFlebI+l98hH7/NN6i/HouH7ze7r2YLkjKZX6XILa5jexgey3LxeX2
 PrbbinG71YVnJ7JX8PFgfCmzk56CApyqVWko/GZrMSbxNmDRIoMXZtnlrm7/7uHDeBsh
 mg4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id;
 bh=zpnmRNIKkvjV2LPN01BqZu47Eb5w1mM1AyOClAtFrXI=;
 b=aSWd1QPUSCRP64YfH67XoXywFencPDplQs7lLMtEb1+Oopc4wko3sVKgjYcj3GG8Wh
 2g0dVZuQypAzi4/1raF5udZbwMOsKJuUNHZboz5qsOvmDKtTazLpR8x0x7b6QNpIp9Cp
 Ki1pPvStrVJ+G9KxFNJ5fFH0YBvmZZ+zyVnluVGfss4AWn0h6qiDoJtsto36gbSTff8r
 9Tpk9GYZWtYB7CWPJF5TPeVx0CLCpw47hanvKk3hJgKEzy+oqsKfPIRCN59RYNF5TW2/
 ND6zlQ0a3f169qh3J960VrLUrvANb7fSwo/VTFiS46vEWeykjNSBv/6SVgF6OWY7mP+s
 nfqA==
X-Gm-Message-State: AOAM533due6U8Tph56f3ksllJ3O8pesR88umNYYoNYxexbNmfVWomhga
 m/l1LW8hBj2NjoK3PRiDR5c=
X-Google-Smtp-Source: ABdhPJzA74PH6fkzfA54h84m1jubls9NcJ307f/XM+aVW17ppXCAHQIMS5mz8GGn93A4L1wrXAjgYQ==
X-Received: by 2002:a17:902:8509:: with SMTP id
 bj9mr2360001plb.172.1598294185558; 
 Mon, 24 Aug 2020 11:36:25 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id u191sm10235065pgu.56.2020.08.24.11.36.23
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 24 Aug 2020 11:36:24 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH stable 4.9 v3 0/2] arm64: entry: Place an SB sequence
 following an ERET instruction
Date: Mon, 24 Aug 2020 11:36:20 -0700
Message-Id: <1598294182-34012-1-git-send-email-f.fainelli@gmail.com>
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

Changes in v3:

- included missing preliminary patch to define the SB barrier instruction, see
  patch change log for details on how it was back ported into v4.9

Changes in v2:

- added missing hunk in hyp/entry.S per Will's feedback

Will Deacon (2):
  arm64: Add support for SB barrier and patch in over DSB; ISB sequences
  arm64: entry: Place an SB sequence following an ERET instruction

 arch/arm64/include/asm/assembler.h  | 13 +++++++++++++
 arch/arm64/include/asm/barrier.h    |  4 ++++
 arch/arm64/include/asm/cpucaps.h    |  3 ++-
 arch/arm64/include/asm/sysreg.h     | 13 +++++++++++++
 arch/arm64/include/asm/uaccess.h    |  3 +--
 arch/arm64/include/uapi/asm/hwcap.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 22 +++++++++++++++++++++-
 arch/arm64/kernel/cpuinfo.c         |  1 +
 arch/arm64/kernel/entry.S           |  2 ++
 arch/arm64/kvm/hyp/entry.S          |  2 ++
 arch/arm64/kvm/hyp/hyp-entry.S      |  4 ++++
 11 files changed, 64 insertions(+), 4 deletions(-)

-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
