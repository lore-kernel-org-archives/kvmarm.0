Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9211C262FC4
	for <kvmarm@lists.linux.dev>; Wed,  4 Jun 2025 05:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749013750; cv=none; b=VQdV9c6gG/F5EdEdYmGO9gT5ZYDicHIdaSTTwhQ8PhlaVr6X3BHP7iBr7O1xjjtmAFY1RJB/ZB003QbSkt71lHNF5MheopBSL61Hkk0iIKAy0QwvU/StbkvPrvTG2I9f4JCjTF5RkcI8Rx0MlDg/Go1eTZiB70etLw+GA7AFeRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749013750; c=relaxed/simple;
	bh=+djBXRGZZ4KS/japPqQxkteXePbiEDHtGk4KYt6B518=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HSFUwFygZZ5qp7OWZQ42FuoB2OlpRSmK0LZfRh+jCxGCfR1vwqJBLQaGMtZolKGa5wsXOPirvjZBeo3KNmIpvePa8xkdHMMwdqNB3GMD6f5qsKoM82PWv1amh2hn6TELodZyOCMPzAt/QC8mFtLMPhd7y17r0cBh9XQwORkNg54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1/CU20Gb; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jiaqiyan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1/CU20Gb"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b00e4358a34so3812149a12.0
        for <kvmarm@lists.linux.dev>; Tue, 03 Jun 2025 22:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749013748; x=1749618548; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HXtiOD32k+3IRpg7Tl5Q1Nm4vKBBcoEeXUHabwSNFEc=;
        b=1/CU20Gbns/g+LZAWySbAKRUOGljlVunWJmcwd9e9kBY8/pxB9oWexIVnLmU5Kiu85
         dGZFtX6Q2mjjMK9L77P7J617/8kOjrv0afLaNJVz/FizD660o9ex2FlA9Doil6IAaEO3
         4YZ8pNsfSrNzV5wlk/V8x/qT3Zly26sz4enLGpCqSr7VaxOinCl5aQhB5g2tHdGguhyE
         48PDWMfSp5+RhBnFyF4CUfYTW7H4F1oQjCkfUANWeBJZKyV0QEyLOvQZ2ClKOHxR3zjW
         IHyUmJty8L1N/aMaQcyGLBxpge3ZEDOgdxL7Gn2yGk4Ln6W8QKIW+YkzX4DdyEvqirkh
         Jdow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749013748; x=1749618548;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HXtiOD32k+3IRpg7Tl5Q1Nm4vKBBcoEeXUHabwSNFEc=;
        b=H/GDOqJ0zBvwxgA2occYf9xAcvuei6RW5yW+AqNNm3Ek54KsXuUdR3K2TKEzqtWPwt
         JGiJ3zVHqlKhygQPgwCkQjAE1e3iPwjp2QPuMZmjxWvSTF/n4Vy0WfNDd9FS7dthlxUo
         QYteD9W1PDxcp4jr9fvg8B2VP6PCFb7wjclppU3H12ZH4CW8Ne1mFhVrh+bqDtFYI8t8
         jXyR9zclCgOwMy6frAj95ZLypcJoyeW7e4JPxl20JcJFiXoDFdcQi5toZU3KRlw2oAQ+
         z+KO0NxGUuz+Ym4+HTmxgjjWakxixuw2SGQW10kDt5roJfOpJX+FfsrHYdarDuVw7FSk
         sIlg==
X-Forwarded-Encrypted: i=1; AJvYcCXaBo9r2wbrHHLeV5KGGtOsy6UOGDVyi9XKEIwJVk4sIRb6hCP2UWiyCkL3ueqGwpbsGaygK7I=@lists.linux.dev
X-Gm-Message-State: AOJu0YziteC2lBd2JVH2Rqh2pGB+MoUPrcCET9mvZz1Yylyj5tYL88wd
	qYb2k2qcceELE/GzCrrp8upKFNWWIPQW4JtuYoE896vuPGBAQgrvBRBCK6h0COME/yKVxz+X0Vl
	Dt+XOWsTrc/XHlw==
X-Google-Smtp-Source: AGHT+IE0yG+wVldA+Ut+AEkkDvhjuf8f2LJxfg7qHFUSl5PI3nGJnDA82B1khwNucVOGJtMX8A10UmFpgQtpEg==
X-Received: from pjh4.prod.google.com ([2002:a17:90b:3f84:b0:311:9b25:8e87])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:28c7:b0:312:e731:5a6b with SMTP id 98e67ed59e1d1-3130cdfb38dmr1864793a91.32.1749013747721;
 Tue, 03 Jun 2025 22:09:07 -0700 (PDT)
Date: Wed,  4 Jun 2025 05:08:57 +0000
In-Reply-To: <20250604050902.3944054-1-jiaqiyan@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250604050902.3944054-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.50.0.rc0.604.gd4ff7b7c86-goog
Message-ID: <20250604050902.3944054-3-jiaqiyan@google.com>
Subject: [PATCH v2 2/6] KVM: arm64: Set FnV for VCPU when FAR_EL2 is invalid
From: Jiaqi Yan <jiaqiyan@google.com>
To: maz@kernel.org, oliver.upton@linux.dev
Cc: joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	shuah@kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	duenwen@google.com, rananta@google.com, jthoughton@google.com, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"

Certain microarchitectures (e.g. Neoverse V2) do not keep track of
the faulting address for a memory load that consumes poisoned data
and results in a synchronous external abort (SEA). IOW, both
FAR_EL2 register and kvm_vcpu_get_hfar holds a garbage value.

In case VMM later totally relies on KVM to synchronously inject a
SEA into the guest, KVM should set FnV bit in VCPU's
- ESR_EL1 to let guest kernel know FAR_EL1 is invalid
- ESR_EL2 to let nested virtualization know FAR_EL2 is invalid

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 arch/arm64/kvm/inject_fault.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index a640e839848e6..b4f9a09952ead 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -81,6 +81,9 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	if (!is_iabt)
 		esr |= ESR_ELx_EC_DABT_LOW << ESR_ELx_EC_SHIFT;
 
+	if (!kvm_vcpu_sea_far_valid(vcpu))
+		esr |= ESR_ELx_FnV;
+
 	esr |= ESR_ELx_FSC_EXTABT;
 
 	if (match_target_el(vcpu, unpack_vcpu_flag(EXCEPT_AA64_EL1_SYNC))) {
-- 
2.49.0.1266.g31b7d2e469-goog

