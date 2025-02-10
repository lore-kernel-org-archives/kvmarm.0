Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6CD23CEE5
	for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 15:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739202603; cv=none; b=Qm2Q3lvRaycVoEivPLRU2GQIf3X3m2jz3liQIqncKfhOMxiSj88HrdUtgpTshMvXEHZ0U1DZsNJ0rzP8nqJZh+7CHtE6MzF8T2X0DMbWaO9neY7oqTtRzqW93CuvYntYkLdtOBA1Ryde5tqfIuiJMertgwxLr2aVFsKuenOJ5eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739202603; c=relaxed/simple;
	bh=0my6NoAsd7P7y9OJgYipp1QVHC1ZbpCJcXEsrlAHxlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=mJw3iWIq+Dk7Q6QmAz86Yo2IjMan7wXSdJq3GI5vuIdU0VyhtZv5WKGO751qc4NDoGphUekssWgI/nC6jGNs6xi3/nePTRUAFZAxu+lwG/3pfDKDZrm0BuLhVeHaT0Fhu31UDinMvaftJJ6/YwGMtjqEOcx//bNgeUOd6R3UiXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O3flciJ5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O3flciJ5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739202600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k5AYcip1WpOMZ4l8MYmRKzKUrzrFcQKu9wKzGyAJc4c=;
	b=O3flciJ5Yr6KOeZ+eJNJzWaR2Xh9DZ0baQuZ4wvAzfp+vHL/4U9g6RADl+u4T8tjkrTVhD
	24mp8Rqb3nBsTuvBY10rjIlh9hQmj3+nJRIGX+2G7cY8wG5XUorlD+BcrsFlIHiedOleVg
	wbaiwYSNzXkHkm94BdBDh0vi6MXvW8k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-zXgB6k31MmeXNAYh_VGX5Q-1; Mon, 10 Feb 2025 10:49:59 -0500
X-MC-Unique: zXgB6k31MmeXNAYh_VGX5Q-1
X-Mimecast-MFC-AGG-ID: zXgB6k31MmeXNAYh_VGX5Q
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43947979ce8so4581445e9.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 07:49:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739202598; x=1739807398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k5AYcip1WpOMZ4l8MYmRKzKUrzrFcQKu9wKzGyAJc4c=;
        b=TIGN85XsS9SZ7BvEM/2wdDbaGbk+29YM19jmdni1vbqVubrSVupWzROhtUTcj3XES8
         1pcDBOlou9mpuWgV4Kuw/hRWHkjlYxcadrkPzDz/SyNi5GpnHYPON7uTjnx1Y5FZOsJ9
         x8ArDTJthGe7e9Wt7quzoHQPjzS3EQt1NipXcr5V5XpwywQWYHKQxqQ6ecNr6kT8ePOt
         k1EXDPOTHFecechPmeZTbQTstCt1ywdnRHD6g0w47WE4znSaQbgeOZtmeklVf9BV63HH
         jpYIM8cAqWgWJoqbe4Pza3K2Eksi12ybh0dCljIjdqXz3dzQljGzWRjAyvOY3q3R0d8I
         vypw==
X-Forwarded-Encrypted: i=1; AJvYcCUOEJ9jCZwdoYcxjxBYzUrzWoDoN1ExwagzfgoWrBF5QGCOuBgvHFXcH1AbEQehAV9riK3Ib1c=@lists.linux.dev
X-Gm-Message-State: AOJu0YwT0mDzxrN7QwpzNJk3t9KUIiN0Nt16SZc5+FI2Qm+QsT+AqtSS
	LIFOEtCjLU81GkjnjNw9aGUCF7Diwj5T4ugzm3NNNsdNnZjUCa8KpHtA8xAOori1uEtedOu7r8X
	jR3K2AAZlLrAk/qqKIutx3jnwQWCrmI3evy4+Mc4r0EbYwnaUe8X7cA==
X-Gm-Gg: ASbGnctbGN/LOQXc8/gmuwClSZPm2z9nb1Rlo4nKRuXyaPfDKmCrfILyF29UQ0rHIuM
	LMurPZVwLZqW2u1Ij76k4jDdvjOf5W6g+QZKSKivzeu0HqUiinYitUpami5NVrThFZpflK/de41
	ZVpphDoJpkAtjqG+TVthZ4Yq9rWUo9HOwOAVIcSzV1wD5yfbo/RwNP1AFNtpoemxXNxsB7OqAJM
	zbLtcWcEOe5j0WVdq0W/GjovnEv6+uPnTmcPNYFubs6PVTMEkMjdWAkdvrOtER60E8o/9+Ovoxc
	o5+/jaqB8tMe3aFVaSw5aiPIlYf+zoM8IhrvowCPBYiXuJSzfHrW6KL1ZVvHhLPnTLw=
X-Received: by 2002:a05:600c:cce:b0:434:f131:1e64 with SMTP id 5b1f17b1804b1-4394c815898mr2835295e9.9.1739202597839;
        Mon, 10 Feb 2025 07:49:57 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/gXGeXIZb0aJTYjdY1ZH66XscPhh3eLXFgOg1KHJQ8jUhpcmWvkE0k+kfaiy48I06jOKA8w==
X-Received: by 2002:a05:600c:cce:b0:434:f131:1e64 with SMTP id 5b1f17b1804b1-4394c815898mr2835065e9.9.1739202597479;
        Mon, 10 Feb 2025 07:49:57 -0800 (PST)
Received: from rh.fritz.box (p200300f6af0e4d00dda53016e366575f.dip0.t-ipconnect.de. [2003:f6:af0e:4d00:dda5:3016:e366:575f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4391da96502sm153559395e9.1.2025.02.10.07.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 07:49:57 -0800 (PST)
From: Sebastian Ott <sebott@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Cornelia Huck <cohuck@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] KVM: arm64: Allow userspace to change REVIDR_EL1
Date: Mon, 10 Feb 2025 16:49:51 +0100
Message-ID: <20250210154953.27002-3-sebott@redhat.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210154953.27002-1-sebott@redhat.com>
References: <20250210154953.27002-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Dxn_KyO0PHhK2Dfsw-aacBryRcU19M-jxvbKKeRtGRM_1739202598
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Enable VMMs to write REVIDR_EL1 by treating it as a VM ID register.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/sys_regs.c         | 11 +++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3db8c773339e..c8fba4111b77 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -374,6 +374,7 @@ struct kvm_arch {
 	u64 id_regs[KVM_ARM_ID_REG_NUM];
 
 	u64 midr_el1;
+	u64 revidr_el1;
 	u64 ctr_el0;
 
 	/* Masks for VNCR-backed and general EL2 sysregs */
@@ -1472,6 +1473,8 @@ static inline u64 *__vm_id_reg(struct kvm_arch *ka, u32 reg)
 		return &ka->id_regs[IDREG_IDX(reg)];
 	case SYS_MIDR_EL1:
 		return &ka->midr_el1;
+	case SYS_REVIDR_EL1:
+		return &ka->revidr_el1;
 	case SYS_CTR_EL0:
 		return &ka->ctr_el0;
 	default:
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index cc94bed7299d..0ab2b2c79881 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1666,7 +1666,8 @@ static bool is_feature_id_reg(u32 encoding)
  */
 static inline bool is_vm_ftr_id_reg(u32 id)
 {
-	if (id == SYS_CTR_EL0 || id == SYS_MIDR_EL1)
+	if (id == SYS_CTR_EL0 || id == SYS_MIDR_EL1 ||
+	    id == SYS_REVIDR_EL1)
 		return true;
 
 	return (sys_reg_Op0(id) == 3 && sys_reg_Op1(id) == 0 &&
@@ -2001,7 +2002,8 @@ static int get_id_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 
 static bool skip_feature_check(u32 reg)
 {
-	return (reg == SYS_MIDR_EL1);
+	return (reg == SYS_MIDR_EL1) ||
+	       (reg == SYS_REVIDR_EL1);
 }
 
 /*
@@ -2521,6 +2523,7 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	}
 
 FUNCTION_RESET(midr_el1)
+FUNCTION_RESET(revidr_el1)
 
 
 /*
@@ -2574,6 +2577,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ ID_DESC(MIDR_EL1), .set_user = set_id_reg, .visibility = id_visibility,
 	  .reset = reset_midr_el1, .val = (u32)-1 },
 	{ SYS_DESC(SYS_MPIDR_EL1), NULL, reset_mpidr, MPIDR_EL1 },
+	{ ID_DESC(REVIDR_EL1), .set_user = set_id_reg, .visibility = id_visibility,
+	  .reset = reset_revidr_el1, .val = -1ULL },
 
 	/*
 	 * ID regs: all ID_SANITISED() entries here must have corresponding
@@ -4625,12 +4630,10 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
 		return ((struct sys_reg_desc *)r)->val;			\
 	}
 
-FUNCTION_INVARIANT(revidr_el1)
 FUNCTION_INVARIANT(aidr_el1)
 
 /* ->val is filled in by kvm_sys_reg_table_init() */
 static struct sys_reg_desc invariant_sys_regs[] __ro_after_init = {
-	{ SYS_DESC(SYS_REVIDR_EL1), NULL, reset_revidr_el1 },
 	{ SYS_DESC(SYS_AIDR_EL1), NULL, reset_aidr_el1 },
 };
 
-- 
2.42.0

