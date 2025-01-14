Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEE28615A
	for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 14:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736866268; cv=none; b=TkpDZ1PJorczfq1RnHNK//RMhLkVTGYtNM6KC3OIBRFTqikPwZ6PzXY6l8cfTn2Ehs1pOODGadBGrOofNSTYzWGTCqcRsmcnx58pt8Ua4wXfmY4o89xpgHSe28ReLo4XQpl0ccTbs9nDVyuW9c8uBnk2YMb3wBuQGmx3+R34d5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736866268; c=relaxed/simple;
	bh=FncsAYkcJF/nMHqGnW/3nMpMk2ByWsCClyouYgkRPcM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Content-Type; b=hqk+/uPsD1kzc2C1D12qfLPeFMPillUsJZIr+09X1CP7axOIWfmDGqhz5ir8hKWKKOBeolpPbS6sWjsnsHhwVNPXt2ZYHlKRjtciGCD4AL3mcd0ZAeF6tNkhXJglY2NlrJvbnZELz5jLJOOGy30llWrZKn8Fm0X3Etq2rlclxtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=liJnYOX4; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="liJnYOX4"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-436289a570eso19216885e9.0
        for <kvmarm@lists.linux.dev>; Tue, 14 Jan 2025 06:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736866265; x=1737471065; darn=lists.linux.dev;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0eTIIfStQ+7VgOiC8tdc+ucwS1WrBZu33tceKYHTFlo=;
        b=liJnYOX4gnzwb9EHgrl6kpDzPfqEw3bSoZPkLY4vCJwzItyMs8s9q+gNGOgO5J9/jJ
         ALc4MouOqF6VoSHxJwUJtuO0hw0ltD9+NTChlIPxR7nNkH8hnlshfb4HUj8S5gLLCMhH
         NxSKMcMUW++PhD0K5ZTo6Dzz3lNL0j8kfGm/h6pS+8fImk7F250wt7qu6lO2eV9Xgkhg
         yc03ELuBwrCgtQ7m1nh5q+PxPUATBo8TMkR0W2bzKgIhUcV1MmJV4a5XZCsbjHUp3Cmx
         tMu+rX3TrzCvYTM6qy+e6pHtCOXAWm5s4g0tGjmpVgzqyLnSl5DhpROJcimkC8h12nPE
         q9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736866265; x=1737471065;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0eTIIfStQ+7VgOiC8tdc+ucwS1WrBZu33tceKYHTFlo=;
        b=qT6AG4bWTMZux8EtdY3pCe9zJj3aOyT0K0NgNzuZ0Zj+jCVWKR2sVL2ckQqq+HuAqF
         AnBK+xx0e3Z/fp1LREKysChfPOUncJP6jEfsblHEPB3P1BkQsT634HdGnlx0DA4ozsCZ
         3xdUnGYW4UpX+wCsNKVuJGoC+Ncl3mifp+TD4lvjJWbjM2vdzkvEL99ypwECg9BaXIYT
         rwl2TI2K4X5yETiAzNhQyB26c9IsIEpCeLyKe1RCA/evwDWy9IQk50ZeINtOqdToYXPr
         ogmZbsqZOpetCBE9P59yqfTI6rq+ZqDtrY8CQ4IZSeqOO1UT/Y3lJY3ZJ8ITmckya8R0
         gaRw==
X-Forwarded-Encrypted: i=1; AJvYcCUf0KyvBWnAT3sKHqa+2QTw+nvluBs/c7q5cGBTVjmOccjge8smc1rwUEISjQLiMRR6WJwUuuw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVFP1RiVz9ePmmSJWup5ZsAR2xhO8pOw3bKj/Qz5lXcRB1fcJ2
	PCekLHpiOewaESrCgZU/FzT9ubqa7fcNCzqr4PkET14JnttqfWhh0biTQC0mv91JzHKbe1jUGd4
	A+qskh4vc9sxQ6cICYvdP5wY/bA==
X-Google-Smtp-Source: AGHT+IHHxF6PgjGCqVXzpxA4AjixYi8BbG8haFoZBwrYz/9M9zFcbsfYBWQrtZ6low6sVY/sgvFdwRItNXxCPl5Z6Pk=
X-Received: from wmbfp16.prod.google.com ([2002:a05:600c:6990:b0:434:fc6f:e8c3])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f4e:b0:436:1ac2:1acf with SMTP id 5b1f17b1804b1-436e26e28cemr219984475e9.20.1736866265825;
 Tue, 14 Jan 2025 06:51:05 -0800 (PST)
Date: Tue, 14 Jan 2025 14:50:51 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.688.g23fc6f90ad-goog
Message-ID: <20250114145050.563658-2-sebastianene@google.com>
Subject: [PATCH] KVM: arm64: Fix the upper limit of the walker range
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, joey.gouly@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, oliver.upton@linux.dev, sebastianene@google.com, 
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Prevent the walker from running into weeds when walking an
entire address range.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 40bd55966..2ffb5571e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -260,7 +260,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_da
 {
 	u32 idx;
 	int ret = 0;
-	u64 limit = BIT(pgt->ia_bits);
+	u64 limit = BIT(pgt->ia_bits) - 1;
 
 	if (data->addr > limit || data->end > limit)
 		return -ERANGE;
-- 
2.47.1.688.g23fc6f90ad-goog

