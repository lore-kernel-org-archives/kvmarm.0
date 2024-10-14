Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA2A1BF7E8
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 16:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728925097; cv=none; b=uiok4G2EO9TqjYqxOShbBpaCI6UKlMtzqkh7f0GIVrofBH1OqJgjroF34fzIEksc8PW2Vu6aHeKPhd0mcEInH1te0X5P4o2vuWg+Wt8PnFZIzp5jKbzdB1bOcE22daMb9O+TDK8jmir1xO7UWmG99vqDrknBdgYyrILYhoV5Ysk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728925097; c=relaxed/simple;
	bh=edUJL+FJ6h9JxZNm301Fog+/x1otwjz6O3CC5d4DGko=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AXrvI8TcrLoMbvU/EPuX4x1R1G5rB2C18GKsr7LaOrNAtaIerykxGZAAptt+eKOhebJ5k4cUQy8NVh0lfvKAGH9GwUY8z/QyAVF9nAIPfJyzXGgxhmeL1WaoEqxTO+DG3ZdxzwHAIdqGqICiPUjIC/E38NMmw+nS9sSV8Yp4TQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kZgHWxRD; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kZgHWxRD"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e389169f92so17191707b3.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 09:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728925095; x=1729529895; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fqg0V801+3eNNwgTiudHRpPmV7ODY0kJS6HC2iw21gA=;
        b=kZgHWxRDrDVti2w60x+KCLBXUo0AM2eTIvQDuns2hy91BjNvHdeoKflEmwN/aVNMsm
         10puARkf15/v/kwvcOq6f59i0GVgB/Wd0MwrDEypvg+3FZ2aRJRskuijYpzqXvfLBBhF
         yQC+Y7VygTL564KpkvHP3ljF5shNNOOwZXZ/A6jimET4PWbR5mrvw0szTZCPqY5dYAI1
         hYhmQ9wsT9tj/Is45epBhe6CX4bExWLPVGooWTW5XlCrD5GHUmDogrEEwdr2AtYhzGOZ
         Dqy+Zz+czxZ7CArfkptagbVuIbvHpc1xv6s79hL0busc4YnQZVglpH0A/kJ3uGMgGAcl
         tF6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728925095; x=1729529895;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fqg0V801+3eNNwgTiudHRpPmV7ODY0kJS6HC2iw21gA=;
        b=XCxYQDNXPKg6JUn6mNBVJ3BfbeVLrGQCqz0K6D2qD8yBgwjMIoFLbx8nMhJfSflGH+
         5NlvMGHAcXtisz7ZZ7H2k2pw1n5pF4iFj3JvlS5BZeajmHVYYmfLp1RSKfp0WJ10DBGB
         DExgiOG3c3RaOo7aOCiq047uO47pTy1lcMYy8G4PS9FlmpPWR1MjohCMCs+ls5CU/zIw
         0Jb5IARof/XP63zj3DHXV7K0kWViVKEGiLYbdNZmRUENzU6fpUN7W/Yj6j5Ak41aARYu
         J7pYH7RVvg+wxVtgkWR2LcG/wWFXrGyJGIT1FzGF5iF49YHdRDBV+lPruJXr6awxcptb
         ymLg==
X-Gm-Message-State: AOJu0Yw6ICJc/8ATgp7N/uEhKNTynZhq/dVgRF4eLmwfKn5pSQRXxDMY
	bvzYMNPh+kYTNIq6vqPb//r8/qmTfILGXWNT9gOa2aYIRws9D3gMMJiJ1IfKKiJdCweq8Y7Ke2N
	pzugYfiqdPyRRi7mfRmSt/IpfGck0dMcPGUSolL3grYQrQIIW+mAnEgq5kXj6KDUhJ3rmPrqlDZ
	K/ajLlXAYrhKfLkqo6HhIc5xAOkV4=
X-Google-Smtp-Source: AGHT+IETZYXlC2bxPRun3hZf6qI/RmwrsYpPmZhA4QTYLcBbmbD0lDZ9hmlRgarabDxKlKnSHYDkLnyvKg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:690c:2892:b0:6e2:1713:bdb5 with SMTP id
 00721157ae682-6e347c4ca77mr302877b3.5.1728925093619; Mon, 14 Oct 2024
 09:58:13 -0700 (PDT)
Date: Mon, 14 Oct 2024 17:58:06 +0100
In-Reply-To: <20241014165809.984883-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241014165809.984883-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241014165809.984883-2-tabba@google.com>
Subject: [PATCH v1 1/4] KVM: arm64: Update the value of KVM_VCPU_MAX_FEATURES
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, catalin.marinas@arm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org, christoffer.dall@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

There are currently 8 CPU features, but the value of
KVM_VCPU_MAX_FEATURES hasn't been updated to reflect that.

Fixes: 89b0e7de3451 ("KVM: arm64: nv: Introduce nested virtualization VCPU feature")
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 94cff508874b..78c068592d73 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -39,7 +39,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 7
+#define KVM_VCPU_MAX_FEATURES 8
 #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
 #define KVM_REQ_SLEEP \
-- 
2.47.0.rc1.288.g06298d1525-goog

