Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B0AC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A0CA1611AE
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 15:58:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A0CA1611AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 447764B11E;
	Wed, 13 Oct 2021 11:58:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 28QXtPqgUvjJ; Wed, 13 Oct 2021 11:58:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 24E444B13D;
	Wed, 13 Oct 2021 11:58:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D0FE4B128
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5hsYA1hJiGSa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 11:58:43 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF0BC4B121
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 11:58:41 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 k2-20020adfc702000000b0016006b2da9bso2373737wrg.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iQjX5L75EMSut/e9QkKC3PVYtpB1oumW2lPsA0BXgHk=;
 b=mIk1w2jkpInjOJapgg2EiBV4rNZgsgrkxTvKv+siczoD6/bFepkA9l4SOTN6PbyrSN
 dXPXzsv4EPi6k9JSC+NkQy/OdGLmYCDnMOgDmY2x8FF0X86XBBp4Zlcbuy0UoaXz8kNl
 yNBxqZRo1LBPUkBWUDCARpwsXE05CCl0Izy/SIBc7Fjm85eoeEDoAtMV3PNd9rxKM0P0
 Pxw1YjskOHOCj8VoF4X7ujJ2Esn8W3QuG9E1FlEL9i2WuxPaTuGTl/4yWFNdPCfsNl62
 tjkH4AxtP48/1CYZlrScJ0diYkB2Lqr0HocWPwK3xLr8Twzo7r+apNgU2NSKioYMwf5/
 Xg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iQjX5L75EMSut/e9QkKC3PVYtpB1oumW2lPsA0BXgHk=;
 b=aM45vbFPdmiI1Wct9lrKdfuJp2/wyn+QRe0pa61nVlQ33m/SerTeKtT/JdseT+J/VW
 vzkoBHUnjA0t8SBK5r9FC+9ZZOYlbkw0MojBofDiaEFc83tt+egF73cSTbKe+xtGwvwY
 jDJKbUocKBTKc0B9vOK/uLTuWze6L+kEnAnazYOE2l1WqaC07P8FVLkWmE9KKHmF/vRa
 Yy4fVQ8Q/99pNGVF57zKJgH7gm1bMeSZ1dSU1MlHVP89OvW7h7GIDGCv2FuyFXlQsLx+
 rsJ5AlXSLzqz91RfSJj1OHNwpHD1m0y0OlC9knr31L0sNy1cZipHsYa9RCUmPIxgdCkK
 oavA==
X-Gm-Message-State: AOAM5335/i4RfJ086il7/TzMoKU88gtFhMTk0DBOXJ1mEo06GanAT91I
 rRZunZGyGngISLcf8m3VBjNHUC1XhtPP
X-Google-Smtp-Source: ABdhPJwXfk8TYTriRHD8Ql+PrifVU/oKyaCUyxffX3kvDsKbnn5ZL+GaraV62M5Cs5X0Y7S/AKPg00V749ll
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:65b5:73d3:1558:b9ae])
 (user=qperret job=sendgmr) by 2002:a05:6000:2af:: with SMTP id
 l15mr6285646wry.296.1634140721007; Wed, 13 Oct 2021 08:58:41 -0700 (PDT)
Date: Wed, 13 Oct 2021 16:58:18 +0100
In-Reply-To: <20211013155831.943476-1-qperret@google.com>
Message-Id: <20211013155831.943476-4-qperret@google.com>
Mime-Version: 1.0
References: <20211013155831.943476-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 03/16] KVM: arm64: Avoid remapping the SVE state in the hyp
 stage-1
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Fuad Tabba <tabba@google.com>, David Brazdil <dbrazdil@google.com>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

We currently map the SVE state into the hypervisor stage-1 on VCPU_RUN,
when the vCPU thread's PID has changed. However, this only needs to be
done during the first VCPU_RUN as the SVE state doesn't depend on
thread-specific data, so move the create_hyp_mapping() call to
kvm_vcpu_first_run_init().

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/arm.c    | 12 ++++++++++++
 arch/arm64/kvm/fpsimd.c | 11 -----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..c33d8c073820 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -618,6 +618,18 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
+	if (vcpu->arch.sve_state) {
+		void *sve_end;
+
+		sve_end = vcpu->arch.sve_state + vcpu_sve_state_size(vcpu);
+
+		ret = create_hyp_mappings(vcpu->arch.sve_state, sve_end,
+					  PAGE_HYP);
+		if (ret)
+			return ret;
+	}
+
+
 	ret = kvm_arm_pmu_v3_enable(vcpu);
 
 	return ret;
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 5621020b28de..62c0d78da7be 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -43,17 +43,6 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 	if (ret)
 		goto error;
 
-	if (vcpu->arch.sve_state) {
-		void *sve_end;
-
-		sve_end = vcpu->arch.sve_state + vcpu_sve_state_size(vcpu);
-
-		ret = create_hyp_mappings(vcpu->arch.sve_state, sve_end,
-					  PAGE_HYP);
-		if (ret)
-			goto error;
-	}
-
 	vcpu->arch.host_thread_info = kern_hyp_va(ti);
 	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
 error:
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
