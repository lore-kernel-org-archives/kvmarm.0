Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184C9144D2E
	for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 10:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714128602; cv=none; b=qNWbfZtRyKNYY8TD0EJAWlnO52IB1C84Kt7eOfbImuJqhCWA9+eg65yEJoqZ0BRf2zWiUMCUbP5Kx2F4inPihw8eP9L/0K4+alTMdvM6NoaMskkh2PVyOiiooCg3U56DX/Cst6KwVtbryFzp91J6/rRe72j+BB8CbVmwPcVJRqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714128602; c=relaxed/simple;
	bh=FRiRwc90NawBYQ1NhQ/i4LDW0LXM9/iVyn9EgL+Kf4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XoErT7RhKe46RA9RnDmtixX6LIPgDVpC50Ja65CyJKn0p1/4NUVNx0FAMw9Y0Q7lhJZRTStLAjqXQD3FG9W/iWtB/G3ILtHZWlu/EosMoZTN+js4Hvny7Npn+p+gQgasCdSIq9/GnY6I4Tyvm1zTmSNjyLNTyf14WvD2RyyDdtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bqwG0AtE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bqwG0AtE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714128597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yv0f7+ZooceAuz8ErMSH+4jWIomyiUMNQo0xCMMDiy0=;
	b=bqwG0AtERfhd1VyIBA1UAm4bkXDVNCCPIS7BYCXbB7vLQrjawDwbELt1LrpgvSEFMh/Fal
	vgQDa1KvObX3EnNa7vbutzw8KSPDPh2m9T2fMfH/L/Pq7+qaqDayL2ijzjGCAdDKTBs71r
	c5wMnu7qgbbSUVi4869xp3IUMfGXryc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-zadYHprYOV6L_jrGQslOcw-1; Fri, 26 Apr 2024 06:49:56 -0400
X-MC-Unique: zadYHprYOV6L_jrGQslOcw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-78ecaccfda5so190962685a.1
        for <kvmarm@lists.linux.dev>; Fri, 26 Apr 2024 03:49:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714128596; x=1714733396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yv0f7+ZooceAuz8ErMSH+4jWIomyiUMNQo0xCMMDiy0=;
        b=Ecnl1T9lURyPVHiFpEmFWmEkByURowv89DvSFT8DWlZSzPpWrOC1LZbkGf8c4LQkwj
         3NjHoxbSQ/rI1v9O9M8TRaH5MDoc18MkUZr85MqwTD74cM9mCMhakppPIoFdcWNO6ajh
         7IkviRhW/PcQjTR4J8VDDpWBUBY8NZ9kkson5KsBkZpcte8Fx13h7P/Zlto96uFnuPAk
         Rfl8Gzxw2uA9B4fbGf6Zztnv9INpJagoQuueH5mWMWSLd3Rdey8QMTtIgiTQ+VbnPeNV
         1HEfkEdtlb7Czb4126YrmkXixBXVC48xa9flUGZ/MMEHwDiicztqMa/Vn/7jH08r10Ko
         NrqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXw7WDjxDFoEf3bE00YM8+TsfYrUOMNFlIikv58Oi/9q98gB9sj8Re7nmyqCI5l3vJWcozwnEBGJQGrHQCNc7bXwttmYL66
X-Gm-Message-State: AOJu0YxBhIz8r1eeEqhAIHuoQK5Wj3iKiPrLohlq/Y+ASE2ZD9lUFgtx
	WMHAIBpDDEuLIFkQ047NIHNiiy0R8lvfucNKQvfkQgknrbav1N2PbSbciBrhcpTuAdfiBdxWA/8
	1NDdJLxha5QIWXgNDbgI1ZSv+Kpf+X7P64hrZFS+L7b9x72SBPKyH7g==
X-Received: by 2002:a05:620a:558f:b0:790:9792:ccf9 with SMTP id vq15-20020a05620a558f00b007909792ccf9mr2474357qkn.26.1714128596234;
        Fri, 26 Apr 2024 03:49:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuK9q7K5MnARR1FYXhNoL5QlURcOPFxWs+be/9tKmV0SXMgVdbnC3Cd+KrI9ajhgrIqvqt3A==
X-Received: by 2002:a05:620a:558f:b0:790:9792:ccf9 with SMTP id vq15-20020a05620a558f00b007909792ccf9mr2474347qkn.26.1714128595916;
        Fri, 26 Apr 2024 03:49:55 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f4cc600a5cdf10de606b5e2.dip0.t-ipconnect.de. [2003:c9:3f4c:c600:a5cd:f10d:e606:b5e2])
        by smtp.gmail.com with ESMTPSA id vv26-20020a05620a563a00b007907b57aa1fsm3888019qkn.12.2024.04.26.03.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 03:49:55 -0700 (PDT)
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
Subject: [PATCH v2 1/6] KVM: arm64: change return value in arm64_check_features()
Date: Fri, 26 Apr 2024 12:49:45 +0200
Message-ID: <20240426104950.7382-2-sebott@redhat.com>
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

arm64_check_features() returns -E2BIG to indicate the register's
feature set is a superset of the maximally-allowed register value.

The only caller of that function changes this to -EINVAL since
that's what userspace expects for invalid register writes.

In preparation of adding another caller for arm64_check_features()
that would need to do the same conversion just return -EINVAL
directly.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c9f4f387155f..131f5b0ca2b9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1445,7 +1445,7 @@ static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
  * considered the safe value regardless For register fields that are not in
  * writable, only the value in limit is considered the safe value.
  *
- * Return: 0 if all the fields are safe. Otherwise, return negative errno.
+ * Return: 0 if all the fields are safe. Otherwise, return -EINVAL.
  */
 static int arm64_check_features(struct kvm_vcpu *vcpu,
 				const struct sys_reg_desc *rd,
@@ -1464,7 +1464,7 @@ static int arm64_check_features(struct kvm_vcpu *vcpu,
 	 * only safe value is 0.
 	 */
 	if (sysreg_visible_as_raz(vcpu, rd))
-		return val ? -E2BIG : 0;
+		return val ? -EINVAL : 0;
 
 	ftr_reg = get_arm64_ftr_reg(id);
 	if (!ftr_reg)
@@ -1490,12 +1490,12 @@ static int arm64_check_features(struct kvm_vcpu *vcpu,
 			safe_val = kvm_arm64_ftr_safe_value(id, ftrp, f_val, f_lim);
 
 		if (safe_val != f_val)
-			return -E2BIG;
+			return -EINVAL;
 	}
 
 	/* For fields that are not writable, values in limit are the safe values. */
 	if ((val & ~mask) != (limit & ~mask))
-		return -E2BIG;
+		return -EINVAL;
 
 	return 0;
 }
@@ -1840,16 +1840,6 @@ static int set_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		IDREG(vcpu->kvm, id) = val;
 
 	mutex_unlock(&vcpu->kvm->arch.config_lock);
-
-	/*
-	 * arm64_check_features() returns -E2BIG to indicate the register's
-	 * feature set is a superset of the maximally-allowed register value.
-	 * While it would be nice to precisely describe this to userspace, the
-	 * existing UAPI for KVM_SET_ONE_REG has it that invalid register
-	 * writes return -EINVAL.
-	 */
-	if (ret == -E2BIG)
-		ret = -EINVAL;
 	return ret;
 }
 
-- 
2.42.0

