Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F0218FDB4
	for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 11:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732273609; cv=none; b=rnuuF57Zb2lYv7yXXMo0V+NHOCZGh8y293wBzRpvt7X+ouuwqHFuu1D/8nVINB2G2JkICZtzDaEnkw14YlVHG+36p4uSRczc4d3rNshNb8jtyvpG1vBQse7Tst6f0+tkF1XdLDn3uCZx3NGRlk3dRGiQrX+uwV7UzM/fUsnbr1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732273609; c=relaxed/simple;
	bh=jgEuvNt8gncQDjceUbeY0KNevzNLSz8v0UpUFMakaiA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cZZ8cMEPRa0BGQ4Qz5nBQQPyYUuCmx6LZ17E4C8nFpu6lwNW2XrNvGgU9YeKYUJtChDYoyxLgxD+8I4xanHnY3BQdr7fbJSWd20j0K+cmK7jrbGrXt314H074fZA5ClQaPKcxdy05YIePLRom190u1POojQZyUJJcvJCvnGPUgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CAsvwDHe; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CAsvwDHe"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-38233ea8c1bso1655702f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 22 Nov 2024 03:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732273606; x=1732878406; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6ktoHeGKmXYIdsUvMRAz3vVzbrdPr/EI44OUns8qrUY=;
        b=CAsvwDHefoK7RaMSTQjT/o1XGpCxCgBformox9tyTH2gPalK5xM2i+0mGE08pGzDXd
         IJYBhVpwvgH2saHqe2cvXaFV52Fp3Ur38xuyEZplcP3zJiy+MEqU3y2YUC+wYpN3dhb4
         ZjZTqRTVBhCK2+Dyjmon64hr5+6DyzFLx6RhOfRK6aFE4hpRD7XVfURiMjmzP2DnsyTn
         3i2jFpjGpj3vhtnKGnw62BkQ8u/rYBLQVlnUA5Ygvlhfn3OlhNi5WwaiNTNtj9IfK2mn
         Cbr6IB/ZhuVTDiHCydgLDWEIEkEEulafppqjQdgqotINb7vevKwlqzGOH6kITDXVQoGY
         bZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732273606; x=1732878406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6ktoHeGKmXYIdsUvMRAz3vVzbrdPr/EI44OUns8qrUY=;
        b=E/0STFsJ8TZ25eYKO1YYoVr3cThaIrGYnuLI7ctg2G6RQ1uaMjN75H39/yxu0OS8HL
         UFFeAZzMppHRWBi9/m74V63yvBvoHeUNz8n4E6oCeYyFIMqVPKMh+UWrouIPuMzvhwlU
         6UKf8NC0VDvETsd9ngy00NEOYXJF1nYPcIi53JUtSDk6sjcq+Ad4CnyCyvg9860AXv3Z
         iY/Hrd9kZ8wc/2mf7RqXTMQWBpQUnx0xjoOxlyL0h/SngVz29LC4nL50oJe0okaDtNf0
         6LYSR0PH9RkffRQXQjx34SBUK122nn64kY85Vo0KqkX63G1QFPYcgPhU6EdoRSNc+WH3
         d9DA==
X-Gm-Message-State: AOJu0YxHhsMoFu1MDAONybrJx0e/0drFlE0LPBLRVsg+ykMDkUAPdrvl
	32h/MxF0zi52dBaQk6ZBOylYTs8ulATXBB7zc2CwCe/FnsitIlQl9VxeQGBRWHOeR+WeTEw+J2K
	U5nIM7Kzshni5v6OJxcyJOF3/XMyhMC2LKaCwl2hzTq5yssjIWcS5iJhukEARk4Eo5LS/6X+PGL
	kP7ZQmMKT3ocd4V9UlxhW/gF3j7z4=
X-Google-Smtp-Source: AGHT+IHxlIibkga1iw7v2vPgOGsJTBx+OxZIvFAGu3eNw4H3FAZffNRHym6mWyxiSwY3urBtHDIw7EKv/w==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a5d:5712:0:b0:382:3c47:f377 with SMTP id
 ffacd0b85a97d-3826060f567mr890f8f.3.1732273605841; Fri, 22 Nov 2024 03:06:45
 -0800 (PST)
Date: Fri, 22 Nov 2024 11:06:19 +0000
In-Reply-To: <20241122110622.3010118-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241122110622.3010118-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241122110622.3010118-10-tabba@google.com>
Subject: [PATCH v2 09/12] KVM: arm64: Remove redundant setting of HCR_EL2 trap bit
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, tabba@google.com
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
2.47.0.371.ga323438b13-goog

