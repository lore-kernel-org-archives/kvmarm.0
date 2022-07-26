Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F276AC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE4744C549;
	Tue, 26 Jul 2022 03:38:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oTwjJeOsnjpA; Tue, 26 Jul 2022 03:38:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 897764C54B;
	Tue, 26 Jul 2022 03:38:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEDD04C549
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OjSkZ4Y6TF+y for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:10 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A51544C53A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:10 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-31f49eea05fso4816907b3.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc:content-transfer-encoding;
 bh=VavrLtXbRNR5iYY6DuWJsiPM2oJzRiMbR593lo0d1Rw=;
 b=j96IaEX62h71DWb6L/1x3UIPVuOe11L4SskRUNLfEpqgu2vu4jVoT7hkbCAryRObVn
 Zi9PUjFc3msAp6dAeAxLeAvs5ursb0jnWMfa66uohrRUKiYMKU6skuOaJAlmHKMEnNXn
 osaNYizMUsQjs8peiYd/0YDjLYH7izn6TGf8Vejoqckt5OSYyCR7wAWcWajSZnntZDeQ
 G8qLCUQzdjzgvYlwgCnfYmJjBnkmOh5UZMKCFOUAbItZYA5Di/+5IJKFfMmR5lxLeFg+
 6H5z7pSY/XdyftcagV0boM4TJERzjbvtdEnrnWDxPwe3kwN/CDSKVtd3hu6+6QLzA8Z7
 0jDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc:content-transfer-encoding;
 bh=VavrLtXbRNR5iYY6DuWJsiPM2oJzRiMbR593lo0d1Rw=;
 b=CZTnyJMI3fCq7/9NL9btStopfcYqAG0fmjqI1LMH4oeDCK4TM1316g+UZgh2lkJyyn
 OlarPRohZyrUdqCQr/33KnwV7E2uRBuU1PXtluBcuFgWTOFR8XtbFssZ5ZtyV0/btFnc
 4+awLDtYhfd1d7I6imt2WCNYNa/No1iT1sxf4M1TUh1LhdcBF2dTsTEtHUrYkzCOa6o5
 0+qMHB10zbJ5YLp9w3skT6YvhXfnppfzOIriQ45mTmPEM1IDBsy6PMvV1MmIIgaT3IgN
 roElLP4ejKsycW535T8Lg2qd+uptZTEYIJE1SxQwx/FmAIHOV17UjyI2SLL+uMTLNmeI
 +uYg==
X-Gm-Message-State: AJIora/k/mNEQ85cRR6CBCFz5/ACf5GuI4waG+n2D/G6dc7s8z4C2h7C
 l9j1JPLafSO2OltU2lfdAH6BlBHqlacyKaUPkw==
X-Google-Smtp-Source: AGRyM1uLngP1y5rfZv7qcR91UDrsOk5KX5o+Z2nFXgrbRkoOxYN5kjOvh7dIZvVEJTbG63rkQ3WbCIEv9Qf04bN+kA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a81:1b97:0:b0:2db:640f:49d8 with SMTP
 id b145-20020a811b97000000b002db640f49d8mr13021154ywb.326.1658821090210; Tue,
 26 Jul 2022 00:38:10 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:39 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-7-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 06/17] arm64: stacktrace: Add description of
 stacktrace/common.h
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, elver@google.com,
 linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

QWRkIGJyaWVmIGRlc2NyaXB0aW9uIG9uIGhvdyB0byB1c2Ugc3RhY2t0cmFjZS9jb21tb24uaCB0
byBpbXBsZW1lbnQKYSBzdGFjayB1bndpbmRlci4KClNpZ25lZC1vZmYtYnk6IEthbGVzaCBTaW5n
aCA8a2FsZXNoc2luZ2hAZ29vZ2xlLmNvbT4KUmV2aWV3ZWQtYnk6IEZ1YWQgVGFiYmEgPHRhYmJh
QGdvb2dsZS5jb20+Ci0tLQoKQ2hhbmdlcyBpbiB2NjoKICAtIEFkZCBGdWFk4oCZcyBSZXZpZXdl
ZC1ieSB0YWcKCkNoYW5nZXMgaW4gdjU6CiAgLSBBZGQgc2hvcnQgZGVzY3JpcHRpb24gb2YgZWFj
aCByZXF1aXJlZCBmdW5jdGlvbiwgcGVyIEZ1YWQgYW5kIE1hcmMKCiBhcmNoL2FybTY0L2luY2x1
ZGUvYXNtL3N0YWNrdHJhY2UvY29tbW9uLmggfCAxNSArKysrKysrKysrKysrKysKIDEgZmlsZSBj
aGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9zdGFja3RyYWNlL2NvbW1vbi5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zdGFja3Ry
YWNlL2NvbW1vbi5oCmluZGV4IDRiNjMyMTQxZDkxYy4uNDU0NzRiMzgzNjMwIDEwMDY0NAotLS0g
YS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N0YWNrdHJhY2UvY29tbW9uLmgKKysrIGIvYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9zdGFja3RyYWNlL2NvbW1vbi5oCkBAIC0yLDYgKzIsMjEgQEAKIC8q
CiAgKiBDb21tb24gYXJtNjQgc3RhY2sgdW53aW5kZXIgY29kZS4KICAqCisgKiBUbyBpbXBsZW1l
bnQgYSBuZXcgYXJtNjQgc3RhY2sgdW53aW5kZXI6CisgKiAgICAgMSkgSW5jbHVkZSB0aGlzIGhl
YWRlcgorICoKKyAqICAgICAyKSBQcm92aWRlIGltcGxlbWVudGF0aW9ucyBmb3IgdGhlIGZvbGxv
d2luZyBmdW5jdGlvbnM6CisgKiAgICAgICAgICBvbl9vdmVyZmxvd19zdGFjaygpOiAgIFJldHVy
bnMgdHJ1ZSBpZiBTUCBpcyBvbiB0aGUgb3ZlcmZsb3cKKyAqICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgc3RhY2suCisgKiAgICAgICAgICBvbl9hY2Nlc3NpYmxlX3N0YWNrKCk6IFJl
dHVybnMgdHJ1ZSBpcyBTUCBpcyBvbiBhbnkgYWNjZXNzaWJsZQorICogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBzdGFjay4KKyAqICAgICAgICAgIHVud2luZF9uZXh0KCk6ICAgICAg
ICAgUGVyZm9ybXMgdmFsaWRhdGlvbiBjaGVja3Mgb24gdGhlIGZyYW1lCisgKiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHBvaW50ZXIsIGFuZCB0cmFuc2l0aW9ucyB1bndpbmRfc3Rh
dGUKKyAqICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdG8gdGhlIG5leHQgZnJhbWUu
CisgKgorICogICAgICAgICBTZWU6IGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3RhY2t0cmFjZS5o
IGZvciByZWZlcmVuY2UKKyAqICAgICAgICAgICAgICBpbXBsZW1lbnRhdGlvbnMuCisgKgogICog
Q29weXJpZ2h0IChDKSAyMDEyIEFSTSBMdGQuCiAgKi8KICNpZm5kZWYgX19BU01fU1RBQ0tUUkFD
RV9DT01NT05fSAotLSAKMi4zNy4xLjM1OS5nZDEzNmM2YzNlMi1nb29nCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
