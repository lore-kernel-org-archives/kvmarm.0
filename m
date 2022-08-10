Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D70C25B07
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 19:34:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 800044DA6F;
	Wed, 10 Aug 2022 15:34:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LyFFjXc+xKtT; Wed, 10 Aug 2022 15:34:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D4CA4DA69;
	Wed, 10 Aug 2022 15:34:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC5564DA55
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 15:34:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IW5pQHmhXB70 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Aug 2022 15:34:08 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 60B9D4DA53
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Aug 2022 15:34:08 -0400 (EDT)
Date: Wed, 10 Aug 2022 14:33:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660160047;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Xd7ZEh3Cai7T9+89O7KBFEDHECO3gMJG4kN2ocTFX7A=;
 b=gZ45Svi4/xPi8Uqm/3lqwxOfKntmq36LjsWKSmUW6nYlWib/04Y6vZ31GUKn3YNO8cljdM
 EQzpyHEIhidWwAm6OXLz4+hBTEHeQdL2c1GgIGcj6VZ5bhoUKGHdzJQhwwImYP4jWLyL0C
 wZqU6VogFnXuXNTqPRwlJKPkEb7vfro=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Ricardo Koller <ricarkol@google.com>
Subject: Re: [PATCH 0/9] KVM: arm64: PMU: Fixing chained events, and PMUv3p5
 support
Message-ID: <YvQIIWnUkCGl9Ltp@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <YvP8/m9uDI2PcyoP@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <YvP8/m9uDI2PcyoP@google.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kernel-team@android.com, kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

SGkgUmljYXJkbywKCk9uIFdlZCwgQXVnIDEwLCAyMDIyIGF0IDExOjQ2OjIyQU0gLTA3MDAsIFJp
Y2FyZG8gS29sbGVyIHdyb3RlOgo+IE9uIEZyaSwgQXVnIDA1LCAyMDIyIGF0IDAyOjU4OjA0UE0g
KzAxMDAsIE1hcmMgWnluZ2llciB3cm90ZToKPiA+IFJpY2FyZG8gcmVjZW50bHkgcmVwb3J0ZWRb
MV0gdGhhdCBvdXIgUE1VIGVtdWxhdGlvbiB3YXMgYnVzdGVkIHdoZW4gaXQKPiA+IGNvbWVzIHRv
IGNoYWluZWQgZXZlbnRzLCBhcyB3ZSBjYW5ub3QgZXhwb3NlIHRoZSBvdmVyZmxvdyBvbiBhIDMy
Yml0Cj4gPiBib3VuZGFyeSAod2hpY2ggdGhlIGFyY2hpdGVjdHVyZSByZXF1aXJlcykuCj4gPiAK
PiA+IFRoaXMgc2VyaWVzIGFpbXMgYXQgZml4aW5nIHRoaXMgKGJ5IGRlbGV0aW5nIGEgbG90IG9m
IGNvZGUpLCBhbmQgYXMgYQo+ID4gYm9udXMgYWRkcyBzdXBwb3J0IGZvciBQTVV2M3A1LCBhcyB0
aGlzIHJlcXVpcmVzIHVzIHRvIGZpeCBhIGZldyBtb3JlCj4gPiB0aGluZ3MuCj4gPiAKPiA+IFRl
c3RlZCBvbiBBNTMgKFBNVXYzKSBhbmQgRlZQIChQTVV2M3A1KS4KPiA+IAo+ID4gWzFdIGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMjA4MDUwMDQxMzkuOTkwNTMxLTEtcmljYXJrb2xAZ29v
Z2xlLmNvbQo+ID4gCj4gPiBNYXJjIFp5bmdpZXIgKDkpOgo+ID4gICBLVk06IGFybTY0OiBQTVU6
IEFsaWduIGNoYWluZWQgY291bnRlciBpbXBsZW1lbnRhdGlvbiB3aXRoCj4gPiAgICAgYXJjaGl0
ZWN0dXJlIHBzZXVkb2NvZGUKPiA+ICAgS1ZNOiBhcm02NDogUE1VOiBEaXN0aW5ndWlzaCBiZXR3
ZWVuIDY0Yml0IGNvdW50ZXIgYW5kIDY0Yml0IG92ZXJmbG93Cj4gPiAgIEtWTTogYXJtNjQ6IFBN
VTogT25seSBuYXJyb3cgY291bnRlcnMgdGhhdCBhcmUgbm90IDY0Yml0IHdpZGUKPiA+ICAgS1ZN
OiBhcm02NDogUE1VOiBBZGQgY291bnRlcl9pbmRleF90b18qcmVnKCkgaGVscGVycwo+ID4gICBL
Vk06IGFybTY0OiBQTVU6IFNpbXBsaWZ5IHNldHRpbmcgYSBjb3VudGVyIHRvIGEgc3BlY2lmaWMg
dmFsdWUKPiA+ICAgS1ZNOiBhcm02NDogUE1VOiBNb3ZlIHRoZSBJRF9BQTY0REZSMF9FTDEuUE1V
dmVyIGxpbWl0IHRvIFZNIGNyZWF0aW9uCj4gPiAgIEtWTTogYXJtNjQ6IFBNVTogQWxldmVuIElE
X0FBNjRERlIwX0VMMS5QTVV2ZXIgdG8gYmUgc2V0IGZyb20gdXNlcnNwYWNlCj4gPiAgIEtWTTog
YXJtNjQ6IFBNVTogSW1wbGVtZW50IFBNVXYzcDUgbG9uZyBjb3VudGVyIHN1cHBvcnQKPiA+ICAg
S1ZNOiBhcm02NDogUE1VOiBBbGV2ZW4gUE1VdjNwNSB0byBiZSBleHBvc2VkIHRvIHRoZSBndWVz
dAo+ID4gCj4gPiAgYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgICAxICsKPiA+
ICBhcmNoL2FybTY0L2t2bS9hcm0uYyAgICAgICAgICAgICAgfCAgIDYgKwo+ID4gIGFyY2gvYXJt
NjQva3ZtL3BtdS1lbXVsLmMgICAgICAgICB8IDM3MiArKysrKysrKysrLS0tLS0tLS0tLS0tLS0t
LS0tLS0KPiA+ICBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jICAgICAgICAgfCAgNjUgKysrKyst
Cj4gPiAgaW5jbHVkZS9rdm0vYXJtX3BtdS5oICAgICAgICAgICAgIHwgIDE2ICstCj4gPiAgNSBm
aWxlcyBjaGFuZ2VkLCAyMDggaW5zZXJ0aW9ucygrKSwgMjUyIGRlbGV0aW9ucygtKQo+ID4gCj4g
PiAtLSAKPiA+IDIuMzQuMQo+ID4gCj4gCj4gSGkgTWFyYywKPiAKPiBUaGVyZSBpcyBvbmUgZXh0
cmEgcG90ZW50aWFsIGlzc3VlIHdpdGggZXhwb3NpbmcgUE1VdjNwNS4gSSBzZWUgdGhpcwo+IHdl
aXJkIGJlaGF2aW9yIHdoZW4gZG9pbmcgcGFzc3Rocm91Z2ggKCJiYXJlIG1ldGFsIikgb24gdGhl
IGZhc3QtbW9kZWwKPiBjb25maWd1cmVkIHRvIGVtdWxhdGUgUE1VdjNwNTogdGhlIFs2MzozMl0g
aGFsZiBvZiB0aGUgY291bnRlcnMKPiBvdmVyZmxvd2luZyBhdCAzMi1iaXRzIGlzIHN0aWxsIGlu
Y3JlbWVudGVkLgo+IAo+ICAgRmFzdCBtb2RlbCAtIEFSTXY4LjU6Cj4gICAgCj4gCUFzc3VtaW5n
IHRoZSBpbml0aWFsIHN0YXRlIGlzIGV2ZW49MHhGRkZGRkZGRiBhbmQgb2RkPTB4MCwKPiAJaW5j
cmVtZW50aW5nIHRoZSBldmVuIGNvdW50ZXIgbGVhZHMgdG86Cj4gCj4gCTB4MDAwMDAwMDFfMDAw
MDAwMDAJMHgwMDAwMDAwMF8wMDAwMDAwMQkJMHgxCj4gCWV2ZW4gY291bnRlcgkJb2RkIGNvdW50
ZXIJCQlQTU9WU0VUCj4gCj4gCUFzc3VtaW5nIHRoZSBpbml0aWFsIHN0YXRlIGlzIGV2ZW49MHhG
RkZGRkZGRiBhbmQgb2RkPTB4RkZGRkZGRkYsCj4gCWluY3JlbWVudGluZyB0aGUgZXZlbiBjb3Vu
dGVyIGxlYWRzIHRvOgo+IAo+IAkweDAwMDAwMDAxXzAwMDAwMDAwCTB4MDAwMDAwMDFfMDAwMDAw
MDAJCTB4Mwo+IAlldmVuIGNvdW50ZXIJCW9kZCBjb3VudGVyCQkJUE1PVlNFVAoKVGhpcyBpcyB0
byBiZSBleHBlY3RlZCwgYWN0dWFsbHkuIFBNVXY4cDUgY291bnRlcnMgYXJlIGFsd2F5cyA2NCBi
aXQsCnJlZ2FyZGxlc3Mgb2YgdGhlIGNvbmZpZ3VyZWQgb3ZlcmZsb3cuCgpEREkgMDQ4N0ggRDgu
MyBCZWhhdmlvciBvbiBvdmVyZmxvdwoKICBJZiBGRUFUX1BNVXYzcDUgaXMgaW1wbGVtZW50ZWQs
IDY0LWJpdCBldmVudCBjb3VudGVycyBhcmUgaW1wbGVtZW50ZWQsCiAgSERDUi5IUE1OIGlzIG5v
dCAwLCBhbmQgZWl0aGVyIG4gaXMgaW4gdGhlIHJhbmdlIFswIC4uIChIRENSLkhQTU4tMSldCiAg
b3IgRUwyIGlzIG5vdCBpbXBsZW1lbnRlZCwgdGhlbiBldmVudCBjb3VudGVyIG92ZXJmbG93IGlz
IGNvbmZpZ3VyZWQKICBieSBQTUNSLkxQOgoKICDigJQgV2hlbiBQTUNSLkxQIGlzIHNldCB0byAw
LCBpZiBpbmNyZW1lbnRpbmcgUE1FVkNOVFI8bj4gY2F1c2VzIGFuIHVuc2lnbmVkCiAgICBvdmVy
ZmxvdyBvZiBiaXRzIFszMTowXSBvZiB0aGUgZXZlbnQgY291bnRlciwgdGhlIFBFIHNldHMgUE1P
VlNDTFJbbl0gdG8gMS4KICDigJQgV2hlbiBQTUNSLkxQIGlzIHNldCB0byAxLCBpZiBpbmNyZW1l
bnRpbmcgUE1FVkNOVFI8bj4gY2F1c2VzIGFuIHVuc2lnbmVkCiAgICBvdmVyZmxvdyBvZiBiaXRz
IFs2MzowXSBvZiB0aGUgZXZlbnQgY291bnRlciwgdGhlIFBFIHNldHMgUE1PVlNDTFJbbl0gdG8g
MS4KCiAgWy4uLl0KCiAgRm9yIGFsbCA2NC1iaXQgY291bnRlcnMsIGluY3JlbWVudGluZyB0aGUg
Y291bnRlciBpcyB0aGUgc2FtZSB3aGV0aGVyIGFuCiAgdW5zaWduZWQgb3ZlcmZsb3cgb2NjdXJz
IGF0IFszMTowXSBvciBbNjM6MF0uIElmIHRoZSBjb3VudGVyIGluY3JlbWVudHMKICBmb3IgYW4g
ZXZlbnQsIGJpdHMgWzYzOjBdIGFyZSBhbHdheXMgaW5jcmVtZW50ZWQuCgpEbyB5b3Ugc2VlIHRo
aXMgc2FtZSAoZXhwZWN0ZWQpIGZhaWx1cmUgdy8gTWFyYydzIHNlcmllcz8KCi0tClRoYW5rcywK
T2xpdmVyCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
