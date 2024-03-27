Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761E9137772
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560971; cv=none; b=gHO8x6zOtvhTe1QX4n3ePvR9ImxYgqDU6kB4Dm32dU0++xPYoa3eFAzMsHn58WSmBouQpzlaVSo9BxGeyescOIboHX01S6Pc7DksyvOgLVq1HfhhavDtS1jp78IP/TI3w4TZdC65PgcdZHRSuIe73SrbNlta2lHPgatxBS4ziAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560971; c=relaxed/simple;
	bh=TRKISnSuHJgXrqtqmhmIdDgTW+zlF1EUNGwi/MotDXQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zs99vzSUwka74gJvNH2m8hZIQm0VvL2euAxpvdKJYLbKHpQzH12ztcsvuY2AW0XIWMGFfF54wtBfUKt1kOSQQi6c+SlJAAg9C3wFXY7w9GbvcCNgyGt9gekw35sW6xk6aPyzMqODUG6CiPoXegbLpps2TXETYprX80cbJkUN/j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rheHz2Vx; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rheHz2Vx"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dd944567b6cso41214276.2
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560968; x=1712165768; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jxzAByZiGkiEQ2PK+eMYk6pqbpIcvJwWEXmwCgWVtWw=;
        b=rheHz2VxDqEGVzUUJHiWN3xtqTRWTqlAGzB5mB+Bbj1egeNlSCxMFcyqOuRH1YVddk
         S0xbvVAUajFsCQGDEuU4W7UFBAwEvdm1BPxr6q70CNn+1zS+Oixu/c8OR7J+xgebEfxy
         SDMfRGExwGBEO8SnL0hLKZVsXacRTWqlGVHDP+NZ4nrr5ODfvMkll/L0PN7+tdVbkJYZ
         0WsiPv058qZn+0TauO8BWs9wwADr+PQPIRPGXowj0IyVIC99QTvMYO3oZjQZ4FzkB7Qr
         rtXMUT9DXNHXfGvIEf7MuKKgqkPqxrpb8pFsG9XMRUMEoetK/4TBOaXn7PSXANlTTham
         r/5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560968; x=1712165768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jxzAByZiGkiEQ2PK+eMYk6pqbpIcvJwWEXmwCgWVtWw=;
        b=TDQqDvraJhEgwIlcrtvmJ2edNtiejfLQSTfoqyS6JAZdGSrJJ2GFu6b9mXErHAlbOG
         W6amvp3BGgvyjEVJPF5ov6RaL3bO/VjryBiZhIqXFiwl5/pFfsUykdM66UykCBQIhQwM
         z54YCbZjQD4H8x+ZLUUl1WAokgNaYklJfgT5PnvKeT2ANnLLjjAzdnPLeHy3GEPSl7qQ
         GbVxk0ZFWVNjqlXOOVdO9LaxPwShsuU0ygKzoVTnwQ50tcZZCjcQzr0mlloOe6SrLp4K
         I8F8tcWNb3kow1/wku5G1GeMpzJ0KDFys9WRbrQjr0pa4tGCzUqlDu2CyEQJWAtKuVCv
         A1/Q==
X-Gm-Message-State: AOJu0Yym0JL7NDeWQ3vR+aFJECMU02YCOJukGP+iGrqGOSM7ijYlb0F6
	OM8HlgYZRsxLUgfxlcX79ofWHetCmL4GveI7SFYkzW81d/dz/wqP5zoN56cGczQEI4V+kmqz1Je
	1zJ9vhr/Nza3jrtmlHfeyVGNwAch2NeLTsG5Pg5r/1qXx8dgZpdPVV6U+uyPy6UweQsobg7J7J/
	1v+VYt/R/dh3ihhBdcvGm61R+dCQI=
X-Google-Smtp-Source: AGHT+IHL+1X+CrVWUH2aXcXmodzdR9TAiovgOPNZFW2IjZdKR4HvoOrdCnDOru56q6sJCgk9axVM8Fv0UQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:2306:b0:dc2:26f6:fbc8 with SMTP id
 do6-20020a056902230600b00dc226f6fbc8mr63809ybb.7.1711560968433; Wed, 27 Mar
 2024 10:36:08 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:02 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-16-tabba@google.com>
Subject: [PATCH v1 15/44] KVM: arm64: Use active guest SVE vector length on
 guest restore
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

On restoring guest SVE state, use the guest's current active
vector length. This reduces the amount of restoring for the cases
where the maximum size isn't used. Moreover, it fixes a bug where
the ZCR_EL2 value wasn't being set when restoring the guest
state, potentially corrupting it.

Fixes: 52029198c1ce ("KVM: arm64: Rework SVE host-save/guest-restore")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 1a6dfd035531..570bbdbe55ca 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -315,10 +315,14 @@ static bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
-	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	u64 zcr_el1 = __vcpu_sys_reg(vcpu, ZCR_EL1);
+	u64 zcr_el2 = min(zcr_el1, vcpu_sve_max_vq(vcpu) - 1ULL);
+
+	write_sysreg_el1(zcr_el1, SYS_ZCR);
+	sve_cond_update_zcr_vq(zcr_el2, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
 			    &vcpu->arch.ctxt.fp_regs.fpsr);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
+	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1ULL, SYS_ZCR_EL2);
 }
 
 /*
-- 
2.44.0.478.gd926399ef9-goog

