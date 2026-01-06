Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0192D3161BA
	for <kvmarm@lists.linux.dev>; Tue,  6 Jan 2026 09:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767691471; cv=none; b=bcMy/Do5sJxqsANG/NhvkITWh+Hq0NZLQIMmbXxxTaa/WKmHvW24qgsjeOeTi5wcW+xHgf5XgAqd/fHNYhafhcH1NQbY+k8NwMylSelLjVPk6RnPShwq4L4IdeoRuPTW5dUK1ZdNczcLk/1EecllvGUmp70xI+LuBFRweOHpAzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767691471; c=relaxed/simple;
	bh=K7c4pi6jwjpb2UDOULlAxegszb3LTOJLg8FVDuHxR3w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gjd0RuXnoO55HUW2jDd5M2q3mMoREYtIT2FoPASJD2LGLqK0SMaGWagQw0Xhj41pdNLtpsl2xDVwREmRXp4Le8hZr8sxsSvnG8lY/Bo9SgUYT/qqFOqsP8Mo4ng7vd0mAcpo1S5wWoRfLm0hsTDdBvbkvhkm+yM330MriwHBMRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wFBt53I7; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wFBt53I7"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47775585257so5031235e9.1
        for <kvmarm@lists.linux.dev>; Tue, 06 Jan 2026 01:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767691467; x=1768296267; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kq1IjMSjoMKjdw0XAwlPesXU4TmV0d7vJwGMiICzk6g=;
        b=wFBt53I7mHshsbbQ0gsq0uEqmRPhtxbfPeKIIxA8wbjELkALK2e/OuqMEABeVNZx5Q
         /ixr5ivN6byMM1J/GC1lUjUDLuIlUDr+veYYTwwuY0H/U76wq/dJrFAZ+SXTC0PB7NaC
         k1DT8zMTSY8KlV4DbqEhrAWdIfRnEkk2Ndtb68nNLkPzJTrcuhkjWDK/eA41qVIWmeCf
         /UNfelTMXvFoariljwy5AV0zFtILS6IXDOErY+CAdNh31syvo7S8jiQQmOue0rZR+lpW
         iBDEltnha9Bp9aWm8yTNm55n8ckPltBZ/Ye6trnmgjTKoRhIRTuy6QVwnrukcq7hM06q
         yBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691467; x=1768296267;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kq1IjMSjoMKjdw0XAwlPesXU4TmV0d7vJwGMiICzk6g=;
        b=L3WxyYrb61bvN2+WnezE7UbITWd8817FVtvIvB+Wvl8/YatzCtbyrCZxweGYwQx8wZ
         ZmAWTwJg7rWiGRZQdnqpqrzHLm1zUm48cenm26EJstP1hznjadU5Oua80OJD7zhrVLmp
         zY3+r2ocTDnfGVO3US6kK7fYvfB4KMEfbDk2xLB6IalFctCmjH7USO3c00kMgxUGYKW0
         H25N/nqubbSz14KJVQL5415YjLGBdJfXwj3eWjhEP7XaJpOsAqjjF5daLZzyDJ3cpzFU
         VCwEMb+zTi//FDiuBRyVkdtcYZKQi/rZN76ZVo9nGTPW06Iaw46j/onihxfZvMcNMsp9
         2B/Q==
X-Forwarded-Encrypted: i=1; AJvYcCX0wP7viaUz0FARLUqsJyj94ZmoOsZ3RoumSi7x+tiT4P/wAi84eGFdIWBqJxvnIB7+acoXzPc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbxiFSbS+2BstyAuKVx1Hvrzb72MFt7ZOMfcc7Vo/SKuQHo0Ch
	PP892GT7ceO+HscXOI2PmZvnd03uJklknKmYHc438igcQ2te0vs6VKsZ6iuD2QxbyEdQ2+9ilVU
	xsw==
X-Google-Smtp-Source: AGHT+IHAvLyAn1VJG2+pLIU7Jm982X3rmXgnqbZGLYkM+N3EFPWYk9emuP+KfsGs4jFnJ/EzGlOPeeJ+Fg==
X-Received: from wmqo19.prod.google.com ([2002:a05:600c:4fd3:b0:47a:7586:4faa])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3554:b0:46e:33b2:c8da
 with SMTP id 5b1f17b1804b1-47d7f09fac3mr25123345e9.32.1767691466959; Tue, 06
 Jan 2026 01:24:26 -0800 (PST)
Date: Tue,  6 Jan 2026 09:24:21 +0000
In-Reply-To: <20260106092425.1529428-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260106092425.1529428-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106092425.1529428-2-tabba@google.com>
Subject: [PATCH v3 1/5] KVM: arm64: selftests: Disable unused TTBR1_EL1 translations
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, will@kernel.org, 
	pbonzini@redhat.com, shuah@kernel.org, anup@brainfault.org, 
	itaru.kitayama@fujitsu.com, andrew.jones@linux.dev, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

KVM selftests map all guest code and data into the lower virtual address
range (0x0000...) managed by TTBR0_EL1. The upper range (0xFFFF...)
managed by TTBR1_EL1 is unused and uninitialized.

If a guest accesses the upper range, the MMU attempts a translation
table walk using uninitialized registers, leading to unpredictable
behavior.

Set `TCR_EL1.EPD1` to disable translation table walks for TTBR1_EL1,
ensuring that any access to the upper range generates an immediate
Translation Fault. Additionally, set `TCR_EL1.TBI1` (Top Byte Ignore) to
ensure that tagged pointers in the upper range also deterministically
trigger a Translation Fault via EPD1.

Define `TCR_EPD1_MASK`, `TCR_EPD1_SHIFT`, and `TCR_TBI1` in
`processor.h` to support this configuration. These are based on their
definitions in `arch/arm64/include/asm/pgtable-hwdef.h`.

Suggested-by: Will Deacon <will@kernel.org>
Reviewed-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/include/arm64/processor.h | 4 ++++
 tools/testing/selftests/kvm/lib/arm64/processor.c     | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index ff928716574d..ac97a1c436fc 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -90,6 +90,9 @@
 #define TCR_TG0_64K		(UL(1) << TCR_TG0_SHIFT)
 #define TCR_TG0_16K		(UL(2) << TCR_TG0_SHIFT)
 
+#define TCR_EPD1_SHIFT		23
+#define TCR_EPD1_MASK		(UL(1) << TCR_EPD1_SHIFT)
+
 #define TCR_IPS_SHIFT		32
 #define TCR_IPS_MASK		(UL(7) << TCR_IPS_SHIFT)
 #define TCR_IPS_52_BITS	(UL(6) << TCR_IPS_SHIFT)
@@ -97,6 +100,7 @@
 #define TCR_IPS_40_BITS	(UL(2) << TCR_IPS_SHIFT)
 #define TCR_IPS_36_BITS	(UL(1) << TCR_IPS_SHIFT)
 
+#define TCR_TBI1		(UL(1) << 38)
 #define TCR_HA			(UL(1) << 39)
 #define TCR_DS			(UL(1) << 59)
 
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index d46e4b13b92c..5b379da8cb90 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -384,6 +384,8 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 
 	tcr_el1 |= TCR_IRGN0_WBWA | TCR_ORGN0_WBWA | TCR_SH0_INNER;
 	tcr_el1 |= TCR_T0SZ(vm->va_bits);
+	tcr_el1 |= TCR_TBI1;
+	tcr_el1 |= TCR_EPD1_MASK;
 	if (use_lpa2_pte_format(vm))
 		tcr_el1 |= TCR_DS;
 
-- 
2.52.0.351.gbe84eed79e-goog

