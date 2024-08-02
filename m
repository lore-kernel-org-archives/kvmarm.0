Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F11913C673
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 22:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722638467; cv=none; b=MIuhkEf6EcFgWdnaxKX45dJtxIs4eVStLauDJ4tIawhDp8tTnQKpRZkA9aHxqiRLWQU386+Bk8ATYA78KsLttns61IF74+sYHbr1M4lJmvRxy/ObPy3HJJqv3i8l4NpFAJd9+REOt+cZFhE4YySBG7nf2g2hpc5cVjjiARhaDvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722638467; c=relaxed/simple;
	bh=2BJP/Gjlhn0CI12zdChPBuMYdNrdF6BpuynLMzCWLmY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DEZVz9GGfbn5l962g0u/b4xAXyLRLB15su11KMvEl2Lyq7T1yIjY32cNOKgm+MPLgHZLMF9wK26tA9wVZXpGFbB7lJ5KmN6lynVkF/lfZ8EknR5zpa/9k2CZTkkPhYjYjzXiWqP0S0h6hqyKfkhqehpJtWvXJLaLVJ0gbmlalXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BTiWVRzH; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BTiWVRzH"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e08bc29c584so12138303276.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Aug 2024 15:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722638464; x=1723243264; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mg6abDzvai2Zsgu1qbiWH7RLNmKIJFQcCyuMlSnLw2M=;
        b=BTiWVRzHmWq4GxZ++01zPG5zQVQgS42vLEGlC/7Yk8UqNiNeNgHhr15G0kxg1DpfBn
         o+d77X/2jJ+OLoqW9H2jZMlMUCaqJ0xc8QOe6HfiERcm3FZdxrR47T6+x3aJw0elkGjK
         7KN97YZIRTnm4m0+aN7x+vn8ly47fnxsIPj0bU8iL/OvG5oj19ReuFtLtEBMuG+sEoOe
         0GIJH0PZjwbff88um4xphiA+O1vhnDQTPCmcUOyelU1YwdI+SWBMytluKSQrGtx+NpXj
         7LzG7nqxrf70oowgmn/MHKHN3xcy4KO74WzuIyFM13KQh+1hin+swe9QusdiBlfNctrL
         plPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722638464; x=1723243264;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mg6abDzvai2Zsgu1qbiWH7RLNmKIJFQcCyuMlSnLw2M=;
        b=LL1UzbVHfohgNgDou5ueJz20dXNIg11W5HVdPnq8L1R//HLUqmvW9RabzbIrU6BIQ3
         WNvFG7X70Glx+ESUGYbHKGjz3H5cncfS8oAqLPTvUvm5FpkayMjKb5z87XSwhWPAiRah
         io50XSFMEl6cLvXNiNu/LNMKM9XZ83qD5307HYVlBUEZ+aTS/9jswGcr/Ay5JF1znoBy
         C8nGF2VH3TS3i8XQF7QcoWEmOymk0lEN+4yHIEPgZVcI9R+zgzw12nnQ/+fH6vkjHe40
         pICqbVLpM1z6PDupEqNUvChLX0uZ1jSzI2mAScaEHHJAYWbaf8gIQ1orb9IaHG9uW9ax
         hy/A==
X-Forwarded-Encrypted: i=1; AJvYcCX6Mf/qRUyvVJbKFX9kIkLHRLZiwdTkccDT+aMbOS6abxn/MvvVRkzGhCaX4X6Wg8ktF7q5Wto=@lists.linux.dev
X-Gm-Message-State: AOJu0YySUYJrWv+TBith70lGeRHFVpM6/z3Bk04LPiMR0LhsGwfXfo8m
	7BpFMa7G+Tjy8vNRVzzZvQRfo0xmbSRVUpEOjvAw4r/l8YPLNW+38PeWSsXoNHwbD7Ihbr7gw0c
	CmT0mZemXNw==
X-Google-Smtp-Source: AGHT+IEY5CubreumvsIjMcPe2q5xXNHlPJqiPWsr+2ng5ETcTgVR1+5qyV+F3pi2OrpH5AWrnR9VlKryzgVK+Q==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:2b0d:b0:dff:1070:84b7 with SMTP
 id 3f1490d57ef6-e0bde21e24dmr9370276.5.1722638464470; Fri, 02 Aug 2024
 15:41:04 -0700 (PDT)
Date: Fri,  2 Aug 2024 22:40:31 +0000
In-Reply-To: <20240802224031.154064-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240802224031.154064-1-amoorthy@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802224031.154064-4-amoorthy@google.com>
Subject: [PATCH 3/3] KVM: arm64: Do a KVM_EXIT_MEMORY_FAULT when stage-2 fault
 handler EFAULTs
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, jthoughton@google.com, 
	amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Right now userspace just gets a bare EFAULT when the stage-2 fault
handler fails to fault in the relevant page. Set up a memory fault exit
when this happens, which at the very least eases debugging and might
also let userspace decide on/take some specific action other than
crashing the VM.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 arch/arm64/kvm/mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6981b1bc0946..52b4f8e648fb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1568,8 +1568,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		kvm_send_hwpoison_signal(hva, vma_shift);
 		return 0;
 	}
-	if (is_error_noslot_pfn(pfn))
+	if (is_error_noslot_pfn(pfn)) {
+		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, vma_pagesize,
+					      write_fault, exec_fault, false);
 		return -EFAULT;
+	}
 
 	if (kvm_is_device_pfn(pfn)) {
 		/*
-- 
2.46.0.rc2.264.g509ed76dc8-goog

