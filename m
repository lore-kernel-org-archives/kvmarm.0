Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE33C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 664396115B
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 664396115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 130444B13A;
	Wed,  3 Nov 2021 02:28:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AfMjKG9hYxa0; Wed,  3 Nov 2021 02:28:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A36CA4B162;
	Wed,  3 Nov 2021 02:28:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74DD34B162
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LePJGHKjiFU1 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:13 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C40FE4B165
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:11 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 h10-20020a63df4a000000b002a6ba425b58so992527pgj.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=q7+v9l/nyn0AhgzFSGXemnn4ohytv9T7PB3GkiLTiSE=;
 b=F/5iIMozxPOo534ZUMCTMOdMx+LyGtJ/iZkeAEsUVRYifAuz8U8ZGbr6iPcr0AjzHk
 6HOT5t7D04o0wT7LaJr16di3GZqV1RVebdyhB5sl8cOudvyAQaBba+mKGbq/3qe4OycH
 e8/0CVyXtti8MBL+PaZBrYK+DNY7pegs7toslxhljSkcdpvcgQJYxgYKl1wzHtuQxgw4
 OCuWQ60zLJGsEbhCt7/x0kJsyFY6Ttk2aE492TMse1o5s9v1xZ65ISDa8M4MNHKuK0AW
 U/g8rvdAII/cUD9IFyW6AnLYnRBJgL1sQnz5rG6jtSyILqqFJHkyM4MtFYiL9OnTooor
 jNwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=q7+v9l/nyn0AhgzFSGXemnn4ohytv9T7PB3GkiLTiSE=;
 b=W6lZr0nsUo4+JcNVObKF97cUv7nn1UKLGOYAntax5KMnQMj/FhTthQqpNSEi7wO81V
 wOEemHArXMSeAFpjKHQn0NDs4P+5ziJlfI3PZn4kidiZ9/KgW3oBzEdJaaWOFs5IlNn4
 Z76ByT9bqi0+R9i6UoOyAmD8r8mrDnVb8A/tMKDN576kSVHGI4rQ1WOhu96gt5HMWZms
 tszTHH4kdCLPyvWXBXSFZ5agICQxUBLDqnaXPAdWdMc1JV59wdQ+Qg4Rk8zKn6TDQ5aG
 Sw+P8avZhdYH8Rd4z+/81+OnRzDtQuI5vc9ogX0/Yhb+8MDzQejeL/yLmZAe65Tb5lZY
 k2sQ==
X-Gm-Message-State: AOAM531Lu5IT4HhJQL4Tgg/Zkaz/Heh+CfRHVi1fnBexUrqEHCIhg9/k
 vNIyVs7H/wr6WVRf69h0qMtIe4g/9/Q=
X-Google-Smtp-Source: ABdhPJwKpyNta3uMXyyhmfNw7FgGewWUZO4qQrdHLOYgh4C4cuvOvtPwwORnahFa9CDV9cNccFbK/CUlCZY=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:14c2:b0:47c:2c90:df4f with SMTP id
 w2-20020a056a0014c200b0047c2c90df4fmr41652535pfu.63.1635920890804; Tue, 02
 Nov 2021 23:28:10 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:02 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-11-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 10/28] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
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
exopse 0x0 (PMU is not implemented) instead.

Change cpuid_feature_cap_perfmon_field() to update the field value
to 0x0 when it is 0xf.

Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/cpufeature.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index ef6be92b1921..fd7ad8193827 100644
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
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
