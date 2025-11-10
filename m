Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAD915A86D
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 13:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762782336; cv=none; b=PSlgPQ4PDaZlgqesJIdHEi9kLp7eB02iNOGoA/eQAX1ZrBQ2Zl2zqgEhYGKodd54nzcD/BRY2Yw/glV7ShyeLQIOf9o51itK31KOpNfbdUOyzCl9nUBdBxrzM9CE75tow+TBBNNCBfKMyUIjXbUEnBGGA07P6vSRVYgxwSB2D4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762782336; c=relaxed/simple;
	bh=amTS1cl4xT61CmzM3gv7/rxJQt4ko3PXHeM6lAHq6c8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OS+8dsSq/IFqiv44FYJ3t5t1kUUi9ZQSl/9dsaMlZk8nGKP1TI0+tWmwxSeUUA6riPDju4Q5Dq4+au12a8svV7/7aniZ4aFLe1MW73dy1g1JQZrnqaCwYHVF/C7MxUVmjsNpREeEu4iEGOuAtZMJZKBuXjmugGRRvuRivXm+WqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MsseZ5zJ; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MsseZ5zJ"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-429cd447398so1104761f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 05:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762782333; x=1763387133; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ie7kpsh7J/uc1PtC1eN/9i9Vh9NVRgm/2OIk7X5wYpo=;
        b=MsseZ5zJ3rA3/v4xQfqlk10dwFpWvoV+Zg+aNEE6t0meDVQVY/XV06aRnYcnADu69E
         PLZQelfhgd5CJhwjOUECrmTt8sQLQyugYugrPhzBgY3NSfPcXVA4AHCBX4cILJM0D2da
         qrtseOKNyFZCCTeIVFvK0kPJxg3ws1RjlUrAoMlmukcUNHLGSLmJQoXgLLEKWTIcjIuE
         Lxtg5nUvz211V8NwSZ4dnR2yvOWI/89MgEyPyv5Knm+ghv8EOQeFAu6lVTcCftBHHb4C
         Wq3puVYmagjMvdbIJfid/n9UOhJSarYfZa9EoHGWwPMfMIEdWYXbRNymiiCaRpa4Fnd7
         yZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762782333; x=1763387133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ie7kpsh7J/uc1PtC1eN/9i9Vh9NVRgm/2OIk7X5wYpo=;
        b=waEijoIcKMZHgXQmFiWl0HouhbL+0wlRjJ/VI+0SgtjUb69QMdwySh2of+lzRNSzKL
         brFSColPGJtxIkJ5jWNa6kFgNBJnLcppmY+cMrOPci2vrGKFy6LbicWR8L15o06GljUu
         Ie1Aet410Vi2dWTpL/4L8tShkUFZncvPpQ5JFmEDGdMGS53ETuDMNwWNAI7bS0dZ4RPr
         LrYrAeT7gShZeeBV8kOw7sAQi+Axv1IM+Fw9l1Y7N71Q1wxamKraZ6f6c9G7lA6Nww+s
         zdEYiYTTmxFG2euMGiiHkh9B557JK2c2TNEmXxeb0F1ALmrtrXackl2KaH4MDc7hCabu
         fiew==
X-Gm-Message-State: AOJu0YxiuAhkzILSlOxfwlsOeklp27RQPuJQy1yklDmeEQ+ZsfAe+zOU
	N34ITMWIMq0vpo6w2aPkKlDFJc3XySbhxECj30oM/n9tiFPRHDQIxIEIMo6+ulBNbxeIdwP6C5J
	WEGVzdwwcCpp0PqNhe1zPz9FO4I1pIfA5KZ0h2fIvf5+wS5RUU3CQ/Zq1+mzlWE4KbCFrhRm+Uw
	CZaLP6oCNky/++QGwysg3kcfYiE1APNrc=
X-Google-Smtp-Source: AGHT+IG9ilEUoq2nh7FpIF6KZkR90/4mFzDa0JiXH3DjnqLpk38X37fcPxRyknshTYR2PdDE64CreGe4Bg==
X-Received: from wmbh5.prod.google.com ([2002:a05:600c:a105:b0:475:decb:4c4d])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6384:b0:477:5aaa:57a6
 with SMTP id 5b1f17b1804b1-477732372aemr59615955e9.10.1762782333174; Mon, 10
 Nov 2025 05:45:33 -0800 (PST)
Date: Mon, 10 Nov 2025 13:45:24 +0000
In-Reply-To: <20251110134525.3768197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110134525.3768197-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251110134525.3768197-8-tabba@google.com>
Subject: [PATCH v3 7/8] KVM: arm64: Check whether a VM IOCTL is allowed in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Certain VM IOCTLs are tied to specific VM features. Since pKVM does not
support all features, restrict which IOCTLs are allowed depending on
whether the associated feature is supported.

Use the existing VM capability check as the source of truth to whether
an IOCTL is allowed for a particular VM by mapping the IOCTLs with their
associated capabilities.

Suggested-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 20 ++++++++++++++++++++
 arch/arm64/kvm/arm.c              |  3 +++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index ea5d2275d16d..a2b51590bed0 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -52,6 +52,26 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	}
 }
 
+/*
+ * Check whether the KVM IOCTL is allowed in pKVM.
+ *
+ * Certain features are allowed only for non-protected VMs in pKVM, which is why
+ * this takes the VM (kvm) as a parameter.
+ */
+static inline bool kvm_pkvm_ioctl_allowed(struct kvm *kvm, unsigned int ioctl)
+{
+	switch (ioctl) {
+	case KVM_CREATE_IRQCHIP:
+		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_IRQCHIP);
+	case KVM_ARM_MTE_COPY_TAGS:
+		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_ARM_MTE);
+	case KVM_ARM_SET_COUNTER_OFFSET:
+		return kvm_pkvm_ext_allowed(kvm, KVM_CAP_COUNTER_OFFSET);
+	default:
+		return true;
+	}
+}
+
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 10d853f2722e..020cadd811a3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1879,6 +1879,9 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 	void __user *argp = (void __user *)arg;
 	struct kvm_device_attr attr;
 
+	if (is_protected_kvm_enabled() && !kvm_pkvm_ioctl_allowed(kvm, ioctl))
+		return -EINVAL;
+
 	switch (ioctl) {
 	case KVM_CREATE_IRQCHIP: {
 		int ret;
-- 
2.51.2.1041.gc1ab5b90ca-goog

