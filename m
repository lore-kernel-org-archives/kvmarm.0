Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03956426EAA
	for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 15:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779894165; cv=none; b=NDSv3DvFag9jQlUZhOjjf5k/e/tEluIGMH/1hvyVcvWR56z98/8yGE6kZ20GDlyc4YcZRvCodU/RdGvbvLz3IdaaasQDdQFQ+f58nPlviIc0BzfBVvFQdRYalIl5Of99EIh3rcpIKgUmfmcUEzfm+zFArRq89iEZ5pG28nS+2X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779894165; c=relaxed/simple;
	bh=SVvDiffb/nQ6NalN7qs94CnE2E+NZ1sLlPWERmt385M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t3cOHXw5iNOBxIaV48XOhFZtcq1WSQf8GMm/OlF86i1okb2TyL0haGahojpUwUo+ga44pprCvk8AU5UUjQixGeWLwugRbuGAbczI2nEZ3iIMcGMJrt5mXP8WmNO2NC21JL6SWWeycXHy2pxlh3hO0na8EPXjoaLF+Vbfq6W5Smw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F3kPsewF; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F3kPsewF"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49050c44bcdso56486075e9.3
        for <kvmarm@lists.linux.dev>; Wed, 27 May 2026 08:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779894161; x=1780498961; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=q7J1ztb6Z4HCTvPSQ3KlFjIJDDk9HF6V81J85Mqd8VE=;
        b=F3kPsewF8scudpa+qTWRLTeA0jqywhSHy/Zk5rWpWwxf/ZBBa7IeFR2epnv/ceFI4E
         8LAwgwDcxeILuIELQohOUayt5DgePs44EJ1JGw5ElZpyHXE6YQSk/hgaQ2Er7h4Gh25D
         IaE6/YeNJOuipmudB22jkctS4pR30mX3Ylh+yljmMC9A0YpdmBsoCzb3JZdKGM3fD6dw
         Xoyfvl3LJrAwdzjkzlGj//jUkct67NdzpgMLpFO+r/8t30cSClq9t7SYZYyRrrAvGTKd
         KzFHjtKJ3cQuae4K6NyRXA2c6V1gYqr88qp5CbRx6Hg8hrY5F6chc8ScojtsJNxcg/8r
         h+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779894161; x=1780498961;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q7J1ztb6Z4HCTvPSQ3KlFjIJDDk9HF6V81J85Mqd8VE=;
        b=CtoleQg0u9bIIAC37oEdn7XEru9MtHPDxBrk8ECEhn9Z5hSSfAMNjSLrOk8np8OI2/
         Ah0G3+uQ4u2M1xs6ZC3mPmqVprGzZ176Br6xmNGZGKR+YlxSsqx9ar/e88Zc9dhIK+Bf
         4P3vcRRYVKlmJUGpLgtWUKaY62ORYM3nwZRGP8tREvURxUQ77mfAzoqbOYVCAlGlfPQ0
         gEktAr8bNzlgiXu8xwMP8ao1xQejvysX/ojMkDLG5IQW08wjn1SPWwWIRKytR2bosZx0
         sXw1RwbgW4FU3sxRx2fkB5XKyUckMXopmz6kycqLnI8nYqYYwG9kuYE3zReg4hSmRZwG
         qT0g==
X-Forwarded-Encrypted: i=1; AFNElJ/mma9h/fxfXPY4od3naX3LwYrUhsfSAZhrzeq++kd8s72zHGxG3Butqb2pnpobPjNN83qH48U=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywsc4N8L0C/ZQD9FVsUCeg6hid+HCyNmevj3LoM7/natlpAjgup
	dj6BkKO3lcQHDLZCYmd4LJG+ZSyn+QjUTO5ml/ri8UQyEjH3iDqFGd5zmEVNCbdsD5HJ5aE8Bdy
	z7IvT0a2FxPsv2Q==
X-Received: from wrrj16.prod.google.com ([2002:adf:ff90:0:b0:43d:2d2:c03b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:530c:b0:490:5527:3be2 with SMTP id 5b1f17b1804b1-49055273be6mr302305885e9.32.1779894161027;
 Wed, 27 May 2026 08:02:41 -0700 (PDT)
Date: Wed, 27 May 2026 15:02:31 +0000
In-Reply-To: <20260527150236.1978655-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260527150236.1978655-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260527150236.1978655-2-smostafa@google.com>
Subject: [PATCH v6 1/6] optee: ffa: Add NULL check in optee_ffa_lend_protmem
From: Mostafa Saleh <smostafa@google.com>
To: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, catalin.marinas@arm.com, jens.wiklander@linaro.org, 
	sumit.garg@kernel.org, sebastianene@google.com, vdonnefort@google.com, 
	sudeep.holla@kernel.org, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Sashiko (locally) reports a possible null dereference under memory
pressure due to the lack of validation of the allocated pointer.

Fix that by adding the missing check.

Fixes: 2b78d79cdf96 ("optee: FF-A: dynamic protected memory allocation")
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/tee/optee/ffa_abi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index b4372fa268d0..633715b98625 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -698,6 +698,9 @@ static int optee_ffa_lend_protmem(struct optee *optee, struct tee_shm *protmem,
 	int rc;
 
 	mem_attr = kzalloc_objs(*mem_attr, ma_count);
+	if (!mem_attr)
+		return -ENOMEM;
+
 	for (n = 0; n < ma_count; n++) {
 		mem_attr[n].receiver = mem_attrs[n] & U16_MAX;
 		mem_attr[n].attrs = mem_attrs[n] >> 16;
-- 
2.54.0.746.g67dd491aae-goog

