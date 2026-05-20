Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B76D36F421
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 20:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779310196; cv=none; b=JOD2S+f6lPW8tSp98R3hBQjSYfV3jVE0ToYn+GskUAAxSIArfib7K0+m2w7usKsMHeY5OPQ+whV+Dp4je/cRF4eK4myKpSJpAXdr7MstJPlgl+uLz2lV2O8giuCA0e5vF4AZ5e6oCLeZB3gGkTw5mOpXTeYy7rkt+yDLFwHUQEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779310196; c=relaxed/simple;
	bh=9CAsfM7KLu52yrdWqJdHkcolcfG9V6vCGTohj393onM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fgzv7XXGNuZ94X7iJxYlu/xqNPAJooR0hW6xOWqetdu7K6DeitA35UwMqamCvKCIbb1rJx5JFQsa3xZG1Eg7sw5d/U+xwKfUCVnNkcApUhSrbN7cw18knkgA7EN6l3XYDzmIpQ+DKXPnGipTdE1pNXGIWDsa+xK+T0iikdnwOzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hF5uYeiV; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hF5uYeiV"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fea6292a5so24799735e9.1
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 13:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779310194; x=1779914994; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mkaEL0dtEh5vLkhnum12HiGQZEgLNqcEhlclJBj/jfs=;
        b=hF5uYeiVF6b4Z60j5ubbZXIi1K13qym5hpqYO8a2wEcv/YYeBleDVh44cRpqWGihNx
         6dv9Hcr8qDBWtQxysTyJX7Uce/8XILWdMbT12eCqBN9zHCHg5FjpH6Ul0Q361aW1Vet6
         c4bGGZt7jl+95KK6DGFciEpEkt6qvkq4+FTo/O5H2ofHpeYcO9RBwBuQ4pPfmV6kEedE
         DBUSbv4T0mlQUxn2ozhr0MFiHNr38HFZrp+R5ufrGDph+X9g4wmN6tCYA8xlOrQKmR0e
         2As9h+eXR1kuSUrU31uxq8jCHkOEwaD10TKdKOMwBy7VydcpZkbSF0ETC+Qqr3M45NBW
         wLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310194; x=1779914994;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mkaEL0dtEh5vLkhnum12HiGQZEgLNqcEhlclJBj/jfs=;
        b=dvDqYL7PMB8paW/LrltaCCrvAZ/yntJ2aWSJb+TlZRhu6+AvqOTybgSAfrXMRznPT6
         bMR+73sUjj97cqb6xAzG2t7o+jEc+xiG0Hts/2E9V8NOEU6FQQx+M362n9erOaNPRcHz
         isCYGaF4H8e8j5YekN9yaqpKIJiH05rDoYe3MUXUsreanJTDg9mfJXmXGu8FxayOkNGW
         wJbrT/58n7j3L2sTLS1R7BO5KzNg7j3L2xfCHWR+K1ShmsSoaMfxDOQCAlShhK/y1ax0
         gFPd7VIpANpsLtswOtUF2zCi/NSUPocwKO3ADiqj23TxehUqPuKHRnEaiL4OBlIqm3DM
         tF1Q==
X-Forwarded-Encrypted: i=1; AFNElJ9MzNqIU6vbDKeXV/imNxo2+88KZy18Ag4dlKDleKc328Mrz+9CQQl+soEhbzSgJ8l6AH0NPH4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzw+aPX4JIq1CV96ZmF1a6jbbj8WCRVFi7mw+wCcN+EGW5FTtbL
	42/CJvJpNl3skPFGolIkssAbGjr50EZLv0aL18ANC2E/RnenOFtfCzwRnaq6fD750NFMHVjG9FF
	XHMKme7gmnBHHjA==
X-Received: from wmoj17.prod.google.com ([2002:a05:600c:4851:b0:488:af7f:772a])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a00f:b0:48a:5301:bb5c with SMTP id 5b1f17b1804b1-48fe63263dfmr421319785e9.16.1779310193872;
 Wed, 20 May 2026 13:49:53 -0700 (PDT)
Date: Wed, 20 May 2026 20:49:44 +0000
In-Reply-To: <20260520204948.2440882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520204948.2440882-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.669.g59709faab0-goog
Message-ID: <20260520204948.2440882-2-smostafa@google.com>
Subject: [PATCH v4 1/5] optee: ffa: Add NULL check in optee_ffa_lend_protmem
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
2.54.0.669.g59709faab0-goog

