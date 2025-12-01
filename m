Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34AFC337BA1
	for <kvmarm@lists.linux.dev>; Mon,  1 Dec 2025 18:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764613200; cv=none; b=iD3+O2bAGokrsLWBBfuRykGqMiUFewYjXImgzecb4p3wxaXKgDDJmIdEkqCRen6nqcDgXQ1Fdg+QQkFRqsHNUrKcZL9zt1os5UQrsOhPnQYtUI0FUc7IwEuKHGcTBJsIiCAmjz0XNa+tAarJMxzwBtrYVIzaGsPsF6Y6sD164zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764613200; c=relaxed/simple;
	bh=R4zb8QVEWFPgzNvZ5CPpwj0EBVH9ubdWaSW2XoDwoY0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OHD5RLh3qhJgaFlYou6+B0iRKvIaQVJJ1yh8Ebp7ve1m7pCgxFSXhrK/h5pk/2kegt47lk1DJT3CORM1D8J4XKib0EnrNUDkhZ/PpraB/VTbFrqRyXPhjeDqQFxl+hZwS9skeYl5d5TR+Cc4QAmkzmOlavx0Ncd0HiFQJqsHP8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Zpr88CvA; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Zpr88CvA"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b70bca184ccso448034966b.2
        for <kvmarm@lists.linux.dev>; Mon, 01 Dec 2025 10:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764613196; x=1765217996; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R2ky1g7vqxE0dSxSYlDayHPkG662KZ7f5gS2hZCCGuQ=;
        b=Zpr88CvAsfj2ywbMPvWvH5VsozBrhWQJsGhz2QI7lcetukl3yr/i3jMUZZUin7skxv
         9ALiY4EvGC4M8qPSgmmL6K8GabrwyDoZa1fa7GMwGHA1edEeR5HR9gDSBX4LLwm5mFHb
         ew0x+tm/FNBkVcd1UideS2olAZjNBElgpSsXaWvSwuydmO3p3sMVUrdVW/uYXnVC3gRn
         VdHGoEwlomrXSFE7SOPfWotyVbo/gQHpgMx4U1WKXxoc6YMF72FDd2e/WZd06ug2e7Pw
         6Fa5vGpp/XPFQwJj6NQr+jgsPKiol5twgzhP0BqPJrehnf20+4hkzAzFmYL8fDpr3MtR
         pamg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764613196; x=1765217996;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2ky1g7vqxE0dSxSYlDayHPkG662KZ7f5gS2hZCCGuQ=;
        b=Bw2fQ/7n3Usd29r3zVM5xBVWHPHijlDcxnk8PM29iUbs2M2jtjLgI8SBpQ6kMH3sDi
         Lcac8Wm+aI9wFub2A3qZH0XH26JcuZSOcYhU4awOiFtxHGRgozcg+u6qZRLcgPXiwH27
         VitlWYNZe2PqE91Nt0l/OS7+z4LawQAmk9uoCMVdj0AR+TXDlRD4slkk6e1cN8mr5Qyk
         r3QqoGkjg9pPYmmOC8Bq3pOmhmk2DjuHg2p/osjOIQ+WTnQU9cJ7fyCSRvejfBW0rLta
         62YBqgYkHcZDMkhkp7/XC4uiF0Wd7XB5sSiIYceyVQ5rHiV0iWuqqmjgqZF+xJDy2MuC
         ZqrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzGDY18j/i0RwegE06iAM0uGNBgWeYBPCEM1JiuFcBT8wBfNhE+rg7mlQ8hA8Il2A921PXbs0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlAqWmnyQw+0Cz3teKAXDokxlWA5mjgOSmBIcGQwAM1iPAOV2c
	7lruE+SITHyNUVU9eyHDBXvl5y+yf+X/nvTHYndEXUNflNzphElITvY93kcXk/wKODbc7gfQpKU
	hlg==
X-Google-Smtp-Source: AGHT+IG0rnfQOBcsGBc89nGQ7P5SqEhx394iLm0A9p+JH2UauaQ7PKGIBjoXKOQU6ONzPdt2vT+TuR01CA==
X-Received: from ejdcu3.prod.google.com ([2002:a17:906:ba83:b0:b73:2695:dbc5])
 (user=ptosi job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6d13:b0:b77:18a0:3c8b
 with SMTP id a640c23a62f3a-b7718a03cd2mr1308264966b.1.1764613196560; Mon, 01
 Dec 2025 10:19:56 -0800 (PST)
Date: Mon, 01 Dec 2025 18:19:52 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAEjcLWkC/x3MQQqAIBBA0avIrBN0QpCuEi1KxxooC40IxLsnL
 d/i/wKZElOGQRRI9HDmMzboToDb5riSZN8MqNBoVFrmwzknA+83JWms9T5oXHpjoCVXosDvvxu nWj8ivT43XgAAAA==
X-Change-Id: 20251201-smccc-filter-588ddf12b355
X-Mailer: b4 0.14.2
Message-ID: <20251201-smccc-filter-v1-1-b4831416f8a3@google.com>
Subject: [PATCH] KVM: arm64: Prevent FWD_TO_USER of SMCCC to pKVM
From: "=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev
Cc: Joey Gouly <joey.gouly@arm.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	"=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

With protected VMs, forwarding guest HVC/SMCs happens at two interfaces:

     pKVM [EL2] <--> KVM [EL1] <--> VMM [EL0]

so it might be possible for EL0 to successfully register with EL1 to
handle guest SMCCC calls but never see the KVM_EXIT_HYPERCALL, even if
the calls are properly issued by the guest, due to EL2 handling them so
that (host) EL1 never gets a chance to exit to EL0.

Instead, avoid that confusing situation and make userspace fail early by
disallowing KVM_ARM_VM_SMCCC_FILTER-ing calls from protected guests in
the KVM FID range (which pKVM re-uses).

DEN0028 defines 65536 "Vendor Specific Hypervisor Service Calls":

- the first ARM_SMCCC_KVM_NUM_FUNCS (128) can be custom-defined
- the following 3 are currently standardized
- the rest is "reserved for future expansion"

so reserve them all, like commit 821d935c87bc ("KVM: arm64: Introduce
support for userspace SMCCC filtering") with the Arm Architecture Calls.

Alternatively, we could have only reserved the ARM_SMCCC_KVM_NUM_FUNCS
(or even a subset of it) and the "Call UID Query" but that would have
risked future conflicts between that uAPI and an extension of the SMCCC
or of the pKVM ABI.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 Documentation/virt/kvm/devices/vm.rst | 11 ++++++++++
 arch/arm64/kvm/hypercalls.c           | 39 +++++++++++++++++++++++++++++++=
++++
 2 files changed, 50 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm=
/devices/vm.rst
index a4d39fa1b0834b090318250db3b670b0b3174259..9ed4b7afe022023346d4835d33a=
901e557fc4765 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -400,3 +400,14 @@ will reject attempts to define a filter for any portio=
n of these ranges:
         0x8000_0000 0x8000_FFFF
         0xC000_0000 0xC000_FFFF
         =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+
+Protected KVM (pKVM) reserves the 'Vendor Specific Hypervisor Service Call=
s'
+range of function IDs and will reject attempts to define a filter for any
+portion of these ranges for a protected VM (``KVM_VM_TYPE_ARM_PROTECTED``)=
:
+
+        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+        Start       End (inclusive)
+        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+        0x8600_0000 0x8600_FFFF
+        0xC600_0000 0xC600_FFFF
+        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 58c5fe7d757274d9079606fcc378485980c6c0f8..5ddcdd70a6b280914048e7683da=
fb778d0f24658 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -135,6 +135,21 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vc=
pu, u32 func_id)
 						   ARM_SMCCC_SMC_64,		\
 						   0, ARM_SMCCC_FUNC_MASK)
=20
+#define SMC32_VHYP_RANGE_BEGIN	ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID
+#define SMC32_VHYP_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+						   ARM_SMCCC_SMC_32,		\
+						   ARM_SMCCC_OWNER_VENDOR_HYP,	\
+						   ARM_SMCCC_FUNC_MASK)
+
+#define SMC64_VHYP_RANGE_BEGIN	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+						   ARM_SMCCC_SMC_64,		\
+						   ARM_SMCCC_OWNER_VENDOR_HYP,	\
+						   0)
+#define SMC64_VHYP_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+						   ARM_SMCCC_SMC_64,		\
+						   ARM_SMCCC_OWNER_VENDOR_HYP,	\
+						   ARM_SMCCC_FUNC_MASK)
+
 static int kvm_smccc_filter_insert_reserved(struct kvm *kvm)
 {
 	int r;
@@ -158,6 +173,30 @@ static int kvm_smccc_filter_insert_reserved(struct kvm=
 *kvm)
 	if (r)
 		goto out_destroy;
=20
+	/*
+	 * Prevent userspace from registering to handle any SMCCC call in the
+	 * vendor hypervisor range for pVMs, avoiding the confusion of guest
+	 * calls seemingly not resulting in KVM_RUN exits because pKVM handles
+	 * them without ever returning to the host. This is NOT for security.
+	 */
+	if (kvm_vm_is_protected(kvm)) {
+		r =3D mtree_insert_range(&kvm->arch.smccc_filter,
+				       SMC32_VHYP_RANGE_BEGIN,
+				       SMC32_VHYP_RANGE_END,
+				       xa_mk_value(KVM_SMCCC_FILTER_HANDLE),
+				       GFP_KERNEL_ACCOUNT);
+		if (r)
+			goto out_destroy;
+
+		r =3D mtree_insert_range(&kvm->arch.smccc_filter,
+				       SMC64_VHYP_RANGE_BEGIN,
+				       SMC64_VHYP_RANGE_END,
+				       xa_mk_value(KVM_SMCCC_FILTER_HANDLE),
+				       GFP_KERNEL_ACCOUNT);
+		if (r)
+			goto out_destroy;
+	}
+
 	return 0;
 out_destroy:
 	mtree_destroy(&kvm->arch.smccc_filter);

---
base-commit: 7d0a66e4bb9081d75c82ec4957c50034cb0ea449
change-id: 20251201-smccc-filter-588ddf12b355

Best regards,
--=20
Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>

