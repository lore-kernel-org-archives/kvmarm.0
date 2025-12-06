Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620E62F3618
	for <kvmarm@lists.linux.dev>; Sat,  6 Dec 2025 00:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980309; cv=none; b=eiRWDdub3azyLwiemrT3Zk5gNrl6e4GX+d/f6Mf1JY1/hgmSulPs/TkRyA7Vx1/PWz8Scq25MQU5oeLzPb2NYVZyhwFQtwQpMW8nlWS3oGPZyPEGx/9IuhCotblHLnfwPCGPLAcjNgwrOWk06++JVRCb7puxPTHFrD0PZ+Qo7TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980309; c=relaxed/simple;
	bh=XkalrXDc3Qa++HcZCT+ub3/cOt2TlQhCgor1dl+ppOo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cTyVWyF2Ao1k4B0tBbsMPiz1yYedCn34LBpeCUcJDRB57RXZpUorBdkZmIEJ5Bmg3Qgf1UnENq86Yftx238PELHSQ3Wk4WtOUCiLuEOyhv2l79Oa96q8on7/4rHgGEb/IbnYOscSSGnXR+6xSnFWKDdSBThaSl9NE9Hm1nxaL5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=fail (0-bit key) header.d=google.com header.i=@google.com header.b=nMTRP3DI reason="key not found in DNS"; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=google.com header.i=@google.com header.b="nMTRP3DI"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-299d221b749so45965715ad.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Dec 2025 16:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980307; x=1765585107; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wDDQncQUzzwpRSzzmwHiRYOU7FF2nSUQYIeQTrnvQK8=;
        b=nMTRP3DIkWpJM1sD56hmnL75t1cB+ErmAHiS5/K8fUxW+ihRJaCUqlDUjcZ2ZCcalD
         dxgAJpqhMSIpDrUyNHK8xSYq3ZPVv8i0171+DtAnbPZG7MQJnLfnkYgrKifw2BZRZkuh
         iFEcg8uYT8rm/YfyQUpVTgHxZN/+P3rEaAxsbzkX0yJQU11W15Va5AFXP2CDr2e5b7/R
         AivXaZa7I3h1fpkAMsIPOM+ye0ep+tdJPeHV9eleieGS+2J7+g7tVpAnaFkq5GtnjTHp
         Kvsa5ScMizyAYrHYnkmGFVDOxor09JxuMNT/TANSKRXYrLFWfgbUyrdYHH/D/8itAhWN
         lo3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980307; x=1765585107;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wDDQncQUzzwpRSzzmwHiRYOU7FF2nSUQYIeQTrnvQK8=;
        b=tzphy2qptyNA3F7QmX6CyPeFGG+xqbjrJ1JxVHJd8FjB87sN8d/a7ZZ1dCmI0A7dSD
         BwL3JRjlvYoBgcncpDshyKBOcVaXIP/N18rgtesgUNAKYlAyzS6UBVX0uzr2G4UtxAji
         vt4gzLQPVSO463sDOm6+94JFU/0AM7ATIyEVmjL6rsSVdzI6rC8OQu0obZuU+iCyaljx
         kDciM1LLcKzekE7/l98zzBExY78OiDRGq7s7H4ECjsCHn/3b9hYe9GywTrNOw84tx4y+
         CdqEhhnnymptQoNqIk4rGU0s3urg1EgJy5V2YXXD2nJI09fXwhSGRbP3t2Z22DSdna8Z
         NNRA==
X-Forwarded-Encrypted: i=1; AJvYcCXSmvlLpQnlk2xJkC78/PQEavoFLgbHf8KHYHQm0lTNuTBk5v5eX+x14sAV47q5hxSkMi+eNDc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yww5yDWFkbH7idrtf4adr3c2N5yriuWVXmQPria/U+a8hSyiOvA
	HzI+fcgRWgcIVkKUq+XVthGQvH9X0eS0Ice9/ib447/CQKT8/rRdv1kr8S5iKwMivH0yXp+3oOb
	nYAgh7w==
X-Google-Smtp-Source: AGHT+IG4vHPmom8LOFsNf9ubPRsWVZC6RkdL55O4HgJ6N06qyh5/Ls7bYlKNT7sQNBmfh9FVeBcsEGoEIG4=
X-Received: from plhz1.prod.google.com ([2002:a17:902:d9c1:b0:298:51f6:847d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2f84:b0:294:fc77:f021
 with SMTP id d9443c01a7336-29df5deb193mr7205895ad.49.1764980306541; Fri, 05
 Dec 2025 16:18:26 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:06 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-31-seanjc@google.com>
Subject: [PATCH v6 30/44] KVM: nVMX: Add macros to simplify nested MSR
 interception setting
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Add macros nested_vmx_merge_msr_bitmaps_xxx() to simplify nested MSR
interception setting. No function change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 40777278eabb..b56ed2b1ac67 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -617,6 +617,19 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
 						   msr_bitmap_l0, msr);
 }
 
+#define nested_vmx_merge_msr_bitmaps(msr, type)	\
+	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1,	\
+					 msr_bitmap_l0, msr, type)
+
+#define nested_vmx_merge_msr_bitmaps_read(msr) \
+	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_R)
+
+#define nested_vmx_merge_msr_bitmaps_write(msr) \
+	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_W)
+
+#define nested_vmx_merge_msr_bitmaps_rw(msr) \
+	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_RW)
+
 /*
  * Merge L0's and L1's MSR bitmap, return false to indicate that
  * we do not use the hardware.
@@ -700,23 +713,13 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	 * other runtime changes to vmcs01's bitmap, e.g. dynamic pass-through.
 	 */
 #ifdef CONFIG_X86_64
-	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
-					 MSR_FS_BASE, MSR_TYPE_RW);
-
-	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
-					 MSR_GS_BASE, MSR_TYPE_RW);
-
-	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
-					 MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
+	nested_vmx_merge_msr_bitmaps_rw(MSR_FS_BASE);
+	nested_vmx_merge_msr_bitmaps_rw(MSR_GS_BASE);
+	nested_vmx_merge_msr_bitmaps_rw(MSR_KERNEL_GS_BASE);
 #endif
-	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
-					 MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
-
-	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
-					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
-
-	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
-					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
+	nested_vmx_merge_msr_bitmaps_rw(MSR_IA32_SPEC_CTRL);
+	nested_vmx_merge_msr_bitmaps_write(MSR_IA32_PRED_CMD);
+	nested_vmx_merge_msr_bitmaps_write(MSR_IA32_FLUSH_CMD);
 
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_APERF, MSR_TYPE_R);
-- 
2.52.0.223.gf5cc29aaa4-goog

