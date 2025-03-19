Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DA8254AEC
	for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 11:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742384352; cv=none; b=ti8GXdTk7oQH0GIwY5PEC3mtaFLTogJ/FO2qwJvlxVjpTbR+Cf9HyZ8FnCyR1xwgl8Wmx7OUI4Ecc91cZM5NNdX4bFBz5MGHjqqMXay9LvQpJLUIt0QUCN9HQzU0BxRuK6lKzFhT5deFohTeRr9IX1bbIJamT8ixpySy8vOJWSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742384352; c=relaxed/simple;
	bh=wSsvSlNkNr2nAKIQx6vbdaSycDEUcJGLMq0k1Pp9xg8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C2Vch2Ns/nmZpmr5SZ4F/WIuMl7OulNODQPoTXgFpljKE09MrV9ivXtZ5sbX2wii0hLWLWaldcgBbRK7jFi8pdkiMhrrSuGu1qBUJgyAQ0a8WcwBV5flbgUi+onYNzg79zpQ3kTffbD9Oz7Obr5d/VHXQLwGMvcyXxQMQqFLfW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=jxVFEQow; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="jxVFEQow"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-224100e9a5cso129204595ad.2
        for <kvmarm@lists.linux.dev>; Wed, 19 Mar 2025 04:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742384349; x=1742989149; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BJsAUn2tJ/N0GZBEAi0IEG/qBVORqD8jC/NmJGn5En4=;
        b=jxVFEQowPqCoM196yM9tut0eFSvGRBf52eosE2LiFr3IhLAyOswgi9vbRuqlrqTJfR
         J2Vpp12rM9XdCKST7OHu+jIAM7njs8g+Y2uFQVosiay7YhPZYCzENLvCd5El80jyXQVH
         s9gqdH27NuhZ1EvntX8ztkv90GxzfNtvEGMHPAFOt4oKVhewkJBWG0s/k+cetPnKt0R+
         fi+wHyjMm7Hu1y+AC1aO1t1HOsB4YI6tZbFx1xtA7Rs7sg9kK/6LdTs22SrjRpYFmByw
         o8GY9Cx6sEp7KUcFZvdvwCo/o0ybvWZLpNxSs7icc6t8fEdbD3nS2Q2bHKmf1JAu7aM9
         4z6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742384349; x=1742989149;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BJsAUn2tJ/N0GZBEAi0IEG/qBVORqD8jC/NmJGn5En4=;
        b=B6tCHGdcBldY2RZUoy5QOc13I42TqFJ7QvIw6vAbvXm9RZGox0zDSUOiw+s6BanFT6
         rLGhxMjYQgloBChU9L+4LYBkrPaqKchMRqcfm2hup8AAb1QDMRwj4SpjXvs5VOCycgKt
         lWHOGFP+LbAD32x3OikEXUNiVhFf5eKY/oI2HV8RYH3uzIDOeWq1U8iznDXvXg8Ofrhq
         spH7lnTHQYf6idsMy3WYzSfbVgSWHVpohHRAXfn9O4goxjaQISZqW8K+hoP90Ufda2L9
         KQR+f8rR6vKuenvEUHq+CLxzu5i0waxIs8GxXSuXpsmbQxYLEiqVBFqz/5TYozxJ3JFS
         zKRw==
X-Forwarded-Encrypted: i=1; AJvYcCXXyS73RpfdHIDdyk+pLLAiVYRUdxdMsBD9mkJmggENPgtZZDYL9PaqlX0+1iaYUktPQgYiBSQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBrjgtenw3ODlN1/hYae0ulpElW8+YZHRj2TENR4Ol72/WY8Lg
	wo0ZjzzveQh3qSG/B0sokSEGtyZdX4HsWQ0T6dkWhsz3+tdMMQ1YxMFQkCqWpls=
X-Gm-Gg: ASbGncvwiyC0YqjS0dfz4sZD67hmhX8HvXhACequ3lISV0ZPizX+C9ic456UGvf0DQO
	PwGDtiUc1I6FeTAEYmk559xbsNXeBS/mLXvVNiw7plEZMV4D5+uphvAolm/sX4wWy3PdfODqUxY
	7CthlbJC092c24qGpKO+7JZ4aB4Ya9CAmyPxBqimToF/+AUBidk03dLMogf74E/rohRc226J0F1
	0KxmhBJBlupUObIx4kEXkPgmCrJKwvNkNMCf8u1rIm00D1MHA+KHg/JODtdGEZztfxCqcnOM4Dz
	tpjPP43WSNXSq9EvbA8AquV8UPbRSR5LnILyiz2KXi+w/NhA
X-Google-Smtp-Source: AGHT+IGfWVdcLoiaUgIHbjMMUMvA2v0l8u40e6hMqGpDW/wkNrA/pWWYq1nd4axTz9YOadVt/J2Xdg==
X-Received: by 2002:a17:903:32c3:b0:211:e812:3948 with SMTP id d9443c01a7336-22649580acdmr35244335ad.0.1742384349386;
        Wed, 19 Mar 2025 04:39:09 -0700 (PDT)
Received: from localhost ([157.82.207.107])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-225c68887fcsm111347295ad.39.2025.03.19.04.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Mar 2025 04:39:09 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Wed, 19 Mar 2025 20:38:56 +0900
Subject: [PATCH 2/2] KVM: arm64: Trace SMC in a way similar to HVC
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250319-trace-v1-2-0fff03204efa@daynix.com>
References: <20250319-trace-v1-0-0fff03204efa@daynix.com>
In-Reply-To: <20250319-trace-v1-0-0fff03204efa@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

KVM handles SMCCC calls from virtual EL2 that use the SMC instruction
since commit bd36b1a9eb5a ("KVM: arm64: nv: Handle SMCs taken from
virtual EL2"). Copy the tracepoint for HVC to the SMC handler to trace
SMCCC calls whether they come from either HVC or SMC.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/handle_exit.c       |  3 +++
 arch/arm64/kvm/trace_handle_exit.h | 20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 512d152233ff..087880b645be 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -55,6 +55,9 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 
 static int handle_smc(struct kvm_vcpu *vcpu)
 {
+	trace_kvm_smc_arm64(*vcpu_pc(vcpu), vcpu_get_reg(vcpu, 0),
+			    kvm_vcpu_hvc_get_imm(vcpu));
+
 	/*
 	 * Forward this trapped smc instruction to the virtual EL2 if
 	 * the guest has asked for it.
diff --git a/arch/arm64/kvm/trace_handle_exit.h b/arch/arm64/kvm/trace_handle_exit.h
index b0308d95304d..a3a0e0a46c60 100644
--- a/arch/arm64/kvm/trace_handle_exit.h
+++ b/arch/arm64/kvm/trace_handle_exit.h
@@ -46,6 +46,26 @@ TRACE_EVENT(kvm_hvc_arm64,
 		  __entry->vcpu_pc, __entry->r0, __entry->imm)
 );
 
+TRACE_EVENT(kvm_smc_arm64,
+	TP_PROTO(unsigned long vcpu_pc, unsigned long r0, unsigned long imm),
+	TP_ARGS(vcpu_pc, r0, imm),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, vcpu_pc)
+		__field(unsigned long, r0)
+		__field(unsigned long, imm)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_pc = vcpu_pc;
+		__entry->r0 = r0;
+		__entry->imm = imm;
+	),
+
+	TP_printk("SMC at 0x%016lx (r0: 0x%016lx, imm: 0x%lx)",
+		  __entry->vcpu_pc, __entry->r0, __entry->imm)
+);
+
 /*
  * The dreg32 name is a leftover from a distant past. This will really
  * output a 64bit value...

-- 
2.48.1

