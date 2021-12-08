Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E570C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 15:23:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DD4B4B092;
	Wed,  8 Dec 2021 10:23:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F-slS0KhL2fs; Wed,  8 Dec 2021 10:23:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 578514B172;
	Wed,  8 Dec 2021 10:23:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 139454B15E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ImMXCopBGab7 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 10:23:09 -0500 (EST)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADAF14B092
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:09 -0500 (EST)
Received: by mail-wm1-f73.google.com with SMTP id
 ay17-20020a05600c1e1100b0033f27b76819so1455172wmb.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 07:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=WFv2lXz9eCHT3yd+CF6ElCbrsux6py5SHwDqlqAaTn4=;
 b=ZDiX6clEZwsCO576ptI4p+U8abQdk4d/G9Oef955pfW4K0FAUmdqldx2WNOMkcw9ak
 5qSvscHuqPi9DAOEf9QVnnWjJ0eeoJurD1kc1Ea5jfSWXTNnLJWLVDBU6AJOV7sIIG8/
 Pj1j4AYMPQGGlZR/X4DymKwUQpNV1Upw0xVjLfOPKCa+hA/UhqGSyjcFm2+Act+iJqI5
 GSAuAGgG5gFc8GwslklSGNlNKa08cXanws+vPcdHC51+MWHmwmFsAbRHed6kq+FwtS8Q
 SRgV/L9TyhcBHOZLXurecAnFAJEuOgoccyWzRd6O1ChhBQV/YHcSQeEYlhC+TfRaL5Je
 kYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=WFv2lXz9eCHT3yd+CF6ElCbrsux6py5SHwDqlqAaTn4=;
 b=CBvCXO5P13YgcrIz5RVDU2baPl8dRgohtqFQ8E15gONNQ/RhbqLxkKd7BVRoUrtbk2
 a887sc6hbmyXfXhMu6bVez91/pPY3FExXEKceYIryDGctG93rQuSFUrbdBTlSd6ru73O
 FifVyKuyLKGl3/QwhthzKw5mSQmHPQfxD2qSds//fD/AJXYv4I9r7UTI2CDe9MGgY+pQ
 kufq8F4ZEl4ghk3GGOWD/6SiYfiD1Ne9Crix8aDZIZZV1VJ6qDFxIUmFocNBQ+XjWb1v
 AsSlQ76h/kjcvOeGpjNGsqvPW9UVr3H7cZs+dG/7DXZHbSVwANaJK2y9aufmsGnadH3m
 ExEA==
X-Gm-Message-State: AOAM531wv/FvmP9c3igOCV2AejWdfaXwAQGnBFGepDyqVFdCRWQj67qQ
 U7XAYMaaPsAl1zZwHhjfvAiD7Hv47oZy
X-Google-Smtp-Source: ABdhPJxSs8eDEFE+1XbumupLfjxLtoH5gK9ACn6/1cAzmR58bQj+dtBX/daKqvo9wufYXRpz+sc7M4xxqTKl
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:c718:14b8:982a:57d5])
 (user=qperret job=sendgmr) by 2002:a05:600c:1c1a:: with SMTP id
 j26mr17342732wms.28.1638976988812; Wed, 08 Dec 2021 07:23:08 -0800 (PST)
Date: Wed,  8 Dec 2021 15:22:55 +0000
In-Reply-To: <20211208152300.2478542-1-qperret@google.com>
Message-Id: <20211208152300.2478542-3-qperret@google.com>
Mime-Version: 1.0
References: <20211208152300.2478542-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 2/6] KVM: arm64: pkvm: Disable GICv2 support
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

GICv2 requires having device mappings in guests and the hypervisor,
which is incompatible with the current pKVM EL2 page ownership model
which only covers memory. While it would be desirable to support pKVM
with GICv2, this will require a lot more work, so let's make the
current assumption clear until then.

Co-developed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/vgic/vgic-v2.c | 5 +++++
 arch/arm64/kvm/vgic/vgic-v3.c | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v2.c b/arch/arm64/kvm/vgic/vgic-v2.c
index 95a18cec14a3..8e337a0d7817 100644
--- a/arch/arm64/kvm/vgic/vgic-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-v2.c
@@ -345,6 +345,11 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 	int ret;
 	u32 vtr;
 
+	if (is_protected_kvm_enabled()) {
+		kvm_err("GICv2 not supported in protected mode\n");
+		return -ENXIO;
+	}
+
 	if (!info->vctrl.start) {
 		kvm_err("GICH not present in the firmware table\n");
 		return -ENXIO;
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 04f62c4b07fb..debad4e6e6c9 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -651,7 +651,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	} else if (!PAGE_ALIGNED(info->vcpu.start)) {
 		pr_warn("GICV physical address 0x%llx not page aligned\n",
 			(unsigned long long)info->vcpu.start);
-	} else {
+	} else if (kvm_get_mode() != KVM_MODE_PROTECTED) {
 		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
 		kvm_vgic_global_state.can_emulate_gicv2 = true;
 		ret = kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
-- 
2.34.1.400.ga245620fadb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
