Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019B120298D
	for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 13:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762782335; cv=none; b=dcIq2Er8eSkq2d7keIBuu96xgjWh0A2C8eylmNohHmtH8PDTg/Mxi947zHF6XzCsL9O/RpBzH03cKz18yEAIj/CY79auq3cjmeJM4epgzunNhm45YiV+R7piBhsDRAPlsIu0JeHERvfadc48HIvyaX7lRTpzxrTx6uyVr6IcNiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762782335; c=relaxed/simple;
	bh=XZ68awc30/NwN0AX2HwUtKn/22Xb96C1yqMpppbSDuU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZUMAFBLWPfMUcmKSSO9Ow5dqUicuhc+I6Mg+6mAvk1duDhO48TiH7q+HYO+J2j6ekFnyJ7Wl0ZUCODRMcqTnDmWEyIQPnCUgNeZJZd9CsQzRw1yXRgjc6kQ7VGocyDOGdHLhHEQoeU3RGbWyRFJd/NkvdUcXydoWzvIQpV3Qhvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xy0CSx2v; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xy0CSx2v"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4710d174c31so24913805e9.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Nov 2025 05:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762782332; x=1763387132; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1/fm4nl0KgisTT6v5Yg58GOK5F5zZrpPcJU+5CfVCJs=;
        b=xy0CSx2vFGwBfp4Uyfd1UquBa2jxRIXG3QGpJFFQYaMy7AWlyiwbE13zCbGE2qWRBr
         9VCxbBIauSLsyBXky+t3lz5kdcw7rv37nEkcp+5POnl+tzx7ps6s9IhYdmWMyCb/CzUi
         Yl79Y/i01Xvo7N5d6a7bma2GIS7SEdC+EK4EEEz2N5UEVmustWegeU+g4VzWcDKn7WZg
         Kq4jzVa7sg26j2VudvVjoSkQLBophFkI/22KT0qTnp+9i1bbquSnmyzXQWVCqmty3GUC
         xS8ahO9eYOUuD4UEYSweu1TeTIV96vlERn0ARYQAWP7efqkzB2b8Mo93xe5tLLVXKBKQ
         g4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762782332; x=1763387132;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1/fm4nl0KgisTT6v5Yg58GOK5F5zZrpPcJU+5CfVCJs=;
        b=ASdQKs4/eX3b0POPcRFJ8lPewbK7k7PE5eq4pD2dm8PRvX9pzcbKSOq5h0LtrEAFFJ
         Usm22/aX3TrDHhT2t5plWNlKwzZgVNygTDo+/8EYmcRHcdwVs2BctPWD6M+X56mOyXuk
         un1mqX5tT+VbEAN0TneEE8L8XnbjDT0tSL9vCFm9kgL2huU/VekKwe58scdT0/8dYJEn
         mrm4X0aTn4/czeOs9qE5lyzmOXH7IzTOId8hxuTfV0DzHT1L/bNOAycez/mnInhbS4jw
         3oH2znkia1nH3MIAC6Z7/6t1i6pgDgUAGhCm/uDWYimXj0e6NVjxe4L9oAvEJZaBBGXt
         bEEA==
X-Gm-Message-State: AOJu0YxBATTJEF9NpdWkK3bB6Bp5Zmhfh/2NJ28br26frhpXhjRzqPr4
	z/jUvf+a1UKtpaZ2CBybgsM0OpcVWleC6dO2fQcn6zW1tUY1O5jtdlBbG300fER+xhHQuBToHmB
	ooGb7nYzyVwb9dgpqrBlbeXEArc0o4i2kCyFhJRxTvk/PFbXTqRKWAVJxAKRRmVY6d+CbX/zNAR
	OZA0KpCyCzNjW1FnzpCi+vmJqYHAE2ZCs=
X-Google-Smtp-Source: AGHT+IFrLXPatsL3cKFrxUxY0ZecRhM0O2Za13tOgEt+4mphfqOiMkTeDFkmmonelKHZAFUDUzD8DYLTKQ==
X-Received: from wmbdo21.prod.google.com ([2002:a05:600c:6815:b0:475:d8bd:60f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f8b:b0:477:569c:34e9
 with SMTP id 5b1f17b1804b1-47773271a62mr84697165e9.23.1762782332359; Mon, 10
 Nov 2025 05:45:32 -0800 (PST)
Date: Mon, 10 Nov 2025 13:45:23 +0000
In-Reply-To: <20251110134525.3768197-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251110134525.3768197-1-tabba@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251110134525.3768197-7-tabba@google.com>
Subject: [PATCH v3 6/8] KVM: arm64: Do not allow KVM_CAP_ARM_MTE for any guest
 in pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, vladimir.murzin@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Supporting MTE in pKVM introduces significant complexity to the
hypervisor at EL2, even for non-protected VMs, since it would require
EL2 to handle tag management.

For now, do not allow KVM_CAP_ARM_MTE for all VM types in protected
mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_pkvm.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 7195be508d99..ea5d2275d16d 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -44,6 +44,9 @@ static inline bool kvm_pkvm_ext_allowed(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
 	case KVM_CAP_ARM_PTRAUTH_GENERIC:
 		return true;
+	case KVM_CAP_ARM_MTE:
+		/* Memory tagging is not supported at all in pKVM. */
+		return false;
 	default:
 		return !kvm || !kvm_vm_is_protected(kvm);
 	}
-- 
2.51.2.1041.gc1ab5b90ca-goog

