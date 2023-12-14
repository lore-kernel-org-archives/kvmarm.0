Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F205364DE
	for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 10:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mPttejQB"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbcd721b366so346773276.0
        for <kvmarm@lists.linux.dev>; Thu, 14 Dec 2023 02:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702548154; x=1703152954; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S1+IuL8DTNb6t5XDOnXjUzV0e48iypX1iDtmuw3RN+0=;
        b=mPttejQBtt3jXrWEKQvhm6GCh2abNFFwl1lJEmmU2Y/UbTe+tccUTdx+GNFtKJIuwn
         XiEpSyzRAETGEV9NgxhFXSpru/8R7zWmCgxRkZdR+G/qkobrh1M0k9xxzEXVoQr4mpUC
         yBoVrTWYb78OG0VGqitCAjHcI2n4kLweQQ5IuhCQplgMyNQkrr7WRFmh2TwxICaGIGl5
         LqvB1hoBAlePjKsZ8tIAVOgUf9En++Fh8bmqxmVkOfjTa5x6ID34iBYewo86Pfger7WE
         V8RUAdA27l4IgvDEJ2tPcMD3xEdXuMvWWX7YnsOocLFKn1x/MkpOaMs431x1Pb4f3Xgn
         54HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702548154; x=1703152954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S1+IuL8DTNb6t5XDOnXjUzV0e48iypX1iDtmuw3RN+0=;
        b=xJMUZdrrJbsyOmZpFupUMzBi/f/uBbJizp9lxLm/zqAdl1JIwH/8idYbXkRsvLxCSU
         kFQqkFTd5z0aSwDTXVvPRPxDos3FQ8S8sdCsWGNFSH19merWyb7M/UQZpw2jFIwyAoGV
         YHy4lGzJv+xRW2KyLxUq/F6pMNG0TNcIZnvDrol+/S8qJby5RSbA0fr0adt10xMwdIa6
         4KvYGxFRQXBbJajmamdxWRcDmLmCx2vDsZgDqnhkCkVhiEvnTyw+YLg7o4biVHKJ/nKX
         o6iHYmglGApjzXoXrg3zSWFlfN2sRQGr5eDWdwrNa+F7gUo6UzGNASebdyQejhk1lB3l
         qbGg==
X-Gm-Message-State: AOJu0Yy3/mSnsbqnGESJBBjbW1hUAgMwW7H3xptgctwVI/hJ+6Rtg1wc
	n9VdBXyZw/6eL4Inph8KAn+bmpsHGzQh99LNtNCR6x1CRMTAZTkNGcl1wkEE7cx4aMPn5dos769
	CvIvRero/kkQVXVViesiFeL3jsiKGyPiuiyXWkSSUxuYqO18s8hRixPWOa0M=
X-Google-Smtp-Source: AGHT+IFYC31qCWJ06bIumj+WQ40j9UIE6wLj/c88RXH+XdggRYNwnvugeJ9GwrMi29Nj5+bhLHACVDAgRw==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a25:1307:0:b0:db5:4a00:a153 with SMTP id
 7-20020a251307000000b00db54a00a153mr159337ybt.4.1702548153946; Thu, 14 Dec
 2023 02:02:33 -0800 (PST)
Date: Thu, 14 Dec 2023 10:01:55 +0000
In-Reply-To: <20231214100158.2305400-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20231214100158.2305400-1-tabba@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231214100158.2305400-16-tabba@google.com>
Subject: [PATCH v3 15/17] KVM: arm64: Fix which features are marked as allowed
 for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, broonie@kernel.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, eric.auger@redhat.com, 
	jingzhangos@google.com, joey.gouly@arm.com, tabba@google.com, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Cache maintenance operations are not trapped for protected VMs,
and shouldn't be. Mark them as allowed.

Moreover, features advertised by ID_AA64PFR2 and ID_AA64MMFR3 are
(already) not allowed, mark them as such.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index e91922daa8ca..8d97dff4bb7b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -69,6 +69,8 @@
 	ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SSBS) \
 	)
 
+#define PVM_ID_AA64PFR2_ALLOW 0ULL
+
 /*
  * Allow for protected VMs:
  * - Mixed-endian
@@ -101,6 +103,7 @@
  * - Privileged Access Never
  * - SError interrupt exceptions from speculative reads
  * - Enhanced Translation Synchronization
+ * - Control for cache maintenance permission
  */
 #define PVM_ID_AA64MMFR1_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_HAFDBS) | \
@@ -108,7 +111,8 @@
 	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_HPDS) | \
 	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_PAN) | \
 	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_SpecSEI) | \
-	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_ETS) \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_ETS) | \
+	ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_CMOW) \
 	)
 
 /*
@@ -133,6 +137,8 @@
 	ARM64_FEATURE_MASK(ID_AA64MMFR2_EL1_E0PD) \
 	)
 
+#define PVM_ID_AA64MMFR3_ALLOW (0ULL)
+
 /*
  * No support for Scalable Vectors for protected VMs:
  *	Requires additional support from KVM, e.g., context-switching and
-- 
2.43.0.472.g3155946c3a-goog

