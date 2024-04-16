Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9943FE2A
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261440; cv=none; b=P9vNoW8mFBBxLofvUn70YsHM7sWTCmXE7NLDKZNohx/lQ5Hi18t3gAhv4A5IQabLQ9lTRr0wXuZEieSusMTkrj9khoGiOhfYbZyAvjpuBHRpO2ta9suXn16ySjGRJK9AQyIj8wu6XftA1EM39yiRA6U6CfGWRbk1IAH7t/a/tMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261440; c=relaxed/simple;
	bh=I3nPfYA1XhlaCLDDbyKrXXCRGhvE0/DvhCO5ujBPDSY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bff7OukGuLT9+czHnDE4Pjy2yOrL/3dIu3Wtn10zWRzIMAdWlI3c3Thafeu9neXrRyI/qArZ2Wd1JflEbdPGgf/6M5DMnx8pF8fklPj/AnZ8kPCdOvdoOeoUC63dfLBMJMNZYFA30ohmkcApo3iEmrz11viQFQ0+bS9MQMbb7Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=INVLTZXF; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="INVLTZXF"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-416ac21981dso21910305e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261437; x=1713866237; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o7tD94KBuY6Wy37p6zM4l0hq2+p4oAokEU4D5UINo04=;
        b=INVLTZXFMz6yEbc9Op0BcCs78vFHnwtG8cIOdTU9UUaiKDltqWdYcGZvtfRBIK596q
         A+5UMVhIj3Wia8lEkNq2E3yElP8NpySrXx0z/ld8WMlY9TwlFrq224NO+h6t+vmIgbqo
         Gze8HEf8a0e153r8moqateOejMx6xRKZqiXm8beWdVea/e0mV/Uf9Rb2bPtki0Q6VjZg
         qb62DNiZzncaEpC1Bs/NBW3h5VW+EEKjQf+NpPaM58zgXZfWckD7jV9lkJBbn3ZlH2ai
         Sr/iCzavEK6sd7nU6gPKbWFJuUr08Y9irD0Y7dfusLfdRUHHh+qgm+coUh2SRvMcf5xH
         cWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261437; x=1713866237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o7tD94KBuY6Wy37p6zM4l0hq2+p4oAokEU4D5UINo04=;
        b=C8aI1hd7/opXmP6j9vW/BnCm1RNGgYswPCOPT4ldzsN3vurG84yTZYDylzUC95O+hs
         2kockc/ceIxhQvTjLiHfPe6RZAWTRPvbAfr2AbsIHJMSuiNjsNktulySm6YRtm0SHAsu
         07kRv3Rye4vxUAiLHxcKG5Vn9d3EOi1ggV0IxETEW0AC2a8iv6W3DhXxP/2cwouuxUHo
         tTIW4ln3RQf0fc5mbTStT57izaJFFG3HhVNTcYKvc7+gHOrONzH9+DLrbK4G1Sx0Kvar
         8BZASN6MZl3Ex1dlJglvOjJ0c7V4JSDzG3/sfXAwDUuSyNphGAp8945gBRaIE3keFJe0
         5HOw==
X-Gm-Message-State: AOJu0YzPex56Nc/Wh+vQNxZvtRt7MQnitc7ru9UJd47wsqz66KUNggSH
	8aaHHXnPyVVoRz15Xfz6p2yfL0jApjYuTgtGDh2iJqd1G79qzeIeDEJ6UX8UaQRPgdrJlRcDHff
	JGX32AtmNBYxA3e8XjHGlb3TsY+rMtcMSvkpq6uJTBgblSTLcWe1cbcyfJqHhGW80LqbAPOBy6E
	oOaiOQwRZ6PgZiry2SvuU379Koe9g=
X-Google-Smtp-Source: AGHT+IExV887D2TymktFR8/oyi5eRcoGgiHecDE3DhyMZeMC4UyC0nDDwHJZKDJxWgLE8oaq2w08uOcNIA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a1c:7709:0:b0:418:9a5b:d68 with SMTP id
 t9-20020a1c7709000000b004189a5b0d68mr8715wmi.2.1713261437546; Tue, 16 Apr
 2024 02:57:17 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:07 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-17-tabba@google.com>
Subject: [PATCH v2 16/47] KVM: arm64: Clarify rationale for ZCR_EL1 value
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
---
 arch/arm64/kvm/fpsimd.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 7507dcc4e553..b78b87a120c5 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -199,12 +199,33 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		if (vcpu_has_sve(vcpu)) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 
-			/* Restore the VL that was saved when bound to the CPU */
+			/*
+			 * Restore the VL that was saved when bound to the CPU,
+			 * which is the maximum VL for the guest. Because the
+			 * layout of the data when saving the sve state depends
+			 * on the VL, we need to use a consistent VL.
+			 * Note that this means that at guest exit ZCR_EL1 is
+			 * not necessarily the same as on guest entry.
+			 *
+			 * Restoring the VL isn't needed in VHE mode since
+			 * ZCR_EL1 fulfils the role of ZCR_EL2 when doing the
+			 * save from EL2.
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
2.44.0.683.g7961c838ac-goog

