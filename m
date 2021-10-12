Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B441FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4F4F461039
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4F4F461039
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 01AEA4B0F1;
	Tue, 12 Oct 2021 00:36:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gonlQjsC7ggq; Tue, 12 Oct 2021 00:36:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E89F04B093;
	Tue, 12 Oct 2021 00:36:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CAB54A531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Hsoi7HJVvrh5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:24 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 372E34048B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:24 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 d10-20020a621d0a000000b0044ca56b97f5so8241007pfd.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ydcMqLw7I27y2BCq9xNW2IjPYrEmatmYQFDkuaqb6Ys=;
 b=fIhPep5xebOqDQxahAlQRhWaep55nEzLGFccYceuEdkPcptnR+qdgdjVxdKBQOKL7j
 /tnOstI0GSmvqfOb4XGBwZzcrcDFLol9FioWZfD7GNS2DPRDWI68dqEvItZb0sgHLuHa
 jV/G1BuwMRyZxX+4fA7gQ2YkeeOZr/dW/JbplrSneEEVF63KHueJ5KvilT1j3lzTVa8n
 lxSSq5tcFDBVmjBEyq8gwcDpMGWwIx5GMmTvxL7XQEwRyejlBwuingxhY6gK7+Gg9hcU
 aewGN/fbd3gWPBIyL5NAMYGuvQv+7XyE1JGWJ84mqCibVWmSZuzlIUE3lNn0ErvlDlTN
 qeKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ydcMqLw7I27y2BCq9xNW2IjPYrEmatmYQFDkuaqb6Ys=;
 b=qUt31krUXNYI4VEpJsBhAer//0g6gkYbNgqlkdVJ2V5jdM6WP/ASJ0eWu5b4VO81QB
 +lQ61N0gaNBTaTkCBYYHGOCo3dGYbkcbfDS2hah1deyE+lKeYraLU9gwqdr1ELgVJtGm
 SFqggQvElcy477Pbwb8dhOdUharYUtlDlmCm2qGdjEngVbXv2Yt5e3ynsrCsgY6wu6nr
 Uh5J4y+bAYo4GbyncQhWE/FTgmGzMor972pNPt89AqMRedgfxJYSbH1eE5SYfu5juvGG
 BzcHKRSk0OVS149HSby7ZdNFnUhOllJN1Uth3fADfegW6iBouT73LT3lf+pZv8RYvFeM
 7ckw==
X-Gm-Message-State: AOAM533ig48m+RuObpMVM7fS55KIPfztE4R7CyZP+ikRiEXyDp12Fa4u
 Ju4k6lRgst2PAYxOHdX4tGjZ9tAAQp0=
X-Google-Smtp-Source: ABdhPJxJkSl8XzKYhkBIAFMBll8PIXQOz4AtNn7iEoWt6JG9RA/u+2uTfezIu6/nxTTDqGUsD6OE9/ryTQ0=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:140e:b0:444:b077:51ef with SMTP id
 l14-20020a056a00140e00b00444b07751efmr25307458pfu.61.1634013383274; Mon, 11
 Oct 2021 21:36:23 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:13 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-4-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 03/25] KVM: arm64: Introduce a validation function for an
 ID register
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Introduce arm64_check_features(), which does a basic validity checking
of an ID register value against the register's limit value that KVM
can support.
This function will be used by the following patches to check if an ID
register value that userspace tries to set can be supported by KVM on
the host.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ef6be92b1921..eda7ddbed8cf 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -631,6 +631,7 @@ void check_local_cpu_capabilities(void);
 
 u64 read_sanitised_ftr_reg(u32 id);
 u64 __read_sysreg_by_encoding(u32 sys_id);
+int arm64_check_features(u32 sys_reg, u64 val, u64 limit);
 
 static inline bool cpu_supports_mixed_endian_el0(void)
 {
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6ec7036ef7e1..d146ef759435 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3114,3 +3114,29 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
 		return sprintf(buf, "Vulnerable\n");
 	}
 }
+
+/*
+ * Check if all features that are indicated in the given ID register value
+ * ('val') are also indicated in the 'limit'.
+ */
+int arm64_check_features(u32 sys_reg, u64 val, u64 limit)
+{
+	struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
+	const struct arm64_ftr_bits *ftrp;
+	u64 exposed_mask = 0;
+
+	if (!reg)
+		return -ENOENT;
+
+	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
+		if (arm64_ftr_value(ftrp, val) > arm64_ftr_value(ftrp, limit))
+			return -E2BIG;
+
+		exposed_mask |= arm64_ftr_mask(ftrp);
+	}
+
+	if (val & ~exposed_mask)
+		return -E2BIG;
+
+	return 0;
+}
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
