Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875FE15DBC6
	for <kvmarm@lists.linux.dev>; Fri, 12 Jul 2024 11:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720782227; cv=none; b=dTMdUaa7ybuFwXYgtDZcLi6LDVJ5ALoXVdkTU6Uu0ufVuvtOQ1UOFc/l0mJ1FrJ29qJIcumNBDJiMDzgmdCHI9+5FJ7F1IeiZ3W8cIJ5h37Yuf2ThO9cMJDzZzxedpduog+KdXgX/rPqY+g8v9Nzx8MRxYqdyfP2miCUhmdI97s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720782227; c=relaxed/simple;
	bh=ukDXw37dhq+dYuSOWjdciN0yQwOu+nqVZTB9iN2+Ls4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EvJBjmHAQihLWHD1IwbfM1f/w+zPSFMKkHNTljMwoDKQ+ynDKGD24SJ1Gukgjk1UF8mpmpUVbo23xobgEt9hvhfH5yf8FqwSn2CA+Vi1XrzLDerFG95B1pwULN8tj2xP3P/OEsHYVrDzGdGnqpjoXjyqj5R921R9cn/aR7++mD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=du8DrIIA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="du8DrIIA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720782224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=veUUGt+GBKRUflAP/4u3UadYVzXIYYKM+vDLIvIs2Yc=;
	b=du8DrIIAR6MJqkvMf2pBv3p/RAMXq0J42p1oyQnQhR+Z6/cwZFEhi+5SR5/MtZWwZIbb/d
	C80YndRJueYRB9hXlPgRnp5Gn8UFLvPW5rGIm4A+mE+H0bYR/181FEa6pMqmwOT3cLmT+O
	FAE9lpLQl818p5lIgg5IN6wQ+3AY3EA=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-Phta4jefM4KECOBFvh6mUg-1; Fri, 12 Jul 2024 07:03:43 -0400
X-MC-Unique: Phta4jefM4KECOBFvh6mUg-1
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3d1c48fafe4so1291389b6e.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jul 2024 04:03:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720782222; x=1721387022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=veUUGt+GBKRUflAP/4u3UadYVzXIYYKM+vDLIvIs2Yc=;
        b=bh0I5318WOWj8UTvyPdar/IFQIj4EjW0YLqJraD2bs7Ws8LE5b1yFmguPtBD2f7Ylz
         gIBReaX0TJ+xYY9+Eu2pwBP+IvaVHNcE1auStlndxUR0XFy3kyRxDm3FW4/LwjGXuwfC
         V0QgcclL7+sxwPZZZEV36FusB93CbKBYv+Mk9X8Bi3WjeaCXkom2KvlCgyeAb5BzAxDj
         U41y2J6R3oZBHmVYb9iO+ex+U+cyIzXe9a5knntLOgvPXhBCeCSg1Z+4tf1BLYwSWEGH
         iytdZAZjctT9WxaqlLFbNf1LC9Y7KMNhEKKIjk83DdiRNVwFWPEjoC7F22sgMqgvaO3D
         +LCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEfV15StCo87wM2KvfnssKkHDFT9bgOM6aXFu0jV6MxDacvehtqC8MUhLT7r7fY7glbDYVAxBeZaYblN3xnmWx9E4siUVN
X-Gm-Message-State: AOJu0Ywp6r1iGjhscSnI8PyfvdhEvpGbQ2l1tYgPH1IplM5BppOf77v2
	Zu3q7t7CbJKoeEQGSPsfh7NS4/lerfuQITJL+JgxiAQ9E8qgNwxh5ASA8lhLtZfHbs2vbDdL1VL
	JdpqcXU9loGdvrwxFh2Cnba4uwHZBtocZzkoqHUOuA1xQM2/pk9AUKQ==
X-Received: by 2002:a05:6808:1451:b0:3d6:2fb8:2905 with SMTP id 5614622812f47-3d93c08ccc9mr12087094b6e.42.1720782222493;
        Fri, 12 Jul 2024 04:03:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHaYoe9jS++ITWpl1K24bjqJ7Ih4Tcqa5GejquSQMQtKX8znz1DvmZfOWT4pcFyOh59vOw1Ew==
X-Received: by 2002:a05:6808:1451:b0:3d6:2fb8:2905 with SMTP id 5614622812f47-3d93c08ccc9mr12087065b6e.42.1720782222096;
        Fri, 12 Jul 2024 04:03:42 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f45e50062e5f8c654844c9a.dip0.t-ipconnect.de. [2003:c9:3f45:e500:62e5:f8c6:5484:4c9a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-79f18ff834csm390498685a.5.2024.07.12.04.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 04:03:41 -0700 (PDT)
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
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/3] KVM: arm64: fix override-init warnings in W=1 builds
Date: Fri, 12 Jul 2024 13:03:30 +0200
Message-ID: <20240712110332.10970-2-sebott@redhat.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240712110332.10970-1-sebott@redhat.com>
References: <20240712110332.10970-1-sebott@redhat.com>
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

Remove double initializations in cases where that's easily possible
- like extra NULL initialization in static global structures. In the
other cases just silence -Woverride-init.

To fix warnings like the following:
arch/arm64/kvm/hyp/vhe/switch.c:271:43: warning: initialized field overwritten [-Woverride-init]
  271 |         [ESR_ELx_EC_CP15_32]            = kvm_hyp_handle_cp15_32,
      |                                           ^~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Sebastian Ott <sebott@redhat.com>
---
 arch/arm64/kvm/handle_exit.c     | 5 +++++
 arch/arm64/kvm/hyp/nvhe/switch.c | 6 ++----
 arch/arm64/kvm/hyp/vhe/switch.c  | 3 +--
 arch/arm64/kvm/sys_regs.c        | 5 +++++
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d7c2990e7c9e..2c049746657c 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -291,6 +291,9 @@ static int handle_svc(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+__diag_push();
+__diag_ignore_all("-Woverride-init", "Allow field overrides in exit_handlers");
+
 static exit_handle_fn arm_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]	= kvm_handle_unknown_ec,
 	[ESR_ELx_EC_WFx]	= kvm_handle_wfx,
@@ -319,6 +322,8 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]	= kvm_handle_ptrauth,
 };
 
+__diag_pop();
+
 static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
 {
 	u64 esr = kvm_vcpu_get_esr(vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6af179c6356d..bf49afc01542 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -200,8 +200,7 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 	}
 }
 
-static const exit_handler_fn hyp_exit_handlers[] = {
-	[0 ... ESR_ELx_EC_MAX]		= NULL,
+static const exit_handler_fn hyp_exit_handlers[ESR_ELx_EC_MAX + 1] = {
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
 	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg,
 	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
@@ -212,8 +211,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_MOPS]		= kvm_hyp_handle_mops,
 };
 
-static const exit_handler_fn pvm_exit_handlers[] = {
-	[0 ... ESR_ELx_EC_MAX]		= NULL,
+static const exit_handler_fn pvm_exit_handlers[ESR_ELx_EC_MAX + 1] = {
 	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
 	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 77010b76c150..4e4ff2bd51c9 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -415,8 +415,7 @@ static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return kvm_hyp_handle_sysreg(vcpu, exit_code);
 }
 
-static const exit_handler_fn hyp_exit_handlers[] = {
-	[0 ... ESR_ELx_EC_MAX]		= NULL,
+static const exit_handler_fn hyp_exit_handlers[ESR_ELx_EC_MAX + 1] = {
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
 	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg_vhe,
 	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436..00fb6f1e9a48 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2255,6 +2255,9 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+__diag_push();
+__diag_ignore_all("-Woverride-init", "Allow field overrides in sys_reg_descs");
+
 /*
  * Architected system registers.
  * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
@@ -2803,6 +2806,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
+__diag_pop();
+
 static bool kvm_supported_tlbi_s12_op(struct kvm_vcpu *vpcu, u32 instr)
 {
 	struct kvm *kvm = vpcu->kvm;
-- 
2.42.0

