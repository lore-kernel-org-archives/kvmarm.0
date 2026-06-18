Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB240277C81
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 09:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781773299; cv=none; b=WYaCbRC9SYj3vpbCXzH0+w8qdlBUD2dU5kzBRvESnzMoj2nFUCXplYWyfszMhh7AMONndeXLDs7fcvuV84sA21eAZYug/MnEUtjxVWy87/gcU8OhCegcQy6tzEokz1niiaUeW2oYHjyxyfyTfBLX7kicz94eJpCyOe45b4G8WPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781773299; c=relaxed/simple;
	bh=44l2bWmHh9oqwDlLgfnpVWipXB6VIDnQV2gMJ2iiF10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g232ZOc1zBDQ5LMtRWArj02Cssh8xBzSBWWBW//kzxw+qcjtxB9yzS1rVAS8ZaS/0oHN2xzWEIJhn4D/M2d+8a1hytohtRJ4pyOeXVOdll5PRngtfO6oHzMRo44aqoOOdoY8KoJR+jVE+EBwSUm9K9abeHBDf15zh6UJpIfd6k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cJvBxG+O; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cJvBxG+O"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-490b3ec3f7fso3722565e9.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 02:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781773294; x=1782378094; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vSbfsSuF8XQoOBhzJ79rNhpPjL/Yakp0GnQrnvhxx5s=;
        b=cJvBxG+OjJgfmiweytpU7j4k9cejW5SLXvd3LAykKbgi72KLw402S4ZteRLjpJv7+v
         Jm+k6tcI5LjcrlXQtIYJHKxbGRBX2ISKuO0wge9pTqL3RgpE62+kGO1y+QbsZ3mo0j4E
         AHfVoIPiRLrR7mT/lOyO00AZ0XpdIFDI3EWrlL8Cm+oceV4qw0XkG24laM7oWg1BBpcg
         98faqamYUEMNcJwGiNBxDcnBm+Y4SFGhJvYNcWa4tRfj5SEIFEV7WUknMlItFlXDqhlo
         1PTMbcKai1nTidoBDEMiLLE7ikQuebxhnfRH9/qEm0/BcX2MmwgGPBrKYYYX9pW2kMfE
         /XDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781773294; x=1782378094;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vSbfsSuF8XQoOBhzJ79rNhpPjL/Yakp0GnQrnvhxx5s=;
        b=PwRn5fc64XBcrUy6muDANRQOn58L1jM+dHxi1452nVE0fGSiZiEFt+5adiBTfKeASP
         j6QWwWlx859FGwjqNn1AYhN7wYjL5ovedDXYQC2An0oxwQ6ccApDfhT+ZDkSUz18JK23
         zlFl3Du19VJ5oUNHdtJB6RosO0aideSV5u2vP/wYEV9g+snK05LN/+9CN/I0QIW90YGL
         m/BjBUHAKeNK6me16e8HUItABYbpCJmu2b2q2P8HoIyP9GCqM4OvP6ccPeUtQ/Fb1P5K
         Kiss67i/3ysjK+u5W+KvGhi+ZP9DKn9OaawLu9P2KGriiIL6hQbWVKhW5zZgoL25icQa
         jI8g==
X-Forwarded-Encrypted: i=1; AFNElJ9HSaAG11aD7k6/M31eKUrnskVpiDqXaG0tPX3LkO4Br2cK/eb+Y2YmngYV3KsjHcRsCRG5YrA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMA3tLV5iMN+AkDArxBETlmBbZ8z6mvzbJMH2W/LRkDoWj4vsg
	cDRazt2GrC6GlvJa6aZdsfo2vfwKqzHXR7NDSVuPFSLxhesvtUHaGVndDQPldZKRKkoxTNHQ9X8
	Pvg==
X-Received: from wmim8.prod.google.com ([2002:a7b:cb88:0:b0:492:2b56:8534])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:6447:10b0:490:c2a3:23cf
 with SMTP id 5b1f17b1804b1-492333dfdbcmr103923175e9.34.1781773294140; Thu, 18
 Jun 2026 02:01:34 -0700 (PDT)
Date: Thu, 18 Jun 2026 10:01:28 +0100
In-Reply-To: <20260618090128.3913688-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260618090128.3913688-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1189.g8c84645362-goog
Message-ID: <20260618090128.3913688-4-tabba@google.com>
Subject: [PATCH 3/3] KVM: arm64: Drop redundant READ_ONCE() in pkvm_hyp_vm_is_created()
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Keir Fraser <keirf@google.com>, 
	Hyunwoo Kim <imv4bel@gmail.com>, Fuad Tabba <tabba@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

is_created is written under config_lock. Every concurrent reader is
serialised against that write: pkvm_create_hyp_vm() under config_lock,
and the memslot path (kvm_arch_prepare_memory_region) via slots_lock,
which the creation writer also holds. The teardown-path accesses have no
concurrent writer. The read is therefore serialised, and the READ_ONCE()
is unnecessary.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/pkvm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 67b90a58fbea..008766273912 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -185,7 +185,11 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
 
 bool pkvm_hyp_vm_is_created(struct kvm *kvm)
 {
-	return READ_ONCE(kvm->arch.pkvm.is_created);
+	/*
+	 * Serialised by config_lock/slots_lock, or by VM lifecycle at
+	 * teardown, so a plain read suffices.
+	 */
+	return kvm->arch.pkvm.is_created;
 }
 
 int pkvm_create_hyp_vm(struct kvm *kvm)
-- 
2.54.0.1189.g8c84645362-goog

