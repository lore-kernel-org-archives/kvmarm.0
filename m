Return-Path: <SRS0=4Pzf=KB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EB4C433B4
	for <kvmarm@archiver.kernel.org>; Thu,  6 May 2021 13:19:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8560061076
	for <kvmarm@archiver.kernel.org>; Thu,  6 May 2021 13:19:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8560061076
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF71F4B525;
	Thu,  6 May 2021 09:19:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dfI7szZAkCn5; Thu,  6 May 2021 09:19:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B30C4B57E;
	Thu,  6 May 2021 09:19:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B918A4B2DD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 May 2021 08:48:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZixPI9n8W2ce for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 May 2021 08:48:00 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3753F4B2B3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 May 2021 08:48:00 -0400 (EDT)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FbYFr4TdPz1BJCs;
 Thu,  6 May 2021 20:45:20 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Thu, 6 May 2021 20:47:52 +0800
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <82cfbb7f-dd4f-12d8-dc76-847f06172200@huawei.com>
Date: Thu, 6 May 2021 20:47:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YI+32ocTbec5Rm4e@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.177.243]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Thu, 06 May 2021 09:19:47 -0400
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

CgpPbiAyMDIxLzUvMyAxNjo0NCwgTWlrZSBSYXBvcG9ydCB3cm90ZToKPiBPbiBNb24sIE1heSAw
MywgMjAyMSBhdCAxMDowNzowMUFNICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCB3cm90ZToKPj4g
T24gMDMuMDUuMjEgMDg6MjYsIE1pa2UgUmFwb3BvcnQgd3JvdGU6Cj4+PiBPbiBGcmksIEFwciAz
MCwgMjAyMSBhdCAwNzoyNDozN1BNICswODAwLCBLZWZlbmcgV2FuZyB3cm90ZToKPj4+Pgo+Pj4+
Cj4+Pj4gT24gMjAyMS80LzMwIDE3OjUxLCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+Pj4+PiBPbiBU
aHUsIEFwciAyOSwgMjAyMSBhdCAwNjoyMjo1NVBNICswODAwLCBLZWZlbmcgV2FuZyB3cm90ZToK
Pj4+Pj4+Cj4+Pj4+PiBPbiAyMDIxLzQvMjkgMTQ6NTcsIE1pa2UgUmFwb3BvcnQgd3JvdGU6Cj4+
Pj4+Pgo+Pj4+Pj4+Pj4gRG8geW91IHVzZSBTUEFSU01FTT8gSWYgeWVzLCB3aGF0IGlzIHlvdXIg
c2VjdGlvbiBzaXplPwo+Pj4+Pj4+Pj4gV2hhdCBpcyB0aGUgdmFsdWUgaWYgQ09ORklHX0ZPUkNF
X01BWF9aT05FT1JERVIgaW4geW91ciBjb25maWd1cmF0aW9uPwo+Pj4+Pj4+PiBZZXMsCj4+Pj4+
Pj4+Cj4+Pj4+Pj4+IENPTkZJR19TUEFSU0VNRU09eQo+Pj4+Pj4+Pgo+Pj4+Pj4+PiBDT05GSUdf
U1BBUlNFTUVNX1NUQVRJQz15Cj4+Pj4+Pj4+Cj4+Pj4+Pj4+IENPTkZJR19GT1JDRV9NQVhfWk9O
RU9SREVSID0gMTEKPj4+Pj4+Pj4KPj4+Pj4+Pj4gQ09ORklHX1BBR0VfT0ZGU0VUPTB4QzAwMDAw
MDAKPj4+Pj4+Pj4gQ09ORklHX0hBVkVfQVJDSF9QRk5fVkFMSUQ9eQo+Pj4+Pj4+PiBDT05GSUdf
SElHSE1FTT15Cj4+Pj4+Pj4+ICNkZWZpbmUgU0VDVElPTl9TSVpFX0JJVFMgICAgMjYKPj4+Pj4+
Pj4gI2RlZmluZSBNQVhfUEhZU0FERFJfQklUUyAgICAzMgo+Pj4+Pj4+PiAjZGVmaW5lIE1BWF9Q
SFlTTUVNX0JJVFMgICAgIDMyCj4+Pj4+Pgo+Pj4+Pj4KPj4+Pj4+IFdpdGggdGhlIHBhdGNoLMKg
IHRoZSBhZGRyIGlzIGFsaWduZWQsIGJ1dCB0aGUgcGFuaWMgc3RpbGwgb2NjdXJyZWQsCj4+Pj4+
Cj4+Pj4+IElzIHRoaXMgdGhlIHNhbWUgcGFuaWMgYXQgbW92ZV9mcmVlcGFnZXMoKSBmb3IgcmFu
Z2UgW2RlNjAwLCBkZTdmZl0/Cj4+Pj4+Cj4+Pj4+IERvIHlvdSBlbmFibGUgQ09ORklHX0FSTV9M
UEFFPwo+Pj4+Cj4+Pj4gbm8sIHRoZSBDT05GSUdfQVJNX0xQQUUgaXMgbm90IHNldCwgYW5kIHll
cyB3aXRoIHNhbWUgcGFuaWMgYXQKPj4+PiBtb3ZlX2ZyZWVwYWdlcyBhdAo+Pj4+Cj4+Pj4gc3Rh
cnRfcGZuL2VuZF9wZm4gW2RlNjAwLCBkZTdmZl0sIFtkZTYwMDAwMCwgZGU3ZmYwMDBdIDogIHBm
biA9ZGU2MDAsIHBhZ2UKPj4+PiA9ZWYzY2MwMDAsIHBhZ2UtZmxhZ3MgPSBmZmZmZmZmZiwgIHBm
bjJwaHkgPSBkZTYwMDAwMAo+Pj4+Cj4+Pj4+PiBfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAw
eGIwMjAwMDAwIC0gMHhjMDAwMDAwMCwgcGZuOiBiMDIwMCAtIGIwMjAwCj4+Pj4+PiBfX2ZyZWVf
bWVtb3J5X2NvcmUsIHJhbmdlOiAweGNjMDAwMDAwIC0gMHhkY2EwMDAwMCwgcGZuOiBjYzAwMCAt
IGIwMjAwCj4+Pj4+PiBfX2ZyZWVfbWVtb3J5X2NvcmUsIHJhbmdlOiAweGRlNzAwMDAwIC0gMHhk
ZWEwMDAwMCwgcGZuOiBkZTcwMCAtIGIwMjAwCj4+Pgo+Pj4gSG1tLCBbZGU2MDAsIGRlN2ZmXSBp
cyBub3QgYWRkZWQgdG8gdGhlIGZyZWUgbGlzdHMgd2hpY2ggaXMgY29ycmVjdC4gQnV0Cj4+PiB0
aGVuIGl0J3MgdW5jbGVhciBob3cgdGhlIHBhZ2UgZm9yIGRlNjAwIGdldHMgdG8gbW92ZV9mcmVl
cGFnZXMoKS4uLgo+Pj4KPj4+IENhbid0IHNheSBJIGhhdmUgYW55IGJyaWdodCBpZGVhcyB0byB0
cnkgaGVyZS4uLgo+Pgo+PiBBcmUgd2UgbWlzc2luZyBzb21lIGNoZWNrcyAoZS5nLiwgUGFnZVJl
c2VydmVkKCkpIHRoYXQgcGZuX3ZhbGlkX3dpdGhpbigpCj4+IHdvdWxkIGhhdmUgImNhdWdodCIg
YmVmb3JlPwo+IAo+IFVubGVzcyBJJ20gbWlzc2luZyBzb21ldGhpbmcgdGhlIGNyYXNoIGhhcHBl
bnMgaW4gX19ybXF1ZXVlX2ZhbGxiYWNrKCk6Cj4gCj4gZG9fc3RlYWw6Cj4gCXBhZ2UgPSBnZXRf
cGFnZV9mcm9tX2ZyZWVfYXJlYShhcmVhLCBmYWxsYmFja19tdCk7Cj4gCj4gCXN0ZWFsX3N1aXRh
YmxlX2ZhbGxiYWNrKHpvbmUsIHBhZ2UsIGFsbG9jX2ZsYWdzLCBzdGFydF9taWdyYXRldHlwZSwK
PiAJCQkJCQkJCWNhbl9zdGVhbCk7Cj4gCQktPiBtb3ZlX2ZyZWVwYWdlcygpCj4gCQkJLT4gQlVH
KCkKPiAKPiBTbyBhIHBhZ2UgZnJvbSBmcmVlIGFyZWEgc2hvdWxkIGJlIHNhbmUgYXMgdGhlIGZy
ZWVkIHJhbmdlIHdhcyBuZXZlciBhZGRlZAo+IGl0IHRvIHRoZSBmcmVlIGxpc3RzLgoKU29ycnkg
Zm9yIHRoZSBsYXRlIHJlc3BvbnNlIGR1ZSB0byB0aGUgdmFjYXRpb24uCgpUaGUgcGZuIGluIHJh
bmdlIFtkZTYwMCwgZGU3ZmZdIHdvbid0IGJlIGFkZGVkIGludG8gdGhlIGZyZWUgbGlzdHMgdmlh
IApfX2ZyZWVfbWVtb3J5X2NvcmUoKSwgYnV0IHRoZSBwZm4gY291bGQgYmUgYWRkZWQgaW50byBm
cmVlbGlzdHMgdmlhIApmcmVlX2hpZ2htZW1fcGFnZSgpCgpJIGFkZCBzb21lIGRlYnVnWzFdIGlu
IGFkZF90b19mcmVlX2xpc3QoKSwgd2UgY291bGQgc2VlIHRoZSBjYWxsdHJhY2UKCmZyZWVfaGln
aHBhZ2VzLCByYW5nZV9wZm4gW2IwMjAwLCBjMDAwMF0sIHJhbmdlX2FkZHIgW2IwMjAwMDAwLCBj
MDAwMDAwMF0KZnJlZV9oaWdocGFnZXMsIHJhbmdlX3BmbiBbY2MwMDAsIGRjYTAwXSwgcmFuZ2Vf
YWRkciBbY2MwMDAwMDAsIGRjYTAwMDAwXQpmcmVlX2hpZ2hwYWdlcywgcmFuZ2VfcGZuIFtkZTcw
MCwgZGVhMDBdLCByYW5nZV9hZGRyIFtkZTcwMDAwMCwgZGVhMDAwMDBdCmFkZF90b19mcmVlX2xp
c3QsID09PT4gcGZuID0gZGU3MDAKLS0tLS0tLS0tLS0tWyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0t
CldBUk5JTkc6IENQVTogMCBQSUQ6IDAgYXQgbW0vcGFnZV9hbGxvYy5jOjkwMCBhZGRfdG9fZnJl
ZV9saXN0KzB4OGMvMHhlYwpwZm4gPSBkZTcwMApNb2R1bGVzIGxpbmtlZCBpbjoKQ1BVOiAwIFBJ
RDogMCBDb21tOiBzd2FwcGVyIE5vdCB0YWludGVkIDUuMTAuMCsgIzQ4CkhhcmR3YXJlIG5hbWU6
IEhpc2lsaWNvbiBBOQpbPGMwMTBhNjAwPl0gKHNob3dfc3RhY2spIGZyb20gWzxjMDRiMjFjND5d
IChkdW1wX3N0YWNrKzB4OWMvMHhjMCkKWzxjMDRiMjFjND5dIChkdW1wX3N0YWNrKSBmcm9tIFs8
YzAxMWM3MDg+XSAoX193YXJuKzB4YzAvMHhlYykKWzxjMDExYzcwOD5dIChfX3dhcm4pIGZyb20g
WzxjMDExYzdhOD5dICh3YXJuX3Nsb3dwYXRoX2ZtdCsweDc0LzB4YTQpCls8YzAxMWM3YTg+XSAo
d2Fybl9zbG93cGF0aF9mbXQpIGZyb20gWzxjMDIzNzIxYz5dIAooYWRkX3RvX2ZyZWVfbGlzdCsw
eDhjLzB4ZWMpCls8YzAyMzcyMWM+XSAoYWRkX3RvX2ZyZWVfbGlzdCkgZnJvbSBbPGMwMjM3ZTAw
Pl0gCihmcmVlX3BjcHBhZ2VzX2J1bGsrMHgyMDAvMHgyNzgpCls8YzAyMzdlMDA+XSAoZnJlZV9w
Y3BwYWdlc19idWxrKSBmcm9tIFs8YzAyMzhkMTQ+XSAKKGZyZWVfdW5yZWZfcGFnZSsweDU4LzB4
NjgpCls8YzAyMzhkMTQ+XSAoZnJlZV91bnJlZl9wYWdlKSBmcm9tIFs8YzAyM2JiNTQ+XSAKKGZy
ZWVfaGlnaG1lbV9wYWdlKzB4Yy8weDUwKQpbPGMwMjNiYjU0Pl0gKGZyZWVfaGlnaG1lbV9wYWdl
KSBmcm9tIFs8YzA3MDYyMGM+XSAobWVtX2luaXQrMHgyMWMvMHgyNTQpCls8YzA3MDYyMGM+XSAo
bWVtX2luaXQpIGZyb20gWzxjMDcwMGIzOD5dIChzdGFydF9rZXJuZWwrMHgyNTgvMHg1YzApCls8
YzA3MDBiMzg+XSAoc3RhcnRfa2VybmVsKSBmcm9tIFs8MDAwMDAwMDA+XSAoMHgwKQoKc28gYW55
IGlkZWE/CgpbMV0gZGVidWcKZGlmZiAtLWdpdCBhL2FyY2gvYXJtL21tL2luaXQuYyBiL2FyY2gv
YXJtL21tL2luaXQuYwppbmRleCAxYmE5ZjlmOWRiZDguLmVlMzYxOWMwNGY5MyAxMDA2NDQKLS0t
IGEvYXJjaC9hcm0vbW0vaW5pdC5jCisrKyBiL2FyY2gvYXJtL21tL2luaXQuYwpAQCAtMjg2LDcg
KzI4Niw3IEBAIHN0YXRpYyB2b2lkIF9faW5pdCBmcmVlX2hpZ2hwYWdlcyh2b2lkKQogICAgICAg
ICAgICAgICAgIC8qIFRydW5jYXRlIHBhcnRpYWwgaGlnaG1lbSBlbnRyaWVzICovCiAgICAgICAg
ICAgICAgICAgaWYgKHN0YXJ0IDwgbWF4X2xvdykKICAgICAgICAgICAgICAgICAgICAgICAgIHN0
YXJ0ID0gbWF4X2xvdzsKLQorICAgICAgICAgICAgICAgcHJfaW5mbygiJXMsIHJhbmdlX3BmbiBb
JWx4LCAlbHhdLCByYW5nZV9hZGRyIFsleCwgCiV4XVxuIiwgX19mdW5jX18sIHN0YXJ0LCBlbmQs
IHJhbmdlX3N0YXJ0LCByYW5nZV9lbmQpOwogICAgICAgICAgICAgICAgIGZvciAoOyBzdGFydCA8
IGVuZDsgc3RhcnQrKykKICAgICAgICAgICAgICAgICAgICAgICAgIGZyZWVfaGlnaG1lbV9wYWdl
KHBmbl90b19wYWdlKHN0YXJ0KSk7CgpkaWZmIC0tZ2l0IGEvbW0vcGFnZV9hbGxvYy5jIGIvbW0v
cGFnZV9hbGxvYy5jCmluZGV4IDU5MjQ3OWY0M2M3NC4uOTIwZjA0MWYwYzZmIDEwMDY0NAotLS0g
YS9tbS9wYWdlX2FsbG9jLmMKKysrIGIvbW0vcGFnZV9hbGxvYy5jCkBAIC04OTIsNyArODkyLDE0
IEBAIGNvbXBhY3Rpb25fY2FwdHVyZShzdHJ1Y3QgY2FwdHVyZV9jb250cm9sICpjYXBjLCAKc3Ry
dWN0IHBhZ2UgKnBhZ2UsCiAgc3RhdGljIGlubGluZSB2b2lkIGFkZF90b19mcmVlX2xpc3Qoc3Ry
dWN0IHBhZ2UgKnBhZ2UsIHN0cnVjdCB6b25lICp6b25lLAogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgdW5zaWduZWQgaW50IG9yZGVyLCBpbnQgbWlncmF0ZXR5cGUpCiAgewor
ICAgICAgIHVuc2lnbmVkIGxvbmcgcGZuOwogICAgICAgICBzdHJ1Y3QgZnJlZV9hcmVhICphcmVh
ID0gJnpvbmUtPmZyZWVfYXJlYVtvcmRlcl07CisgICAgICAgcGZuID0gcGFnZV90b19wZm4ocGFn
ZSk7CisgICAgICAgaWYgKHBmbiA+PSAweGRlNjAwICYmIHBmbiA8IDB4ZGU3ZmYpIHsKKyAgICAg
ICAgICAgICAgIHByX2luZm8oIiVzLCA9PT0+IHBmbiA9ICVseCIsIF9fZnVuY19fLCBwZm4pOwor
ICAgICAgICAgICAgICAgV0FSTl9PTkNFKHBmbiA9PSAweGRlNzAwLCAicGZuID0gJWx4IiwgcGZu
KTsKKyAgICAgICB9CgoKCj4gCj4gQW5kIGhvbmVzdGx5LCB3aXRoIHRoZSBtZW1vcnkgbGF5b3V0
IHJlcG9ydGVkIGVsc2V3aGVyZSBpbiB0aGUgc3RhY2sgSSdkCj4gc2F5IHRoYXQgdGhlIGJvb3Rs
b2FkZXIvZmR0IGJlZyBmb3IgZml4ZXMuLi4KPiAKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
