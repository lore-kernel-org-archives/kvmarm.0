Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B9A2951D2
	for <kvmarm@lists.linux.dev>; Mon, 12 May 2025 13:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747056619; cv=none; b=Dda/4QQ8zC1r7wPpGQmKz8A8m6BKG4SZxDVGQBl3pPgGCIb1YMwXglMz2e6jefai+Z0ishLU2b+ErfJ4VFko7b+0bYCvAXaJmmIFfrgj8ukOP2EiMrgFiUh55enQwhLw5mvFL/WBPIGakNVYWjdB1Q6x+9f5XDaqMoZ8dPDoJRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747056619; c=relaxed/simple;
	bh=O8oz5UvKiTFaAgUQe1w3ZHg8nAMDBTrMSIwdDYm3EAE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GiLHaBBFrNYB5eLi449KOMg4UUwMvApiw/BYE0qFUEn8sxcePlOvTFKRtdLK7ddXMKZjmUuz3iYsSgGSVPTIprc1e8dQxWLLgT5waC0YwiyV7aaj5tLu1r0/UmXWpIiClCHlOQNL2ot62ibwaQ/8wt5h/8sapTT7qC3lKF/fzkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=Tmlzo3/3; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="Tmlzo3/3"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43d0782d787so30489345e9.0
        for <kvmarm@lists.linux.dev>; Mon, 12 May 2025 06:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1747056613; x=1747661413; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6O0jvL9bp0RhLH3gFStx+IoQOSIzReGN6we6Sj8t7oo=;
        b=Tmlzo3/3grvs8PTtZ3oH5odCBX7f1xKcMx0AssoBBTKPAx6tHUTXuSBm88n67V/5Tk
         nq3d43EaIJctMoODKExsCVzCw15lodxRGrFdkjazSAzBH8m4lrj3obDVrCY0gZk+fukf
         BP+b2VQkAHOJazCwlZY/xiiw/7O9kFdd99G+9F5m4C5ujUqRVLv1fZhuD12iKrzw9Dq/
         /fMTstKXe2SI+PdZapW6oSZgyk9oyDpnudRyrf6C5eLtwCFC9gxoA+qV4fuRaqmz0rey
         YXHCMUzmZfs/kWfrnMFvaYdrMpB9IVj6c0KhfqS2bRBwmje8e1bCxhoMEd4viK/Xlhh4
         yzGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747056613; x=1747661413;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6O0jvL9bp0RhLH3gFStx+IoQOSIzReGN6we6Sj8t7oo=;
        b=FBewG9IxOpIqVip1I63W+TEps4KZWRgxuCAeC23Bj3iv1AiHnNo9XkWrc6xqKPIDGv
         bhartTOg6HTpjdoVVQt0HwfVyDkI34Yzm9ym5wDyAIBrGNkOTWKUDDMXCieOaFyh+B3E
         yJpHHQv0WrJ5Bvqp7nM8znAdA8AxDc9Os6xDylApKWEc4UbIQgo0UT5jBnqfNN3JDpp2
         kErP241J4VfoEBnXtaZrTvbaMsP94m5BxAvQakv1tb1Z27rZ1H/cqNmqySGbV436jfJM
         3TeyUqmG0OnvYYaxy11zLYrv4lqCdh/r6GpKqUSqxHJdRNV5NidZL/Ztt0NPL8oUeqL+
         AwjQ==
X-Forwarded-Encrypted: i=1; AJvYcCULcr82FkJmVxCLPu6hQxfd/SOrBo65j4sJWfHPec/coTUG0N3GpAuyQtQ1CzeFVYmrr1jUUAo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyNTG3ctjyHb9zgkJL+2GUWz3RtM6Lm3CG1cxhaZ6HgasLtVE3
	GU4AP6yv81gW7QuMHPRpqQfsnt+QbzhGD5eAhy50eR1eXgRPuXO07fgtCrH9Wk8/Zq1NIDSUw/H
	ShPJ48ACgMNIdFoc5aPrtHjTUAkqD29ImAhsXy7ozM5DIQJA=
X-Gm-Gg: ASbGncsoevciL8HBPfClqKsFqKnyGi09Ku++zJifPmzrSuL773beAU32OsLtJwvF84k
	Z6IAR2Ig2lsdaQ++C8pR9J5U50gQohl5ENowx9icBowfr7Zj0hmZHipoKzgWgAg86K6E2EaAl2O
	WtVcB5aIxHNTws34iAgQ37oxQBEZc4UX1EkuZvl1F5t98sR2sdp6LSVYhDcfgfJNUzaLnoB8AiS
	5iBnijcZADapOijGTkj6qBzjUXBBF5b6OQIgjxzFDlC1oHywS/gCLWd7pC4ZeZ7rMN8ZYewRvJ+
	qrDIkY1VEtH/cK6cyLlessPkX9KIQfghPrcG8VAW3TBpTshWDA0WvNKClsLnNwzU6vFgCDRl
X-Google-Smtp-Source: AGHT+IGvjNxhAX66VVq4W0wV6STryscjMOGjWiI63Myou666P8Evc1sc/t303qv3kgeVp110Hjntxg==
X-Received: by 2002:a05:600c:5250:b0:43c:ea1a:720c with SMTP id 5b1f17b1804b1-442d6d6ad52mr105665795e9.18.1747056612621;
        Mon, 12 May 2025 06:30:12 -0700 (PDT)
Received: from localhost.localdomain ([213.157.19.150])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d67ee33bsm125593325e9.20.2025.05.12.06.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 06:30:12 -0700 (PDT)
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Christoffer Dall <christoffer.dall@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
Subject: [PATCH] KVM: arm64: nv: Remove clearing of ICH_LR<n>.EOI if ICH_LR<n>.HW == 1
Date: Mon, 12 May 2025 21:32:23 +0800
Message-ID: <20250512133223.866999-1-r09922117@csie.ntu.edu.tw>
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

In the case of ICH_LR<n>.HW == 1, bit 41 of LR is just a part of pINTID
without EOI meaning, and bit 41 will be zeroed by the subsequent clearing
of ICH_LR_PHYS_ID_MASK anyway.
No functional changes intended.

Signed-off-by: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index bfa5bde1f106..4f6954c30674 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -240,9 +240,6 @@ static void vgic_v3_create_shadow_lr(struct kvm_vcpu *vcpu,
 			goto next;
 		}
 
-		/* It is illegal to have the EOI bit set with HW */
-		lr &= ~ICH_LR_EOI;
-
 		/* Translate the virtual mapping to the real one */
 		lr &= ~ICH_LR_PHYS_ID_MASK;
 		lr |= FIELD_PREP(ICH_LR_PHYS_ID_MASK, (u64)irq->hwintid);
-- 
2.49.0

