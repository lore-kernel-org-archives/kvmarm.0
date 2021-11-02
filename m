Return-Path: <SRS0=ULe9=PV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FF0C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 09:47:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F055F60249
	for <kvmarm@archiver.kernel.org>; Tue,  2 Nov 2021 09:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F055F60249
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A13AB4B1B6;
	Tue,  2 Nov 2021 05:47:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rjEp1sDT3pTs; Tue,  2 Nov 2021 05:47:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 433254B190;
	Tue,  2 Nov 2021 05:47:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D98AA4B15A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 05:47:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yY-DAIyw6zjt for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Nov 2021 05:47:01 -0400 (EDT)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 825724B154
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Nov 2021 05:47:01 -0400 (EDT)
Received: by mail-io1-f74.google.com with SMTP id
 m5-20020a0566022e8500b005e192595a3dso5446406iow.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 02:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=1y+OLvxpVymtlL7fk66XN2cWX+vD2iLWE/0SkTIcu/U=;
 b=rzO1Y8VN0zUYuasfFoTvV/5jD+cKSRGlj/YpHnnIRuicH7JJIZ2PnY4j26AX38M33j
 w4phFGdJUTdXdCnx01ZxlpdHwuiZsF8zMYKIkTwU+Oz5ByP6W796mfarWTsctdFT1yL5
 pJlkmLGyfKzIN/D3syWMWYGFIs5YynzA0lsENVBa/R/bjXWIMJgrWc22lyZuS7vFVIUg
 Ry7VLJisteieRR96iKby/wvJE7vRkjfUTAUGZdOcr7NC6SQDX3vX+NM/RDeG4U1iWDnV
 FRGpQZQSdtyOqQAjD/sUYy8cu81WON1vWgsJcY7wvINgJ71tv806zzkalWbjsCPfged8
 +yUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=1y+OLvxpVymtlL7fk66XN2cWX+vD2iLWE/0SkTIcu/U=;
 b=Yp9bV9Tjurq27/s4UMuXPeZUFrNSMhnCB8hTCsHqKpufqGzMuuN7h6iFE/nrRTIDMi
 mpPldxrRRUNymyPViLaNixs5zuEqYj+f2SIsIOIH0h5qix1fMkRpuRPNcAp6Je/Dz2V5
 eDRgVP/fMybi3YaxRymU1MKYIf4VmhWlU+Dl+I9vSpJHuHMCGv0PI6x6/2dYIK9hRVEs
 a+in/Tu+c+i1C2bvDyr9bGhOXNxabkOUItNqzNoPCSaurOaSYjdiHPWQrzvA4RLsAMQK
 Pbbe3QRd55tYB05k4bxSVI3G5ln36Jv7TR/vUbkZT5t+n8a+qXaNbFowiEQEcQ90dXda
 Wbmg==
X-Gm-Message-State: AOAM5315e+7t4+UQONVk05YFmsU+HmuVaZfmprUBWpn0UKFJAuL+/1jC
 hPCUsFzFNXjVHGeZHaTPUle06Z34thZYWMIWNiJ3XiuRraOWaT06t3XhmJ2IMCBxV5PAX380fnt
 7iQim7Tg6NwrsqD979NgL40v63MnCOrMISrJACpyhiskJtsETg9kXQFDoCCkagestUa3BQA==
X-Google-Smtp-Source: ABdhPJyayLrRnzjr+V0pA0yQ0Z4XEZRHuv5UbfBHmBUD+1GNwyAnZEMt4nk99gXUFzj3J+ZkE8WGDda50ZA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:148b:: with SMTP id
 a11mr26232858iow.85.1635846420975; Tue, 02 Nov 2021 02:47:00 -0700 (PDT)
Date: Tue,  2 Nov 2021 09:46:46 +0000
In-Reply-To: <20211102094651.2071532-1-oupton@google.com>
Message-Id: <20211102094651.2071532-2-oupton@google.com>
Mime-Version: 1.0
References: <20211102094651.2071532-1-oupton@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH v2 1/6] KVM: arm64: Correctly treat writes to OSLSR_EL1 as
 undefined
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, linux-arm-kernel@lists.infradead.org
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

Any valid implementation of the architecture should generate an
undefined exception for writes to a read-only register, such as
OSLSR_EL1. Nonetheless, the KVM handler actually implements write-ignore
behavior.

Align the trap handler for OSLSR_EL1 with hardware behavior. If such a
write ever traps to EL2, inject an undef into the guest and print a
warning.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d46e185f31e..17fa6ddf5405 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -292,7 +292,7 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
 			   const struct sys_reg_desc *r)
 {
 	if (p->is_write) {
-		return ignore_write(vcpu, p);
+		return write_to_read_only(vcpu, p, r);
 	} else {
 		p->regval = (1 << 3);
 		return true;
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
