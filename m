Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD194C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4C6D261178
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4C6D261178
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC25A4B1CC;
	Wed,  3 Nov 2021 02:28:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bKg36LuL3I0d; Wed,  3 Nov 2021 02:28:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CEFA4B188;
	Wed,  3 Nov 2021 02:28:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 948164B163
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LuYgmIngzWXM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:22 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 27E274B16E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:22 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 s4-20020a627704000000b00481101730b1so831920pfc.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=kNjTPzP2KLdpBZioWjSqQb8109nySN2BIgqc7hOB6qs=;
 b=AfpsRAPpSTvALsHZ0QnP5jU02J0/Z3dgKDvHgH5nClQw7JMedG9qWr0ZRMiobPmrAW
 0r+PYxsUEkUxjdxdJ6L556u0HVB/Zl5mq3QRWFXm8rgjLc7HTzh6VdKeU9MIgcZ/Zxml
 PVVe76BxFjMMsUwIcgVTvNqdrFG4LofekmP+iY8Ruvwdxe8ypsLG4ek6srsQcCs5DP3w
 uqjbxPp4oBvGERNCrd0lHsSx0gGRU628gRGZTlTuXm9EXjCnbiD4Qq9v2d72PNRiW/av
 S+s/UKR+NFVCAFmIm4FpXxK3gWC2freG//KY5OB1zKprirGGzArEsbaC69f7EAmeZg8i
 STFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=kNjTPzP2KLdpBZioWjSqQb8109nySN2BIgqc7hOB6qs=;
 b=6Iyv2oaWL96IEaJatZyVXX3aa2K6e0/9WUcC8FA+bCs3zL/twgiTBB1ZUfDybfz6/i
 wcuTxrAa0Fyz2uIJcCyaL0/aIiwF0vzcl5sw4qbdg8ps/UiDgm5auIMEUlDguy7hbOq2
 8vwTIDNQiLWZKvn1k5QPrKPEOK/D9BQ+hspPTyWcxarYXRJtSoJqcMEcmFre6GO1vDOI
 MdarbE9q47Smicz4rkADSB25N4+zMJP1jteGbxsp8HrkzqHipXXTmEfJVRm4GnjJQD9o
 zPgP3VTPm9DpvgnGMWer6cVga19u4w3MYj3ILYV/JgX9m2CN8j6ldOEzXXpXrRGFWbjh
 cI5g==
X-Gm-Message-State: AOAM5323iPVRyiloUQnyK8kPOo0osofY0LtOjCx5Ai/V56ZGcWCVfZdD
 J0EuPHunymmGDJfkYCi7xU4nuQJNqtg=
X-Google-Smtp-Source: ABdhPJzPkyz8U9fHsTJuHQswL3KaxgisjjocgibWzmnaPNs/FZMpFacvIrZvfkYMZMGH+/n999KUp7HLIcw=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:a503:: with SMTP id
 a3mr12433259pjq.122.1635920901217; Tue, 02 Nov 2021 23:28:21 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:08 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-17-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 16/28] KVM: arm64: Make ID registers without
 id_reg_info writable
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

Make ID registers that don't have id_reg_info writable.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 99dc2d622df2..1b4ffbf539a7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1836,16 +1836,12 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
 	if (err)
 		return err;
 
-	/* Don't allow to change the reg unless the reg has id_reg_info */
-	if (val != read_id_reg(vcpu, rd, raz) && !GET_ID_REG_INFO(encoding))
-		return -EINVAL;
-
 	/* Don't allow to change the reg after the first KVM_RUN. */
-	if (vcpu->arch.has_run_once)
+	if ((val != read_id_reg(vcpu, rd, raz)) && vcpu->arch.has_run_once)
 		return -EINVAL;
 
 	if (raz)
-		return 0;
+		return (val == 0) ? 0 : -EINVAL;
 
 	err = validate_id_reg(vcpu, rd, val);
 	if (err)
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
