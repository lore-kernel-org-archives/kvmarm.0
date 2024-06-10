Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28552224CC
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 06:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718001195; cv=none; b=eaZIA6nqXkKo/AU2ysOkgecr3RQQ9Rng2yAj6/lt8j3jYbvy7owq6bgtH5cEG5aVLRWgZS9e4H4DCoh2IbXSMRBqafI8yqeUDUN2geLWh6VcaZgvm3FM+3QmbIZmHLP3SHk8umvolI+i1ju1yccVbvHjYI6gcfq/ClEh+gAespM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718001195; c=relaxed/simple;
	bh=EI4/EM811Evgaxt17ukV0tKGIs7v8E3XxqrfQ4eYqoY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tx8cQSG1iA5pGpOCnph4Lrj/zri9Aw/CoSrh7DeG0XGEEZ0zoQTzbIKWGUiaYJ8zTDxR9+m5r6RUV9dQkx2l6kGbuBAtVvZx4KnEzzFBBK6Oi+2Sr+O0silgIE7KVlWf87JBtv2DL7V7J1he64MdtFu0uOLhQ9Fcq+xsYfCfE7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k461y3ce; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k461y3ce"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62a080977a5so75955037b3.0
        for <kvmarm@lists.linux.dev>; Sun, 09 Jun 2024 23:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718001193; x=1718605993; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=erSEe/z/lyxgtHPTmqJJzIqKibPHcDLT3stY+lpOvXc=;
        b=k461y3ceqolkFGUzE0DeaVm3AcU7A8edLzntVm48gp8dedhPuj3ppB3P/tGGlFz9AZ
         0BDitw2lHdJ/jicI6DGGHrVeFXqZ9v4cKbY83ylz1eopcsHjCdkJyGWxO5SMfSiBwPAR
         uSlyt3VVhIzcqMU3wwV0CdQfrpxeIvuG0QU6OjyMvKc7lJ2GO0UQKYWy3jdp0ZMeefPF
         XI4WNZKOQAyWVzFYtG90x0cyVdzDAYUli/0mmzr7gm3gl2rjeUTJHLzihjHqxHU0Kvlg
         28Tk+NxjJz9NghMFxn205PSn8ZbyUEwO6rF3scx/K7PtTx7eXJSaITU5zqMutdLa3LxC
         csfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718001193; x=1718605993;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=erSEe/z/lyxgtHPTmqJJzIqKibPHcDLT3stY+lpOvXc=;
        b=aibcsLlDnjWRcGZzDgU78MY1O959DJALYq0JDTKtPn73slqf1dQqDefzSGIx+BD+pj
         IJp3ejYig1r4ZWdSFvhBNVvp+/SbegI/hDg9iaGG119jfNl719a1VL9f/GQr8U7Pw1Zz
         rDOtfil5W/78yWXLG9ZLbiwH+UTiSbtGd5dgCSg0qwhjykJyuZBteeCEQYSMldp0jmtO
         AnqWuX7aHFnVR5eruzuTecgGX6F6eXxFMQrCiNP3O55ebXRJK1ylZ2QvK18nnRPPdykB
         esUdXB1ekIKbk/j+8p6eVDHpASU0zXVtR022RTyAENG4DuHkhx4ZjEUfXCQaTqXUAtwS
         K53w==
X-Gm-Message-State: AOJu0Yx9BxSMNpcEhKDa7C72RzjiA8ZPtp9/CPBaGqJPWNCgVseHBU1W
	j7htHW06wPSv5CK0FoIQEsIYZ6BLBOIOE5bvxWl0q9PYEp44Jvcrz1lGjB1B4poX6F0zJuyoyRT
	w93rHv27W/Nf6IvJhRLjLbrupOndQ34yaHhQvNmM8umDou/y8vh8sz5P+e16tcMETMqnS7ewboG
	GY1pWp3Z3usC4nKrpQiLKj14+i2eQ=
X-Google-Smtp-Source: AGHT+IHneFcZIljJu58TGDzZRXW2Dq5HHh3VsxwTxsRfeFhyr4nvcrpdZeErzPsMk+6Ni5nqm5R0Pmo18g==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:690c:640d:b0:62c:f7e2:fc4e with SMTP id
 00721157ae682-62cf7e3002dmr13313527b3.2.1718001193144; Sun, 09 Jun 2024
 23:33:13 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:32:34 +0100
In-Reply-To: <20240610063244.2828978-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240610063244.2828978-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240610063244.2828978-6-ptosi@google.com>
Subject: [PATCH v5 5/8] KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Given that the sole purpose of __hyp_call_panic() is to call panic(), a
__noreturn function, give it the __noreturn attribute, removing the need
for its caller to use unreachable().

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switc=
h.c
index d7af5f46f22a..0550b9f6317f 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -384,7 +384,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
=20
-static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -409,7 +409,6 @@ void __noreturn hyp_panic(void)
 	u64 par =3D read_sysreg_par();
=20
 	__hyp_call_panic(spsr, elr, par);
-	unreachable();
 }
=20
 asmlinkage void kvm_unexpected_el2_exception(void)
--=20
2.45.2.505.gda0bf45e8d-goog

