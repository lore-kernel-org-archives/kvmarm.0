Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D322B8627E
	for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 09:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713261506; cv=none; b=WEWb5EPmXqf+a/c07cy1P4NEzv0mIv2ScHhqhiO8ttb8pKTRim77NMAYAkL7OFMxVY/L2AOcN2/t5P532XNMJ6jD+OqitmHQGd0Y1nq3AmxR5t829ETh33B/cAk/f4oOhMtFLeh3zs+g7XNwEB3LPG8z7jwS5SoGAlMVVwd3yQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713261506; c=relaxed/simple;
	bh=D622keFcBR+86Jle2wEFFUBFJ+mtMysx/BReBBm+ELo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fzZIDAJrIRehr0z+R+zbN5ctxc6rZVRZcUztIuWjcK9f9d5LyBTE2QxtJXlmDSxYUwbyrw617orbIqKNZzI+CslMMv4MWjuWnlcDkajFKwzcW/EyspjHNN+uSTyK0CR/OcE/Mfc35TmlCGNfQ++u6tmDwRED6HnN2JfS3SIXfss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O8AyRo67; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O8AyRo67"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-417bf71efb4so22012585e9.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Apr 2024 02:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713261503; x=1713866303; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0YeSWoOUW9xOuVXf9LlKxvIbo7rEQpYtwMUvFF2y8IE=;
        b=O8AyRo67Gr4eHYj2EAbvJbdRRmhWdlqmaoVlP90PwU+YTe9KxFlnz40NmQzlQ5SAaD
         Rzsole430jaqitDaOf/KsUQlZM4vtUb6J0HSz/kiujqUS+4SQwe9DSwL7vimMgWokcc5
         XEvYGnaQZtPHqEXAmj0+Xm75LB5OVIJG9tw7++DnPHZdrEbLvf1t/f0AfFgjABZcAtsG
         yqCaruyJ/2BfkfC8qwWMpOQObP4OYI2YpYQlb7v8bEhtGQwwVcb777D3VJ5EKBSj804d
         rcfoSkd/VAquDnAlwLgSU4NoUVj6kJuXVocumbOs4zRT49TnrOkLQdosVeLzfPiYGzAQ
         c2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713261503; x=1713866303;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0YeSWoOUW9xOuVXf9LlKxvIbo7rEQpYtwMUvFF2y8IE=;
        b=M/DNtdN646bM1RqUCbW0o2u6NP9glttnZy8glJC6O2+lVvEHRF9BBw+mNK/Dzo6pjN
         8Tz8rKkqNjOtbHk29qs4XudiNfQR7vbBw2bKobs3NHMPYVTiKpPSMS9BvUobL85DITos
         AlJ3VYonGkaTUx1+VOvgP0qxpRDcGL18RyWlS1d6umnhW5dKvTPdDH3Fr+8uOr3o9Hr1
         1JYwi45F/qL6+J7x4mf7eOC+R2ZCUbCtYJ7AeoxLZIJ0mwO6dl521OOrzG+KLJCr7C3w
         3y5gPteq8sKwSIb/KqPdpwP3XSFTgLjAnLD2iflM7+DdgeYg4Mujsy6iAJYbeximePjg
         SrNw==
X-Gm-Message-State: AOJu0YwJ8IPYuJfXZa+IK+KFUA0nBsdUP0AuN/Lmsh6cXxz59y5THd02
	ZxPldUMbyBwZzeG+chDtGDM5QxGyETlwCXYVZUdXuocf/68H76+GPjsXW99oavqOXUKJhyMNhIg
	BQLFAAbn76YqGV+8B7JJXQeIs5KKXPmdcMVp8Wq4ZSmyGM875tmyiWTImpLzyiu680Z/6Cx1n8k
	GDCvvHzycE/c6+v25quNz1YiOKfW8=
X-Google-Smtp-Source: AGHT+IHZD+TPE+f7Od2bH1FXSEHheCZR0jbD85PhGlvZouPYK7rri5NndsQUPYvw0OcgSpkxiZZxIDt+ew==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4f13:b0:418:3b99:a2c5 with SMTP id
 l19-20020a05600c4f1300b004183b99a2c5mr99081wmq.3.1713261503363; Tue, 16 Apr
 2024 02:58:23 -0700 (PDT)
Date: Tue, 16 Apr 2024 10:56:36 +0100
In-Reply-To: <20240416095638.3620345-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240416095638.3620345-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.683.g7961c838ac-goog
Message-ID: <20240416095638.3620345-46-tabba@google.com>
Subject: [PATCH v2 45/47] KVM: arm64: Move guest_owns_fp_regs() to enable use
 in KVM code
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

guest_owns_fp_regs() will be used to check fpsimd state ownership
across kvm/arm64. Therefore, move it to kvm_emulate.h to widen
its scope.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h    | 6 ++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index fd5b790af6bf..5651e971b341 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -72,6 +72,12 @@ static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 }
 #endif
 
+/* Check whether the FP regs are owned by the guest */
+static inline bool guest_owns_fp_regs(void)
+{
+	return *host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED;
+}
+
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 6e2ddce7f830..38961b6b1a18 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -39,12 +39,6 @@ struct kvm_exception_table_entry {
 extern struct kvm_exception_table_entry __start___kvm_ex_table;
 extern struct kvm_exception_table_entry __stop___kvm_ex_table;
 
-/* Check whether the FP regs are owned by the guest */
-static inline bool guest_owns_fp_regs(void)
-{
-	return *host_data_ptr(fp_owner) == FP_STATE_GUEST_OWNED;
-}
-
 /* Save the 32-bit only FPSIMD system register state */
 static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 {
-- 
2.44.0.683.g7961c838ac-goog

