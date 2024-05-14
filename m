Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AD811720
	for <kvmarm@lists.linux.dev>; Tue, 14 May 2024 07:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715671398; cv=none; b=M+5ovRDHyPTr8f2+hpgaYWnuaVPnvoYvmWVQrwIJD3S8M3ChdnoxQPtqVg7VqhXKiNVkM1E+Mo35LMX2nglH2V1er4Ad2qD6qVydYLiYatNrZuNY5PY9ep4axpZRqGna8nkWWPZ4ZInA8C3ukFbP8V/rP51giClJ5ePmjjbatBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715671398; c=relaxed/simple;
	bh=GKU8aDad++UHg7ULCq5a+WASZrV1XSR5fQTRpdyDPAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gjkg8DRDm2u4EY3WM0Zc3XmnFpFbUtdU59Nc03OD3IDfZXs82Uur3owimyyiYJxI0F1rzHfQoLar4HDNFmVRWmUFLrnbMX5WqOwlWhYtrCFEXgeRYwYqBYakyzUMsIB/1OX2C//gwTH6iKEi8RsOZH3ylpJMcBoOMjJCgBn2+J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WzlmXoTt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WzlmXoTt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715671395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ir9ch9TLrkkINczF+u09rhfqVntFlPUGfW92ABaqtP4=;
	b=WzlmXoTtjunyoYYEKWH7ToerFsEnVNcLZa9e9dvPesDCcQlQZWTncwVYvh6FAPG2jazIZT
	zA2iELhc0xYck0DYlKy9ljMzgpLCQc0hnrBZEWtSPphc+3p0NA4JxkmK4rxtd5OAG9rM04
	KWQJgpbPgt6N0hDPKDabh+zAxqzomtM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-jdLk0SCKMiKeGXSV-PBL7g-1; Tue, 14 May 2024 03:23:08 -0400
X-MC-Unique: jdLk0SCKMiKeGXSV-PBL7g-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-792ca95e323so602693385a.1
        for <kvmarm@lists.linux.dev>; Tue, 14 May 2024 00:23:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715671388; x=1716276188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ir9ch9TLrkkINczF+u09rhfqVntFlPUGfW92ABaqtP4=;
        b=DbHNyOXYHA+OuvXS8fo5WLTucrJOkU0jxKZs18jYWaXGa7TTf5MXvyH2Zqbyc5JIYV
         gLhDLApdzvlXroQK2IyQN2k2qat0uj+m2yS3NdhXKoMtlHvfB1ieUq+N1hkpS2bPzot5
         jN4rtDIwjWvwtATNUi3do9M9T7sj+knnGzV/5zzhyyiCUS2jNntaPk2KBja2CdIPjVCa
         ANJa7HiBTJaWZssqzvuIHEdojsFuvYn0caiyIcSiYbxZ7HpIvnp5PaZP2USzrikKp+nq
         Y46cUjyl8UenA4eAZHeRjgZTYoruZyvHAiTyqkljhieinQYcnRgIN0fffWH9R/vS71V/
         1EPA==
X-Forwarded-Encrypted: i=1; AJvYcCV6+P+LtlLQguLwwyGDTkQQGYSZDAVb4VycmqxMbLQYx/oGCxNbpuoLIH7sbKlOs5mhy2arbH9B6Ifvim55U1wZl8g9/irU
X-Gm-Message-State: AOJu0YwUi602EHRSmVQdk5sR3IKFU2aNX9LA57ZNJA9I43utLiLoSm3o
	TR5YE4GVQ2meeS9POR9wOSgpUXT/94OePAQ8kzA2fHb2rgtP95KBF86dyvUkK2hgiW4PK0tLAFK
	gIbdelxGN5w1HsGDoVyQYCnXQMws/TCYQ/wgPsrLbCFdX3+OhW0gPeQ==
X-Received: by 2002:a05:6214:4309:b0:6a0:d21b:c914 with SMTP id 6a1803df08f44-6a168217e82mr153404616d6.51.1715671388059;
        Tue, 14 May 2024 00:23:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIbQ2Xnzp0GccgqjWLFujOwJhCg38lH8DFppsuBR5FMZevyxek/6u2nIsapmQtCwGG2EXSrA==
X-Received: by 2002:a05:6214:4309:b0:6a0:d21b:c914 with SMTP id 6a1803df08f44-6a168217e82mr153404396d6.51.1715671387689;
        Tue, 14 May 2024 00:23:07 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6a15f1ccd4esm50917516d6.97.2024.05.14.00.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 00:23:07 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 5/6] KVM: arm64: rename functions for invariant sys regs
Date: Tue, 14 May 2024 09:22:51 +0200
Message-ID: <20240514072252.5657-6-sebott@redhat.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514072252.5657-1-sebott@redhat.com>
References: <20240514072252.5657-1-sebott@redhat.com>
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
---
 arch/arm64/kvm/sys_regs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1b6ab483e21e..bae72a4ce72b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3795,8 +3795,8 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
  */
 
 #define FUNCTION_INVARIANT(reg)						\
-	static u64 get_##reg(struct kvm_vcpu *v,			\
-			      const struct sys_reg_desc *r)		\
+	static u64 reset_##reg(struct kvm_vcpu *v,			\
+			       const struct sys_reg_desc *r)		\
 	{								\
 		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
 		return ((struct sys_reg_desc *)r)->val;			\
@@ -3808,9 +3808,9 @@ FUNCTION_INVARIANT(aidr_el1)
 
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

