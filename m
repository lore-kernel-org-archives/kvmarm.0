Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DEC32C30D
	for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 12:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764246135; cv=none; b=BDeQGlfqhzUrwHPlPrc0yBgGV+35Owm91Uj/6VzkdXCzvcC+AY4PR1qDblu344NeZefPeZ1sfcP3fsmsYZt2vQc24/Az7bSrg9VK1R1f+w3hroKTQfb74BEMo5nQsy2i5tyOfKWBtxP4kEcsxy3PLS80uoT4nHSqueVxaAqkaj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764246135; c=relaxed/simple;
	bh=itVBDoMNcgUwq55xeET6AAi7RpUmXVS9MJk8QhRvEEo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=foWWpCO6/Tx5Y0Ep/X3l6i+tcrPfq33P8ps/BU/tJS9bxuNVgQ4QgR0RYlLUXOai315D5DtVp/QKvEVWF65o+LnciQPiK6brEKDtdhknoyBqscppZVDIBwlCJG+wK8fy7FrwexjGgi+UiQ/I/ang4CrcRjIG4UNm2Fc6gchzzok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rl/9TLmi; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rl/9TLmi"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477cabba65dso4564815e9.2
        for <kvmarm@lists.linux.dev>; Thu, 27 Nov 2025 04:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764246132; x=1764850932; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0jYlXOcQHb39hyc/5eDnef2js3ze9FVOX5U4DjiM3A=;
        b=Rl/9TLmi/nusvFSrOZKI3tLORVz6+Kb1g7cYkvFtAfqu8UnpbSqSpXMzSg7XmNE/gg
         jlvBceTPGcGYxlzi5TqLbaIm6meUyDlmef3dYxZisove5tZNZsiZzWgkrLjgHCScyjlw
         H6Qmys9bf9yTG3dN3jOVoznXay88EpPkWbC3I43nwGPZHxP4xSduGyhL/hHgAiOm5FRe
         u+i2DWRPI5m7RHEQUtAV5wccW5OzgR6LPjh/gBQp/BxdZeJ5xQdOcLAhB0N9872EJyqu
         fImnQlpfwSXrmLowODDIYLIiTzdFkSv16bs88FjhvqIh5C5D5tH2AJcmH3BT9k8VX9TJ
         7keg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764246132; x=1764850932;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0jYlXOcQHb39hyc/5eDnef2js3ze9FVOX5U4DjiM3A=;
        b=Jf/kRQcs9sPwoQA/shJovqWKpO6PR4PNw2E9KBBLOnxPCITikad+yvqGtU/ftwj3n5
         CFUR6uGq9lfyjhAofSk4PVgcUU+qkipSAB7KA0vMQCUMsoH7eCqbYKbv7SzY1wko8LDu
         zIxL7waui6xJjqxNCVa1SvjV8/R5PqJWafYYdmuWyW6sNHKGEYHp1Kp2mF3MtAlYNKGT
         SibKY/aCbkXzjdMKzAhfSbPylnRjQNFL979qRZ6A9drUsJ+o7J23NuYTaB9yqXLCLsTG
         zKkd6enaisnXGLfqPHDOFSanbFrLsr9lp46hQDIQguqj2o2Os3yJZDZ3OxPSu7LKZDzB
         4oiA==
X-Gm-Message-State: AOJu0Yzn985ItKwQW1sCzXR84wLf8OpMGHtE7y4hi5GaZEsJzlJzeaA5
	M1lQYA8bWQJgabf4cweTiXvtowWIwnp0tFcv5n3IgXtBODJ/fk3wAOIWtXm+//CJZ4cpaGbLfhl
	w6FQ2ih9bOYnZiQ90LkGgzQ0EmLzUXE50/TOQLbfGPDIpUciQk6qUh8ku4vLy8IuJkkfIGyO8/n
	T2unLDm3sa+7lFkxTcJ8K6FtDxDoUIeNk=
X-Google-Smtp-Source: AGHT+IG376eJWHhEDDHEut4Z6VQk8yE45YwYK/zkOvNfOcdPu+aYheXH5kexSijNSsoOI07uy/ilOytz6A==
X-Received: from wmcn11.prod.google.com ([2002:a05:600c:c0cb:b0:477:7a96:c9e1])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1ca0:b0:477:75eb:a643
 with SMTP id 5b1f17b1804b1-477c0165b4emr275207485e9.4.1764246132246; Thu, 27
 Nov 2025 04:22:12 -0800 (PST)
Date: Thu, 27 Nov 2025 12:22:06 +0000
In-Reply-To: <20251127122210.4111702-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251127122210.4111702-1-tabba@google.com>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
Message-ID: <20251127122210.4111702-2-tabba@google.com>
Subject: [PATCH v1 1/5] arm64: Remove dead code resetting HCR_EL2 for pKVM
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The pKVM lifecycle does not support tearing down the hypervisor and
returning to the hyp stub once initialized. The transition to protected
mode is one-way.

Consequently, the code path in hyp-init.S responsible for resetting
EL2 registers (triggered by kexec or hibernation) is unreachable in
protected mode.

Remove the dead code handling HCR_EL2 reset for
ARM64_KVM_PROTECTED_MODE.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index aada42522e7b..0d42eedc7167 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -260,11 +260,6 @@ reset:
 	msr	sctlr_el2, x5
 	isb
 
-alternative_if ARM64_KVM_PROTECTED_MODE
-	mov_q	x5, HCR_HOST_NVHE_FLAGS
-	msr_hcr_el2 x5
-alternative_else_nop_endif
-
 	/* Install stub vectors */
 	adr_l	x5, __hyp_stub_vectors
 	msr	vbar_el2, x5
-- 
2.52.0.487.g5c8c507ade-goog

