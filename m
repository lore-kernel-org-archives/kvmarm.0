From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: stand-alone kvmtool
Date: Thu, 26 Feb 2015 11:02:31 +0000
Message-ID: <87mw41aqbc.fsf@linaro.org>
References: <54DDD465.3050300@arm.com> <20150218155042.GF22017@arm.com>
 <54EAFCE9.5030000@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B876A46AB4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 05:56:37 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x+XVH8pwnfqg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Feb 2015 05:56:36 -0500 (EST)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9C4C946AB1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Feb 2015 05:56:36 -0500 (EST)
In-reply-to: <54EAFCE9.5030000@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>
Cc: Pekka Enberg <penberg@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <Marc.Zyngier@arm.com>, Asias He <asias.hejun@gmail.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>, Ronald Minnich <rminnich@google.com>, Sasha Levin <sasha.levin@oracle.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

CkFuZHJlIFByenl3YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0uY29tPiB3cml0ZXM6Cgo+IEhpIFdp
bGwsCj4KPiBPbiAxOC8wMi8xNSAxNTo1MCwgV2lsbCBEZWFjb24gd3JvdGU6Cj4+IEhpIEFuZHJl
LAo+PiAKPj4gVGhhbmtzIGZvciBkb2luZyB0aGlzLiBTaW5jZSBpdCBsb29rcyB1bmxpa2VseSB0
aGF0IGt2bXRvb2wgd2lsbCBldmVyIGJlCj4+IG1lcmdlZCBiYWNrIGludG8gdGhlIGtlcm5lbCB0
cmVlLCBpdCBtYWtlcyBzZW5zZSB0byBjdXQgdGhlIGRlcGVuZGVuY3kKPj4gaW4gbXkgb3Bpbmlv
bi4KPj4gCjxzbmlwPgo+Cj4gUC5TLiBBbHRob3VnaCBib3RoIGFwcHJvYWNoZXMgc3RpbGwgcHJv
dmlkZSB0aGUga3ZtdG9vbCBwYXRjaCBoaXN0b3J5LAo+IHRoZXkgZG8gbm90IGNvbXBpbGUgYmVm
b3JlIHRoZSBkZXBlbmRlbmN5IGN1dCBwYXRjaGVzLiBJZiB0aGF0IGlzIGFuCj4gaXNzdWUsIG9u
ZSBjb3VsZCB0aGluayBhYm91dCBpbmplY3RpbmcgdGhvc2UgbmV3IHBhdGNoZXMgYmFjayBpbnRv
IHRoZQo+IHJlcG9zaXRvcnkgdGltZSBsaW5lLiBBZG1pdHRlZGx5IHRoYXQgc291bmRzIHNjYXJ5
LCBidXQgd291bGQgc29sdmUgdGhlCj4gcHJvYmxlbS4KCklmIHlvdSBjYW4gaGF2ZSBpdCBhbGwg
aXQgd291bGQgYmUgbmljZSB0byBwcmVzZXJ2ZSBidWlsZGFiaWxpdHkgYWxsCnRocm91Z2ggeW91
ciBoaXN0b3J5IGZvciBiaXNlY3RpbmcgKGFuZCB0aGUgbW9vbiBvbiBhIHN0aWNrIHBsZWFzZSA7
LSkKCklzIHRoZSBkZXBlbmRlbmN5IG9uIHRoZSBrZXJuZWwgc291cmNlcyBzb21ldGhpbmcgdGhh
dCBoYXMgYmVlbiBzdGFibGUKb3ZlciB0aGUgcHJvamVjdHMgaGlzdG9yeSBvciBzb21ldGhpbmcg
dGhhdCdzIGJlZW4gZGVjbGluaW5nL2luY3JlYXNpbmcKb3ZlciB0aW1lPwoKLS0gCkFsZXggQmVu
bsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1h
cm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0
cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
