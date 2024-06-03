Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFC1C12EBF2
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 13:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419933; cv=none; b=Riz17YUlTuPZ7MHedlAcbMESuKsCv9jyxZt6UhhfQpmdEPyCeQN1BrDykBBqIb2u1TbmXpFwNtyn7oOAhWrDScS9RYWp3Hq3ENquuhb3Vxz/oxLiXp13ZxXn+MOKWiHoJMZkc113bD7DHLYhUSeRns4pxTWsjSFxCYia5em1Mmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419933; c=relaxed/simple;
	bh=71m52FJi8Um7FJFoETG+FaMXe3M/vfBj7cNFVRSvdGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXgeoa6txfsDYxzHPULD/m7t9utw/kCmc6vtdSYfv+IMI/S+KZQqghT7ooR3ZKr1vhUB+5v4E7NNBnaEdmOuztNVM1VSOJ1dtseFVNY06gcLss7Z+8pU7W2EA/7G7lzRfhL8b0R3P4K/ykVkroOp5io2Grzp4GMml0HOLwnS7vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dUeeZ+CB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dUeeZ+CB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717419930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2hDp3mJM+KL3UzD0Xul7NRSgkymM8l/Ae4m4/fkqIqo=;
	b=dUeeZ+CBLIgfivUPcBFOm5SJxe5opsP0Scz077RGCsPtOdQT4kr2rzyktkluuFDtlCiurM
	52kxU7J61zX6i5f2OudnJT3jCX4YljEkhNkwAfvMB5B8jF+MjCYwgwjX9o/SJX32yZ/28/
	s78P5ruOq6izpg46Pt9yYG439RFD0Hk=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-veGRW9p2Ma2OjQl5IybiFQ-1; Mon, 03 Jun 2024 09:05:29 -0400
X-MC-Unique: veGRW9p2Ma2OjQl5IybiFQ-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6af22efee18so35966416d6.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 06:05:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717419929; x=1718024729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2hDp3mJM+KL3UzD0Xul7NRSgkymM8l/Ae4m4/fkqIqo=;
        b=Qx5p1+RU0WatCtdNwj1tK7g3mEPnPAl8OlKc0UAC8ixn+npy8GTzFNu/s0PfSwcGev
         kN2Kv8X/XVjkv8x+duknC19rKy30/ELq1KcFVFXkb4OXcdnTtzlgC9+wIOE2KohAYkS7
         Ap+z0lfDdaTQXZrc0kRAT4DfhhPZjQGrjM8PkS1LVncUKmPJpRxN8ZlHzv0BGDVFoCmV
         Fnouf7D64azvqY7+Waw2LnQLX4dI0xtYapLkxbJY6y2llgIyU2iYLs+Vq+7to9sNTix8
         L+UF6j86TIT5lAdmVMphDVsWvJk87/iW9qn+adM5CyLutTzujFem1Q/ct3TVYzCgP8M4
         +Hpg==
X-Forwarded-Encrypted: i=1; AJvYcCWMsS0JnVyliLghisVVaNunDYr90koPFI8X239BL6Kv6JJm/hG3R9PfEJRSOUo5XUOMxnGktHtHzAgT2YVmPD8wZ73CtIaR
X-Gm-Message-State: AOJu0Ywu/6mxC38qMguUwl7bOuL3bvZ+grNNwzo7g2RxvhWaFPgdK3zh
	Rg8n30SdSaq+L5+VuYWs2u/uAUjBzhOXyH0XLrNkYiTH1iAU9rmyfM+YI2BC2O6nJBWbEWX7T9d
	9GTnyCq8p6JrVMQovtwjQEQVGZDD0ujdiEtuleey2Mbv2bDsUBEiC4g==
X-Received: by 2002:a05:6214:53c2:b0:6ae:ba6:2136 with SMTP id 6a1803df08f44-6aecd69c655mr116485956d6.36.1717419928905;
        Mon, 03 Jun 2024 06:05:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIqrN3yZy5lXpQG4/otUItFzer4jmPLCycJ2Rj//HPLUZeLLc+f0g23vFqngAb9IsidJe/Vg==
X-Received: by 2002:a05:6214:53c2:b0:6ae:ba6:2136 with SMTP id 6a1803df08f44-6aecd69c655mr116485636d6.36.1717419928535;
        Mon, 03 Jun 2024 06:05:28 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ae4b4179f4sm30558826d6.113.2024.06.03.06.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 06:05:28 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 5/6] KVM: arm64: rename functions for invariant sys regs
Date: Mon,  3 Jun 2024 15:05:06 +0200
Message-ID: <20240603130507.17597-6-sebott@redhat.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240603130507.17597-1-sebott@redhat.com>
References: <20240603130507.17597-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Invariant system id registers are populated with host values
at initialization time using their .reset function cb.

These are currently called get_* which is usually used by
the functions implementing the .get_user callback.

Change their function names to reset_* to reflect what they
are used for.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8008120d021b..12ce8461323a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3799,8 +3799,8 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
  */
 
 #define FUNCTION_INVARIANT(reg)						\
-	static u64 get_##reg(struct kvm_vcpu *v,			\
-			      const struct sys_reg_desc *r)		\
+	static u64 reset_##reg(struct kvm_vcpu *v,			\
+			       const struct sys_reg_desc *r)		\
 	{								\
 		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
 		return ((struct sys_reg_desc *)r)->val;			\
@@ -3812,9 +3812,9 @@ FUNCTION_INVARIANT(aidr_el1)
 
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
-	{ SYS_DESC(SYS_MIDR_EL1), NULL, get_midr_el1 },
-	{ SYS_DESC(SYS_REVIDR_EL1), NULL, get_revidr_el1 },
-	{ SYS_DESC(SYS_AIDR_EL1), NULL, get_aidr_el1 },
+	{ SYS_DESC(SYS_MIDR_EL1), NULL, reset_midr_el1 },
+	{ SYS_DESC(SYS_REVIDR_EL1), NULL, reset_revidr_el1 },
+	{ SYS_DESC(SYS_AIDR_EL1), NULL, reset_aidr_el1 },
 };
 
 static int get_invariant_sys_reg(u64 id, u64 __user *uaddr)
-- 
2.42.0

