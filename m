Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAB312BF1C
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 12:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717417741; cv=none; b=cpcB9JeXApU1M//rE2X3ysCPnRyXHhQ1DuDS7xF/4AIJTbhTkVrgnwyqqJfap9R+Oc/ri5lsCDXtlDd1O2Ku/THCefH95gFLRHG6gWd3O40mxegLBHHk92YPb1VdHFmJrsqo6sZUdDZ6t7z7Q56gfrYYAc8aX94ugkJcxxXNh4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717417741; c=relaxed/simple;
	bh=Zmd4z0euKCam2wVCcS076AoUEJGDxp9KtunqsVsxbT0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gJUne7sMRVijTlVwm4YoNMBbGWbYcwUdzZGS+hW2IkvoUNNtkEmlpjGTLqXvcEnxcnH9MLqTuG9JSR1i9mNrA9lrV1wiqjqTR9EQwuuOJvPBTUM+TFMfnQvbOt2rOVRqWNsfG6mwLQIUVYoydIX3Hp/fEOu7j//lZNIeKWK80tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YiDe/FBs; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YiDe/FBs"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfa8ab88a8cso2618838276.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 05:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717417739; x=1718022539; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Busb8wZE35tqQHea1drQPQ7SwO3FvWCCFh2pATpAbXc=;
        b=YiDe/FBs0IFQJTc3HW8Ea0Q8PQG+ixzum73k9gkEuZxapmTdWYxUJc19XnGT1+tJf0
         Ahu825hjBhZMubCHgWkqjZckZ054z6vrmHIxnoQ8tzz4VnaBQVvfdKFWOtmSOj+F/8f+
         8S3SwlQ5OVNYvQq1hxEyjbKlSYAmMhqZ+7HETOLcfa2UWZhQduYWOPWOAGeeor2rUF0S
         jf6GAZ20RAM81+yXRT9i88vHQK3av4cvw2JUxKEliawZj1X1URCDPaXgeYxwsNQgGH7A
         hgR2ljjqcYdCPwR7GmyRSzsAcv/nxBED1ZoN82kCnsNcgx96io0XUkn7kDlONiuEVEgl
         c11Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717417739; x=1718022539;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Busb8wZE35tqQHea1drQPQ7SwO3FvWCCFh2pATpAbXc=;
        b=VVELedTlNhzkyUX8c3NMVlpLdUqRostI8M7e2DcgH4ixbBBTXrr9y2bkOHF7CH9y68
         VgmB/f7x5CnWFrdyUK0QAUYRA8iwMZmD7vgYJVZFzh80VoLuRU8NVdzIPeGT/gzEtpBk
         H0K5AIQKwmzD/REfcE+0H6zm5tmhPuYk5mcpdAJshDohCIYHyEEEpuQqIweMi3VqpGyk
         KUjR/Y39Lncg07RNBOKFVjgVddI9YvMDVQN3N2FAR145+mIyltTAVUI+pxNyxUCkwDNY
         XikRULa3Quv205Pe7CWhGJvP25WD91u1vV1aDMUqSMoy8fy/2bZ1KazahnII76pHwymg
         ZlTA==
X-Gm-Message-State: AOJu0Yyyslrpx+81mi1FGfGUukH4uMn0JiblMOlHvbpKxHp1PNwlb/tP
	THQTFlOUdtF6OgfogaX/sE6oQD2Y57pppCnz7LaN6vcRbZKWd2xNH1eSKUXHFR9AIHBakPBD2b3
	2C4GdRGxNfd33Uk+IXKl06SZ1pqUiwvbwXdkJqjKIlL9qVPH40QOXPSv2kEj1QbN5jYE8+R1ivy
	BgkeDp7d4pouOBlY6M1yf4hBXZ7VI=
X-Google-Smtp-Source: AGHT+IFjNCBoVuMLP5rmp+nqXCTo9OEnaVWdBHoViIssIdEcBdNlZlICCOUEdrQeOt50djoQcToa5uIMxA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2d4a:b0:de5:9e4b:fbb with SMTP id
 3f1490d57ef6-dfa73c02d0dmr807955276.6.1717417738728; Mon, 03 Jun 2024
 05:28:58 -0700 (PDT)
Date: Mon,  3 Jun 2024 13:28:44 +0100
In-Reply-To: <20240603122852.3923848-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240603122852.3923848-1-tabba@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240603122852.3923848-3-tabba@google.com>
Subject: [PATCH v4 2/9] KVM: arm64: Fix prototype for __sve_save_state/__sve_restore_state
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Since the prototypes for __sve_save_state/__sve_restore_state at
hyp were added, the underlying macro has acquired a third
parameter for saving/restoring ffr.

Fix the prototypes to account for the third parameter, and
restore the ffr for the guest since it is saved.

Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h        | 4 ++--
 arch/arm64/kvm/hyp/include/hyp/switch.h | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 2ab23589339a..686cce7e4e96 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -111,8 +111,8 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
 
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
-void __sve_save_state(void *sve_pffr, u32 *fpsr);
-void __sve_restore_state(void *sve_pffr, u32 *fpsr);
+void __sve_save_state(void *sve_pffr, u32 *fpsr, int save_ffr);
+void __sve_restore_state(void *sve_pffr, u32 *fpsr, int restore_ffr);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a92566f36022..d58933ae8fd5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -316,7 +316,8 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
-			    &vcpu->arch.ctxt.fp_regs.fpsr);
+			    &vcpu->arch.ctxt.fp_regs.fpsr,
+			    true);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 }
 
-- 
2.45.1.288.g0e0cd299f1-goog

