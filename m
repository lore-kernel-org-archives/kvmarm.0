Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A358171E5D
	for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 16:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713457911; cv=none; b=Vgb4WZu7nTPy8m2EI+J/TUvVPBlLMVsx73BiJuM//3fXwaYmcEA2gtPd9QR9WTNPVwzww17me1/Ge84I5/Ehl0feQqjl6/4qi94B5aUh7vbtGtSDSPPca8T4P2txHvj9PTgefLysirfRv99TP4ltgz6c6pqoLJU5jZ/m/34FvSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713457911; c=relaxed/simple;
	bh=reTusRmlKdivguaCRBJs9NeNASz4hK8OyNTz/hTvqXQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QrZW+4Bu2Bra/RRF5gNH8hxsdAcoC8BXic5n8bUzwqGUtNPiTrjMXRdKI07unQvTuR/Sai4XiF7+W9Awa74narzLH4G+CB8MviG5WnjvAF1dDKvNZHNCVt+DBaKf0wIQSprwZplLFIKSoH9VLdOBX8HsorPdxXBZ3RaAdd7QEMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fkSYX0wR; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fkSYX0wR"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61b1200cc92so20272087b3.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 09:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713457909; x=1714062709; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JYz/Mm7XL97gcC37XQSh6FT+KtzHg82q93nX3l947mY=;
        b=fkSYX0wR3bplw+sUpm8j9v0Rr5i9A5ilcnS92dbuYmsVozi3rztVBEAfkbg7Q91YUH
         u/mejfiN4BL8OMdPpi1ml5INBaDx2BUD4dwa3uGRPWl8miNjG6YjB8sGm4ws1/Oxxc6L
         R11Vj9UrCk05mUR3Y5b2dT2xQwGv6E1Rm7V6BdpUE8dU9m6HpEDaTtvKugtbML3MW0C5
         /0QXDnRboa/IX+OkKrJjMvPK/BAmzHXMQ2kfGHu79yZTyFu4LsmWDps36Y5lvGJ5WltV
         1OogW6DChgO9z1E6kYKh3IP7Qy3OuF9zs5qP2/ASJpvplbvxAfF4MtzFhSP7WGDFllB2
         5kKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713457909; x=1714062709;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JYz/Mm7XL97gcC37XQSh6FT+KtzHg82q93nX3l947mY=;
        b=O2vQ3JQRoosoVNQnh+Sb1oyUGuGoqqkcBY4CdkUmijL8iiekbkyMfpuB8SKFXN8hgo
         uO169pBjhMl/VxGTYQkjETk0bxak3SGgjtmwR2CGu/lNfrCO76Opi2anB/a+owYLdYZH
         CYNdYOtF5HA/cO8ppctQmDtIfZiMBM5HksGWGJ4bGhoMJfbf7bmFr76WKOSTP0RZvzQt
         ShTCOduYa5CthttmmWD4SdYGexpx7/D9NHxDMHX/xKo/ljKeJxwc3yD6HPJJ6OFJzDJF
         Qpoll02MqNEPlZcOUF6Oex22kvp4u9m8iEHYuQmmxNyvsrEIjP/5NXO5oOS3P/ldhI6S
         840w==
X-Gm-Message-State: AOJu0YzEHezzDI5/5qRLozR98/vJHdqfP2MPInqqcz1ZfwdJJvgRUnmO
	OJvKpWdEPsYk+ahnn5Thpn7LBGA1jXD+NTAAaxCJCRpMKLUXopnZW+HeWfsXkOnFIiSAa5MI40g
	q1jEr3GY2fHSjezjcQZucmysM2w==
X-Google-Smtp-Source: AGHT+IGRr7uB8dyL1qZY2tNdLCo6bCgG9f2Ylok0Sq5MdDUUM2WXBpExMqrkM6rHCoVTKgjGEzcyP05psJEyfeFP8OM=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:2b08:b0:dda:c59c:3953 with
 SMTP id fi8-20020a0569022b0800b00ddac59c3953mr882660ybb.0.1713457909290; Thu,
 18 Apr 2024 09:31:49 -0700 (PDT)
Date: Thu, 18 Apr 2024 16:30:25 +0000
In-Reply-To: <20240418163025.1193763-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240418163025.1193763-2-sebastianene@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240418163025.1193763-5-sebastianene@google.com>
Subject: [PATCH 3/4] KVM: arm64: Fix the identification range for the FF-A smcs
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com, 
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com, 
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com, 
	lpieralisi@kernel.org
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Sebastian Ene <sebastianene@google.com>
Content-Type: text/plain; charset="UTF-8"

The FF-A spec 1.2 reserves the following ranges for identifying FF-A
calls:
0x84000060-0x840000FF: FF-A 32-bit calls
0xC4000060-0xC40000FF: FF-A 64-bit calls.

Use the range identification according to the spec and allow calls that
are currently out of the range(eg. FFA_MSG_SEND_DIRECT_REQ2) to be
identified correctly.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/ffa.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/ffa.h b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
index d9fd5e6c7d3c..146e0aebfa1c 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/ffa.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/ffa.h
@@ -9,7 +9,7 @@
 #include <asm/kvm_host.h>
 
 #define FFA_MIN_FUNC_NUM 0x60
-#define FFA_MAX_FUNC_NUM 0x7F
+#define FFA_MAX_FUNC_NUM 0xFF
 
 int hyp_ffa_init(void *pages);
 bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id);
-- 
2.44.0.769.g3c40516874-goog

