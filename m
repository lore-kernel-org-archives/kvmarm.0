Return-Path: <SRS0=m0cG=V2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF827C76192
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jul 2019 09:52:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 929562075C
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jul 2019 09:52:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 929562075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1025B4A542;
	Mon, 29 Jul 2019 05:52:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zxk0C68ZHvFK; Mon, 29 Jul 2019 05:52:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0B154A539;
	Mon, 29 Jul 2019 05:52:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D02D84A539
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jul 2019 05:52:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LEMxXvMZd1bD for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jul 2019 05:52:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FC9C4A52C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jul 2019 05:52:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E4121596;
 Mon, 29 Jul 2019 02:52:25 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 40F703F694; Mon, 29 Jul 2019 02:52:24 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: vgic-v3: mark expected switch fall-through
To: Matteo Croce <mcroce@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
References: <20190728233347.7856-1-mcroce@redhat.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <e59eb35f-a83b-69e4-c72f-fe3f674f1fec@kernel.org>
Date: Mon, 29 Jul 2019 10:52:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190728233347.7856-1-mcroce@redhat.com>
Content-Language: en-US
Cc: linux-kernel@vger.kernel.org
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

T24gMjkvMDcvMjAxOSAwMDozMywgTWF0dGVvIENyb2NlIHdyb3RlOgo+IE1hcmsgc3dpdGNoIGNh
c2VzIHdoZXJlIHdlIGFyZSBleHBlY3RpbmcgdG8gZmFsbCB0aHJvdWdoLAo+IGZpeGVzIHRoZSBm
b2xsb3dpbmcgd2FybmluZzoKPiAKPiBhcmNoL2FybTY0L2t2bS9oeXAvLi4vLi4vLi4vLi4vdmly
dC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmM6IEluIGZ1bmN0aW9uIOKAmF9fdmdpY192M19zYXZl
X2FwcnPigJk6Cj4gYXJjaC9hcm02NC9rdm0vaHlwLy4uLy4uLy4uLy4uL3ZpcnQva3ZtL2FybS9o
eXAvdmdpYy12My1zci5jOjM1MToyNDogd2FybmluZzogdGhpcyBzdGF0ZW1lbnQgbWF5IGZhbGwg
dGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1dCj4gICAgY3B1X2lmLT52Z2ljX2FwMHJb
Ml0gPSBfX3ZnaWNfdjNfcmVhZF9hcDBybigyKTsKPiAgICB+fn5+fn5+fn5+fn5+fn5+fn5+fn5e
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+Cj4gYXJjaC9hcm02NC9rdm0vaHlwLy4uLy4uLy4uLy4u
L3ZpcnQva3ZtL2FybS9oeXAvdmdpYy12My1zci5jOjM1MjoyOiBub3RlOiBoZXJlCj4gICBjYXNl
IDY6Cj4gICBefn5+Cj4gYXJjaC9hcm02NC9rdm0vaHlwLy4uLy4uLy4uLy4uL3ZpcnQva3ZtL2Fy
bS9oeXAvdmdpYy12My1zci5jOjM1MzoyNDogd2FybmluZzogdGhpcyBzdGF0ZW1lbnQgbWF5IGZh
bGwgdGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1dCj4gICAgY3B1X2lmLT52Z2ljX2Fw
MHJbMV0gPSBfX3ZnaWNfdjNfcmVhZF9hcDBybigxKTsKPiAgICB+fn5+fn5+fn5+fn5+fn5+fn5+
fn5efn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+Cj4gYXJjaC9hcm02NC9rdm0vaHlwLy4uLy4uLy4u
Ly4uL3ZpcnQva3ZtL2FybS9oeXAvdmdpYy12My1zci5jOjM1NDoyOiBub3RlOiBoZXJlCj4gICBk
ZWZhdWx0Ogo+ICAgXn5+fn5+fgo+IGFyY2gvYXJtNjQva3ZtL2h5cC8uLi8uLi8uLi8uLi92aXJ0
L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYzozNjE6MjQ6IHdhcm5pbmc6IHRoaXMgc3RhdGVtZW50
IG1heSBmYWxsIHRocm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQo+ICAgIGNwdV9pZi0+
dmdpY19hcDFyWzJdID0gX192Z2ljX3YzX3JlYWRfYXAxcm4oMik7Cj4gICAgfn5+fn5+fn5+fn5+
fn5+fn5+fn5+Xn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fgo+IGFyY2gvYXJtNjQva3ZtL2h5cC8u
Li8uLi8uLi8uLi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYzozNjI6Mjogbm90ZTogaGVy
ZQo+ICAgY2FzZSA2Ogo+ICAgXn5+fgo+IGFyY2gvYXJtNjQva3ZtL2h5cC8uLi8uLi8uLi8uLi92
aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYzozNjM6MjQ6IHdhcm5pbmc6IHRoaXMgc3RhdGVt
ZW50IG1heSBmYWxsIHRocm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQo+ICAgIGNwdV9p
Zi0+dmdpY19hcDFyWzFdID0gX192Z2ljX3YzX3JlYWRfYXAxcm4oMSk7Cj4gICAgfn5+fn5+fn5+
fn5+fn5+fn5+fn5+Xn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fgo+IGFyY2gvYXJtNjQva3ZtL2h5
cC8uLi8uLi8uLi8uLi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYzozNjQ6Mjogbm90ZTog
aGVyZQo+ICAgZGVmYXVsdDoKPiAgIF5+fn5+fn4KPiBhcmNoL2FybTY0L2t2bS9oeXAvLi4vLi4v
Li4vLi4vdmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmM6IEluIGZ1bmN0aW9uIOKAmF9fdmdp
Y192M19yZXN0b3JlX2FwcnPigJk6Cj4gYXJjaC9hcm02NC9rdm0vaHlwLy4uLy4uLy4uLy4uL3Zp
cnQva3ZtL2FybS9oeXAvdmdpYy12My1zci5jOjM4NDozOiB3YXJuaW5nOiB0aGlzIHN0YXRlbWVu
dCBtYXkgZmFsbCB0aHJvdWdoIFstV2ltcGxpY2l0LWZhbGx0aHJvdWdoPV0KPiAgICBfX3ZnaWNf
djNfd3JpdGVfYXAwcm4oY3B1X2lmLT52Z2ljX2FwMHJbMl0sIDIpOwo+ICAgIF5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4KPiBhcmNoL2FybTY0L2t2bS9oeXAv
Li4vLi4vLi4vLi4vdmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmM6Mzg1OjI6IG5vdGU6IGhl
cmUKPiAgIGNhc2UgNjoKPiAgIF5+fn4KPiBhcmNoL2FybTY0L2t2bS9oeXAvLi4vLi4vLi4vLi4v
dmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmM6Mzg2OjM6IHdhcm5pbmc6IHRoaXMgc3RhdGVt
ZW50IG1heSBmYWxsIHRocm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQo+ICAgIF9fdmdp
Y192M193cml0ZV9hcDBybihjcHVfaWYtPnZnaWNfYXAwclsxXSwgMSk7Cj4gICAgXn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fgo+IGFyY2gvYXJtNjQva3ZtL2h5
cC8uLi8uLi8uLi8uLi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYzozODc6Mjogbm90ZTog
aGVyZQo+ICAgZGVmYXVsdDoKPiAgIF5+fn5+fn4KPiBhcmNoL2FybTY0L2t2bS9oeXAvLi4vLi4v
Li4vLi4vdmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmM6Mzk0OjM6IHdhcm5pbmc6IHRoaXMg
c3RhdGVtZW50IG1heSBmYWxsIHRocm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQo+ICAg
IF9fdmdpY192M193cml0ZV9hcDFybihjcHVfaWYtPnZnaWNfYXAxclsyXSwgMik7Cj4gICAgXn5+
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fgo+IGFyY2gvYXJtNjQv
a3ZtL2h5cC8uLi8uLi8uLi8uLi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYzozOTU6Mjog
bm90ZTogaGVyZQo+ICAgY2FzZSA2Ogo+ICAgXn5+fgo+IGFyY2gvYXJtNjQva3ZtL2h5cC8uLi8u
Li8uLi8uLi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYzozOTY6Mzogd2FybmluZzogdGhp
cyBzdGF0ZW1lbnQgbWF5IGZhbGwgdGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1dCj4g
ICAgX192Z2ljX3YzX3dyaXRlX2FwMXJuKGNwdV9pZi0+dmdpY19hcDFyWzFdLCAxKTsKPiAgICBe
fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+Cj4gYXJjaC9hcm02
NC9rdm0vaHlwLy4uLy4uLy4uLy4uL3ZpcnQva3ZtL2FybS9oeXAvdmdpYy12My1zci5jOjM5Nzoy
OiBub3RlOiBoZXJlCj4gICBkZWZhdWx0Ogo+ICAgXn5+fn5+fgo+IAo+IFNpZ25lZC1vZmYtYnk6
IE1hdHRlbyBDcm9jZSA8bWNyb2NlQHJlZGhhdC5jb20+Cj4gLS0tCj4gIHZpcnQva3ZtL2FybS9o
eXAvdmdpYy12My1zci5jIHwgOCArKysrKysrKwo+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRp
b25zKCspCj4gCj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2FybS9oeXAvdmdpYy12My1zci5jIGIv
dmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmMKPiBpbmRleCAyNTRjNWYxOTBhM2QuLjYyMmZi
NGQxOGM1YyAxMDA2NDQKPiAtLS0gYS92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYwo+ICsr
KyBiL3ZpcnQva3ZtL2FybS9oeXAvdmdpYy12My1zci5jCj4gQEAgLTM0OSw4ICszNDksMTAgQEAg
dm9pZCBfX2h5cF90ZXh0IF9fdmdpY192M19zYXZlX2FwcnMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
KQo+ICAJY2FzZSA3Ogo+ICAJCWNwdV9pZi0+dmdpY19hcDByWzNdID0gX192Z2ljX3YzX3JlYWRf
YXAwcm4oMyk7Cj4gIAkJY3B1X2lmLT52Z2ljX2FwMHJbMl0gPSBfX3ZnaWNfdjNfcmVhZF9hcDBy
bigyKTsKPiArCQkvKiBmYWxsdGhyb3VnaCAqLwo+ICAJY2FzZSA2Ogo+ICAJCWNwdV9pZi0+dmdp
Y19hcDByWzFdID0gX192Z2ljX3YzX3JlYWRfYXAwcm4oMSk7Cj4gKwkJLyogZmFsbHRocm91Z2gg
Ki8KPiAgCWRlZmF1bHQ6Cj4gIAkJY3B1X2lmLT52Z2ljX2FwMHJbMF0gPSBfX3ZnaWNfdjNfcmVh
ZF9hcDBybigwKTsKPiAgCX0KPiBAQCAtMzU5LDggKzM2MSwxMCBAQCB2b2lkIF9faHlwX3RleHQg
X192Z2ljX3YzX3NhdmVfYXBycyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4gIAljYXNlIDc6Cj4g
IAkJY3B1X2lmLT52Z2ljX2FwMXJbM10gPSBfX3ZnaWNfdjNfcmVhZF9hcDFybigzKTsKPiAgCQlj
cHVfaWYtPnZnaWNfYXAxclsyXSA9IF9fdmdpY192M19yZWFkX2FwMXJuKDIpOwo+ICsJCS8qIGZh
bGx0aHJvdWdoICovCj4gIAljYXNlIDY6Cj4gIAkJY3B1X2lmLT52Z2ljX2FwMXJbMV0gPSBfX3Zn
aWNfdjNfcmVhZF9hcDFybigxKTsKPiArCQkvKiBmYWxsdGhyb3VnaCAqLwo+ICAJZGVmYXVsdDoK
PiAgCQljcHVfaWYtPnZnaWNfYXAxclswXSA9IF9fdmdpY192M19yZWFkX2FwMXJuKDApOwo+ICAJ
fQo+IEBAIC0zODIsOCArMzg2LDEwIEBAIHZvaWQgX19oeXBfdGV4dCBfX3ZnaWNfdjNfcmVzdG9y
ZV9hcHJzKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKPiAgCWNhc2UgNzoKPiAgCQlfX3ZnaWNfdjNf
d3JpdGVfYXAwcm4oY3B1X2lmLT52Z2ljX2FwMHJbM10sIDMpOwo+ICAJCV9fdmdpY192M193cml0
ZV9hcDBybihjcHVfaWYtPnZnaWNfYXAwclsyXSwgMik7Cj4gKwkJLyogZmFsbHRocm91Z2ggKi8K
PiAgCWNhc2UgNjoKPiAgCQlfX3ZnaWNfdjNfd3JpdGVfYXAwcm4oY3B1X2lmLT52Z2ljX2FwMHJb
MV0sIDEpOwo+ICsJCS8qIGZhbGx0aHJvdWdoICovCj4gIAlkZWZhdWx0Ogo+ICAJCV9fdmdpY192
M193cml0ZV9hcDBybihjcHVfaWYtPnZnaWNfYXAwclswXSwgMCk7Cj4gIAl9Cj4gQEAgLTM5Miw4
ICszOTgsMTAgQEAgdm9pZCBfX2h5cF90ZXh0IF9fdmdpY192M19yZXN0b3JlX2FwcnMoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1KQo+ICAJY2FzZSA3Ogo+ICAJCV9fdmdpY192M193cml0ZV9hcDFybihj
cHVfaWYtPnZnaWNfYXAxclszXSwgMyk7Cj4gIAkJX192Z2ljX3YzX3dyaXRlX2FwMXJuKGNwdV9p
Zi0+dmdpY19hcDFyWzJdLCAyKTsKPiArCQkvKiBmYWxsdGhyb3VnaCAqLwo+ICAJY2FzZSA2Ogo+
ICAJCV9fdmdpY192M193cml0ZV9hcDFybihjcHVfaWYtPnZnaWNfYXAxclsxXSwgMSk7Cj4gKwkJ
LyogZmFsbHRocm91Z2ggKi8KPiAgCWRlZmF1bHQ6Cj4gIAkJX192Z2ljX3YzX3dyaXRlX2FwMXJu
KGNwdV9pZi0+dmdpY19hcDFyWzBdLCAwKTsKPiAgCX0KPiAKCkFscmVhZHkgZml4ZWQgaGVyZVsx
XS4KCglNLgoKWzFdCmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwv
Z2l0L2t2bWFybS9rdm1hcm0uZ2l0L2NvbW1pdC8/aWQ9MWE4MjQ4Yzc0YzgxYTE1YTMyZGMzMzQ0
ZmI1YzYyMmUxOTA3Mjc5MQotLSAKSmF6eiBpcyBub3QgZGVhZCwgaXQganVzdCBzbWVsbHMgZnVu
bnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
