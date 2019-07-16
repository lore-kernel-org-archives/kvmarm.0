Return-Path: <SRS0=eCDF=VN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A46B3C7618F
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 15:18:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3E04A2173B
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jul 2019 15:18:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3E04A2173B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8E8C4A541;
	Tue, 16 Jul 2019 11:18:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id kOHbkT6SmSxQ; Tue, 16 Jul 2019 11:18:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E2754A53E;
	Tue, 16 Jul 2019 11:18:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 657634A53D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 11:18:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9cTIm8BMroBM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jul 2019 11:18:11 -0400 (EDT)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B58E74A53C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jul 2019 11:18:10 -0400 (EDT)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
 by Forcepoint Email with ESMTP id 500C491AD3FBB4DAFBEF;
 Tue, 16 Jul 2019 23:18:06 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 16 Jul 2019
 23:17:59 +0800
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 kvm_pmu_get_canonical_pmc+0x48/0x78
From: Zenghui Yu <yuzenghui@huawei.com>
To: <kvmarm@lists.cs.columbia.edu>
References: <644e3455-ea6d-697a-e452-b58961341381@huawei.com>
Message-ID: <f9d5d18a-7631-f3e2-d73a-21d8eee183f1@huawei.com>
Date: Tue, 16 Jul 2019 23:14:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <644e3455-ea6d-697a-e452-b58961341381@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org,
 kasan-dev@googlegroups.com
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Ck9uIDIwMTkvNy8xNiAyMzowNSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBIaSBmb2xrcywKPiAKPiBS
dW5uaW5nIHRoZSBsYXRlc3Qga2VybmVsIHdpdGggS0FTQU4gZW5hYmxlZCwgd2Ugd2lsbCBoaXQg
dGhlIGZvbGxvd2luZwo+IEtBU0FOIEJVRyBkdXJpbmcgZ3Vlc3QncyBib290IHByb2Nlc3MuCj4g
Cj4gSSdtIGluIGNvbW1pdCA5NjM3ZDUxNzM0N2U4MGVlMmZlMWM1ZDhjZTQ1YmExYjg4ZDhiNWNk
Lgo+IAo+IEFueSBwcm9ibGVtcyBpbiB0aGUgY2hhaW5lZCBQTVUgY29kZT8gT3IganVzdCBhIGZh
bHNlIHBvc2l0aXZlPwo+IAo+IC0tLTg8LS0tCj4gCj4gW8KgIDY1NC43MDYyNjhdIAo+ID09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQo+IFvCoCA2NTQuNzA2MjgwXSBCVUc6IEtBU0FOOiBzbGFiLW91dC1vZi1ib3VuZHMgaW4g
Cj4ga3ZtX3BtdV9nZXRfY2Fub25pY2FsX3BtYysweDQ4LzB4NzgKPiBbwqAgNjU0LjcwNjI4Nl0g
UmVhZCBvZiBzaXplIDggYXQgYWRkciBmZmZmODAxZDZjOGZlYTM4IGJ5IHRhc2sgCj4gcWVtdS1r
dm0vMjMyNjgKPiAKPiBbwqAgNjU0LjcwNjI5Nl0gQ1BVOiAyIFBJRDogMjMyNjggQ29tbTogcWVt
dS1rdm0gTm90IHRhaW50ZWQgNS4yLjArICMxNzgKPiBbwqAgNjU0LjcwNjMwMV0gSGFyZHdhcmUg
bmFtZTogSHVhd2VpIFRhaVNoYW4gMjI4MCAvQkMxMVNQQ0QsIEJJT1MgMS41OCAKPiAxMC8yNC8y
MDE4Cj4gW8KgIDY1NC43MDYzMDVdIENhbGwgdHJhY2U6Cj4gW8KgIDY1NC43MDYzMTFdwqAgZHVt
cF9iYWNrdHJhY2UrMHgwLzB4MjM4Cj4gW8KgIDY1NC43MDYzMTddwqAgc2hvd19zdGFjaysweDI0
LzB4MzAKPiBbwqAgNjU0LjcwNjMyNV3CoCBkdW1wX3N0YWNrKzB4ZTAvMHgxMzQKPiBbwqAgNjU0
LjcwNjMzMl3CoCBwcmludF9hZGRyZXNzX2Rlc2NyaXB0aW9uKzB4ODAvMHg0MDgKPiBbwqAgNjU0
LjcwNjMzOF3CoCBfX2thc2FuX3JlcG9ydCsweDE2NC8weDFhMAo+IFvCoCA2NTQuNzA2MzQzXcKg
IGthc2FuX3JlcG9ydCsweGMvMHgxOAo+IFvCoCA2NTQuNzA2MzQ4XcKgIF9fYXNhbl9sb2FkOCsw
eDg4LzB4YjAKPiBbwqAgNjU0LjcwNjM1M13CoCBrdm1fcG11X2dldF9jYW5vbmljYWxfcG1jKzB4
NDgvMHg3OAoKSSBub3RpY2VkIHRoYXQgd2Ugd2lsbCB1c2UgInBtYy0+aWR4IiBhbmQgdGhlICJj
aGFpbmVkIiBiaXRtYXAgdG8KZGV0ZXJtaW5lIGlmIHRoZSBwbWMgaXMgY2hhaW5lZCwgaW4ga3Zt
X3BtdV9wbWNfaXNfY2hhaW5lZCgpLgoKU2hvdWxkIHdlIGluaXRpYWxpemUgdGhlIGlkeCBhbmQg
dGhlIGJpdG1hcCBhcHByb3ByaWF0ZWx5IGJlZm9yZQpkb2luZyBrdm1fcG11X3N0b3BfY291bnRl
cigpPyAgTGlrZToKCgpkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJtL3BtdS5jIGIvdmlydC9rdm0v
YXJtL3BtdS5jCmluZGV4IDNkZDgyMzguLmNmMzExOWEgMTAwNjQ0Ci0tLSBhL3ZpcnQva3ZtL2Fy
bS9wbXUuYworKysgYi92aXJ0L2t2bS9hcm0vcG11LmMKQEAgLTIyNCwxMiArMjI0LDEyIEBAIHZv
aWQga3ZtX3BtdV92Y3B1X3Jlc2V0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKICAJaW50IGk7CiAg
CXN0cnVjdCBrdm1fcG11ICpwbXUgPSAmdmNwdS0+YXJjaC5wbXU7CgorCWJpdG1hcF96ZXJvKHZj
cHUtPmFyY2gucG11LmNoYWluZWQsIEFSTVY4X1BNVV9NQVhfQ09VTlRFUl9QQUlSUyk7CisKICAJ
Zm9yIChpID0gMDsgaSA8IEFSTVY4X1BNVV9NQVhfQ09VTlRFUlM7IGkrKykgewotCQlrdm1fcG11
X3N0b3BfY291bnRlcih2Y3B1LCAmcG11LT5wbWNbaV0pOwogIAkJcG11LT5wbWNbaV0uaWR4ID0g
aTsKKwkJa3ZtX3BtdV9zdG9wX2NvdW50ZXIodmNwdSwgJnBtdS0+cG1jW2ldKTsKICAJfQotCi0J
Yml0bWFwX3plcm8odmNwdS0+YXJjaC5wbXUuY2hhaW5lZCwgQVJNVjhfUE1VX01BWF9DT1VOVEVS
X1BBSVJTKTsKICB9CgogIC8qKgoKClRoYW5rcywKemVuZ2h1aQoKPiBbwqAgNjU0LjcwNjM1OF3C
oCBrdm1fcG11X3N0b3BfY291bnRlcisweDI4LzB4MTE4Cj4gW8KgIDY1NC43MDYzNjNdwqAga3Zt
X3BtdV92Y3B1X3Jlc2V0KzB4NjAvMHhhOAo+IFvCoCA2NTQuNzA2MzY5XcKgIGt2bV9yZXNldF92
Y3B1KzB4MzAvMHg0ZDgKPiBbwqAgNjU0LjcwNjM3Nl3CoCBrdm1fYXJjaF92Y3B1X2lvY3RsKzB4
YTA0LzB4YzE4Cj4gW8KgIDY1NC43MDYzODFdwqAga3ZtX3ZjcHVfaW9jdGwrMHgxN2MvMHhkZTgK
PiBbwqAgNjU0LjcwNjM4N13CoCBkb192ZnNfaW9jdGwrMHgxNTAvMHhhZjgKPiBbwqAgNjU0Ljcw
NjM5Ml3CoCBrc3lzX2lvY3RsKzB4ODQvMHhiOAo+IFvCoCA2NTQuNzA2Mzk3XcKgIF9fYXJtNjRf
c3lzX2lvY3RsKzB4NGMvMHg2MAo+IFvCoCA2NTQuNzA2NDAzXcKgIGVsMF9zdmNfY29tbW9uLmNv
bnN0cHJvcC4wKzB4YjQvMHgyMDgKPiBbwqAgNjU0LjcwNjQwOV3CoCBlbDBfc3ZjX2hhbmRsZXIr
MHgzYy8weGE4Cj4gW8KgIDY1NC43MDY0MTRdwqAgZWwwX3N2YysweDgvMHhjCj4gCj4gW8KgIDY1
NC43MDY0MjJdIEFsbG9jYXRlZCBieSB0YXNrIDIzMjY4Ogo+IFvCoCA2NTQuNzA2NDI5XcKgIF9f
a2FzYW5fa21hbGxvYy5pc3JhLjArMHhkMC8weDE4MAo+IFvCoCA2NTQuNzA2NDM1XcKgIGthc2Fu
X3NsYWJfYWxsb2MrMHgxNC8weDIwCj4gW8KgIDY1NC43MDY0NDBdwqAga21lbV9jYWNoZV9hbGxv
YysweDE3Yy8weDRhOAo+IFvCoCA2NTQuNzA2NDQ1XcKgIGt2bV9hcmNoX3ZjcHVfY3JlYXRlKzB4
YTAvMHgxMzAKPiBbwqAgNjU0LjcwNjQ1MV3CoCBrdm1fdm1faW9jdGwrMHg4NDQvMHgxMjE4Cj4g
W8KgIDY1NC43MDY0NTZdwqAgZG9fdmZzX2lvY3RsKzB4MTUwLzB4YWY4Cj4gW8KgIDY1NC43MDY0
NjFdwqAga3N5c19pb2N0bCsweDg0LzB4YjgKPiBbwqAgNjU0LjcwNjQ2Nl3CoCBfX2FybTY0X3N5
c19pb2N0bCsweDRjLzB4NjAKPiBbwqAgNjU0LjcwNjQ3Ml3CoCBlbDBfc3ZjX2NvbW1vbi5jb25z
dHByb3AuMCsweGI0LzB4MjA4Cj4gW8KgIDY1NC43MDY0NzhdwqAgZWwwX3N2Y19oYW5kbGVyKzB4
M2MvMHhhOAo+IFvCoCA2NTQuNzA2NDgyXcKgIGVsMF9zdmMrMHg4LzB4Ywo+IAo+IFvCoCA2NTQu
NzA2NDkwXSBGcmVlZCBieSB0YXNrIDA6Cj4gW8KgIDY1NC43MDY0OTNdIChzdGFjayBpcyBub3Qg
YXZhaWxhYmxlKQo+IAo+IFvCoCA2NTQuNzA2NTAxXSBUaGUgYnVnZ3kgYWRkcmVzcyBiZWxvbmdz
IHRvIHRoZSBvYmplY3QgYXQgZmZmZjgwMWQ2YzhmYzAxMAo+ICDCoHdoaWNoIGJlbG9uZ3MgdG8g
dGhlIGNhY2hlIGt2bV92Y3B1IG9mIHNpemUgMTA3ODQKPiBbwqAgNjU0LjcwNjUwN10gVGhlIGJ1
Z2d5IGFkZHJlc3MgaXMgbG9jYXRlZCA4IGJ5dGVzIHRvIHRoZSByaWdodCBvZgo+ICDCoDEwNzg0
LWJ5dGUgcmVnaW9uIFtmZmZmODAxZDZjOGZjMDEwLCBmZmZmODAxZDZjOGZlYTMwKQo+IFvCoCA2
NTQuNzA2NTEwXSBUaGUgYnVnZ3kgYWRkcmVzcyBiZWxvbmdzIHRvIHRoZSBwYWdlOgo+IFvCoCA2
NTQuNzA2NTE2XSBwYWdlOmZmZmY3ZTAwNzViMjNmMDAgcmVmY291bnQ6MSBtYXBjb3VudDowIAo+
IG1hcHBpbmc6ZmZmZjgwMWRiMjU3ZTQ4MCBpbmRleDoweDAgY29tcG91bmRfbWFwY291bnQ6IDAK
PiBbwqAgNjU0LjcwNjUyNF0gZmxhZ3M6IDB4ZmZmZmUwMDAwMDEwMjAwKHNsYWJ8aGVhZCkKPiBb
wqAgNjU0LjcwNjUzMl0gcmF3OiAwZmZmZmUwMDAwMDEwMjAwIGZmZmY4MDFkYjI1ODZlZTAgZmZm
ZjgwMWRiMjU4NmVlMCAKPiBmZmZmODAxZGIyNTdlNDgwCj4gW8KgIDY1NC43MDY1MzhdIHJhdzog
MDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDEwMDAxIDAwMDAwMDAxZmZmZmZmZmYgCj4gMDAw
MDAwMDAwMDAwMDAwMAo+IFvCoCA2NTQuNzA2NTQyXSBwYWdlIGR1bXBlZCBiZWNhdXNlOiBrYXNh
bjogYmFkIGFjY2VzcyBkZXRlY3RlZAo+IAo+IFvCoCA2NTQuNzA2NTQ5XSBNZW1vcnkgc3RhdGUg
YXJvdW5kIHRoZSBidWdneSBhZGRyZXNzOgo+IFvCoCA2NTQuNzA2NTU0XcKgIGZmZmY4MDFkNmM4
ZmU5MDA6IDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIDAwIAo+IDAwIDAwIDAw
Cj4gW8KgIDY1NC43MDY1NjBdwqAgZmZmZjgwMWQ2YzhmZTk4MDogMDAgMDAgMDAgMDAgMDAgMDAg
MDAgMDAgMDAgMDAgMDAgMDAgMDAgCj4gMDAgMDAgMDAKPiBbwqAgNjU0LjcwNjU2NV0gPmZmZmY4
MDFkNmM4ZmVhMDA6IDAwIDAwIDAwIDAwIDAwIDAwIGZjIGZjIGZjIGZjIGZjIGZjIGZjIAo+IGZj
IGZjIGZjCj4gW8KgIDY1NC43MDY1NjhdwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgXgo+IFvCoCA2
NTQuNzA2NTczXcKgIGZmZmY4MDFkNmM4ZmVhODA6IGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZj
IGZjIGZjIGZjIGZjIAo+IGZjIGZjIGZjCj4gW8KgIDY1NC43MDY1NzhdwqAgZmZmZjgwMWQ2Yzhm
ZWIwMDogZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgZmMgCj4gZmMgZmMgZmMK
PiBbwqAgNjU0LjcwNjU4Ml0gCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
