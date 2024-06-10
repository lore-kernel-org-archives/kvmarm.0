Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50FB25634
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 06:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001200; cv=none; b=gF+IZ6amHRXrX/tKLuWrg5w7kagde2ojRBSJVQYr8ymDKseUHPg9TkDn2B2v5E6IS2kStUWzvGoiyOGflS0qVGS2/gUmYpw1pzKfNOppKV1HWr8xCoNaaJNEQyRSEqBCIn98+flMPXHuEgaXk1ZQgfOEZjLuwIHqUcxGQZxvt9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001200; c=relaxed/simple;
	bh=AqvaU44Y4+L1JXO5CklIeg/gsPsV6LRGHS7zAcof/1w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o1TB5ybDjMUlY5TJhEi4rd6q50iVNBoR22dFKs6g4zE85nvyh+/jnIzT6rpz4c45Zedmvb/P73i0csU2WD02Ljflu+sT+aDdUtPO+AtfpDfKyOu2d/R59yVRB7XM4BVWPk/nlAoZGdQx9lD00S3mIZcR7pp1BNeIJsFUovfh+Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dyB5jThN; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dyB5jThN"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dfb17fb0fb6so2773649276.1
        for <kvmarm@lists.linux.dev>; Sun, 09 Jun 2024 23:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001198; x=1718605998; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dqyohViu5INtDvXVZa+s1VQcpgMXQ3O7S1A4651HaGs=;
        b=dyB5jThNerYyFtosbGUr/VG9pfV495BroCLkq8qxRvnTi34H1inzUsf4ZVuTh2LYSq
         u0jyipmQOtTXgeKd9z8mR6EBNoYzMIBTYRNktweQseVkyaCoCBnQiY9v3lo1/oNqPTkf
         Zk6kGjhglDAnh8GTscvhHWlF419U03cbCc4Xsy2W+6zMjSitXoOy58wAeJ/IMq4JsCpW
         Rjt2dntnzB6xhJsaiHxc0mN6/Oi031oza7QPBkYQD504t9F2WBq8hdiDV+v+DK1cJ7sj
         OWkqV2i990L8AOlFEIKdWW37jnN24/j9PN5cox/WHggyOHBdu5F2JvPOHMRbFykwm2lh
         dWgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001198; x=1718605998;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dqyohViu5INtDvXVZa+s1VQcpgMXQ3O7S1A4651HaGs=;
        b=g5vc6tMEQxx4gv8/nFATSaL9Pt/1/dFr0xVOpl5kB3iKHX72Jr4lgyiVJqCMbJddbn
         FyHj5zM/BYnQNvhhAgntqZEKdBMXn+w8bz8LcorCWkZZWhVStHP0h7c1z9q3xQ5nlw+L
         6e4C97VguTbptN1F1sse3FaKNXNMyakm5HigvG0R9n92wcUvs9Z42QgLBmErORtp3mbp
         EetOML69fokWVuVBFOTez+UNepaOga3hmSCnj9S548r3+XrX3B7n1x8Q4t4OO1MnBLI2
         tSuJHcBR0u6rwQoEbFPvE9cmIBYC1EPs37VGrX9qrKbIOJHRZcNNuNpKs4rSHz9JYX8d
         dFnA==
X-Gm-Message-State: AOJu0Yza5fP7RFdtTElfBLUlzA1L7uvArFIhPN7UaZE3sPe+PnFp7HAd
	sOXBuKYfJwEx9WQbnaclzcO27SRYca5t++Bxa/eljMf6dTe8Mv9TRdBXe0reGM/4RpwvQhPLA0Q
	8rP8dwLEGfWfF3ofmfFeInRvaxLn3JwV7j9TCqJwrNda8prYWclf6h/9l+RAXSc9pRLYI10CtWz
	HoobHqR7LZJ2Ot1SMmFDx/qnm+/+U=
X-Google-Smtp-Source: AGHT+IGf6WRV7HKSJskgV/e4LobW32lt+CvHAqHY8Xw+IryjRsITtuaQvaI/3e5A/41rY75n+5kl2ImpRQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:1024:b0:dfa:56fa:bb4e with SMTP id
 3f1490d57ef6-dfaf64ea21fmr2585123276.1.1718001197573; Sun, 09 Jun 2024
 23:33:17 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:36 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-8-ptosi@google.com>
Subject: [PATCH v5 7/8] KVM: arm64: Introduce print_nvhe_hyp_panic helper
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a helper to display a panic banner soon to also be used for kCFI
failures, to ensure that we remain consistent.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/handle_exit.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d41447193e13..b3d6657a259d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -411,6 +411,12 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exce=
ption_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
=20
+static void print_nvhe_hyp_panic(const char *name, u64 panic_addr)
+{
+	kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
+		(void *)(panic_addr + kaslr_offset()));
+}
+
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
@@ -439,11 +445,9 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr,=
 u64 spsr,
 		if (file)
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
-			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
-					(void *)(panic_addr + kaslr_offset()));
+			print_nvhe_hyp_panic("BUG", panic_addr);
 	} else {
-		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
-				(void *)(panic_addr + kaslr_offset()));
+		print_nvhe_hyp_panic("panic", panic_addr);
 	}
=20
 	/* Dump the nVHE hypervisor backtrace */
--=20
2.45.2.505.gda0bf45e8d-goog

