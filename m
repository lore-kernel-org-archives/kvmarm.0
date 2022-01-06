Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C56BEC433FE
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:28:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D2C049F3E;
	Wed,  5 Jan 2022 23:28:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZTb+5l0avhA4; Wed,  5 Jan 2022 23:28:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B92B49F17;
	Wed,  5 Jan 2022 23:28:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76FC649E1A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YwwDeNPziEpC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:28:45 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 09BFB49F06
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:45 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 t29-20020aa7947d000000b004bb4bd3dd77so966643pfq.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:28:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=DZhMao6Nzb59uhYqKntJMb0wcUFVe/fWTq/WjhQp4nI=;
 b=B1o6YWTCTFMPSevDHYwF+9S//2//N1+PXnP+1TlnL9QVCqLT3b6o+97FiIXC2Nrimf
 miXIYFPowqAitUy9yjFgHdCWNDRclnTBeLCH5Cqk/IQuuv1sqpGXycCeZCg2XLfjLKmr
 NJXVdmRvWjbihBhI07UiYrt8d3P1AzRX9cIlQa5D2W02fGotiV22DXZejhidqBzMrUV9
 whlE2JnFHTUHlcOfi8itXDTCtIMGZMvj49srS3x5poke3Unw8P2aIv6/E3RlYvJUyYp8
 T3p8ibnYLW011MeErL4RQkbPIbjwqeJw/1HUVsVCC39UDIVbpKuc5vo1YI91Uf1B/AFd
 RGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DZhMao6Nzb59uhYqKntJMb0wcUFVe/fWTq/WjhQp4nI=;
 b=JnJTkuM/UgbRSWMSQLbNvruNZZgsItgG7/ezY3cEnPovqOH+eFnnpXQYVP7sIFBIkN
 1WOh7DOYW2BcVG5zoP2H85vdp9GAY+6XKdbSOkCOns/ZFrNVQ5ZnX8nbmnoJwYGExX59
 iXeltQ3OS3gho1rW+RqhiTHO20DU5ZxCAYugBoJfgPG4Ke/gdCYzepn/B2vASUyUbsYk
 ftx8rqdvwrQBWkPlkkb+9Da4yApbNYo9sxsDhj0hHIcmBv9cTL4Xjv9cbCGD+wXrZWA3
 XWWITcF3uJgpjwCcCOGvt1isMJow4cy4xpi1f+WXuKtRhtXdnr2LSM7bhreZzzKMYZQQ
 FhGg==
X-Gm-Message-State: AOAM530BVnMgeDg+pieDKriXvLMGNxvPlhu8r5zqM9Mt7f/fKJpFFeMD
 SebOIwP5pJXfkgObKJzQIZ/FuiYOF4E=
X-Google-Smtp-Source: ABdhPJxHr1H65bcpJbwKoKMxmRj0YdGYEJpmFPmZHlSITljOdjOCkEqQRWhGEdRa2gaCuVOqi+Jbpm101hg=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:6841:b0:149:6791:5a4f with SMTP id
 f1-20020a170902684100b0014967915a4fmr44802796pln.123.1641443324266; Wed, 05
 Jan 2022 20:28:44 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:51 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-10-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 09/26] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
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

When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
expose the value for the guest as it is.  Since KVM doesn't support
IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
expose 0x0 (PMU is not implemented) instead.

Change cpuid_feature_cap_perfmon_field() to update the field value
to 0x0 when it is 0xf.

Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index eda7ddbed8cf..487ca7555c18 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
 
 	/* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
 	if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
-		val = 0;
+		return (features & ~mask);
 
 	if (val > cap) {
 		features &= ~mask;
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
