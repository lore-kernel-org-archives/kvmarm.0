Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45AC1C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCC9E4B1C9;
	Tue, 19 Apr 2022 02:57:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jf4OzuN5icMP; Tue, 19 Apr 2022 02:57:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9DC24B1D2;
	Tue, 19 Apr 2022 02:57:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C5D24B1BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MW+gDIF0BAG6 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:08 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2801A49F16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:08 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 t24-20020a17090a449800b001d2d6e740c3so764686pjg.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LynBrBVbmgX2+WvKy3gn9dzDYlX9Xj/PYcz4rcGsVrE=;
 b=pb47lvhf8Z//JVtjhi2MTUEc5TyUZmQkHhhcQiIH1B+gOsCUIuYhHDxjaeh/NBGruD
 IFmEFY99G7yvkW9vtGaRltiz96b+66iq4Rh7sr0f96aTkCVLuJkcOBCS1PEEciP7ykHd
 hlc5fldT3vIKA/dNwCChdCoF2CS7MWMzq1LM52cdaoTTb5Y3IHRjI3hiKBSNeKpTBv5m
 H+TZe3zZK2DqK+dch7uYj+Fxh0hnB/KMIcxzXboPM+2VoxuTshugY0WZKEO4aC+SK9tY
 xCmxr0oUqVp9JU/RAwQTGYsuLLsXAM3OaFoHv019JtwirkqTeevXBu8XaOfxbb3rJLMb
 3v6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LynBrBVbmgX2+WvKy3gn9dzDYlX9Xj/PYcz4rcGsVrE=;
 b=R7vvDg3MxWBHnOW81s5KKwTTumavAq94w6bzax5OArQuJo3+5WZ+jeB8nTush3X1oH
 vwnFUyH+cpw8qGv6MD811O7Q7XqYoFO8BDoL1n3vlT1RaK3D0p7jsFPV4lVqphpZ1Ykh
 MJq+AHwxOa+vwl41RiLVGrLHS7kMzX5dGOBiizmAWPlZxAww8g1TA7sf2ewWwOwsXP6v
 rzpT649pi6+kHV7ejA99JtJz4HQp/0NVGxRxyCiel0i2EjSOCETjMq/3MxZnpdAbBxiL
 m/atWe9EpKnuFrian3yekq5MavXSUULaZ72m5U+uFSlfDbgig2pUIUhDpgMbaYAyAr0P
 99TA==
X-Gm-Message-State: AOAM531H1+0b82TOKz9NwspwFEvF7iCYTdoVXZFTcft98g+ZP3TEgn/X
 qPIfEWFmG8ffCm8nfYvFkT+Vi1a7wVE=
X-Google-Smtp-Source: ABdhPJxvVqjBxl7SRv/CdH2AWZNC4bLBk9YbOJJ9z+CxzjQ12jRtsxSU318j3YETRdXG3BXKMjWxCiZkbks=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:9105:b0:1d2:9e98:7e1e with SMTP id
 k5-20020a17090a910500b001d29e987e1emr277559pjo.0.1650351426949; Mon, 18 Apr
 2022 23:57:06 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:07 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-2-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 01/38] KVM: arm64: Introduce a validation function for an
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
of an ID register value against the register's limit value, which is
generally the host's sanitized value.

This function will be used by the following patches to check if an ID
register value that userspace tries to set for a guest can be supported
on the host.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 52 +++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index c62e7e5e2f0c..7a009d4e18a6 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -634,6 +634,7 @@ void check_local_cpu_capabilities(void);
 
 u64 read_sanitised_ftr_reg(u32 id);
 u64 __read_sysreg_by_encoding(u32 sys_id);
+int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit);
 
 static inline bool cpu_supports_mixed_endian_el0(void)
 {
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d72c4b4d389c..dbbc69745f22 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3239,3 +3239,55 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
 		return sprintf(buf, "Vulnerable\n");
 	}
 }
+
+/**
+ * arm64_check_features() - Check if a feature register value constitutes
+ * a subset of features indicated by @limit.
+ *
+ * @ftrp: Pointer to an array of arm64_ftr_bits. It must be terminated by
+ * an item whose width field is zero.
+ * @val: The feature register value to check
+ * @limit: The limit value of the feature register
+ *
+ * This function will check if each feature field of @val is the "safe" value
+ * against @limit based on @ftrp[], each of which specifies the target field
+ * (shift, width), whether or not the field is for a signed value (sign),
+ * how the field is determined to be "safe" (type), and the safe value
+ * (safe_val) when type == FTR_EXACT (safe_val won't be used by this
+ * function when type != FTR_EXACT). Any other fields in arm64_ftr_bits
+ * won't be used by this function. If a field value in @val is the same
+ * as the one in @limit, it is always considered the safe value regardless
+ * of the type. For register fields that are not in @ftrp[], only the value
+ * in @limit is considered the safe value.
+ *
+ * Return: 0 if all the fields are safe. Otherwise, return negative errno.
+ */
+int arm64_check_features(const struct arm64_ftr_bits *ftrp, u64 val, u64 limit)
+{
+	u64 mask = 0;
+
+	for (; ftrp->width; ftrp++) {
+		s64 f_val, f_lim, safe_val;
+
+		f_val = arm64_ftr_value(ftrp, val);
+		f_lim = arm64_ftr_value(ftrp, limit);
+		mask |= arm64_ftr_mask(ftrp);
+
+		if (f_val == f_lim)
+			safe_val = f_val;
+		else
+			safe_val = arm64_ftr_safe_value(ftrp, f_val, f_lim);
+
+		if (safe_val != f_val)
+			return -E2BIG;
+	}
+
+	/*
+	 * For fields that are not indicated in ftrp, values in limit are the
+	 * safe values.
+	 */
+	if ((val & ~mask) != (limit & ~mask))
+		return -E2BIG;
+
+	return 0;
+}
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
