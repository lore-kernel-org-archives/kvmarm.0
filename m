Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED91E7E101
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884789; cv=none; b=OflY4xUqVnS3ghPuiKttcISvYhmfMg7ocPESi4X8ncghYAuj6R1XCjQl4qzuPGRgdbRH+S7iUb6tVGV12ylFrHzRszjNEu32QD29LpyIhXXND7SffUpmR1Fx9yeDp0apuG76/QzNq4VN2GmWMNhH0UEUYg1xwbkP4nkhAp0QwN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884789; c=relaxed/simple;
	bh=fpBNfUng3ivWZ/e1rNCZE3PiicNxTH+p1yaN63flohI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W5oU7dREUKES8oGiU19BUdsqSAQZDpMEcm0grj2spXon1LK/I+0Vg/QH6snuiD4kKWQcJ3tXzi8J2gwPuLvF1/Id1zRqUPUlTdGuOCnnbwoAt8NHOwmftu/ATlXbE50NC3olBKEHPanYi9e3McxZrg0D8Emxla7msu2NCmMiCOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zc740cQs; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zc740cQs"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-61acc68c1bdso72419427b3.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884787; x=1714489587; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0d8Ru5GVRSJ4WBKuASRyEck6e/9MaagweE0nrh6F3CY=;
        b=Zc740cQsWlG8nxdo7P0TIGZ7QIv1ZxECtnyoJZxjgmibn9BzyeNCtVvbuxCg4ZCZq9
         r9pWxjS1u7tUJzegAiD2mWr5xvvMEPTNqzzPG1dS2oTH2FPuPPCyCeB/0T7Wju7ajJz2
         KENCEf2I8Agk6OZbqZgOkrY3P14ZXu5QewCkgN2UJkdtEs8CLktXub0Hw9gSl07lzwcm
         FNMETXcaWbCpv/XjpvUpwC7apIuRNaGtUNOdUVlH6EUj/w0VIRmwsrWdPHsZZMJbU3gG
         TcoebKaxbKlVsaIw4rxjEcX6P/0l3I3u5YEMkhlpMOYPoaAiqLEepTzzttvaeImHK6gy
         9G2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884787; x=1714489587;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0d8Ru5GVRSJ4WBKuASRyEck6e/9MaagweE0nrh6F3CY=;
        b=PQrY6t18KApK96UnpclNi3sZUCyn21Zp/ArG8xZ/QueiHZGx7/FSlM/prFal3aD44l
         RhJ5u6lT5F+v46orncl8n95bMbu4BTqWjDOQ6yoWokkkdCKuDwM6rBmaOfQ2Skuzc4md
         aZueC152IQ8fIvDIalxqXwob0tuOHpbfx/zJvR/D5DrSeEThhPPLgHdP/ezHv+sfOrET
         /nEQW4F2mT1smdb/ph0zKivEhEyrzP6unN7ilFP8t/+bMGgUK7KWs+dLuRNzhrBJpXdH
         D1d0e0mPGGTG0epBb+ts4BfC1MpCCKDkLIKBzCAb2XwfDxEFdIlGnUhlUkcbv+xb8kei
         zaVg==
X-Gm-Message-State: AOJu0Yyepcziva7oEdQg5TEzjJODOu7YWsrVeIOZae5jYTAU1AbyZnLF
	7tsGTBgiEW6HMm6pxMIM/gBVIluK1ZcaqZbz5IEX48rFqyYDr0C2Mkz2rRvccDm5GsdTE2TnrAr
	7a2XHwVVN0QRJPy/XiTYzWtsOaSEUVACjEDH43tx0olc+/6covBkzXJ3pLFDDNWtFsleHpA4ysb
	/dj3VIQIaUoOb7ouXeWHoqWO+/94g=
X-Google-Smtp-Source: AGHT+IHJPJFU/pqDcWPEqvgTdiYAHoikIgpFetSd8HX9XA0sDGIBQ4TdNWgonFPDBSF2Chnwah0XE8YvvA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a0d:c985:0:b0:61a:f3ea:3994 with SMTP id
 l127-20020a0dc985000000b0061af3ea3994mr636617ywd.3.1713884786587; Tue, 23 Apr
 2024 08:06:26 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:28 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-21-tabba@google.com>
Subject: [PATCH v4 20/30] KVM: arm64: Clarify rationale for ZCR_EL1 value
 restored on guest exit
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

Expand comment clarifying why the host value representing SVE
vector length being restored for ZCR_EL1 on guest exit isn't the
same as it was on guest entry.

Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/fpsimd.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 63a6f82934a6..1807d3a79a8a 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -175,12 +175,34 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		if (vcpu_has_sve(vcpu)) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 
-			/* Restore the VL that was saved when bound to the CPU */
+			/*
+			 * Restore the VL that was saved when bound to the CPU,
+			 * which is the maximum VL for the guest. Because the
+			 * layout of the data when saving the sve state depends
+			 * on the VL, we need to use a consistent (i.e., the
+			 * maximum) VL.
+			 * Note that this means that at guest exit ZCR_EL1 is
+			 * not necessarily the same as on guest entry.
+			 *
+			 * Restoring the VL isn't needed in VHE mode since
+			 * ZCR_EL2 (accessed via ZCR_EL1) would fulfill the same
+			 * role when doing the save from EL2.
+			 */
 			if (!has_vhe())
 				sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1,
 						       SYS_ZCR_EL1);
 		}
 
+		/*
+		 * Flush (save and invalidate) the fpsimd/sve state so that if
+		 * the host tries to use fpsimd/sve, it's not using stale data
+		 * from the guest.
+		 *
+		 * Flushing the state sets the TIF_FOREIGN_FPSTATE bit for the
+		 * context unconditionally, in both nVHE and VHE. This allows
+		 * the kernel to restore the fpsimd/sve state, including ZCR_EL1
+		 * when needed.
+		 */
 		fpsimd_save_and_flush_cpu_state();
 	} else if (has_vhe() && system_supports_sve()) {
 		/*
-- 
2.44.0.769.g3c40516874-goog

