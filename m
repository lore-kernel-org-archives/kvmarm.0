Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD781146A7A
	for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 10:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714128611; cv=none; b=KBk5waKuI2iU8+0RigugzJUl4PyqZgN9RG2+VYa9WhKdD/PlF/ptQFZDPqaI2Dgb6BTjlOrfMPazoUqhGoolnUFtXjg1P9Kl+cGNCyK0DDlvl7MGdfU2iC1zqDjMAZCEwMRKopahIbCD76F2EMcA9WBPyy9AWoH4O0HX3QWIisA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714128611; c=relaxed/simple;
	bh=Tf9y+3NWAEc98GgU9RtLG+14qsoC+MYFycxluP99giU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EK+hNzuqD/mQCTxVFBp1GygP1eTivBXxP0uX9qD3IDaWnsrN1Fer1Nif8WbeGwUvJrW3X5Vk/NDWSMRjcwt+07pbNqjS8wqulqfA+0YAijdJL9gisR/Y12QhADjp/BFnRf5hX0p/gZBuOd//cCJcXEzzvJ+4iwxpn+nqtI/2KBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L2YBm6Ro; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L2YBm6Ro"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714128608;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wNqZh+z2EiZYSEoBRZTk0oPEfA8kIktvdRXuHyV2qbw=;
	b=L2YBm6RolfcvR3gZE92sLvYKtIRvFYnzfdT3n07NYyaaWtslZYR8mAtqe/D4gnkwncyusJ
	jc4s2S0PBQmuc/pob97U5F9TDYC/dVBiBquBPj4oahQ6QsJGsGKWs0j23ejRLT9E0tIPSk
	dpPUkpMPqBf3ewf4VbfexFr5gPRRZ6Q=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-H2NcZedcOWewdRNccEdOmQ-1; Fri, 26 Apr 2024 06:50:07 -0400
X-MC-Unique: H2NcZedcOWewdRNccEdOmQ-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3c82cfb89b3so1679887b6e.2
        for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 03:50:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714128607; x=1714733407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wNqZh+z2EiZYSEoBRZTk0oPEfA8kIktvdRXuHyV2qbw=;
        b=DsVVcFLsBdPzPlu6DBQnTvv9914NYb1w86WuBchRmmQYYmf+Aps3s7WbMN6+pUpkhe
         B2j3Q2te1N3iQv8u/694FMyEQSSz1LmPvWDRd5gXTxiw4Y9+0/Oy9z/ai6060MzPKsMn
         IMsMFpfgrB4OXXjPeUpb+XVlHez7mQCZkN2/YVTf7ZyBQ3Pmtc1ObeyusN8PoTfheLkU
         PP2CYD010t/nPl7WWEOQclijIeUpKWtNLMdKVVYMnQSR7QonkSRK5MBHhrWBrt60qdQO
         gKdUBzljWozSm+MZmBYAVvYApyBLtMVO6T2Tu0EEGHayANPohfj3/MdHIc36Z0HPwTGr
         93ag==
X-Forwarded-Encrypted: i=1; AJvYcCUTIcvTKDpG4zZHgFxovQJhyzko5sC0aWcCsyNNfp3Jo/qdkTkhnwu2wea+cTUlE69jnFK448MAHSi3LJkmDm5T24+WMjlo
X-Gm-Message-State: AOJu0Yypw5aydWj08UMGXPKTNvGuX5rsgiZ0vAKL/wa+Kv3AsSQwywPe
	r7nXpM+FJFwAg5go/YpIeLxgSmgwm6wvSVAa9VzTFsvE4NZsots+1a0Jz4kuQfUjknQj1NHpgir
	KEE4MUE/PgWu1tQooyxWsamnzJdyig8i9t5vp1Syl2wlZlJd7pe7D5A==
X-Received: by 2002:a05:6808:30a4:b0:3c7:4d4e:efa with SMTP id bl36-20020a05680830a400b003c74d4e0efamr3051363oib.0.1714128606911;
        Fri, 26 Apr 2024 03:50:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKgU12rJ0S8FySH9QjK+dyy5z+zqe2fLh87SXhBDOo4CIWHlr7Ul+j8/28IMaiu8xhUzD1bg==
X-Received: by 2002:a05:6808:30a4:b0:3c7:4d4e:efa with SMTP id bl36-20020a05680830a400b003c74d4e0efamr3051354oib.0.1714128606675;
        Fri, 26 Apr 2024 03:50:06 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id vv26-20020a05620a563a00b007907b57aa1fsm3888019qkn.12.2024.04.26.03.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 03:50:06 -0700 (PDT)
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
Subject: [PATCH v2 6/6] KVM: arm64: rename functions for invariant sys regs
Date: Fri, 26 Apr 2024 12:49:50 +0200
Message-ID: <20240426104950.7382-7-sebott@redhat.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240426104950.7382-1-sebott@redhat.com>
References: <20240426104950.7382-1-sebott@redhat.com>
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
index 7d5d55e5c16a..88f6cdf9b8d6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3753,8 +3753,8 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
  */
 
 #define FUNCTION_INVARIANT(reg)						\
-	static u64 get_##reg(struct kvm_vcpu *v,			\
-			      const struct sys_reg_desc *r)		\
+	static u64 reset_##reg(struct kvm_vcpu *v,			\
+			       const struct sys_reg_desc *r)		\
 	{								\
 		((struct sys_reg_desc *)r)->val = read_sysreg(reg);	\
 		return ((struct sys_reg_desc *)r)->val;			\
@@ -3766,9 +3766,9 @@ FUNCTION_INVARIANT(aidr_el1)
 
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

