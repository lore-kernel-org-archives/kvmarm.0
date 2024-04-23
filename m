Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80DED13C3CC
	for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 15:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713884792; cv=none; b=ipfP8p+7+UtnDD77lTjzEw3u0IN5EVP4XY+3Rv7keLJBDT9a26/pT6x3tBvXGJ6xnXwY0tfYvN5ZLnP+jVZ8UiLclrJRF07BahZBqmWUg8K4o1qsv6iD5EAzQHa4GIegUZJoJIAUTBXHINtbQExXNNO2cfKA7Exi87ltDnRifao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713884792; c=relaxed/simple;
	bh=I9X8LkFEXsfu7/RlXGp7Z2qnQ/D/Isl0cM8qObYFL+s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=drH/GVE1tOJPyrvFKQjOHoCndK6bNw9d2qj/eaPkX16ZE9CjlTfKwrCKeQru38cxgGbxBrBh1fISG11hjCrbWW+F20vBObi32juntNDiP18LJy8Dx2flKIeePEGNJ/DbuapPFdXRmpT/RZUp3/YVb9QXGuE3XEvc1zUQiXrBrNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rg0F6ElM; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rg0F6ElM"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3473168c856so3839571f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 23 Apr 2024 08:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713884789; x=1714489589; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O6N8Gf6EtbWKXPOI4kB8DDQdfbURqSVQNLN2xFlncj4=;
        b=Rg0F6ElMYYgggh3DDgR6NwhJIsQo9WylRZwVzf+qmzyI0oAxLc0b1Z0zzlNXHkfQO9
         iBxCuhedstLdieNc5BPxRo7JwP8hTZ7pTTQHMNcXAjHH2VSVkbVYaSR4/SVYDuq1KYkx
         V2MLI+43l62wyG/wPFnAZ046P/+VAaDp+5c77Rh75Hi2Yk+DRxRHcy2zh3ca4HXaOCED
         NyLqZBCe1Xa4F+vNCxCYKiIW7S/cr0+R4CjAJ9xIl5X3Ut+IyDIXKHT43J5+89qtOglr
         GMldMwiPUS4qdpyNLJgK/rOOi3WGK6rxmoSb8X6Xnd2mOBRLH7CIQctU52db+c62hHUR
         GNcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713884789; x=1714489589;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O6N8Gf6EtbWKXPOI4kB8DDQdfbURqSVQNLN2xFlncj4=;
        b=PS93yKWSjFEaIUAlVl9fdMxWKwhJHYl5TCsLwIUZz7LvF8C9qpTvePWcs9F45MSWwV
         f/heqR7LpXBgjw/Iac76iPQyOKH+Qer84wMAUCkdwFp7WzS70pl8G6mt4pMaJJNiiCIn
         ON88bVRDcPwOaZgNqFv7xqlYMjyfXv6Qk4S3djcgjYf2W+yfGIUJ6TnbOld4b3gXngz7
         yO0vdVeinh2r2enP4QipPEwK4PPemKzqjs0DCbocDYuZ34+Vav3qv0wb9PNGvsqkGE8L
         j4eTkNIfN9vIKHmGb3Du6XQmXv7jTXLMo+3BkKh+H5YStzOVk4ie66e+D93SkzfDnonw
         Q9JQ==
X-Gm-Message-State: AOJu0Yxm14WEu8RgBa6/cFSwFaz8K1o6QGIh9prHLfZjz3PY6Jt2Nm5p
	7roAxKghpxNhZNNMuOHpkbrFIK4cCwmtq9PwCFI2zXXoFKBwF6mN1zypZ3+q4ccGsucSOi5Pr9a
	VhLcrEM2ekjDSknaJUQAizaTxYpd6X54VaTl3ghYO7zJt9dz7wcT8VpvNX3lRdVvi5yjTQ84L1j
	TIdzQjEEh0jGlpR8ZJMQH6ID6kImI=
X-Google-Smtp-Source: AGHT+IFMFM3YtpPAhFMzBb0+G+slmfQXd2dT3pdmVvbsPXaf8EeAUJRFtPNQIT+ivmn7ulT0yW1s0wxaSA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:ecc2:0:b0:34a:cf8f:67ef with SMTP id
 s2-20020adfecc2000000b0034acf8f67efmr18785wro.5.1713884788770; Tue, 23 Apr
 2024 08:06:28 -0700 (PDT)
Date: Tue, 23 Apr 2024 16:05:29 +0100
In-Reply-To: <20240423150538.2103045-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240423150538.2103045-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240423150538.2103045-22-tabba@google.com>
Subject: [PATCH v4 21/30] KVM: arm64: Refactor calculating SVE state size to
 use helpers
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

The main factor for determining the SVE state size is the vector
length, and future patches will need to calculate it without
necessarily having a vcpu as a reference.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 23a117cb3e50..b41ab8229524 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -852,22 +852,24 @@ struct kvm_vcpu_arch {
 #define vcpu_sve_pffr(vcpu) (kern_hyp_va((vcpu)->arch.sve_state) +	\
 			     sve_ffr_offset((vcpu)->arch.sve_max_vl))
 
-#define vcpu_sve_max_vq(vcpu)	sve_vq_from_vl((vcpu)->arch.sve_max_vl)
-
-#define vcpu_sve_state_size(vcpu) ({					\
+#define sve_state_size(sve_max_vl) ({					\
 	size_t __size_ret;						\
-	unsigned int __vcpu_vq;						\
+	unsigned int __vq;						\
 									\
-	if (WARN_ON(!sve_vl_valid((vcpu)->arch.sve_max_vl))) {		\
+	if (WARN_ON(!sve_vl_valid(sve_max_vl))) {			\
 		__size_ret = 0;						\
 	} else {							\
-		__vcpu_vq = vcpu_sve_max_vq(vcpu);			\
-		__size_ret = SVE_SIG_REGS_SIZE(__vcpu_vq);		\
+		__vq = sve_vq_from_vl(sve_max_vl);			\
+		__size_ret = SVE_SIG_REGS_SIZE(__vq);			\
 	}								\
 									\
 	__size_ret;							\
 })
 
+#define vcpu_sve_max_vq(vcpu) sve_vq_from_vl((vcpu)->arch.sve_max_vl)
+
+#define vcpu_sve_state_size(vcpu) sve_state_size((vcpu)->arch.sve_max_vl)
+
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
 				 KVM_GUESTDBG_USE_HW | \
-- 
2.44.0.769.g3c40516874-goog

