Return-Path: <SRS0=9Ttc=O6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26046C433FE
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 14:56:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A979A60F58
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 14:56:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A979A60F58
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DB424B0E1;
	Sun, 10 Oct 2021 10:56:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s41yDZO29EGd; Sun, 10 Oct 2021 10:56:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38AB24B118;
	Sun, 10 Oct 2021 10:56:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C3C44B11C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 10:56:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q6Inee4co5Y5 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Oct 2021 10:56:52 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 58C314B0EC
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 10:56:52 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 h11-20020adfa4cb000000b00160c791a550so10993609wrb.6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 07:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VhuTEAoXz/dF/jFcm1SrjIjX6UWTaTkDztAyYYvfOi8=;
 b=qWI4G5g36XxXyEsgPjeNAI4W97txYnCt+D1vMKXxad2mu+zc9lDk69KVLbgb7MoKDY
 x4b65PqwGCwM5iC6D0Z8c+mqJ60ImWNqWz8ID4P27GoBikiJflNd6oskhEdJ7dCX/hjI
 r+eIfx4aFm0iit0UHZ1DV0uMo5OrQJNk2zDrucrBYWGDZ6RYQmXK5Z40NpPTgxZskO6K
 pI6ppf5RTnHu6yfBd0HWnDKOgxR11KaPNl6p+wLJeOCUcCJNU+sLsfxkKgnH/Tpedtd+
 GWyavAG0HDOHpRkTCDF0//3M/NyzLOZjlUL7XEyP9lxtvKi0dz+HLHueq6d9gvPdHdNS
 jLAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VhuTEAoXz/dF/jFcm1SrjIjX6UWTaTkDztAyYYvfOi8=;
 b=yLm5KvOQvYOcRAk1nYsXHHtgKyLNhO/LTPJPr8UGH+qeIxcUErEyg7zMLz9TkRFgkG
 drIJXjAfRi2jLxM1NVEuxxK8xeWL1Yc2HfTfWf0hWObaLVGOI6UDOi5CaXkiVP7WdO9U
 JSBR/9AEuO3XU4357ML0JkCZuA34EGSmMgq0eamZaZCisUV6+Cupg0WiIu6fQ8MYxxdU
 J+ME04Q217aQfNQLlY2pjvwXhdn85o4EhvXXzYZNhfER0dSDI+WvW1S1nze+ke7G0jbW
 t7Y0VJU1WDg49z1itlh/Ols/EsTH4a7AJUVw7TwT8ox1tNUAVT3gzsMMg9KzWM0h6Y20
 RU4Q==
X-Gm-Message-State: AOAM530t3PHVv3L9FNyzFIJbvcDQx9uVDasTC6D3PFcxT62Em8bpuNUP
 uWwRQP48jpAJFbQ94jleAbrBREaNiRusxM381Tq1JqPa0i2H6PjAo6mwlFUK7wN4PazRHeN3zWP
 4D21HTEYGFBMcs9oYllXphrD/pz4gR2WK0X57kM3r6TALSZgo3Z3KPy7OE1+pwApviP8=
X-Google-Smtp-Source: ABdhPJz9fEWzeoXAkJy2EB0zc/fuvxlPm1VqHcpI+f8um4/Z2ygNhevMtDfldGJvxH5VKZYVvAdv4s5YJw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:4e88:: with SMTP id
 f8mr4351133wmq.185.1633877811342; Sun, 10 Oct 2021 07:56:51 -0700 (PDT)
Date: Sun, 10 Oct 2021 15:56:31 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-7-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 06/11] KVM: arm64: Simplify masking out MTE in feature id
 reg
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Simplify code for hiding MTE support in feature id register when
MTE is not enabled/supported by KVM.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/sys_regs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d46e185f31e..447acce9ca84 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1077,14 +1077,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
 		break;
 	case SYS_ID_AA64PFR1_EL1:
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-		if (kvm_has_mte(vcpu->kvm)) {
-			u64 pfr, mte;
-
-			pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
-			mte = cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR1_MTE_SHIFT);
-			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), mte);
-		}
+		if (!kvm_has_mte(vcpu->kvm))
+			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
