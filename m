Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7417B28DA2
	for <kvmarm@lists.linux.dev>; Wed,  6 Dec 2023 10:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HZLKiHPp"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-db7d0089795so6331893276.1
        for <kvmarm@lists.linux.dev>; Wed, 06 Dec 2023 02:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701857135; x=1702461935; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xUiJNYgu3BcJ5Sp8pydb/vXasIJyg0fyLlEISb7NPAM=;
        b=HZLKiHPp+KgGJP1xUS5GYPO5vySg4vLRMs77eqJ6aJWc/nDtXSZy6sJMurNc41AX7P
         Oip4qFtr15TXDyjB2/hZgnpfZ+S/7CErMnkll0sZ9gTn4r3VQpHhDzWG5wmYHE1knDgL
         rrJ1ycpcuUFAn5v6LzYwokbYZSeM5HS0okcjUSvQZ3YOuIiht9qck42o9eUibQjFBGPJ
         CWhzSpCLhRq7QtcZpdPBRZj66UtOl/4H/Md+7ObGYzHC34lQlmF0lRuFxeIMAloQPfve
         m/voPZADt1hWL25seR5/cH8kuSZr8V9y5TbWg4O4Xab0HjwdfvSk7kRpMbm54CWcptUY
         uMRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701857135; x=1702461935;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xUiJNYgu3BcJ5Sp8pydb/vXasIJyg0fyLlEISb7NPAM=;
        b=HFuAP254EIy9Ixfu+TCdCAkwo2479O1HQM4oHb4uuUDOe8ab1SUxcMZkOXfRD2KOlv
         QV4W/u1h75DVlikwhu+2/cAv5ne924w2wdlBo/hSR7Tw42oHakET61yBFwcgL1BWPLWQ
         +UsnjG1Om/jCPxhADUBkzngflZ4/LAiFAlpnBpZQWeXNTwcCwFBwpYJsMEZXKqVCqT8L
         RX7DQ6cZqwV17FFIrbT3nDwsyB+bD0Q/92IZ48WZ3A8HMOYv+ia6mmTLVbFvLYVh5XWk
         L9FWgKFX+cYg2uaDmvovs2H99/QxKWWjHdrDK7SS5TVeoBKwAiIKyPk3EGbRaiURrZ0U
         5pMg==
X-Gm-Message-State: AOJu0YxQr518yDZ7J8KgCCOUuc8ONALQybhUx99eLhtHySVA9w5CJaP3
	BN40GinSLwSGV2uXfrm6sW9I+kg2i1d6an6M5GZmfmLlP6xuVyQUtv5LQ2sD36CU19OSNb2zZEA
	b91flcrCJ+OaddPQ7KhOqDpNJFbdJmyWzK8pttVDQBmJS5HMfBPzwRUGvCuY=
X-Google-Smtp-Source: AGHT+IFGRw3zitwl4XnEhwjmIR/zDmnE2y22FrkJSb1iLC2yNmu9JaaASYyY8nJsZ4cyowrGUlwSuBOEsQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:d751:0:b0:db7:d315:6643 with SMTP id
 o78-20020a25d751000000b00db7d3156643mr4262ybg.6.1701857135072; Wed, 06 Dec
 2023 02:05:35 -0800 (PST)
Date: Wed,  6 Dec 2023 10:05:02 +0000
In-Reply-To: <20231206100503.564090-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231206100503.564090-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231206100503.564090-13-tabba@google.com>
Subject: [PATCH v2 12/12] KVM: arm64: Mark CMOW as allowed for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Cache maintenance operations are not trapped for protected VMs,
and shouldn't be. Mark the feature as allowed.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index e91922daa8ca..e628541585fc 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -101,6 +101,7 @@
  * - Privileged Access Never
  * - SError interrupt exceptions from speculative reads
  * - Enhanced Translation Synchronization
+ * - Control for cache maintenance permission
  */
 #define PVM_ID_AA64MMFR1_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_HAFDBS) | \
@@ -108,7 +109,8 @@
 	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_HPDS) | \
 	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_PAN) | \
 	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_SpecSEI) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_ETS) \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_ETS) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_CMOW) \
 	)
 
 /*
-- 
2.43.0.rc2.451.g8631bc7472-goog

