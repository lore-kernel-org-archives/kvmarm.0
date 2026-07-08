Received: from mail-lf1-f73.google.com (mail-lf1-f73.google.com [209.85.167.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6483F86FC
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 07:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783497471; cv=none; b=W+BWRbmEwn8tm2ongl6E0D6nkS+llRuxBlGdu5JA6A0d0mCuJnLahNZWzOj30i9Mx67ggwb6X/fQONurvW6BRYM6j14BqE9Y8q06k9PF680qRtxsSOYFw4FDwiyOkCqsPpnOXlrnttPCIpXe4mabLfwZaw4iMSsc9a1cALqGmBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783497471; c=relaxed/simple;
	bh=C9lW5FtsNFxHad90kVAIzueR+ooJaPzexhKAr47w/Sk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RsGSV4XzhbMYZEWZQ9zNXPyKNmLEzEAJLeVE39/J7nXhjf64ddQWcTo0UBsIF1gUc3jJPQ+k67miETIE4FwmEju1RISUfGuLhU/xDsGcUvQZAMmBYKvL7mvu9g/lSGcfYmG+QzDplG1kBqRBIlMrmgWeqLYQ0/4joPdiy0qCI0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q9o+ZRK0; arc=none smtp.client-ip=209.85.167.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q9o+ZRK0"
Received: by mail-lf1-f73.google.com with SMTP id 2adb3069b0e04-5aeadffc05fso70766e87.2
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 00:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783497465; x=1784102265; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oAzLQ3gzA+KnrCzUsFBoGBhVOWJwQaHovl8NoBHBi/Q=;
        b=Q9o+ZRK0szGkt0i4L043oAzpmDKgkpeUKcVx1YTitCjM5mQPeU9LlPT8c1ElvcI1WH
         f2plVbW/8B/sJU88dM/IKh+PHE0k9OUW7AZ3SlQC4svvxzAaJcizxJIL74mMh9XqEXRf
         GwxDY7xBIsBT5XzToE9SUgOhZQJG+6k7CLqQ1nMCkZubeSl8okRKbaMunkZblOYfGQzC
         7GOaqtkmjaf+WQouGZd0YBa+WDagVWb9jfIqYaMvk1M7rBjVcs3IKlxup6cjmG41vjqa
         x10o6b56zwF9QxmkvHc+jlrSKqfDfv1q3SLbKfYPjLywOTm61aZ0+E9ALOYUgUxQhmQt
         u8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783497465; x=1784102265;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oAzLQ3gzA+KnrCzUsFBoGBhVOWJwQaHovl8NoBHBi/Q=;
        b=W3FMIpC9uGN4OAZH8037GPdbsN/7j7c0MiNfq5IXfRkYl4jjLaIQElnsgFlgNzp4GQ
         8AeshJR0eCQ8VG924lwg242hFp+pEtxuvEaCpTFP0vEmQr7EMU7iw98TxoehPwCDKk4Z
         P6ZnG5Tlnne0ncQXnckSQ1SxDhCbquiSxo2UbK+6rPpPDLXirfo4uHBZd32DRC786b/+
         Bh21olGaRIsUPos55JRbdIPWOuhQnD6DgHykgK6Vt8SYYvbLKpm1wnDBnUVyLUcLKBHU
         LEz2eQMejNgThFHkHctKrd2E3dsMhKZPicIEuaZR8TbyJVbnaelwxmDu5u2i0DA537R7
         7AIQ==
X-Forwarded-Encrypted: i=1; AHgh+RpCx58284WQvesTGBI9mnChKmbtxnc9xOQVJ1/mbo8T9dprbW/ecso7u0tJK/SgD/lvqkkmKp4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTh21n0/Go9qk5TVQs4dqqgqdm0wg2Oipc3u6BZG97//CiegH0
	JDfq4fIA07ig4A1xvlbW4TPtYpp1unHSLMerE1nLmh1SKyVyd5+bdsG7kaIHre8pUd16Du6Mpwr
	Qge/E0F0tV1FiNNMuANWZ3g==
X-Received: from ljic3-n1.prod.google.com ([2002:a05:651c:2343:10b0:39a:fb7d:982d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6512:3b20:b0:5ae:bb35:c956 with SMTP id 2adb3069b0e04-5b011497d66mr431084e87.56.1783497464617;
 Wed, 08 Jul 2026 00:57:44 -0700 (PDT)
Date: Wed,  8 Jul 2026 08:54:32 +0100
In-Reply-To: <20260708075435.47419-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260708075435.47419-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708075435.47419-2-vdonnefort@google.com>
Subject: [PATCH v2 1/4] KVM: arm64: Allow early calls to pKVM host_share/unshare_hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	linux-trace-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The hypervisor tracing for pKVM relies on the __pkvm_host_share_hyp and
__pkvm_host_unshare_hyp HVCs. In order to start tracing as early as
possible, allow those two HVCs before the host is deprivileged.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 043495f7fc78..fb049c40d04f 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,12 +89,12 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 
 	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
 
 	/* Hypercalls that are available only when pKVM has finalised. */
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_donate_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d3c69de698f4..361dbfe2e832 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -740,9 +740,9 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v5_save_apr),
 	HANDLE_FUNC(__vgic_v5_restore_vmcr_apr),
-
 	HANDLE_FUNC(__pkvm_host_share_hyp),
 	HANDLE_FUNC(__pkvm_host_unshare_hyp),
+
 	HANDLE_FUNC(__pkvm_host_donate_guest),
 	HANDLE_FUNC(__pkvm_host_share_guest),
 	HANDLE_FUNC(__pkvm_host_unshare_guest),
-- 
2.55.0.795.g602f6c329a-goog

