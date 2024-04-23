Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791F813B7A3
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884758; cv=none; b=LQXWhokKC4Iqs+/EraTm0ikDLg0jqge+LTkH8PeRROodCuglQtbVQc1pF21yXBeYWD2KE6wDOEQf2FjhXQovV1/2docigGhPC5iT/gaQl93cYWOCTVolHtDC0nBVWAb6P/5461ClcNBty4WbGF/1ETPNclusAMK3NwBu+yRRflY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884758; c=relaxed/simple;
	bh=VNHXQksJlWsBetmOy6ulWeA/n4/5+YDGGSzeE+WSPDM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=amTYOS/nGZ4P++Ul/u+w/Rf1C8OKxboLOuyodbQHSpSgeSm09d5gHB6/nS/awPGGA67reDQsN5HEW/fy/t5dMAp4z4aIqEWIVLJzpgi1AvFsZey0m04A5J4s+xfifB4LMgdAgpy7WDMpi0DtM0tsWL/1+RHiAmcaIC9ohPRGT2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eh33J9c5; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eh33J9c5"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4183d08093bso33542485e9.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884755; x=1714489555; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eNGHoiTkTpooDRBs+AgtG8mdi17/WQB8g/BFrlfuCbo=;
        b=eh33J9c5AZJqH/9XvPKZqAB3kP66xbQmLT8b+lnF+IPABC7kr4EiKYTDadZX9z1YO9
         bcYmv9fh0n8O0nED9NdBDAsZh5ecTCzpk93J7CquRJ4WdBq49KLcCPZVb3AUqn4+FdUi
         89q1I+xnKCQNWXbMC0PEr9X+Zahw4ESJLINuV4SrHYTC+QtfodU54+rkUyYt46bhkmpN
         +iCzzRUAvstX4tiB9KFMSWZxXA+W+PCgiVg1sPyfOyRxwBEZ/BYGa3Tqyai7cmvjTVJ1
         kqFdAE6GX732uhNzd8bnua7/q+RQhWWb5fgGu1iYHRLV05dMKuMUB3/5XuUud0kWLrNz
         jCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884755; x=1714489555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eNGHoiTkTpooDRBs+AgtG8mdi17/WQB8g/BFrlfuCbo=;
        b=OO7Qpqh//CIYZl9Pu5Bc8FW0lKMHra0CoBJxitlVRMt6Ug70xxt8QoSQjg1sAhHl1C
         RjmyGwrw/3ju89qjhopsVwM0zUEvGWPPPGfdWM53dVhyMgm/a1ia8ve+xrnzOnYZyV72
         VNmNucGD+Z2fEf7Qk4VyNHH81pt3ChL4u183fjMRxO9WyHE18/C+cquvWM8tBIQGsoYI
         ajLu/ctKAdkhcN5ASoDo1VXabWVd10wCAZqIqZTBXbxngM1MS/DM/3DeoJy10vYFlwQ0
         jb2Bcy8PZzMYCH8fG402QKNjAg6GAPeIr+xL7AVAbEZgf+Kc1zn1X1f4YHGtDgm93Ux8
         QGgw==
X-Gm-Message-State: AOJu0YwEBldy8Z8w6QTsmojOLrMZUSDbHwCI3z/w2nVJH2eCnzMrAWT+
	ZgS8sXPEYK3Iz0hZOb03oGws1f+x8IcrIz5dyEvknviU9RJgRbj1seeRSlMJQC++aA5pShx3m54
	UZlYRDbTqKFBJZYDCnIMDjuHCwPzOMj9+QAJpwBXfa6AJ2mAnuI9dQQx1Izwh3Ksjn9kpKExvSH
	YzZ52h/EO0mWtBt9zVnOU+xCK3/+M=
X-Google-Smtp-Source: AGHT+IFtkasqb8Usy+hm2WyUcfFdS+j9LQXv4CTm/oGFoMA1hg4vZIdtpnhhdT4J0KgL0Cn5yXnn+EO6fw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4fcf:b0:418:3eb7:e8c3 with SMTP id
 o15-20020a05600c4fcf00b004183eb7e8c3mr151869wmq.2.1713884754564; Tue, 23 Apr
 2024 08:05:54 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:14 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-7-tabba@google.com>
Subject: [PATCH v4 06/30] KVM: arm64: Avoid BUG-ing from the host abort path
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

