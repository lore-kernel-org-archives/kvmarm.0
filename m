Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C2F3218D4
	for <kvmarm@lists.linux.dev>; Mon,  1 Sep 2025 12:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756730754; cv=none; b=Iu1oIQ75b/75PnbyTNmDbTbEdW4G4KBfsSHzIvhuOR2FTaesjE6f8UidfwpSgMsuqLcNx7TwwLq32b0ZthmbORrVvP986jKR4184S7DZL9fD5B+9YPHgVPz5dGxK1OjXQM0X3Ek6uFTWt2fXF3BUZH0cA5UgRn2mQn4rNJnkG20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756730754; c=relaxed/simple;
	bh=kKPxwMDQ12/QlFsJHDAQpUGCRuy72hF3jfEmjy7TKnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fK5NgFHdiCdZq3zvKrZg4LheOvmkKPv4WgOI+0On4S4Be6NQ4r0opO9keLPaUSjIoDZ2bthTsV6oEY7m95joO5VdKpC6APFatmNq8vndUORYeM1iuQcS8EgdhH7o62/flF+vWxHPoMb/GwDliGpeXlyYCxr7ZZ184rHGV2d1iZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EEwAMusX; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EEwAMusX"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76e2ea21430so145953b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 01 Sep 2025 05:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756730752; x=1757335552; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0LJ4r9mMq8e3mdNbo2g6rD5aD5gZi5B+2aiqw18aFtk=;
        b=EEwAMusXcuAGRTM762M8GyIaATDZV5QtO9rXtYRZsqpGJZaXcytvntUjfJEihVY1Kd
         MZziiG20OdAXWWYzK3IzQkWewtPe30fto59eudq16LgnAL5qULQpycPxIwLE9FKPZa4P
         1/v+vnFeNI8PWYOPYKMew/YA34EQpJBxUMrde9FNLeOcdo9vwiWXPe12sgw9pGtwRtnw
         9tav3dI1cwh0yAw4l7Gc0GGdA9KzhcqZYSSf3KkRxNCocym3NJA455Ghpvs461oYFk0I
         4LDKimpR6dOMnua+GPHC6OYyvQdZOZkQ4VYJzdS28EqIUOSSiSgclmdpvXAQnHMEL0xb
         vPFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756730752; x=1757335552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0LJ4r9mMq8e3mdNbo2g6rD5aD5gZi5B+2aiqw18aFtk=;
        b=a8t8z60Rh9EcJ4ZAhefLyKNzX8rupiu/WuR1S5wmWPffl+16A8Xt893Y0KM12fZpMg
         9XLjRUj4+g+fpKjS/fMKITiwOltjLtvj5HXCV+OY/Uj+W4igN6RlDjZ2ROIWWi8Uw473
         hzliFVh19lkbLcbOPea3/G+PBA0f7A8po8sMSG83/+1zkTz6pTn/O7ASzzHyIOfhGGd4
         ubjEIEknuwOwGcHKGYkSoaYbk7C+eL7B+g36ADnTzwOmAGl4GoNkFGqEUULFjSOb/88W
         y84ZLE2ryRCS98nsy4julykV8nsNiCTDyBYseJ+tbAAfdx+gvKPA1zMVaISt8MK0mKFA
         782w==
X-Forwarded-Encrypted: i=1; AJvYcCX1UufOqLUY9mu21LcHBcEfi75BsNZfQEbGhBt8FS8kuomzxZloho0vDIJmvWw+qKRXK54nA3s=@lists.linux.dev
X-Gm-Message-State: AOJu0YyaER54qrnrGLGLR6jZbd85BiIOcQlqzMn93OXJpRh8Brc9SOff
	RfV2VrBHMtmbO77ozMSm5wnAMGXmkzS+MFjQhZeHjt6AloucvQT+td68
X-Gm-Gg: ASbGncvg2mCYBIc6Mya8H1VnvAgCv99zIoimBPQKTsm28Oeuzj9CoM4/7dJQKUzY3RR
	yKES+eGW2O53IXd0W75DSdjufvqZ8AIIWjwpZhKHFzGaoobr0Be1RpqbTQXoM7iFz8HrVeDN4i7
	4MAdDZkrCCaCNmB1ONQjHGwvA1hF/bGy6VA3eSk8MSS8LmttpXdfTxM+XDcfiTyFAsCLsseFS2s
	6fFo0rhHWrWSUiUChOVXQe0w6Y/0P5uG04blZ2rMFGtz/1pTbdbbeypB+1PU2aDOUs5GNgxoagm
	PLSlpJ5asza0e4buFMSkflN+A85sjG7MmBCbDxUU1h1R3tV03Hf6EHtI4OqXYeS495ASJt0hIs1
	8F6GLCGDy1kGP9xz+Rdxs1w==
X-Google-Smtp-Source: AGHT+IHN71zGlOOMRyH+O5wcaJBAY1QklGt6JPB0plU5qIlkRtUqi8nYhrHaVrv2vP+4Uv8jYf4bYQ==
X-Received: by 2002:a05:6a00:928d:b0:771:eec7:a71f with SMTP id d2e1a72fcca58-77232874e8cmr5779479b3a.4.1756730752213;
        Mon, 01 Sep 2025 05:45:52 -0700 (PDT)
Received: from localhost ([114.70.121.22])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7723d79fcfesm7553805b3a.16.2025.09.01.05.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:45:51 -0700 (PDT)
From: Gyujeong Jin <wlsrbwjd7232@gmail.com>
To: maz@kernel.org,
	oliver.upton@linux.dev
Cc: joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	wlsrbwjd7232@gmail.com,
	gyutrange <wlsrbwjd643@naver.com>
Subject: [PATCH] KVM: arm64: nested: Fix VA sign extension in VNCR/TLBI paths
Date: Mon,  1 Sep 2025 21:45:20 +0900
Message-ID: <20250901124520.54259-1-wlsrbwjd7232@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: gyutrange <wlsrbwjd643@naver.com>

Signed-off-by: gyutrange <wlsrbwjd643@naver.com>
---
 arch/arm64/kvm/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 77db81bae86f..eaa6dd9da086 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1169,7 +1169,7 @@ int kvm_vcpu_allocate_vncr_tlb(struct kvm_vcpu *vcpu)
 
 static u64 read_vncr_el2(struct kvm_vcpu *vcpu)
 {
-	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 48);
+	return (u64)sign_extend64(__vcpu_sys_reg(vcpu, VNCR_EL2), 47);
 }
 
 static int kvm_translate_vncr(struct kvm_vcpu *vcpu)
-- 
2.43.0

