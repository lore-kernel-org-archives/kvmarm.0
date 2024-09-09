Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526431B9B2A
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725887324; cv=none; b=aaIzNr7Md2dxIv8TDrt3o+q+W59806bJE24YYn20yPPmw69IiKlXH+EPZ9jRlsadca0ckY+biKiDjd9JMX9A6HhbRBUHnDDrG32FbPIc2Wf8bAJah84NB4crMyo1EeaQ/YR2IUsP+F6vLSuppKmbNtiwW2Mmyim6LwYbqWlXIVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725887324; c=relaxed/simple;
	bh=VimrJNUrhgwuXOUZQj8K1x4oJhjSufEAbZfaXLz2Bbs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=G+PU1HEIl3kO4pjlXpugf4EGYyQ2jCxxFpMkPri8ZGZbYAyccdE8g7j56FSao7eSLDb9G5ZoGdch5mcmPIt6lANGb/X/2RR+Fla0Rv9wTaeM4SeNQk0Qty74pbO223pKvtlhI1Og6N1rx09sUsraz5AMTWa8A7V5/kMo3xOAAMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a8y/pfrw; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a8y/pfrw"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1a7fd2eb36so8881202276.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 06:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725887322; x=1726492122; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gkcR1LQPE4FCQJPuyJ1psNJiBytHsKUOZJ03Mjoli6E=;
        b=a8y/pfrw3yP++LBJw/UMnFhzz4XRq/9ogsA3fKVosE/1GGyPNALzPGRaN1xNMOqAXF
         yJPalrTy24uKzBBQjw/YM1bENmAYYarsLVH8GG4qIwdD7NoVZ1gwfKiT2e/rsqLssWd2
         CeZJTJIYsiVv48hoh3Z44hhNe5XX1bmt4sexjkRMqDQpcTcAp7qOshY9je1HrR9RyqxF
         KlzvG1tSHg+DSBbac7Vf0hguR1TLoFdUykeP49R5aJpLWgDYI5B45IauQ9rt6pKchQPu
         0RStW7PI+KH5s6cKWyGd1REyhN5Z1CsPyQNCNYPDMrIOTeAy3QqYgh0glqBKYTs30nSk
         w8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725887322; x=1726492122;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gkcR1LQPE4FCQJPuyJ1psNJiBytHsKUOZJ03Mjoli6E=;
        b=P+VZXG9tZ6rFc5fqmqFv+CwcayCHZdZEt8UsKBw9hHP367zYYWqH5NVYZadpLqlJpx
         aquZrZdqsus9pJvZAPRlKeVTX8WSSphzy9oafg1nLiCXC2SXUbdELkpzat9qb6vWWaOh
         mirJYgOJr9nJ1vFGq0fEpvUb7phm+konqF69nAirEWQob7MBJ+xGBA8oCXYGMW2g4P3t
         AU9ljUtm8xKj3GFSASfO+rNqmZZX+Na/wmYgCTVK6BeskosnJRslPyQooA8D8o9H2du3
         KT+tb0ui2oNaV5Ss1ayt4TbmUeQtWVhexpLXX52rU7RUwf8jzBXp6szPTN+D7Bgfgr/r
         yZEQ==
X-Forwarded-Encrypted: i=1; AJvYcCX7vEgVBSxV6G4to3iOGrcjRs/nSPY5qb7UTXQiwM1VAJj4AQQ/NsWwjrO8i37iKkr5bNBfgdc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwFA3gvDcxdGqkgfTNrctc6rwjC+gx9VoM9DNs05UomtiU2WCPD
	5Ah0WzEGbAyI4PQSeYVIQ1lEX8BdGyAIUHdMihKLGH62JTKaEWH/ipJjnn0wxQfxADyaGJBihHe
	r4QP+4/zxlHJ+E/Sk0fekOg==
X-Google-Smtp-Source: AGHT+IHZHeeJzJA+rBQ2ukVV7/hhG+otbYJ/RCdAhQjZtiHGvPzEoizdzLQoCYDilJms56oKXlfXRy7wmQN6XoFmtg==
X-Received: from snehalreddy-1.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:c1f])
 (user=snehalreddy job=sendgmr) by 2002:a05:6902:4d1:b0:e0b:cce3:45c7 with
 SMTP id 3f1490d57ef6-e1d349e38d5mr19825276.9.1725887322131; Mon, 09 Sep 2024
 06:08:42 -0700 (PDT)
Date: Mon,  9 Sep 2024 13:08:32 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240909130832.1203849-1-snehalreddy@google.com>
Subject: [PATCH v2] KVM: arm64: Add memory length checks and remove inline in do_ffa_mem_xfer
From: Snehal Koukuntla <snehalreddy@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Sebastian Ene <sebastianene@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Snehal <snehalreddy@google.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Check size during allocation to fix discrepancy in memory reclaim path.
Currently only happens during memory reclaim, inconsistent with mem_xfer
Also  do_ffa_mem_xfer() does not need __always_inline

Signed-off-by: Snehal Koukuntla <snehalreddy@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index e715c157c2c4..637425f63fd1 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -426,7 +426,7 @@ static void do_ffa_mem_frag_tx(struct arm_smccc_res *res,
 	return;
 }
 
-static __always_inline void do_ffa_mem_xfer(const u64 func_id,
+static void do_ffa_mem_xfer(const u64 func_id,
 					    struct arm_smccc_res *res,
 					    struct kvm_cpu_context *ctxt)
 {
@@ -461,6 +461,11 @@ static __always_inline void do_ffa_mem_xfer(const u64 func_id,
 		goto out_unlock;
 	}
 
+	if (len > ffa_desc_buf.len) {
+		ret = FFA_RET_NO_MEMORY;
+		goto out_unlock;
+	}
+
 	buf = hyp_buffers.tx;
 	memcpy(buf, host_buffers.tx, fraglen);
 
-- 
2.46.0.469.g59c65b2a67-goog

