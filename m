Return-Path: <SRS0=ELNw=JW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E34C433B4
	for <kvmarm@archiver.kernel.org>; Sun, 25 Apr 2021 07:20:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AA59861210
	for <kvmarm@archiver.kernel.org>; Sun, 25 Apr 2021 07:20:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA59861210
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E6824B52E;
	Sun, 25 Apr 2021 03:20:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CJimwhWrbUhh; Sun, 25 Apr 2021 03:20:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 328A24B430;
	Sun, 25 Apr 2021 03:20:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A13914B200
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Apr 2021 03:20:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w-EWhO413WZ3 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 25 Apr 2021 03:20:05 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 886BD4B2E1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 25 Apr 2021 03:20:05 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34E5261154;
 Sun, 25 Apr 2021 07:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619335204;
 bh=t3uBLdKj3RwD8AUUCKgSTXuCvucTl9G7gRfYDcygyuE=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=kDBJ9u5v83yTj0knDFg6TvMz5f6BIJsd5rsSHucko8FJYyP8hKzwbwbOeAb6OL6Gh
 xuMRIZMu2D7nophxm+LihrlmsW4f48MmVnU5drdb6ipiRoj2CfzFMY4bqVjRwTx+6+
 9B8S/FvKzlV2QmLlv6vwkSb85kMbbQAUg5Ws0vHGlUxYCuu41Y/R1qdnE8VMWYARiB
 eU/aJN90HOkPrlG+urZD6/bIOwPewBRhGwTRmrMmDhrq3YSFL8yzn36gO4laglg+3R
 ZUY8d+WHppFIJYrchBcOIcGak8HLE6382dK4LN+EZDuaW37/HlFcQKcwQ8f7VWdTWT
 TrycNCi498ltA==
Date: Sun, 25 Apr 2021 10:19:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
Message-ID: <YIUYG8N9T3/C/tSG@kernel.org>
References: <20210421065108.1987-1-rppt@kernel.org>
 <9aa68d26-d736-3b75-4828-f148964eb7f0@huawei.com>
 <YIEl8aKr8Ly0Zd3O@kernel.org>
 <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
 <2a1592ad-bc9d-4664-fd19-f7448a37edc0@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2a1592ad-bc9d-4664-fd19-f7448a37edc0@huawei.com>
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
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

T24gRnJpLCBBcHIgMjMsIDIwMjEgYXQgMDQ6MTE6MTZQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3Jv
dGU6Cj4gCj4gSSB0ZXN0ZWQgdGhpcyBwYXRjaHNldChwbHVzIGFybTMyIGNoYW5nZSwgbGlrZSBh
cm02NCBkb2VzKSBiYXNlZCBvbiBsdHMKPiA1LjEw77yMYWRkCj4gCj4gc29tZSBkZWJ1ZyBsb2cs
IHRoZSB1c2VmdWwgaW5mbyBzaG93cyBiZWxvdywgaWYgd2UgZW5hYmxlIEhPTEVTX0lOX1pPTkUs
IG5vCj4gcGFuaWMsCj4gCj4gYW55IGlkZWEsIHRoYW5rcy4KIApBcmUgdGhlcmUgYW55IGNoYW5n
ZXMgb24gdG9wIG9mIDUuMTAgZXhjZXB0IGZvciBwZm5fdmFsaWQoKSBwYXRjaD8KRG8geW91IHNl
ZSB0aGlzIHBhbmljIG9uIDUuMTAgd2l0aG91dCB0aGUgY2hhbmdlcz8KQ2FuIHlvdSBzZWUgc3Rh
Y2sgYmFja3RyYWNlIGJleW9uZCBtb3ZlX2ZyZWVwYWdlc19ibG9jaz8KCj4gWm9uZSByYW5nZXM6
Cj4gwqAgTm9ybWFswqDCoCBbbWVtIDB4MDAwMDAwMDA4MGEwMDAwMC0weDAwMDAwMDAwYjAxZmZm
ZmZdCj4gwqAgSGlnaE1lbcKgIFttZW0gMHgwMDAwMDAwMGIwMjAwMDAwLTB4MDAwMDAwMDBmZmZm
ZWZmZl0KPiBNb3ZhYmxlIHpvbmUgc3RhcnQgZm9yIGVhY2ggbm9kZQo+IEVhcmx5IG1lbW9yeSBu
b2RlIHJhbmdlcwo+IMKgIG5vZGXCoMKgIDA6IFttZW0gMHgwMDAwMDAwMDgwYTAwMDAwLTB4MDAw
MDAwMDA4NTVmZmZmZl0KPiDCoCBub2RlwqDCoCAwOiBbbWVtIDB4MDAwMDAwMDA4NmEwMDAwMC0w
eDAwMDAwMDAwODdkZmZmZmZdCj4gwqAgbm9kZcKgwqAgMDogW21lbSAweDAwMDAwMDAwOGJkMDAw
MDAtMHgwMDAwMDAwMDhjNGZmZmZmXQo+IMKgIG5vZGXCoMKgIDA6IFttZW0gMHgwMDAwMDAwMDhl
MzAwMDAwLTB4MDAwMDAwMDA4ZWNmZmZmZl0KPiDCoCBub2RlwqDCoCAwOiBbbWVtIDB4MDAwMDAw
MDA5MGQwMDAwMC0weDAwMDAwMDAwYmZmZmZmZmZdCj4gwqAgbm9kZcKgwqAgMDogW21lbSAweDAw
MDAwMDAwY2MwMDAwMDAtMHgwMDAwMDAwMGRjOWZmZmZmXQo+IMKgIG5vZGXCoMKgIDA6IFttZW0g
MHgwMDAwMDAwMGRlNzAwMDAwLTB4MDAwMDAwMDBkZTlmZmZmZl0KPiDCoCBub2RlwqDCoCAwOiBb
bWVtIDB4MDAwMDAwMDBlMDgwMDAwMC0weDAwMDAwMDAwZTBiZmZmZmZdCj4gwqAgbm9kZcKgwqAg
MDogW21lbSAweDAwMDAwMDAwZjRiMDAwMDAtMHgwMDAwMDAwMGY2ZmZmZmZmXQo+IMKgIG5vZGXC
oMKgIDA6IFttZW0gMHgwMDAwMDAwMGZkYTAwMDAwLTB4MDAwMDAwMDBmZmZmZWZmZl0KPiAKPiAt
LS0tPiBmcmVlX21lbW1hcCwgc3RhcnRfcGZuID0gODU4MDAswqAgODU4MDAwMDAgZW5kX3BmbiA9
IDg2YTAwLCA4NmEwMDAwMAo+IC0tLS0+IGZyZWVfbWVtbWFwLCBzdGFydF9wZm4gPSA4YzgwMCzC
oCA4YzgwMDAwMCBlbmRfcGZuID0gOGUzMDAsIDhlMzAwMDAwCj4gLS0tLT4gZnJlZV9tZW1tYXAs
IHN0YXJ0X3BmbiA9IDhmMDAwLMKgIDhmMDAwMDAwIGVuZF9wZm4gPSA5MDAwMCwgOTAwMDAwMDAK
PiAtLS0tPiBmcmVlX21lbW1hcCwgc3RhcnRfcGZuID0gZGNjMDAswqAgZGNjMDAwMDAgZW5kX3Bm
biA9IGRlNzAwLCBkZTcwMDAwMAo+IC0tLS0+IGZyZWVfbWVtbWFwLCBzdGFydF9wZm4gPSBkZWMw
MCzCoCBkZWMwMDAwMCBlbmRfcGZuID0gZTAwMDAsIGUwMDAwMDAwCj4gLS0tLT4gZnJlZV9tZW1t
YXAsIHN0YXJ0X3BmbiA9IGUwYzAwLMKgIGUwYzAwMDAwIGVuZF9wZm4gPSBlNDAwMCwgZTQwMDAw
MDAKPiAtLS0tPiBmcmVlX21lbW1hcCwgc3RhcnRfcGZuID0gZjcwMDAswqAgZjcwMDAwMDAgZW5k
X3BmbiA9IGY4MDAwLCBmODAwMDAwMAo+ID09PSA+bW92ZV9mcmVlcGFnZXM6IHN0YXJ0X3Bmbi9l
bmRfcGZuIFtkZTYwMSwgZGU3ZmZdLCBbZGU2MDAwMDAsIGRlN2ZmMDAwXQo+IDrCoCBwZm4gPWRl
NjAwIHBmbjJwaHkgPSBkZTYwMDAwMCAsIHBhZ2UgPSBlZjNjYzAwMCwgcGFnZS1mbGFncyA9IGZm
ZmZmZmZmCj4gODwtLS0gY3V0IGhlcmUgLS0tCj4gVW5hYmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFn
aW5nIHJlcXVlc3QgYXQgdmlydHVhbCBhZGRyZXNzIGZmZmZmZmZlCj4gcGdkID0gNWRkNTBkZjUK
PiBbZmZmZmZmZmVdICpwZ2Q9YWZmZmY4NjEsICpwdGU9MDAwMDAwMDAsICpwcHRlPTAwMDAwMDAw
Cj4gSW50ZXJuYWwgZXJyb3I6IE9vcHM6IDM3IFsjMV0gU01QIEFSTQo+IE1vZHVsZXMgbGlua2Vk
IGluOiBnbWFjKE8pCj4gQ1BVOiAyIFBJRDogNjM1IENvbW06IHRlc3Qtb29tIFRhaW50ZWQ6IEfC
oMKgwqDCoMKgwqDCoMKgwqDCoCBPwqDCoMKgwqDCoCA1LjEwLjArICMzMQo+IEhhcmR3YXJlIG5h
bWU6IEhpc2lsaWNvbiBBOQo+IFBDIGlzIGF0IG1vdmVfZnJlZXBhZ2VzX2Jsb2NrKzB4MTUwLzB4
Mjc4Cj4gTFIgaXMgYXQgbW92ZV9mcmVlcGFnZXNfYmxvY2srMHgxNTAvMHgyNzgKPiBwYyA6IFs8
YzAyMzgzYTQ+XcKgwqDCoCBsciA6IFs8YzAyMzgzYTQ+XcKgwqDCoCBwc3I6IDIwMGUwMzkzCj4g
c3AgOiBjNDE3OWNmOMKgIGlwIDogMDAwMDAwMDDCoCBmcCA6IDAwMDAwMDAxCj4gcjEwOiBjNDE3
OWQ1OMKgIHI5IDogMDAwZGU3ZmbCoCByOCA6IDAwMDAwMDAwCj4gcjcgOiBjMDg2MzI4MMKgIHI2
IDogMDAwZGU2MDDCoCByNSA6IDAwMGRlNjAwwqAgcjQgOiBlZjNjYzAwMAo+IHIzIDogZmZmZmZm
ZmbCoCByMiA6IDAwMDAwMDAwwqAgcjEgOiBlZjVkMDY5Y8KgIHIwIDogZmZmZmZmZmUKPiBGbGFn
czogbnpDdsKgIElSUXMgb2ZmwqAgRklRcyBvbsKgIE1vZGUgU1ZDXzMywqAgSVNBIEFSTcKgIFNl
Z21lbnQgdXNlcgo+IENvbnRyb2w6IDFhYzUzODdkwqAgVGFibGU6IDgzYjBjMDRhwqAgREFDOiA1
NTU1NTU1NQo+IFByb2Nlc3MgdGVzdC1vb20gKHBpZDogNjM1LCBzdGFjayBsaW1pdCA9IDB4MjVk
NjY3ZGYpCj4gCgotLSAKU2luY2VyZWx5IHlvdXJzLApNaWtlLgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1h
bi9saXN0aW5mby9rdm1hcm0K
