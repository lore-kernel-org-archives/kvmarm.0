Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C0C2882DE
	for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 08:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750841116; cv=none; b=ul6IlCeB+HKgHKIxl8oXQEjZIKcFykNF5jIkRKXlWpkkXFg0tSceJB+TtEuZi+naKtoN9E7QQmgghoqJQwaIqyeGWfJD2LTte0MupqFhIlyj1qOgHG8qmcHFaKyU2FOvIPGewz8tRcZ0Xi4uuvqMEPkN+i28AKdiln66O0G8+Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750841116; c=relaxed/simple;
	bh=hXBmUgYnqVV/obrfQE+ffzHO/KP6BaKG11lXO0yJS1w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CtuPF0eNU+Mk8HTz5AoB8W1smqoVYr3Tsy9j9PGyKandNYzdBF5JOzw+wCbIussgbZwYwGmwaeCTCD7HpiCwwICtjg3Yl/REaVp3F+apUhR8UPl3UxircE5xR+gHmld0Sm+xL1AfMd0NBvedd3nhkd3UrJ1yj1iOpRAx+rgw2os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=H5/nfzXI; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="H5/nfzXI"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3141b84bf65so1480688a91.1
        for <kvmarm@lists.linux.dev>; Wed, 25 Jun 2025 01:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1750841112; x=1751445912; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZgnHfrvb1ohAxqWBg7xDt3QN8B0f9Jh9ZGClguGU7k=;
        b=H5/nfzXIM0e3KirQ35/Jr3w8MbKBjYuIiBunXNGf+b4bcqTCnD6ZDmD6r/SWN/RLQg
         SaQ1tNdD+5kgCy6tIEX+uxvMalwN8UswllDXap7On4CzeESzJMZeBvZ+7pyeVt7ozZBD
         oPg+lAk9J08Z4jpht6fPhEZsjBzAF4q6s+gu2+RdDtoZCc3eAkdomfdWLF/kRHasrA7T
         XV1DLf0qUYl/VQcDREUILEyv5bYwWLY5DKbixy0frMfv9vPtFHkA+TrkKHz6rYUmovUl
         vp0t6rAo0dmxVRTMOiVw4SQNPdtQTu+579zU8FI79htbmqaXSOE/0ud2WRR1MY4I0kyt
         gSLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750841112; x=1751445912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/ZgnHfrvb1ohAxqWBg7xDt3QN8B0f9Jh9ZGClguGU7k=;
        b=hWOsCw8Sv2MsSzIbD1mPNvFS21X8txrqyEez7CVAQ5b+X9KtQMmmqwbI63plVvaXin
         86ldIdaNsQI1Tf2ET/2vc3uj+e2ia4I/NzW8mUh4Dk3NdLrFM5aP3nlv4CD3j3Wb4V5B
         OL9Vaf6gM2hMu1GJZFxgIP6ajWbOqmVQHSicSg5tlA1ax92lwma1pRgLEDbYcvYwsEfS
         9Thx/fwsy2ft5CWyL5lG1K0oB39v45RS22yksvpw2UQGBj7uI/vmQKmS9JUbZRRG8Q8k
         ePgwEEzE0BaTVyOhwJiCukVGFplIFRLYKH/SOhZVxU/XzgyT66uAchCzzqy9Jsg5WOS8
         Z1yA==
X-Forwarded-Encrypted: i=1; AJvYcCVJhUf8qDA727YLeFu8dLQugnNHNB5rKccLaI/M7qzll2jrc953KDrrQaXhgLyfqKdbCyRudas=@lists.linux.dev
X-Gm-Message-State: AOJu0YxC0RHZfLj6KJi3bxFc+iJOUGs0eDIt7HGZjBUiM85olAEgagrp
	1/grOgMEZONbJ6X2b2ozMrm6ZXl+n+XNiCIyIaJCSphvLxpLVsTTe5yPukFsaRO6BRwXrLP+ov7
	C9LNsoHuWHtiOmpsUAK2PsXMiBZWQ3AHNjiZT87bnJf7thbBrWoU=
X-Gm-Gg: ASbGncvnkKPYQ5KhByoeA9xZIdpbi2x++3cWfDzU9TsnUmhdz2dEkn9QCxkUvFLgsWl
	HxcCYMUo5s5/Gl6YQg5OLRph5wIEf6bcaixDMgvAFzuf2QG/Fs/xy6VGuKJG9hx6Ui/U9yl3rSu
	sy8DjndSx6e716Z69QXmswyzHjG4QDj4MSWVuIMvYpwoaz3nhP6jhhrPAJi6Cyj0m9k+lMg5aLL
	tIp2NUPapELb9i95ijqvBhz4/HU4MiDQC0GmNPwfbmeAqsc3cKLTwMXO2Cjh8nnu1Wg4NBEkLNK
	3uPbmfFy8eux4kY3iZagWDTRcGq5b5WgrwkU+l5If6hmqapSSIkxJTS+rzxOA4BInmzul/rsI3Q
	Nmu/G06fHSRI62TQeiD7zHURmFmmv4ZczRAAzvm38Mm7MGTcASBA=
X-Google-Smtp-Source: AGHT+IGyy6YLwss+HffP5SUP+oihK3m9EHxjRmtYMYfXhWdxLxeKPaeGlxm77RQZMQ31nRdwQyAxaQ==
X-Received: by 2002:a17:90b:1a88:b0:311:c970:c9ce with SMTP id 98e67ed59e1d1-315f268a5f6mr3098742a91.28.1750841112061;
        Wed, 25 Jun 2025 01:45:12 -0700 (PDT)
Received: from localhost.localdomain (36-228-0-244.dynamic-ip.hinet.net. [36.228.0.244])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-315f5441770sm1264154a91.48.2025.06.25.01.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 01:45:11 -0700 (PDT)
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
Subject: [PATCH] KVM: arm64: nv: Fix MI line level calculation in vgic_v3_nested_update_mi()
Date: Wed, 25 Jun 2025 16:47:09 +0800
Message-ID: <20250625084709.3968844-1-r09922117@csie.ntu.edu.tw>
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

The state of the vcpu's MI line should be asserted when its
ICH_HCR_EL2.En is set and ICH_MISR_EL2 is non-zero. Using bitwise AND
(&=) directly for this calculation will not give us the correct result
when the LSB of the vcpu's ICH_MISR_EL2 isn't set. Correct this by first
adjusting the return value of vgic_v3_get_misr() into 1 if it is
non-zero.

Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 4f6954c30674..ebffad632fd2 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -400,7 +400,7 @@ void vgic_v3_nested_update_mi(struct kvm_vcpu *vcpu)
 
 	level  = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) & ICH_HCR_EL2_En;
 	if (level)
-		level &= vgic_v3_get_misr(vcpu);
+		level &= !!vgic_v3_get_misr(vcpu);
 	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
 			    vcpu->kvm->arch.vgic.mi_intid, level, vcpu);
 }
-- 
2.49.0

