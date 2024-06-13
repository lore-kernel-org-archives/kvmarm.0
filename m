Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B840144D11
	for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 13:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718284862; cv=none; b=htHJFcuR9Gft5EPZqiYkpJML87tXX+Mv7GvlF9QGQ5yP7RQ5r22SQC3ZlwiphbSQh8OLDhhSo6+cWqwYJFCdhOcY9n7Xq7MDB/tOQkRe22oyb73vyOi/vvyqy6mbsVO2qdYJh2JFNC9QGOw/yu1GYoYnUKgZe2ve9t0KNqPde5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718284862; c=relaxed/simple;
	bh=zFmo670I0tiDu31Oc+yMgEHTb7RV2is956ciDFrAEIk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iuyjsCqQ8o8dO/jzohKWGbT27veMIRfQC/DqBgW5xERlKw/QBUpYkz8inU8GfWx5aE54YEjRd+1S1asnXoZOolu/8Mb61luybjSVJl+T9zKa0B0Ei4233hUz7xHFH9R8ar49STa9CiX7PGLAaptjCIs2+Q70TiJFHZ9Ca0LhjrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cQrMpI3A; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cQrMpI3A"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6311e0f4db4so11623017b3.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Jun 2024 06:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718284860; x=1718889660; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u0OhOvlObTYcevtXo8Z7p/mIFsLXq1uqkU+zyx3S4LA=;
        b=cQrMpI3AAPuCVp2UgXbS0zCfjGMRdPpHSDodvFMQZdt4qM7S/OBJDjlWLKv6lpBBLr
         k4lcDpPAGS8xbuBHuAs6lbWFaxpqimOWT7FlNHeXr0LCNVMBzWTSo7dL2JQWsKe2fvzN
         yNWghJ8zjew/BzHSRdY9jmPI3M9M3kDJ8/Pp7odkcUZz2CvauMBYRHrHY3GaGc8y5Og7
         bl0N1k7GNDSI5tXn/ZP7ak0lRm/Xf8sGQf9y5ldgFXLL5ouXGo0eOMBO3vnXgSd6ouyx
         KPwkZhiWW+SzJLdSUnGYwyXAPLigklM78dYB3fx4i612CwLcGoiAh1z2TcWGsTxpbhKc
         gy1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718284860; x=1718889660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u0OhOvlObTYcevtXo8Z7p/mIFsLXq1uqkU+zyx3S4LA=;
        b=WKFMyO96jdTpb3R4NaB2Mwl5Ayh3EUg0H7UQhOkEumQIbxaVKpoDR1jApwgBeTmcST
         +RUipMfjmFO4GfJKI+sdB36XFeDe/K9am4pSbLeEIIlzfj7VaDnVqgcqa2TTQlglbLPE
         9tvy3VwXfJtcJ5gGm/Onf8UDT5xk0VLRf6fl7qCymOaVUgJ1tZX5oJdievwXntsRWWu6
         SKyU2qTpQru0HmGiDsrzWxCIVIC2tEWFPLEitXdICyOqiZuCkfHQV60BVBKhDa0HAKzK
         Sps7US0+96wswcHxD2SzJhJvh5zVnAYZfsKPx/R2guoysZkMui5F0zM9hYYQYynip/vl
         FZjA==
X-Gm-Message-State: AOJu0YxSl5wGeoPyD8kqApqV4keQXTMVdNL2CNYgJaCEoh3YN05YXgIn
	xb2fHX2kuKL7y/MPbKJN0rT/elPmVBZNyaRvyJUWLFuErJ8Thy4zwDXnowo6lKIssJlonBKzVBQ
	yxdII65xCJD8ys7b1grvOfgYGrQ==
X-Google-Smtp-Source: AGHT+IFmR5E42s+BCdl2zDYX/0jaaUeTAn+ERNofvz51IQhPRv6eG1U8A9CWU+hty3Xq9QgQmwvTlYwuQ2lHK/2XOVM=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a05:6902:723:b0:dff:ee8:14d6 with
 SMTP id 3f1490d57ef6-dff0ee81893mr156506276.10.1718284859883; Thu, 13 Jun
 2024 06:20:59 -0700 (PDT)
Date: Thu, 13 Jun 2024 13:20:34 +0000
In-Reply-To: <20240613132035.1070360-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240613132035.1070360-1-sebastianene@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240613132035.1070360-4-sebastianene@google.com>
Subject: [PATCH v3 3/4] KVM: arm64: Update the identification range for the
 FF-A smcs
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

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
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
2.45.2.505.gda0bf45e8d-goog

