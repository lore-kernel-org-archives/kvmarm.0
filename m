Return-Path: <SRS0=m0cG=V2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53243C7618B
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jul 2019 10:49:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 15AC9214AE
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jul 2019 10:49:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15AC9214AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2B3E4A531;
	Mon, 29 Jul 2019 06:49:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BvAhGYgdCjCa; Mon, 29 Jul 2019 06:49:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B5474A545;
	Mon, 29 Jul 2019 06:49:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE6F24A3A5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jul 2019 19:33:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c1aqDeFJDYGj for <kvmarm@lists.cs.columbia.edu>;
 Sun, 28 Jul 2019 19:33:57 -0400 (EDT)
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com
 [209.85.221.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6DE374A53F
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jul 2019 19:33:57 -0400 (EDT)
Received: by mail-wr1-f65.google.com with SMTP id r1so59797750wrl.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 28 Jul 2019 16:33:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=aaEeKTG5R6Qc1GdziDtQYqZnD5RGAhr5gRU7LI7kaRU=;
 b=LvEQ9DXHekvhq08s6gENVYoFb96S1lslKEoyo0EaQcfHMRUHUg16K7YqRClyLJxHWy
 Y3RplpJlhPWtgIUu6obKg4GsSnwZg0KQ+meFH+g2arbSNohL09Fgh/+6v3HwienV4C7+
 cINmD+MPilrUHi+9v5krIUDc3itpngx1nSjL8YVdjiquo+Z4FGRlmtPhZQ1DMkWLipPf
 RSdmXFEXNE61448tAEUHM2AGXCJLMTPO8RAt5KrSOfCJUv4rhKWukmTu1L0bfZlTLthJ
 /WT8jtHwFrqC41+5rEKr4gN1xKPq3NhKJaAoJa/OyALxmfvy56fz/Mlcdrgc1bvhf5V7
 3P2Q==
X-Gm-Message-State: APjAAAXUAP9oMHUHWW8o0ypMJas9sreN0ESLn2E3Oq7YCKqgsKqI3Xdq
 Smxx/IblU1OD7fI/MXKgD7oilw==
X-Google-Smtp-Source: APXvYqw92NTMBLPsPb4QZTGuO9U/NuPamS1jjyCN0NB7ONLDo7yL5jkx3vA9VzVTsdLSGSGyi5CJjQ==
X-Received: by 2002:adf:d4c1:: with SMTP id w1mr44021854wrk.229.1564356836523; 
 Sun, 28 Jul 2019 16:33:56 -0700 (PDT)
Received: from mcroce-redhat.homenet.telecomitalia.it
 (host221-208-dynamic.27-79-r.retail.telecomitalia.it. [79.27.208.221])
 by smtp.gmail.com with ESMTPSA id c1sm136666630wrh.1.2019.07.28.16.33.55
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Sun, 28 Jul 2019 16:33:55 -0700 (PDT)
From: Matteo Croce <mcroce@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: vgic-v3: mark expected switch fall-through
Date: Mon, 29 Jul 2019 01:33:47 +0200
Message-Id: <20190728233347.7856-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
X-Mailman-Approved-At: Mon, 29 Jul 2019 06:49:21 -0400
Cc: Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org
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

TWFyayBzd2l0Y2ggY2FzZXMgd2hlcmUgd2UgYXJlIGV4cGVjdGluZyB0byBmYWxsIHRocm91Z2gs
CmZpeGVzIHRoZSBmb2xsb3dpbmcgd2FybmluZzoKCmFyY2gvYXJtNjQva3ZtL2h5cC8uLi8uLi8u
Li8uLi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYzogSW4gZnVuY3Rpb24g4oCYX192Z2lj
X3YzX3NhdmVfYXByc+KAmToKYXJjaC9hcm02NC9rdm0vaHlwLy4uLy4uLy4uLy4uL3ZpcnQva3Zt
L2FybS9oeXAvdmdpYy12My1zci5jOjM1MToyNDogd2FybmluZzogdGhpcyBzdGF0ZW1lbnQgbWF5
IGZhbGwgdGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1dCiAgIGNwdV9pZi0+dmdpY19h
cDByWzJdID0gX192Z2ljX3YzX3JlYWRfYXAwcm4oMik7CiAgIH5+fn5+fn5+fn5+fn5+fn5+fn5+
fl5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4KYXJjaC9hcm02NC9rdm0vaHlwLy4uLy4uLy4uLy4u
L3ZpcnQva3ZtL2FybS9oeXAvdmdpYy12My1zci5jOjM1MjoyOiBub3RlOiBoZXJlCiAgY2FzZSA2
OgogIF5+fn4KYXJjaC9hcm02NC9rdm0vaHlwLy4uLy4uLy4uLy4uL3ZpcnQva3ZtL2FybS9oeXAv
dmdpYy12My1zci5jOjM1MzoyNDogd2FybmluZzogdGhpcyBzdGF0ZW1lbnQgbWF5IGZhbGwgdGhy
b3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1dCiAgIGNwdV9pZi0+dmdpY19hcDByWzFdID0g
X192Z2ljX3YzX3JlYWRfYXAwcm4oMSk7CiAgIH5+fn5+fn5+fn5+fn5+fn5+fn5+fl5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn4KYXJjaC9hcm02NC9rdm0vaHlwLy4uLy4uLy4uLy4uL3ZpcnQva3Zt
L2FybS9oeXAvdmdpYy12My1zci5jOjM1NDoyOiBub3RlOiBoZXJlCiAgZGVmYXVsdDoKICBefn5+
fn5+CmFyY2gvYXJtNjQva3ZtL2h5cC8uLi8uLi8uLi8uLi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMt
djMtc3IuYzozNjE6MjQ6IHdhcm5pbmc6IHRoaXMgc3RhdGVtZW50IG1heSBmYWxsIHRocm91Z2gg
Wy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQogICBjcHVfaWYtPnZnaWNfYXAxclsyXSA9IF9fdmdp
Y192M19yZWFkX2FwMXJuKDIpOwogICB+fn5+fn5+fn5+fn5+fn5+fn5+fn5efn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+CmFyY2gvYXJtNjQva3ZtL2h5cC8uLi8uLi8uLi8uLi92aXJ0L2t2bS9hcm0v
aHlwL3ZnaWMtdjMtc3IuYzozNjI6Mjogbm90ZTogaGVyZQogIGNhc2UgNjoKICBefn5+CmFyY2gv
YXJtNjQva3ZtL2h5cC8uLi8uLi8uLi8uLi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYzoz
NjM6MjQ6IHdhcm5pbmc6IHRoaXMgc3RhdGVtZW50IG1heSBmYWxsIHRocm91Z2ggWy1XaW1wbGlj
aXQtZmFsbHRocm91Z2g9XQogICBjcHVfaWYtPnZnaWNfYXAxclsxXSA9IF9fdmdpY192M19yZWFk
X2FwMXJuKDEpOwogICB+fn5+fn5+fn5+fn5+fn5+fn5+fn5efn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+CmFyY2gvYXJtNjQva3ZtL2h5cC8uLi8uLi8uLi8uLi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMt
djMtc3IuYzozNjQ6Mjogbm90ZTogaGVyZQogIGRlZmF1bHQ6CiAgXn5+fn5+fgphcmNoL2FybTY0
L2t2bS9oeXAvLi4vLi4vLi4vLi4vdmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmM6IEluIGZ1
bmN0aW9uIOKAmF9fdmdpY192M19yZXN0b3JlX2FwcnPigJk6CmFyY2gvYXJtNjQva3ZtL2h5cC8u
Li8uLi8uLi8uLi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYzozODQ6Mzogd2FybmluZzog
dGhpcyBzdGF0ZW1lbnQgbWF5IGZhbGwgdGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1d
CiAgIF9fdmdpY192M193cml0ZV9hcDBybihjcHVfaWYtPnZnaWNfYXAwclsyXSwgMik7CiAgIF5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4KYXJjaC9hcm02NC9r
dm0vaHlwLy4uLy4uLy4uLy4uL3ZpcnQva3ZtL2FybS9oeXAvdmdpYy12My1zci5jOjM4NToyOiBu
b3RlOiBoZXJlCiAgY2FzZSA2OgogIF5+fn4KYXJjaC9hcm02NC9rdm0vaHlwLy4uLy4uLy4uLy4u
L3ZpcnQva3ZtL2FybS9oeXAvdmdpYy12My1zci5jOjM4NjozOiB3YXJuaW5nOiB0aGlzIHN0YXRl
bWVudCBtYXkgZmFsbCB0aHJvdWdoIFstV2ltcGxpY2l0LWZhbGx0aHJvdWdoPV0KICAgX192Z2lj
X3YzX3dyaXRlX2FwMHJuKGNwdV9pZi0+dmdpY19hcDByWzFdLCAxKTsKICAgXn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fgphcmNoL2FybTY0L2t2bS9oeXAvLi4v
Li4vLi4vLi4vdmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmM6Mzg3OjI6IG5vdGU6IGhlcmUK
ICBkZWZhdWx0OgogIF5+fn5+fn4KYXJjaC9hcm02NC9rdm0vaHlwLy4uLy4uLy4uLy4uL3ZpcnQv
a3ZtL2FybS9oeXAvdmdpYy12My1zci5jOjM5NDozOiB3YXJuaW5nOiB0aGlzIHN0YXRlbWVudCBt
YXkgZmFsbCB0aHJvdWdoIFstV2ltcGxpY2l0LWZhbGx0aHJvdWdoPV0KICAgX192Z2ljX3YzX3dy
aXRlX2FwMXJuKGNwdV9pZi0+dmdpY19hcDFyWzJdLCAyKTsKICAgXn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fgphcmNoL2FybTY0L2t2bS9oeXAvLi4vLi4vLi4v
Li4vdmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmM6Mzk1OjI6IG5vdGU6IGhlcmUKICBjYXNl
IDY6CiAgXn5+fgphcmNoL2FybTY0L2t2bS9oeXAvLi4vLi4vLi4vLi4vdmlydC9rdm0vYXJtL2h5
cC92Z2ljLXYzLXNyLmM6Mzk2OjM6IHdhcm5pbmc6IHRoaXMgc3RhdGVtZW50IG1heSBmYWxsIHRo
cm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQogICBfX3ZnaWNfdjNfd3JpdGVfYXAxcm4o
Y3B1X2lmLT52Z2ljX2FwMXJbMV0sIDEpOwogICBefn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+CmFyY2gvYXJtNjQva3ZtL2h5cC8uLi8uLi8uLi8uLi92aXJ0L2t2
bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYzozOTc6Mjogbm90ZTogaGVyZQogIGRlZmF1bHQ6CiAgXn5+
fn5+fgoKU2lnbmVkLW9mZi1ieTogTWF0dGVvIENyb2NlIDxtY3JvY2VAcmVkaGF0LmNvbT4KLS0t
CiB2aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYyB8IDggKysrKysrKysKIDEgZmlsZSBjaGFu
Z2VkLCA4IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMt
djMtc3IuYyBiL3ZpcnQva3ZtL2FybS9oeXAvdmdpYy12My1zci5jCmluZGV4IDI1NGM1ZjE5MGEz
ZC4uNjIyZmI0ZDE4YzVjIDEwMDY0NAotLS0gYS92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3Iu
YworKysgYi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYwpAQCAtMzQ5LDggKzM0OSwxMCBA
QCB2b2lkIF9faHlwX3RleHQgX192Z2ljX3YzX3NhdmVfYXBycyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUpCiAJY2FzZSA3OgogCQljcHVfaWYtPnZnaWNfYXAwclszXSA9IF9fdmdpY192M19yZWFkX2Fw
MHJuKDMpOwogCQljcHVfaWYtPnZnaWNfYXAwclsyXSA9IF9fdmdpY192M19yZWFkX2FwMHJuKDIp
OworCQkvKiBmYWxsdGhyb3VnaCAqLwogCWNhc2UgNjoKIAkJY3B1X2lmLT52Z2ljX2FwMHJbMV0g
PSBfX3ZnaWNfdjNfcmVhZF9hcDBybigxKTsKKwkJLyogZmFsbHRocm91Z2ggKi8KIAlkZWZhdWx0
OgogCQljcHVfaWYtPnZnaWNfYXAwclswXSA9IF9fdmdpY192M19yZWFkX2FwMHJuKDApOwogCX0K
QEAgLTM1OSw4ICszNjEsMTAgQEAgdm9pZCBfX2h5cF90ZXh0IF9fdmdpY192M19zYXZlX2FwcnMo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogCWNhc2UgNzoKIAkJY3B1X2lmLT52Z2ljX2FwMXJbM10g
PSBfX3ZnaWNfdjNfcmVhZF9hcDFybigzKTsKIAkJY3B1X2lmLT52Z2ljX2FwMXJbMl0gPSBfX3Zn
aWNfdjNfcmVhZF9hcDFybigyKTsKKwkJLyogZmFsbHRocm91Z2ggKi8KIAljYXNlIDY6CiAJCWNw
dV9pZi0+dmdpY19hcDFyWzFdID0gX192Z2ljX3YzX3JlYWRfYXAxcm4oMSk7CisJCS8qIGZhbGx0
aHJvdWdoICovCiAJZGVmYXVsdDoKIAkJY3B1X2lmLT52Z2ljX2FwMXJbMF0gPSBfX3ZnaWNfdjNf
cmVhZF9hcDFybigwKTsKIAl9CkBAIC0zODIsOCArMzg2LDEwIEBAIHZvaWQgX19oeXBfdGV4dCBf
X3ZnaWNfdjNfcmVzdG9yZV9hcHJzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIAljYXNlIDc6CiAJ
CV9fdmdpY192M193cml0ZV9hcDBybihjcHVfaWYtPnZnaWNfYXAwclszXSwgMyk7CiAJCV9fdmdp
Y192M193cml0ZV9hcDBybihjcHVfaWYtPnZnaWNfYXAwclsyXSwgMik7CisJCS8qIGZhbGx0aHJv
dWdoICovCiAJY2FzZSA2OgogCQlfX3ZnaWNfdjNfd3JpdGVfYXAwcm4oY3B1X2lmLT52Z2ljX2Fw
MHJbMV0sIDEpOworCQkvKiBmYWxsdGhyb3VnaCAqLwogCWRlZmF1bHQ6CiAJCV9fdmdpY192M193
cml0ZV9hcDBybihjcHVfaWYtPnZnaWNfYXAwclswXSwgMCk7CiAJfQpAQCAtMzkyLDggKzM5OCwx
MCBAQCB2b2lkIF9faHlwX3RleHQgX192Z2ljX3YzX3Jlc3RvcmVfYXBycyhzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpCiAJY2FzZSA3OgogCQlfX3ZnaWNfdjNfd3JpdGVfYXAxcm4oY3B1X2lmLT52Z2lj
X2FwMXJbM10sIDMpOwogCQlfX3ZnaWNfdjNfd3JpdGVfYXAxcm4oY3B1X2lmLT52Z2ljX2FwMXJb
Ml0sIDIpOworCQkvKiBmYWxsdGhyb3VnaCAqLwogCWNhc2UgNjoKIAkJX192Z2ljX3YzX3dyaXRl
X2FwMXJuKGNwdV9pZi0+dmdpY19hcDFyWzFdLCAxKTsKKwkJLyogZmFsbHRocm91Z2ggKi8KIAlk
ZWZhdWx0OgogCQlfX3ZnaWNfdjNfd3JpdGVfYXAxcm4oY3B1X2lmLT52Z2ljX2FwMXJbMF0sIDAp
OwogCX0KLS0gCjIuMjEuMAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
