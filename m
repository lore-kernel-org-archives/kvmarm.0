Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961B0C433ED
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 10:28:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0510C61464
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 10:28:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0510C61464
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E4614B590;
	Fri,  7 May 2021 06:28:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QyhHjFv9Ug4c; Fri,  7 May 2021 06:28:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 605F64B583;
	Fri,  7 May 2021 06:28:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E66D4B530
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 03:17:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dfsnS+5J2x+7 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 03:17:15 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B2494B51B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 03:17:14 -0400 (EDT)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Fc1rx60N9zqT3T;
 Fri,  7 May 2021 15:13:53 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Fri, 7 May 2021 15:17:08 +0800
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@redhat.com>
References: <YIet5X7lgygD9rpZ@kernel.org>
 <259d14df-a713-72e7-4ccb-c06a8ee31e13@huawei.com>
 <YIj5zcbHBHt7CC8B@kernel.org>
 <6ad2956c-70ae-c423-ed7d-88e94c88060f@huawei.com>
 <YIpY8TXCSc7Lfa2Z@kernel.org>
 <0cb013e4-1157-f2fa-96ec-e69e60833f72@huawei.com>
 <YIvTM5Yqit8AB4W8@kernel.org>
 <ca5b00bd-1312-0c69-ab69-a1bd749f51b6@huawei.com>
 <YI+XrAg4KOzOyt7c@kernel.org>
 <24b37c01-fc75-d459-6e61-d67e8f0cf043@redhat.com>
 <YI+32ocTbec5Rm4e@kernel.org>
 <82cfbb7f-dd4f-12d8-dc76-847f06172200@huawei.com>
Message-ID: <b077916e-d3f7-ec6c-8c80-b5b642ee111f@huawei.com>
Date: Fri, 7 May 2021 15:17:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <82cfbb7f-dd4f-12d8-dc76-847f06172200@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.174.177.243]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Fri, 07 May 2021 06:28:11 -0400
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, Mike
 Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu,
 Marc Zyngier <maz@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

CgpPbiAyMDIxLzUvNiAyMDo0NywgS2VmZW5nIFdhbmcgd3JvdGU6Cj4gCj4gCj4+Pj4+IG5vLCB0
aGUgQ09ORklHX0FSTV9MUEFFIGlzIG5vdCBzZXQsIGFuZCB5ZXMgd2l0aCBzYW1lIHBhbmljIGF0
Cj4+Pj4+IG1vdmVfZnJlZXBhZ2VzIGF0Cj4+Pj4+Cj4+Pj4+IHN0YXJ0X3Bmbi9lbmRfcGZuIFtk
ZTYwMCwgZGU3ZmZdLCBbZGU2MDAwMDAsIGRlN2ZmMDAwXSA6wqAgcGZuIAo+Pj4+PiA9ZGU2MDAs
IHBhZ2UKPj4+Pj4gPWVmM2NjMDAwLCBwYWdlLWZsYWdzID0gZmZmZmZmZmYswqAgcGZuMnBoeSA9
IGRlNjAwMDAwCj4+Pj4+Cj4+Pj4+Pj4gX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhiMDIw
MDAwMCAtIDB4YzAwMDAwMDAsIHBmbjogYjAyMDAgLSAKPj4+Pj4+PiBiMDIwMAo+Pj4+Pj4+IF9f
ZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4Y2MwMDAwMDAgLSAweGRjYTAwMDAwLCBwZm46IGNj
MDAwIC0gCj4+Pj4+Pj4gYjAyMDAKPj4+Pj4+PiBfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAw
eGRlNzAwMDAwIC0gMHhkZWEwMDAwMCwgcGZuOiBkZTcwMCAtIAo+Pj4+Pj4+IGIwMjAwCj4+Pj4K
Pj4+PiBIbW0sIFtkZTYwMCwgZGU3ZmZdIGlzIG5vdCBhZGRlZCB0byB0aGUgZnJlZSBsaXN0cyB3
aGljaCBpcyBjb3JyZWN0LiAKPj4+PiBCdXQKPj4+PiB0aGVuIGl0J3MgdW5jbGVhciBob3cgdGhl
IHBhZ2UgZm9yIGRlNjAwIGdldHMgdG8gbW92ZV9mcmVlcGFnZXMoKS4uLgo+Pj4+Cj4+Pj4gQ2Fu
J3Qgc2F5IEkgaGF2ZSBhbnkgYnJpZ2h0IGlkZWFzIHRvIHRyeSBoZXJlLi4uCj4+Pgo+Pj4gQXJl
IHdlIG1pc3Npbmcgc29tZSBjaGVja3MgKGUuZy4sIFBhZ2VSZXNlcnZlZCgpKSB0aGF0IAo+Pj4g
cGZuX3ZhbGlkX3dpdGhpbigpCj4+PiB3b3VsZCBoYXZlICJjYXVnaHQiIGJlZm9yZT8KPj4KPj4g
VW5sZXNzIEknbSBtaXNzaW5nIHNvbWV0aGluZyB0aGUgY3Jhc2ggaGFwcGVucyBpbiBfX3JtcXVl
dWVfZmFsbGJhY2soKToKPj4KPj4gZG9fc3RlYWw6Cj4+IMKgwqDCoMKgcGFnZSA9IGdldF9wYWdl
X2Zyb21fZnJlZV9hcmVhKGFyZWEsIGZhbGxiYWNrX210KTsKPj4KPj4gwqDCoMKgwqBzdGVhbF9z
dWl0YWJsZV9mYWxsYmFjayh6b25lLCBwYWdlLCBhbGxvY19mbGFncywgc3RhcnRfbWlncmF0ZXR5
cGUsCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGNhbl9zdGVhbCk7Cj4+IMKgwqDCoMKgwqDCoMKgIC0+IG1vdmVfZnJlZXBh
Z2VzKCkKPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAtPiBCVUcoKQo+Pgo+PiBTbyBhIHBhZ2Ug
ZnJvbSBmcmVlIGFyZWEgc2hvdWxkIGJlIHNhbmUgYXMgdGhlIGZyZWVkIHJhbmdlIHdhcyBuZXZl
ciAKPj4gYWRkZWQKPj4gaXQgdG8gdGhlIGZyZWUgbGlzdHMuCj4gCj4gU29ycnkgZm9yIHRoZSBs
YXRlIHJlc3BvbnNlIGR1ZSB0byB0aGUgdmFjYXRpb24uCj4gCj4gVGhlIHBmbiBpbiByYW5nZSBb
ZGU2MDAsIGRlN2ZmXSB3b24ndCBiZSBhZGRlZCBpbnRvIHRoZSBmcmVlIGxpc3RzIHZpYSAKPiBf
X2ZyZWVfbWVtb3J5X2NvcmUoKSwgYnV0IHRoZSBwZm4gY291bGQgYmUgYWRkZWQgaW50byBmcmVl
bGlzdHMgdmlhIAo+IGZyZWVfaGlnaG1lbV9wYWdlKCkKPiAKPiBJIGFkZCBzb21lIGRlYnVnWzFd
IGluIGFkZF90b19mcmVlX2xpc3QoKSwgd2UgY291bGQgc2VlIHRoZSBjYWxsdHJhY2UKPiAKPiBm
cmVlX2hpZ2hwYWdlcywgcmFuZ2VfcGZuIFtiMDIwMCwgYzAwMDBdLCByYW5nZV9hZGRyIFtiMDIw
MDAwMCwgYzAwMDAwMDBdCj4gZnJlZV9oaWdocGFnZXMsIHJhbmdlX3BmbiBbY2MwMDAsIGRjYTAw
XSwgcmFuZ2VfYWRkciBbY2MwMDAwMDAsIGRjYTAwMDAwXQo+IGZyZWVfaGlnaHBhZ2VzLCByYW5n
ZV9wZm4gW2RlNzAwLCBkZWEwMF0sIHJhbmdlX2FkZHIgW2RlNzAwMDAwLCBkZWEwMDAwMF0KPiBh
ZGRfdG9fZnJlZV9saXN0LCA9PT0+IHBmbiA9IGRlNzAwCj4gLS0tLS0tLS0tLS0tWyBjdXQgaGVy
ZSBdLS0tLS0tLS0tLS0tCj4gV0FSTklORzogQ1BVOiAwIFBJRDogMCBhdCBtbS9wYWdlX2FsbG9j
LmM6OTAwIGFkZF90b19mcmVlX2xpc3QrMHg4Yy8weGVjCj4gcGZuID0gZGU3MDAKPiBNb2R1bGVz
IGxpbmtlZCBpbjoKPiBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgNS4x
MC4wKyAjNDgKPiBIYXJkd2FyZSBuYW1lOiBIaXNpbGljb24gQTkKPiBbPGMwMTBhNjAwPl0gKHNo
b3dfc3RhY2spIGZyb20gWzxjMDRiMjFjND5dIChkdW1wX3N0YWNrKzB4OWMvMHhjMCkKPiBbPGMw
NGIyMWM0Pl0gKGR1bXBfc3RhY2spIGZyb20gWzxjMDExYzcwOD5dIChfX3dhcm4rMHhjMC8weGVj
KQo+IFs8YzAxMWM3MDg+XSAoX193YXJuKSBmcm9tIFs8YzAxMWM3YTg+XSAod2Fybl9zbG93cGF0
aF9mbXQrMHg3NC8weGE0KQo+IFs8YzAxMWM3YTg+XSAod2Fybl9zbG93cGF0aF9mbXQpIGZyb20g
WzxjMDIzNzIxYz5dIAo+IChhZGRfdG9fZnJlZV9saXN0KzB4OGMvMHhlYykKPiBbPGMwMjM3MjFj
Pl0gKGFkZF90b19mcmVlX2xpc3QpIGZyb20gWzxjMDIzN2UwMD5dIAo+IChmcmVlX3BjcHBhZ2Vz
X2J1bGsrMHgyMDAvMHgyNzgpCj4gWzxjMDIzN2UwMD5dIChmcmVlX3BjcHBhZ2VzX2J1bGspIGZy
b20gWzxjMDIzOGQxND5dIAo+IChmcmVlX3VucmVmX3BhZ2UrMHg1OC8weDY4KQo+IFs8YzAyMzhk
MTQ+XSAoZnJlZV91bnJlZl9wYWdlKSBmcm9tIFs8YzAyM2JiNTQ+XSAKPiAoZnJlZV9oaWdobWVt
X3BhZ2UrMHhjLzB4NTApCj4gWzxjMDIzYmI1ND5dIChmcmVlX2hpZ2htZW1fcGFnZSkgZnJvbSBb
PGMwNzA2MjBjPl0gKG1lbV9pbml0KzB4MjFjLzB4MjU0KQo+IFs8YzA3MDYyMGM+XSAobWVtX2lu
aXQpIGZyb20gWzxjMDcwMGIzOD5dIChzdGFydF9rZXJuZWwrMHgyNTgvMHg1YzApCj4gWzxjMDcw
MGIzOD5dIChzdGFydF9rZXJuZWwpIGZyb20gWzwwMDAwMDAwMD5dICgweDApCj4gCj4gc28gYW55
IGlkZWE/CgpJZiBwZm4gPSAweGRlNzAwLCBkdWUgdG8gdGhlIHBhZ2VibG9ja19ucl9wYWdlcyA9
IDB4MjAwLCB0aGVuIHRoZSAKc3RhcnRfcGZuLGVuZF9wZm4gcGFzc2VkIHRvIG1vdmVfZnJlZXBh
Z2VzKCkgd2lsbCBiZSBbZGU2MDAsIGRlN2ZmXSwKYnV0IHRoZSByYW5nZSBvZiBbZGU2MDAsZGU3
MDBdIHdpdGhvdXQg4oCYc3RydWN0IHBhZ2UnIHdpbGwgbGVhZCB0bwp0aGlzIHBhbmljIHdoZW4g
cGZuX3ZhbGlkX3dpdGhpbiBub3QgZW5hYmxlZCBpZiBubyBIT0xFU19JTl9aT05FLAphbmQgdGhl
IHNhbWUgaXNzdWUgd2lsbCBvY2N1cnJlZCBpbiBpc29sYXRlX2ZyZWVwYWdlc19ibG9jaygpLCBt
YXliZQp0aGVyZSBhcmUgc29tZSBzY2VuZSwgc28gSSBzZWxlY3QgSE9MRVNfSU5fWk9ORSBpbiBB
UkNIX0hJU0koQVJNKSB0byAKc29sdmUgdGhpcyBpc3N1ZSBpbiBvdXIgNS4xMCwgc2hvdWxkIHdl
IHNlbGVjdCBIT0xFU19JTl9aT05FIGluIGFsbCBBUk0gCm9yIG9ubHkgaW4gQVJDSF9ISVNJLCBh
bnkgYmV0dGVyIHNvbHV0aW9uPyAgVGhhbmtzLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
