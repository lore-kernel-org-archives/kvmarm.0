Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60BCFC43460
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 10:18:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C1CC261428
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 10:18:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C1CC261428
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6216E4B238;
	Wed, 28 Apr 2021 06:18:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p23lDgsww8-1; Wed, 28 Apr 2021 06:18:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 59F3F4B23A;
	Wed, 28 Apr 2021 06:18:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9DE4B22E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 06:18:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pgAzri7f1coj for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 06:18:49 -0400 (EDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7AD664B22B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 06:18:49 -0400 (EDT)
Received: by mail-wr1-f54.google.com with SMTP id h4so53384873wrt.12
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 03:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=h0nQnWfRsJ4H9fZ4V8oB0e3t3FwopAIx7BelND6opc4=;
 b=bXzFmQP1exjyRE4ikU7o5JEDc/TxB2cHiu9Lh59XBAJr+A3q4lARBvXmVMzRNrMj5L
 vjQJBVkXOC65HWb6w/qD1dmG8PVFdbanqJ2laZYgQq13ex4X9vXw+PPX/Zb7R3PrC+Ad
 R5Awbdh6Ev+31y58S3A+X3ushs8Rd1m6WW8Sgw4QMJc0hPQ5X+ky1FvjHRFvWutikyqN
 FmckXdM8YadSOzFWOHXv/ch+cwdB0Ghq5vu7RrFMAYpRW3zkAHvZLuRPyOVSZWtnTYrU
 J1mHfdZGgz+Sq1mGKTs8nq3/sqUOHcrxOS9ChhVQKsS+WoN9knT9GVVSSRh6Rianlb7V
 ipTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=h0nQnWfRsJ4H9fZ4V8oB0e3t3FwopAIx7BelND6opc4=;
 b=TsS244rXpwWvrW9yaJYU5POyP4kIOOoBo5KeYULlLYygaFvwXWfoGD1Mp9JRx/FPr0
 ti3Gy7YfyVElPmZB2Wz/XkLLpC4rMMrxPGWFPdXyBWz7px/nKYc5u9A2xqgl9y7pfcOj
 LIWwQd17VaYejBrSaTDD+/CalkxEQXsLMT73TImOqIQYyR7fJ21q276JdrQrl7rw6+P2
 Y1wSeUpJbcu7lp/zLKJvGCHXQzr7GuDsunoE8/dcA6RdOVlJBVvKpZrItx1HOkXAwVr3
 9j4L9fQFp8TZkZgkb8XOR3yrED69I1zIf6mroQ5mnHVY0XBQhSMEsiR9uSYyJkoSF3yi
 E/qA==
X-Gm-Message-State: AOAM530WbZ6/XQPCpSgT8cFOk3dge6lnb4dm7oCGeew864n2ejw+hNZQ
 MWk7fKw7B+DWRNwM7oE1fWPNcQ==
X-Google-Smtp-Source: ABdhPJyF87c/fp1iN0zpxYpXE/1Gh0VymotpoSflP0pBM80ElDhXfzZRhRVKwFGRvGOg2YP67jblyQ==
X-Received: by 2002:a05:6000:1564:: with SMTP id
 4mr35151201wrz.197.1619605128646; 
 Wed, 28 Apr 2021 03:18:48 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id g5sm7632844wrq.30.2021.04.28.03.18.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 28 Apr 2021 03:18:44 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 410151FF8F;
 Wed, 28 Apr 2021 11:18:44 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 3/4] arm64: enable its-migration tests for
 TCG
Date: Wed, 28 Apr 2021 11:18:43 +0100
Message-Id: <20210428101844.22656-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210428101844.22656-1-alex.bennee@linaro.org>
References: <20210428101844.22656-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Cc: maz@kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

V2l0aCB0aGUgc3VwcG9ydCBmb3IgVENHIGVtdWxhdGVkIEdJQyB3ZSBjYW4gYWxzbyB0ZXN0IHRo
ZXNlIG5vdy4gWW91Cm5lZWQgdG8gY2FsbCBydW5fdGVzdHMuc2ggd2l0aCAtYSB0byB0cmlnZ2Vy
IHRoZQppdHMtbWlncmF0ZS11bm1hcHBlZC1jb2xsZWN0aW9uIHRlc3Qgd2hpY2ggb2J2aW91c2x5
IGRvZXNuJ3QgbmVlZCB0aGUKS1ZNIGVycmF0YSB0byBydW4gaW4gVENHIHN5c3RlbSBlbXVsYXRp
b24gbW9kZS4KClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJv
Lm9yZz4KLS0tCiBhcm0vdW5pdHRlc3RzLmNmZyB8IDMgLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcm0vdW5pdHRlc3RzLmNmZyBiL2FybS91bml0dGVz
dHMuY2ZnCmluZGV4IGM3MmRjMzQuLmQ0ZGJjOGIgMTAwNjQ0Ci0tLSBhL2FybS91bml0dGVzdHMu
Y2ZnCisrKyBiL2FybS91bml0dGVzdHMuY2ZnCkBAIC0yMDMsNyArMjAzLDYgQEAgYXJjaCA9IGFy
bTY0CiBbaXRzLW1pZ3JhdGlvbl0KIGZpbGUgPSBnaWMuZmxhdAogc21wID0gJE1BWF9TTVAKLWFj
Y2VsID0ga3ZtCiBleHRyYV9wYXJhbXMgPSAtbWFjaGluZSBnaWMtdmVyc2lvbj0zIC1hcHBlbmQg
J2l0cy1taWdyYXRpb24nCiBncm91cHMgPSBpdHMgbWlncmF0aW9uCiBhcmNoID0gYXJtNjQKQEAg
LTIxMSw3ICsyMTAsNiBAQCBhcmNoID0gYXJtNjQKIFtpdHMtcGVuZGluZy1taWdyYXRpb25dCiBm
aWxlID0gZ2ljLmZsYXQKIHNtcCA9ICRNQVhfU01QCi1hY2NlbCA9IGt2bQogZXh0cmFfcGFyYW1z
ID0gLW1hY2hpbmUgZ2ljLXZlcnNpb249MyAtYXBwZW5kICdpdHMtcGVuZGluZy1taWdyYXRpb24n
CiBncm91cHMgPSBpdHMgbWlncmF0aW9uCiBhcmNoID0gYXJtNjQKQEAgLTIxOSw3ICsyMTcsNiBA
QCBhcmNoID0gYXJtNjQKIFtpdHMtbWlncmF0ZS11bm1hcHBlZC1jb2xsZWN0aW9uXQogZmlsZSA9
IGdpYy5mbGF0CiBzbXAgPSAkTUFYX1NNUAotYWNjZWwgPSBrdm0KIGV4dHJhX3BhcmFtcyA9IC1t
YWNoaW5lIGdpYy12ZXJzaW9uPTMgLWFwcGVuZCAnaXRzLW1pZ3JhdGUtdW5tYXBwZWQtY29sbGVj
dGlvbicKIGdyb3VwcyA9IGl0cyBtaWdyYXRpb24KIGFyY2ggPSBhcm02NAotLSAKMi4yMC4xCgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFp
bGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5j
b2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
