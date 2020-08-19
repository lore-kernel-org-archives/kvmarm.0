Return-Path: <SRS0=sZMl=B5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07295C433E1
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 08:54:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 88AD6207BB
	for <kvmarm@archiver.kernel.org>; Wed, 19 Aug 2020 08:54:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88AD6207BB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1EC4B98D;
	Wed, 19 Aug 2020 04:54:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vTfum5NOnE2H; Wed, 19 Aug 2020 04:54:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E55E4B97D;
	Wed, 19 Aug 2020 04:54:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44BB84B96C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 04:54:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EgN9lAMpQZzc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Aug 2020 04:54:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA35D4B963
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Aug 2020 04:54:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30EB231B;
 Wed, 19 Aug 2020 01:54:47 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C32DD3F6CF;
 Wed, 19 Aug 2020 01:54:45 -0700 (PDT)
Subject: Re: [RFC PATCH 0/5] KVM: arm64: Add pvtime LPT support
To: Marc Zyngier <maz@kernel.org>, Keqian Zhu <zhukeqian1@huawei.com>
References: <20200817084110.2672-1-zhukeqian1@huawei.com>
 <8308f52e4c906cad710575724f9e3855@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <f14cfd5b-c103-5d56-82fb-59d0371c6f21@arm.com>
Date: Wed, 19 Aug 2020 09:54:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8308f52e4c906cad710575724f9e3855@kernel.org>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

T24gMTgvMDgvMjAyMCAxNTo0MSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjAtMDgtMTcg
MDk6NDEsIEtlcWlhbiBaaHUgd3JvdGU6Cj4+IEhpIGFsbCwKPj4KPj4gVGhpcyBwYXRjaCBzZXJp
ZXMgcGlja3MgdXAgdGhlIExQVCBwdnRpbWUgZmVhdHVyZSBvcmlnaW5hbGx5IGRldmVsb3BlZAo+
PiBieSBTdGV2ZW4gUHJpY2U6IGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvY292ZXIvMTA3
MjY0OTkvCj4+Cj4+IEJhY2tncm91ZDoKPj4KPj4gVGhlcmUgaXMgZGVtYW5kIGZvciBjcm9zcy1w
bGF0Zm9ybSBtaWdyYXRpb24sIHdoaWNoIG1lYW5zIHdlIGhhdmUgdG8KPj4gc29sdmUgZGlmZmVy
ZW50IENQVSBmZWF0dXJlcyBhbmQgYXJjaCBjb3VudGVyIGZyZXF1ZW5jeSBiZXR3ZWVuIGhvc3Rz
Lgo+PiBUaGlzIHBhdGNoIHNlcmllcyBjYW4gc29sdmUgdGhlIGxhdHRlciBwcm9ibGVtLgo+Pgo+
PiBBYm91dCBMUFQ6Cj4+Cj4+IFRoaXMgaW1wbGVtZW50cyBzdXBwb3J0IGZvciBMaXZlIFBoeXNp
Y2FsIFRpbWUgKExQVCkgd2hpY2ggcHJvdmlkZXMgdGhlCj4+IGd1ZXN0IHdpdGggYSBtZXRob2Qg
dG8gZGVyaXZlIGEgc3RhYmxlIGNvdW50ZXIgb2YgdGltZSBkdXJpbmcgd2hpY2ggdGhlCj4+IGd1
ZXN0IGlzIGV4ZWN1dGluZyBldmVuIHdoZW4gdGhlIGd1ZXN0IGlzIGJlaW5nIG1pZ3JhdGVkIGJl
dHdlZW4gaG9zdHMKPj4gd2l0aCBkaWZmZXJlbnQgcGh5c2ljYWwgY291bnRlciBmcmVxdWVuY2ll
cy4KPj4KPj4gQ2hhbmdlcyBvbiBTdGV2ZW4gUHJpY2UncyB3b3JrOgo+PiAxLiBMUFQgc3RydWN0
dXJlOiB1c2Ugc3ltbWF0aWNhbCBzZW1hbnRpY3Mgb2Ygc2NhbGUgbXVsdGlwbGllciwgYW5kIHVz
ZQo+PiDCoMKgIGZyYWN0aW9uIGJpdHMgaW5zdGVhZCBvZiAic2hpZnQiIHRvIG1ha2UgZXZlcnl0
aGluZyBjbGVhci4KPj4gMi4gU3RydWN0dXJlIGFsbG9jYXRpb246IGhvc3Qga2VybmVsIGRvZXMg
bm90IGFsbG9jYXRlcyB0aGUgTFBUIAo+PiBzdHJ1Y3R1cmUsCj4+IMKgwqAgaW5zdGVhZCBpdCBp
cyBhbGxvY2F0ZWQgYnkgdXNlcnNwYWNlIHRocm91Z2ggVk0gYXR0cmlidXRlcy4gVGhlIAo+PiBz
YXZlL3Jlc3RvcmUKPj4gwqDCoCBmdW5jdGlvbmFsaXR5IGNhbiBiZSByZW1vdmVkLgo+PiAzLiBT
aW5jZSBMUFQgc3RydWN0dXJlIGp1c3QgbmVlZCB1cGRhdGUgb25jZSBmb3IgZWFjaCBndWVzdCBy
dW4sIGFkZCBhIAo+PiBmbGFnIHRvCj4+IMKgwqAgaW5kaWNhdGUgdGhlIHVwZGF0ZSBzdGF0dXMu
IFRoaXMgaGFzIHR3byBiZW5pZml0czogMSkgYXZvaWQgCj4+IG11bHRpcGxlIHVwZGF0ZQo+PiDC
oMKgIGJ5IGVhY2ggdkNQVXMuIDIpIElmIHRoZSB1cGRhdGUgZmxhZyBpcyBub3Qgc2V0LCB0aGVu
IHJldHVybiBOT1QgCj4+IFNVUFBPUlQgZm9yCj4+IMKgwqAgY29yZXNzcG9uZGluZyBndWVzdCBI
VkMgY2FsbC4KPj4gNC4gQWRkIFZNIGRldmljZSBhdHRyaWJ1dGVzIGludGVyZmFjZSBmb3IgdXNl
cnNwYWNlIGNvbmZpZ3VyYXRpb24uCj4+IDUuIEFkZCBhIGJhc2UgTFBUIHJlYWQvd3JpdGUgbGF5
ZXIgdG8gcmVkdWNlIGNvZGUuCj4+IDYuIFN1cHBvcnQgcHRpbWVyIHNjYWxpbmcuCj4+IDcuIFN1
cHBvcnQgdGltZXIgZXZlbnQgc3RyZWFtIHRyYW5zbGF0aW9uLgo+Pgo+PiBUaGluZ3MgbmVlZCBj
b25jZXJuOgo+PiAxLiBodHRwczovL2RldmVsb3Blci5hcm0uY29tL2RvY3MvZGVuMDA1Ny9hIG5l
ZWRzIHVwZGF0ZS4KPiAKPiBMUFQgd2FzIGV4cGxpY2l0bHkgcmVtb3ZlZCBmcm9tIHRoZSBzcGVj
IGJlY2F1c2UgaXQgZG9lc24ndCByZWFsbHkKPiBzb2x2ZSB0aGUgcHJvYmxlbSwgc3BlY2lhbGx5
IGZvciB0aGUgZmlybXdhcmU6IEVGSSBrbm93cwo+IG5vdGhpbmcgYWJvdXQgdGhpcywgZm9yIGV4
YW1wbGUuIEhvdyBpcyBpdCBnb2luZyB0byB3b3JrPwo+IEFsc28sIG5vYm9keSB3YXMgZXZlciBh
YmxlIHRvIGV4cGxhaW4gaG93IHRoaXMgd291bGQgd29yayBmb3IKPiBuZXN0ZWQgdmlydC4KPiAK
PiBBUk12OC40IGFuZCBBUk12OC42IGhhdmUgdGhlIGZlYXR1cmUgc2V0IHRoYXQgaXMgcmVxdWly
ZWQgdG8gc29sdmUKPiB0aGlzIHByb2JsZW0gd2l0aG91dCBhZGRpbmcgbW9yZSBQViB0byB0aGUg
a2VybmVsLgoKSGkgTWFyYywKClRoZXNlIGFyZSBnb29kIHBvaW50cywgaG93ZXZlciB3ZSBkbyBz
dGlsbCBoYXZlIHRoZSBzaXR1YXRpb24gdGhhdCBDUFVzIAp0aGF0IGRvbid0IGhhdmUgQVJNdjgu
NC84LjYgY2xlYXJseSBjYW5ub3QgaW1wbGVtZW50IHRoaXMuIEkgcHJlc3VtZSB0aGUgCnVzZS1j
YXNlIEtlcWlhbiBpcyBsb29raW5nIGF0IHByZWRhdGVzIHRoZSBuZWNlc3Nhcnkgc3VwcG9ydCBp
biB0aGUgQ1BVIAotIEtlcWlhbiBpZiB5b3UgY2FuIHByb3ZpZGUgbW9yZSBkZXRhaWxzIG9uIHRo
ZSBhcmNoaXRlY3R1cmUocykgaW52b2x2ZWQgCnRoYXQgd291bGQgYmUgaGVscGZ1bC4KCk5lc3Rl
ZCB2aXJ0IGlzIGluZGVlZCBtb3JlIG9mIGFuIGlzc3VlIC0gd2UgZGlkIGhhdmUgc29tZSBpZGVh
cyBhcm91bmQgCnVzaW5nIFNERUkgdGhhdCBuZXZlciBtYWRlIGl0IHRvIHRoZSBzcGVjLiBIb3dl
dmVyIEkgd291bGQgYXJndWUgdGhhdCAKdGhlIG1vc3QgcHJhZ21hdGljIGFwcHJvYWNoIHdvdWxk
IGJlIHRvIG5vdCBzdXBwb3J0IHRoZSBjb21iaW5hdGlvbiBvZiAKbmVzdGVkIHZpcnQgYW5kIExQ
VC4gSG9wZWZ1bGx5IHRoYXQgY2FuIHdhaXQgdW50aWwgdGhlIGNvdW50ZXIgc2NhbGluZyAKc3Vw
cG9ydCBpcyBhdmFpbGFibGUgYW5kIG5vdCByZXF1aXJlIFBWLgoKV2UgYXJlIGRpc2N1c3Npbmcg
KHJlLSlyZWxlYXNpbmcgdGhlIHNwZWMgd2l0aCB0aGUgTFBUIHBhcnRzIGFkZGVkLiBJZiAKeW91
IGhhdmUgZnVuZGFtZW50YWwgb2JqZWN0aW9ucyB0aGVuIHBsZWFzZSBtZSBrbm93LgoKVGhhbmtz
LAoKU3RldmUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
