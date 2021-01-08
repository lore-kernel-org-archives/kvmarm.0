Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59962C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD8E223A21
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:16:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD8E223A21
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76E384B3DF;
	Fri,  8 Jan 2021 07:16:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ht4Qm9lk4vui; Fri,  8 Jan 2021 07:16:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AB3A4B386;
	Fri,  8 Jan 2021 07:16:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A562D4B412
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:16:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0A2ht9wyNdYC for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:15:59 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8BFA14B40B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:59 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id w8so4068258wrv.18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:15:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=7wQIE5XecZh/pAi+A9ahJ0JiP2BIW9kKktEGdKjk9KE=;
 b=A8PxRTnMwBpbyy3mjy7HcZVKT4lcOkB6tCxDtqR0LOEWgzLXSW1lJKcuTnVfX5uu1/
 jEpCOtIwnUA6Uui3Zv+q3w+TGLuWznDsE+qg8r9wx5p29uGmwnaWocLUmC/y6c+VyPQR
 JXTLKVSCPBeri30E44X4gWfFGk6vhc8hUAWuFi91Y/XmSgxFa9zzwfapa5aRNyF0pqcX
 W+FbQGjkGPLb6qITvlNZvexo7Qlg1gJ/bFXZdVD0DPrawILRu3CDrLNQmjmLAQBP+SE7
 aXSaZX+KY+NRDYk5QN4FYmPthdCftGMPdExRyClSUnhfXCNXEl/a/ZGyv9b8Z98mpNJ/
 y2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7wQIE5XecZh/pAi+A9ahJ0JiP2BIW9kKktEGdKjk9KE=;
 b=LWLdXSI5NqZ1Mj47nAdhQQw/7ELhfpOrP5+a99DqQsTIVnOV81iYJ9sY3XjLtvOcfP
 lIjmhIMZzQgmkcPVvQCxS1tU1sT7I2nW/2e4hqJQDER3mJ959YsycFHDLxEo8Vm9M3Kw
 ZYB212NtmoeqNptVU0Yo4ZfYHX/DbOPasHqTCVx8IUM93Uv0Ehow37T3cwPDVM5LAnBa
 66KG00+yW32O9/iiQhOUY8UDjxiG8+2c3ZAyJclGEqJW+SpxFk6N7hYZeKDVHMai1Wic
 h53WlEJfdqI0SQZaEoUQnLjXTlOV38Pd9h6XTqene18HTaqkBg4Ke7N7svpK6ytUpXTi
 g4oA==
X-Gm-Message-State: AOAM532L0JGN8c+ynqQNNgaQcwz5xC0YFFxGXL7L6l2ZCoHoViLQnLa2
 pgybAD42byBGb1kE950q8L1THPhRTZ3K
X-Google-Smtp-Source: ABdhPJzSE1Qnh3bmoUiNpT3+OMdMwVfkpG80eqm+sA8SoXeBjeN9dqGurdaqfhYzIGM73v4r+iFahg4hIkFI
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:c044:: with SMTP id
 u4mr1783959wmc.1.1610108158307; Fri, 08 Jan 2021 04:15:58 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:13 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-16-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 15/26] of/fdt: Introduce early_init_dt_add_memory_hyp()
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
