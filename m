From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: KVM: Add braces to multi-line if statement in
 virtual PMU code
Date: Fri, 1 Apr 2016 12:36:25 +0100
Message-ID: <20160401113625.GC3604@arm.com>
References: <1459509142-13524-1-git-send-email-will.deacon@arm.com>
 <20160401113040.GD20224@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB40440F77
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 07:35:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GqIhUf8GBwci for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2016 07:35:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74B0C40C9D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 07:35:22 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20160401113040.GD20224@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gRnJpLCBBcHIgMDEsIDIwMTYgYXQgMDE6MzA6NDBQTSArMDIwMCwgQ2hyaXN0b2ZmZXIgRGFs
bCB3cm90ZToKPiBPbiBGcmksIEFwciAwMSwgMjAxNiBhdCAxMjoxMjoyMlBNICswMTAwLCBXaWxs
IERlYWNvbiB3cm90ZToKPiA+IFRoZSBrZXJuZWwgaXMgd3JpdHRlbiBpbiBDLCBub3QgcHl0aG9u
LCBzbyB3ZSBuZWVkIGJyYWNlcyBhcm91bmQKPiA+IG11bHRpLWxpbmUgaWYgc3RhdGVtZW50cy4g
R0NDIDYgYWN0dWFsbHkgd2FybnMgYWJvdXQgdGhpcywgdGhhbmtzIHRvIHRoZQo+ID4gZmFudGFz
dGljIG5ldyAiLVdtaXNsZWFkaW5nLWluZGVudGF0aW9uIiBmbGFnOgo+IAo+IFdlIHNob3VsZCBy
ZXdyaXRlIHRoZSBrZXJuZWwgaW4gcHl0aG9uIQoKT2ggbWFuLCB5b3UgbWFkZSBtZSBsb29rIGFu
ZCBJIGZvdW5kIHRoaXM6CgpodHRwczovL21haWwucHl0aG9uLm9yZy9waXBlcm1haWwvcHl0aG9u
LWxpc3QvMjAwNC1PY3RvYmVyLzI4MzMyNy5odG1sCgpidXQsIHRvZGF5J3MgY2VydGFpbmx5IHRo
ZSBkYXkgZm9yIHdoYWNreSBzdWdnZXN0aW9ucy4KCj4gPiAgfCB2aXJ0L2t2bS9hcm0vcG11LmM6
IEluIGZ1bmN0aW9uIOKAmGt2bV9wbXVfb3ZlcmZsb3dfc3RhdHVz4oCZOgo+ID4gIHwgdmlydC9r
dm0vYXJtL3BtdS5jOjE5ODozOiB3YXJuaW5nOiBzdGF0ZW1lbnQgaXMgaW5kZW50ZWQgYXMgaWYg
aXQgd2VyZSBndWFyZGVkIGJ5Li4uIFstV21pc2xlYWRpbmctaW5kZW50YXRpb25dCj4gPiAgfCAg
ICByZWcgJj0gdmNwdV9zeXNfcmVnKHZjcHUsIFBNQ05URU5TRVRfRUwwKTsKPiA+ICB8ICAgIF5+
fgo+ID4gIHwgYXJjaC9hcm02NC9rdm0vLi4vLi4vLi4vdmlydC9rdm0vYXJtL3BtdS5jOjE5Njoy
OiBub3RlOiAuLi50aGlzIOKAmGlm4oCZIGNsYXVzZSwgYnV0IGl0IGlzIG5vdAo+ID4gIHwgICBp
ZiAoKHZjcHVfc3lzX3JlZyh2Y3B1LCBQTUNSX0VMMCkgJiBBUk1WOF9QTVVfUE1DUl9FKSkKPiA+
ICB8ICAgXn4KPiA+IAo+ID4gQXMgaXQgdHVybnMgb3V0LCB0aGlzIHBhcnRpY3VsYXIgY2FzZSBp
cyBoYXJtbGVzcyAod2UganVzdCBkbyBzb21lICY9Cj4gPiBvcGVyYXRpb25zIHdpdGggMCksIGJ1
dCB3b3J0aCBmaXhpbmcgbm9uZXRoZWxlc3MuCj4gPiAKPiA+IFNpZ25lZC1vZmYtYnk6IFdpbGwg
RGVhY29uIDx3aWxsLmRlYWNvbkBhcm0uY29tPgo+IAo+IFRoYW5rcyBmb3IgdGhlIHBhdGNoLgoK
Tm8gcHJvYmxlbS4gSSB0aW1lZCBpdCBuaWNlbHkgd2l0aCB5b3VyIHB1bGwgcmVxdWVzdC4KCldp
bGwKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
