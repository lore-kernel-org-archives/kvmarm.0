Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E5B4E63D
	for <kvmarm@lists.linux.dev>; Tue,  5 Dec 2023 10:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ROpaDOMV"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5d351694be7so83408397b3.3
        for <kvmarm@lists.linux.dev>; Tue, 05 Dec 2023 02:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701771784; x=1702376584; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=33fHTG4hd84nJo+G3RKw/og5Lg2h+7y1b4GD/jJpS2Q=;
        b=ROpaDOMVsveWhzgwOWqDNWQzZt5x6DdzFpEELC0eDlFFopP8JEMEwl6/+ZhpTWa2Z7
         dRQIqhhWsgVY9qrbtJoWLzaSW3A9X+30gdG8tOXc+apXq/qWqRyXOwjK6hvj/ZghKMYW
         x8sSIljDGdliPnopaY3qsBJWBQtGQr6vDafULpOnunJ4YOBOZdQ4B2B3udiNEpPWspew
         iNo/j9GcPyDtRn9/ZJ5JuqvlSEXgvf4eGuZjzb/b9UExSPdpm7jhX6zEsqyLagzmpwLN
         WTsJVtA+LWxCadXhR1iNAWtVO1P69x8qIF34hOCbHcaSwFVKOSQmD1fhN3Wh7T3G0l/L
         0ySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701771784; x=1702376584;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=33fHTG4hd84nJo+G3RKw/og5Lg2h+7y1b4GD/jJpS2Q=;
        b=rYYXFT2IvFEAmWWCBjrOKewSExSBTe+9trmb9vvy6XplJyARehAYU4tSH1XxpPl861
         hONriuC22T7wQC/A6HXBLQ8KBWld+zLVzfbHeydsFlm5S/DO94ux5y3bD0Aud2oksY7t
         qd96Nz42SoSOscnFqDwRWkt+vEdZL6IkCrNpQaMDGTfFfCm2FrFXU7USGqksXt/1Pt7X
         FQdxm25P12xkhZGp/D7A/7v8D8x2V9mnrbxOwqCAxDhoBhfWISbfgM2CMfTAu9cwIoXC
         npOum9tak4qEyUofXQJC2Q0UZzGd4HbiAJKHpexlaaZTXnC52/3lJ8GGkOT6mTr1wq4A
         HHYg==
X-Gm-Message-State: AOJu0YySlCBj5tn4L2gnoJGVn4zUj9EYZDz47LvrsZd0kO//0lUTWdY1
	HD5t5EcpSNJXWSf+IUzPZfMHp2SDk4hIxl9PxCl3ii3N0TjHvcKnzQkjcfwDAYF1aY4gCvzcukX
	CARSsDqfuH7/4gv9lCMAKStOHQp1Qlj7jCadEE49IzdxhmN0muJ998NaBM+M=
X-Google-Smtp-Source: AGHT+IFuVZnqls8s50nh20mAzd33XQDay5LYgo/RvYkGwRdnhQgJYLOnpmgqp7qPnVY6WXLk7qGbMS3YbQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a81:f00a:0:b0:5d7:7d30:595c with SMTP id
 p10-20020a81f00a000000b005d77d30595cmr184549ywm.9.1701771784487; Tue, 05 Dec
 2023 02:23:04 -0800 (PST)
Date: Tue,  5 Dec 2023 10:22:48 +0000
In-Reply-To: <20231205102248.1915895-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231205102248.1915895-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <20231205102248.1915895-7-tabba@google.com>
Subject: [PATCH v1 6/6] KVM: arm64: Mark features as supported for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, tabba@google.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Add features supported for protected VMs to the allow list.

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

