Return-Path: <SRS0=p1b3=FE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E22C64E8A
	for <kvmarm@archiver.kernel.org>; Mon, 30 Nov 2020 14:00:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4E752076E
	for <kvmarm@archiver.kernel.org>; Mon, 30 Nov 2020 14:00:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4E752076E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C72C4D4FB;
	Mon, 30 Nov 2020 09:00:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BhENDMax5V5h; Mon, 30 Nov 2020 09:00:04 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8FDD4D510;
	Mon, 30 Nov 2020 09:00:04 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 323D94D4E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2020 09:00:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ySaazkQZvGO9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Nov 2020 09:00:00 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 88B894D3A8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2020 08:59:51 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Cl6Km0VKnzhkyV;
 Mon, 30 Nov 2020 21:59:24 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Mon, 30 Nov 2020 21:59:32 +0800
Subject: Re: [kvm-unit-tests PATCH 10/10] arm64: gic: Use IPI test checking
 for the LPI tests
To: Alexandru Elisei <alexandru.elisei@arm.com>, <kvm@vger.kernel.org>,
 <kvmarm@lists.cs.columbia.edu>, <drjones@redhat.com>
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-11-alexandru.elisei@arm.com>
 <a7069b1d-ef11-7504-644c-8d341fa2aabc@huawei.com>
 <fd32d075-c6a9-a869-14a9-2c29f41d3318@arm.com>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <49be46a8-2c29-b805-366e-7c955d395874@huawei.com>
Date: Mon, 30 Nov 2020 21:59:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <fd32d075-c6a9-a869-14a9-2c29f41d3318@arm.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.179]
X-CFilter-Loop: Reflected
Cc: andre.przywara@arm.com
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

SGkgQWxleCwKCk9uIDIwMjAvMTEvMjcgMjI6NTAsIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4g
SGkgWmhlbmdodWksCj4gCj4gVGhhbmsgeW91IGZvciBoYXZpbmcgYSBsb29rIGF0IHRoaXMhCj4g
Cj4gT24gMTEvMjYvMjAgOTozMCBBTSwgWmVuZ2h1aSBZdSB3cm90ZToKPj4gT24gMjAyMC8xMS8y
NSAyMzo1MSwgQWxleGFuZHJ1IEVsaXNlaSB3cm90ZToKPj4+IFRoZSByZWFzb24gZm9yIHRoZSBm
YWlsdXJlIGlzIHRoYXQgdGhlIHRlc3QgImRldjIvZXZlbnRpZD0yMCBub3cgdHJpZ2dlcnMKPj4+
IGFuIExQSSIgdHJpZ2dlcnMgMiBMUElzLCBub3Qgb25lLiBUaGlzIGJlaGF2aW9yIHdhcyBwcmVz
ZW50IGJlZm9yZSB0aGlzCj4+PiBwYXRjaCwgYnV0IGl0IHdhcyBpZ25vcmVkIGJlY2F1c2UgY2hl
Y2tfbHBpX3N0YXRzKCkgd2Fzbid0IGxvb2tpbmcgYXQgdGhlCj4+PiBhY2tlZCBhcnJheS4KPj4+
Cj4+PiBJJ20gbm90IGZhbWlsaWFyIHdpdGggdGhlIElUUyBzbyBJJ20gbm90IHN1cmUgaWYgdGhp
cyBpcyBleHBlY3RlZCwgaWYgdGhlCj4+PiB0ZXN0IGlzIGluY29ycmVjdCBvciBpZiB0aGVyZSBp
cyBzb21ldGhpbmcgd3Jvbmcgd2l0aCBLVk0gZW11bGF0aW9uLgo+Pgo+PiBJIHRoaW5rIHRoaXMg
aXMgZXhwZWN0ZWQsIG9yIG5vdC4KPj4KPj4gQmVmb3JlIElOVkFMTCwgdGhlIExQSS04MTk1IHdh
cyBhbHJlYWR5IHBlbmRpbmcgYnV0IGRpc2FibGVkLiBPbgo+PiByZWNlaXZpbmcgSU5WQUxMLCBW
R0lDIHdpbGwgcmVsb2FkIGNvbmZpZ3VyYXRpb24gZm9yIGFsbCBMUElzIHRhcmdldGluZwo+PiBj
b2xsZWN0aW9uLTMgYW5kIGRlbGl2ZXIgdGhlIG5vdyBlbmFibGVkIExQSS04MTk1LiBXZSdsbCB0
aGVyZWZvcmUgc2VlCj4+IGFuZCBoYW5kbGUgaXQgYmVmb3JlIHNlbmRpbmcgdGhlIGZvbGxvd2lu
ZyBJTlQgKHdoaWNoIHdpbGwgc2V0IHRoZQo+PiBMUEktODE5NSBwZW5kaW5nIGFnYWluKS4KPj4K
Pj4+IERpZCBzb21lIG1vcmUgdGVzdGluZyBvbiBhbiBBbXBlcmUgZU1BRyAoZmFzdCBvdXQtb2Yt
b3JkZXIgY29yZXMpIHVzaW5nCj4+PiBxZW11IGFuZCBrdm10b29sIGFuZCBMaW51eCB2NS44LCBo
ZXJlJ3Mgd2hhdCBJIGZvdW5kOgo+Pj4KPj4+IC0gVXNpbmcgcWVtdSBhbmQgZ2ljLmZsYXQgYnVp
bHQgZnJvbSptYXN0ZXIqOiBlcnJvciBlbmNvdW50ZXJlZCA4NjQgdGltZXMKPj4+ICDCoMKgIG91
dCBvZiAxMDg4IHJ1bnMuCj4+PiAtIFVzaW5nIHFlbXU6IGVycm9yIGVuY291bnRlcmVkIDg1MiB0
aW1lcyBvdXQgb2YgMTAyNyBydW5zLgo+Pj4gLSBVc2luZyBrdm10b29sOiBlcnJvciBlbmNvdW50
ZXJlZCA4MTY0IHRpbWVzIG91dCBvZiAxMDYwMiBydW5zLgo+Pgo+PiBJZiB2Y3B1LTMgaGFkbid0
IHNlZW4gYW5kIGhhbmRsZWQgTFBJLTgxOTUgYXMgcXVpY2tseSBhcyBwb3NzaWJsZSAoZS5nLiwK
Pj4gdmNwdS0zIGhhZG4ndCBiZWVuIHNjaGVkdWxlZCksIHRoZSBmb2xsb3dpbmcgSU5UIHdpbGwg
c2V0IHRoZSBhbHJlYWR5Cj4+IHBlbmRpbmcgTFBJLTgxOTUgcGVuZGluZyBhZ2FpbiBhbmQgd2Un
bGwgcmVjZWl2ZSBpdCAqb25jZSogb24gdmNwdS0zLgo+PiBBbmQgd2Ugd29uJ3Qgc2VlIHRoZSBt
ZW50aW9uZWQgZmFpbHVyZS4KPj4KPj4gSSB0aGluayB3ZSBjYW4ganVzdCBkcm9wIHRoZSAobWVh
bmluZ2xlc3MgYW5kIGNvbmZ1c2luZz8pIElOVC4KPiAKPiBJIHRoaW5rIEkgdW5kZXJzdGFuZCB5
b3VyIGV4cGxhbmF0aW9uLCB0aGUgVkNQVSB0YWtlcyB0aGUgaW50ZXJydXB0IGltbWVkaWF0ZWx5
Cj4gYWZ0ZXIgdGhlIElOVkFMTCBhbmQgYmVmb3JlIHRoZSBJTlQsIGFuZCB0aGUgc2Vjb25kIGlu
dGVycnVwdCB0aGF0IEkgYW0gc2VlaW5nIGlzCj4gdGhlIG9uZSBjYXVzZWQgYnkgdGhlIElOVCBj
b21tYW5kLgoKWWVzLgoKPiBJIHRyaWVkIG1vZGlmeWluZyB0aGUgdGVzdCBsaWtlIHRoaXM6Cj4g
Cj4gZGlmZiAtLWdpdCBhL2FybS9naWMuYyBiL2FybS9naWMuYwo+IGluZGV4IDZlOTNkYTgwZmUw
ZC4uMGVmOGMxMmVhMjM0IDEwMDY0NAo+IC0tLSBhL2FybS9naWMuYwo+ICsrKyBiL2FybS9naWMu
Ywo+IEBAIC03NjEsMTAgKzc2MSwxNyBAQCBzdGF0aWMgdm9pZCB0ZXN0X2l0c190cmlnZ2VyKHZv
aWQpCj4gICAgICAgICAgd21iKCk7Cj4gICAgICAgICAgY3B1bWFza19jbGVhcigmbWFzayk7Cj4g
ICAgICAgICAgY3B1bWFza19zZXRfY3B1KDMsICZtYXNrKTsKPiAtICAgICAgIGl0c19zZW5kX2lu
dChkZXYyLCAyMCk7CgpTaG91bGRuJ3QgaXRzX3NlbmRfaW52YWxsKGNvbDMpIGJlIG1vdmVkIGRv
d24gaGVyZT8gU2VlIGJlbG93LgoKPiAgICAgICAgICB3YWl0X2Zvcl9pbnRlcnJ1cHRzKCZtYXNr
KTsKPiAgICAgICAgICByZXBvcnQoY2hlY2tfYWNrZWQoJm1hc2ssIDAsIDgxOTUpLAo+IC0gICAg
ICAgICAgICAgICAgICAgICAgICJkZXYyL2V2ZW50aWQ9MjAgbm93IHRyaWdnZXJzIGFuIExQSSIp
Owo+ICsgICAgICAgICAgICAgICAgICAgICAgICJkZXYyL2V2ZW50aWQ9MjAgcGVuZGluZyBMUEkg
aXMgcmVjZWl2ZWQiKTsKPiArCj4gKyAgICAgICBzdGF0c19yZXNldCgpOwo+ICsgICAgICAgd21i
KCk7Cj4gKyAgICAgICBjcHVtYXNrX2NsZWFyKCZtYXNrKTsKPiArICAgICAgIGNwdW1hc2tfc2V0
X2NwdSgzLCAmbWFzayk7Cj4gKyAgICAgICBpdHNfc2VuZF9pbnQoZGV2MiwgMjApOwo+ICsgICAg
ICAgd2FpdF9mb3JfaW50ZXJydXB0cygmbWFzayk7Cj4gKyAgICAgICByZXBvcnQoY2hlY2tfYWNr
ZWQoJm1hc2ssIDAsIDgxOTUpLCAiZGV2Mi9ldmVudGlkPTIwIHRyaWdnZXJzIGFuIExQSSIpOwo+
ICAgCj4gICAgICAgICAgcmVwb3J0X3ByZWZpeF9wb3AoKTsKPiAgIAo+IEkgcmVtb3ZlZCB0aGUg
SU5UIGZyb20gdGhlIGluaXRpYWwgdGVzdCwgYW5kIGFkZGVkIGEgc2VwYXJhdGUgb25lIHRvIGNo
ZWNrIHRoYXQKPiB0aGUgSU5UIGNvbW1hbmQgc3RpbGwgd29ya3MuIFRoYXQgbG9va3MgdG8gbWUg
dGhhdCBwcmVzZXJ2ZXMgdGhlIHNwaXJpdCBvZiB0aGUKPiBvcmlnaW5hbCB0ZXN0LiBBZnRlciBk
b2luZyBzdHJlc3MgdGVzdGluZyB0aGlzIGlzIHdoYXQgSSBnb3Q6Cj4gCj4gLSB3aXRoIGt2bXRv
b2wsIDQ3LDcwOSBpdGVyYXRpb25zLCAyNyB0aW1lcyB0aGUgdGVzdCB0aW1lZCBvdXQgd2hlbiB3
YWl0aW5nIGZvcgo+IHRoZSBpbnRlcnJ1cHQgYWZ0ZXIgSU5WQUxMLgo+IC0gd2l0aCBxZW11LCAx
NSw1MTEgaXRlcmF0aW9ucywgMjU4IHRpbWVzIHRoZSB0ZXN0IHRpbWVkIG91dCB3aGVuIHdhaXRp
bmcgZm9yIHRoZQo+IGludGVycnVwdCBhZnRlciBJTlZBTEwsIGp1c3QgbGlrZSB3aXRoIGt2bXRv
b2wuCgpJIGd1ZXNzIHRoZSByZWFzb24gb2YgZmFpbHVyZSBpcyB0aGF0IHRoZSBMUEkgaXMgdGFr
ZW4gKmltbWVkaWF0ZWx5KgphZnRlciB0aGUgSU5WQUxMPwoKCS8qIE5vdyBjYWxsIHRoZSBpbnZh
bGwgYW5kIGNoZWNrIHRoZSBMUEkgaGl0cyAqLwoJaXRzX3NlbmRfaW52YWxsKGNvbDMpOwoJCTwt
IExQSSBpcyB0YWtlbiwgYWNrZWRbXSsrCglzdGF0c19yZXNldCgpOwoJCTwtIGFja2VkW10gaXMg
Y2xlYXJlZCB1bmV4cGVjdGVkbHkKCXdtYigpOwoJY3B1bWFza19jbGVhcigmbWFzayk7CgljcHVt
YXNrX3NldF9jcHUoMywgJm1hc2spOwoJd2FpdF9mb3JfaW50ZXJydXB0cygmbWFzayk7CgkJPC0g
d2UnbGwgaGl0IHRpbWVkLW91dCBzaW5jZSBhY2tlZFtdIGlzIDAKCgpUaGFua3MsClplbmdodWkK
Cj4gSnVkZ2luZyBmcm9tIHRoZSBmYWN0IHRoYXQgdGhlcmUgaXMgYW4gb3JkZXIgb2YgbWFnbml0
dWRlIGxlc3MgZmFpbHVyZXMgd2l0aAo+IGt2bXRvb2wgdGhhbiB3aXRoIHFlbXUsIEknbSBsZWFu
aW5nIHRvd2FyZHMgc29tZSByYW5kb20gdGltaW5nIGlzc3VlLiBJIHdpbGwgdHJ5Cj4gaW5jcmVh
c2luZyB0aGUgdGltZW91dCBmb3Igd2FpdF9mb3JfaW50ZXJydXB0cygpIGFuZCBzZWUgaWYgdGhl
IHJlc3VsdHMgaW1wcm92ZQo+IG92ZXIgdGhlIHdlZWtlbmQuCj4gCj4gVGhhbmtzLAo+IEFsZXgK
Pj4KPj4KPj4gVGhhbmtzLAo+PiBaZW5naHVpCj4gLgo+IApfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
