Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AD514C5BF
	for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 13:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712843828; cv=none; b=doDLM6Rz9bzjQ8aHdLDT+OmdfBbcqyhfvtiL/J0y5IQlpiTPlhwJXC1dxFe0mTuLJrqhLKnBnht1bhBgCmIQJ52UBv++RLN8ZiB/HcdapO8MpWyWOEGyi1R2kChltyfA76AHQN7sQEwhrDlSoH8cmOSqxysR5MckQztyq+F+TBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712843828; c=relaxed/simple;
	bh=rj7jL0inBOSEZHgrBXiWcOt4NTfoLLf41Owd8e/QN1E=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=pIANlT4rBbhfe9mK/YSC+EdbJS+OGXiD15/bfQLGFtQqUJ305SLJAjFXU0kPnPr/8w/uR/zARbtK2nCYs4JXFN4ZcvyuYOCphmEfbjpkPAf6lWS5wxgs+Y4/m3+RYMw/fCb7CZKxQ1RekoRyYdjOFghaAk/+F6nUspAqXGu0uNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ITgBl0hh; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ITgBl0hh"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dd1395fd1bfso13483026276.0
        for <kvmarm@lists.linux.dev>; Thu, 11 Apr 2024 06:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712843826; x=1713448626; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D+EIh4GaKjBC89iq3H7JjSUXThXK2r+ggs0qQY84omw=;
        b=ITgBl0hhOU+PckV/W9+K7peAGGNNQLytFEsHX0lnhxYGmBrKoM08JjLDYHQdBrfp4z
         FCINy5dn4S2tiohgd+ZrxxkE8wIMzUKvexp6FW4fLX6A6r4YbAdO6MbkGdi33HnGKKbF
         y/PsIdRYjJwfJ7t0Eco7ORw7eIfUgU2fFRs6X2qPSrSuXQCn79v4y3GzF3TXx3dXlQrt
         m0b7d47NB5pfXN0CtPoggt13/GXtboKzQULDPivYfAQR4gKPLkZNgU5EXQwvvsqWdAqk
         BAsUA0zuZOtJgaBAm+50Si4ZvaOW7qRGhdHKGQDdZsoCQi/kYPdgsNcvunPKXR5LX8To
         hEdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712843826; x=1713448626;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D+EIh4GaKjBC89iq3H7JjSUXThXK2r+ggs0qQY84omw=;
        b=vh2USaeOGhofJBdSg6DvGFF1T582jp7MuuwFgBBqIPZ0Qya+aCGg9vusLuIkvFMGOp
         3OBjSpKZq/Ng3xcfc8j2bN09lyYucW8HmRYisHCYiB7MSSEkbLaNFocOPs80imFw6duI
         YXgk4Ime9b3NHdIsLEDrdBogHPWuRgQV3OtOIZa1aXWROmS8fyVbSsUoTWL22n7yZiJR
         pzJCHIuMpGlxSApUNrYaS5SsKorJ8fnobXsR2a687f3eJZxv7Xn6KsuAnbd1vmzkSJ9y
         mM622B85YY3yui9HA7F8P7IjY4HM9wsdSpxzLwxNfij4QuqZPu4renHJ5JVIGjSXUFWB
         F87w==
X-Gm-Message-State: AOJu0Yw3dRV0FV6TFbylL9Y4s01GQD9wsrSG0s1anY3jMqWfLyXppQt7
	elqwvgtcIsvg3Z8CMtPlI7G/Bmevb8V2aWKhTd/39iUivCNqZ/PtM6fPPWuB7nlCUZv96MnHcQO
	hxj/gHddyl8uAl95TWcmFeLH73Q==
X-Google-Smtp-Source: AGHT+IEwnm375fG2EIsGyufwb0TdVTVsW3fmGnrbbBqhe480E3BRr8U08k6owLTh9FqdJqCEg0fO34CuUpQr+Fmo7L0=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:2b83:b0:dd9:1db5:8348 with
 SMTP id fj3-20020a0569022b8300b00dd91db58348mr1560194ybb.8.1712843825763;
 Thu, 11 Apr 2024 06:57:05 -0700 (PDT)
Date: Thu, 11 Apr 2024 13:56:59 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240411135700.2140550-1-sebastianene@google.com>
Subject: [PATCH] KVM: arm64: Remove FFA_MSG_SEND_DIRECT_REQ from the denylist
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, james.morse@arm.com, maz@kernel.org, 
	oliver.upton@linux.dev, qperret@google.com, qwandor@google.com, 
	suzuki.poulose@arm.com, tabba@google.com, will@kernel.org, 
	yuzenghui@huawei.com, vdonnefort@google.com, lpieralisi@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

The denylist is blocking the 32 bit version of the call but is allowing
the 64 bit version of it. There is no reason for blocking only one of
them and the hypervisor should support these calls.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/ffa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
index 31ad740137fd..0df217bb2194 100644
--- a/arch/arm64/kvm/hyp/nvhe/ffa.c
+++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
@@ -601,7 +601,6 @@ static bool ffa_call_supported(u64 func_id)
 	case FFA_MSG_POLL:
 	case FFA_MSG_WAIT:
 	/* 32-bit variants of 64-bit calls */
-	case FFA_MSG_SEND_DIRECT_REQ:
 	case FFA_MSG_SEND_DIRECT_RESP:
 	case FFA_RXTX_MAP:
 	case FFA_MEM_DONATE:
-- 
2.44.0.478.gd926399ef9-goog

