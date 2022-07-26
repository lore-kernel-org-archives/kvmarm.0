Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3145CC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3BFE4C54B;
	Tue, 26 Jul 2022 03:38:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ekVelsYoLKAm; Tue, 26 Jul 2022 03:38:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A99144C54C;
	Tue, 26 Jul 2022 03:38:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 360314C547
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fqfGl6fnOMVR for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:28 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A0DA84C54A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:27 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31f3959ba41so21020537b3.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc:content-transfer-encoding;
 bh=Yr2SeyZfI0iUSRRhOZVPZMhkgZCPOBYcwpq2LIzTDZU=;
 b=ld594KmaC+x5hDg3TfDCFLBo3mJAZfZadHtvCv4LxhROGpYJjZU5u3nKSiZtJGEeDg
 IIuDeTXXeGCm/m63A/vVxNjaLgs/Y/a/sPcp5QPfaHOHooP7/BenwvBsnpWGgpYKdke2
 NSEaG4+gALZAkhG6CrQW2qi5i3MnwMxygSzrgKO+y48x97DWG5b6cKMHnWq5gI3k7I8o
 aF84buGLeVeeiDm2loKcvHAEv/qJorx273cBmBrFBtvuFayq67ts1t/eZYcPdJiP1OrJ
 37UDImjN43qQLenhSw1pgI8Q7IZ/5+VyJ8X+qvF10PD0zs4JSX97+y7BUrreFoc3hEaK
 +Rtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc:content-transfer-encoding;
 bh=Yr2SeyZfI0iUSRRhOZVPZMhkgZCPOBYcwpq2LIzTDZU=;
 b=VSDPKpeAuM7BKfSXK0eulUjeVbBb7j/ASamKNyzxRe/iIFRi0O9acFY91Xxd0i131p
 ERC6WpzNVEINAq6RZUw4vILOCDgzfMWmXAD4FNOaQxX9I4lOEPnO4/bjLU3W1256Bv4i
 sdp3dObvQEApAtA5MxrD74W5sW/kIkh+Uc53J6VA5WHo8ajXMeFvI5nqz8vpk5QSLXsq
 XQAhW5f+44sLh5Nn2jua2jKJTPtLFixMkU5l0oQFoda8E40INBJfHhH+mZ9nAKFX87rt
 U96K6rv5T64aZVmgHPntc6sAq492E4jaWzm70Z0zvbO3PE3NA0N9jNX7lVAdxXrj31pV
 Xv2w==
X-Gm-Message-State: AJIora9a+H6ne+aAyuBni2fhSuT2e33nHqBu/A1nYwalCY0N++MnZcLU
 XTp1iK/iTB6p5GemZEw01mjFZroNpVUmE3d3Pw==
X-Google-Smtp-Source: AGRyM1uUV8LVmqLvK9zIG/LZdwQHtzL5gI4YShW6qDDsHeG4grPXlFeu6lQVvyPm5rCyBP47PIGIWuZltzrJGPwwYA==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a81:911:0:b0:31f:4906:80a2 with SMTP
 id 17-20020a810911000000b0031f490680a2mr1032907ywj.351.1658821107235; Tue, 26
 Jul 2022 00:38:27 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:46 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-14-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 13/17] KVM: arm64: Allocate shared pKVM hyp stacktrace
 buffers
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

SW4gcHJvdGVjdGVkIG5WSEUgbW9kZSB0aGUgaG9zdCBjYW5ub3QgZGlyZWN0bHkgYWNjZXNzCmh5
cGVydmlzb3IgbWVtb3J5LCBzbyB3ZSB3aWxsIGR1bXAgdGhlIGh5cGVydmlzb3Igc3RhY2t0cmFj
ZQp0byBhIHNoYXJlZCBidWZmZXIgd2l0aCB0aGUgaG9zdC4KClRoZSBtaW5pbXVtIHNpemUgZm9y
IHRoZSBidWZmZXIgcmVxdWlyZWQsIGFzc3VtaW5nIHRoZSBtaW4gZnJhbWUKc2l6ZSBvZiBbeDI5
LCB4MzBdICgyICogc2l6ZW9mKGxvbmcpKSwgaXMgaGFsZiB0aGUgY29tYmluZWQgc2l6ZSBvZgp0
aGUgaHlwZXJ2aXNvciBhbmQgb3ZlcmZsb3cgc3RhY2tzIHBsdXMgYW4gYWRkaXRpb25hbCBlbnRy
eSB0bwpkZWxpbWl0IHRoZSBlbmQgb2YgdGhlIHN0YWNrdHJhY2UuCgpUaGUgc3RhY2t0cmFjZSBi
dWZmZXJzIGFyZSB1c2VkIGxhdGVyIGluIHRoZSBzZXJpZXMgdG8gZHVtcCB0aGUKblZIRSBoeXBl
cnZpc29yIHN0YWNrdHJhY2Ugd2hlbiB1c2luZyBwcm90ZWN0ZWQtbW9kZS4KClNpZ25lZC1vZmYt
Ynk6IEthbGVzaCBTaW5naCA8a2FsZXNoc2luZ2hAZ29vZ2xlLmNvbT4KUmV2aWV3ZWQtYnk6IEZ1
YWQgVGFiYmEgPHRhYmJhQGdvb2dsZS5jb20+ClRlc3RlZC1ieTogRnVhZCBUYWJiYSA8dGFiYmFA
Z29vZ2xlLmNvbT4KLS0tCgpDaGFuZ2VzIGluIHY2OgogIC0gRml4IHR5cG8gaW4gY29tbWl0IHRl
eHQsIHBlciBGdWFkCiAgLSBBZGQgRnVhZOKAmXMgUmV2aWV3ZWQtYnkgYW5kIFRlc3RlZC1ieSB0
YWdzCgpDaGFuZ2VzIGluIHY1OgogIC0gRml4IHR5cG8gaW4gY29tbWl0IHRleHQsIHBlciBNYXJj
CgogYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9tZW1vcnkuaCAgICAgIHwgOCArKysrKysrKwogYXJj
aC9hcm02NC9rdm0vaHlwL252aGUvc3RhY2t0cmFjZS5jIHwgNCArKysrCiAyIGZpbGVzIGNoYW5n
ZWQsIDEyIGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNt
L21lbW9yeS5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9tZW1vcnkuaAppbmRleCAwYWY3MGQ5
YWJlZGUuLmNhYjgwYTlhNDA4NiAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9t
ZW1vcnkuaAorKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL21lbW9yeS5oCkBAIC0xMTMsNiAr
MTEzLDE0IEBACiAKICNkZWZpbmUgT1ZFUkZMT1dfU1RBQ0tfU0laRQlTWl80SwogCisvKgorICog
V2l0aCB0aGUgbWluaW11bSBmcmFtZSBzaXplIG9mIFt4MjksIHgzMF0sIGV4YWN0bHkgaGFsZiB0
aGUgY29tYmluZWQKKyAqIHNpemVzIG9mIHRoZSBoeXAgYW5kIG92ZXJmbG93IHN0YWNrcyBpcyB0
aGUgbWF4aW11bSBzaXplIG5lZWRlZCB0bworICogc2F2ZSB0aGUgdW53aW5kZWQgc3RhY2t0cmFj
ZTsgcGx1cyBhbiBhZGRpdGlvbmFsIGVudHJ5IHRvIGRlbGltaXQgdGhlCisgKiBlbmQuCisgKi8K
KyNkZWZpbmUgTlZIRV9TVEFDS1RSQUNFX1NJWkUJKChPVkVSRkxPV19TVEFDS19TSVpFICsgUEFH
RV9TSVpFKSAvIDIgKyBzaXplb2YobG9uZykpCisKIC8qCiAgKiBBbGlnbm1lbnQgb2Yga2VybmVs
IHNlZ21lbnRzIChlLmcuIC50ZXh0LCAuZGF0YSkuCiAgKgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02
NC9rdm0vaHlwL252aGUvc3RhY2t0cmFjZS5jIGIvYXJjaC9hcm02NC9rdm0vaHlwL252aGUvc3Rh
Y2t0cmFjZS5jCmluZGV4IGI4YTI4MGFhMDI2YS4uZTJlZGRhOTJhMTA4IDEwMDY0NAotLS0gYS9h
cmNoL2FybTY0L2t2bS9oeXAvbnZoZS9zdGFja3RyYWNlLmMKKysrIGIvYXJjaC9hcm02NC9rdm0v
aHlwL252aGUvc3RhY2t0cmFjZS5jCkBAIC0zNCw2ICszNCwxMCBAQCBzdGF0aWMgdm9pZCBoeXBf
cHJlcGFyZV9iYWNrdHJhY2UodW5zaWduZWQgbG9uZyBmcCwgdW5zaWduZWQgbG9uZyBwYykKIAlz
dGFja3RyYWNlX2luZm8tPnBjID0gcGM7CiB9CiAKKyNpZmRlZiBDT05GSUdfUFJPVEVDVEVEX05W
SEVfU1RBQ0tUUkFDRQorREVGSU5FX1BFUl9DUFUodW5zaWduZWQgbG9uZyBbTlZIRV9TVEFDS1RS
QUNFX1NJWkUvc2l6ZW9mKGxvbmcpXSwgcGt2bV9zdGFja3RyYWNlKTsKKyNlbmRpZiAvKiBDT05G
SUdfUFJPVEVDVEVEX05WSEVfU1RBQ0tUUkFDRSAqLworCiAvKgogICoga3ZtX252aGVfcHJlcGFy
ZV9iYWNrdHJhY2UgLSBwcmVwYXJlIHRvIGR1bXAgdGhlIG5WSEUgYmFja3RyYWNlCiAgKgotLSAK
Mi4zNy4xLjM1OS5nZDEzNmM2YzNlMi1nb29nCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
