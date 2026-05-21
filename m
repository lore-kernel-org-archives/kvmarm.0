Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562E23CBE97
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 12:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779367586; cv=none; b=PJ4NCAy0c1X2cyllD4/H7rwPGQneVPT2Qwzoe+5fy5eeUgc8E6cy/do2VbKMC97myQyzKY/N7nbJUsAcrUq9McV7R7vNm3rQ8cIC1Dk9QTGhn7T+G2+uyR0fBx7dgUQqC+eNPLCklAUk3c3zbc0nH5YjyzYWCCVnH74Nfb4mSC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779367586; c=relaxed/simple;
	bh=72OjoMYoSGyE5YQl1vS8ZCpWBEThpbC9H0SDe/hovyA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=DBa8q3i5AjyU+u+8HHMpsAeaD60/LvDXviZIEhnmbkW5+y3LI1syu8qf57W7EZrLfc03bJL2AGO0il9L9/jyEGCbWAwRxvA59xfwyupjsV2oLdHSoxZMrJUCllzp4Ov6crwSlPOQFcn9PRYhfDZKIIWU4xYvF/btjvBiVty2ts0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MHxqNAMx; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MHxqNAMx"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-45ea38c03a1so791346f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 05:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779367583; x=1779972383; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8dAyTyPo3nTRS15e/8c3XFjXBigAbf2Uv2kjO9O9SdQ=;
        b=MHxqNAMxLTEa6MXvDwhNNdYD8O4Jjjsw7Vv4oQXSLjmWXZq41SjMgXCUU0tfycN/dL
         Q9pwYbb6wuIRHnL/Bl1NWBVpX07QCgIOlSFkUpjtxybpoyiwULWqqEUBqbSzjyXDVzUq
         EU48yZ98Os9EXUV/ayC3chnjMSOpugeh323QlzV8wyHQ/KuZ0X6i5+yFd0bPBOywUJes
         8UwiYhwg5LcZC8ak3MLqTftWmqMNc/cgl6F4bf9DBQmTdrRyMyvooqktkxNYw0vXUCE6
         gR2e+aAUTv//lPOCdXEtccxr3n9Yv7jbOvRg1FfgKpBV1J/N7I7x9bdUllLB8Df84NQI
         CZ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779367583; x=1779972383;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8dAyTyPo3nTRS15e/8c3XFjXBigAbf2Uv2kjO9O9SdQ=;
        b=Q6OvzFzxbGukVoHiBiWmXBBKFfUQsg9c9qLKy4vLiwrn7VZYShzTaVH7mAZRzKgoH9
         GcJbJIzxPu+mDtMcWm+UikKMD1QEPqUba0O5+i3QyUrljAadzT7/H6i3/Ua8h1iwLc6S
         Q030btOrdimrVZlG3ijZjZf2GuXQU23ilu9+NKsBwQdCZPsiNt/ZVQkfRM1bbCQz+hId
         aM8q2irwbvY5uQ11CpOAR3yCQ8vgEND2/Xe08GEBMgfPmdx597hmmYT2wFwjZ9ixyDNi
         D1YGVe/Y9b1xPU6Ah1mtQkBUL197YyIeRf4NcmmiVAfCv+LqWe/KRyEw5DcRJXobgw+b
         PGzQ==
X-Forwarded-Encrypted: i=1; AFNElJ8LL31HKGNap+2r75lo45U4Yo3Igz0HfAXPbz/Y6ySlU3ZVlVxrlQi0Sn1fmqPpn4FufShTqEM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCg1uO68xu3JAmat+0vzT1Tcsv1k9emdrX2jtfHQfIzz9p0bMy
	1iSJZhnvaxax338uu7PvIfr0/Au8JA1LzjfNBTaSEZ5wtiDN2GwU2MhWt27yyQN237hBMD72NdV
	ATMXzfMSjQVUJ1jHuVOjeYQ==
X-Received: from wrxk6.prod.google.com ([2002:a05:6000:46:b0:45e:6a13:51a1])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f09:0:b0:43d:1dfe:350a with SMTP id ffacd0b85a97d-45ea3ef2bccmr4337653f8f.22.1779367583503;
 Thu, 21 May 2026 05:46:23 -0700 (PDT)
Date: Thu, 21 May 2026 13:46:10 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521124613.911067-1-vdonnefort@google.com>
Subject: [PATCH v2 0/3] Fixes for hyp_trace.c
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

While reviewing my v1, Sashiko found a couple of issues with the error path and
more annoyingly a memory leak which I originally missed as the allocated
decriptor isn't tracked by kmemleak.

Changes since v2:
  
  - Fix rollback in hyp_trace_buffer_share_hyp()
  - Fix memory leak in hyp_trace_unload() 

v1 (https://lore.kernel.org/all/20260521090939.735108-1-vdonnefort@google.com/)

Vincent Donnefort (3):
  KVM: arm64: Fix meta-page unsharing in pKVM hyp tracing
  KVM: arm64: Fix rollback in hyp_trace_buffer_share_hyp()
  KVM: arm64: Fix memory leak in hyp_trace_unload()

 arch/arm64/kvm/hyp_trace.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
2.54.0.746.g67dd491aae-goog

