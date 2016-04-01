From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm64: KVM: Add braces to multi-line if statement in
 virtual PMU code
Date: Fri, 1 Apr 2016 14:10:34 +0200
Message-ID: <20160401121034.GA22170@cbox>
References: <1459509142-13524-1-git-send-email-will.deacon@arm.com>
 <20160401113040.GD20224@cbox> <20160401113625.GC3604@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90C4C412A2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 08:09:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4MK9g6LDkBAM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Apr 2016 08:09:25 -0400 (EDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6847F40C9D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Apr 2016 08:09:25 -0400 (EDT)
Received: by mail-wm0-f46.google.com with SMTP id p65so23313979wmp.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Apr 2016 05:10:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160401113625.GC3604@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gRnJpLCBBcHIgMDEsIDIwMTYgYXQgMTI6MzY6MjVQTSArMDEwMCwgV2lsbCBEZWFjb24gd3Jv
dGU6Cj4gT24gRnJpLCBBcHIgMDEsIDIwMTYgYXQgMDE6MzA6NDBQTSArMDIwMCwgQ2hyaXN0b2Zm
ZXIgRGFsbCB3cm90ZToKPiA+IE9uIEZyaSwgQXByIDAxLCAyMDE2IGF0IDEyOjEyOjIyUE0gKzAx
MDAsIFdpbGwgRGVhY29uIHdyb3RlOgo+ID4gPiBUaGUga2VybmVsIGlzIHdyaXR0ZW4gaW4gQywg
bm90IHB5dGhvbiwgc28gd2UgbmVlZCBicmFjZXMgYXJvdW5kCj4gPiA+IG11bHRpLWxpbmUgaWYg
c3RhdGVtZW50cy4gR0NDIDYgYWN0dWFsbHkgd2FybnMgYWJvdXQgdGhpcywgdGhhbmtzIHRvIHRo
ZQo+ID4gPiBmYW50YXN0aWMgbmV3ICItV21pc2xlYWRpbmctaW5kZW50YXRpb24iIGZsYWc6Cj4g
PiAKPiA+IFdlIHNob3VsZCByZXdyaXRlIHRoZSBrZXJuZWwgaW4gcHl0aG9uIQo+IAo+IE9oIG1h
biwgeW91IG1hZGUgbWUgbG9vayBhbmQgSSBmb3VuZCB0aGlzOgo+IAo+IGh0dHBzOi8vbWFpbC5w
eXRob24ub3JnL3BpcGVybWFpbC9weXRob24tbGlzdC8yMDA0LU9jdG9iZXIvMjgzMzI3Lmh0bWwK
CkhhaGEsIHRoZSByZXBseSBzYXlpbmcgIkdyZWF0IGlkZWEsIGdvIGZvciBpdCEiIGlzIGhpbGFy
aW91cy4KCj4gCj4gYnV0LCB0b2RheSdzIGNlcnRhaW5seSB0aGUgZGF5IGZvciB3aGFja3kgc3Vn
Z2VzdGlvbnMuCj4gCgpJIHdhbnRlZCB0byBoYXZlIHNlbnQgeW91IGFuZCBDYXRhbGluIG15IExp
bnV4IGluIEVMMiBwYXRjaCBzZXQgdG9kYXksCmJ1dCBpdCB3YXMgc3RpbGwgdG9vIG1lc3N5IGFu
ZCBoYWNrZWQgdXAgZm9yIHRoYXQgdG8gYmUgZnVubnksCnVuZm9ydHVuYXRlbHkuCgo+ID4gPiAg
fCB2aXJ0L2t2bS9hcm0vcG11LmM6IEluIGZ1bmN0aW9uIOKAmGt2bV9wbXVfb3ZlcmZsb3dfc3Rh
dHVz4oCZOgo+ID4gPiAgfCB2aXJ0L2t2bS9hcm0vcG11LmM6MTk4OjM6IHdhcm5pbmc6IHN0YXRl
bWVudCBpcyBpbmRlbnRlZCBhcyBpZiBpdCB3ZXJlIGd1YXJkZWQgYnkuLi4gWy1XbWlzbGVhZGlu
Zy1pbmRlbnRhdGlvbl0KPiA+ID4gIHwgICAgcmVnICY9IHZjcHVfc3lzX3JlZyh2Y3B1LCBQTUNO
VEVOU0VUX0VMMCk7Cj4gPiA+ICB8ICAgIF5+fgo+ID4gPiAgfCBhcmNoL2FybTY0L2t2bS8uLi8u
Li8uLi92aXJ0L2t2bS9hcm0vcG11LmM6MTk2OjI6IG5vdGU6IC4uLnRoaXMg4oCYaWbigJkgY2xh
dXNlLCBidXQgaXQgaXMgbm90Cj4gPiA+ICB8ICAgaWYgKCh2Y3B1X3N5c19yZWcodmNwdSwgUE1D
Ul9FTDApICYgQVJNVjhfUE1VX1BNQ1JfRSkpCj4gPiA+ICB8ICAgXn4KPiA+ID4gCj4gPiA+IEFz
IGl0IHR1cm5zIG91dCwgdGhpcyBwYXJ0aWN1bGFyIGNhc2UgaXMgaGFybWxlc3MgKHdlIGp1c3Qg
ZG8gc29tZSAmPQo+ID4gPiBvcGVyYXRpb25zIHdpdGggMCksIGJ1dCB3b3J0aCBmaXhpbmcgbm9u
ZXRoZWxlc3MuCj4gPiA+IAo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBXaWxsIERlYWNvbiA8d2lsbC5k
ZWFjb25AYXJtLmNvbT4KPiA+IAo+ID4gVGhhbmtzIGZvciB0aGUgcGF0Y2guCj4gCj4gTm8gcHJv
YmxlbS4gSSB0aW1lZCBpdCBuaWNlbHkgd2l0aCB5b3VyIHB1bGwgcmVxdWVzdC4KPiAKWWVhaCwg
SSBmaWd1cmUgSSB3aWxsIGp1c3QgYWRkIGl0IHRvIHRoZSBuZXh0IHB1bGwgcmVxdWVzdCwgdW5s
ZXNzCmFueW9uZSBvYmplY3RzIHRvIHRoYXQuCgotQ2hyaXN0b2ZmZXIKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1h
cm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21h
aWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
