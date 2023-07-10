Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688AE14AB3
	for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 19:24:40 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-573d70da2dcso56536537b3.1
        for <kvmarm@lists.linux.dev>; Mon, 10 Jul 2023 12:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689017079; x=1691609079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RJ6ya0NEnIa5aVQX1AiBY2Ns/ppVJUg4kBKaquDN4C0=;
        b=OdWaI8UetC5xlsDbivt/wI1RqtD2Ol3BBLHnxQ9/Cf9Go9SKNCN7pvoug5MOr8pFRE
         Jr0HJYE6+lJIFXqJiZFwE62NlyzEhmli/QtYehhll8htzke3R17cDFmL4EWRtVDdtxpj
         v/3b49yRvxDs3842p5I92zZ1Nxbg+u3MD2SrWdYVKspzUMp2ZxinKiQymdYZdCuRoei2
         Fav1CzDCizrzfvxke6uiRWaXz9+d3t/p+qH5BHFH/8Hkr4CYv5kH/Gm2210yjr/D/U2A
         OJ34jvPSX4bqdF8X1d/o/dTD9bTQ9+/d/P8r54rZ+w2wkDB97xWCkJgaW1vJvrm1zxUo
         Dz9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689017079; x=1691609079;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RJ6ya0NEnIa5aVQX1AiBY2Ns/ppVJUg4kBKaquDN4C0=;
        b=lGjNGu96cfA8+XVSIp/aBVGyLBsRSaMju1Ar0+uhYH5JX36Jr2V1y37HO9tlftqYnB
         8C+a+j1LFuLsgRzwv5AbFbBCbE4s0QUbQp6e0bwUwKz/g5nn1eB25qY4TyvRTujvn1nJ
         S90hqWPjFglKh5WA7DUN+hk1ZhxEGQ+kJxjwDKBdH9PrNaewTldn5By6KfrClurWM8s0
         iZClLPGqrAxDa/ffc8Y9UwsqBmJ4i6FEBJxj/wgmP630al6Dve4yduXyaE3lvTjITGIy
         Z/0c2UxD//GP1rpykkVkXWv5PHwOVvvryFZ1sDNkRLJ5zC4P/FlhFxY5C+yiMeS+DrIZ
         FVEA==
X-Gm-Message-State: ABy/qLbH5fpmBNv9xcw0Kez0t7Ifq9vPCYfZRdC175OtTklQmeNwE3+a
	YsAYKE9WXZnGzPOEjQC6XFaE9SuGtTPPUAhpcg==
X-Google-Smtp-Source: APBJJlGrizomlrXrfIIBON5g1LdEHWOUxmR3lblulK7dG7BSaVkBpJJIgLVla3mrwr0NssOyEnvwpwXcUtXHepnUaA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a25:508:0:b0:c66:b847:544d with SMTP
 id 8-20020a250508000000b00c66b847544dmr113736ybf.1.1689017079311; Mon, 10 Jul
 2023 12:24:39 -0700 (PDT)
Date: Mon, 10 Jul 2023 19:24:26 +0000
In-Reply-To: <20230710192430.1992246-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230710192430.1992246-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230710192430.1992246-4-jingzhangos@google.com>
Subject: [PATCH v5 3/6] KVM: arm64: Reject attempts to set invalid debug arch version
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Oliver Upton <oliver.upton@linux.dev>

The debug architecture is mandatory in ARMv8, so KVM should not allow
userspace to configure a vCPU with less than that. Of course, this isn't
handled elegantly by the generic ID register plumbing, as the respective
ID register fields have a nonzero starting value.

Add an explicit check for debug versions less than v8 of the
architecture.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/kvm/sys_regs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0160ef9cfe18..c44504038ae9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1496,6 +1496,7 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 			       const struct sys_reg_desc *rd,
 			       u64 val)
 {
+	u8 debugver = SYS_FIELD_GET(ID_AA64DFR0_EL1, DebugVer, val);
 	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, val);
 
 	/*
@@ -1515,6 +1516,13 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
 		val &= ~ID_AA64DFR0_EL1_PMUVer_MASK;
 
+	/*
+	 * ID_AA64DFR0_EL1.DebugVer is one of those awkward fields with a
+	 * nonzero minimum safe value.
+	 */
+	if (debugver < ID_AA64DFR0_EL1_DebugVer_IMP)
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, val);
 }
 
@@ -1536,6 +1544,7 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 			   u64 val)
 {
 	u8 perfmon = SYS_FIELD_GET(ID_DFR0_EL1, PerfMon, val);
+	u8 copdbg = SYS_FIELD_GET(ID_DFR0_EL1, CopDbg, val);
 
 	if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
 		val &= ~ID_DFR0_EL1_PerfMon_MASK;
@@ -1551,6 +1560,9 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	if (perfmon != 0 && perfmon < ID_DFR0_EL1_PerfMon_PMUv3)
 		return -EINVAL;
 
+	if (copdbg < ID_DFR0_EL1_CopDbg_Armv8)
+		return -EINVAL;
+
 	return set_id_reg(vcpu, rd, val);
 }
 
-- 
2.41.0.255.g8b1d071c50-goog

