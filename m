Return-Path: <SRS0=jSi8=UD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82076C282CE
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 08:35:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 18F4D24515
	for <kvmarm@archiver.kernel.org>; Tue,  4 Jun 2019 08:35:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J8sz4rTe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 18F4D24515
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AA834A319;
	Tue,  4 Jun 2019 04:35:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FWxOmHiAuTNd; Tue,  4 Jun 2019 04:35:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 675504A3B2;
	Tue,  4 Jun 2019 04:35:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9CB04A4C1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 00:43:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nsLI2EyDKFMU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Jun 2019 00:43:48 -0400 (EDT)
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com
 [209.85.210.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B5D934A4AA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Jun 2019 00:43:48 -0400 (EDT)
Received: by mail-pf1-f193.google.com with SMTP id a23so11903248pff.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 03 Jun 2019 21:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=zkepnFRWjo+2i9EzIxBtZYocaRmAxYlop81Nj4rH8DI=;
 b=J8sz4rTevobviVKwm+dLsHY0zZAT9dT0y9oQKyafTlFYIXFXc0sZ/DS6ZSOiJpH4ci
 KWIWCxBwVCaPaC6geJvwYMf++4HvY7OTCHRLscuRijfmR+cSNydwyg5D7V0LxdI+LGJj
 VoIsuIUSlisSzGAnZPF1DUqV6SKLx89VTa4WQfp3wugLav54sY7mHjBqxF+0JGokf+x5
 vAXrGc2v1k5D8fJriujqAgW3MBU+vh7xu/kdqnI+obXgP0yWUAbhuhkTIFIKQ3sLgrpa
 LHfdBBRDqAXOzJ4d5JHexjtnNKCmImiX9N+T5AaQoeIXuM7pSq+BGNA0pB/V9nTjcFod
 Ax6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=zkepnFRWjo+2i9EzIxBtZYocaRmAxYlop81Nj4rH8DI=;
 b=cwyHTZPU9BxOWq8hheYn9TzMmKVl/f4qpUS5NegZGCauhGcew4oiX+wNcyFnB9sRAW
 3E8WzvU8v9JaPe/DBnbMNueBvp84UnfRBXvKqaM+BA/2vmUg2yor/0bBqKpmyg3eN2BF
 kE5enCv4fw8rMWfsILSL1/oItqcQcMswBZdvKjzruBH9R0RtOyYUm9BxF0D216AZJDc1
 sAg3uwsAr+297GnjB4bloM5YpKj524FQp/hzZYzdcOmXCaEOfyootYrpHmYXAohd1fAd
 enXPk1XXi4hcxvVFYX25Jxp/UQXlUOCX8EcPiBsyOstirdby36x7JWPtQUaW0sVg1eOl
 Iy+A==
X-Gm-Message-State: APjAAAXaydvA3nMFk0Ejf6BnkT7XZyf3N1zL8Q+EpZvU2JVgtfdQ7VzX
 CdFp74ETekCy+j/MHrCtuuCw2Q==
X-Google-Smtp-Source: APXvYqyrbfVVhnHOSNRF/Ni0Um7ccZKTk5f7Qfxx4j3T7CrtwO7Q4cK+39lbl+3EGYtoAYqA4PM09w==
X-Received: by 2002:a17:90a:ff03:: with SMTP id
 ce3mr34487977pjb.81.1559623427427; 
 Mon, 03 Jun 2019 21:43:47 -0700 (PDT)
Received: from localhost ([122.172.66.84])
 by smtp.gmail.com with ESMTPSA id q17sm24195389pfq.74.2019.06.03.21.43.46
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Mon, 03 Jun 2019 21:43:46 -0700 (PDT)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
 James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>,
 Suzuki K Pouloze <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>
Subject: [PATCH] KVM: arm64: Drop 'const' from argument of vq_present()
Date: Tue,  4 Jun 2019 10:13:19 +0530
Message-Id: <699121e5c938c6f4b7b14a7e2648fa15af590a4a.1559623368.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
MIME-Version: 1.0
X-Mailman-Approved-At: Tue, 04 Jun 2019 04:35:02 -0400
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
 Vincent Guittot <vincent.guittot@linaro.org>, kvmarm@lists.cs.columbia.edu,
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

We currently get following compilation warning:

arch/arm64/kvm/guest.c: In function 'set_sve_vls':
arch/arm64/kvm/guest.c:262:18: warning: passing argument 1 of 'vq_present' from incompatible pointer type
arch/arm64/kvm/guest.c:212:13: note: expected 'const u64 (* const)[8]' but argument is of type 'u64 (*)[8]'

The argument can't be const, as it is copied at runtime using
copy_from_user(). Drop const from the prototype of vq_present().

Fixes: 9033bba4b535 ("KVM: arm64/sve: Add pseudo-register for the guest's vector lengths")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm64/kvm/guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 3ae2f82fca46..78f5a4f45e0a 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -209,7 +209,7 @@ static int set_core_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 #define vq_mask(vq) ((u64)1 << ((vq) - SVE_VQ_MIN) % 64)
 
 static bool vq_present(
-	const u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
+	u64 (*const vqs)[KVM_ARM64_SVE_VLS_WORDS],
 	unsigned int vq)
 {
 	return (*vqs)[vq_word(vq)] & vq_mask(vq);
-- 
2.21.0.rc0.269.g1a574e7a288b

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
