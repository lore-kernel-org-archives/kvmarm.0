Return-Path: <SRS0=m0cG=V2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412F5C433FF
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jul 2019 09:46:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BEE8920679
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jul 2019 09:46:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEE8920679
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4731F4A52C;
	Mon, 29 Jul 2019 05:46:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oytc39fpptJa; Mon, 29 Jul 2019 05:46:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F21E34A539;
	Mon, 29 Jul 2019 05:46:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C49B4A52B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jul 2019 05:46:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vrJ4UU1HWnuI for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jul 2019 05:46:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA74C4A2E7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jul 2019 05:46:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D7B8152D;
 Mon, 29 Jul 2019 02:46:18 -0700 (PDT)
Received: from [10.1.197.61] (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 BF3FB3F694; Mon, 29 Jul 2019 02:46:17 -0700 (PDT)
Subject: Re: [PATCH] KVM: arm64: mark expected switch fall-through
To: Matteo Croce <mcroce@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
References: <20190728225311.5414-1-mcroce@redhat.com>
From: Marc Zyngier <maz@kernel.org>
Organization: Approximate
Message-ID: <e14529dd-a517-afcb-24f3-198dc8ebb364@kernel.org>
Date: Mon, 29 Jul 2019 10:46:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190728225311.5414-1-mcroce@redhat.com>
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org
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

T24gMjgvMDcvMjAxOSAyMzo1MywgTWF0dGVvIENyb2NlIHdyb3RlOgo+IE1hcmsgc3dpdGNoIGNh
c2VzIHdoZXJlIHdlIGFyZSBleHBlY3RpbmcgdG8gZmFsbCB0aHJvdWdoLAo+IGZpeGVzIHRoZSBm
b2xsb3dpbmcgd2FybmluZzoKPiAKPiBJbiBmaWxlIGluY2x1ZGVkIGZyb20gLi9hcmNoL2FybTY0
L2luY2x1ZGUvYXNtL2t2bV9lbXVsYXRlLmg6MTksCj4gICAgICAgICAgICAgICAgICBmcm9tIGFy
Y2gvYXJtNjQva3ZtL3JlZ21hcC5jOjEzOgo+IGFyY2gvYXJtNjQva3ZtL3JlZ21hcC5jOiBJbiBm
dW5jdGlvbiDigJh2Y3B1X3dyaXRlX3Nwc3IzMuKAmToKPiAuL2FyY2gvYXJtNjQvaW5jbHVkZS9h
c20va3ZtX2h5cC5oOjMxOjM6IHdhcm5pbmc6IHRoaXMgc3RhdGVtZW50IG1heSBmYWxsIHRocm91
Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQo+ICAgIGFzbSB2b2xhdGlsZShBTFRFUk5BVElW
RShfX21zcl9zKHIjI252aCwgIiV4MCIpLCBcCj4gICAgXn5+Cj4gLi9hcmNoL2FybTY0L2luY2x1
ZGUvYXNtL2t2bV9oeXAuaDo0NjozMTogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmHdy
aXRlX3N5c3JlZ19lbHjigJkKPiAgI2RlZmluZSB3cml0ZV9zeXNyZWdfZWwxKHYscikgd3JpdGVf
c3lzcmVnX2VseCh2LCByLCBfRUwxLCBfRUwxMikKPiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgXn5+fn5+fn5+fn5+fn5+fgo+IGFyY2gvYXJtNjQva3ZtL3JlZ21hcC5jOjE4MDozOiBu
b3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCYd3JpdGVfc3lzcmVnX2VsMeKAmQo+ICAgIHdy
aXRlX3N5c3JlZ19lbDEodiwgU1lTX1NQU1IpOwo+ICAgIF5+fn5+fn5+fn5+fn5+fn4KPiBhcmNo
L2FybTY0L2t2bS9yZWdtYXAuYzoxODE6Mjogbm90ZTogaGVyZQo+ICAgY2FzZSBLVk1fU1BTUl9B
QlQ6Cj4gICBefn5+Cj4gSW4gZmlsZSBpbmNsdWRlZCBmcm9tIC4vYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9jcHV0eXBlLmg6MTMyLAo+ICAgICAgICAgICAgICAgICAgZnJvbSAuL2FyY2gvYXJtNjQv
aW5jbHVkZS9hc20vY2FjaGUuaDo4LAo+ICAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUv
bGludXgvY2FjaGUuaDo2LAo+ICAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgv
cHJpbnRrLmg6OSwKPiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L2tlcm5l
bC5oOjE1LAo+ICAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvYXNtLWdlbmVyaWMvYnVn
Lmg6MTgsCj4gICAgICAgICAgICAgICAgICBmcm9tIC4vYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9i
dWcuaDoyNiwKPiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L2J1Zy5oOjUs
Cj4gICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC9tbWRlYnVnLmg6NSwKPiAg
ICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L21tLmg6OSwKPiAgICAgICAgICAg
ICAgICAgIGZyb20gYXJjaC9hcm02NC9rdm0vcmVnbWFwLmM6MTE6Cj4gLi9hcmNoL2FybTY0L2lu
Y2x1ZGUvYXNtL3N5c3JlZy5oOjgzNzoyOiB3YXJuaW5nOiB0aGlzIHN0YXRlbWVudCBtYXkgZmFs
bCB0aHJvdWdoIFstV2ltcGxpY2l0LWZhbGx0aHJvdWdoPV0KPiAgIGFzbSB2b2xhdGlsZSgibXNy
ICIgX19zdHJpbmdpZnkocikgIiwgJXgwIiAgXAo+ICAgXn5+Cj4gYXJjaC9hcm02NC9rdm0vcmVn
bWFwLmM6MTgyOjM6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJh3cml0ZV9zeXNyZWfi
gJkKPiAgICB3cml0ZV9zeXNyZWcodiwgc3Bzcl9hYnQpOwo+ICAgIF5+fn5+fn5+fn5+fgo+IGFy
Y2gvYXJtNjQva3ZtL3JlZ21hcC5jOjE4MzoyOiBub3RlOiBoZXJlCj4gICBjYXNlIEtWTV9TUFNS
X1VORDoKPiAgIF5+fn4KPiBJbiBmaWxlIGluY2x1ZGVkIGZyb20gLi9hcmNoL2FybTY0L2luY2x1
ZGUvYXNtL2NwdXR5cGUuaDoxMzIsCj4gICAgICAgICAgICAgICAgICBmcm9tIC4vYXJjaC9hcm02
NC9pbmNsdWRlL2FzbS9jYWNoZS5oOjgsCj4gICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVk
ZS9saW51eC9jYWNoZS5oOjYsCj4gICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51
eC9wcmludGsuaDo5LAo+ICAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgva2Vy
bmVsLmg6MTUsCj4gICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9hc20tZ2VuZXJpYy9i
dWcuaDoxOCwKPiAgICAgICAgICAgICAgICAgIGZyb20gLi9hcmNoL2FybTY0L2luY2x1ZGUvYXNt
L2J1Zy5oOjI2LAo+ICAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvYnVnLmg6
NSwKPiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xpbnV4L21tZGVidWcuaDo1LAo+
ICAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvbW0uaDo5LAo+ICAgICAgICAg
ICAgICAgICAgZnJvbSBhcmNoL2FybTY0L2t2bS9yZWdtYXAuYzoxMToKPiAuL2FyY2gvYXJtNjQv
aW5jbHVkZS9hc20vc3lzcmVnLmg6ODM3OjI6IHdhcm5pbmc6IHRoaXMgc3RhdGVtZW50IG1heSBm
YWxsIHRocm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQo+ICAgYXNtIHZvbGF0aWxlKCJt
c3IgIiBfX3N0cmluZ2lmeShyKSAiLCAleDAiICBcCj4gICBefn4KPiBhcmNoL2FybTY0L2t2bS9y
ZWdtYXAuYzoxODQ6Mzogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmHdyaXRlX3N5c3Jl
Z+KAmQo+ICAgIHdyaXRlX3N5c3JlZyh2LCBzcHNyX3VuZCk7Cj4gICAgXn5+fn5+fn5+fn5+Cj4g
YXJjaC9hcm02NC9rdm0vcmVnbWFwLmM6MTg1OjI6IG5vdGU6IGhlcmUKPiAgIGNhc2UgS1ZNX1NQ
U1JfSVJROgo+ICAgXn5+fgo+IEluIGZpbGUgaW5jbHVkZWQgZnJvbSAuL2FyY2gvYXJtNjQvaW5j
bHVkZS9hc20vY3B1dHlwZS5oOjEzMiwKPiAgICAgICAgICAgICAgICAgIGZyb20gLi9hcmNoL2Fy
bTY0L2luY2x1ZGUvYXNtL2NhY2hlLmg6OCwKPiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNs
dWRlL2xpbnV4L2NhY2hlLmg6NiwKPiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2xp
bnV4L3ByaW50ay5oOjksCj4gICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC9r
ZXJuZWwuaDoxNSwKPiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRlL2FzbS1nZW5lcmlj
L2J1Zy5oOjE4LAo+ICAgICAgICAgICAgICAgICAgZnJvbSAuL2FyY2gvYXJtNjQvaW5jbHVkZS9h
c20vYnVnLmg6MjYsCj4gICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC9idWcu
aDo1LAo+ICAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgvbW1kZWJ1Zy5oOjUs
Cj4gICAgICAgICAgICAgICAgICBmcm9tIC4vaW5jbHVkZS9saW51eC9tbS5oOjksCj4gICAgICAg
ICAgICAgICAgICBmcm9tIGFyY2gvYXJtNjQva3ZtL3JlZ21hcC5jOjExOgo+IC4vYXJjaC9hcm02
NC9pbmNsdWRlL2FzbS9zeXNyZWcuaDo4Mzc6Mjogd2FybmluZzogdGhpcyBzdGF0ZW1lbnQgbWF5
IGZhbGwgdGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1dCj4gICBhc20gdm9sYXRpbGUo
Im1zciAiIF9fc3RyaW5naWZ5KHIpICIsICV4MCIgIFwKPiAgIF5+fgo+IGFyY2gvYXJtNjQva3Zt
L3JlZ21hcC5jOjE4NjozOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCYd3JpdGVfc3lz
cmVn4oCZCj4gICAgd3JpdGVfc3lzcmVnKHYsIHNwc3JfaXJxKTsKPiAgICBefn5+fn5+fn5+fn4K
PiBhcmNoL2FybTY0L2t2bS9yZWdtYXAuYzoxODc6Mjogbm90ZTogaGVyZQo+ICAgY2FzZSBLVk1f
U1BTUl9GSVE6Cj4gICBefn5+Cj4gCj4gU2lnbmVkLW9mZi1ieTogTWF0dGVvIENyb2NlIDxtY3Jv
Y2VAcmVkaGF0LmNvbT4KPiAtLS0KPiAgYXJjaC9hcm02NC9rdm0vcmVnbWFwLmMgfCA0ICsrKysK
PiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKQo+IAo+IGRpZmYgLS1naXQgYS9hcmNo
L2FybTY0L2t2bS9yZWdtYXAuYyBiL2FyY2gvYXJtNjQva3ZtL3JlZ21hcC5jCj4gaW5kZXggMGQ2
MGU0ZjBhZjY2Li5iMzc2YjJmZGJmNTEgMTAwNjQ0Cj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vcmVn
bWFwLmMKPiArKysgYi9hcmNoL2FybTY0L2t2bS9yZWdtYXAuYwo+IEBAIC0xNzgsMTIgKzE3OCwx
NiBAQCB2b2lkIHZjcHVfd3JpdGVfc3BzcjMyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdW5zaWdu
ZWQgbG9uZyB2KQo+ICAJc3dpdGNoIChzcHNyX2lkeCkgewo+ICAJY2FzZSBLVk1fU1BTUl9TVkM6
Cj4gIAkJd3JpdGVfc3lzcmVnX2VsMSh2LCBTWVNfU1BTUik7Cj4gKwkJLyogZmFsbHRocm91Z2gg
Ki8KPiAgCWNhc2UgS1ZNX1NQU1JfQUJUOgo+ICAJCXdyaXRlX3N5c3JlZyh2LCBzcHNyX2FidCk7
Cj4gKwkJLyogZmFsbHRocm91Z2ggKi8KPiAgCWNhc2UgS1ZNX1NQU1JfVU5EOgo+ICAJCXdyaXRl
X3N5c3JlZyh2LCBzcHNyX3VuZCk7Cj4gKwkJLyogZmFsbHRocm91Z2ggKi8KPiAgCWNhc2UgS1ZN
X1NQU1JfSVJROgo+ICAJCXdyaXRlX3N5c3JlZyh2LCBzcHNyX2lycSk7Cj4gKwkJLyogZmFsbHRo
cm91Z2ggKi8KPiAgCWNhc2UgS1ZNX1NQU1JfRklROgo+ICAJCXdyaXRlX3N5c3JlZyh2LCBzcHNy
X2ZpcSk7Cj4gIAl9Cj4gCgpUaGF0J3MgYWJzb2x1dGVseSB0aGUgKldST05HKiBmaXguIFBsZWFz
ZSBzZWUgWzFdIGZvciB0aGUgcmVhbCB0aGluZy4KClRoYW5rcywKCglNLgoKWzFdCmh0dHBzOi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2t2bWFybS9rdm1hcm0uZ2l0
L2NvbW1pdC8/aWQ9M2Q1ODRhM2M4NWQ2ZmUyY2Y4NzhmMjIwZDRhZDcxNDVlN2Y4OTIxOAotLSAK
SmF6eiBpcyBub3QgZGVhZCwgaXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1h
cm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21h
aWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
