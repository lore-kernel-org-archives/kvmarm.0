Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189AC2C11CF
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 08:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844592; cv=none; b=ERk+ypYlW7hxhVrGfyJko1yS7TeNxdG+5NOL26R86i4X0fdM6xL6vS034AdWBGFhsoAtT4OoF3evVg4qC5sUTeAhCGvZ6cEaazONZHLquji137BJxYXg4O4PqNZn3nURc8W+jx9DIcHFytazoe9wPR1c3IGFH9oeoFe5BlCmsqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844592; c=relaxed/simple;
	bh=IdYR/8yaRIGkwktNu73Ter3+6neq3k/NNu+zIk3IK5c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JCWvsXQUFlug3G7iwpJVs7jb/CVtoIuvj05PgfgQSgEDA3sNTrqbryi9HBs86WN4bVm7/6nVeyskeZ9+gpCzK80Dq5Alw5MYEiJclx10nVEGJuGMSkun+N4cQaNF8CrcKFJ+Txx+vrgvleVwn/6MDWASuNx/+quTr56Sx5wD/Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aSJaiW5X; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aSJaiW5X"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a024bce773so1920775e9.0
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 01:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790844589; x=1791449389; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kEb6Vu3i7LeQ0WrrmmClxachzkqqgLj3XAr2+t7WRUk=;
        b=aSJaiW5Xz8VN8nhfebj3PlmrlFrtgrN7sCn+b8ujUUH6y7skzssBz4Bgu0QE+tKg1k
         J1FhvVTRV/HtJ+siokNgWRUJlcAqbU8taMNN3TNqQ0JBhUeHBy0zcRpqlk76JkJbDINp
         /eOC+Uq0oFTgAawdS+yMEuz1SUF59mvOTYXMrW6BT/oFn1KdXEAz8f+Cb2IrvqEv0Mmg
         BboRZMSxzYoL+yf/YN7GZagVbnuReBUyQx1qkgLQIn8jf7zlKNkok26ie8Vyu9YBWRLU
         axanqIG9/mySK70mXLID511jAeq+z/WHf7IP6jLEwwzmMN/4tfxxpln/wq11O/tEAlh2
         GOMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790844589; x=1791449389;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kEb6Vu3i7LeQ0WrrmmClxachzkqqgLj3XAr2+t7WRUk=;
        b=DQBfB1C7DB2F+AcmtgqOG7xClmSTXey/wmzl75CbJ0ctOAbIUcTjO2h2MKZcgRFu31
         fCufa3gV85yuXxNyFTEf2y4gadwCl5kodY/kGxiFqtSUfFU6z5E/04LeGRA0q+Qfpc0M
         QcRLw72SFkIcIf6BJ2NhpDlomQTsPEGYOtcCW7n5G/+wO6H3pKSuPAaZEGh3sk0/q9DU
         PR6BkKi7MAUmpUuO4OePPCHtXnoDJFRRV+4wCaLE0rmvNGZuFYtjV3Y0U3Jj/c0gN+6c
         N8pNiB+GU9tghiE7hWquf+GTmfD1fOjxpZHTbZgOZEBfiShL/ucxWYIbe9fKXB6wfZtu
         UZ9w==
X-Forwarded-Encrypted: i=1; AKwUvByqDdvP841NMu2u4qY3NIriJozf0sh5tZnz8c7hb9CFttFCMVpoxcP9rWaIOX+LuZQneiEiJaU=@lists.linux.dev
X-Gm-Message-State: AFuF++nFnbKv93ieYoPOCBFTIRbYMR34govN1p84xa1A3hJhDljUTpay
	3P407amHiF898Jo8oB/Cxw+MMoJ2PDtxRdtMLj6Mwcwx0eQuXvn8OfAdTlPlndfEM43vLXlHQNZ
	i0nCjxJhsXjVgN6h/UHzcfA==
X-Received: from wmnj10.prod.google.com ([2002:a05:600c:74a:b0:4a0:1976:e6a3])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1c19:b0:49c:cfbe:5a76 with SMTP id 5b1f17b1804b1-4a01adb2cb6mr85618915e9.2.1790844589150;
 Thu, 01 Oct 2026 01:49:49 -0700 (PDT)
Date: Thu,  1 Oct 2026 09:49:06 +0100
In-Reply-To: <20261001084909.2937943-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001084909.2937943-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001084909.2937943-3-vdonnefort@google.com>
Subject: [PATCH v4 2/4] KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
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

