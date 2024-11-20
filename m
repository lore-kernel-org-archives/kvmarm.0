Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5B0187859
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 10:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732100001; cv=none; b=R5TBJzIrhoUFCtnATH5Dz01DGLcgaxVeMZK8kikTYLxFWjJeJiCaMryMLQ5fQK/9WAEeM6GuUqgcMFlFex92Jr3mi9zckKojb6su5ZipH2DURYJT2bLbu2YivlCFIT3CxiLuDfVZIA5R2KDGvHedQOrgV6A0KYMYPOY1ofLVcSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732100001; c=relaxed/simple;
	bh=88XT4CYPNYTPqbxPKc3mmDg1crzW70qfcz93YokeWHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BL7pxxi26M3r3l7TS35gfbg3+kKpsx3Am1pHKSkGjepCUEyfmgOIxmQ5wQ+4wDa+XqDv2g1uosxJrbKa6pI179IlGm+ldxKTNdQ5YJkMk1G5FdfrPLIvKSPZRPf+6NtMigT6M6foKtsGuVmkYkRVskZHd8nPAJnDh6Wg8la9WCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0b4E3e5d; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0b4E3e5d"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4327bd6bd60so12909375e9.1
        for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 02:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732099998; x=1732704798; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AUZZOxNVC1lLwStyPm7LTR4giJNaFKBwnVTKDXsGwgs=;
        b=0b4E3e5dktskkumFpsExRYzGFhTlr/86w56n77N9BnA5Vy5rGk2CEFFZ8k83edI/SW
         ISRBo+474dQT0UvLl/aZOtKWkm6uksblFyxHi7L+8vo2QSn+Y6NLFXgR7ZNlfRmhYHG7
         QJpnP3OnbZOCBAOu18ZZGK2cRAMm1Fuob7mx3QF4+b3aWh6vmcwWahmw0yT9Jvig2/Df
         04UFiK0BwwVkHK+BGFaFQo1eLUGVPHr9K1zqk+/CYJ9FhVy5dFNYHE+HsDqcgKb1fJyJ
         uSkc2YzzwBregd37MWuCIrUC+M+412XKfDaAUNOe9ZveXE4hCrLJY0sb/O6RmcWjNL5B
         lwRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732099998; x=1732704798;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AUZZOxNVC1lLwStyPm7LTR4giJNaFKBwnVTKDXsGwgs=;
        b=VOZ320WC3taPmznkG4M50b21qIdvQtevZK80FZgoFJuC/ckpWj750DLNBrHHiXYVL5
         ccpOMX9UFhqW4e94eERZXkBAbxJiH5GDiLG3p5TZqZnbYsIVH0ubIrGOZ85UgbkqlAvR
         v7kwI8bPpX6pBfsqO41o/w3SE3kBMexWMS1ZZjCBVkhpH2EmPNmEBpZxh+g+OVKX/nfV
         rcmSGCw+fi7woRPG9uEOgCxq+Ol4TuJPg7UulC6EfyJ9YLXa33G3HvVuD86suFkESsnB
         9rmjJbHT9ActTaleQWP+vrUJNc965tCLUXSQY5w/7te4bSphq4AIx5ItEvA+O5ESnbdv
         yf8w==
X-Gm-Message-State: AOJu0YxuYv42OsUrs7Z/L4+CiItRt7Bgm9HuywiDmTj0YdGx96SxPqiX
	6za20Y+klEk40i5MH8i3BWFSWTK64m38VFWRrEgHsKBYiq4QEbOLYmCJsxlHt0XMntaDUiy4bW9
	5Hydz4wwuQS9B+t3EVXoL2pEFwq8kXeQkdTmkXe1f8pKbc67dP8uWMqhMdK1vsEi4wjp4QsPGJg
	EDhLf0D6A6aLB+83hLIrNvX9KGdEA=
X-Google-Smtp-Source: AGHT+IESPaO4CPr0NA1Ub5Xw8vv27byiJYHr78DPp8A9WH6e7qfhaRGN7COXOiASlCtqkjlPzdISATeTEw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:1c21:b0:42f:8ce0:a546 with SMTP id
 5b1f17b1804b1-43348904911mr13335e9.0.1732099997594; Wed, 20 Nov 2024 02:53:17
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:52:51 +0000
In-Reply-To: <20241120105254.2842020-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241120105254.2842020-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241120105254.2842020-10-tabba@google.com>
Subject: [PATCH v1 09/12] KVM: arm64: Remove redundant setting of HCR_EL2 trap bit
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

In hVHE mode, HCR_E2H should be set for both protected and
non-protected VMs. Since commit 23c9d58cb458 ("KVM: arm64: Fix
initializing traps in protected mode"), this has been fixed, and
the setting of the flag here is redundant.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index ffa500b500f2..cede527a59d4 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -57,9 +57,6 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 	/* No support for AArch32. */
 	val |= HCR_RW;
 
-	if (has_hvhe())
-		val |= HCR_E2H;
-
 	/*
 	 * Always trap:
 	 * - Feature id registers: to control features exposed to guests
-- 
2.47.0.338.g60cca15819-goog

