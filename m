Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D70333938E
	for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 15:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782540; cv=none; b=ucpD3Btj5r0JSkO3lqMk6E2h42tgSYLMUZyzMv7NAdtKAO9R9FVFxPQilNY0ICRBtVK48anhH4/EFLomhZHstGdG08cNAskQ+ybBE5Qm62DkGSfS/hTj/Rc9cBBxZyH2MjEkr1ppIQIR87CN24KXhjCAiCNkGUQIg1UtgikPO24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782540; c=relaxed/simple;
	bh=IdYR/8yaRIGkwktNu73Ter3+6neq3k/NNu+zIk3IK5c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VLGgTY3Rtu5LDzxJa63PQAhT60M2IARfCAZBTBcpc2UZdFSzuHhRAwwablszHaJPkKg+WfUkjtGbD2ROm/huXsIw4F81+kvhRuq/GCIrQG+T0UtDv9/XI3ZifeFWYXuP2uQ7z4uoKYWVrsM6MKTR9puOxqysZFSxdWjEtvViXxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YurjPvNb; arc=none smtp.client-ip=209.85.221.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YurjPvNb"
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-486f1ecf9bbso1801298f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 30 Sep 2026 08:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790782525; x=1791387325; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kEb6Vu3i7LeQ0WrrmmClxachzkqqgLj3XAr2+t7WRUk=;
        b=YurjPvNbVvibixbtJD/ZbRAX8wS/JkfyAfIiRXQ/nXO8s7RNmE0U5uz35jXhHjohk2
         EoBKjDJZHkcrXbrlGweID3bN4h7fFZT+qclMMpZcKtQoSvx4fAZKSiFiFxB1OrbHiteG
         3AUpPstzMwh1utyDVm5UYicim4e4PLQGJ+JJpXAWmqn06b0/UaT9qdn1UsRqGK5s+JuC
         hXIYktWyIqhEVhWtbpxEAGqv8nhB5AkOO+FDEjbVBaI2MqJrMgjdDfJVXg434pC2eTJN
         gfiivw8fuk7+VrsEKEYModNUV81UuEj1VXYBIhunKDR2BXH3k1u6vgpHp9vakVfqYsPg
         EP3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790782525; x=1791387325;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kEb6Vu3i7LeQ0WrrmmClxachzkqqgLj3XAr2+t7WRUk=;
        b=qGgG7fxDcCk+ZllnL/TkXXrYgqFrb2YnpzXbnp1zU4IZoca/8a/iK1sp+paDCUKUzV
         OE1E+OaSzg9FQ6g1cOTqydvfzf9/b09j+egYJWOtpomRKgeZI/nWnS/vy+Ne3Gg3K3hE
         surPm9T1On7O7Jy/vH4gOdD5dgd0jThj0XD6kAR1Mk0YBmRWScQn59rXvpcBosixeraY
         kguB3INryMzYzF2dilo1qEIDM8i8tokphxGfb/5cPiD2IFv/mXjvFT6Uwu1/CF5tkH/4
         hGCDLCql6CB0nmN2yb//BnaHjePJUKZPKYAGioALWyCNEVroEc1l8yBLN2B3bgSFbnhZ
         xmPA==
X-Forwarded-Encrypted: i=1; AKwUvByMQyVr38aL6UZ/3wveIqUGFPLNdGy9V1smZxLjMnpQlU0hwHnIkU3hFry0CMLXiHhb4OHlqV8=@lists.linux.dev
X-Gm-Message-State: AFuF++kEZlY1pQu3orAXcS/AdeHyziZWwppaOFOPOBbbbn2jH9FzZS+v
	h4hb4pb1DZrnEl0dGiJ8BP/gaIoeIv1fZo1m1qxcGIXjfX7wti6YivcrIxsu7dDQbGwD9/PNdls
	DLQ/GhO7UKe4GqmVldB2SpQ==
X-Received: from wmbgy25.prod.google.com ([2002:a05:600c:8819:b0:4a0:500:55c4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3ba6:b0:4a0:1a7f:2abb with SMTP id 5b1f17b1804b1-4a01addde33mr35495045e9.11.1790782524993;
 Wed, 30 Sep 2026 08:35:24 -0700 (PDT)
Date: Wed, 30 Sep 2026 16:35:03 +0100
In-Reply-To: <20260930153505.2144559-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260930153505.2144559-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260930153505.2144559-3-vdonnefort@google.com>
Subject: [PATCH v3 2/4] KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>, Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

kvm_define_hypevents.h is used to define the kernel-side structures for
hypervisor events. It doesn't need to be used anywhere else than in
hyp_trace.c.

Rename and move it to arch/arm64/kvm/

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
---
 .../asm/kvm_define_hypevents.h => kvm/define_hypevents.h}       | 0
 arch/arm64/kvm/hyp_trace.c                                      | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/arm64/{include/asm/kvm_define_hypevents.h => kvm/define_hypevents.h} (100%)

diff --git a/arch/arm64/include/asm/kvm_define_hypevents.h b/arch/arm64/kvm/define_hypevents.h
similarity index 100%
rename from arch/arm64/include/asm/kvm_define_hypevents.h
rename to arch/arm64/kvm/define_hypevents.h
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 9644c424819b..8faaec899f92 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -402,7 +402,7 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
 
 static const char *__hyp_enter_exit_reason_str(u8 reason);
 
-#include <asm/kvm_define_hypevents.h>
+#include "define_hypevents.h"
 
 static const char *__hyp_enter_exit_reason_str(u8 reason)
 {
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

