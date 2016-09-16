From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v2] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 16 Sep 2016 14:28:55 +0200
Message-ID: <68EDCDEF-5D07-405C-9601-F489F55056F7@suse.de>
References: <1474002553-30079-1-git-send-email-agraf@suse.de>
 <20160916094433.GA4794@cbox>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1727F48529
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 08:20:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GN8qOF+2szeb for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 08:20:11 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CAC4041390
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 08:20:10 -0400 (EDT)
In-Reply-To: <20160916094433.GA4794@cbox>
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
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Cj4gT24gMTYgU2VwIDIwMTYsIGF0IDExOjQ0LCBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZl
ci5kYWxsQGxpbmFyby5vcmc+IHdyb3RlOgo+IAo+IEFsZXgsCj4gCj4gT24gRnJpLCBTZXAgMTYs
IDIwMTYgYXQgMDc6MDk6MTNBTSArMDIwMCwgQWxleGFuZGVyIEdyYWYgd3JvdGU6Cj4+IFdlIGhh
dmUgMiBtb2RlcyBmb3IgZGVhbGluZyB3aXRoIGludGVycnVwdHMgaW4gdGhlIEFSTSB3b3JsZC4g
V2UgY2FuIGVpdGhlcgo+PiBoYW5kbGUgdGhlbSBhbGwgdXNpbmcgaGFyZHdhcmUgYWNjZWxlcmF0
aW9uIHRocm91Z2ggdGhlIHZnaWMgb3Igd2UgY2FuIGVtdWxhdGUKPj4gYSBnaWMgaW4gdXNlciBz
cGFjZSBhbmQgb25seSBkcml2ZSBDUFUgSVJRIHBpbnMgZnJvbSB0aGVyZS4KPj4gCj4+IFVuZm9y
dHVuYXRlbHksIHdoZW4gZHJpdmluZyBJUlFzIGZyb20gdXNlciBzcGFjZSwgd2UgbmV2ZXIgdGVs
bCB1c2VyIHNwYWNlCj4+IGFib3V0IHRpbWVyIGV2ZW50cyB0aGF0IG1heSByZXN1bHQgaW4gaW50
ZXJydXB0IGxpbmUgc3RhdGUgY2hhbmdlcywgc28gd2UKPj4gbG9zZSBvdXQgb24gdGltZXIgZXZl
bnRzIGlmIHdlIHJ1biB3aXRoIHVzZXIgc3BhY2UgZ2ljIGVtdWxhdGlvbi4KPj4gCj4+IFRoaXMg
cGF0Y2ggc2V0IGZpeGVzIHRoYXQgYnkgcm91dGluZyB2dGltZXIgZXhwaXJhdGlvbiBldmVudHMg
dG8gdXNlciBzcGFjZS4KPj4gV2l0aCB0aGlzIHBhdGNoIEkgY2FuIHN1Y2Nlc3NmdWxseSBydW4g
ZWRrMiBhbmQgTGludXggd2l0aCB1c2VyIHNwYWNlIGdpYwo+PiBlbXVsYXRpb24uCj4gCj4gSSBo
YXZlIHR3byB2ZXJzaW9ucyBvZiB2Mi4gIEFyZSB0aGVyZSBhbnkgZGlmZmVyZW5jZXMgb3IgZGlk
IGl0IGp1c3QgZ28KPiBvdXQgdHdpY2Ugb3IgZ290IGR1cGxpY2F0ZWQgc29tZWhvdyBvbiBteSBl
bmQ/CgpKdXN0IGlnbm9yZSB2Mi4gSSBzaG91bGRu4oCZdCBzZW5kIGVtYWlscyB0aGF0IGVhcmx5
IGluIHRoZSBtb3JuaW5nLiB2MyBpcyBtdWNoIGJldHRlciA7KQoKCkFsZXgKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
