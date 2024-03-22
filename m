Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F36B2770C
	for <kvmarm@lists.linux.dev>; Fri, 22 Mar 2024 12:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711111444; cv=none; b=ZKhO2GpSlNSTvMyKWBjDaY6sqGBavlSWD+YTzdMEFjAoyDnFjUIrD06si43THmAXQlqcIeoGXzpTBj2zCqDUC6ybxzzg6m0RmtTKoUNcT8frd2lR8rYzd85rhNxCYPdG5hhR960bXf2sc9ovdka2eUSJqQskGfK3rfIi2Kp2Bos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711111444; c=relaxed/simple;
	bh=TFLtWqVtnfY3Ny77IqrCP4FTbQMx8MGubLMvGhIpAOw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=MexFZ6NJWiMAc1ZWdU77CcqRmRBvs1IvuxiilyDSaLMT68pb0+RJPsVEBw//vaUOlNW3jeeKjJQ4UfUxslOkqDFkDSHUNx0pRO0XzsgeHThYU1NsworOfOFxMZGB/YG19o47LWrkfz/7ADXTCOhOHM1aU6SVE55aYA0lBVASdPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i7Rxr985; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i7Rxr985"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60ab69a9e6fso39481347b3.0
        for <kvmarm@lists.linux.dev>; Fri, 22 Mar 2024 05:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711111442; x=1711716242; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TBPzH8uDG5g28i+V0dmYxrEXrjob8o+00KlgZjV6q1c=;
        b=i7Rxr985cqFOdOK+pqj+8XThYJsyqfa8cF4vlAUIm22RhmzPSlwkbgqxGJfg2nRujo
         LpB0Kmki8lf52Vpr1N06JDL5pQbAw8JMOcgbS5nlh6TqVD8+tOKhALMDLffEr3YgYS+h
         mR6+fCou1lnBeL6RdZBLv0llMUmbp4mculQZUelSQyTq5yaRgR75DiAOADDNyAosqEfw
         pMGFijGAAsAQelY657Pr5IXtlUNeAdh3H0a0Ti8/zm6qXjFUnmaBg7xj1r7m8JzGFx51
         c/0sTI6ZtsVbP55ypMcp/9ZizSt170CnZ494c189U/FgACNtVQDeed2caysSsqnivyBJ
         cLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711111442; x=1711716242;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TBPzH8uDG5g28i+V0dmYxrEXrjob8o+00KlgZjV6q1c=;
        b=mav5hkqBBRNP1x5PNL8JdXpi81zcIZWqAffUTNyHu5wAl4Bs3nXvtLviOZv4U8iXxG
         H0JZjBlkYxzZKdWRxXyree1HVOzs45fJBmoq5qOloowARjGiufvcAimyKW/og5Q1VvZK
         md1k7K75onCrkyyvPaJ+4SCqWsvezHBQMUe0+Mko7hQhMec3nXEfvflJMlBMGBdFXAfq
         gI9cs5qxCqhRQJL4j86CaDjQSWKdkHUwUwB79YfUnE5giKxyjaiwf1i2KMCtvll5+o3Z
         XkS6i+4btuQdpmqj5Ec6fYpW2GWRTa1ddXCLOn/fEd1WyW2l+VpfOGiev5F8GCTHZLr0
         VsYg==
X-Gm-Message-State: AOJu0YzJgkmbZ0ZLn5IwtE0wlUGSpecibQZXeeJzDdxJTe6HFSMVMTIp
	kD0pxzvyUtztfRiWoo51bh9hKLHLxn5zz0Cmg22NM0rWtstRL3OxG4riL2qjkz/5VQ6JHn5G0iF
	FV4LIh9Y0/MM/DOIAYa0Vojjc4Q==
X-Google-Smtp-Source: AGHT+IFzf18KZ0iBCrjW/8R/6z+H2nXgPj8YuTFxRr7MGr6I4rYMt6hvaFHDr1At0VKoydLVvbh6cjlq/HBZLuTcqXQ=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a81:4fc5:0:b0:610:dc1b:8e57 with SMTP
 id d188-20020a814fc5000000b00610dc1b8e57mr560266ywb.3.1711111442517; Fri, 22
 Mar 2024 05:44:02 -0700 (PDT)
Date: Fri, 22 Mar 2024 12:43:02 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.396.g6e790dbe36-goog
Message-ID: <20240322124303.309423-1-sebastianene@google.com>
Subject: [PATCH 1/2] KVM: arm64: Fix the identification range for the FF-A smcs
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org, 
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com, 
	qwandor@google.com, sebastianene@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kernel-team@android.com
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
2.44.0.396.g6e790dbe36-goog

