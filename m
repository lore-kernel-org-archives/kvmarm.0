Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5FCC63798
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 99E762222C
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:16:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="JQlCWex6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99E762222C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 372B14B517;
	Tue, 17 Nov 2020 13:16:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ReGuAOHYZUvm; Tue, 17 Nov 2020 13:16:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A26E4B6E8;
	Tue, 17 Nov 2020 13:16:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 001264B874
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9WT1sYTQCdJ4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:16:56 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C3204B8C4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:16:55 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id f4so13375233wru.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=9NJwaj6H9dpl3R5GKvz3RD0FPuXlHhNUuulS5FTh3Hk=;
 b=JQlCWex6GQEr90aD+Xq83dUt3R1pZAtX7hpfO3tXPKjNHdQDhvuF4w7p9Uq1cYYUYD
 0qrdweQ40YIYcJpB0rKkgokebr+IL6PKzeAVgT/WlcVavgVeGC39u48slN1Uf9VaNibF
 7mREaFFzfgYyEmzz/EM0L6NqrHnXIhZ0MgyYVApx8H6kpW0muE4kg6NHnwBm0Z89W6HC
 BnINsKivgdOVXfLE+ZlQWsr02uvo74sizwj9Y/eaZ3zIO9kF8K2u6C6mTeKsGxWotXkK
 amR0Q5jpJ0Dgqi7rng0ETiiuwY82ca7PMq+gKYVBGnztUjGQQ+TpyrGRWn42mo1p7mPT
 J0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9NJwaj6H9dpl3R5GKvz3RD0FPuXlHhNUuulS5FTh3Hk=;
 b=g5uo1Qo9kWbHSJdutHR6XpoStaLaU8C8+X+TpCaWy4PrBVr15Yxy8ygOJM/qaXcM+c
 uLKEnG4GQ6lx/dQJfmCcA3/qRf1Vc4HbYwWoq70kFV4Ufwb5dqSSmg/qxwcaReESPVBO
 DGAPv/UiuJdvjzQgxC9z5mlTDRfXUzS+8sMhcybGwSIptwuH97Xom1Ttgof6SyelyH2D
 9guB/D2XBVHIdheneDDenuToADiVUL7YshBEkTH2KDp0Vldkwf4S/VZT+f9OVRiBMZFF
 L/1Fm/GNN+3QCFG7NU/s4jMqLbI2kh5cMDKe4aSgGnEJ30Q3Myco2aTOMiONSYuol+q5
 dUdg==
X-Gm-Message-State: AOAM5329rQlKC8P+CmLhK5Qs9vSrELov68ArF4Od2C4BVuVaKNRw3chI
 0PoR42L0Qk4EGgeynLXa3e6H+oqLouWD
X-Google-Smtp-Source: ABdhPJyGVJgIcTCT/DdbnY1gsliRaeUzyr2tI4CihTRnunVErPVhmxXy6EImfhV9SGx6S5piiKOb6bkx3WEt
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a1c:44d4:: with SMTP id
 r203mr394378wma.60.1605637014324; Tue, 17 Nov 2020 10:16:54 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:55 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-16-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 15/27] of/fdt: Introduce early_init_dt_add_memory_hyp()
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

Introduce early_init_dt_add_memory_hyp() to allow KVM to conserve a copy
of the memory regions parsed from DT. This will be needed in the context
of the protected nVHE feature of KVM/arm64 where the code running at EL2
will be cleanly separated from the host kernel during boot, and will
need its own representation of memory.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 drivers/of/fdt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 4602e467ca8b..af2b5a09c5b4 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -1099,6 +1099,10 @@ int __init early_init_dt_scan_chosen(unsigned long node, const char *uname,
 #define MAX_MEMBLOCK_ADDR	((phys_addr_t)~0)
 #endif
 
+void __init __weak early_init_dt_add_memory_hyp(u64 base, u64 size)
+{
+}
+
 void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
 {
 	const u64 phys_offset = MIN_MEMBLOCK_ADDR;
@@ -1139,6 +1143,7 @@ void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
 		base = phys_offset;
 	}
 	memblock_add(base, size);
+	early_init_dt_add_memory_hyp(base, size);
 }
 
 int __init __weak early_init_dt_mark_hotplug_memory_arch(u64 base, u64 size)
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
