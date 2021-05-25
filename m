Return-Path: <SRS0=drPj=KU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4DADC2B9F8
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 17:42:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1CBCF61400
	for <kvmarm@archiver.kernel.org>; Tue, 25 May 2021 17:42:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CBCF61400
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 732F64B0C9;
	Tue, 25 May 2021 13:42:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WHC+12oz6PbA; Tue, 25 May 2021 13:42:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0803E4B0C6;
	Tue, 25 May 2021 13:42:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7363E4B0C0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 13:42:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DxzER-iuYZtj for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 May 2021 13:42:35 -0400 (EDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5785C4A551
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 13:42:35 -0400 (EDT)
Received: by mail-wm1-f49.google.com with SMTP id b7so16618085wmh.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 May 2021 10:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=xRd9XsO+PDr6n4FeCOKrjoZ73C+wdSaKiGHr6cRSi/o=;
 b=lcuvChzJ8BN2TYlPcmvvAZ5Q1xMlrBmS6r7ceo1rAACSz8yGjYpW+/iucHYFCQ0Wtd
 6w0DRSeHgsM28X67c9WCerAUnRIiXLyA0Wi7Ni8yoZc7SJ+HtTx2oio0cOFQA6fzRa0B
 ApTF3w5tVirxlb7+AohSilHxlzQwyDv+MexiO+tDQGOcseSL09qetYIZS4pPRsmYGJMm
 N5WHGRY+kRtvDtApIvxHS0tn8Y8N1Rvc7YA4CWBuWvPEH4ctTCXt22B3tF8ft69JgPiI
 IgfwpdhDSf+t6Ai7635kgD4PE1ZBCb9vdU/puofaNvmoQaBY2eDAKLfR7qPbp9lMt0pH
 BmDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=xRd9XsO+PDr6n4FeCOKrjoZ73C+wdSaKiGHr6cRSi/o=;
 b=hSxJo0rFZz4p6xnxuMMUHw8elVfYkmUz0lYRqH0QspinXCWbhqrSENkPuqunGZfJjy
 SR+JVzg7SF++TFQeleTar9JU8vrMttQyQoVe+uvuvR6mE6+Ch++ZDBtSpoYY+gEh5RqQ
 4uLYk25C5fsCvjxdOobWZcLaEIDlVLQWAlb7cujeUDRKXX1Uc+6FUC30BBDQUlX2eEwH
 a0E17ZlfXFsUwsx2le74alplvMwKhGqeJ8Xez4Ao/6LLymw1UnhnTUyz6EG8hObPQTdO
 sck6EhJoFgx4NtWj0k4uTuxDz4gfjekO3Y6w++HhsVY6IceTpCGFVTrMfLz6kwLJf4py
 NKYQ==
X-Gm-Message-State: AOAM532lmC2MHpOEIxIvVhUv7ztIOpOCTYdzYSIj8BaN9hDbTjVm/rhr
 8dF2S+7iCNaq+xdnwqM7/8J6hQ==
X-Google-Smtp-Source: ABdhPJxaqQHNaLKGr4fuwt/Q7tHiqBlX9WrKJ8ZFkr85g6fKVEx9BNsMXajWfHgn+YRz4uEKvCtTeg==
X-Received: by 2002:a1c:b646:: with SMTP id g67mr24639077wmf.117.1621964554306; 
 Tue, 25 May 2021 10:42:34 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id d3sm16788921wrs.41.2021.05.25.10.42.32
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 25 May 2021 10:42:32 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id C4ADF1FF7E;
 Tue, 25 May 2021 18:42:31 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, christoffer.dall@arm.com, maz@kernel.org,
 qemu-arm@nongnu.org, qemu-devel@nongnu.org
Subject: [kvm-unit-tests RFC PATCH] arm64: split pmu tests into tcg/kvm
 variants
Date: Tue, 25 May 2021 18:42:21 +0100
Message-Id: <20210525174221.16987-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
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

UUVNVSBpcyBhYmxlIHRvIGdpdmUgYSBjb3VudGVyIGZvciBpbnN0cnVjdGlvbnMgcmV0aXJlZCB1
bmRlciBUQ0cgYnV0CnlvdSBuZWVkIHRvIGVuYWJsZSAtaWNvdW50IGZvciBpdCB0byB3b3JrLiBT
cGxpdCB0aGUgdGVzdHMgaW50bwprdm0vdGNnIHZhcmlhbnRzIHRvIHN1cHBvcnQgdGhpcy4KCltB
SkI6IEkgd29uZGVyIGlmIHRoZSBzb2x1dGlvbiBpcyB0byBoYXZlIGEgdG90YWxseSBzZXBhcmF0
ZQp1bml0dGVzdHMuY2ZnIGZvciBUQ0cgbW9kZSBoZXJlP10KClNpZ25lZC1vZmYtYnk6IEFsZXgg
QmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KLS0tCiBhcm0vdW5pdHRlc3RzLmNmZyB8
IDIwICsrKysrKysrKysrKysrKysrKy0tCiAxIGZpbGUgY2hhbmdlZCwgMTggaW5zZXJ0aW9ucygr
KSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcm0vdW5pdHRlc3RzLmNmZyBiL2FybS91
bml0dGVzdHMuY2ZnCmluZGV4IGFkYzFiYmYuLjJjNGNmNDEgMTAwNjQ0Ci0tLSBhL2FybS91bml0
dGVzdHMuY2ZnCisrKyBiL2FybS91bml0dGVzdHMuY2ZnCkBAIC02NiwyNCArNjYsNDAgQEAgZmls
ZSA9IHBtdS5mbGF0CiBncm91cHMgPSBwbXUKIGV4dHJhX3BhcmFtcyA9IC1hcHBlbmQgJ2N5Y2xl
LWNvdW50ZXIgMCcKIAotW3BtdS1ldmVudC1pbnRyb3NwZWN0aW9uXQorW3BtdS1ldmVudC1pbnRy
b3NwZWN0aW9uLWt2bV0KIGZpbGUgPSBwbXUuZmxhdAogZ3JvdXBzID0gcG11CiBhcmNoID0gYXJt
NjQKK2FjY2VsID0ga3ZtCiBleHRyYV9wYXJhbXMgPSAtYXBwZW5kICdwbXUtZXZlbnQtaW50cm9z
cGVjdGlvbicKIAorW3BtdS1ldmVudC1pbnRyb3NwZWN0aW9uLXRjZ10KK2ZpbGUgPSBwbXUuZmxh
dAorZ3JvdXBzID0gcG11CithcmNoID0gYXJtNjQKK2FjY2VsID0gdGNnCitleHRyYV9wYXJhbXMg
PSAtYXBwZW5kICdwbXUtZXZlbnQtaW50cm9zcGVjdGlvbicgLWljb3VudCBzaGlmdD0xCisKIFtw
bXUtZXZlbnQtY291bnRlci1jb25maWddCiBmaWxlID0gcG11LmZsYXQKIGdyb3VwcyA9IHBtdQog
YXJjaCA9IGFybTY0CiBleHRyYV9wYXJhbXMgPSAtYXBwZW5kICdwbXUtZXZlbnQtY291bnRlci1j
b25maWcnCiAKLVtwbXUtYmFzaWMtZXZlbnQtY291bnRdCitbcG11LWJhc2ljLWV2ZW50LWNvdW50
LWt2bV0KIGZpbGUgPSBwbXUuZmxhdAogZ3JvdXBzID0gcG11CiBhcmNoID0gYXJtNjQKK2FjY2Vs
ID0ga3ZtCiBleHRyYV9wYXJhbXMgPSAtYXBwZW5kICdwbXUtYmFzaWMtZXZlbnQtY291bnQnCiAK
K1twbXUtYmFzaWMtZXZlbnQtY291bnQtdGNnXQorZmlsZSA9IHBtdS5mbGF0Citncm91cHMgPSBw
bXUKK2FyY2ggPSBhcm02NAorYWNjZWwgPSB0Y2cKK2V4dHJhX3BhcmFtcyA9IC1hcHBlbmQgJ3Bt
dS1iYXNpYy1ldmVudC1jb3VudCcgLWljb3VudCBzaGlmdD0xCisKIFtwbXUtbWVtLWFjY2Vzc10K
IGZpbGUgPSBwbXUuZmxhdAogZ3JvdXBzID0gcG11Ci0tIAoyLjIwLjEKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
