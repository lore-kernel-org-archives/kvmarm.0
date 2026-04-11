Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9128A30DD1F
	for <kvmarm@lists.linux.dev>; Sat, 11 Apr 2026 05:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775887185; cv=none; b=qhrLpHBoRTaMdlXwy0vYpnb8fdtBnQaDNb7xkAdAU8gJlkm0FnNpZPIK3P3/7enn1i9KLRGNkbtEWZaYatLSyxawq09Q7uj4CIMhXwYvsw8dkveUGCKib0eXctc79/fY1ScOoSv5XHBsp7LmKt5E97EbekyCRFdNF4/jFt+3CXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775887185; c=relaxed/simple;
	bh=1+M/LxRWc86eWq4cNRHT0yrYfUE6yViWD9TbxaM0v0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iWr4cR1cTpQY7CKRuT/avxsUAXW3igELu0h7VaTbIpsoSHOqboPz2t8DbbINAqVIocY5R78jhRN5Ug2xSvYzpYvboCR5PkuMN+q7Hx+dIWVxXzIYeuqhmTUs9V/qYhnV5yI23kzjPpvLCyEb3e8WXU+MGpiq4FX5bGxuAmnYjbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P78AcBkW; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P78AcBkW"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c74244dc0b3so1646993a12.2
        for <kvmarm@lists.linux.dev>; Fri, 10 Apr 2026 22:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775887184; x=1776491984; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2hKpQKRb1doRhCbODxXOkqcma9DZMRnM3wlvxT1Nafs=;
        b=P78AcBkWyPnuRBGcARRuwSQM6c0Pi8dC8l8hZ+eTBpGoa88FKt5VLvWIs6mBFL5cNQ
         a+S71TgRNMmOMSZ3Ue0jzCwwNbIqClnKmFMGVK8Ox44dw33GIiDZ2wNxn81qLvKDSxwH
         sMZ9Lt9OtQT7UvDoYqiE9S2kqFRaRzvbjtw7hsCnAf0UBDNVvWgJqkrf6nlzgwgjaWkE
         3hT4k9pL8vx1g1sOrBrc7PueHNneeyhLuNy5mZ3CgxGy8xh9W+wr3CdWsyvelblwbL2C
         +kNw8pEHGNjAC1j7vc0GZ7CgoupCJEb7HSnos5cxktiAhv8f7fbNvd0vrHXmwfGwDfH8
         V9/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775887184; x=1776491984;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2hKpQKRb1doRhCbODxXOkqcma9DZMRnM3wlvxT1Nafs=;
        b=s2GPE2luDnRAlBwb8HJqrrN3fyVUd5/4DazQv2TuvlexV27b5Hcf8WkkawsbUd3gT2
         AQE/Dw+c1zTSOxvn4quYnFeMjmKq1HIXueOQby5P7Yhz5kkRGWRv7h33ztjIa4ocW7s4
         c1/4SoNBO/MjVcyVZrmOpeFKY2o06NP3MbQzBh5Af2ZLUzNNxv6uXMUktwIXrmhfiHxX
         4uJPdRbs9+wPjpnHQppYaxn12ELTQ2kdiNlNEd+41zKhsmqIGIzspHuldDDI5nViKhTZ
         kdgKPl8ozOdlwxQItdVP0s4V0hg7xnzsa3Rf6mWDxBmethOpg6Ek1aksFohvHqDa3kqD
         qBYg==
X-Forwarded-Encrypted: i=1; AJvYcCV9E2jTgoPO/k51KJHRudjNMLDp+w+Ty9yk58+oRU2M8OeB5f+p0qRLOS2+2qRVJ8E9RMch/40=@lists.linux.dev
X-Gm-Message-State: AOJu0YyK9zgLuUsaq+u0ENXQiyvLUD9A0MMVPZ/xraggffnGDPhaKBZ4
	cU0SPWjOa4DV0oVZ6l94Q/f/Ayc4kLZHAHDuUf9AeHWHcxMwFfgXmMc2
X-Gm-Gg: AeBDiet4NOBCOmaQ38D9Jo0IiUi533VA1NXbgUKPV2ilHm8P3fSJJszeRYUUF1CEBg4
	LHOzEm/1bZDcQNA40WmBkpgQ6xl95eCEDFQgjQC3jj7qkddaQArymxY4TnxCDRmyveLhkhEDl7N
	aFvg2ykgMP1wZ7eiCkAbXYM1sUsX3XGWzTpCSiuo3BnhX3WeO5wZx5OXwaMrJzSWy5hnuDuQjFT
	+rLB9TJza4t+KDHnfcb12e+Wq9lHoi1AdbhQMs2wiDTDTnkPBeg7KHhrDJG+wVB+sMshZxUaU9L
	Y7YQpIy7IWp4QGZ6WEzcnIqL43ZvOjqqX+nlH9OKZuVTxXHZeGrOVwiHu5zSqJM95BoR4Kl/WE0
	TGYicFTxCiiYhL7lJb+NfpFh6Whx8jdE5mID8ux9nsUl27kQikdyBeJpJyv8SoNFil2AXZMs+dn
	BDGLAcXtF1iGvehdc3SqRY7Nb4+QVWuv4FFss68uqqXqDDMPwxntJ/9P6VUtx8Snt/Poc4/0coJ
	1iTVp+QBaE0C+NdJg==
X-Received: by 2002:a05:6a20:9155:b0:39f:5671:921 with SMTP id adf61e73a8af0-39fe3c9126bmr7033215637.3.1775887183785;
        Fri, 10 Apr 2026 22:59:43 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:a7b4:1829:8943:c37a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c30ee3fsm4977702b3a.12.2026.04.10.22.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 22:59:43 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: maz@kernel.org,
	oupton@kernel.org,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: drjones@redhat.com,
	christoffer.dall@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+12b178b7c756664d2518@syzkaller.appspotmail.com
Subject: [PATCH] arm64: KVM: Initialize vGIC before preempt-disabled section in kvm_reset_vcpu()
Date: Sat, 11 Apr 2026 11:29:35 +0530
Message-ID: <20260411055935.21692-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_reset_vcpu() calls kvm_timer_vcpu_reset() inside a preempt-disabled
section to avoid races with preempt notifiers that also call vcpu put/load.

However, kvm_timer_vcpu_reset() eventually calls kvm_vgic_inject_irq()
which triggers vgic_lazy_init() if the vGIC has not been initialized yet.
vgic_lazy_init() acquires a mutex and calls vgic_init() which invokes
synchronize_srcu_expedited() -- both of which may sleep. Sleeping inside
a preempt-disabled section is illegal and causes:

  BUG: scheduling while atomic: syz.1.49/3699/0x00000002

Fix this by calling vgic_lazy_init() before preempt_disable(). On the
second call inside kvm_vgic_inject_irq(), vgic_initialized() will return
true and vgic_lazy_init() will return immediately without sleeping.

Fixes: e761a927bc9a ("KVM: arm/arm64: Reset the VCPU without preemption and vcpu state loaded")
Reported-by: syzbot+12b178b7c756664d2518@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=12b178b7c756664d2518
Tested-by: syzbot+12b178b7c756664d2518@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 arch/arm64/kvm/reset.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b963fd975aac..4ee16b4a37b5 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -25,6 +25,7 @@
 #include <asm/ptrace.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_asm.h>
+#include "vgic/vgic.h"
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
@@ -198,6 +199,14 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	vcpu->arch.reset_state.reset = false;
 	spin_unlock(&vcpu->arch.mp_state_lock);
 
+
+	/*
+	 * Initialize vGIC before entering preempt-disabled section.
+	 * vgic_lazy_init() may sleep via mutex_lock, which is illegal
+	 * inside preempt_disable(). Second call inside kvm_vgic_inject_irq
+	 * will find vGIC already initialized and return immediately.
+	 */
+	vgic_lazy_init(vcpu->kvm);
 	preempt_disable();
 	loaded = (vcpu->cpu != -1);
 	if (loaded)
-- 
2.43.0

