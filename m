Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FBACC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 20 Jan 2022 17:39:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0C3F49E38;
	Thu, 20 Jan 2022 12:39:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vDwPF9JH5SIx; Thu, 20 Jan 2022 12:39:11 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD56E49E3F;
	Thu, 20 Jan 2022 12:39:11 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA74849E38
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jan 2022 12:39:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 50CJQ5y3CWGZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 Jan 2022 12:39:09 -0500 (EST)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8997149E35
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jan 2022 12:39:09 -0500 (EST)
Received: by mail-pf1-f202.google.com with SMTP id
 z20-20020aa791d4000000b004bd024eaf19so4238109pfa.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 Jan 2022 09:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=YE99vojQD2AxPQSWB/44jVS0Qb0ZYbLu9xs6WG/RgmY=;
 b=D6LYnL518npfbdVeQXIesu0zquom0i1+sfkMdjABkguXDWxwAoLo4dmjtrX4/t1fyC
 SfUBX9J6Dv+QtXM06M8qeaEifOHS7MWiLcAPaa4Y/3VQXOBRz7OXK2kdJAFSQEcXIA7c
 cOCHmddd1EMevUnWCjZhIZDO1ES2jg2QsLwyqLmK2HHa/Hlvv8p52tahLZFbyCFNYWHi
 lbQxzJE/dNOf17RGJqptAa9304lgCY1U7RMGpjIlRzATlJHnrN/ZNdphWq1qEPSz1Ai0
 qFSql/7qsjaaLC3Zq/UTrUU/+L3QH09L1VYK4hotZTzDtTwr3fcVyco+9q7Mvy8fB4P8
 GT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=YE99vojQD2AxPQSWB/44jVS0Qb0ZYbLu9xs6WG/RgmY=;
 b=Pyfvqr2nBJWuK6yqwjLe28+s+anucu28213cc5ImQkqc/AXLSfqfyZJ0pwsRt+j2PM
 fZZSza7cT9uU24Kheh4cYT9jU0bwD8wwMfvhc77Sag4Wp1Ixqfzvopv+dMBFNJ2WWSL7
 QC7tX9AfRuuyKSBza1udMLj79RiJY2yWi2tmtG4xGiRLkdJToMZD7yEwV/36s3/SzCZA
 HYYq/5AEWBER8xxHZ9xNg58xi6mk9t2JVVifA0zPRvKPrMvWMsUifBYYJhQCyHsGMTty
 LiRhLuNQMqZVoe45363J2aT4svA+U5swCWSA9Rgfndzutbr2/m19R0RiP5Te9TImuFiF
 K6Pg==
X-Gm-Message-State: AOAM533deOKmP2qrGCuOHgY3JopPVde/bmg7dsU8ZdDYOq/8pfNuvFye
 cm36W7WNDhFI2F5p0jddhDoukyZHD01KaQ==
X-Google-Smtp-Source: ABdhPJy97Lg4jLb/CtetkWy0ICvzz47NCQ+mT9Hlb27wuiusZjTfw0b4KdBOMMenlF8DLQ82HlI7DiWyqcF07g==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:81cf:0:b0:4c0:6242:c14e with SMTP id
 c15-20020aa781cf000000b004c06242c14emr3040pfn.83.1642700348410; Thu, 20 Jan
 2022 09:39:08 -0800 (PST)
Date: Thu, 20 Jan 2022 09:39:03 -0800
Message-Id: <20220120173905.1047015-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 0/2] kvm: selftests: aarch64: some fixes for vgic_irq
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
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

Reiji discovered some issues with the vgic_irq series [0]:
- there's an assert that needs fixing.
- there are lots of comments that use the wrong formatting for comments.

I haven't hit the failed assert, but just by chance: my compiler is
initializing the respective local variable to 0. The second commit is not
critical, but it would be nice to have.

This series applies on top of:
[PATCH] kvm: selftests: conditionally build vm_xsave_req_perm()
The aarch64 selftests fail to build otherwise.

[0] https://lore.kernel.org/kvmarm/164072141023.1027791.3183483860602648119.b4-ty@kernel.org/

Ricardo Koller (2):
  kvm: selftests: aarch64: fix assert in gicv3_access_reg
  kvm: selftests: aarch64: fix some vgic related comments

 tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 12 ++++++++----
 tools/testing/selftests/kvm/lib/aarch64/gic_v3.c | 13 ++++++++-----
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   |  3 ++-
 3 files changed, 18 insertions(+), 10 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
