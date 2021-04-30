Return-Path: <SRS0=QphI=J3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9767DC433B4
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 11:50:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E88FF61474
	for <kvmarm@archiver.kernel.org>; Fri, 30 Apr 2021 11:50:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E88FF61474
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 612994B428;
	Fri, 30 Apr 2021 07:50:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aEHRRzmIUPhR; Fri, 30 Apr 2021 07:50:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAC444B42B;
	Fri, 30 Apr 2021 07:50:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B1AB24B3FF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 07:24:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mxsxdNRJD6fv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Apr 2021 07:24:48 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 662004B3DC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Apr 2021 07:24:48 -0400 (EDT)
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FWqhk0Hn2znTYF;
 Fri, 30 Apr 2021 19:22:14 +0800 (CST)
Received: from [10.174.177.244] (10.174.177.244) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Fri, 30 Apr 2021 19:24:38 +0800
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
To: Mike Rapoport <rppt@kernel.org>
References: <YIUYG8N9T3/C/tSG@kernel.org>
 <52f7d03b-7219-46bc-c62d-b976bc31ebd5@huawei.com>
 <YIZNq5HMfJ1rWytv@kernel.org>
 <2d879629-3059-fd42-428f-4b7c2a73d698@huawei.com>
 <YIet5X7lgygD9rpZ@kernel.org>
 <259d14df-a713-72e7-4ccb-c06a8ee31e13@huawei.com>
 <YIj5zcbHBHt7CC8B@kernel.org>
 <6ad2956c-70ae-c423-ed7d-88e94c88060f@huawei.com>
 <YIpY8TXCSc7Lfa2Z@kernel.org>
 <0cb013e4-1157-f2fa-96ec-e69e60833f72@huawei.com>
 <YIvTM5Yqit8AB4W8@kernel.org>
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <ca5b00bd-1312-0c69-ab69-a1bd749f51b6@huawei.com>
Date: Fri, 30 Apr 2021 19:24:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YIvTM5Yqit8AB4W8@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.177.244]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Fri, 30 Apr 2021 07:50:49 -0400
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

CgpPbiAyMDIxLzQvMzAgMTc6NTEsIE1pa2UgUmFwb3BvcnQgd3JvdGU6Cj4gT24gVGh1LCBBcHIg
MjksIDIwMjEgYXQgMDY6MjI6NTVQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3JvdGU6Cj4+Cj4+IE9u
IDIwMjEvNC8yOSAxNDo1NywgTWlrZSBSYXBvcG9ydCB3cm90ZToKPj4KPj4+Pj4gRG8geW91IHVz
ZSBTUEFSU01FTT8gSWYgeWVzLCB3aGF0IGlzIHlvdXIgc2VjdGlvbiBzaXplPwo+Pj4+PiBXaGF0
IGlzIHRoZSB2YWx1ZSBpZiBDT05GSUdfRk9SQ0VfTUFYX1pPTkVPUkRFUiBpbiB5b3VyIGNvbmZp
Z3VyYXRpb24/Cj4+Pj4gWWVzLAo+Pj4+Cj4+Pj4gQ09ORklHX1NQQVJTRU1FTT15Cj4+Pj4KPj4+
PiBDT05GSUdfU1BBUlNFTUVNX1NUQVRJQz15Cj4+Pj4KPj4+PiBDT05GSUdfRk9SQ0VfTUFYX1pP
TkVPUkRFUiA9IDExCj4+Pj4KPj4+PiBDT05GSUdfUEFHRV9PRkZTRVQ9MHhDMDAwMDAwMAo+Pj4+
IENPTkZJR19IQVZFX0FSQ0hfUEZOX1ZBTElEPXkKPj4+PiBDT05GSUdfSElHSE1FTT15Cj4+Pj4g
I2RlZmluZSBTRUNUSU9OX1NJWkVfQklUUyAgICAyNgo+Pj4+ICNkZWZpbmUgTUFYX1BIWVNBRERS
X0JJVFMgICAgMzIKPj4+PiAjZGVmaW5lIE1BWF9QSFlTTUVNX0JJVFMgICAgIDMyCj4+Cj4+Cj4+
IFdpdGggdGhlIHBhdGNoLMKgIHRoZSBhZGRyIGlzIGFsaWduZWQsIGJ1dCB0aGUgcGFuaWMgc3Rp
bGwgb2NjdXJyZWQsCj4gCj4gSXMgdGhpcyB0aGUgc2FtZSBwYW5pYyBhdCBtb3ZlX2ZyZWVwYWdl
cygpIGZvciByYW5nZSBbZGU2MDAsIGRlN2ZmXT8KPiAKPiBEbyB5b3UgZW5hYmxlIENPTkZJR19B
Uk1fTFBBRT8KCm5vLCB0aGUgQ09ORklHX0FSTV9MUEFFIGlzIG5vdCBzZXQsIGFuZCB5ZXMgd2l0
aCBzYW1lIHBhbmljIGF0IAptb3ZlX2ZyZWVwYWdlcyBhdAoKc3RhcnRfcGZuL2VuZF9wZm4gW2Rl
NjAwLCBkZTdmZl0sIFtkZTYwMDAwMCwgZGU3ZmYwMDBdIDogIHBmbiA9ZGU2MDAsIApwYWdlID1l
ZjNjYzAwMCwgcGFnZS1mbGFncyA9IGZmZmZmZmZmLCAgcGZuMnBoeSA9IGRlNjAwMDAwCgoKCj4g
Cj4+IG5ldyBmcmVlIG1lbW9yeSBsb2cgaXMgYmVsb3csCj4+Cj4+IG1lbWJsb2NrX2ZyZWU6IFsw
eGFmNDMwMDAwLTB4YWY0NGZmZmZdIG1lbV9pbml0KzB4MTU4LzB4MjNjCj4+Cj4+IG1lbWJsb2Nr
X2ZyZWU6IFsweGFmNTEwMDAwLTB4YWY1M2ZmZmZdIG1lbV9pbml0KzB4MTU4LzB4MjNjCj4+IG1l
bWJsb2NrX2ZyZWU6IFsweGFmNTYwMDAwLTB4YWY1N2ZmZmZdIG1lbV9pbml0KzB4MTU4LzB4MjNj
Cj4+IG1lbWJsb2NrX2ZyZWU6IFsweGFmZDk4MDAwLTB4YWZkYzdmZmZdIG1lbV9pbml0KzB4MTU4
LzB4MjNjCj4+IG1lbWJsb2NrX2ZyZWU6IFsweGFmZGQ4MDAwLTB4YWZkZmZmZmZdIG1lbV9pbml0
KzB4MTU4LzB4MjNjCj4+IG1lbWJsb2NrX2ZyZWU6IFsweGFmZTE4MDAwLTB4YWZlN2ZmZmZdIG1l
bV9pbml0KzB4MTU4LzB4MjNjCj4+IG1lbWJsb2NrX2ZyZWU6IFsweGFmZWUwMDAwLTB4YWZlZmZm
ZmZdIG1lbV9pbml0KzB4MTU4LzB4MjNjCj4+IF9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4
ODBhMDMwMDAgLSAweDgwYTA0MDAwLCBwZm46IDgwYTAzIC0gODBhMDQKPj4gX19mcmVlX21lbW9y
eV9jb3JlLCByYW5nZTogMHg4MGEwODAwMCAtIDB4ODBiMDAwMDAsIHBmbjogODBhMDggLSA4MGIw
MAo+PiBfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweDgxMmU4MDU4IC0gMHg4MzAwMDAwMCwg
cGZuOiA4MTJlOSAtIDgzMDAwCj4+IF9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4ODUwMDAw
MDAgLSAweDg1NjAwMDAwLCBwZm46IDg1MDAwIC0gODU2MDAKPj4gX19mcmVlX21lbW9yeV9jb3Jl
LCByYW5nZTogMHg4NmEwMDAwMCAtIDB4ODdlMDAwMDAsIHBmbjogODZhMDAgLSA4N2UwMAo+PiBf
X2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweDhiZDAwMDAwIC0gMHg4YzUwMDAwMCwgcGZuOiA4
YmQwMCAtIDhjNTAwCj4+IF9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4OGUzMDAwMDAgLSAw
eDhlZDAwMDAwLCBwZm46IDhlMzAwIC0gOGVkMDAKPj4gX19mcmVlX21lbW9yeV9jb3JlLCByYW5n
ZTogMHg5MGQwMDAwMCAtIDB4YWYyYzAwMDAsIHBmbjogOTBkMDAgLSBhZjJjMAo+PiBfX2ZyZWVf
bWVtb3J5X2NvcmUsIHJhbmdlOiAweGFmNDMwMDAwIC0gMHhhZjQ1MDAwMCwgcGZuOiBhZjQzMCAt
IGFmNDUwCj4+IF9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4YWY1MTAwMDAgLSAweGFmNTQw
MDAwLCBwZm46IGFmNTEwIC0gYWY1NDAKPj4gX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhh
ZjU2MDAwMCAtIDB4YWY1ODAwMDAsIHBmbjogYWY1NjAgLSBhZjU4MAo+PiBfX2ZyZWVfbWVtb3J5
X2NvcmUsIHJhbmdlOiAweGFmZDk4MDAwIC0gMHhhZmRjODAwMCwgcGZuOiBhZmQ5OCAtIGFmZGM4
Cj4+IF9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4YWZkZDgwMDAgLSAweGFmZTAwMDAwLCBw
Zm46IGFmZGQ4IC0gYWZlMDAKPj4gX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhhZmUxODAw
MCAtIDB4YWZlODAwMDAsIHBmbjogYWZlMTggLSBhZmU4MAo+PiBfX2ZyZWVfbWVtb3J5X2NvcmUs
IHJhbmdlOiAweGFmZWUwMDAwIC0gMHhhZmYwMDAwMCwgcGZuOiBhZmVlMCAtIGFmZjAwCj4+IF9f
ZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4YWZmODAwMDAgLSAweGFmZjhkMDAwLCBwZm46IGFm
ZjgwIC0gYWZmOGQKPj4gX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhhZmZmMjAwMCAtIDB4
YWZmZjQ1ODAsIHBmbjogYWZmZjIgLSBhZmZmNAo+PiBfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdl
OiAweGFmZmZlMDAwIC0gMHhhZmZmZTBlMCwgcGZuOiBhZmZmZSAtIGFmZmZlCj4+IF9fZnJlZV9t
ZW1vcnlfY29yZSwgcmFuZ2U6IDB4YWZmZmU0ZmMgLSAweGFmZmZlNTAwLCBwZm46IGFmZmZmIC0g
YWZmZmUKPj4gX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhhZmZmZTZlNCAtIDB4YWZmZmU3
MDAsIHBmbjogYWZmZmYgLSBhZmZmZQo+PiBfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweGFm
ZmZlOGRjIC0gMHhhZmZmZThlMCwgcGZuOiBhZmZmZiAtIGFmZmZlCj4+IF9fZnJlZV9tZW1vcnlf
Y29yZSwgcmFuZ2U6IDB4YWZmZmU5NzAgLSAweGFmZmZlOTgwLCBwZm46IGFmZmZmIC0gYWZmZmUK
Pj4gX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhhZmZmZTk5MCAtIDB4YWZmZmU5YTAsIHBm
bjogYWZmZmYgLSBhZmZmZQo+PiBfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweGFmZmZlOWE0
IC0gMHhhZmZmZTljMCwgcGZuOiBhZmZmZiAtIGFmZmZlCj4+IF9fZnJlZV9tZW1vcnlfY29yZSwg
cmFuZ2U6IDB4YWZmZmViNTQgLSAweGFmZmZlYjYwLCBwZm46IGFmZmZmIC0gYWZmZmUKPj4gX19m
cmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhhZmZmZWNmNCAtIDB4YWZmZmVkMDAsIHBmbjogYWZm
ZmYgLSBhZmZmZQo+PiBfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweGFmZmZlZmM0IC0gMHhh
ZmZmZWZkOCwgcGZuOiBhZmZmZiAtIGFmZmZlCj4+IF9fZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6
IDB4YjAyMDAwMDAgLSAweGMwMDAwMDAwLCBwZm46IGIwMjAwIC0gYjAyMDAKPj4gX19mcmVlX21l
bW9yeV9jb3JlLCByYW5nZTogMHhjYzAwMDAwMCAtIDB4ZGNhMDAwMDAsIHBmbjogY2MwMDAgLSBi
MDIwMAo+PiBfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweGRlNzAwMDAwIC0gMHhkZWEwMDAw
MCwgcGZuOiBkZTcwMCAtIGIwMjAwCj4gCj4gVGhlIHJhbmdlIFtkZTYwMCwgZGU3ZmZdCnRoZSBf
X2ZyZWVfbWVtb3J5X2NvcmUgd2lsbCBjaGVjayB0aGUgc3RhcnQgcGZuIGFuZCBlbmQgcGZuLAoK
ICBpZiAoc3RhcnRfcGZuID49IGVuZF9wZm4pCiAgICAgICAgICByZXR1cm4gMDsKCiAgX19mcmVl
X3BhZ2VzX21lbW9yeShzdGFydF9wZm4sIGVuZF9wZm4pOwpzbyB0aGUgbWVtb3J5IHdpbGwgbm90
IGJlIGZyZWVkIHRvIGJ1ZGR5LCBjb25mdXNlZC4uLgo+IAo+PiBfX2ZyZWVfbWVtb3J5X2NvcmUs
IHJhbmdlOiAweGUwODAwMDAwIC0gMHhlMGMwMDAwMCwgcGZuOiBlMDgwMCAtIGIwMjAwCj4+IF9f
ZnJlZV9tZW1vcnlfY29yZSwgcmFuZ2U6IDB4ZjRiMDAwMDAgLSAweGY3MDAwMDAwLCBwZm46IGY0
YjAwIC0gYjAyMDAKPj4gX19mcmVlX21lbW9yeV9jb3JlLCByYW5nZTogMHhmZGEwMDAwMCAtIDB4
ZmZmZmZmZmYsIHBmbjogZmRhMDAgLSBiMDIwMAo+Pj4gSXQgc2VlbXMgdGhhdCB3aXRoIFNQQVJT
RU1FTSB3ZSBkb24ndCBhbGlnbiB0aGUgZnJlZWQgcGFydHMgb24gcGFnZWJsb2NrCj4+PiBib3Vu
ZGFyaWVzLgo+Pj4KPj4+IENhbiB5b3UgdHJ5IHRoZSBwYXRjaCBiZWxvdzoKPj4+Cj4+PiBkaWZm
IC0tZ2l0IGEvbW0vbWVtYmxvY2suYyBiL21tL21lbWJsb2NrLmMKPj4+IGluZGV4IGFmYWVmYThm
YzZhYi4uMTkyNjM2OWI1MmVjIDEwMDY0NAo+Pj4gLS0tIGEvbW0vbWVtYmxvY2suYwo+Pj4gKysr
IGIvbW0vbWVtYmxvY2suYwo+Pj4gQEAgLTE5NDEsMTQgKzE5NDEsMTMgQEAgc3RhdGljIHZvaWQg
X19pbml0IGZyZWVfdW51c2VkX21lbW1hcCh2b2lkKQo+Pj4gICAgCQkgKiBkdWUgdG8gU1BBUlNF
TUVNIHNlY3Rpb25zIHdoaWNoIGFyZW4ndCBwcmVzZW50Lgo+Pj4gICAgCQkgKi8KPj4+ICAgIAkJ
c3RhcnQgPSBtaW4oc3RhcnQsIEFMSUdOKHByZXZfZW5kLCBQQUdFU19QRVJfU0VDVElPTikpOwo+
Pj4gLSNlbHNlCj4+PiArI2VuZGlmCj4+PiAgICAJCS8qCj4+PiAgICAJCSAqIEFsaWduIGRvd24g
aGVyZSBzaW5jZSB0aGUgVk0gc3Vic3lzdGVtIGluc2lzdHMgdGhhdCB0aGUKPj4+ICAgIAkJICog
bWVtbWFwIGVudHJpZXMgYXJlIHZhbGlkIGZyb20gdGhlIGJhbmsgc3RhcnQgYWxpZ25lZCB0bwo+
Pj4gICAgCQkgKiBNQVhfT1JERVJfTlJfUEFHRVMuCj4+PiAgICAJCSAqLwo+Pj4gICAgCQlzdGFy
dCA9IHJvdW5kX2Rvd24oc3RhcnQsIE1BWF9PUkRFUl9OUl9QQUdFUyk7Cj4+PiAtI2VuZGlmCj4+
PiAgICAJCS8qCj4+PiAgICAJCSAqIElmIHdlIGhhZCBhIHByZXZpb3VzIGJhbmssIGFuZCB0aGVy
ZSBpcyBhIHNwYWNlCj4+Pgo+IApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
