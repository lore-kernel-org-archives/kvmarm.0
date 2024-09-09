Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF25224F6
	for <kvmarm@lists.linux.dev>; Mon,  9 Sep 2024 18:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725904942; cv=none; b=uf+ZugEcSAsvKwY0oLKfhceOxk66mdJn1qMwDw08FyRpN8f/+1CbbbJOMkUeQZUilWCfEOg8GVjUoUfoxuEuRJNPrcob9oOiVTc0VnjtaEVVz8CExmLLzPdxkzsQfEy4bjmYIxU0NFxaH+maIUDKXesVdu8lSAXGEV4eePqmM8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725904942; c=relaxed/simple;
	bh=m/wGZi8BcTf1EOpqGRqnWjiKZB6QmIMK4V1d+BMQEsk=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=r3Mo5sI8K8Sfx0dVc5+VGxB/nKfMCmFUjqLYB45nCQB1zXXiuN3i0oORsl1xn4VUuizB3CLCNd0zrju7OIeEoKhwbM6Jf2pFG+STxqW1SVU+CAWHw1PBRSsVW0a7GX+PJbUFKrMVnd8BhGZqYNM1+EyI8xmrw7GFXlzRa0n0n98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I6EQpVrG; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--snehalreddy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I6EQpVrG"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e1d46cee0b0so4178581276.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Sep 2024 11:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725904939; x=1726509739; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4GzdOAnXsu8VayoX45huUrzJ6QMBoTAjQVvSrXaAbFE=;
        b=I6EQpVrGCizwdfpNjg0dyLmmvZxiAkmj2F38dWlxPpClzAynrJY1NI5Ryopx0BOKfn
         53VeYTXg4KwhXXkLM1buU9Q2qF0x1LAHXriINdfTpKL+pmIbhZLdtTQwN5pEYTUtLOhT
         41NTPZTnkkm8ahzTZcOJV404dT5qpkG5ovpHqWvuFMvO6vXRZCXuC5gY1p/PxU1I6v0n
         RmDvwNCBt/iBj3KW++Z6NBLglfS5r0Au3vQHstWPq/t1OKQ1ARK1jnif39BClJB04wwo
         x/csYwIKDVVqZcT9fhhr/gkgKU2ZYuzRougIkUaA+0aDWSNcp705jrJjsf5ukq8cjsnZ
         8gpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725904939; x=1726509739;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4GzdOAnXsu8VayoX45huUrzJ6QMBoTAjQVvSrXaAbFE=;
        b=J+Jd7fATtP5e0wzygJAk/2Ozh5oqmIBCHRAcZ87iqu2rrmFsQoLwL/fdWxvg3AGqw+
         hCafLl2riBxhuIQ6uTbAVoN1+XFTbiieucnKzZQLosRqAaj1YJ2No+3lNHtUupnV3k4e
         +lPuZ35kpcQCozL/9w4YE96rhgUk+LGC5e787e49maTrDDz+/6vdL4h4bsO4jKil8oMt
         BHvC/9xyJYho9bULxA5QUrqLYo6tHwIJnPhKiW7dpWctbUKRpY5xX1VvhlDQ8ti9hq8R
         4wKwZbM2ONqFJgDhmivSl3x0IPxvoXXtlLjq109OqNdW90e9XVRiZEV7V9uOO8Khj52s
         VAtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUweaEZNj/Kr7ieZppLm9uTVqWdy6hazre2+25mKiCBN5GtGwyC1dTIEocGCpGi5gDHX0eVzWg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzpV2eFxz89TZA7bkuRbJEaBW40YRsLOyeRMGRbyBJ6ehZrI8t0
	OuZiyzTxH2wpT3NgpdWw2zk4yhhfuJohRqmtYU8x1xHmSbXcGl91sAqwFv9cEJcyFm6rmIaT3oq
	SfDxE3gw8BDJMbcvMRLXnHQ==
X-Google-Smtp-Source: AGHT+IFAuTEL+1ahwEy/aM3fSi5ne7wxws+pnvSGN+IlqZz9OjmkUToSqSs13gvLLdON+5TO44ygwJ2bXIpXxfgvnA==
X-Received: from snehalreddy-1.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:c1f])
 (user=snehalreddy job=sendgmr) by 2002:a25:680b:0:b0:e0b:958a:3344 with SMTP
 id 3f1490d57ef6-e1d34a3abb7mr28584276.10.1725904939453; Mon, 09 Sep 2024
 11:02:19 -0700 (PDT)
Date: Mon,  9 Sep 2024 18:01:54 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
Message-ID: <20240909180154.3267939-1-snehalreddy@google.com>
Subject: [PATCH v3] KVM: arm64: Add memory length checks and remove inline in do_ffa_mem_xfer
From: Snehal Koukuntla <snehalreddy@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Sudeep Holla <sudeep.holla@arm.com>, 
	Sebastian Ene <sebastianene@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Snehal <snehalreddy@google.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When we share memory through FF-A and the description of the buffers
exceeds the size of the mapped buffer, the fragmentation API is used.
The fragmentation API allows specifying chunks of descriptors in subsequent
FF-A fragment calls and no upper limit has been established for this.
The entire memory region transferred is identified by a handle which can be
used to reclaim the transferred memory.
To be able to reclaim the memory, the description of the buffers has to fit
in the ffa_desc_buf.
Add a bounds check on the FF-A sharing path to prevent the memory reclaim
from failing.

Also do_ffa_mem_xfer() does not need __always_inline

Fixes: 634d90cf0ac65 ("KVM: arm64: Handle FFA_MEM_LEND calls from the host")
Cc: stable@vger.kernel.org
Reviewed-by: Sebastian Ene <sebastianene@google.com>
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
2.46.0.598.g6f2099f65c-goog

