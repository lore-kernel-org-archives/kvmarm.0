Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E15AC433B4
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 15:33:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD0D661452
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 15:33:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD0D661452
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B0114B433;
	Thu, 22 Apr 2021 11:33:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BHH-segGK9Bf; Thu, 22 Apr 2021 11:33:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B20D14B436;
	Thu, 22 Apr 2021 11:33:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 746EF4B404
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 11:28:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T6CqR7UkSDro for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 11:28:38 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C2694B38F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 11:28:38 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FR1T26DV9zpZmV;
 Thu, 22 Apr 2021 23:25:26 +0800 (CST)
Received: from [10.174.177.244] (10.174.177.244) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Thu, 22 Apr 2021 23:28:24 +0800
Subject: Re: [PATCH v2 0/4] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
To: Mike Rapoport <rppt@kernel.org>
References: <20210421065108.1987-1-rppt@kernel.org>
 <9aa68d26-d736-3b75-4828-f148964eb7f0@huawei.com>
 <YIEl8aKr8Ly0Zd3O@kernel.org>
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
Date: Thu, 22 Apr 2021 23:28:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <YIEl8aKr8Ly0Zd3O@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.177.244]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Thu, 22 Apr 2021 11:33:25 -0400
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

Ck9uIDIwMjEvNC8yMiAxNToyOSwgTWlrZSBSYXBvcG9ydCB3cm90ZToKPiBPbiBUaHUsIEFwciAy
MiwgMjAyMSBhdCAwMzowMDoyMFBNICswODAwLCBLZWZlbmcgV2FuZyB3cm90ZToKPj4gT24gMjAy
MS80LzIxIDE0OjUxLCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+Pj4gRnJvbTogTWlrZSBSYXBvcG9y
dCA8cnBwdEBsaW51eC5pYm0uY29tPgo+Pj4KPj4+IEhpLAo+Pj4KPj4+IFRoZXNlIHBhdGNoZXMg
YWltIHRvIHJlbW92ZSBDT05GSUdfSE9MRVNfSU5fWk9ORSBhbmQgZXNzZW50aWFsbHkgaGFyZHdp
cmUKPj4+IHBmbl92YWxpZF93aXRoaW4oKSB0byAxLgo+Pj4KPj4+IFRoZSBpZGVhIGlzIHRvIG1h
cmsgTk9NQVAgcGFnZXMgYXMgcmVzZXJ2ZWQgaW4gdGhlIG1lbW9yeSBtYXAgYW5kIHJlc3RvcmUK
Pj4+IHRoZSBpbnRlbmRlZCBzZW1hbnRpY3Mgb2YgcGZuX3ZhbGlkKCkgdG8gZGVzaWduYXRlIGF2
YWlsYWJpbGl0eSBvZiBzdHJ1Y3QKPj4+IHBhZ2UgZm9yIGEgcGZuLgo+Pj4KPj4+IFdpdGggdGhp
cyB0aGUgY29yZSBtbSB3aWxsIGJlIGFibGUgdG8gY29wZSB3aXRoIHRoZSBmYWN0IHRoYXQgaXQg
Y2Fubm90IHVzZQo+Pj4gTk9NQVAgcGFnZXMgYW5kIHRoZSBob2xlcyBjcmVhdGVkIGJ5IE5PTUFQ
IHJhbmdlcyB3aXRoaW4gTUFYX09SREVSIGJsb2Nrcwo+Pj4gd2lsbCBiZSB0cmVhdGVkIGNvcnJl
Y3RseSBldmVuIHdpdGhvdXQgdGhlIG5lZWQgZm9yIHBmbl92YWxpZF93aXRoaW4uCj4+Pgo+Pj4g
VGhlIHBhdGNoZXMgYXJlIG9ubHkgYm9vdCB0ZXN0ZWQgb24gcWVtdS1zeXN0ZW0tYWFyY2g2NCBz
byBJJ2QgcmVhbGx5Cj4+PiBhcHByZWNpYXRlIG1lbW9yeSBzdHJlc3MgdGVzdHMgb24gcmVhbCBo
YXJkd2FyZS4KPj4+Cj4+PiBJZiB0aGlzIGFjdHVhbGx5IHdvcmtzIHdlJ2xsIGJlIG9uZSBzdGVw
IGNsb3NlciB0byBkcm9wIGN1c3RvbSBwZm5fdmFsaWQoKQo+Pj4gb24gYXJtNjQgYWx0b2dldGhl
ci4KPj4gSGkgTWlrZe+8jEkgaGF2ZSBhIHF1ZXN0aW9uLCB3aXRob3V0IEhPTEVTX0lOX1pPTkUs
IHRoZSBwZm5fdmFsaWRfd2l0aGluKCkgaW4KPj4gbW92ZV9mcmVlcGFnZXNfYmxvY2soKS0+bW92
ZV9mcmVlcGFnZXMoKQo+PiB3aWxsIGJlIG9wdGltaXplZCwgaWYgdGhlcmUgYXJlIGhvbGVzIGlu
IHpvbmUsIHRoZSAnc3RydWNlIHBhZ2UnKG1lbW9yeSBtYXApCj4+IGZvciBwZm4gcmFuZ2Ugb2Yg
aG9sZSB3aWxsIGJlIGZyZWUgYnkKPj4gZnJlZV9tZW1tYXAoKSwgYW5kIHRoZW4gdGhlIHBhZ2Ug
dHJhdmVyc2UgaW4gdGhlIHpvbmUod2l0aCBob2xlcykgZnJvbQo+PiBtb3ZlX2ZyZWVwYWdlcygp
IHdpbGwgbWVldCB0aGUgd3JvbmcgcGFnZe+8jAo+PiB0aGVuIGl0IGNvdWxkIHBhbmljIGF0IFBh
Z2VMUlUocGFnZSkgdGVzdCwgY2hlY2sgbGlua1sxXSwKPiBGaXJzdCwgSE9MRVNfSU5fWk9ORSBu
YW1lIHVzIGh1Z2VseSBtaXNsZWFkaW5nLCB0aGlzIGNvbmZpZ3VyYXRpb24gb3B0aW9uCj4gaGFz
IG5vdGhpbmcgdG8gdG8gd2l0aCBtZW1vcnkgaG9sZXMsIGJ1dCByYXRoZXIgaXQgaXMgdGhlcmUg
dG8gZGVhbCB3aXRoCj4gaG9sZXMgb3IgdW5kZWZpbmVkIHN0cnVjdCBwYWdlcyBpbiB0aGUgbWVt
b3J5IG1hcCwgd2hlbiB0aGVzZSBob2xlcyBjYW4gYmUKPiBpbnNpZGUgYSBNQVhfT1JERVJfTlJf
UEFHRVMgcmVnaW9uLgo+Cj4gSW4gZ2VuZXJhbCBwZm4gd2Fsa2VycyB1c2UgcGZuX3ZhbGlkKCkg
YW5kIHBmbl92YWxpZF93aXRoaW4oKSB0byBhdm9pZAo+IGFjY2Vzc2luZyAqbWlzc2luZyogc3Ry
dWN0IHBhZ2VzLCBsaWtlIHRob3NlIHRoYXQgYXJlIGZyZWVkIGF0Cj4gZnJlZV9tZW1tYXAoKS4g
QnV0IG9uIGFybTY0IHRoZXNlIHRlc3RzIGFsc28gZmlsdGVyIG91dCB0aGUgbm9tYXAgZW50cmll
cwo+IGJlY2F1c2UgdGhlaXIgc3RydWN0IHBhZ2VzIGFyZSBub3QgaW5pdGlhbGl6ZWQuCj4KPiBU
aGUgcGFuaWMgeW91IHJlZmVyIHRvIGhhcHBlbmVkIGJlY2F1c2UgdGhlcmUgd2FzIGFuIHVuaW5p
dGlhbGl6ZWQgc3RydWN0Cj4gcGFnZSBpbiB0aGUgbWlkZGxlIG9mIE1BWF9PUkRFUl9OUl9QQUdF
UyByZWdpb24gYmVjYXVzZSBpdCBjb3JyZXNwb25kZWQgdG8KPiBub21hcCBtZW1vcnkuCj4KPiBX
aXRoIHRoZXNlIGNoYW5nZXMgSSBtYWtlIHN1cmUgdGhhdCBzdWNoIHBhZ2VzIHdpbGwgYmUgcHJv
cGVybHkgaW5pdGlhbGl6ZWQKPiBhcyBQYWdlUmVzZXJ2ZWQgYW5kIHRoZSBwZm4gd2Fsa2VycyB3
aWxsIGJlIGFibGUgdG8gcmVseSBvbiB0aGUgbWVtb3J5IG1hcC4KPgo+IE5vdGUgYWxzbywgdGhh
dCBmcmVlX21lbW1hcCgpIGFsaWducyB0aGUgcGFydHMgYmVpbmcgZnJlZWQgb24gTUFYX09SREVS
Cj4gYm91bmRhcmllcywgc28gdGhlcmUgd2lsbCBiZSBubyBtaXNzaW5nIHBhcnRzIGluIHRoZSBt
ZW1vcnkgbWFwIHdpdGhpbiBhCj4gTUFYX09SREVSX05SX1BBR0VTIHJlZ2lvbi4KCk9rLCB0aGFu
a3MsIHdlIG1ldCBhIHNhbWUgcGFuaWMgbGlrZSB0aGUgbGluayBvbiBhcm0zMih3aXRob3V0IApI
T0xFU19JTl9aT05FKSwKCnRoZSBzY2hlbWUgZm9yIGFybTY0IGNvdWxkIGJlIHN1aXQgZm9yIGFy
bTMyLCByaWdodD/CoCBJIHdpbGwgdHJ5IHRoZSAKcGF0Y2hzZXQgd2l0aAoKc29tZSBjaGFuZ2Vz
IG9uIGFybTMyIGFuZCBnaXZlIHNvbWUgZmVlZGJhY2suCgpBZ2FpbiwgdGhlIHN0dXBpZCBxdWVz
dGlvbiwgd2hlcmUgd2lsbCBtYXJrIHRoZSByZWdpb24gb2YgbWVtYmxvY2sgd2l0aAoKTUVNQkxP
Q0tfTk9NQVAgZmxhZyA/CgoKPiAgIAo+PiAiVGhlIGlkZWEgaXMgdG8gbWFyayBOT01BUCBwYWdl
cyBhcyByZXNlcnZlZCBpbiB0aGUgbWVtb3J5IG1hcCIsIEkgc2VlIHRoZQo+PiBwYXRjaDIgY2hl
Y2sgbWVtYmxvY2tfaXNfbm9tYXAoKSBpbiBtZW1vcnkgcmVnaW9uCj4+IG9mIG1lbWJsb2NrLCBi
dXQgaXQgc2VlbXMgdGhhdCBtZW1ibG9ja19tYXJrX25vbWFwKCkgaXMgbm90IGNhbGxlZChtYXli
ZSBJCj4+IG1pc3NlZCksIHRoZW4gbWVtbWFwX2luaXRfcmVzZXJ2ZWRfcGFnZXMoKSB3b24ndAo+
PiB3b3JrLCBzbyBzaG91bGQgdGhlIEhPTEVTX0lOX1pPTkUgc3RpbGwgYmUgbmVlZGVkIGZvciBn
ZW5lcmljIG1tIGNvZGU/Cj4+Cj4+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1h
cm0ta2VybmVsLzU0MTE5M2E2LTJiY2UtZjA0Mi01YmIyLTg4OTEzZDVmMTA0N0Bhcm0uY29tLwo+
PgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
