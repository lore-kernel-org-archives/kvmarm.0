Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8B146453
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 07:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513599; cv=none; b=niclcAkbyuotpiRye6UFNixPAodvi2GkMB4w90NCoDUytO2AVyjcpEgLK0SVNzly5neouf61Z8Ix4A+YFuPxZCaRaMLfqEel1Kdv1o69DJgeLX0Qogh4GMShqEaaDugyIFzXI+Vz730OjUPY9DXKRQfVnOiceZZ1HhwPH0pIjg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513599; c=relaxed/simple;
	bh=VNHXQksJlWsBetmOy6ulWeA/n4/5+YDGGSzeE+WSPDM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jGUapeCC0IgGI/nhywKnKWijtgZ2btEqwSdyLAu4pkCzEJw1vGri92mA4WEhOL9FyTTl2yf/A7xqRBKsjarV6zoTCiHogbd8cHHN9SiFM4vkeerbVWowWvl4mdnBMLlw4RmWhiZ3TlwnyfKOfB1dcSVRUueQZR5I/oc5aCh0irQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YeS3eqUN; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YeS3eqUN"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b2abd30fdso22946087b3.2
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 00:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513597; x=1714118397; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eNGHoiTkTpooDRBs+AgtG8mdi17/WQB8g/BFrlfuCbo=;
        b=YeS3eqUNwyDRMn9vC6gO65xJlR2T1kqoL0DlbrfwxQiln74QoDDE+YHfp6vcjUef4d
         eEp6M2/yIn+/bWizllrqTl2Eg1LbZ709h+fWmo38Zo8lz4Rhz/uf2wdsy+Xdq6cfK/rq
         1ovrxyVFnrQH3/4BDk/UboBoga0oY2J2ZZf/+ndIToVN5amjC6QZKYDCtxvCwS3dOqtZ
         nYqjR1vZWrLw8t23C4GmNmPjeXi4I1HRmD4MPBKCvEtkTqg+RzwS9eGsxhO4hKajytDY
         Vtz2c9NTejdQLho5aMxI60M84lj8Q/3JenWlKGy9He+bvx2Gxob4KBCd2VrHesFO5dEX
         66KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513597; x=1714118397;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eNGHoiTkTpooDRBs+AgtG8mdi17/WQB8g/BFrlfuCbo=;
        b=v29OB50NXh1NBFd734EerukOLEFj+F7nbjj8pqH/QurN5IPAcgCVEd/jOEaPFM1DVu
         /t353MKPRJ6dApJ5w5iKKGvVYVTVv1Bm3M7ma7iXxxYQzFUg8Tddj9S1Ivci2WC0dO+P
         dS6eWjsI59a/5Bk1obAm0DkGci6AsZglzIV3O9t7sApLnVu931jEpkitKOLlGbrSW263
         QtHuBNUC1LJRRQcfVrxRwkUy6DecMfY2tnfBrTib9EqkZM+If3y7UjEwXb4y5VWEqgtx
         a1DFtV/7PFNgGLTa9LCUIF/MSGs1PD0iNCnDmbTitxeXF8lGOaERpM0mIW1FWw7USBd6
         Lraw==
X-Gm-Message-State: AOJu0YzdQ5NoKyYzW8xLVfzFoiBBHiyLktq1JzhtBKmLk7mod7iSwGKv
	zynDcy+MbZarUjr5ZFK74mpkPXx4d3U5sbzgFNx/te/5nYad1s/xptEoxg0TOwzPtIOhHqSw/Bw
	VDg3qupF75rrPxdzNZHJNN95I3Mo4DHKNuHoNTDm/BB78wa8ZP+85TRpwuGr2H7SENJOMJTnycZ
	OGGl8cPaYUM6F87siggRCtEsntcbs=
X-Google-Smtp-Source: AGHT+IG9fvQq1b2x7wOFeZBjBNJd35hwN4EpUXRyxZ7wP29xHNDhGQfZ60vZ06Rm8+wz83DEbgicrCw4zQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1208:b0:dd9:2789:17fb with SMTP id
 s8-20020a056902120800b00dd9278917fbmr83332ybu.3.1713513597164; Fri, 19 Apr
 2024 00:59:57 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:16 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-7-tabba@google.com>
Subject: [PATCH v3 06/31] KVM: arm64: Avoid BUG-ing from the host abort path
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
2.44.0.769.g3c40516874-goog

