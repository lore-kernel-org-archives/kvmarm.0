Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2558BC433B4
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 10:30:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B9696143F
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 10:30:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B9696143F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A8E84B2C5;
	Fri,  7 May 2021 06:30:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SAPY74sIfeZY; Fri,  7 May 2021 06:30:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3CE24B49B;
	Fri,  7 May 2021 06:30:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DEA64B444
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 06:30:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VTZ32Y3OLmkE for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 06:30:45 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE01E4B2C5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 06:30:44 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17B75613F0;
 Fri,  7 May 2021 10:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620383443;
 bh=xO2yiNtWQ2O7eOAXqEu52tCA2HTisM05D8ogUeVRGIs=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=I3wci5mv4Gs6EyRYz2OZSjpzVQI/OLGQ7wJFnSwJzXhSaAZezyd872uqmd8eixDl2
 rFFe4IKS7TI1CU69Ujl5e9Qak2z6h7yGx0BJacxyzPTLMnHFOeTfrCTAQvPgGxOZ/3
 2MtQGiRFNnfqAjpay08cGhYotePU1XN36qEKlKPqQiNZgDVPcYRIJ4wOJDDZ8SjD0V
 QMcmkJr6dqXSPBgebph8z/PdGUnNKfZLKvG7sVr944ubJVoyhTk2YEQxv5vRYHKsAo
 75YjeuioJyCebAUNHpVf0f6O6/x/FqVOx5f1rf+PIOFaZadL9MsZadfp0YvXsJPFf3
 0t9HnWVV6NieA==
Date: Fri, 7 May 2021 13:30:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
Message-ID: <YJUWywpGwOpM8hzo@kernel.org>
References: <6ad2956c-70ae-c423-ed7d-88e94c88060f@huawei.com>
 <YIpY8TXCSc7Lfa2Z@kernel.org>
 <0cb013e4-1157-f2fa-96ec-e69e60833f72@huawei.com>
 <YIvTM5Yqit8AB4W8@kernel.org>
 <ca5b00bd-1312-0c69-ab69-a1bd749f51b6@huawei.com>
 <YI+XrAg4KOzOyt7c@kernel.org>
 <24b37c01-fc75-d459-6e61-d67e8f0cf043@redhat.com>
 <YI+32ocTbec5Rm4e@kernel.org>
 <82cfbb7f-dd4f-12d8-dc76-847f06172200@huawei.com>
 <b077916e-d3f7-ec6c-8c80-b5b642ee111f@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b077916e-d3f7-ec6c-8c80-b5b642ee111f@huawei.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
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

T24gRnJpLCBNYXkgMDcsIDIwMjEgYXQgMDM6MTc6MDhQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3Jv
dGU6Cj4gCj4gT24gMjAyMS81LzYgMjA6NDcsIEtlZmVuZyBXYW5nIHdyb3RlOgo+ID4gCj4gPiAK
PiA+ID4gPiA+ID4gbm8sIHRoZSBDT05GSUdfQVJNX0xQQUUgaXMgbm90IHNldCwgYW5kIHllcyB3
aXRoIHNhbWUgcGFuaWMgYXQKPiA+ID4gPiA+ID4gbW92ZV9mcmVlcGFnZXMgYXQKPiA+ID4gPiA+
ID4gCj4gPiA+ID4gPiA+IHN0YXJ0X3Bmbi9lbmRfcGZuIFtkZTYwMCwgZGU3ZmZdLCBbZGU2MDAw
MDAsIGRlN2ZmMDAwXQo+ID4gPiA+ID4gPiA6wqAgcGZuID1kZTYwMCwgcGFnZQo+ID4gPiA+ID4g
PiA9ZWYzY2MwMDAsIHBhZ2UtZmxhZ3MgPSBmZmZmZmZmZizCoCBwZm4ycGh5ID0gZGU2MDAwMDAK
PiA+ID4gPiA+ID4gCj4gPiA+ID4gPiA+ID4gPiBfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAw
eGIwMjAwMDAwIC0KPiA+ID4gPiA+ID4gPiA+IDB4YzAwMDAwMDAsIHBmbjogYjAyMDAgLSBiMDIw
MAo+ID4gPiA+ID4gPiA+ID4gX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhjYzAwMDAwMCAt
Cj4gPiA+ID4gPiA+ID4gPiAweGRjYTAwMDAwLCBwZm46IGNjMDAwIC0gYjAyMDAKPiA+ID4gPiA+
ID4gPiA+IF9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4ZGU3MDAwMDAgLQo+ID4gPiA+ID4g
PiA+ID4gMHhkZWEwMDAwMCwgcGZuOiBkZTcwMCAtIGIwMjAwCj4gPiA+ID4gPiAKPiA+ID4gPiA+
IEhtbSwgW2RlNjAwLCBkZTdmZl0gaXMgbm90IGFkZGVkIHRvIHRoZSBmcmVlIGxpc3RzIHdoaWNo
IGlzCj4gPiA+ID4gPiBjb3JyZWN0LiBCdXQKPiA+ID4gPiA+IHRoZW4gaXQncyB1bmNsZWFyIGhv
dyB0aGUgcGFnZSBmb3IgZGU2MDAgZ2V0cyB0byBtb3ZlX2ZyZWVwYWdlcygpLi4uCj4gPiA+ID4g
PiAKPiA+ID4gPiA+IENhbid0IHNheSBJIGhhdmUgYW55IGJyaWdodCBpZGVhcyB0byB0cnkgaGVy
ZS4uLgo+ID4gPiA+IAo+ID4gPiA+IEFyZSB3ZSBtaXNzaW5nIHNvbWUgY2hlY2tzIChlLmcuLCBQ
YWdlUmVzZXJ2ZWQoKSkgdGhhdAo+ID4gPiA+IHBmbl92YWxpZF93aXRoaW4oKQo+ID4gPiA+IHdv
dWxkIGhhdmUgImNhdWdodCIgYmVmb3JlPwo+ID4gPiAKPiA+ID4gVW5sZXNzIEknbSBtaXNzaW5n
IHNvbWV0aGluZyB0aGUgY3Jhc2ggaGFwcGVucyBpbiBfX3JtcXVldWVfZmFsbGJhY2soKToKPiA+
ID4gCj4gPiA+IGRvX3N0ZWFsOgo+ID4gPiDCoMKgwqDCoHBhZ2UgPSBnZXRfcGFnZV9mcm9tX2Zy
ZWVfYXJlYShhcmVhLCBmYWxsYmFja19tdCk7Cj4gPiA+IAo+ID4gPiDCoMKgwqDCoHN0ZWFsX3N1
aXRhYmxlX2ZhbGxiYWNrKHpvbmUsIHBhZ2UsIGFsbG9jX2ZsYWdzLCBzdGFydF9taWdyYXRldHlw
ZSwKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgY2FuX3N0ZWFsKTsKPiA+ID4gwqDCoMKgwqDCoMKgwqAgLT4gbW92ZV9m
cmVlcGFnZXMoKQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIC0+IEJVRygpCj4gPiA+IAo+
ID4gPiBTbyBhIHBhZ2UgZnJvbSBmcmVlIGFyZWEgc2hvdWxkIGJlIHNhbmUgYXMgdGhlIGZyZWVk
IHJhbmdlIHdhcyBuZXZlcgo+ID4gPiBhZGRlZAo+ID4gPiBpdCB0byB0aGUgZnJlZSBsaXN0cy4K
PiA+IAo+ID4gU29ycnkgZm9yIHRoZSBsYXRlIHJlc3BvbnNlIGR1ZSB0byB0aGUgdmFjYXRpb24u
Cj4gPiAKPiA+IFRoZSBwZm4gaW4gcmFuZ2UgW2RlNjAwLCBkZTdmZl0gd29uJ3QgYmUgYWRkZWQg
aW50byB0aGUgZnJlZSBsaXN0cyB2aWEKPiA+IF9fZnJlZV9tZW1vcnlfY29yZSgpLCBidXQgdGhl
IHBmbiBjb3VsZCBiZSBhZGRlZCBpbnRvIGZyZWVsaXN0cyB2aWEKPiA+IGZyZWVfaGlnaG1lbV9w
YWdlKCkKPiA+IAo+ID4gSSBhZGQgc29tZSBkZWJ1Z1sxXSBpbiBhZGRfdG9fZnJlZV9saXN0KCks
IHdlIGNvdWxkIHNlZSB0aGUgY2FsbHRyYWNlCj4gPiAKPiA+IGZyZWVfaGlnaHBhZ2VzLCByYW5n
ZV9wZm4gW2IwMjAwLCBjMDAwMF0sIHJhbmdlX2FkZHIgW2IwMjAwMDAwLCBjMDAwMDAwMF0KPiA+
IGZyZWVfaGlnaHBhZ2VzLCByYW5nZV9wZm4gW2NjMDAwLCBkY2EwMF0sIHJhbmdlX2FkZHIgW2Nj
MDAwMDAwLCBkY2EwMDAwMF0KPiA+IGZyZWVfaGlnaHBhZ2VzLCByYW5nZV9wZm4gW2RlNzAwLCBk
ZWEwMF0sIHJhbmdlX2FkZHIgW2RlNzAwMDAwLCBkZWEwMDAwMF0KPiA+IGFkZF90b19mcmVlX2xp
c3QsID09PT4gcGZuID0gZGU3MDAKPiA+IC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0t
LS0tLQo+ID4gV0FSTklORzogQ1BVOiAwIFBJRDogMCBhdCBtbS9wYWdlX2FsbG9jLmM6OTAwIGFk
ZF90b19mcmVlX2xpc3QrMHg4Yy8weGVjCj4gPiBwZm4gPSBkZTcwMAo+ID4gTW9kdWxlcyBsaW5r
ZWQgaW46Cj4gPiBDUFU6IDAgUElEOiAwIENvbW06IHN3YXBwZXIgTm90IHRhaW50ZWQgNS4xMC4w
KyAjNDgKPiA+IEhhcmR3YXJlIG5hbWU6IEhpc2lsaWNvbiBBOQo+ID4gWzxjMDEwYTYwMD5dIChz
aG93X3N0YWNrKSBmcm9tIFs8YzA0YjIxYzQ+XSAoZHVtcF9zdGFjaysweDljLzB4YzApCj4gPiBb
PGMwNGIyMWM0Pl0gKGR1bXBfc3RhY2spIGZyb20gWzxjMDExYzcwOD5dIChfX3dhcm4rMHhjMC8w
eGVjKQo+ID4gWzxjMDExYzcwOD5dIChfX3dhcm4pIGZyb20gWzxjMDExYzdhOD5dICh3YXJuX3Ns
b3dwYXRoX2ZtdCsweDc0LzB4YTQpCj4gPiBbPGMwMTFjN2E4Pl0gKHdhcm5fc2xvd3BhdGhfZm10
KSBmcm9tIFs8YzAyMzcyMWM+XQo+ID4gKGFkZF90b19mcmVlX2xpc3QrMHg4Yy8weGVjKQo+ID4g
WzxjMDIzNzIxYz5dIChhZGRfdG9fZnJlZV9saXN0KSBmcm9tIFs8YzAyMzdlMDA+XQo+ID4gKGZy
ZWVfcGNwcGFnZXNfYnVsaysweDIwMC8weDI3OCkKPiA+IFs8YzAyMzdlMDA+XSAoZnJlZV9wY3Bw
YWdlc19idWxrKSBmcm9tIFs8YzAyMzhkMTQ+XQo+ID4gKGZyZWVfdW5yZWZfcGFnZSsweDU4LzB4
NjgpCj4gPiBbPGMwMjM4ZDE0Pl0gKGZyZWVfdW5yZWZfcGFnZSkgZnJvbSBbPGMwMjNiYjU0Pl0K
PiA+IChmcmVlX2hpZ2htZW1fcGFnZSsweGMvMHg1MCkKPiA+IFs8YzAyM2JiNTQ+XSAoZnJlZV9o
aWdobWVtX3BhZ2UpIGZyb20gWzxjMDcwNjIwYz5dIChtZW1faW5pdCsweDIxYy8weDI1NCkKPiA+
IFs8YzA3MDYyMGM+XSAobWVtX2luaXQpIGZyb20gWzxjMDcwMGIzOD5dIChzdGFydF9rZXJuZWwr
MHgyNTgvMHg1YzApCj4gPiBbPGMwNzAwYjM4Pl0gKHN0YXJ0X2tlcm5lbCkgZnJvbSBbPDAwMDAw
MDAwPl0gKDB4MCkKPiA+IAo+ID4gc28gYW55IGlkZWE/Cj4gCj4gSWYgcGZuID0gMHhkZTcwMCwg
ZHVlIHRvIHRoZSBwYWdlYmxvY2tfbnJfcGFnZXMgPSAweDIwMCwgdGhlbiB0aGUKPiBzdGFydF9w
Zm4sZW5kX3BmbiBwYXNzZWQgdG8gbW92ZV9mcmVlcGFnZXMoKSB3aWxsIGJlIFtkZTYwMCwgZGU3
ZmZdLAo+IGJ1dCB0aGUgcmFuZ2Ugb2YgW2RlNjAwLGRlNzAwXSB3aXRob3V0IOKAmHN0cnVjdCBw
YWdlJyB3aWxsIGxlYWQgdG8KPiB0aGlzIHBhbmljIHdoZW4gcGZuX3ZhbGlkX3dpdGhpbiBub3Qg
ZW5hYmxlZCBpZiBubyBIT0xFU19JTl9aT05FLAo+IGFuZCB0aGUgc2FtZSBpc3N1ZSB3aWxsIG9j
Y3VycmVkIGluIGlzb2xhdGVfZnJlZXBhZ2VzX2Jsb2NrKCksIG1heWJlCgpJIHRoaW5rIHlvdXIg
YW5hbHlzaXMgaXMgY29ycmVjdCBleGNlcHQgb25lIG1pbm9yIGRldGFpbC4gV2l0aCB0aGUgI2lm
ZGVmCmZpeCBJJ3ZlIHByb3Bvc2VkIGVhcmxpZXJpIFsxXSB0aGUgbWVtbWFwIGZvciBbMHhkZTYw
MCwgMHhkZTcwMF0gc2hvdWxkIG5vdApiZSBmcmVlZCBzbyB0aGVyZSBzaG91bGQgYmUgYSBzdHJ1
Y3QgcGFnZS4gRGlkIHlvdSBjaGVjayB3aGF0IHBhcnRzIG9mIHRoZQptZW1tYXAgYXJlIGFjdHVh
bGx5IGZyZWVkIHdpdGggdGhpcyBwYXRjaCBhcHBsaWVkPwpXb3VsZCB5b3UgZ2V0IGEgcGFuaWMg
aWYgeW91IGFkZAoKCWR1bXBfcGFnZShwZm5fdG9fcGFnZSgweGRlNjAwKSwgIiIpOwoKc2F5LCBp
biB0aGUgZW5kIG9mIG1lbWJsb2NrX2ZyZWVfYWxsKCk/Cgo+IHRoZXJlIGFyZSBzb21lIHNjZW5l
LCBzbyBJIHNlbGVjdCBIT0xFU19JTl9aT05FIGluIEFSQ0hfSElTSShBUk0pIHRvIHNvbHZlCj4g
dGhpcyBpc3N1ZSBpbiBvdXIgNS4xMCwgc2hvdWxkIHdlIHNlbGVjdCBIT0xFU19JTl9aT05FIGlu
IGFsbCBBUk0gb3Igb25seSBpbgo+IEFSQ0hfSElTSSwgYW55IGJldHRlciBzb2x1dGlvbj8gIFRo
YW5rcy4KCkkgZG9uJ3QgdGhpbmsgdGhhdCBIT0xFU19JTl9aT05FIGlzIHRoZSByaWdodCBzb2x1
dGlvbi4gSSBiZWxpZXZlIHRoYXQgd2UKbXVzdCBrZWVwIHRoZSBtZW1vcnkgbWFwIGFsaWduZWQg
b24gcGFnZWJsb2NrIGJvdW5kYXJpZXMuIFRoYXQncyBzdXJlbHkgbm90IHRoZQpjYXNlIGZvciBT
UEFSU0VNRU0gYXMgb2Ygbm93LCBhbmQgaWYgbXkgZml4IGlzIG5vdCBlbm91Z2ggd2UgbmVlZCB0
byBmaW5kCndoZXJlIGl0IHdlbnQgd3JvbmcuCgpCZXNpZGVzLCBJJ2Qgc2F5IHRoYXQgaWYgaXQg
aXMgcG9zc2libGUgdG8gdXBkYXRlIHlvdXIgZmlybXdhcmUgdG8gbWFrZSB0aGUKbWVtb3J5IGxh
eW91dCByZXBvcnRlZCB0byB0aGUga2VybmVsIGxlc3MsIGhtbSwgZXNvdGVyaWMsIHlvdSB3b3Vs
ZCBoaXQKbGVzcyBjb3JuZXIgY2FzZXMuCgpbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGtt
bC9ZSXBZOFRYQ1NjN0xmYTJaQGtlcm5lbC5vcmcKCi0tIApTaW5jZXJlbHkgeW91cnMsCk1pa2Uu
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
