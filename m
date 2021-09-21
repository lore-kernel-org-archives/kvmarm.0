Return-Path: <SRS0=fzUG=OL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937ADC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 01:01:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2EB3561213
	for <kvmarm@archiver.kernel.org>; Tue, 21 Sep 2021 01:01:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2EB3561213
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C291C4B086;
	Mon, 20 Sep 2021 21:01:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UVPmlcQfFH55; Mon, 20 Sep 2021 21:01:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDAB74B0F3;
	Mon, 20 Sep 2021 21:01:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A08449F6C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 21:01:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5hpDkeElRbgD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Sep 2021 21:01:39 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B9444A4C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 21:01:39 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 b8-20020a0562141148b02902f1474ce8b7so209257064qvt.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Sep 2021 18:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=XqeN3hyu4xVF/UFXFp3XkUay0dLcSsRd5uf44abCA2Q=;
 b=HlQnSCmXttBhWRfulvS9JxQUQJlpPBD/crbVGiQ7AxEI2pbDQrmfVVS1TrWccw05Ez
 eCEsECHpCm917mn23DJC9oZgkSzmu3asArrLun7/xRx3hNhroie5AKTRnXBi6yxoKHoC
 b8GKFhPnoo+BgJywlBZdiDb/6n/3Q1mq5w/RXjJVKxT7iiB2y++xEYRtbRwzJi8A/huk
 FaDjs6fz5H1BJJ8DL/iyaU72EoY1d5tkHHZEoT5qdqIDOkY+8BkMvBelQfJ8mdzapsbD
 d/9Sj6LOnSH4Dq2uOAaFw4RaX7m0U6znUaYtajJHJWAvtiliUjl7xZwx2mdQh50WPD7E
 XLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=XqeN3hyu4xVF/UFXFp3XkUay0dLcSsRd5uf44abCA2Q=;
 b=iwKqA/DCoWy4rUrYNrcaozFNpDP6zd5ErYZ2N82BdhwFXkXU3FYNzQHJ+m0B0hUicz
 5MEBn1jLU/80EOjDLI9SPIblWg5f7Q1hgzSrG2qJVY+FItklQQvQSEbglsYVIaUertw0
 coTLhnSQOUqQ1tPYz+r7Xm97ZNTWE9KG+xqCNkQE50hcNVE2yLfIH5Cp5tCV5iWXicO5
 x679iKtVcwbaMiqYjk8znsQ9PKxnHb+kFY4IWoJoE1FF1DzWm15AiqEF9ckjaDWV0A6f
 tPtNpVMobpXk5LUREsPDt25nt6RkZgqbdgdOHUoZUPeTGLyAUZNQG2tlRE3J2X7uqpbC
 8Oew==
X-Gm-Message-State: AOAM531lztpLVuXzIAyFcSvCJDSwjGfjzdukglCGvxSozxnhLXcXftdb
 g96ii8A5B5ZOIOwvkvveIaGxfRzvfWU=
X-Google-Smtp-Source: ABdhPJw4f4/voRxb0xXPFNT+rq0rQnSg1TwSBIEaiOSR4mzrEZAZp1YmF5XBLZs+tg0K7NHBTbfgA7u7PCM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:408:: with SMTP id
 z8mr19753705qvx.21.1632186099152; Mon, 20 Sep 2021 18:01:39 -0700 (PDT)
Date: Tue, 21 Sep 2021 01:01:20 +0000
In-Reply-To: <20210921010120.1256762-1-oupton@google.com>
Message-Id: <20210921010120.1256762-3-oupton@google.com>
Mime-Version: 1.0
References: <20210921010120.1256762-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH 2/2] selftests: KVM: Fix 'asm-operand-width' warnings in
 steal_time.c
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>
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

Building steal_time.c for arm64 with clang throws the following:

>> steal_time.c:130:22: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
          : "=r" (ret) : "r" (func), "r" (arg) :
                              ^
>> steal_time.c:130:34: error: value size does not match register size specified by the constraint and modifier [-Werror,-Wasm-operand-widths]
          : "=r" (ret) : "r" (func), "r" (arg) :
                                          ^

Silence by casting operands to 64 bits.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/steal_time.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/selftests/kvm/steal_time.c
index ecec30865a74..eb75b31122c5 100644
--- a/tools/testing/selftests/kvm/steal_time.c
+++ b/tools/testing/selftests/kvm/steal_time.c
@@ -127,7 +127,7 @@ static int64_t smccc(uint32_t func, uint32_t arg)
 		"mov	x1, %2\n"
 		"hvc	#0\n"
 		"mov	%0, x0\n"
-	: "=r" (ret) : "r" (func), "r" (arg) :
+	: "=r" (ret) : "r" ((uint64_t)func), "r" ((uint64_t)arg) :
 	  "x0", "x1", "x2", "x3");
 
 	return ret;
-- 
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
