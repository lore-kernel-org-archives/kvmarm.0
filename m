Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53FA9C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1086C20787
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="Dpj2davp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1086C20787
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE5974B323;
	Wed, 15 Jul 2020 14:45:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xBPIObmALBcG; Wed, 15 Jul 2020 14:45:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC79C4B3CA;
	Wed, 15 Jul 2020 14:45:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A3C74B212
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A4LlH9UAuNrT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:48 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31B044B357
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:47 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id o12so1962748wrj.23
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=5jXqDacXXWH9FX7bZsl2Z+EROYiNPtWGBtSx1zopEIM=;
 b=Dpj2davpebzFDIFwLuU6bV2zcYQzttki92mREd2pLUjYICi43NOcGuiZz3QVB1FkCa
 PEf5ujhwMLeNdDYo3PWexHk5QWKWbSS7XvsKZ7xCc+RBba6cHNylMZ8Uums3bn0BmO2L
 eb7GXD16jhRdjGwLe65xxBXyBRIqSuLZckyiTUimAdQ7g34Ui7hF13nspS9aDGHz9+LE
 0aMm1WrdZfyFzY6lkBqUGSSoQlwY+3YChdjTGxxlAoIkjDji4M38vyWKrVEIylkQDL7S
 Y5Jzv4xZD6xHVP86yOahslL2mVXFCipoJ8zM65VP82tTIblEFb/caPVHWEVTIKYtiSl7
 mvnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=5jXqDacXXWH9FX7bZsl2Z+EROYiNPtWGBtSx1zopEIM=;
 b=YOOcBnBfO9pVjj2XLGECJukWDTVviXx1T5pGEgGNU3Sw/w1zP4HPQYrjVusarxB0UW
 Pan6Djj8h1MSq9EXGfRwcD0W+8UUL7lJtR4PPd4Nb4/hm/wRui4Le6bg2j9GrwpgSsic
 s0Kwzo+5NgEcLyF2/wIoe9HBZfqAQH3ATROe8o3M5sMlcNkef0HE23RJxKxPJiVVu+il
 YULH6+r6Hzar9IAZbF53hkmfn0drWmJblA6twaY5HYEHo6J6390TpgX+b02NiaYbZQny
 1VODQqLZHIYTfcx0mTZgrQpbPrMQaiK2mtdR+viMFWUYJnugozcYuYYHCy0A90lF2eU5
 zq1Q==
X-Gm-Message-State: AOAM5336OaXRP82QrKjjjdWUC29VFld2QY/DopS+ZnYBkWov2IE3bwQz
 IaNcdGyz9O7ctwQLopFh2MV0SRLYfxcYIrWdWCxmF70TSPATYaS7aOhTTJoV/HPIqwmevKZc0Ta
 3uuD0KrJOpmkhz26xHHjbKBq4nh+VlhWv0lpxQjJKgvMif/HHwL18E6/GRIkU5ssly4oeVg==
X-Google-Smtp-Source: ABdhPJyCs4wBFsa8SCyYUFlpMO3y9zcrqo1DzxOBMVAn5PCEspJoiricpM0+M/PjEopVBW/XjzPiwoEe1Bs=
X-Received: by 2002:a1c:48d7:: with SMTP id v206mr702842wma.145.1594838746262; 
 Wed, 15 Jul 2020 11:45:46 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:27 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-27-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 26/37] KVM: arm64: nVHE: Unify 32-bit sysreg saving paths
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

The 32-bit sysreg saving process can be made common between switches to
a guest or to the host because the host vcpu is not 32-bit so the saving
will be skipped.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 0cabb8ce7d68..a23eba0ccd3e 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -180,7 +180,6 @@ static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
 {
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 
-	__sysreg32_save_state(vcpu);
 	__timer_disable_traps(vcpu);
 	__hyp_vgic_save_state(vcpu);
 
@@ -208,6 +207,7 @@ static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
 static void __vcpu_save_state(struct kvm_vcpu *vcpu)
 {
 	__sysreg_save_state_nvhe(&vcpu->arch.ctxt);
+	__sysreg32_save_state(vcpu);
 }
 
 static void __vcpu_restore_state(struct kvm_vcpu *vcpu)
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
