Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE333E9C1E
	for <kvmarm@lists.linux.dev>; Wed,  8 Jul 2026 07:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783497475; cv=none; b=hUmGR0MWQwaTaxwX2cG0w/sRJZ1FsS+3pz44xBceG6ggdRlxewRHuQ5Juzj6z++deoIKX/djh8h3JCG9rVDVBXWZmdEIPOE6vP+JmU2QQznYVoeNWT4fpaKB26twSE8WAlyBf6ijnA1N2US8hqFVktAAa+z9fG8325fd/72vYu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783497475; c=relaxed/simple;
	bh=VzCYkNa30Geqvz9sJ1QH8BtffPcQxY2xckFaj8QY4L4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AQZBHVi/0AQipS60pdEPOscVYNX2upI6UFJIzhz0sn3Pj8Ke1VsONT3ZL4LFdq6zvwqQ1cnWqq4TFABERPU4HPFvHrqW2V2OREgpAARTkTI19+Su84k7gvLIGwtQU0gIKdcoNoyDHyclDDGsRCBhR2/XzCQTjCQg7i/CqqMud/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZqJQf3ZV; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZqJQf3ZV"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-698addf0a80so513213a12.1
        for <kvmarm@lists.linux.dev>; Wed, 08 Jul 2026 00:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783497466; x=1784102266; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AKUSCNsamYINaoMMk1AY8FuyMTxoIpvfSaBPJ1kllt0=;
        b=ZqJQf3ZVQ5RMFmCdgGDH5R4YPARmHwHkdEEmnACGOjmiFJncbRi7Guqh0B+I3GOdKf
         E6snWzu4t7k4XTeAdVDxKQrD2BNATNvmtqhwiTftEYpE+oCAK1xNGfsTBVo7qzoq5Ruk
         O4j7hSObdMz1gdhX+j+ccZNUkSQ04C/2BE9EFa4T9BViw6TssaVRhUIHQqJZWtCag9ne
         Hv0MdLOWE2ZleCMcIXFbLxWrs8dmAXPzC81OPg36vkQkUklk6PqVgPAqcuMDvUUl8lAG
         dd+bL+eFVvwXyhKPuTW/zwu/8ZgXWYHBu3xWds1a4dDdEIh6Tr8uM1GJEWOKF5f2cgJy
         jf/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783497466; x=1784102266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AKUSCNsamYINaoMMk1AY8FuyMTxoIpvfSaBPJ1kllt0=;
        b=J2okGYeIixNfGyhTMi+En1ewi1brWIEj+TKG959Q6XBD8BrTxx9CgtNkTpgsXYICIf
         UIhvoSs+qaP0ZhJCHinBToMKmCo/coMxQpOwqSWzcKeOw/n1s8mQLcqMzHZ8a0j2rPyg
         DX5fBU9I+HHTtyDk9PX7bmwlY/wIMZB6PV4cPjn9W4Y9L03AHSO+PnhKyMUhPkmL5JB2
         g2SfpQ7insHVymgbeQPIDfU8GOuI2byHe/C+UwgYIP40NO2uPPY6uEgxcNk1ElMvcANA
         L0UBk9aGvkJ6gQFwrVfpmANiQauqEy1EAabjRSsuS2wTe0aOd8/iT87gE/RPffBXFcag
         +6nw==
X-Forwarded-Encrypted: i=1; AHgh+Rq/i3kxoCJFUNUb55FPZKok5VoX/tXXhGQV3xt8AyaynQFdAieQA2I7FdBDDDRVELh5nJteJtU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/kYwPF5mq1tlMj0W7tMtG8ywjtcQvLVrfu0GNnHHqzg2CjHO9
	5uNFnqxe0tHvUsmBC3+ogiqeWDWKEFKdBgTAOoD4o8+t8uqNERCJRE4h29Yzu4vOMiQ+j/9YntP
	qweX5RVE71qsAvbMj+hY9Ww==
X-Received: from edro11.prod.google.com ([2002:aa7:d3cb:0:b0:698:aaa3:b77d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:4305:b0:698:585c:f07b with SMTP id 4fb4d7f45d1cf-69ab44634e8mr540676a12.3.1783497466019;
 Wed, 08 Jul 2026 00:57:46 -0700 (PDT)
Date: Wed,  8 Jul 2026 08:54:33 +0100
In-Reply-To: <20260708075435.47419-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260708075435.47419-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708075435.47419-3-vdonnefort@google.com>
Subject: [PATCH v2 2/4] KVM: arm64: Move kvm_define_hypevents.h to arch/arm64/kvm/
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, rostedt@goodmis.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	linux-trace-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

kvm_define_hypevents.h is used to define the kernel-side structures for
hypervisor events. It doesn't need to be used anywhere else than in
hyp_trace.c.

Rename and move it to arch/arm64/kvm/

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_define_hypevents.h b/arch/arm64/kvm/define_hypevents.h
similarity index 100%
rename from arch/arm64/include/asm/kvm_define_hypevents.h
rename to arch/arm64/kvm/define_hypevents.h
diff --git a/arch/arm64/kvm/hyp_trace.c b/arch/arm64/kvm/hyp_trace.c
index 2411b4c32932..0c7349fe006a 100644
--- a/arch/arm64/kvm/hyp_trace.c
+++ b/arch/arm64/kvm/hyp_trace.c
@@ -391,7 +391,7 @@ static struct trace_remote_callbacks trace_remote_callbacks = {
 
 static const char *__hyp_enter_exit_reason_str(u8 reason);
 
-#include <asm/kvm_define_hypevents.h>
+#include "define_hypevents.h"
 
 static const char *__hyp_enter_exit_reason_str(u8 reason)
 {
-- 
2.55.0.795.g602f6c329a-goog

