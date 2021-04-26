Return-Path: <SRS0=roT/=JX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03CEC433B4
	for <kvmarm@archiver.kernel.org>; Mon, 26 Apr 2021 05:20:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2EE8461176
	for <kvmarm@archiver.kernel.org>; Mon, 26 Apr 2021 05:20:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2EE8461176
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A67A24B2D1;
	Mon, 26 Apr 2021 01:20:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 43M4Kx6B8JN8; Mon, 26 Apr 2021 01:20:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 563204B2BF;
	Mon, 26 Apr 2021 01:20:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 771034B2B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 01:20:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bNa5ByEtHZCQ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Apr 2021 01:20:53 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B40A4B183
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Apr 2021 01:20:53 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5D746008E;
 Mon, 26 Apr 2021 05:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619414451;
 bh=685vzft1UpPTZWzP/wT5CXw7b1mT0zK3efSf8y1p2WA=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=I6Slv6qlya+xpQVA06BiWCjMjBS8rZUtrjr7pbsxHgtXEcKOwLJZvDxsBIndbJOHD
 suxJ4+7M60Cf7bCUNYKBY5gECQOMzcRfMIDdIe90Z4nWliQCdjqlFKwOsBdK85ZilE
 3anSC2AQi13U9mf0NhVeuh0c4bgk1XfcBOL0Z9DEE853hO3ymv1luCV2piBg0DOyLi
 ml/yx1n/REGPPJcTTCLZ8EfI5XTfsEr3LIkbSj60jGy2JDzGNHhwIEe/2QeGPvWHF0
 +2nioLe6KnheTG2nIN0zGZf8qN5klKL2O2T6/GnJlPzPQ+EuMM8alUKiKoXqrasaF8
 Qpgn2sWQHxDQg==
Date: Mon, 26 Apr 2021 08:20:43 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: arm32: panic in move_freepages (Was [PATCH v2 0/4] arm64: drop
 pfn_valid_within() and simplify pfn_valid())
Message-ID: <YIZNq5HMfJ1rWytv@kernel.org>
References: <20210421065108.1987-1-rppt@kernel.org>
 <9aa68d26-d736-3b75-4828-f148964eb7f0@huawei.com>
 <YIEl8aKr8Ly0Zd3O@kernel.org>
 <33fa74c2-f32d-f224-eb30-acdb717179ff@huawei.com>
 <2a1592ad-bc9d-4664-fd19-f7448a37edc0@huawei.com>
 <YIUYG8N9T3/C/tSG@kernel.org>
 <52f7d03b-7219-46bc-c62d-b976bc31ebd5@huawei.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52f7d03b-7219-46bc-c62d-b976bc31ebd5@huawei.com>
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

T24gU3VuLCBBcHIgMjUsIDIwMjEgYXQgMDM6NTE6NTZQTSArMDgwMCwgS2VmZW5nIFdhbmcgd3Jv
dGU6Cj4gCj4gT24gMjAyMS80LzI1IDE1OjE5LCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+IAo+ICAg
ICBPbiBGcmksIEFwciAyMywgMjAyMSBhdCAwNDoxMToxNlBNICswODAwLCBLZWZlbmcgV2FuZyB3
cm90ZToKPiAKPiAgICAgICAgIEkgdGVzdGVkIHRoaXMgcGF0Y2hzZXQocGx1cyBhcm0zMiBjaGFu
Z2UsIGxpa2UgYXJtNjQgZG9lcykgYmFzZWQgb24gbHRzCj4gICAgICAgICA1LjEw77yMYWRkCj4g
Cj4gICAgICAgICBzb21lIGRlYnVnIGxvZywgdGhlIHVzZWZ1bCBpbmZvIHNob3dzIGJlbG93LCBp
ZiB3ZSBlbmFibGUgSE9MRVNfSU5fWk9ORSwgbm8KPiAgICAgICAgIHBhbmljLAo+IAo+ICAgICAg
ICAgYW55IGlkZWEsIHRoYW5rcy4KPiAKPiAKPiAgICAgQXJlIHRoZXJlIGFueSBjaGFuZ2VzIG9u
IHRvcCBvZiA1LjEwIGV4Y2VwdCBmb3IgcGZuX3ZhbGlkKCkgcGF0Y2g/Cj4gICAgIERvIHlvdSBz
ZWUgdGhpcyBwYW5pYyBvbiA1LjEwIHdpdGhvdXQgdGhlIGNoYW5nZXM/Cj4gCj4gWWVzLCB0aGVy
ZSBhcmUgc29tZSBCU1Agc3VwcG9ydCBmb3IgYXJtIGJvYXJkIGJhc2VkIG9uIDUuMTAsIHdpdGgg
b3Igd2l0aG91dAo+IAo+IHlvdXIgcGF0Y2ggd2lsbCBnZXQgc2FtZSBwYW5pYywgdGhlIHBhbmlj
IHBmbj1kZTYwMCBpbiB0aGUgcmFuZ2Ugb2YKPiBbZGNjMDAsZGUwMF0KPiAKPiB3aGljaCBpcyBm
cmVlZCBieSBmcmVlX21lbW1hcCwgc3RhcnRfcGZuID0gZGNjMDAswqAgZGNjMDAwMDAgZW5kX3Bm
biA9IGRlNzAwLAo+IGRlNzAwMDAwCj4gCj4gd2Ugc2VlIHRoZSBQQyBpcyBhdCBQYWdlTFJVLCBz
YW1lIHJlYXNvbiBsaWtlIGFybTY0IHBhbmljIGxvZywKPiAKPiAgICAiUGFnZUJ1ZGR5IGluIG1v
dmVfZnJlZXBhZ2VzIHJldHVybnMgZmFsc2UKPiAgICAgVGhlbiB3ZSBjYWxsIFBhZ2VMUlUsIHRo
ZSBtYWNybyBjYWxscyBQRl9IRUFEIHdoaWNoIGlzIGNvbXBvdW5kX3BhZ2UoKQo+ICAgICBjb21w
b3VuZF9wYWdlIHJlYWRzIHBhZ2UtPmNvbXBvdW5kX2hlYWQsIGl0IGlzIDB4ZmZmZmZmZmZmZmZm
ZmZmZiwgc28gaXQKPiAgICAgcmVzdHVybnMgMHhmZmZmZmZmZmZmZmZmZmZlIC0gYW5kIGFjY2Vz
c2luZyB0aGlzIGFkZHJlc3MgY2F1c2VzIGNyYXNoIgo+IAo+ICAgICBDYW4geW91IHNlZSBzdGFj
ayBiYWNrdHJhY2UgYmV5b25kIG1vdmVfZnJlZXBhZ2VzX2Jsb2NrPwo+IAo+IEkgZG8gc29tZSBv
b20gdGVzdCwgc28gdGhlIGxvZyBpcyBhYm91dCBtZW1vcnkgYWxsb2NhdGUsCj4gCj4gWzxjMDIz
ODNjOD5dIChtb3ZlX2ZyZWVwYWdlc19ibG9jaykgZnJvbSBbPGMwMjM4NjY4Pl0KPiAoc3RlYWxf
c3VpdGFibGVfZmFsbGJhY2srMHgxNzQvMHgxZjQpCj4gCj4gWzxjMDIzODY2OD5dIChzdGVhbF9z
dWl0YWJsZV9mYWxsYmFjaykgZnJvbSBbPGMwMjM5OTljPl0gKGdldF9wYWdlX2Zyb21fZnJlZWxp
c3QrMHg0OTAvMHg5YTQpCgpIbW0sIHRoaXMgaXMgY2FsbGVkIHdpdGggYSBwYWdlIGZyb20gZnJl
ZSBsaXN0LCBoYXZpbmcgYSBwYWdlIGZyb20gYSBmcmVlZApwYXJ0IG9mIHRoZSBtZW1vcnkgbWFw
IHBhc3NlZCB0byBzdGVhbF9zdWl0YWJsZV9mYWxsYmFjaygpIG1lYW5zIHRoYXQgdGhlcmUKaXMg
YW4gaXNzdWUgd2l0aCBjcmVhdGlvbiBvZiB0aGUgZnJlZSBsaXN0LgoKQ2FuIHlvdSBwbGVhc2Ug
YWRkICJtZW1ibG9jaz1kZWJ1ZyIgdG8gdGhlIGtlcm5lbCBjb21tYW5kIGxpbmUgYW5kIHBvc3Qg
dGhlCmxvZz8KCj4gWzxjMDIzOTk5Yz5dIChnZXRfcGFnZV9mcm9tX2ZyZWVsaXN0KSBmcm9tIFs8
YzAyM2E0ZGM+XSAoX19hbGxvY19wYWdlc19ub2RlbWFzaysweDE4OC8weGMwOCkKPiBbPGMwMjNh
NGRjPl0gKF9fYWxsb2NfcGFnZXNfbm9kZW1hc2spIGZyb20gWzxjMDIyMzA3OD5dIChhbGxvY196
ZXJvZWRfdXNlcl9oaWdocGFnZV9tb3ZhYmxlKzB4MTQvMHgzYykKPiBbPGMwMjIzMDc4Pl0gKGFs
bG9jX3plcm9lZF91c2VyX2hpZ2hwYWdlX21vdmFibGUpIGZyb20gWzxjMDIyNjc2OD5dIChoYW5k
bGVfbW1fZmF1bHQrMHgyNTQvMHhhYzgpCj4gWzxjMDIyNjc2OD5dIChoYW5kbGVfbW1fZmF1bHQp
IGZyb20gWzxjMDRiYTA5Yz5dIChkb19wYWdlX2ZhdWx0KzB4MjI4LzB4MmY0KQo+IFs8YzA0YmEw
OWM+XSAoZG9fcGFnZV9mYXVsdCkgZnJvbSBbPGMwMTExZDgwPl0gKGRvX0RhdGFBYm9ydCsweDQ4
LzB4ZDApCj4gWzxjMDExMWQ4MD5dIChkb19EYXRhQWJvcnQpIGZyb20gWzxjMDEwMGUwMD5dIChf
X2RhYnRfdXNyKzB4NDAvMHg2MCkKPiAKPiAKPiAKPiAgICAgICAgIFpvbmUgcmFuZ2VzOgo+ICAg
ICAgICAgwqAgTm9ybWFswqDCoCBbbWVtIDB4MDAwMDAwMDA4MGEwMDAwMC0weDAwMDAwMDAwYjAx
ZmZmZmZdCj4gICAgICAgICDCoCBIaWdoTWVtwqAgW21lbSAweDAwMDAwMDAwYjAyMDAwMDAtMHgw
MDAwMDAwMGZmZmZlZmZmXQo+ICAgICAgICAgTW92YWJsZSB6b25lIHN0YXJ0IGZvciBlYWNoIG5v
ZGUKPiAgICAgICAgIEVhcmx5IG1lbW9yeSBub2RlIHJhbmdlcwo+ICAgICAgICAgwqAgbm9kZcKg
wqAgMDogW21lbSAweDAwMDAwMDAwODBhMDAwMDAtMHgwMDAwMDAwMDg1NWZmZmZmXQo+ICAgICAg
ICAgwqAgbm9kZcKgwqAgMDogW21lbSAweDAwMDAwMDAwODZhMDAwMDAtMHgwMDAwMDAwMDg3ZGZm
ZmZmXQo+ICAgICAgICAgwqAgbm9kZcKgwqAgMDogW21lbSAweDAwMDAwMDAwOGJkMDAwMDAtMHgw
MDAwMDAwMDhjNGZmZmZmXQo+ICAgICAgICAgwqAgbm9kZcKgwqAgMDogW21lbSAweDAwMDAwMDAw
OGUzMDAwMDAtMHgwMDAwMDAwMDhlY2ZmZmZmXQo+ICAgICAgICAgwqAgbm9kZcKgwqAgMDogW21l
bSAweDAwMDAwMDAwOTBkMDAwMDAtMHgwMDAwMDAwMGJmZmZmZmZmXQo+ICAgICAgICAgwqAgbm9k
ZcKgwqAgMDogW21lbSAweDAwMDAwMDAwY2MwMDAwMDAtMHgwMDAwMDAwMGRjOWZmZmZmXQo+ICAg
ICAgICAgwqAgbm9kZcKgwqAgMDogW21lbSAweDAwMDAwMDAwZGU3MDAwMDAtMHgwMDAwMDAwMGRl
OWZmZmZmXQo+ICAgICAgICAgwqAgbm9kZcKgwqAgMDogW21lbSAweDAwMDAwMDAwZTA4MDAwMDAt
MHgwMDAwMDAwMGUwYmZmZmZmXQo+ICAgICAgICAgwqAgbm9kZcKgwqAgMDogW21lbSAweDAwMDAw
MDAwZjRiMDAwMDAtMHgwMDAwMDAwMGY2ZmZmZmZmXQo+ICAgICAgICAgwqAgbm9kZcKgwqAgMDog
W21lbSAweDAwMDAwMDAwZmRhMDAwMDAtMHgwMDAwMDAwMGZmZmZlZmZmXQo+IAo+ICAgICAgICAg
LS0tLT4gZnJlZV9tZW1tYXAsIHN0YXJ0X3BmbiA9IDg1ODAwLMKgIDg1ODAwMDAwIGVuZF9wZm4g
PSA4NmEwMCwgODZhMDAwMDAKPiAgICAgICAgIC0tLS0+IGZyZWVfbWVtbWFwLCBzdGFydF9wZm4g
PSA4YzgwMCzCoCA4YzgwMDAwMCBlbmRfcGZuID0gOGUzMDAsIDhlMzAwMDAwCj4gICAgICAgICAt
LS0tPiBmcmVlX21lbW1hcCwgc3RhcnRfcGZuID0gOGYwMDAswqAgOGYwMDAwMDAgZW5kX3BmbiA9
IDkwMDAwLCA5MDAwMDAwMAo+ICAgICAgICAgLS0tLT4gZnJlZV9tZW1tYXAsIHN0YXJ0X3BmbiA9
IGRjYzAwLMKgIGRjYzAwMDAwIGVuZF9wZm4gPSBkZTcwMCwgZGU3MDAwMDAKPiAgICAgICAgIC0t
LS0+IGZyZWVfbWVtbWFwLCBzdGFydF9wZm4gPSBkZWMwMCzCoCBkZWMwMDAwMCBlbmRfcGZuID0g
ZTAwMDAsIGUwMDAwMDAwCj4gICAgICAgICAtLS0tPiBmcmVlX21lbW1hcCwgc3RhcnRfcGZuID0g
ZTBjMDAswqAgZTBjMDAwMDAgZW5kX3BmbiA9IGU0MDAwLCBlNDAwMDAwMAo+ICAgICAgICAgLS0t
LT4gZnJlZV9tZW1tYXAsIHN0YXJ0X3BmbiA9IGY3MDAwLMKgIGY3MDAwMDAwIGVuZF9wZm4gPSBm
ODAwMCwgZjgwMDAwMDAKPiAgICAgICAgID09PSA+bW92ZV9mcmVlcGFnZXM6IHN0YXJ0X3Bmbi9l
bmRfcGZuIFtkZTYwMSwgZGU3ZmZdLCBbZGU2MDAwMDAsIGRlN2ZmMDAwXQo+ICAgICAgICAgOsKg
IHBmbiA9ZGU2MDAgcGZuMnBoeSA9IGRlNjAwMDAwICwgcGFnZSA9IGVmM2NjMDAwLCBwYWdlLWZs
YWdzID0gZmZmZmZmZmYKPiAgICAgICAgIDg8LS0tIGN1dCBoZXJlIC0tLQo+ICAgICAgICAgVW5h
YmxlIHRvIGhhbmRsZSBrZXJuZWwgcGFnaW5nIHJlcXVlc3QgYXQgdmlydHVhbCBhZGRyZXNzIGZm
ZmZmZmZlCj4gICAgICAgICBwZ2QgPSA1ZGQ1MGRmNQo+ICAgICAgICAgW2ZmZmZmZmZlXSAqcGdk
PWFmZmZmODYxLCAqcHRlPTAwMDAwMDAwLCAqcHB0ZT0wMDAwMDAwMAo+ICAgICAgICAgSW50ZXJu
YWwgZXJyb3I6IE9vcHM6IDM3IFsjMV0gU01QIEFSTQo+ICAgICAgICAgTW9kdWxlcyBsaW5rZWQg
aW46IGdtYWMoTykKPiAgICAgICAgIENQVTogMiBQSUQ6IDYzNSBDb21tOiB0ZXN0LW9vbSBUYWlu
dGVkOiBHwqDCoMKgwqDCoMKgwqDCoMKgwqAgT8KgwqDCoMKgwqAgNS4xMC4wKyAjMzEKPiAgICAg
ICAgIEhhcmR3YXJlIG5hbWU6IEhpc2lsaWNvbiBBOQo+ICAgICAgICAgUEMgaXMgYXQgbW92ZV9m
cmVlcGFnZXNfYmxvY2srMHgxNTAvMHgyNzgKPiAgICAgICAgIExSIGlzIGF0IG1vdmVfZnJlZXBh
Z2VzX2Jsb2NrKzB4MTUwLzB4Mjc4Cj4gICAgICAgICBwYyA6IFs8YzAyMzgzYTQ+XcKgwqDCoCBs
ciA6IFs8YzAyMzgzYTQ+XcKgwqDCoCBwc3I6IDIwMGUwMzkzCj4gICAgICAgICBzcCA6IGM0MTc5
Y2Y4wqAgaXAgOiAwMDAwMDAwMMKgIGZwIDogMDAwMDAwMDEKPiAgICAgICAgIHIxMDogYzQxNzlk
NTjCoCByOSA6IDAwMGRlN2ZmwqAgcjggOiAwMDAwMDAwMAo+ICAgICAgICAgcjcgOiBjMDg2MzI4
MMKgIHI2IDogMDAwZGU2MDDCoCByNSA6IDAwMGRlNjAwwqAgcjQgOiBlZjNjYzAwMAo+ICAgICAg
ICAgcjMgOiBmZmZmZmZmZsKgIHIyIDogMDAwMDAwMDDCoCByMSA6IGVmNWQwNjljwqAgcjAgOiBm
ZmZmZmZmZQo+ICAgICAgICAgRmxhZ3M6IG56Q3bCoCBJUlFzIG9mZsKgIEZJUXMgb27CoCBNb2Rl
IFNWQ18zMsKgIElTQSBBUk3CoCBTZWdtZW50IHVzZXIKPiAgICAgICAgIENvbnRyb2w6IDFhYzUz
ODdkwqAgVGFibGU6IDgzYjBjMDRhwqAgREFDOiA1NTU1NTU1NQo+ICAgICAgICAgUHJvY2VzcyB0
ZXN0LW9vbSAocGlkOiA2MzUsIHN0YWNrIGxpbWl0ID0gMHgyNWQ2NjdkZikKPiAKPiAKCi0tIApT
aW5jZXJlbHkgeW91cnMsCk1pa2UuCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
