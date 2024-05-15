Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882D25DF3B
	for <kvmarm@lists.linux.dev>; Wed, 15 May 2024 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715793798; cv=none; b=s2fSBfsCCZnnxx30I7hr7XF510S9cOIBiwRB1uUft8GBUQhV2mLC++5tCSM2dE5at+k6m+9wIkbrErYIKZc8c5rogPv3dsl+VEMdRI5xPcNqpQ5OiNxLlfGrxrTq9IAzmphZGxtcZb96+yxgDSa9H0UbAKtfgtfCxhNkIi72ouI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715793798; c=relaxed/simple;
	bh=27Ez01frh80qv0dCLE2nqGawXWJ0QpQYbc9jTyic+yQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Do3p64NrTAlqsZBYqinPMSsfgEjnHJT0GinbgCgjYP8aVs3rvRBpkuag1HWlUYFgdk5KeNolDQtt9XakdFN7qCMqukiZTGU4gYT/lSpGXqjezXhrTN9BtVuyv2LA25wYOoLg7Ge7ukqvg6nYCl8wP65wNo4UFTa6ziUNCaQQj9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I2TXo+HP; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I2TXo+HP"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-34dcec2cbbbso3889336f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 15 May 2024 10:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715793795; x=1716398595; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B0DAehK5iEGC7D6F2LaIGrwd7yaT6oZGo7c2srRK8ao=;
        b=I2TXo+HPSDEjObHke/IIT+g1NQnzPIXCLU1kxqklupbghI+rIbeqkQEFYEza1WUeSj
         bmG3CzzQ3+oPzA0vk0IKChQnA9Wdt7xfKDCPRdcl9ONhOC/FNQy89EnH93R0Fxeo1h9J
         uCocUshUYaELQC8tJuJNcEGKtt5UNDzqxcLzi0Vu3f3h1vcUvi0xupvnbfWgr54uJuV7
         HpPyolL6XENSGkBrerkRnmvuICBDWXYTMgEQQ+zQEHQBLsGsks8fTbTkqx5yIcPBVxGy
         jbi1CFFVttDf7t3I5PYwwUbWctM70MxWPaNS1PpYYDbt/of+3Qt8koZndYy8Uypu8tSG
         XEsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715793795; x=1716398595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B0DAehK5iEGC7D6F2LaIGrwd7yaT6oZGo7c2srRK8ao=;
        b=S5Vm6FrvF/M1l5xNSU5HNlSxWu9fE5+tbWXkrs3QJIRgLaeSbSP/vlSXGjhsnVzjY8
         WeVJ0EHx04uyt8wTyTSFVHqxvpXhBHjWl5ZmQnycOPcGZ7eDLng/5nc5ckv7vdSmsQGq
         EpJXXu0tioGSehSgjdPYsmaTbD+hzNAdmzhGsLqqt/hhCF2HwwrwVKSkgTc90UHuvXtw
         0n9bLIx+AF/icelkatigUBc7uch23Ka/jm5iGBMrWmYInqisAej3ZgbnuiY0RUPrViXx
         2noFCxPSFtEwULXmKGj607q83eMS0xJn+7tf6RRKa7+Awbq/5ylNnvxBnqppJwoThpvb
         510Q==
X-Gm-Message-State: AOJu0YzHgXVn+fD2wpZbUaz0thPM6bxVNSW1s2uejL3SIKYXT+FIVX3O
	xWgOEcBb8aPM1rgJUP/n34KOi2PPfY+K0limZp7Zn164Ljq+SGVQlP9XEud8X2cPTunt+GFhELs
	L0blbMQ7OGfcrR0FgZA3mG8H/Dw==
X-Google-Smtp-Source: AGHT+IH03ZoGLJfBqC8Eh4MTyJx29qZ/mRDItFO9N0niAZcln5o7llsonWFoglyUwHcG4HXvFRo52sD+v+QqQnvnw4k=
X-Received: from sebkvm.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:cd5])
 (user=sebastianene job=sendgmr) by 2002:a5d:4750:0:b0:34d:a979:e99b with SMTP
 id ffacd0b85a97d-3504a10f83dmr32508f8f.0.1715793794931; Wed, 15 May 2024
 10:23:14 -0700 (PDT)
Date: Wed, 15 May 2024 17:22:57 +0000
In-Reply-To: <20240515172258.1680881-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240515172258.1680881-1-sebastianene@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240515172258.1680881-4-sebastianene@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: Fix the identification range for the FF-A smcs
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
2.45.0.rc1.225.g2a3ae87e7f-goog

