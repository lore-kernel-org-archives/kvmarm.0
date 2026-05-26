Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D6B1A6800
	for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 15:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779808789; cv=none; b=F3IOIstAfpiHMjpMeVA29KVwA0Yd3UnQEyarhE8Ql3W0wxS7gt+9OrCCN1ndEVdAI7RrzvXdm6lbAH938mt61yVrIk+84c2PCXvcoAyHG0nsm+rk5St628ot6ZK/qWb2ljFRyAriFNpZ7EsdJP+CjJuJQJrPV9WmLQyze+PZETo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779808789; c=relaxed/simple;
	bh=pt0ml956E7763pNtpKBWBD6NZdNOiJbp6LvAL3RA/Qg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MiqvTuNOoh1Iz6YC+izqgrfJy03dAcgnheI/Uo6lbeN+xjAkFJn5EtYkb/01BQB13sL6cqEA0Xpb+xaV+8wMATajh1udawpy61XbSf731eO12JcsluRfkx2shl6yKGpe+T5p3FfQZ8rZVZLdNKBU0xEgSsYLk1EYmmcNDZTq3rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F0i5J3Pf; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F0i5J3Pf"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bd960997b8eso203900666b.0
        for <kvmarm@lists.linux.dev>; Tue, 26 May 2026 08:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779808786; x=1780413586; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JYSPuJSk3QuKc7sf14ipiOObeqdt7tBHKRBi5y5X6HQ=;
        b=F0i5J3PfeRZWMiMLxK2BlOSlnovwgiFTfAufkH5UL7QjfccML9kInTBgDcbJ7dGUe0
         uGZPjuzH7R5NhxswiudYxd+w/VDXc8SFO0J8yN2v/dPomq5UKo7oRCPw8C4syBCMdHzs
         HF0OnY+yZyAf5Vv2LOL/8JVQ0pPy4/Gr5o6Armx60WssodYbR027EIn5VAVY2n3giFXa
         IIqotA8zPOiM/DemSqSjj7A3LudG9NGRxplpPGvn72WyIPzuWgHGnagkhoJV5TN8aZBn
         mFrKkxVNe7iDIqEzn2c0O9iBCux7LBO+d/z/9oaUa0mFknVcDruBunIacHoUwADvpcHx
         qvug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779808786; x=1780413586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JYSPuJSk3QuKc7sf14ipiOObeqdt7tBHKRBi5y5X6HQ=;
        b=hPl0Ma9YcJnuH0s4qxGmL0UrNvosDPQhnwVd/Nb7GwzvhBrNfJ654J9jdkazT/85Af
         kC2aifOJgvLAT7GwPrKc4YJY/YVJXJwj0J6K4u0M+arnjb5dnRSTBhqMlwO2EPK7sulF
         lKHPigPP5bMMSO4lVI/NCfEwNBv2YB/MRuRvhgL72TcfdoCTaPrb1UI+beI7z+uyUASY
         TA3tlGQmA2rZRrAIKuA0+GAjlaBtmufjBto1Qsa5zT4b2hjV7YaVNf4wLr/E1FAE+nkZ
         Wr37+tVd/hLTkOqxMXPa3Dknps8dIJOXXYXu/yyJb3JoZ+g0aRx1+cIDAo+fMgZh/AVU
         ww8g==
X-Forwarded-Encrypted: i=1; AFNElJ+UYtXcsumdGifx37H3/PGkeMwDxe++mYUmIdlIo6UX3MteIJdiJrnWAyqp1jV3GjaHg9pOcnY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzp3V2JxjZCEtSnCxBPBTs9Jq9NW1rhZLVhBC38mYzEG0P29jV3
	g8UXhjoStYYLxyKCtLN2KFbq6weo3OhzQ7FXfRSgmvigBzqxz4JwLZB3+2RlJ9wv9NrnAj9kMK8
	mY0mzlEf0ZOom+w==
X-Received: from ejki2.prod.google.com ([2002:a17:906:71c2:b0:bb7:b0ba:e7e2])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3f1b:b0:bd3:6ec5:f141 with SMTP id a640c23a62f3a-bdd25ce1b65mr1107073466b.30.1779808785644;
 Tue, 26 May 2026 08:19:45 -0700 (PDT)
Date: Tue, 26 May 2026 15:19:29 +0000
In-Reply-To: <20260526151934.3783707-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260526151934.3783707-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260526151934.3783707-2-smostafa@google.com>
Subject: [PATCH v5 1/6] optee: ffa: Add NULL check in optee_ffa_lend_protmem
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
2.54.0.746.g67dd491aae-goog

