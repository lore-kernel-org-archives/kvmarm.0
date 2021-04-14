Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A173C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 08:50:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 888A561153
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 08:50:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 888A561153
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3B614B685;
	Wed, 14 Apr 2021 04:50:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VSzljCjzaSPQ; Wed, 14 Apr 2021 04:50:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DA7734B682;
	Wed, 14 Apr 2021 04:50:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFBFB4B673
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 04:50:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i+4GDJbBSAr6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 04:50:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 749B04B482
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 04:50:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13B20113E;
 Wed, 14 Apr 2021 01:50:49 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AE153F73B;
 Wed, 14 Apr 2021 01:50:48 -0700 (PDT)
Date: Wed, 14 Apr 2021 09:50:28 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: =?UTF-8?B?6IOk5qGmIOmZiA==?= <yinhua_chen@outlook.com>
Subject: Re: KVM/ARM64: Booting KVM on FVP/fastmodels
Message-ID: <20210414095028.0bb75aaa@slackpad.fritz.box>
In-Reply-To: <OS0PR01MB54283E4CF20EF0D2E423E366814E9@OS0PR01MB5428.jpnprd01.prod.outlook.com>
References: <OSYPR01MB54317CECC49E872ACFD9D84B817E9@OSYPR01MB5431.jpnprd01.prod.outlook.com>
 <0bbea123-7bea-3a2e-70ae-30f43df3000e@arm.com>
 <OS0PR01MB54283E4CF20EF0D2E423E366814E9@OS0PR01MB5428.jpnprd01.prod.outlook.com>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
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

T24gV2VkLCAxNCBBcHIgMjAyMSAwMjozNzowNyArMDAwMArog6TmoaYg6ZmIIDx5aW5odWFfY2hl
bkBvdXRsb29rLmNvbT4gd3JvdGU6Cgo+IEhpLCBBbmRyZQo+IAo+IERvIHlvdSBtZWFuIHRoYXQg
aWYgSSBib290IExpbnV4IG9uIEZWUCwgdGhlbiBJIGNhbiBydW4gS1ZNIG9uIEZWUD8gU2luY2Ug
S1ZNIGlzIGp1c3QgYSBtb2R1bGUgaW4gTGludXg/CgpXZWxsLCBvbiBBUk0gaXQncyBub3QgYSBr
ZXJuZWwgbW9kdWxlLCBidXQgYnVpbHQtaW4gdG8gdGhlIGtlcm5lbAppbWFnZSwgYnV0IHllczog
WW91IGNhbiBydW4gYW55IG5vcm1hbCBLVk0gZW5hYmxlZCBrZXJuZWwgb24KaXQuIFNvIGp1c3Qg
dXNlIHRoZSBzYW1lIHJlY2lwZSB5b3Ugd291bGQgdXNlIG9uIGFueSBvdGhlciBzeXN0ZW0gdG8K
cnVuIEtWTSBndWVzdHMuCgpDaGVlcnMsCkFuZHJlCiAKPiBfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwo+IEZyb206IEFuZHLDqSBQcnp5d2FyYSA8YW5kcmUucHJ6eXdhcmFAYXJtLmNv
bT4KPiBTZW50OiBUdWVzZGF5LCBNYXJjaCAzMCwgMjAyMSAxODoyMgo+IFRvOiB5aW5odWFfY2hl
bkBvdXRsb29rLmNvbSA8eWluaHVhX2NoZW5Ab3V0bG9vay5jb20+OyBrdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1IDxrdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Pgo+IFN1YmplY3Q6IFJl
OiBLVk0vQVJNNjQ6IEJvb3RpbmcgS1ZNIG9uIEZWUC9mYXN0bW9kZWxzCj4gCj4gT24gMjkvMDMv
MjAyMSAxMzoxMywgeWluaHVhX2NoZW5Ab3V0bG9vay5jb20gd3JvdGU6Cj4gCj4gSGksCj4gCj4g
PiBJIHdhbnQgdG8gYm9vdCBLVk0gb24gc2ltdWxhdG9ycy4KPiA+Cj4gPiBJIGRvbid0IHdhbnQg
dG8gdXNlIFFFTVUgc2luY2Ugc29tZSBmZWF0dXJlcyBhcmUgb25seSBzdXBwb3J0ZWQgb24KPiA+
IEZWUC9mYXN0bW9kZWxzIG5vdy4KPiA+Cj4gPiBIb3dldmVyLCBJIGNhbm5vdCBmaW5kIGRvY3Vt
ZW50cy9ibG9ncy93aWtpIGFib3V0IGJvb3RpbmcgS1ZNIG9uCj4gPiBGVlAvZmFzdG1vZGVscy4K
PiA+Cj4gPiBEb2VzIEtWTSBzdXBwb3J0IHJ1bm5pbmcgb24gRlZQPyAgCj4gCj4gVGhlIEZWUCBl
bXVsYXRlcyB0aGUgZnVsbCBhcmNoaXRlY3R1cmUsIGluY2x1ZGluZyBhbGwgZXhjZXB0aW9uIGxl
dmVscwo+IChzbyBhbHNvIEVMMiksIGFuZCB0aGUgdmlydHVhbGl6YXRpb24gc3VwcG9ydCBvZiB0
aGUgR0lDIGFuZCB0aGUgR2VuZXJpYwo+IFRpbWVyLgo+IFNvIHllcywgdGhlIG1vZGVscyBmdWxs
eSBzdXBwb3J0IEtWTSAob3IgYW55IG90aGVyIGh5cGVydmlzb3IsIGZvciB0aGF0Cj4gbWF0dGVy
KSwgYW5kIGFyZSBpbiBmYWN0IG9mdGVuIHVzZWQgZm9yIGRldmVsb3BpbmcgS1ZNIHN1cHBvcnQg
b2YgbmV3Cj4gaGFyZHdhcmUgZmVhdHVyZXMuCj4gCj4gU28gd2hhdCBhcmUgdGhlIHByb2JsZW1z
IHRoYXQgeW91IGFyZSBmYWNpbmc/IEp1c3QgcnVubmluZyBhIGtlcm5lbCBsaWtlCj4geW91IHdv
dWxkIG5vcm1hbGx5IGRvIG9uIHRoZSBtb2RlbCBzaG91bGQgd29yayBvdXQgb2YgdGhlIGJveC4K
PiBJZiB5b3UgZGVzY3JpYmUgeW91ciBzZXR1cCBhbmQgdGhlIGVycm9yIG1lc3NhZ2VzLCB3ZSBj
YW4gcHJvYmFibHkgaGVscAo+IHlvdSBiZXR0ZXIuCj4gCj4gQ2hlZXJzLAo+IEFuZHJlCj4gCj4g
Pgo+ID4gQXBwcmVjaWF0ZSBmb3IgeW91ciBoZWxwIQo+ID4KPiA+IFNpbmNlcmVseSwKPiA+IFlp
bmh1YQo+ID4KPiA+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCj4gPiBrdm1hcm0gbWFpbGluZyBsaXN0Cj4gPiBrdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cj4gPiBodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo+ID4gIAo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
