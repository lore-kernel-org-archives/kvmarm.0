Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48F0175A66
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 04:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781669374; cv=none; b=hBmt0iX5TLI2cOY/XhGmSLwbdbgIjwk8gDM89Mwj1QsDDho1X+PbU3mpm7wyJQxTj7SE4kHXmKS+Z7RB7CTD400j9MqVVbxXw4Q94ZZYKXjMfy0ZMZJwwgBPxw9KmZdzXIRLv0awZNT2bR6Nvn7aC46L02347mQX6jqtZKVsjxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781669374; c=relaxed/simple;
	bh=/6xxecaOWZzTQ5/0GeYO82zesW0Cwb3wqf9P1ox/pdw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cEmdsUG/rGQBcxiCLKCZLzQGBcVABWpxui1sITOUQenJQAdRV+FJnXMsR/XBtbN5x8XCLhseqUsvnVIVGYeem8NerZNAm/I9nNxgJHr+TQeqoDL8GpubsQ2vnnNdSR9NNlwUJE5vBlCor//8JVHBy/kt9ua+3mnFItStj4+EB0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VW+qGg3/; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VW+qGg3/"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c8584bbbf2cso3110064a12.3
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 21:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781669373; x=1782274173; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XvRbhAm/yfnFmldgaCcQBZ+NPrwKkILyesuk0P8fZn4=;
        b=VW+qGg3/fZ/Rsk+6dCLy6ianie21VEQALmJQwkKs+rEyQEFcOUKOkuDuOmbEBRdLN2
         EGo1sp6ZdmhHzUeo4aus/TQIb2HxXRTrBTmB1Nrf+KtIz9K1WAYYxpt+tqLmU/x/91dP
         z49LeyNPjIbTFzME+2D6qae4KTsTd3B2qErKBmhgb72X6y6zmELo1FRyi6S3TBZPR0MT
         xw8GpMzCS1Mi6ZklwJbmq3pIzHcgPQmaxkYquCuuksYngdyotLuOjYveDvtNvwecAThL
         6ypJA+a6YlcZRkSnY7xTMKctJkaZiIPc4JY2vGqeLhYWeLorwsmgobKXQuh+Q9wQaVVZ
         1RCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781669373; x=1782274173;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XvRbhAm/yfnFmldgaCcQBZ+NPrwKkILyesuk0P8fZn4=;
        b=YZFzAdq5hPiwMpbcvwwT+lw3rQM1TAKHq44WtAQ62wySQ2vCO9YwjSvg8XRfP75DIQ
         WET8Taqx79W75n4HMUTlcAMvYBtdoSr+0RN2U0SDuoJYCeDzRtbryieFmlOXUCLSL/U4
         pHTMPGjjbniudjjEaAHnpNu4fcGOiUj+v8X17TazWIX0Zxetb7s6c+MKBBZBcd+aei6N
         K2oq1cX1sLlFGLC5PsqEhsm5WKHyXEw1VXaebL7CTST4cH3YXws1uEEYIUH54YOHRFOj
         VoBjuLuJiZ5iqAy/lZHmoF0kKOuTVcegdK3iZ27+B6TcMEYer0UaOfDro7dw+kCk0e6K
         fUqA==
X-Forwarded-Encrypted: i=1; AFNElJ9FBL7ZYaQCDJakEMJy7+CRtI7WuNFRAmRZ1dvwbBdMSJD4/lBED8Y7hrXi4wHLFYDGb6bekXA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+u1LstGtagemf2JRcuUTrSxReCHsahH1cpJoTK0aTv4+PuSHG
	CnLv+Zor3wUUcGsHSBdm+CoQT6T9FQQzxkAemugpSSo1WmeW7yQh7bR5
X-Gm-Gg: Acq92OE/X7u5kyh5l7qy0XVxlqieV1OEkrzRIrf2XBPe+5tFDUqEoDmr0RE05FigUzV
	1dSs7/uztpkpKHYFIsWAAIbL3g0a/lipuKVfwfndgQjvz+vk6ZLR7o+jxzE4bCKzKIc4nilm7n8
	OOcqXJQERQDq7GHeJPKnRM2kS7KcVjlsCcezViKkcnlNk33MqdxaYV5YJ3CQHCJCFMn3smx29xd
	nJ1Yq3NiBvrWi+6XbC7RpVJGBBubd1T035dm1oJBwf1fHy19eTiyBnx5PBWqvYaXGKUVS/PhVoU
	sYTmRLuIxn57loo4vveYUo8Oz7HZ7qvBgJG383KvIhCvAM5raGBfesw26a2LIowWU0Y2+UarSWn
	vNRVlon4UhpM1VErB24huOzvwVrTfZAHTB4CNcHNC/x7cFC8yXxCn9kiICGy3zGtAxOmH/JJna5
	9EIhixBgWly24Iltu3VqTDb/5UyF+zgEqR/z5YnCpaaGAOMK3FGRqPF4eyLXr/0t95JTTAgbJ/Z
	g==
X-Received: by 2002:a05:6a20:a111:b0:3b4:85db:1bed with SMTP id adf61e73a8af0-3b8b7fee5e5mr2481246637.45.1781669373125;
        Tue, 16 Jun 2026 21:09:33 -0700 (PDT)
Received: from SLSGDTSWING002.tail0ac356.ts.net ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b0112edsm13181161b3a.45.2026.06.16.21.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 21:09:32 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	Zhong Wang <wangzhong.c0ss4ck@bytedance.com>,
	Xuanqing Shi <shixuanqing.11@bytedance.com>,
	Weiming Shi <bestswngs@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: nv: Fix SPSR_EL2 restore in kvm_hyp_handle_mops()
Date: Wed, 17 Jun 2026 12:08:21 +0800
Message-ID: <20260617040820.2194831-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_hyp_handle_mops() resets the single-step state machine as part of
rewinding state for a MOPS exception by modifying vcpu_cpsr() and
writing the result directly into hardware.

In the case of nested virtualization, vcpu_cpsr() is a synthetic value
such that the rest of KVM can deal with vEL2 cleanly. That means the
value requires translation before being written into hardware, which is
unfortunately missing from the MOPS handler.

Fix it by directly modifying SPSR_EL2 and avoiding the synthetic state
altogether, which will be resynchronized on the next 'full' exit back
to KVM.

Fixes: 2de451a329cf ("KVM: arm64: Add handler for MOPS exceptions")
Reported-by: Zhong Wang <wangzhong.c0ss4ck@bytedance.com>
Reported-by: Xuanqing Shi <shixuanqing.11@bytedance.com>
Link: https://lore.kernel.org/all/ajE4lHQevXNHpl1M@Air.local/
Cc: stable@vger.kernel.org
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
v2:
- Reword the changelog (Oliver Upton).
- Modify the hardware SPSR_EL2 directly instead of translating the
  synthetic vcpu_cpsr(), per review (Oliver Upton).

 arch/arm64/kvm/hyp/include/hyp/switch.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e9b36a3b27bbc..0995e34aa3c54 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -448,16 +448,19 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 
 static inline bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	u64 spsr;
+
 	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
 	arm64_mops_reset_regs(vcpu_gp_regs(vcpu), vcpu->arch.fault.esr_el2);
 	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
 
 	/*
 	 * Finish potential single step before executing the prologue
-	 * instruction.
+	 * instruction. Modify the hardware SPSR_EL2 directly, as vcpu_cpsr()
+	 * may hold a synthetic (vEL2) value for a guest hypervisor.
 	 */
-	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
-	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
+	spsr = read_sysreg_el2(SYS_SPSR);
+	write_sysreg_el2(spsr & ~DBG_SPSR_SS, SYS_SPSR);
 
 	return true;
 }
-- 
2.43.0

