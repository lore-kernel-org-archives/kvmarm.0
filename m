Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A675DC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:38 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 665944BBDA;
	Tue, 26 Jul 2022 03:38:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bfydnL17fsSU; Tue, 26 Jul 2022 03:38:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A5494C567;
	Tue, 26 Jul 2022 03:38:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F1A14C536
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J0lxRZoGYnNo for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:35 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED00A4C54C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:34 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 t10-20020a5b07ca000000b0066ec1bb6e2cso10435989ybq.14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc:content-transfer-encoding;
 bh=4z4Kz5jKP4bI+UOP9DxU3eg2/YP+oU3Smm0rFqPcsng=;
 b=Z1P1ClfItoh79aQ1b/7uN6+YG8sXdaRGbHmm2Km3lpRCBNERxYfC45wuUnV22xDrKr
 C7P7sOnzNuqntBLF3F+6jM28iGWBmjuZh/onAiogWA6nkl+pQMh/hkru3m8yOoDZtCiz
 YUeV/q7yT+eI6gJO0z3Jk1qzCMVZ8PnFyCNSgqN/dWdmju6ronRybvKXvcqMM82Etntz
 YLHXZQ84XUWvCivtFflxyQq6fJhEpglvw3cFqVdjfvpGM1UsagOmmxxMaKcMmpN6dr59
 S8axA/CrLXVHIAUBmzb2I9dpWg+mkbpuBU7UpOLEQXfqv2pHnmn4tY3D3DSea9NPICrl
 o61w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc:content-transfer-encoding;
 bh=4z4Kz5jKP4bI+UOP9DxU3eg2/YP+oU3Smm0rFqPcsng=;
 b=O52WbzyeEMmUE6pSAKGvds15iqfNPYlvr4GPWz4DKqcHiiTdZ2RKvjxZtUqqniFAN6
 JLNlh6t4Tz26GOQK2lNkdd+PSC7+xRRUPLigKhlquaJ9Al5QU5bP80wn4/VIJqkX93N0
 i2qBLu0DrSs2F/YH6vbOcJ+E2W9AYzgIgkkAmy3f8GIL+VFhjipQTMaIPg9Y6UArraF9
 bHNATcQkCB3zKrhuiQyZX7MSspuNCVDxQ7RDDiU4mpMkDE+r0myoB5ae04GZOwv5tKlF
 F6qyq/xSyOZSgjBojd6uQyMEaGbltC6Fc2jk5N/VcIA6alimK5kM1laL8BVP4HgoKY1f
 oBxw==
X-Gm-Message-State: AJIora/GjJrmWIi7lGC+aNZ3VXbZwLIME98IRykb2+6iv23qcw5Inq/l
 9GvYsB8+PLqcEO1cF1UnLd2ti8FGxIcdQLGGmw==
X-Google-Smtp-Source: AGRyM1s+nZYFqneaUWZhKYAd3zQF7L0Cwai3ur8Rv5PlGmwq+xCSduNXnxJSHkCKOQUTBjw9Sv3BBmCbw3HEDJGUpA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a81:1e49:0:b0:31e:5b13:a187 with SMTP
 id e70-20020a811e49000000b0031e5b13a187mr13741284ywe.129.1658821114535; Tue,
 26 Jul 2022 00:38:34 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:49 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-17-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 16/17] KVM: arm64: Implement protected nVHE hyp stack
 unwinder
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

SW1wbGVtZW50cyB0aGUgY29tbW9uIGZyYW1ld29yayBuZWNlc3NhcnkgZm9yIHVud2luZCgpIHRv
IHdvcmsgaW4KdGhlIHByb3RlY3RlZCBuVkhFIGNvbnRleHQ6CiAgIC0gb25fYWNjZXNzaWJsZV9z
dGFjaygpCiAgIC0gb25fb3ZlcmZsb3dfc3RhY2soKQogICAtIHVud2luZF9uZXh0KCkKClByb3Rl
Y3RlZCBuVkhFIHVud2luZCgpIGlzIHVzZWQgdG8gdW53aW5kIGFuZCBzYXZlIHRoZSBoeXAgc3Rh
Y2sKYWRkcmVzc2VzIHRvIHRoZSBzaGFyZWQgc3RhY2t0cmFjZSBidWZmZXIuIFRoZSBob3N0IHJl
YWRzIHRoZQplbnRyaWVzIGluIHRoaXMgYnVmZmVyLCBzeW1ib2xpemVzIGFuZCBkdW1wcyB0aGUg
c3RhY2t0cmFjZSAobGF0ZXIKcGF0Y2ggaW4gdGhlIHNlcmllcykuCgpTaWduZWQtb2ZmLWJ5OiBL
YWxlc2ggU2luZ2ggPGthbGVzaHNpbmdoQGdvb2dsZS5jb20+ClJldmlld2VkLWJ5OiBGdWFkIFRh
YmJhIDx0YWJiYUBnb29nbGUuY29tPgpUZXN0ZWQtYnk6IEZ1YWQgVGFiYmEgPHRhYmJhQGdvb2ds
ZS5jb20+Ci0tLQoKQ2hhbmdlcyBpbiB2NjoKICAtIEFkZCBGdWFk4oCZcyBSZXZpZXdlZC1ieSBh
bmQgVGVzdGVkLWJ5IHRhZ3MKCiBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N0YWNrdHJhY2UvbnZo
ZS5oIHwgMTUgKysrKysrKysrKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygr
KSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N0
YWNrdHJhY2UvbnZoZS5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zdGFja3RyYWNlL252aGUu
aAppbmRleCAyY2U1OWMwNTg4MDYuLjYwMGRiYzIyMjBiNiAxMDA2NDQKLS0tIGEvYXJjaC9hcm02
NC9pbmNsdWRlL2FzbS9zdGFja3RyYWNlL252aGUuaAorKysgYi9hcmNoL2FybTY0L2luY2x1ZGUv
YXNtL3N0YWNrdHJhY2UvbnZoZS5oCkBAIC02NCwxOCArNjQsMjcgQEAgc3RhdGljIGlubGluZSBi
b29sIG9uX2FjY2Vzc2libGVfc3RhY2soY29uc3Qgc3RydWN0IHRhc2tfc3RydWN0ICp0c2ssCiBz
dGF0aWMgaW5saW5lIGJvb2wgb25fb3ZlcmZsb3dfc3RhY2sodW5zaWduZWQgbG9uZyBzcCwgdW5z
aWduZWQgbG9uZyBzaXplLAogCQkJCSAgICAgc3RydWN0IHN0YWNrX2luZm8gKmluZm8pCiB7Ci0J
cmV0dXJuIGZhbHNlOworCXVuc2lnbmVkIGxvbmcgbG93ID0gKHVuc2lnbmVkIGxvbmcpdGhpc19j
cHVfcHRyKG92ZXJmbG93X3N0YWNrKTsKKwl1bnNpZ25lZCBsb25nIGhpZ2ggPSBsb3cgKyBPVkVS
RkxPV19TVEFDS19TSVpFOworCisJcmV0dXJuIG9uX3N0YWNrKHNwLCBzaXplLCBsb3csIGhpZ2gs
IFNUQUNLX1RZUEVfT1ZFUkZMT1csIGluZm8pOwogfQogCiBzdGF0aWMgaW5saW5lIGJvb2wgb25f
aHlwX3N0YWNrKHVuc2lnbmVkIGxvbmcgc3AsIHVuc2lnbmVkIGxvbmcgc2l6ZSwKIAkJCQlzdHJ1
Y3Qgc3RhY2tfaW5mbyAqaW5mbykKIHsKLQlyZXR1cm4gZmFsc2U7CisJc3RydWN0IGt2bV9udmhl
X2luaXRfcGFyYW1zICpwYXJhbXMgPSB0aGlzX2NwdV9wdHIoJmt2bV9pbml0X3BhcmFtcyk7CisJ
dW5zaWduZWQgbG9uZyBoaWdoID0gcGFyYW1zLT5zdGFja19oeXBfdmE7CisJdW5zaWduZWQgbG9u
ZyBsb3cgPSBoaWdoIC0gUEFHRV9TSVpFOworCisJcmV0dXJuIG9uX3N0YWNrKHNwLCBzaXplLCBs
b3csIGhpZ2gsIFNUQUNLX1RZUEVfSFlQLCBpbmZvKTsKIH0KIAogc3RhdGljIGlubGluZSBpbnQg
bm90cmFjZSB1bndpbmRfbmV4dChzdHJ1Y3QgdW53aW5kX3N0YXRlICpzdGF0ZSkKIHsKLQlyZXR1
cm4gMDsKKwlzdHJ1Y3Qgc3RhY2tfaW5mbyBpbmZvOworCisJcmV0dXJuIHVud2luZF9uZXh0X2Nv
bW1vbihzdGF0ZSwgJmluZm8sIE5VTEwpOwogfQogTk9LUFJPQkVfU1lNQk9MKHVud2luZF9uZXh0
KTsKICNlbmRpZgkvKiBDT05GSUdfUFJPVEVDVEVEX05WSEVfU1RBQ0tUUkFDRSAqLwotLSAKMi4z
Ny4xLjM1OS5nZDEzNmM2YzNlMi1nb29nCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
