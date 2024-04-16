Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDBF2907
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261412; cv=none; b=kYIa7QfqyX84A5I1hyT9QwUt7X7sWRWGzoIHxUpZXwqV+GiwHJJ3lHZnvPl7M72kjGLDcxpaW2g8nT5H/ByX/+nImia6kAHb0+ziJUsrXpS90qE1XL/yPfAq80l6J90at7vCX9wQ8yO0BkfoQWFfZTj73cT5A4u62M/9zZ+Z6Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261412; c=relaxed/simple;
	bh=uBAthAt+dSreIfXLEgUqHvtSbyspilQZ3DattG9wdtU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YZVrCeZ+A8NVpLPLloFxHQv/Ewja46GAlKJj3KCk8pAJNHH2dsYpBefmVPwclXKr/SKQVhSnJJ/u2ZvZx2ezpilM7sHR6rFzu0iaH1LFieraWOOtISA7CwMj01vF1LMv7ELyOmWrfaXm4bsN+VMkjoAcrER5bXemo6hzJXDt0Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TC4G2bzP; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TC4G2bzP"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61ac32822bcso37012947b3.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261410; x=1713866210; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LNBCWaCzOWk6qAHfDbivb5OAewgk21uXlkmXN1govU4=;
        b=TC4G2bzPDNzRGTIZNldfGr/0Qy8MW+jc6LokShDaV3ACWa8IZgSIgWLFE0KJOMGsSJ
         peMdDH3eAtmwaoovwkn4HNITjU8awfjgPYaZXabcedZH8mcddOfUOOtH84LMDtv8hI+t
         RF66+g1Taz8OgcuLm1kjbD0CAzYTEs3Wsdk1GcfWJWQKPxo2Q/USucBidRl41PoXil+O
         uzEznLUnycqYVh0T1WmjVQG3ucr6z7yO9A85ldNXfbRYM1eu8lJwLgy+oOczQH7I1u8g
         LMtl+hthTXMYrvSFB7FDD+8KUIx0PRejMhBst8W0ui9eMjsWTqLcoD84yfHF37VFdfiK
         PoIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261410; x=1713866210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LNBCWaCzOWk6qAHfDbivb5OAewgk21uXlkmXN1govU4=;
        b=imzcy6Ka7h5onm5HfnkYTocbW1zUkEx7zks9hJ0oAv+iXV5RCOvOAM6f8NzWKMmMgg
         7eZcgrgeuipW+bAfm48QD98IMAjcIluof+buDA7vScF6YRQaqha020btUKWmxwsPxtQq
         Qqaimn+7+fmYpCCbQdMvhmDcZA+0OsVu0Pu8s+wHGf00bsdiCYa7KeHNGqo3aYP4jMDH
         ryBQ0pfGYkzEf+Cl37Kb9pnNCPh/gOuIHLlH26VFWOkenDMLU7qAZsaQLF+V7Fan53NJ
         f2sXEhQE3h0S3Ow7WhVf/3aVbG3mB7e2wxGbw55Nic05JqO6OOvoVbDVPzNIbspnSyt6
         fEiQ==
X-Gm-Message-State: AOJu0YzyclVxVgk7okvdbR4ld91+51uZQe/VMWokBerQWf1urJAFG990
	ovZS/Rx+S9tpcbsAMfHrCjnS8DL97tryhvPgyq1YHizHLYk5oQSO1B1LmTXYp0iBux54Q832V5a
	65XwDDmZosVAWJB8NKyy9kua7Wy3UsG7/RZoAAMQaTXLnIBM2/8gS5vKSMssXzonfAb01QegNQ+
	Rw5bAgtElud2End4zmG7K4ypZ9Qiw=
X-Google-Smtp-Source: AGHT+IE3ByQQR/jeQ5wQwRPFKmyXLX9RE0fDczG2bU90ZeOCCntSZtWIB5FVagmFluAMAd3JZpfDqKRg1A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1826:b0:dc9:5ef8:2b2d with SMTP id
 cf38-20020a056902182600b00dc95ef82b2dmr3638942ybb.4.1713261410251; Tue, 16
 Apr 2024 02:56:50 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:55:55 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-5-tabba@google.com>
Subject: [PATCH v2 04/47] KVM: arm64: Avoid BUG-ing from the host abort path
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Quentin Perret <qperret@google.com>

Under certain circumstances __get_fault_info() may resolve the faulting
address using the AT instruction. Given that this is being done outside
of the host lock critical section, it is racy and the resolution via AT
may fail. We currently BUG() in this situation, which is obviously less
than ideal. Moving the address resolution to the critical section may
have a performance impact, so let's keep it where it is, but bail out
and return to the host to try a second time.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 861c76021a25..caba3e4bd09e 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -533,7 +533,13 @@ void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt)
 	int ret = 0;
 
 	esr = read_sysreg_el2(SYS_ESR);
-	BUG_ON(!__get_fault_info(esr, &fault));
+	if (!__get_fault_info(esr, &fault)) {
+		/*
+		 * We've presumably raced with a page-table change which caused
+		 * AT to fail, try again.
+		 */
+		return;
+	}
 
 	addr = (fault.hpfar_el2 & HPFAR_MASK) << 8;
 	ret = host_stage2_idmap(addr);
-- 
2.44.0.683.g7961c838ac-goog

