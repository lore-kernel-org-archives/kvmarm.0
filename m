Return-Path: <SRS0=xH8Q=V4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB63C433FF
	for <kvmarm@archiver.kernel.org>; Wed, 31 Jul 2019 17:37:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21B6920693
	for <kvmarm@archiver.kernel.org>; Wed, 31 Jul 2019 17:37:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21B6920693
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF6274A56D;
	Wed, 31 Jul 2019 13:37:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mtFA2DfFCrut; Wed, 31 Jul 2019 13:37:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DC574A559;
	Wed, 31 Jul 2019 13:37:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A25C74A511
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Jul 2019 13:37:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dzFF2TxBiNtQ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Jul 2019 13:37:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B7B84A555
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Jul 2019 13:37:09 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4448515A2;
 Wed, 31 Jul 2019 10:37:09 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92E5A3F71F;
 Wed, 31 Jul 2019 10:37:06 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 3/5] KVM: arm: vgic-v3: Mark expected switch fall-through
Date: Wed, 31 Jul 2019 18:36:48 +0100
Message-Id: <20190731173650.12627-4-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190731173650.12627-1-maz@kernel.org>
References: <20190731173650.12627-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Anders Roxell <anders.roxell@linaro.org>, kvm@vger.kernel.org,
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

RnJvbTogQW5kZXJzIFJveGVsbCA8YW5kZXJzLnJveGVsbEBsaW5hcm8ub3JnPgoKV2hlbiBmYWxs
LXRocm91Z2ggd2FybmluZ3Mgd2FzIGVuYWJsZWQgYnkgZGVmYXVsdCB0aGUgZm9sbG93aW5nIHdh
cm5pbmdzCndhcyBzdGFydGluZyB0byBzaG93IHVwOgoKLi4vdmlydC9rdm0vYXJtL2h5cC92Z2lj
LXYzLXNyLmM6IEluIGZ1bmN0aW9uIOKAmF9fdmdpY192M19zYXZlX2FwcnPigJk6Ci4uL3ZpcnQv
a3ZtL2FybS9oeXAvdmdpYy12My1zci5jOjM1MToyNDogd2FybmluZzogdGhpcyBzdGF0ZW1lbnQg
bWF5IGZhbGwKIHRocm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQogICBjcHVfaWYtPnZn
aWNfYXAwclsyXSA9IF9fdmdpY192M19yZWFkX2FwMHJuKDIpOwogICB+fn5+fn5+fn5+fn5+fn5+
fn5+fn5efn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+Ci4uL3ZpcnQva3ZtL2FybS9oeXAvdmdpYy12
My1zci5jOjM1MjoyOiBub3RlOiBoZXJlCiAgY2FzZSA2OgogIF5+fn4KLi4vdmlydC9rdm0vYXJt
L2h5cC92Z2ljLXYzLXNyLmM6MzUzOjI0OiB3YXJuaW5nOiB0aGlzIHN0YXRlbWVudCBtYXkgZmFs
bAogdGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1dCiAgIGNwdV9pZi0+dmdpY19hcDBy
WzFdID0gX192Z2ljX3YzX3JlYWRfYXAwcm4oMSk7CiAgIH5+fn5+fn5+fn5+fn5+fn5+fn5+fl5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4KLi4vdmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmM6
MzU0OjI6IG5vdGU6IGhlcmUKICBkZWZhdWx0OgogIF5+fn5+fn4KClJld29yayBzbyB0aGF0IHRo
ZSBjb21waWxlciBkb2Vzbid0IHdhcm4gYWJvdXQgZmFsbC10aHJvdWdoLgoKRml4ZXM6IGQ5MzUx
MmVmMGYwZSAoIk1ha2VmaWxlOiBHbG9iYWxseSBlbmFibGUgZmFsbC10aHJvdWdoIHdhcm5pbmci
KQpTaWduZWQtb2ZmLWJ5OiBBbmRlcnMgUm94ZWxsIDxhbmRlcnMucm94ZWxsQGxpbmFyby5vcmc+
ClNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Ci0tLQogdmlydC9r
dm0vYXJtL2h5cC92Z2ljLXYzLXNyLmMgfCA4ICsrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgOCBp
bnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmMg
Yi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYwppbmRleCAyNTRjNWYxOTBhM2QuLmNjZjFm
ZGU5ODM2YyAxMDA2NDQKLS0tIGEvdmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmMKKysrIGIv
dmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmMKQEAgLTM0OSw4ICszNDksMTAgQEAgdm9pZCBf
X2h5cF90ZXh0IF9fdmdpY192M19zYXZlX2FwcnMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogCWNh
c2UgNzoKIAkJY3B1X2lmLT52Z2ljX2FwMHJbM10gPSBfX3ZnaWNfdjNfcmVhZF9hcDBybigzKTsK
IAkJY3B1X2lmLT52Z2ljX2FwMHJbMl0gPSBfX3ZnaWNfdjNfcmVhZF9hcDBybigyKTsKKwkJLyog
RmFsbCB0aHJvdWdoICovCiAJY2FzZSA2OgogCQljcHVfaWYtPnZnaWNfYXAwclsxXSA9IF9fdmdp
Y192M19yZWFkX2FwMHJuKDEpOworCQkvKiBGYWxsIHRocm91Z2ggKi8KIAlkZWZhdWx0OgogCQlj
cHVfaWYtPnZnaWNfYXAwclswXSA9IF9fdmdpY192M19yZWFkX2FwMHJuKDApOwogCX0KQEAgLTM1
OSw4ICszNjEsMTAgQEAgdm9pZCBfX2h5cF90ZXh0IF9fdmdpY192M19zYXZlX2FwcnMoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1KQogCWNhc2UgNzoKIAkJY3B1X2lmLT52Z2ljX2FwMXJbM10gPSBfX3Zn
aWNfdjNfcmVhZF9hcDFybigzKTsKIAkJY3B1X2lmLT52Z2ljX2FwMXJbMl0gPSBfX3ZnaWNfdjNf
cmVhZF9hcDFybigyKTsKKwkJLyogRmFsbCB0aHJvdWdoICovCiAJY2FzZSA2OgogCQljcHVfaWYt
PnZnaWNfYXAxclsxXSA9IF9fdmdpY192M19yZWFkX2FwMXJuKDEpOworCQkvKiBGYWxsIHRocm91
Z2ggKi8KIAlkZWZhdWx0OgogCQljcHVfaWYtPnZnaWNfYXAxclswXSA9IF9fdmdpY192M19yZWFk
X2FwMXJuKDApOwogCX0KQEAgLTM4Miw4ICszODYsMTAgQEAgdm9pZCBfX2h5cF90ZXh0IF9fdmdp
Y192M19yZXN0b3JlX2FwcnMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogCWNhc2UgNzoKIAkJX192
Z2ljX3YzX3dyaXRlX2FwMHJuKGNwdV9pZi0+dmdpY19hcDByWzNdLCAzKTsKIAkJX192Z2ljX3Yz
X3dyaXRlX2FwMHJuKGNwdV9pZi0+dmdpY19hcDByWzJdLCAyKTsKKwkJLyogRmFsbCB0aHJvdWdo
ICovCiAJY2FzZSA2OgogCQlfX3ZnaWNfdjNfd3JpdGVfYXAwcm4oY3B1X2lmLT52Z2ljX2FwMHJb
MV0sIDEpOworCQkvKiBGYWxsIHRocm91Z2ggKi8KIAlkZWZhdWx0OgogCQlfX3ZnaWNfdjNfd3Jp
dGVfYXAwcm4oY3B1X2lmLT52Z2ljX2FwMHJbMF0sIDApOwogCX0KQEAgLTM5Miw4ICszOTgsMTAg
QEAgdm9pZCBfX2h5cF90ZXh0IF9fdmdpY192M19yZXN0b3JlX2FwcnMoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KQogCWNhc2UgNzoKIAkJX192Z2ljX3YzX3dyaXRlX2FwMXJuKGNwdV9pZi0+dmdpY19h
cDFyWzNdLCAzKTsKIAkJX192Z2ljX3YzX3dyaXRlX2FwMXJuKGNwdV9pZi0+dmdpY19hcDFyWzJd
LCAyKTsKKwkJLyogRmFsbCB0aHJvdWdoICovCiAJY2FzZSA2OgogCQlfX3ZnaWNfdjNfd3JpdGVf
YXAxcm4oY3B1X2lmLT52Z2ljX2FwMXJbMV0sIDEpOworCQkvKiBGYWxsIHRocm91Z2ggKi8KIAlk
ZWZhdWx0OgogCQlfX3ZnaWNfdjNfd3JpdGVfYXAxcm4oY3B1X2lmLT52Z2ljX2FwMXJbMF0sIDAp
OwogCX0KLS0gCjIuMjAuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
