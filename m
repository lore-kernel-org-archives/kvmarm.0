Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82EBFC43334
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E7394C53A;
	Tue, 26 Jul 2022 03:38:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j5RJ25CEztcX; Tue, 26 Jul 2022 03:38:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E56BD4C568;
	Tue, 26 Jul 2022 03:38:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76B8C4C53A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3E885UoiZw2Z for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:15 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 37E7D4C437
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:15 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31e9b1be83eso87093277b3.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc:content-transfer-encoding;
 bh=i3lgJjiT46mrfMrlOUzdDB8/4iw1XwFuVsxnh7Km3KU=;
 b=WOkwBJsq6ZjTSMovFjTZSwD8sMa0HEZuNKHEgdh0voOyB5tJv9hkeQ+fZDL1k9LQcl
 HdmKNrGKCbOT5bEqpnEt7rwEAZDZ+0zTSWbaLPiU0AqMqsipdiozcfCUa9u6bPIBOatS
 vWPrP5aG+wSpIvX8sr/94a4xqITU92dSLf2AYfmTEoqKskq1JhQN2gcbTTrtvANOu5eO
 1vVBWRdSsgYX2zoljGCoDswSlE7tA3EoGUGyC5jpvxoGAWjlU43CU5+5obQRNcLBOQGL
 H7NE9oMLvMbY89vNyCOO9gqAaCApSjv9H1wQVr4qEtQwGbYboXkRvHJugniaI+3iDPfl
 O31w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc:content-transfer-encoding;
 bh=i3lgJjiT46mrfMrlOUzdDB8/4iw1XwFuVsxnh7Km3KU=;
 b=f5wkRsn/vD4OxPGYHjSApH3CfuEBiz+QN/OPQ8fsUgsyqeYkkVzcx/b4JKEMo++4si
 zNsqHredRdU7KfloidCoRX7iUSrXVPWlRFsQa3ttZxA5r1NdyOvwHzzq1AwiKP+x/h13
 1Hmv+kAobpnXQSZ1v4N3NCuxZf2QED0ySdEgd9MqY3NMmfEBHYuMiHcz/Yg0azH9V64k
 B8MtfMGhdTxBJY/ReoIeI1WHlGwPqXb66Nji8sgr1jZnmegsFlpYkjt6Sghtz0ad+lT+
 z8LRQ0PRM/TXf8aHK4rgaqQPjJxqKrIlP0bANGPNHore5jnXzhmG2EcNe92EzciJcMnH
 aDNw==
X-Gm-Message-State: AJIora/1VUwc9DHM5ac24FC2ItP/jdrF/a8O/MQ3lYtq/fpfUBrp0paM
 ZP7yQUJpNpZ15rxw+M8M9eMCxMvlqtyYJ3cSag==
X-Google-Smtp-Source: AGRyM1uSyW7sYTMSgC+uaW3gfAmuo2IndnCXRVAcmDi9a0epcfogUXoXeu1EIc1/i1iJusQo8hJnHjXzlwV/bKaYCw==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a25:9e92:0:b0:66e:c03e:c632 with SMTP
 id p18-20020a259e92000000b0066ec03ec632mr12231031ybq.279.1658821094784; Tue,
 26 Jul 2022 00:38:14 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:41 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-9-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 08/17] KVM: arm64: Stub implementation of non-protected
 nVHE HYP stack unwinder
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

QWRkIHN0dWIgaW1wbGVtZW50YXRpb25zIG9mIG5vbi1wcm90ZWN0ZWQgblZIRSBzdGFjayB1bndp
bmRlciwgZm9yCmJ1aWxkaW5nLiBUaGVzZSBhcmUgaW1wbGVtZW50ZWQgbGF0ZXIgaW4gdGhpcyBz
ZXJpZXMuCgpTaWduZWQtb2ZmLWJ5OiBLYWxlc2ggU2luZ2ggPGthbGVzaHNpbmdoQGdvb2dsZS5j
b20+ClJldmlld2VkLWJ5OiBGdWFkIFRhYmJhIDx0YWJiYUBnb29nbGUuY29tPgpUZXN0ZWQtYnk6
IEZ1YWQgVGFiYmEgPHRhYmJhQGdvb2dsZS5jb20+Ci0tLQoKQ2hhbmdlcyBpbiB2NjoKICAtIEFk
ZCBGdWFk4oCZcyBSZXZpZXdlZC1ieSBhbmQgVGVzdGVkLWJ5IHRhZ3MKCkNoYW5nZXMgaW4gdjU6
CiAgLSBNYXJrIHVud2luZF9uZXh0KCkgYXMgaW5saW5lLCBwZXIgTWFyYwogIC0gQ29tbWVudCAh
X19LVk1fTlZIRV9IWVBFUlZJU09SX18gdW53aW5kZXIgcGF0aCwgcGVyIE1hcmMKCiBhcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL3N0YWNrdHJhY2UvbnZoZS5oIHwgNDcgKysrKysrKysrKysrKysrKysr
KysrKysrCiAxIGZpbGUgY2hhbmdlZCwgNDcgaW5zZXJ0aW9ucygrKQogY3JlYXRlIG1vZGUgMTAw
NjQ0IGFyY2gvYXJtNjQvaW5jbHVkZS9hc20vc3RhY2t0cmFjZS9udmhlLmgKCmRpZmYgLS1naXQg
YS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N0YWNrdHJhY2UvbnZoZS5oIGIvYXJjaC9hcm02NC9p
bmNsdWRlL2FzbS9zdGFja3RyYWNlL252aGUuaApuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAw
MDAwMDAwMDAwMDAuLjExOTJhZTBmODBjMQotLS0gL2Rldi9udWxsCisrKyBiL2FyY2gvYXJtNjQv
aW5jbHVkZS9hc20vc3RhY2t0cmFjZS9udmhlLmgKQEAgLTAsMCArMSw0NyBAQAorLyogU1BEWC1M
aWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seSAqLworLyoKKyAqIEtWTSBuVkhFIGh5cGVy
dmlzb3Igc3RhY2sgdHJhY2luZyBzdXBwb3J0LgorICoKKyAqIFRoZSB1bndpbmRlciBpbXBsZW1l
bnRhdGlvbiBkZXBlbmRzIG9uIHRoZSBuVkhFIG1vZGU6CisgKgorICogICAxKSBOb24tcHJvdGVj
dGVkIG5WSEUgbW9kZSAtIHRoZSBob3N0IGNhbiBkaXJlY3RseSBhY2Nlc3MgdGhlCisgKiAgICAg
IEhZUCBzdGFjayBwYWdlcyBhbmQgdW53aW5kIHRoZSBIWVAgc3RhY2sgaW4gRUwxLiBUaGlzIHNh
dmVzIGhhdmluZworICogICAgICB0byBhbGxvY2F0ZSBzaGFyZWQgYnVmZmVycyBmb3IgdGhlIGhv
c3QgdG8gcmVhZCB0aGUgdW53aW5kZWQKKyAqICAgICAgc3RhY2t0cmFjZS4KKyAqCisgKiBDb3B5
cmlnaHQgKEMpIDIwMjIgR29vZ2xlIExMQworICovCisjaWZuZGVmIF9fQVNNX1NUQUNLVFJBQ0Vf
TlZIRV9ICisjZGVmaW5lIF9fQVNNX1NUQUNLVFJBQ0VfTlZIRV9ICisKKyNpbmNsdWRlIDxhc20v
c3RhY2t0cmFjZS9jb21tb24uaD4KKworc3RhdGljIGlubGluZSBib29sIG9uX2FjY2Vzc2libGVf
c3RhY2soY29uc3Qgc3RydWN0IHRhc2tfc3RydWN0ICp0c2ssCisJCQkJICAgICAgIHVuc2lnbmVk
IGxvbmcgc3AsIHVuc2lnbmVkIGxvbmcgc2l6ZSwKKwkJCQkgICAgICAgc3RydWN0IHN0YWNrX2lu
Zm8gKmluZm8pCit7CisJcmV0dXJuIGZhbHNlOworfQorCisjaWZuZGVmIF9fS1ZNX05WSEVfSFlQ
RVJWSVNPUl9fCisvKgorICogQ29udmVudGlvbmFsIChub24tcHJvdGVjdGVkKSBuVkhFIEhZUCBz
dGFjayB1bndpbmRlcgorICoKKyAqIEluIG5vbi1wcm90ZWN0ZWQgbW9kZSwgdGhlIHVud2luZGlu
ZyBpcyBkb25lIGZyb20ga2VybmVsIHByb3BlciBjb250ZXh0CisgKiAoYnkgdGhlIGhvc3QgaW4g
RUwxKS4KKyAqLworCitzdGF0aWMgaW5saW5lIGJvb2wgb25fb3ZlcmZsb3dfc3RhY2sodW5zaWdu
ZWQgbG9uZyBzcCwgdW5zaWduZWQgbG9uZyBzaXplLAorCQkJCSAgICAgc3RydWN0IHN0YWNrX2lu
Zm8gKmluZm8pCit7CisJcmV0dXJuIGZhbHNlOworfQorCitzdGF0aWMgaW5saW5lIGludCBub3Ry
YWNlIHVud2luZF9uZXh0KHN0cnVjdCB1bndpbmRfc3RhdGUgKnN0YXRlKQoreworCXJldHVybiAw
OworfQorTk9LUFJPQkVfU1lNQk9MKHVud2luZF9uZXh0KTsKKworI2VuZGlmCS8qICFfX0tWTV9O
VkhFX0hZUEVSVklTT1JfXyAqLworI2VuZGlmCS8qIF9fQVNNX1NUQUNLVFJBQ0VfTlZIRV9IICov
Ci0tIAoyLjM3LjEuMzU5LmdkMTM2YzZjM2UyLWdvb2cKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3Rz
LmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xp
c3RpbmZvL2t2bWFybQo=
