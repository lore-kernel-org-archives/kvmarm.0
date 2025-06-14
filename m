Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3282E336D
	for <kvmarm@lists.linux.dev>; Sat, 14 Jun 2025 14:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749912968; cv=none; b=k8EFXb1CahZ/13cxDqGW+DzVYy/ZCmIRJp+oshFaZwJi0WRm056ausnrbUQrYfB6EttGyujDQz4y17ee/o6gmqWjotwMIas0l7R3Wi1pyQW+ZN6gD3Sdr4Kc58L7qztGjyH4UXkcNQNdFygFfnnHy60+lYcvecvWji16L7yao5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749912968; c=relaxed/simple;
	bh=V2dnmXkpmQkFeGJ0/9lY8APfUTddRrtiX6o9oiKsl98=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KkBdVCn0fmOL/NT6/YgyRtWGL6MAyZIOu/UYZq/Y3RhcOnArJtZOTATeWuitUe4dOaVqoU4LTEmV6qx1XwmcqSZUUyMKqYZHmMk2YJVwJs6w7kG0La5mXqrNsRC3PdRg7uvgRLX6nlyGbzW0QyNmmn2XpStdyXcp1rmoZWtI12M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=XbaJElQJ; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="XbaJElQJ"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-748a42f718aso260195b3a.2
        for <kvmarm@lists.linux.dev>; Sat, 14 Jun 2025 07:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1749912963; x=1750517763; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FdwgAOcCxW8xP65CJHYSviC4hBZAI2hMwMKg/94ld5s=;
        b=XbaJElQJtvoQz3zq1Qg5hCoard05wVZnbB6N2Wc4qAXv8LGiXYhNAJkjOPWQ+1DyU6
         ywIzgGhO5sQx+95lnFphXCXGMqunLdYyyRESvApB1jRfXj5bwdnUkWiHW6LZyfMoIZHM
         69JErk5110te5xLZqTsqQ4nG5UVsfNgdPRGxUrzCDlV4/qT9Rho94tg2zX8eCM2UPEXc
         faZiZQY/FPEsXi/dDOpWhQmPreE8RGxnaKwP6hz4xCcO2XBJ1NbquBqT4tdmAlbwe13f
         j0FYMlMKkvaDr+PgAJlajRUPiTI7whsPI3gytY0AfeXuedFoW2+Is4AjSb6Cd+t5pqVg
         Ny/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749912963; x=1750517763;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FdwgAOcCxW8xP65CJHYSviC4hBZAI2hMwMKg/94ld5s=;
        b=JJ6UmpUBmiFKn9IvJ42GXob240vNEtZC/5MCOr9SHhFu64abUC6tuAY0NjJqANcy9S
         imL235jRUxHvq6DxlHfAocTtCw7Is00BIqiEMXw+1iIeh97kDe3oGPQOEAvV2XHgKN8P
         LhxAPiOxlDCpMpdnjR+DF1Yn/9MufOxNTHPzpNzpTdLs2HoNTOVHoqFvvNe7tC/2vHWK
         /ZHhqizou/ncLJFFSDssK0YbyAH1XRaXH231GVnCh6EsfGfIh5G4oUwbwjoJUd8wLkS2
         PHhf18fB4D5p0vdclEyboExeU7o74tc4NuNMm4HAxXJIAcGxBtfrrgmcIIkuIh7LtQSh
         Czrw==
X-Forwarded-Encrypted: i=1; AJvYcCVaBg8yRUNBPQj2/qnCnRG/nBuExuCBp0EX8v5U9D0I+KScG48EUPekXVV6/clEDUMdS7b2vu4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhPNLV+SQX7LdoEH3J3fVQ7M4EDRJvGN7PK6Lo7JDsXs6ZF+Vx
	V0oE9jdZW8QoCNiLf/IuW1A/qbMoRVVhtqyQThcKc24OYyzibD+IDpMStHop3+N8/9hI7zaUQqA
	r3PXkZgCWTtKiPKoiB7iARbNtbIApRdcA8BKZtPyn/g3VMPYdjxg=
X-Gm-Gg: ASbGnct9QEQY+aUbvFa5yJnl8DO0AGDNmGxEDnrWv1Yx2anAVz1h1p1hy318NAYs2i8
	M4ohOzQj9a3km1+YZeNfqv/Ysc6h9CPY93ZmfKLDjv/jrwJin0xegNmD7Zc8nRQaufIt4MSj0Gf
	+UAtwDcmk8o0QZcwWli66bjPsTw7emO1ALrhGLu4chrjYCPIEQWhYlVy3/Gx6IZkvL+Y9wA3Kzq
	RVpW1gMKRn5o2R+Zr2YMyMD8SQr3CNwfM9jfjFVZNKtW2jTz43oKRDZGnsylvchXlFZs95VfxrJ
	uCB6m3N+6MRwlO436MrQevK6OQ5caZ48eAtNjPArWS2PyTUgyp7lttydZTJC/pbFw3jmPT+4Sf9
	YeBpFEmfOSE96GJeMaKPTZIylBuDvkQWoEkD9a/aQFAM=
X-Google-Smtp-Source: AGHT+IEEnn/ufz6mqS8sNhhi17+pqZj6OB0ZO/xLcIsqqzhVrA8tKi9dLivhuV4/wirpHZNz/ivObw==
X-Received: by 2002:a05:6a00:3e10:b0:72d:9cbc:730d with SMTP id d2e1a72fcca58-7489cffbf39mr4211820b3a.11.1749912963480;
        Sat, 14 Jun 2025 07:56:03 -0700 (PDT)
Received: from localhost.localdomain (36-228-20-239.dynamic-ip.hinet.net. [36.228.20.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74890006059sm3565303b3a.55.2025.06.14.07.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jun 2025 07:56:02 -0700 (PDT)
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Will Deacon <will@kernel.org>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH] KVM: arm64: nv: Fix s_cpu_if->vgic_lr[] indexing in vgic_v3_put_nested()
Date: Sat, 14 Jun 2025 22:57:21 +0800
Message-ID: <20250614145721.2504524-1-r09922117@csie.ntu.edu.tw>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Gm-Spam: 0
X-Gm-Phishy: 0

s_cpu_if->vgic_lr[] is filled continuously from index 0 to
s_cpu_if->used_lrs - 1, but vgic_v3_put_nested() is indexing it using
the positions of the set bits in shadow_if->lr_map. So correct it.

Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 4f6954c30674..29741e3f077b 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -343,7 +343,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 	struct shadow_if *shadow_if = get_shadow_if();
 	struct vgic_v3_cpu_if *s_cpu_if = &shadow_if->cpuif;
 	u64 val;
-	int i;
+	int i, index = 0;
 
 	__vgic_v3_save_vmcr_aprs(s_cpu_if);
 	__vgic_v3_deactivate_traps(s_cpu_if);
@@ -368,10 +368,11 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 		val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
 
 		val &= ~ICH_LR_STATE;
-		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
+		val |= s_cpu_if->vgic_lr[index] & ICH_LR_STATE;
 
 		__vcpu_sys_reg(vcpu, ICH_LRN(i)) = val;
-		s_cpu_if->vgic_lr[i] = 0;
+		s_cpu_if->vgic_lr[index] = 0;
+		index++;
 	}
 
 	shadow_if->lr_map = 0;
-- 
2.49.0

