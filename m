Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38BD7C352A2
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 10:19:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C9FF221741
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 10:19:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C9FF221741
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 415D14A522;
	Fri,  7 Feb 2020 05:19:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z4mgtbv6gatY; Fri,  7 Feb 2020 05:19:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A7BF4A4C0;
	Fri,  7 Feb 2020 05:19:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 684874A4C0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 05:19:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BiK2JT26UFof for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 05:19:30 -0500 (EST)
Received: from huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B07A94A418
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 05:19:30 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 9C53C2CE6D0BD3553543;
 Fri,  7 Feb 2020 18:19:27 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Fri, 7 Feb 2020
 18:19:19 +0800
Subject: Re: BUG: using __this_cpu_read() in preemptible [00000000] code
To: Marc Zyngier <maz@kernel.org>
References: <318984f6-bc36-33a3-abc6-bf2295974b06@huawei.com>
 <828d3b538b7258f692f782b6798277cf@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <3e90c020-e7f3-61f1-3731-a489df0b1d9c@huawei.com>
Date: Fri, 7 Feb 2020 18:19:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <828d3b538b7258f692f782b6798277cf@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

SGkgTWFyYywKCk9uIDIwMjAvMi83IDE3OjE5LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gSGkgWmVu
Z2h1aSwKPiAKPiBPbiAyMDIwLTAyLTA3IDA5OjAwLCBaZW5naHVpIFl1IHdyb3RlOgo+PiBIaSwK
Pj4KPj4gUnVubmluZyBhIGxhdGVzdCBwcmVlbXB0aWJsZSBrZXJuZWwgYW5kIHNvbWUgZ3Vlc3Rz
IG9uIGl0LAo+PiBJIGdvdCB0aGUgZm9sbG93aW5nIG1lc3NhZ2UsCj4+Cj4+IC0tLTg8LS0tCj4+
Cj4+IFvCoCA2MzAuMDMxODcwXSBCVUc6IHVzaW5nIF9fdGhpc19jcHVfcmVhZCgpIGluIHByZWVt
cHRpYmxlIFswMDAwMDAwMF0KPj4gY29kZTogcWVtdS1zeXN0ZW0tYWFyLzM3MjcwCj4+IFvCoCA2
MzAuMDMxODcyXSBjYWxsZXIgaXMga3ZtX2dldF9ydW5uaW5nX3ZjcHUrMHgxYy8weDM4Cj4+IFvC
oCA2MzAuMDMxODc0XSBDUFU6IDMyIFBJRDogMzcyNzAgQ29tbTogcWVtdS1zeXN0ZW0tYWFyIEtk
dW1wOiBsb2FkZWQKPj4gTm90IHRhaW50ZWQgNS41LjArCj4+IFvCoCA2MzAuMDMxODc2XSBIYXJk
d2FyZSBuYW1lOiBIdWF3ZWkgVGFpU2hhbiAyMjgwIC9CQzExU1BDRCwgQklPUyAxLjU4Cj4+IDEw
LzI5LzIwMTgKPj4gW8KgIDYzMC4wMzE4NzZdIENhbGwgdHJhY2U6Cj4+IFvCoCA2MzAuMDMxODc4
XcKgIGR1bXBfYmFja3RyYWNlKzB4MC8weDIwMAo+PiBbwqAgNjMwLjAzMTg4MF3CoCBzaG93X3N0
YWNrKzB4MjQvMHgzMAo+PiBbwqAgNjMwLjAzMTg4Ml3CoCBkdW1wX3N0YWNrKzB4YjAvMHhmNAo+
PiBbwqAgNjMwLjAzMTg4NF3CoCBfX3RoaXNfY3B1X3ByZWVtcHRfY2hlY2srMHhjOC8weGQwCj4+
IFvCoCA2MzAuMDMxODg2XcKgIGt2bV9nZXRfcnVubmluZ192Y3B1KzB4MWMvMHgzOAo+PiBbwqAg
NjMwLjAzMTg4OF3CoCB2Z2ljX21taW9fY2hhbmdlX2FjdGl2ZS5pc3JhLjQrMHgyYy8weGUwCj4+
IFvCoCA2MzAuMDMxODkwXcKgIF9fdmdpY19tbWlvX3dyaXRlX2NhY3RpdmUrMHg4MC8weGM4Cj4+
IFvCoCA2MzAuMDMxODkyXcKgIHZnaWNfbW1pb191YWNjZXNzX3dyaXRlX2NhY3RpdmUrMHgzYy8w
eDUwCj4+IFvCoCA2MzAuMDMxODk0XcKgIHZnaWNfdWFjY2VzcysweGNjLzB4MTM4Cj4+IFvCoCA2
MzAuMDMxODk2XcKgIHZnaWNfdjNfcmVkaXN0X3VhY2Nlc3MrMHg3Yy8weGE4Cj4+IFvCoCA2MzAu
MDMxODk4XcKgIHZnaWNfdjNfYXR0cl9yZWdzX2FjY2VzcysweDFhOC8weDIzMAo+PiBbwqAgNjMw
LjAzMTkwMV3CoCB2Z2ljX3YzX3NldF9hdHRyKzB4MWI0LzB4MjkwCj4+IFvCoCA2MzAuMDMxOTAz
XcKgIGt2bV9kZXZpY2VfaW9jdGxfYXR0cisweGJjLzB4MTEwCj4+IFvCoCA2MzAuMDMxOTA1XcKg
IGt2bV9kZXZpY2VfaW9jdGwrMHhjNC8weDEwOAo+PiBbwqAgNjMwLjAzMTkwN13CoCBrc3lzX2lv
Y3RsKzB4YjQvMHhkMAo+PiBbwqAgNjMwLjAzMTkwOV3CoCBfX2FybTY0X3N5c19pb2N0bCsweDI4
LzB4MzgKPj4gW8KgIDYzMC4wMzE5MTFdwqAgZWwwX3N2Y19jb21tb24uY29uc3Rwcm9wLjErMHg3
Yy8weDFhMAo+PiBbwqAgNjMwLjAzMTkxM13CoCBkb19lbDBfc3ZjKzB4MzQvMHhhMAo+PiBbwqAg
NjMwLjAzMTkxNV3CoCBlbDBfc3luY19oYW5kbGVyKzB4MTI0LzB4Mjc0Cj4+IFvCoCA2MzAuMDMx
OTE2XcKgIGVsMF9zeW5jKzB4MTQwLzB4MTgwCj4+Cj4+IC0tLTg8LS0tCj4+Cj4+IEknbSBub3cg
YXQgY29tbWl0IDkwNTY4ZWNmNTYxNTQwZmEzMzA1MTFlMjFmY2Q4MjNiMGMzODI5YzYuCj4+Cj4+
IEFuZCBpdCBsb29rcyBsaWtlIHZnaWNfZ2V0X21taW9fcmVxdWVzdGVyX3ZjcHUoKSB3YXMgYnJv
a2VuIGJ5Cj4+IDc0OTVlMjJiYjE2NSAoIktWTTogTW92ZSBydW5uaW5nIFZDUFUgZnJvbSBBUk0g
dG8gY29tbW9uIGNvZGUiKS4KPj4KPj4gQ291bGQgYW55b25lIHBsZWFzZSBoYXZlIGEgbG9vaz8K
PiAKPiBIZXJlIHlvdSBnbzoKPiAKPiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJtL3ZnaWMvdmdp
Yy1tbWlvLmMgYi92aXJ0L2t2bS9hcm0vdmdpYy92Z2ljLW1taW8uYwo+IGluZGV4IGQ2NTZlYmQ1
ZjlkNC4uZTE3MzVmMTljOTI0IDEwMDY0NAo+IC0tLSBhL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMt
bW1pby5jCj4gKysrIGIvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLmMKPiBAQCAtMTkwLDYg
KzE5MCwxNSBAQCB1bnNpZ25lZCBsb25nIHZnaWNfbW1pb19yZWFkX3BlbmRpbmcoc3RydWN0IAo+
IGt2bV92Y3B1ICp2Y3B1LAo+ICDCoCAqIHZhbHVlIGxhdGVyIHdpbGwgZ2l2ZSB1cyB0aGUgc2Ft
ZSB2YWx1ZSBhcyB3ZSB1cGRhdGUgdGhlIHBlci1DUFUgCj4gdmFyaWFibGUKPiAgwqAgKiBpbiB0
aGUgcHJlZW1wdCBub3RpZmllciBoYW5kbGVycy4KPiAgwqAgKi8KPiArc3RhdGljIHN0cnVjdCBr
dm1fdmNwdSAqdmdpY19nZXRfbW1pb19yZXF1ZXN0ZXJfdmNwdSh2b2lkKQo+ICt7Cj4gK8KgwqDC
oCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHU7Cj4gKwo+ICvCoMKgwqAgcHJlZW1wdF9kaXNhYmxlKCk7
Cj4gK8KgwqDCoCB2Y3B1ID0ga3ZtX2dldF9ydW5uaW5nX3ZjcHUoKTsKPiArwqDCoMKgIHByZWVt
cHRfZW5hYmxlKCk7Cj4gK8KgwqDCoCByZXR1cm4gdmNwdTsKPiArfQo+IAo+ICDCoC8qIE11c3Qg
YmUgY2FsbGVkIHdpdGggaXJxLT5pcnFfbG9jayBoZWxkICovCj4gIMKgc3RhdGljIHZvaWQgdmdp
Y19od19pcnFfc3BlbmRpbmcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3QgCj4gdmdpY19p
cnEgKmlycSwKPiBAQCAtMjEyLDcgKzIyMSw3IEBAIHZvaWQgdmdpY19tbWlvX3dyaXRlX3NwZW5k
aW5nKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGdwYV90IGFkZHIsIHVuc2lnbmVkIGludCBsZW4sCj4gIMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBsb25nIHZhbCkKPiAgwqB7Cj4gLcKgwqDC
oCBib29sIGlzX3VhY2Nlc3MgPSAha3ZtX2dldF9ydW5uaW5nX3ZjcHUoKTsKPiArwqDCoMKgIGJv
b2wgaXNfdWFjY2VzcyA9ICF2Z2ljX2dldF9tbWlvX3JlcXVlc3Rlcl92Y3B1KCk7Cj4gIMKgwqDC
oMKgIHUzMiBpbnRpZCA9IFZHSUNfQUREUl9UT19JTlRJRChhZGRyLCAxKTsKPiAgwqDCoMKgwqAg
aW50IGk7Cj4gIMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7Cj4gQEAgLTI2NSw3ICsyNzQs
NyBAQCB2b2lkIHZnaWNfbW1pb193cml0ZV9jcGVuZGluZyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUs
Cj4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBncGFfdCBhZGRyLCB1bnNp
Z25lZCBpbnQgbGVuLAo+ICDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdW5z
aWduZWQgbG9uZyB2YWwpCj4gIMKgewo+IC3CoMKgwqAgYm9vbCBpc191YWNjZXNzID0gIWt2bV9n
ZXRfcnVubmluZ192Y3B1KCk7Cj4gK8KgwqDCoCBib29sIGlzX3VhY2Nlc3MgPSAhdmdpY19nZXRf
bW1pb19yZXF1ZXN0ZXJfdmNwdSgpOwo+ICDCoMKgwqDCoCB1MzIgaW50aWQgPSBWR0lDX0FERFJf
VE9fSU5USUQoYWRkciwgMSk7Cj4gIMKgwqDCoMKgIGludCBpOwo+ICDCoMKgwqDCoCB1bnNpZ25l
ZCBsb25nIGZsYWdzOwo+IEBAIC0zMjYsNyArMzM1LDcgQEAgc3RhdGljIHZvaWQgdmdpY19tbWlv
X2NoYW5nZV9hY3RpdmUoc3RydWN0IGt2bV92Y3B1IAo+ICp2Y3B1LCBzdHJ1Y3QgdmdpY19pcnEg
KmlycSwKPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBib29sIGFj
dGl2ZSkKPiAgwqB7Cj4gIMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7Cj4gLcKgwqDCoCBz
dHJ1Y3Qga3ZtX3ZjcHUgKnJlcXVlc3Rlcl92Y3B1ID0ga3ZtX2dldF9ydW5uaW5nX3ZjcHUoKTsK
PiArwqDCoMKgIHN0cnVjdCBrdm1fdmNwdSAqcmVxdWVzdGVyX3ZjcHUgPSB2Z2ljX2dldF9tbWlv
X3JlcXVlc3Rlcl92Y3B1KCk7Cj4gCj4gIMKgwqDCoMKgIHJhd19zcGluX2xvY2tfaXJxc2F2ZSgm
aXJxLT5pcnFfbG9jaywgZmxhZ3MpOwo+IAo+IAo+IFRoYXQncyBiYXNpY2FsbHkgYSByZXZlcnQg
b2YgdGhlIG9mZmVuZGluZyBjb2RlLiBUaGUgY29tbWVudCByaWdodCBhYm92ZQo+IHZnaWNfZ2V0
X21taW9fcmVxdWVzdGVyX3ZjcHUoKSBleHBsYWlucyAqd2h5KiB0aGlzIGlzIHZhbGlkLCBhbmQg
d2h5Cj4gcHJlZW1wdF9kaXNhYmxlKCkgaXMgbmVlZGVkLgoKSSBzZWUsIHRoYW5rcyEKCj4gCj4g
Q2FuIHlvdSBwbGVhc2UgZ2l2ZSBpdCBhIHNob3Q/CgpZZXMsIGl0IHdvcmtzIGZvciBtZToKClRl
c3RlZC1ieTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+CgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
