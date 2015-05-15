From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 03/12] KVM: arm64: guest debug, define API headers
Date: Fri, 15 May 2015 16:43:24 +0100
Message-ID: <20150515154324.GC23652@leverpostej>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
 <1431700035-23479-4-git-send-email-alex.bennee@linaro.org>
 <20150515144423.GA23652@leverpostej> <874mndlvny.fsf@linaro.org>
 <CAFEAcA8ZpndRyT84ta2r4bPTE1uGTN1XTfMpUn8qW022ben3BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B99C25176F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 11:34:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BKJN7YHB6+hg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2015 11:34:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D25D5174A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 11:34:20 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <CAFEAcA8ZpndRyT84ta2r4bPTE1uGTN1XTfMpUn8qW022ben3BQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, "r65777@freescale.com" <r65777@freescale.com>, Will Deacon <Will.Deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, "dahi@linux.vnet.ibm.com" <dahi@linux.vnet.ibm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "zhichao.huang@linaro.org" <zhichao.huang@linaro.org>, "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "bp@suse.de" <bp@suse.de>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

T24gRnJpLCBNYXkgMTUsIDIwMTUgYXQgMDQ6MTc6NDZQTSArMDEwMCwgUGV0ZXIgTWF5ZGVsbCB3
cm90ZToKPiBPbiAxNSBNYXkgMjAxNSBhdCAxNjoxNCwgQWxleCBCZW5uw6llIDxhbGV4LmJlbm5l
ZUBsaW5hcm8ub3JnPiB3cm90ZToKPiA+Cj4gPiBNYXJrIFJ1dGxhbmQgPG1hcmsucnV0bGFuZEBh
cm0uY29tPiB3cml0ZXM6Cj4gPgo+ID4+IE9uIEZyaSwgTWF5IDE1LCAyMDE1IGF0IDAzOjI3OjA2
UE0gKzAxMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPiA+Pj4gKy8qCj4gPj4+ICsgKiBTZWUgdjgg
QVJNIEFSTSBENy4zOiBEZWJ1ZyBSZWdpc3RlcnMKPiA+Pj4gKyAqCj4gPj4+ICsgKiBUaGUgY29u
dHJvbCByZWdpc3RlcnMgYXJlIGFyY2hpdGVjdHVyYWxseSBkZWZpbmVkIGFzIDMyIGJpdHMgYnV0
IGFyZQo+ID4+PiArICogc3RvcmVkIGFzIDY0IGJpdCB2YWx1ZXMgYWxvbmdzaWRlIHRoZSB2YWx1
ZSByZWdpc3RlcnMuIFRoaXMgaXMgZG9uZQo+ID4+Cj4gPj4gU3RhbGUgY29tbWVudD8gVGhleSdy
ZSBzdG9yZWQgYXMgX191MzIgYmVsb3cuCj4gPgo+ID4gR2FoIHllcyBpdCBpcy4KPiA+Cj4gPj4g
SXQncyBwb3NzaWJsZSB0aGF0IHRoZSByZWdpc3RlcnMgY291bGQgZ3JvdyBpbiBmdXR1cmUgYXMg
aGFwcGVuZWQgaW4gdGhlCj4gPj4gY2FzZSBvZiBDTElEUl9FTDEsIHNvIGl0IG1pZ2h0IGJlIHdv
cnRoIHRyZWF0aW5nIHN5c3RlbSByZWdpc3RlcnMKPiA+PiBnZW5lcmFsbHkgYXMgdTY0IHZhbHVl
cy4KPiA+Cj4gPiBSZWFsbHk/IEkgbWVhbiB0aGUgZXhpc3RpbmcgZGVidWcgKmNvbnRyb2wqIHJl
Z2lzdGVycyBoYXZlIHJlc2VydmVkIGJpdHMKPiA+IDI0LTMxIHNvIHRoZXJlIGlzIHNwYWNlIGZv
ciBleHBhbnNpb24uCj4gCj4gT3RoZXIgcGxhY2VzIGluIHRoZSB1c2Vyc3BhY2UgQUJJIHdoaWNo
IGRlYWwgd2l0aCBzeXNyZWdzIChub3RhYmx5Cj4gT05FX1JFRykgY29uc2lzdGVudGx5IGRlZmlu
ZSB0aGVtIGFsbCBhcyA2NC1iaXQKCkFsc28gZm9yIHB0X3JlZ3MucHN0YXRlLgoKSSBqdXN0IHNw
b3R0ZWQgdGhhdCBpbiB1c2VyX2h3ZGVidWdfc3RhdGUgaW4gcHRyYWNlLmggd2Ugc2VlbSB0byBl
eHBvc2UKdGhlIGRlYnVnIGNvbnRyb2wgcmVnc2l0ZXJzIGFzIF9fdTMyIGFscmVhZHksIGFhbG9u
ZyB3aXRoIHNvbWUgb3RoZXIKcmVnaXN0ZXJzLgoKU28gd2UncmUgYWxyZWFkeSBpbmNvbnNpc3Rl
bnQgdy5yLnQuIGhvdyB3ZSBleHBvc2UgdGhvc2UgcmVnaXN0ZXJzLCBhbmQKSSdtIG5vdCBzdXJl
IHdoYXQgd2UnZCBkbyBlbHNld2hlcmUgaWYgYW55IHJlZ2lzdGVycyBnb3QgZXhwYW5kZWQuIDov
CgpNYXJrLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
