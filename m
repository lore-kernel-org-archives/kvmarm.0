Return-Path: <SRS0=8Q7i=JU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DDC5C433ED
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 09:14:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8EBA66145A
	for <kvmarm@archiver.kernel.org>; Fri, 23 Apr 2021 09:14:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EBA66145A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EB2614B2B5;
	Fri, 23 Apr 2021 05:14:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bwFKkNIRm2fx; Fri, 23 Apr 2021 05:14:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BD6A4B35A;
	Fri, 23 Apr 2021 05:14:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7F8D4B369
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 04:11:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HoJ43O1MUUjM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Apr 2021 04:11:26 -0400 (EDT)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2C7254B366
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Apr 2021 04:11:26 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FRRlQ6dgTzlZ9n;
 Fri, 23 Apr 2021 16:09:22 +0800 (CST)
Received: from [10.174.177.244] (10.174.177.244) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Fri, 23 Apr 2021 16:11:17 +0800
Subject: Re: [PATCH v2 0/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Mike Rapoport <rppt@kernel.org>
References: <20210421065108.1987-1-rppt@kernel.org>
 <9aa68d26-d736-3b75-4828-f148964eb7f0@huawei.com>
 <YIEl8aKr8Ly0Zd3O@kernel.org>
 <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
Message-ID: <2a1592ad-bc9d-4664-fd19-f7448a37edc0@huawei.com>
Date: Fri, 23 Apr 2021 16:11:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
Content-Language: en-US
X-Originating-IP: [10.174.177.244]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Fri, 23 Apr 2021 05:14:27 -0400
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will
 Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org
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

Ck9uIDIwMjEvNC8yMiAyMzoyOCwgS2VmZW5nIFdhbmcgd3JvdGU6Cj4KPiBPbiAyMDIxLzQvMjIg
MTU6MjksIE1pa2UgUmFwb3BvcnQgd3JvdGU6Cj4+IE9uIFRodSwgQXByIDIyLCAyMDIxIGF0IDAz
OjAwOjIwUE0gKzA4MDAsIEtlZmVuZyBXYW5nIHdyb3RlOgo+Pj4gT24gMjAyMS80LzIxIDE0OjUx
LCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+Pj4+IEZyb206IE1pa2UgUmFwb3BvcnQgPHJwcHRAbGlu
dXguaWJtLmNvbT4KPj4+Pgo+Pj4+IEhpLAo+Pj4+Cj4+Pj4gVGhlc2UgcGF0Y2hlcyBhaW0gdG8g
cmVtb3ZlIENPTkZJR19IT0xFU19JTl9aT05FIGFuZCBlc3NlbnRpYWxseSAKPj4+PiBoYXJkd2ly
ZQo+Pj4+IHBmbl92YWxpZF93aXRoaW4oKSB0byAxLgo+Pj4+Cj4+Pj4gVGhlIGlkZWEgaXMgdG8g
bWFyayBOT01BUCBwYWdlcyBhcyByZXNlcnZlZCBpbiB0aGUgbWVtb3J5IG1hcCBhbmQgCj4+Pj4g
cmVzdG9yZQo+Pj4+IHRoZSBpbnRlbmRlZCBzZW1hbnRpY3Mgb2YgcGZuX3ZhbGlkKCkgdG8gZGVz
aWduYXRlIGF2YWlsYWJpbGl0eSBvZiAKPj4+PiBzdHJ1Y3QKPj4+PiBwYWdlIGZvciBhIHBmbi4K
Pj4+Pgo+Pj4+IFdpdGggdGhpcyB0aGUgY29yZSBtbSB3aWxsIGJlIGFibGUgdG8gY29wZSB3aXRo
IHRoZSBmYWN0IHRoYXQgaXQgCj4+Pj4gY2Fubm90IHVzZQo+Pj4+IE5PTUFQIHBhZ2VzIGFuZCB0
aGUgaG9sZXMgY3JlYXRlZCBieSBOT01BUCByYW5nZXMgd2l0aGluIE1BWF9PUkRFUiAKPj4+PiBi
bG9ja3MKPj4+PiB3aWxsIGJlIHRyZWF0ZWQgY29ycmVjdGx5IGV2ZW4gd2l0aG91dCB0aGUgbmVl
ZCBmb3IgcGZuX3ZhbGlkX3dpdGhpbi4KPj4+Pgo+Pj4+IFRoZSBwYXRjaGVzIGFyZSBvbmx5IGJv
b3QgdGVzdGVkIG9uIHFlbXUtc3lzdGVtLWFhcmNoNjQgc28gSSdkIHJlYWxseQo+Pj4+IGFwcHJl
Y2lhdGUgbWVtb3J5IHN0cmVzcyB0ZXN0cyBvbiByZWFsIGhhcmR3YXJlLgo+Pj4+Cj4+Pj4gSWYg
dGhpcyBhY3R1YWxseSB3b3JrcyB3ZSdsbCBiZSBvbmUgc3RlcCBjbG9zZXIgdG8gZHJvcCBjdXN0
b20gCj4+Pj4gcGZuX3ZhbGlkKCkKPj4+PiBvbiBhcm02NCBhbHRvZ2V0aGVyLgouLi4KPgo+IE9r
LCB0aGFua3MsIHdlIG1ldCBhIHNhbWUgcGFuaWMgbGlrZSB0aGUgbGluayBvbiBhcm0zMih3aXRo
b3V0IAo+IEhPTEVTX0lOX1pPTkUpLAo+Cj4gdGhlIHNjaGVtZSBmb3IgYXJtNjQgY291bGQgYmUg
c3VpdCBmb3IgYXJtMzIsIHJpZ2h0P8KgIEkgd2lsbCB0cnkgdGhlIAo+IHBhdGNoc2V0IHdpdGgK
Pgo+IHNvbWUgY2hhbmdlcyBvbiBhcm0zMiBhbmQgZ2l2ZSBzb21lIGZlZWRiYWNrLgoKSSB0ZXN0
ZWQgdGhpcyBwYXRjaHNldChwbHVzIGFybTMyIGNoYW5nZSwgbGlrZSBhcm02NCBkb2VzKSBiYXNl
ZCBvbiBsdHMgCjUuMTDvvIxhZGQKCnNvbWUgZGVidWcgbG9nLCB0aGUgdXNlZnVsIGluZm8gc2hv
d3MgYmVsb3csIGlmIHdlIGVuYWJsZSBIT0xFU19JTl9aT05FLCAKbm8gcGFuaWMsCgphbnkgaWRl
YSwgdGhhbmtzLgoKWm9uZSByYW5nZXM6CiDCoCBOb3JtYWzCoMKgIFttZW0gMHgwMDAwMDAwMDgw
YTAwMDAwLTB4MDAwMDAwMDBiMDFmZmZmZl0KIMKgIEhpZ2hNZW3CoCBbbWVtIDB4MDAwMDAwMDBi
MDIwMDAwMC0weDAwMDAwMDAwZmZmZmVmZmZdCk1vdmFibGUgem9uZSBzdGFydCBmb3IgZWFjaCBu
b2RlCkVhcmx5IG1lbW9yeSBub2RlIHJhbmdlcwogwqAgbm9kZcKgwqAgMDogW21lbSAweDAwMDAw
MDAwODBhMDAwMDAtMHgwMDAwMDAwMDg1NWZmZmZmXQogwqAgbm9kZcKgwqAgMDogW21lbSAweDAw
MDAwMDAwODZhMDAwMDAtMHgwMDAwMDAwMDg3ZGZmZmZmXQogwqAgbm9kZcKgwqAgMDogW21lbSAw
eDAwMDAwMDAwOGJkMDAwMDAtMHgwMDAwMDAwMDhjNGZmZmZmXQogwqAgbm9kZcKgwqAgMDogW21l
bSAweDAwMDAwMDAwOGUzMDAwMDAtMHgwMDAwMDAwMDhlY2ZmZmZmXQogwqAgbm9kZcKgwqAgMDog
W21lbSAweDAwMDAwMDAwOTBkMDAwMDAtMHgwMDAwMDAwMGJmZmZmZmZmXQogwqAgbm9kZcKgwqAg
MDogW21lbSAweDAwMDAwMDAwY2MwMDAwMDAtMHgwMDAwMDAwMGRjOWZmZmZmXQogwqAgbm9kZcKg
wqAgMDogW21lbSAweDAwMDAwMDAwZGU3MDAwMDAtMHgwMDAwMDAwMGRlOWZmZmZmXQogwqAgbm9k
ZcKgwqAgMDogW21lbSAweDAwMDAwMDAwZTA4MDAwMDAtMHgwMDAwMDAwMGUwYmZmZmZmXQogwqAg
bm9kZcKgwqAgMDogW21lbSAweDAwMDAwMDAwZjRiMDAwMDAtMHgwMDAwMDAwMGY2ZmZmZmZmXQog
wqAgbm9kZcKgwqAgMDogW21lbSAweDAwMDAwMDAwZmRhMDAwMDAtMHgwMDAwMDAwMGZmZmZlZmZm
XQoKLS0tLT4gZnJlZV9tZW1tYXAsIHN0YXJ0X3BmbiA9IDg1ODAwLMKgIDg1ODAwMDAwIGVuZF9w
Zm4gPSA4NmEwMCwgODZhMDAwMDAKLS0tLT4gZnJlZV9tZW1tYXAsIHN0YXJ0X3BmbiA9IDhjODAw
LMKgIDhjODAwMDAwIGVuZF9wZm4gPSA4ZTMwMCwgOGUzMDAwMDAKLS0tLT4gZnJlZV9tZW1tYXAs
IHN0YXJ0X3BmbiA9IDhmMDAwLMKgIDhmMDAwMDAwIGVuZF9wZm4gPSA5MDAwMCwgOTAwMDAwMDAK
LS0tLT4gZnJlZV9tZW1tYXAsIHN0YXJ0X3BmbiA9IGRjYzAwLMKgIGRjYzAwMDAwIGVuZF9wZm4g
PSBkZTcwMCwgZGU3MDAwMDAKLS0tLT4gZnJlZV9tZW1tYXAsIHN0YXJ0X3BmbiA9IGRlYzAwLMKg
IGRlYzAwMDAwIGVuZF9wZm4gPSBlMDAwMCwgZTAwMDAwMDAKLS0tLT4gZnJlZV9tZW1tYXAsIHN0
YXJ0X3BmbiA9IGUwYzAwLMKgIGUwYzAwMDAwIGVuZF9wZm4gPSBlNDAwMCwgZTQwMDAwMDAKLS0t
LT4gZnJlZV9tZW1tYXAsIHN0YXJ0X3BmbiA9IGY3MDAwLMKgIGY3MDAwMDAwIGVuZF9wZm4gPSBm
ODAwMCwgZjgwMDAwMDAKPT09ID5tb3ZlX2ZyZWVwYWdlczogc3RhcnRfcGZuL2VuZF9wZm4gW2Rl
NjAwLCBkZTdmZl0sIFtkZTYwMDAwMCwgCmRlN2ZmMDAwXSA6wqAgcGZuID1kZTYwMCBwZm4ycGh5
ID0gZGU2MDAwMDAgLCBwYWdlID0gZWYzY2MwMDAsIHBhZ2UtZmxhZ3MgCj0gZmZmZmZmZmYKODwt
LS0gY3V0IGhlcmUgLS0tClVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0
IHZpcnR1YWwgYWRkcmVzcyBmZmZmZmZmZQpwZ2QgPSA1ZGQ1MGRmNQpbZmZmZmZmZmVdICpwZ2Q9
YWZmZmY4NjEsICpwdGU9MDAwMDAwMDAsICpwcHRlPTAwMDAwMDAwCkludGVybmFsIGVycm9yOiBP
b3BzOiAzNyBbIzFdIFNNUCBBUk0KTW9kdWxlcyBsaW5rZWQgaW46IGdtYWMoTykKQ1BVOiAyIFBJ
RDogNjM1IENvbW06IHRlc3Qtb29tIFRhaW50ZWQ6IEfCoMKgwqDCoMKgwqDCoMKgwqDCoCBPwqDC
oMKgwqDCoCA1LjEwLjArICMzMQpIYXJkd2FyZSBuYW1lOiBIaXNpbGljb24gQTkKUEMgaXMgYXQg
bW92ZV9mcmVlcGFnZXNfYmxvY2srMHgxNTAvMHgyNzgKTFIgaXMgYXQgbW92ZV9mcmVlcGFnZXNf
YmxvY2srMHgxNTAvMHgyNzgKcGMgOiBbPGMwMjM4M2E0Pl3CoMKgwqAgbHIgOiBbPGMwMjM4M2E0
Pl3CoMKgwqAgcHNyOiAyMDBlMDM5MwpzcCA6IGM0MTc5Y2Y4wqAgaXAgOiAwMDAwMDAwMMKgIGZw
IDogMDAwMDAwMDEKcjEwOiBjNDE3OWQ1OMKgIHI5IDogMDAwZGU3ZmbCoCByOCA6IDAwMDAwMDAw
CnI3IDogYzA4NjMyODDCoCByNiA6IDAwMGRlNjAwwqAgcjUgOiAwMDBkZTYwMMKgIHI0IDogZWYz
Y2MwMDAKcjMgOiBmZmZmZmZmZsKgIHIyIDogMDAwMDAwMDDCoCByMSA6IGVmNWQwNjljwqAgcjAg
OiBmZmZmZmZmZQpGbGFnczogbnpDdsKgIElSUXMgb2ZmwqAgRklRcyBvbsKgIE1vZGUgU1ZDXzMy
wqAgSVNBIEFSTcKgIFNlZ21lbnQgdXNlcgpDb250cm9sOiAxYWM1Mzg3ZMKgIFRhYmxlOiA4M2Iw
YzA0YcKgIERBQzogNTU1NTU1NTUKUHJvY2VzcyB0ZXN0LW9vbSAocGlkOiA2MzUsIHN0YWNrIGxp
bWl0ID0gMHgyNWQ2NjdkZikKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
