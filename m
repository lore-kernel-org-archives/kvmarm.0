Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED75248F77
	for <kvmarm@lists.linux.dev>; Mon,  1 Dec 2025 21:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764624421; cv=none; b=Ma782Yb8vyQqmITCrHwo6yq+k+SBHmcMVy2mYY5UF6mZ4cB6P6Df1dYrVOF1kt0FkKSYNz+QaeVaJ59NIdxtbmNbUdjxVHdToKxwYcJS8FAQJsQ+PnRPvJGWmj0o64csyTZcHy5sDmFOKXVELH4YgcgjN0NFj3XOa5WsedCdMNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764624421; c=relaxed/simple;
	bh=8mLxC795XDeXvk7AKRtIomjBDkWhyEQnDZ+CSuHWqxQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=fV7YHogdkHg0lJtnP066SnR5WDzmVejY/qxvcQIIGINxl3Mvg7TUjednPXYWyPKjr1M/k8+p1613LnuMDGmmcBVtjZ5qbEhvo0iKi+vd+nuE/FzPO1HBB6ncLcNYLADxJ3gtuYPJVH74n0w4boTmBZOXBWsNkmpFLO+86p/xLXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pT4GGGs1; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pT4GGGs1"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64160e4d78eso4505479a12.0
        for <kvmarm@lists.linux.dev>; Mon, 01 Dec 2025 13:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764624417; x=1765229217; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cfRTWtcIaathUA2mgL41QBVM+XL6VT6UBdp0QiNZHSY=;
        b=pT4GGGs1WTOHEeLPUmoKzpIHZYZ7vNqGX8DITlzgZrGb6BtibxFyqbpf/YKoqo/jH1
         pFDsCP/0FcUsddhm2HuFe4BySDMZqh6eYkH+gL8S44s2SQuUzO7tPLaNlj3HD3FS3E4I
         4xjNch5MEX/l4CeqJHFQfRLPHyq9IxajEmUrwXDmOvKBW+R1rrwVklapWtZxkRsfJ9jW
         jYCE0ltqrGOr28Uwx1NItaNS6+25gDPlgjFWi9FHOrTtQ6MJQehP/0qS+3iqZbGmkBMD
         j0bMD+FWloH3xgKETcXl1p24yyR5p9iDNkYSqw9Q1mXpNjtjRdYgDvxyXXqOLpPWd2cE
         2fWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764624417; x=1765229217;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfRTWtcIaathUA2mgL41QBVM+XL6VT6UBdp0QiNZHSY=;
        b=rZLwIXtmQ3g/6eZy8W6yQrOxXkrZprFXtQjRV1DdbG6bEcau8wPBuAXntnMNKXEwE7
         K0DPqn5qmR0oI3f+xIwX1vNiInfg/wJeaGyLiZYsDL52E4W84UobE5FKMjoGF7VbXbvN
         qzwK2Ud6b0A2NOHRVF2GM602ELkzNz1NDIwSuUeoVxyfl0hNO3bQ+fyNPEehtqr4CGdY
         x3+nshyAgvuWJI/GiMofjTRJDAU040LFNapH2x6LD/pC1T3zOqROSjE72U7/0wX/jCsn
         Tpp4UO71EJGCzuJsWmIeHG4T9GI77YUMccdvFasv1Qu37dz+h2jAG1f0vrm1i0LNtscf
         9g6A==
X-Forwarded-Encrypted: i=1; AJvYcCVvb64ufKzUldrEoXrFkDMC/RAcb5bNxx+f8oEX7hBdVI+gFuFnlg5dPc7ci10YsCR83oniGOM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwB1kYu1W1C+RxOGOaJKeZF7w8egJtA1sQTFm30clbbJnor1k5g
	JeARWZlRqIC75IzP/dd/CFqz8qJICXB+++g272T8p1xdoYEpQlbs15AyaureRLFtXNI4xVwtoPq
	TCQ==
X-Google-Smtp-Source: AGHT+IG6OTWqFbaWntwqBBvO6mL+v9FKNl0tgC0FGiL0/5Lod1u3ROGkbcUdu5tvSbLlEmMPZt/biMrlsA==
X-Received: from eda15.prod.google.com ([2002:a05:6402:a00f:b0:647:7a4d:7406])
 (user=ptosi job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:26c3:b0:643:6af2:2356
 with SMTP id 4fb4d7f45d1cf-645eb2aade8mr24700068a12.26.1764624416786; Mon, 01
 Dec 2025 13:26:56 -0800 (PST)
Date: Mon, 01 Dec 2025 21:26:42 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIABEILmkC/3XMQQ6DIBCF4auYWZfGQWlIV71H40JhwElUGjCkj
 eHupe67/F/yvgMSRaYE9+aASJkTh62GvDRg5nHzJNjWBtlKhbJFkVZjjHC87BSF0tpah3LqlIJ 6eUVy/D6551B75rSH+Dn1jL/1D5RRoJh63WGPN6fH7uFD8AtdTVhhKKV8ATlMx72pAAAA
X-Change-Id: 20251201-smccc-filter-588ddf12b355
X-Mailer: b4 0.14.2
Message-ID: <20251201-smccc-filter-v2-1-03dab737a14d@google.com>
Subject: [PATCH v2] KVM: arm64: Prevent FWD_TO_USER of SMCCC to pKVM
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
the pKVM FID range.

Similarly, reserve the "Call UID Query" to ensure that a malicious host
can't mislead a protected guest into misusing the pKVM ABI, under the
premise that it would be interacting with a different hypervisor ABI, as
hypervisors share the same FID space.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
Changes in v2:
- Restricted the range to pKVM HVCs & the "Call UID Query"
- Updated docs & removed mention of KVM_VM_TYPE_ARM_PROTECTED
- Link to v1: https://lore.kernel.org/r/20251201-smccc-filter-v1-1-b4831416=
f8a3@google.com
---
 Documentation/virt/kvm/devices/vm.rst | 10 ++++++++++
 arch/arm64/kvm/hypercalls.c           | 29 +++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm=
/devices/vm.rst
index a4d39fa1b0834b090318250db3b670b0b3174259..28ab2629e7e8f166def6f9efd18=
e8408ab4a8e63 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -400,3 +400,13 @@ will reject attempts to define a filter for any portio=
n of these ranges:
         0x8000_0000 0x8000_FFFF
         0xC000_0000 0xC000_FFFF
         =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+
+Protected KVM (pKVM) handles some calls directly and will reject attempts =
to
+define a filter for a protected VM for any portion of these ranges:
+
+        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+        Start       End (inclusive)
+        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
+        0x8600_FF01 0x8600_FF01
+        0xC600_0002 0xC600_003F
+        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 58c5fe7d757274d9079606fcc378485980c6c0f8..5329772f228d356322863a7150f=
fa40c25ea1ee2 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -135,6 +135,12 @@ static bool kvm_smccc_test_fw_bmap(struct kvm_vcpu *vc=
pu, u32 func_id)
 						   ARM_SMCCC_SMC_64,		\
 						   0, ARM_SMCCC_FUNC_MASK)
=20
+#define SMC64_PKVM_RANGE_BEGIN	ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_I=
D
+#define SMC64_PKVM_RANGE_END	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+						   ARM_SMCCC_SMC_64,		\
+						   ARM_SMCCC_OWNER_VENDOR_HYP,	\
+						   ARM_SMCCC_KVM_FUNC_PKVM_RESV_63)
+
 static int kvm_smccc_filter_insert_reserved(struct kvm *kvm)
 {
 	int r;
@@ -158,6 +164,29 @@ static int kvm_smccc_filter_insert_reserved(struct kvm=
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
+		r =3D mtree_insert(&kvm->arch.smccc_filter,
+				ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID,
+				xa_mk_value(KVM_SMCCC_FILTER_HANDLE),
+				GFP_KERNEL_ACCOUNT);
+		if (r)
+			goto out_destroy;
+
+		r =3D mtree_insert_range(&kvm->arch.smccc_filter,
+				       SMC64_PKVM_RANGE_BEGIN,
+				       SMC64_PKVM_RANGE_END,
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

