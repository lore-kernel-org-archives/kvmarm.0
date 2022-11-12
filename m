Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDEAA42
	for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 08:17:20 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-36f8318e4d0so63983117b3.20
        for <kvmarm@lists.linux.dev>; Sat, 12 Nov 2022 00:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bR8iaUgvP1KhoHZDz60Ag9zfSgL9+5xkoUuLuzW9M/E=;
        b=pIfn545Xg4RILlmoV71GI5wUoqZTMmdLuKi3J1MKvNujIUDEvJocA2w/+4VdHLrydh
         sK0Kz45DrHxyinoIeLQ4cXcCDHNvB/fiegMkUkCZ/jootdi1olpyg74PID7iMbDKYQR3
         oTZOhZlJUcV6lDPT4LQuQKTAkUOdnm8NMJhFxby6atuXio/kFt9Ro18NJkwc66I1I2gD
         WtsbfVbkSfXyC7tjTyG3DVsO9TzFV+X60s4LMAxkSYCQPawuBtmOiZYDkpv12smEP4OZ
         34OKYJg7ZObKGYB0um41oXBgQvIAn4s1YHbR2atKJANaTgagyZ5lL6q2a92cdPP49H8g
         pC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bR8iaUgvP1KhoHZDz60Ag9zfSgL9+5xkoUuLuzW9M/E=;
        b=O4p6b1U/AjL1zcPauxi814tmYfvNvheizjehioUf8Z6pD1HIWyO7INBon7q2KPbnwc
         uVFKjGVuKELF7iu8KQ5NctRwDQwtAayNV/th1Zieb5O2Tapd14SaUSk9qpzG9/0wLYRi
         dFUpQGTFmVcx9vbP7a+nzeEp5bxrqmUFlUzgRqWCxwtkStN+Cv2pKN2mpzNwA7vl5Mp8
         d76grplcUdaXDBZdyAjW2Tef3EmJDEVYGDFi0tiWfbkZJH8hq+1DNch3482N9Ykcxq7d
         p4Jccq3RPDgSrjImN7ivGDKVJIsNsVPQdTVfdftvfWDmqbYxS7vLqD6DESu5i1wES+Fw
         2ZGw==
X-Gm-Message-State: ACrzQf01Hc9g7yfvQD7xtiMPNDWEhMb5XYo+cclQMjiJwh4+HkEmNJ31
	CY5ufPbcLA/bh2VWBex4YxDJanpNQ0PLJQ==
X-Google-Smtp-Source: AMsMyM4ah6NGC8kmhMxLtTth8Jo+WhdvvMmY7TiDG/C+ZbL8Crz+PCFuUZuBbeleghI7+CU1WJykCKDc7+AiiA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:6554:0:b0:349:8e3:a882 with SMTP id
 z81-20020a816554000000b0034908e3a882mr65030760ywb.388.1668241038874; Sat, 12
 Nov 2022 00:17:18 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:03 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-2-ricarkol@google.com>
Subject: [RFC PATCH 01/12] KVM: arm64: Relax WARN check in stage2_make_pte()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
	andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221112081703.sG20mSl79L9m8bfThq7Oa1II-H_Fve574CubBJ1fqSA@z>

stage2_make_pte() throws a warning when used in a non-shared walk, as PTEs
are not "locked" when walking non-shared. Add a check so it can be used
non-shared.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c12462439e70..b16107bf917c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -733,7 +733,8 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 
-	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
+	if (kvm_pgtable_walk_shared(ctx))
+		WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
 
 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ctx->ptep);
-- 
2.38.1.431.g37b22c650d-goog

