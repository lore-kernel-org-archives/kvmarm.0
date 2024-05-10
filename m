Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB33174ED4
	for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 11:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715340445; cv=none; b=cDKvPenQjB3RCyIjEFdvDRQlUcZZ3EDzdyFp1dfz5i69dL6EC8kie1r5czj+VCMR/CLVojiT3YdsqQASAvQARq9SzYSjFKwnNtCdeliZD7Oa/isUZrHp1rNm71VrOpRG6bj1ARpwbREzsGq9JIN5H8hFq9UcB0FB9VHyJc6AzIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715340445; c=relaxed/simple;
	bh=A//g+5Ndpfg+WpD9P8dw9I0KPXkUbDOvYBE0SxR39LU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u7BZB6VBq3XC1uyystQBlfmw4S4gh7vfSyc2l4u9RSdtCkHV9DkuP0sUcR0u17XrS629y7Lwm8ctBgDwoYaTXv/1QqQoJrrNEVapFzrz3ybA3GcaNgV2uvpupaUHInH5f+2VodMKBt6gxdsVjCf9otYxsJx7EEQEQe2nexZxbi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KyXz0SAV; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KyXz0SAV"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de617c7649dso2849023276.0
        for <kvmarm@lists.linux.dev>; Fri, 10 May 2024 04:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715340443; x=1715945243; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sbYsZ3117akP+PvJr9gYUoi/CIT+2oSEgeDr5jj+0nI=;
        b=KyXz0SAV/d4JqJDCOVVUSL0xktUUeDw4shzeRiZqNtvBY9xBI9yW2tRUB1bVwdbFYe
         c/UaCM1t7KmO9PgBcnzwcJ4MmydyChEVxfi/FVyH4YmvXPx6BYqpZAedd92g1o3Xjemr
         E9WFKXaUwTmqYAA017qgZ3w5vxM2vwDbJx33u4z6MiSC6UpCEZO5Gcas71FYn9n9bB3c
         vdEUzfuM2No4KakYdLSDLKGcf/m8ICLBx38JieKPy6jwRu0xRWJxRnS901rVlQYVrJAo
         pftCaB1PmXQCk47vxd99ZO0PEURx7L3alyBNpvU7pz1E3yEfDx8/XF3tvJX0y2kMh/wd
         DFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715340443; x=1715945243;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sbYsZ3117akP+PvJr9gYUoi/CIT+2oSEgeDr5jj+0nI=;
        b=EOdXGkdYZOffy8pHKi1XqShrkHhGTnp9dv3TUNJIwae3kQ4lPKPfd1j8Bw3gEjWeUq
         vvMGcQmMbncsh2k7oWbWSfPxqvfwHaqBGYTw+DzmUF8rKAcxgymkiEjddHcsWo6sDOYi
         hwE4K8V9JQXo5Ds5/MwcwBQ9SqViH74YPxXPK8z6tLkNNRREonhU3gTasbOvLyBA6Mm/
         L8UTMIDCSW/ZJ7mfHi9fWpuTthaFn7lEktWBMzZ2Q2h7EsMccDhzxSh8FqRNYSyX8lmk
         VvrgbbT52W/ETOskj40E1E9H5Afw8P1AUKAXrNydV2205tZKSLtueSICgPW9SkrDDiMX
         2q3g==
X-Gm-Message-State: AOJu0Ywpv0tzR/a8pZ0kHpwM6KnyR4QzirFK8ntB0Yi8nQTn3NX1gnTV
	EWJnmbGCwj5TUIlatt6e7JqVweWMH+qlRHlE8lmpSdcADhQbmXkn1LDuH6rMOyQvIRoWMGEbMz1
	B1XoGmJ/cWg7pm2a6iS8LaPxr8SGoQPTL4sMp9c5FW+QsSjrkBxmAfEdwpqSKO6yNthbTpzhyEr
	YMr9ALIjkx2THS7rU8ctDP1lK7b3I=
X-Google-Smtp-Source: AGHT+IFdj/b7v+ntFzmw+lLCR1C20+GpqYEhAi+SWxria6LS62T7NLsO4dOK8hYMQ4bb7TazgmL1bjHlFQ==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6902:100a:b0:de0:ecc6:4681 with SMTP id
 3f1490d57ef6-dee4f30f764mr166230276.1.1715340442754; Fri, 10 May 2024
 04:27:22 -0700 (PDT)
Date: Fri, 10 May 2024 12:26:31 +0100
In-Reply-To: <20240510112645.3625702-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240510112645.3625702-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.0.118.g7fe29c98d7-goog
Message-ID: <20240510112645.3625702-3-ptosi@google.com>
Subject: [PATCH v3 02/12] KVM: arm64: Fix __pkvm_init_switch_pgd C signature
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Update the function declaration to match the asm implementation.

Fixes: f320bc742bc2 ("KVM: arm64: Prepare the creation of s1 mappings at EL=
2")
Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 3 +--
 arch/arm64/kvm/hyp/nvhe/setup.c  | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_=
hyp.h
index 3e2a1ac0c9bb..96daf7cf6802 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -123,8 +123,7 @@ void __noreturn __hyp_do_panic(struct kvm_cpu_context *=
host_ctxt, u64 spsr,
 #endif
=20
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __pkvm_init_switch_pgd(phys_addr_t phys, unsigned long size,
-			    phys_addr_t pgd, void *sp, void *cont_fn);
+void __pkvm_init_switch_pgd(phys_addr_t params, void (*finalize_fn)(void))=
;
 int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long nr_cpu=
s,
 		unsigned long *per_cpu_base, u32 hyp_va_bits);
 void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setu=
p.c
index bc58d1b515af..bcaeb0fafd2d 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -316,7 +316,7 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, u=
nsigned long nr_cpus,
 {
 	struct kvm_nvhe_init_params *params;
 	void *virt =3D hyp_phys_to_virt(phys);
-	void (*fn)(phys_addr_t params_pa, void *finalize_fn_va);
+	typeof(__pkvm_init_switch_pgd) *fn;
 	int ret;
=20
 	BUG_ON(kvm_check_pvm_sysreg_table());
--=20
2.45.0.118.g7fe29c98d7-goog

