Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53F02BD59C
	for <kvmarm@lists.linux.dev>; Sun, 12 Apr 2026 08:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775981090; cv=none; b=WA21Ne9G+FM/7yzEx1+nZre87b2p5pjyLDrR914abS03XuqMpUgLLpip5+s83iGFn57AjTAvKQbo4eeIjR8OKY1dUs+b62kVODGLVt0p5QLT81anm1z/bNYJZu+3EtVeZcKmafdxuPUMJBmFIh0eIU1shGxHZLDbQH4aFjcpjnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775981090; c=relaxed/simple;
	bh=1+M/LxRWc86eWq4cNRHT0yrYfUE6yViWD9TbxaM0v0k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=beCZGTi+vt33bBkH/taC+t3HzkYlcMsjkMqHO26bfpMylJHjqUL9rDaVO4ZJuOmjVrc8A/f+RK6c5V0zOxM6L2M+8qVxQ83TjPydxKXkrjwuujOYJBvXI2EM59bkwrHB0nF6FAtQ1iSRrvevhfWzxNUkXdGUhlHwcOY4hiOQGc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QUSzl6VG; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QUSzl6VG"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-82a655cfab5so3037712b3a.1
        for <kvmarm@lists.linux.dev>; Sun, 12 Apr 2026 01:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775981087; x=1776585887; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2hKpQKRb1doRhCbODxXOkqcma9DZMRnM3wlvxT1Nafs=;
        b=QUSzl6VGZ7Ak3TpLNhT9BCp7KU7B56WoJkJOwSiwqJUE6XXG70coW4BFG8L+S/KpBp
         HFmOVPWq5TkPG/FY15ES4AxUXH02ZfO7LjjOjMsneaKod4EoCcgxDUHCicYuDebrCvb1
         AVuy7zyhqx1ewaj7vj+RoDPDn7DxEcgFXoVBUv6BdSPpK29w7IIhejyxQEc9k/UuxeI9
         IIKTXtUkQR5qXijfwpNwkuCOdxkKvLyPjeAhO9b8nActyLvEcm60mnccsVnSoobxMhdW
         JISDG3VRw5Kbqq23o2BrR/1+X5axr0V3M6O2dJV7+GHSDULLm2ebR/Re+WA9b41RD5gq
         ybig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775981087; x=1776585887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2hKpQKRb1doRhCbODxXOkqcma9DZMRnM3wlvxT1Nafs=;
        b=YopYuNWZQaM+x5Ut//of79SkI92pl4MsZ3UZKiD4XEboWEFiOF1G6QBFiGWuFpqOrg
         iFbjAhM+eHzQsFSFATRTnSwSwi1XaiaCSSAhsXsdDeLwEDI/BY5kofFCzoDFNeINGFyh
         zt9fSX07gphqsfrLAvz+wq/Elh/vJPAsKjkB9dvb76T3zN+mMDxH6aW40u74spNm4OSn
         OrP6t4wq7Sj97jgWvv6L7IL84zHd8GFB68sNQaVmCk5JlTSd27uQyEHT09Y+Lu7mt0kY
         /1Ff9gJU0S3Y060391n9zn9K9/1dw4/nt4oXK97A0yCb2Hk3PqapJyzc39oquOagfMf9
         eJBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWK7AAxBO4NjshafGtYsKgty/aUWyJUfdQDKZmc+8ChNvv4LIAvAEit7CEAYHDRVNFOlUrK/ZI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwxGE/7uXjlMdcI2irPE7DQ7RQnJUFvNkXgjCptGo8OhzzFdViJ
	CCLs6zkSS7Ovt84gHmAI9Jn4nyE2smq1zii97NSQjGiBBEim/goue9Sk
X-Gm-Gg: AeBDieuxPXIUN3KTU0k+sUu/ZovlT4uYv6+jdL4NaGRsKAtbCHRgB1lc4KdmjblwSn3
	/dFOKXzmdxRunN34eKd4RMQhw+msp3YfQxucs05X5GLE8Z+6ZNzhf3SMSTv0LkVQujDCnboJOQz
	W0ILiYoA+5GwaloG0Z347JUQpvpTz2HGGi1syr1qT/35HMUD5MjhHbetTjXW+rqxUSsOxnoOTTN
	Y4ndgdP/Obr0RIb3VAlBh8lb+Hu6azfOrVSoToQRdwDf7xt+BISLkxe5/inVyfbAsLHDvfcEAZr
	HqVpy7MnGIAYZ4r6qKVxKgwlLUhbWTfqBeSEhSp+fbyg9SRruNaS5NQU7TMQYxld2ullzwM+wAt
	no52pohsIh2Ku6c6nLvZl8jNylUL5eGBVM5gIvbEhVoSEq8MBJlo7fzGNuGuQ6x8F8T8JmT2SZo
	7cBECBO8wUIB0yQMiT1NUq21kUfxjwYKOQKmdMAEIU/ntrFHF9uyDaLARMM3C7jRoCvgZisISU4
	oLHwA==
X-Received: by 2002:a05:6a00:1f03:b0:82c:9f73:a2f with SMTP id d2e1a72fcca58-82f0c2c8bfbmr10079288b3a.40.1775981087078;
        Sun, 12 Apr 2026 01:04:47 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:383f:142c:c389:4a2:63cd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c33de57sm7389959b3a.21.2026.04.12.01.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 01:04:46 -0700 (PDT)
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
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+12b178b7c756664d2518@syzkaller.appspotmail.com
Subject: [PATCH] arm64: KVM: Initialize vGIC before preempt-disabled section in kvm_reset_vcpu()
Date: Sun, 12 Apr 2026 13:34:37 +0530
Message-ID: <20260412080437.38782-1-kartikey406@gmail.com>
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

