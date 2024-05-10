Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81334176FBE
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 11:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340458; cv=none; b=OXw/kw5NY5FoPCLAl8Eb6Lq+DvEsfF3yUI0qcYJB5EwKEZGGUX9n+UWLFZFoBlkUHKvnCJ/kLKTEybSJmccvNioKylGaxAyHFgAmYDoRhCxX/Pxs+zLijmEz6s7VoKHDjTyWEPm3ZWTMsGjaFRgduRoUh/vl9kStVichIKQE3uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340458; c=relaxed/simple;
	bh=UDXy6AJXVdSAeErVZLumP8NwdL16orqGjCY+2++AVXE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YjN5b8GFUy1XR7FHTs498OT5ClUToiv9FeRQ+y3hyGYfX+IvVTrt6ZG3mnO/F2xhmVP6H135Ui44JHof1iNVI+AIMRdxzZPey7dK7l/HVR1V/IwwkBhswPe0tj1Hj7bdmKUQQEogvl3y39LlGEksOG0ZsXRnibmXFrSWX9J7JKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pxtVxUq0; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pxtVxUq0"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-a59c2583f0bso111784666b.1
        for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 04:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340455; x=1715945255; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8DKhkb6dSizyRVlRq/XnhdKj6+BlqFPiK9mn9/+w2yc=;
        b=pxtVxUq01UNPZotpRjrfVkqCCUCAJFtRkqMNsvIR24zb9/SYrWDg+YdwN8GBalvsh4
         wqIIlhWVIfYXQw/doRu7AcoQaYUHGYUg0kWGtzqTS5/Bpx3ZmmZrnMrX8w4QllKi1imP
         KOcE2a4y65D/Ed92OT1waZHwOM3Hv4SUio3XdehfVAbRvhfB45929IsnfuBvs84SlIkg
         tBjpj1lX5Osmr5Qx6zsYcWfb6Zo6MQpA+CkRDoXRqsS9C3GMXYF4wciqxWF5cz7viskL
         J9bL0Linu7EToMcDxICltE1pQTBQ3srALGhb5YvObWgTfdsgP/CTWKZ7n08ZAsB9TxbN
         5oeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340455; x=1715945255;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8DKhkb6dSizyRVlRq/XnhdKj6+BlqFPiK9mn9/+w2yc=;
        b=J++sJMiS/kwGRs0gooWmOH4U5QhwqgLu8Ckd+sRQGJ9nv8TLBOTcUP/VV41mhOPzNI
         7z9CGwzw81V8eIuROAaywwRasjcItS+f9m3IasDaEoAfagzS+GUuY1rxx495Cg7cHDDT
         iyDX4Vg7BeSP6shimR5DhDYT1+QNbU78eOf9s5tifG1WM1ER8neV/Hi5LshEwtm4fCpx
         ME+Cp8/VQ1pndNg8PJSnBeOqb9xnZfPiUhHoQE+p+7l4+rJ1B/iPMG5uflSpE3qOQ2Pu
         zzSnUmo/uGR4rMth9ELQBDyh5QTHCvIU55ApehHb7crPfjRZM8lDPB4lG+7tRQP5zRBa
         P3Zw==
X-Gm-Message-State: AOJu0YwhTGcynV7LH87IQMdU7eIIl9o3OfNLAOWXdeM4mtYz7RUuwSka
	MvJSS91cgaR/tyQkg8+QsESCGk6jdOAZi0oTzIV6b0b44XNNQ9svnp4pkDDJr+zKuvLs9GtESk8
	wV92w3fXrszlecDjl16siKdDEUILqmqeN/g+0ntJIb1HROiozYqrh44XI/ofHbea6YKLkG5eJGa
	oSYmwhCtSRff5tOdRrqijXXat/mtA=
X-Google-Smtp-Source: AGHT+IGkpwxqeSN6EavlDA+BXVJp1GAbnEIVQnql+hC6cCYj3jthHFCaBNvnkUk/0Xp8MBeg6nGyR3xjIA==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a17:907:d383:b0:a59:dcdc:a490 with SMTP id
 a640c23a62f3a-a5a2d65d604mr184166b.12.1715340454681; Fri, 10 May 2024
 04:27:34 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:36 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-8-ptosi@google.com>
Subject: [PATCH v3 07/12] KVM: arm64: VHE: Mark __hyp_call_panic __noreturn
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Given that the sole purpose of __hyp_call_panic() is to call panic(), a
__noreturn function, give it the __noreturn attribute, removing the need
for its caller to use unreachable().

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switc=
h.c
index 1581df6aec87..9db04a286398 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -301,7 +301,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
=20
-static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
+static void __noreturn __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
@@ -326,7 +326,6 @@ void __noreturn hyp_panic(void)
 	u64 par =3D read_sysreg_par();
=20
 	__hyp_call_panic(spsr, elr, par);
-	unreachable();
 }
=20
 asmlinkage void kvm_unexpected_el2_exception(void)
--=20
2.45.0.118.g7fe29c98d7-goog

