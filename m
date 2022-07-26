Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B36C1C43334
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E0A14C550;
	Tue, 26 Jul 2022 03:38:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fAfn-n-pewjD; Tue, 26 Jul 2022 03:38:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15DAA4C566;
	Tue, 26 Jul 2022 03:38:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 477B94C437
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4acusEKElNGJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:17 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B6C224C565
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:17 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b18-20020a25bb52000000b0067128e66131so4355768ybk.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc:content-transfer-encoding;
 bh=9m8IvwBOrk2IG7YkQAmQznPKKCvMCFPD8HJb+zFgtK8=;
 b=VhKEEavk6g8DUisEYJ5fAHdMTvKq1n+wB7+56Ad5f4Tt+AZAOv7GuRys7Kgb+3+KOG
 p03FaqATet8gRqAPFppMF9Kfbj/aDmzrkJudV1qME6MnQKWKFtW9pdbRTtwAn+OYEWy9
 B7NVUpEbguxv4nUZgDaWFKufpopj+7xZULmeUF3mYeIBkoglfz3pXlVJNkApttUvBYbv
 rf6vSs4cE7BLt6NNMWawOgPLMDkK1hTQ1GT2YS9ZHmApphd+I6th/NhszMgZ5+elz7pb
 C/8gi3GqQXgiVyNuV4OmLVw58XuRoDb52Hqoazg89l/+gnlHqCoQ8xlq2Oe6EZ9y9f0p
 VBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc:content-transfer-encoding;
 bh=9m8IvwBOrk2IG7YkQAmQznPKKCvMCFPD8HJb+zFgtK8=;
 b=5UitC/ieoBfacZszt/Brxo1iOTI9cmx0JV8m1TJc6G8hV5VYRDj23ODrExLxlbVSKc
 puboAo9pBhYKXxegnx6pljZCMoP3EItKM+dPXThKS5GmOM+szGOrF3Jlv4j58zRtxnN1
 kl1SFYWuARRlhDtn4egZxvGw9H74cZm71pwvYNDIqIMRlm/hXPAQohbTn2lcPwvLSK0w
 Q1PGconS0HguPf6cv4nJlgjKtAGofelpnCOLClJVxQPSDs/omTLgyWxSVITZAFIaT8sn
 TXbagUlQQFkWGolFNsO7CMo+tr/epcUpAJchJd27fT71RjzFvn4bXf/IGFqoHWGa9vTJ
 Mi3A==
X-Gm-Message-State: AJIora9Al8pKf2DB74OLhMvqppd8ZGAbsgYAA5ZZvQop8l66pugQfqk+
 xG+pJ1KAvSVcRbhYOvCRP6jAZNg5MtqMfQ6uCw==
X-Google-Smtp-Source: AGRyM1tZibhQ2sQ3XGV5gsfb456P6K4Ka3kCr7dAdskf5tEREIiKvgCRKyyCGjYAT/M3AHlYk45u/sv5vdP+iu+2/Q==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a25:d6cc:0:b0:671:6e7e:d5d9 with SMTP
 id n195-20020a25d6cc000000b006716e7ed5d9mr1909023ybg.14.1658821097301; Tue,
 26 Jul 2022 00:38:17 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:42 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-10-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 09/17] KVM: arm64: Prepare non-protected nVHE hypervisor
 stacktrace
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

SW4gbm9uLXByb3RlY3RlZCBuVkhFIG1vZGUgKG5vbi1wS1ZNKSB0aGUgaG9zdCBjYW4gZGlyZWN0
bHkgYWNjZXNzCmh5cGVydmlzb3IgbWVtb3J5OyBhbmQgdW53aW5kaW5nIG9mIHRoZSBoeXBlcnZp
c29yIHN0YWNrdHJhY2UgaXMKZG9uZSBmcm9tIEVMMSB0byBzYXZlIG9uIG1lbW9yeSBmb3Igc2hh
cmVkIGJ1ZmZlcnMuCgpUbyB1bndpbmQgdGhlIGh5cGVydmlzb3Igc3RhY2sgZnJvbSBFTDEgdGhl
IGhvc3QgbmVlZHMgdG8ga25vdyB0aGUKc3RhcnRpbmcgcG9pbnQgZm9yIHRoZSB1bndpbmQgYW5k
IGluZm9ybWF0aW9uIHRoYXQgd2lsbCBhbGxvdyBpdCB0bwp0cmFuc2xhdGUgaHlwZXJ2aXNvciBz
dGFjayBhZGRyZXNzZXMgdG8gdGhlIGNvcnJlc3BvbmRpbmcga2VybmVsCmFkZHJlc3Nlcy4gVGhp
cyBwYXRjaCBzZXRzIHVwIHRoaXMgYm9vayBrZWVwaW5nLiBJdCBpcyBtYWRlIHVzZSBvZgpsYXRl
ciBpbiB0aGUgc2VyaWVzLgoKU2lnbmVkLW9mZi1ieTogS2FsZXNoIFNpbmdoIDxrYWxlc2hzaW5n
aEBnb29nbGUuY29tPgpSZXZpZXdlZC1ieTogRnVhZCBUYWJiYSA8dGFiYmFAZ29vZ2xlLmNvbT4K
VGVzdGVkLWJ5OiBGdWFkIFRhYmJhIDx0YWJiYUBnb29nbGUuY29tPgotLS0KCkNoYW5nZXMgaW4g
djY6CiAgLSBBZGQgRnVhZOKAmXMgUmV2aWV3ZWQtYnkgYW5kIFRlc3RlZC1ieSB0YWdzCgpDaGFu
Z2VzIGluIHY1OgogIC0gVXNlIHJlZ3VsYXIgY29tbWVudHMgaW5zdGVhZCBvZiBkb2MgY29tbWVu
dHMsIHBlciBGdWFkCgogYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fYXNtLmggICAgIHwgMTYg
KysrKysrKysrKysKIGFyY2gvYXJtNjQva3ZtL2h5cC9udmhlL3N0YWNrdHJhY2UuYyB8IDQxICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysKIGFyY2gvYXJtNjQva3ZtL2h5cC9udmhlL3N3aXRj
aC5jICAgICB8ICA2ICsrKysKIDMgZmlsZXMgY2hhbmdlZCwgNjMgaW5zZXJ0aW9ucygrKQoKZGlm
ZiAtLWdpdCBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FzbS5oIGIvYXJjaC9hcm02NC9p
bmNsdWRlL2FzbS9rdm1fYXNtLmgKaW5kZXggMmUyNzdmMmVkNjcxLi41MzAzNTc2M2U0OGUgMTAw
NjQ0Ci0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FzbS5oCisrKyBiL2FyY2gvYXJt
NjQvaW5jbHVkZS9hc20va3ZtX2FzbS5oCkBAIC0xNzYsNiArMTc2LDIyIEBAIHN0cnVjdCBrdm1f
bnZoZV9pbml0X3BhcmFtcyB7CiAJdW5zaWduZWQgbG9uZyB2dGNyOwogfTsKIAorLyoKKyAqIFVz
ZWQgYnkgdGhlIGhvc3QgaW4gRUwxIHRvIGR1bXAgdGhlIG5WSEUgaHlwZXJ2aXNvciBiYWNrdHJh
Y2Ugb24KKyAqIGh5cF9wYW5pYygpIGluIG5vbi1wcm90ZWN0ZWQgbW9kZS4KKyAqCisgKiBAc3Rh
Y2tfYmFzZTogICAgICAgICAgICAgICAgIGh5cCBWQSBvZiB0aGUgaHlwX3N0YWNrIGJhc2UuCisg
KiBAb3ZlcmZsb3dfc3RhY2tfYmFzZTogICAgICAgIGh5cCBWQSBvZiB0aGUgaHlwX292ZXJmbG93
X3N0YWNrIGJhc2UuCisgKiBAZnA6ICAgICAgICAgICAgICAgICAgICAgICAgIGh5cCBGUCB3aGVy
ZSB0aGUgYmFja3RyYWNlIGJlZ2lucy4KKyAqIEBwYzogICAgICAgICAgICAgICAgICAgICAgICAg
aHlwIFBDIHdoZXJlIHRoZSBiYWNrdHJhY2UgYmVnaW5zLgorICovCitzdHJ1Y3Qga3ZtX252aGVf
c3RhY2t0cmFjZV9pbmZvIHsKKwl1bnNpZ25lZCBsb25nIHN0YWNrX2Jhc2U7CisJdW5zaWduZWQg
bG9uZyBvdmVyZmxvd19zdGFja19iYXNlOworCXVuc2lnbmVkIGxvbmcgZnA7CisJdW5zaWduZWQg
bG9uZyBwYzsKK307CisKIC8qIFRyYW5zbGF0ZSBhIGtlcm5lbCBhZGRyZXNzIEBwdHIgaW50byBp
dHMgZXF1aXZhbGVudCBsaW5lYXIgbWFwcGluZyAqLwogI2RlZmluZSBrdm1fa3N5bV9yZWYocHRy
KQkJCQkJCVwKIAkoewkJCQkJCQkJXApkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vaHlwL252
aGUvc3RhY2t0cmFjZS5jIGIvYXJjaC9hcm02NC9rdm0vaHlwL252aGUvc3RhY2t0cmFjZS5jCmlu
ZGV4IGEzZDViMzRlMTI0OS4uYjhhMjgwYWEwMjZhIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2
bS9oeXAvbnZoZS9zdGFja3RyYWNlLmMKKysrIGIvYXJjaC9hcm02NC9rdm0vaHlwL252aGUvc3Rh
Y2t0cmFjZS5jCkBAIC00LDggKzQsNDkgQEAKICAqCiAgKiBDb3B5cmlnaHQgKEMpIDIwMjIgR29v
Z2xlIExMQwogICovCisjaW5jbHVkZSA8YXNtL2t2bV9hc20uaD4KKyNpbmNsdWRlIDxhc20va3Zt
X2h5cC5oPgogI2luY2x1ZGUgPGFzbS9tZW1vcnkuaD4KICNpbmNsdWRlIDxhc20vcGVyY3B1Lmg+
CiAKIERFRklORV9QRVJfQ1BVKHVuc2lnbmVkIGxvbmcgW09WRVJGTE9XX1NUQUNLX1NJWkUvc2l6
ZW9mKGxvbmcpXSwgb3ZlcmZsb3dfc3RhY2spCiAJX19hbGlnbmVkKDE2KTsKKworREVGSU5FX1BF
Ul9DUFUoc3RydWN0IGt2bV9udmhlX3N0YWNrdHJhY2VfaW5mbywga3ZtX3N0YWNrdHJhY2VfaW5m
byk7CisKKy8qCisgKiBoeXBfcHJlcGFyZV9iYWNrdHJhY2UgLSBQcmVwYXJlIG5vbi1wcm90ZWN0
ZWQgblZIRSBiYWNrdHJhY2UuCisgKgorICogQGZwIDogZnJhbWUgcG9pbnRlciBhdCB3aGljaCB0
byBzdGFydCB0aGUgdW53aW5kaW5nLgorICogQHBjIDogcHJvZ3JhbSBjb3VudGVyIGF0IHdoaWNo
IHRvIHN0YXJ0IHRoZSB1bndpbmRpbmcuCisgKgorICogU2F2ZSB0aGUgaW5mb3JtYXRpb24gbmVl
ZGVkIGJ5IHRoZSBob3N0IHRvIHVud2luZCB0aGUgbm9uLXByb3RlY3RlZAorICogblZIRSBoeXBl
cnZpc29yIHN0YWNrIGluIEVMMS4KKyAqLworc3RhdGljIHZvaWQgaHlwX3ByZXBhcmVfYmFja3Ry
YWNlKHVuc2lnbmVkIGxvbmcgZnAsIHVuc2lnbmVkIGxvbmcgcGMpCit7CisJc3RydWN0IGt2bV9u
dmhlX3N0YWNrdHJhY2VfaW5mbyAqc3RhY2t0cmFjZV9pbmZvID0gdGhpc19jcHVfcHRyKCZrdm1f
c3RhY2t0cmFjZV9pbmZvKTsKKwlzdHJ1Y3Qga3ZtX252aGVfaW5pdF9wYXJhbXMgKnBhcmFtcyA9
IHRoaXNfY3B1X3B0cigma3ZtX2luaXRfcGFyYW1zKTsKKworCXN0YWNrdHJhY2VfaW5mby0+c3Rh
Y2tfYmFzZSA9ICh1bnNpZ25lZCBsb25nKShwYXJhbXMtPnN0YWNrX2h5cF92YSAtIFBBR0VfU0la
RSk7CisJc3RhY2t0cmFjZV9pbmZvLT5vdmVyZmxvd19zdGFja19iYXNlID0gKHVuc2lnbmVkIGxv
bmcpdGhpc19jcHVfcHRyKG92ZXJmbG93X3N0YWNrKTsKKwlzdGFja3RyYWNlX2luZm8tPmZwID0g
ZnA7CisJc3RhY2t0cmFjZV9pbmZvLT5wYyA9IHBjOworfQorCisvKgorICoga3ZtX252aGVfcHJl
cGFyZV9iYWNrdHJhY2UgLSBwcmVwYXJlIHRvIGR1bXAgdGhlIG5WSEUgYmFja3RyYWNlCisgKgor
ICogQGZwIDogZnJhbWUgcG9pbnRlciBhdCB3aGljaCB0byBzdGFydCB0aGUgdW53aW5kaW5nLgor
ICogQHBjIDogcHJvZ3JhbSBjb3VudGVyIGF0IHdoaWNoIHRvIHN0YXJ0IHRoZSB1bndpbmRpbmcu
CisgKgorICogU2F2ZXMgdGhlIGluZm9ybWF0aW9uIG5lZWRlZCBieSB0aGUgaG9zdCB0byBkdW1w
IHRoZSBuVkhFIGh5cGVydmlzb3IKKyAqIGJhY2t0cmFjZS4KKyAqLwordm9pZCBrdm1fbnZoZV9w
cmVwYXJlX2JhY2t0cmFjZSh1bnNpZ25lZCBsb25nIGZwLCB1bnNpZ25lZCBsb25nIHBjKQorewor
CWlmIChpc19wcm90ZWN0ZWRfa3ZtX2VuYWJsZWQoKSkKKwkJcmV0dXJuOworCWVsc2UKKwkJaHlw
X3ByZXBhcmVfYmFja3RyYWNlKGZwLCBwYyk7Cit9CmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2
bS9oeXAvbnZoZS9zd2l0Y2guYyBiL2FyY2gvYXJtNjQva3ZtL2h5cC9udmhlL3N3aXRjaC5jCmlu
ZGV4IDZkYjgwMWRiOGYyNy4uNjRlMTM0NDVkMGQ5IDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2
bS9oeXAvbnZoZS9zd2l0Y2guYworKysgYi9hcmNoL2FybTY0L2t2bS9oeXAvbnZoZS9zd2l0Y2gu
YwpAQCAtMzQsNiArMzQsOCBAQCBERUZJTkVfUEVSX0NQVShzdHJ1Y3Qga3ZtX2hvc3RfZGF0YSwg
a3ZtX2hvc3RfZGF0YSk7CiBERUZJTkVfUEVSX0NQVShzdHJ1Y3Qga3ZtX2NwdV9jb250ZXh0LCBr
dm1faHlwX2N0eHQpOwogREVGSU5FX1BFUl9DUFUodW5zaWduZWQgbG9uZywga3ZtX2h5cF92ZWN0
b3IpOwogCitleHRlcm4gdm9pZCBrdm1fbnZoZV9wcmVwYXJlX2JhY2t0cmFjZSh1bnNpZ25lZCBs
b25nIGZwLCB1bnNpZ25lZCBsb25nIHBjKTsKKwogc3RhdGljIHZvaWQgX19hY3RpdmF0ZV90cmFw
cyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCiB7CiAJdTY0IHZhbDsKQEAgLTM3NSw2ICszNzcsMTAg
QEAgYXNtbGlua2FnZSB2b2lkIF9fbm9yZXR1cm4gaHlwX3BhbmljKHZvaWQpCiAJCV9fc3lzcmVn
X3Jlc3RvcmVfc3RhdGVfbnZoZShob3N0X2N0eHQpOwogCX0KIAorCS8qIFByZXBhcmUgdG8gZHVt
cCBrdm0gbnZoZSBoeXAgc3RhY2t0cmFjZSAqLworCWt2bV9udmhlX3ByZXBhcmVfYmFja3RyYWNl
KCh1bnNpZ25lZCBsb25nKV9fYnVpbHRpbl9mcmFtZV9hZGRyZXNzKDApLAorCQkJCSAgIF9USElT
X0lQXyk7CisKIAlfX2h5cF9kb19wYW5pYyhob3N0X2N0eHQsIHNwc3IsIGVsciwgcGFyKTsKIAl1
bnJlYWNoYWJsZSgpOwogfQotLSAKMi4zNy4xLjM1OS5nZDEzNmM2YzNlMi1nb29nCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
