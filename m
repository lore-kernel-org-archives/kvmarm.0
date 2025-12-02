Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91803315D32
	for <kvmarm@lists.linux.dev>; Tue,  2 Dec 2025 09:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764668216; cv=none; b=dBlwFjkiaP4Y/RjxhkROJBO0aITyfUPLKp4KRzgILGZqtoLB0vq2XhUGpXnC65YAHnvKUbNj/AJo8slB9Oc/k4xHKJXqWSbnEVqKU3EYPoWkpV5d9M6sMBGND68BUgd1HRWj1c4JX1Yf9t3//ARZTVzVjn37SP9qWLRBVH1jdcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764668216; c=relaxed/simple;
	bh=Q99ZHptghXaCpExrmPZ+3oDScYxZaZVcLLYNcVgWl8A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hF3JgpT5OZoDLTe98qsJgq+fMo2o3ZowRZO0dGbvKOKtVQT2ZoG3g+4ESQGgc/sLDaUY5gDafLKRMT5AObPkKwwSe1xxGBtZWk9oKse1uXjhXzzd2bhJatehaqyr+26Z8RbN1XthzvUCOd80G4aUhXlha1DhaJULFvx0aubWHec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vXY6WuUE; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vXY6WuUE"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477b8a667bcso58838665e9.2
        for <kvmarm@lists.linux.dev>; Tue, 02 Dec 2025 01:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764668213; x=1765273013; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q0u7iZOSRB+/DoXWsZu1l6FhJZS9KBdr/uN7Ps8a3zY=;
        b=vXY6WuUEUteyiZzJOu7C+XCHRmAPk2G+ppMUyBXGQBgB4VVwJmdasw/IAedyejDrVm
         ud6fESoQx4I5d5Unc9gidXRpXCwSTSR0B9wlx2NqSkJXS5Yt2igut54muCTAEsSXtYSq
         gZOraTdvKhI/IciIhJ3Jv77PX0Y44UXw5CUVDIQUzyK2fJ4W/P194ya+WBQx2iK1tl1V
         d4Jp3jrYIdClba7Wn9lXd79A41avrwvPqr9O0jXj5LWqalvd/lTAG5B9Qh2I01/N6YGb
         bobsTP1mYfGmrFV0FsUSNBm6PL03Tje15PJDLP5lQsH9iHAl4uqg9pm/B82cXuoWw0w8
         bSAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764668213; x=1765273013;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q0u7iZOSRB+/DoXWsZu1l6FhJZS9KBdr/uN7Ps8a3zY=;
        b=UG6NjcGrTt5gL2R93LNqQ1sjvRqm0Q0JZBO+2vl/NE8wrNGRf6BFNmg7IZIgHv/bVm
         +yXssufGSNUzqO3maW7vazMlA/KCdh5jc8iWc31L/kg5wfKweR7fzn5CanJgznH3g6Wc
         7zXiJooLVm302/sPXZpqBT8+PRsLfqkk9+oODKAPR1hzcXKPFkQq0dXZvXd4jVfs3vPt
         iRCiUHx0n3i1+NOq/QJr6E/IFbyriNWI/616LUAjgmyBiz2orCmPpFI9EJ63niyKwExU
         eCYAL+huqPaoG1xfouEgMqKUhxFbOQGmzfsqZHrbFKSSnBw0jGEkt+V67X9tDfc4qFqX
         cJUg==
X-Gm-Message-State: AOJu0YzPNKTQOl4Yu3PgQmzJG4Rdgzpj9iMJcxbw5/OEEj25xolQqait
	+rgMzeFX5b53a8ccQFe72VrP04m4yngOfs3QUG5OzG17n2wHhEXSMS8JILh6brVMcgt3wpsk0FU
	/7C3ky+xxgxVoWlfUtC0P2w==
X-Google-Smtp-Source: AGHT+IFuFDiK5O/H4DCPpcGsIXjLLUp67EQUdvqZzMXYtR/E9T82F4OhwcYQh3aVnhXs8gEpu7agTyI46dk1Z4AU
X-Received: from wmom17.prod.google.com ([2002:a05:600c:4611:b0:477:40c1:3e61])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fce:b0:477:9aeb:6a8f with SMTP id 5b1f17b1804b1-47904ad9438mr274538365e9.9.1764668212914;
 Tue, 02 Dec 2025 01:36:52 -0800 (PST)
Date: Tue,  2 Dec 2025 09:36:15 +0000
In-Reply-To: <20251202093623.2337860-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251202093623.2337860-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.52.0.107.ga0afd4fd5b-goog
Message-ID: <20251202093623.2337860-23-vdonnefort@google.com>
Subject: [PATCH v9 22/30] KVM: arm64: Support unaligned fixmap in the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	jstultz@google.com, qperret@google.com, will@kernel.org, 
	aneesh.kumar@kernel.org, kernel-team@android.com, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Return the fixmap VA with the page offset, instead of the page base
address. This allows to use hyp_fixmap_map() seamlessly regardless of
the address alignment. While at it, do the same for hyp_fixblock_map().

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mm.c b/arch/arm64/kvm/hyp/nvhe/mm.c
index ae8391baebc3..a6eafd72f87c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mm.c
+++ b/arch/arm64/kvm/hyp/nvhe/mm.c
@@ -244,7 +244,7 @@ static void *fixmap_map_slot(struct hyp_fixmap_slot *slot, phys_addr_t phys)
 
 void *hyp_fixmap_map(phys_addr_t phys)
 {
-	return fixmap_map_slot(this_cpu_ptr(&fixmap_slots), phys);
+	return fixmap_map_slot(this_cpu_ptr(&fixmap_slots), phys) + offset_in_page(phys);
 }
 
 static void fixmap_clear_slot(struct hyp_fixmap_slot *slot)
@@ -366,7 +366,7 @@ void *hyp_fixblock_map(phys_addr_t phys, size_t *size)
 #ifdef HAS_FIXBLOCK
 	*size = PMD_SIZE;
 	hyp_spin_lock(&hyp_fixblock_lock);
-	return fixmap_map_slot(&hyp_fixblock_slot, phys);
+	return fixmap_map_slot(&hyp_fixblock_slot, phys) + offset_in_page(phys);
 #else
 	*size = PAGE_SIZE;
 	return hyp_fixmap_map(phys);
-- 
2.52.0.107.ga0afd4fd5b-goog

