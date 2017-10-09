From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 26/28] arm64/sve: Add documentation
Date: Mon, 09 Oct 2017 10:34:25 +0100
Message-ID: <878tgkbr6m.fsf@linaro.org>
References: <1504198860-12951-1-git-send-email-Dave.Martin@arm.com>
 <1504198860-12951-27-git-send-email-Dave.Martin@arm.com>
 <59D7A4AF.40408@arm.com> <20171006173715.GC3611@e103592.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A175949D21
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Oct 2017 05:33:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gbcP5sUDOjF7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Oct 2017 05:33:51 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8443441185
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Oct 2017 05:33:51 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id q132so21610368wmd.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Oct 2017 02:34:27 -0700 (PDT)
In-reply-to: <20171006173715.GC3611@e103592.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IE9uIEZyaSwgT2N0
IDA2LCAyMDE3IGF0IDA0OjQzOjQzUE0gKzAxMDAsIFN6YWJvbGNzIE5hZ3kgd3JvdGU6Cj4+IE9u
IDMxLzA4LzE3IDE4OjAwLCBEYXZlIE1hcnRpbiB3cm90ZToKPj4gPiArOS4gIFN5c3RlbSBydW50
aW1lIGNvbmZpZ3VyYXRpb24KPj4gPiArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0K
Pj4gPiArCj4+ID4gKyogVG8gbWl0aWdhdGUgdGhlIEFCSSBpbXBhY3Qgb2YgZXhwYW5zaW9uIG9m
IHRoZSBzaWduYWwgZnJhbWUsIGEgcG9saWN5Cj4+ID4gKyAgbWVjaGFuaXNtIGlzIHByb3ZpZGVk
IGZvciBhZG1pbmlzdHJhdG9ycywgZGlzdHJvIG1haW50YWluZXJzIGFuZCBkZXZlbG9wZXJzCj4+
ID4gKyAgdG8gc2V0IHRoZSBkZWZhdWx0IHZlY3RvciBsZW5ndGggZm9yIHVzZXJzcGFjZSBwcm9j
ZXNzZXM6Cj4+ID4gKwo+PiA+ICsvcHJvYy9jcHUvc3ZlX2RlZmF1bHRfdmVjdG9yX2xlbmd0aAo+
Pgo+Pgo+PiBlbHNld2hlcmUgaW4gdGhlIHBhdGNoIHNlcmllcyBpIHNlZQo+Pgo+PiAvcHJvYy9z
eXMvYWJpL3N2ZV9kZWZhdWx0X3ZlY3Rvcl9sZW5ndGgKPj4KPj4gaXMgdGhpcyBzdXBwb3NlZCB0
byBiZSB0aGUgc2FtZT8KPgo+IEdvb2Qgc3BvdCwgdGhhbmtzIQo+Cj4gL3Byb2MvY3B1LyB3YXMg
dGhlIG9sZCBsb2NhdGlvbjogdGhleSBzaG91bGQgYm90aCBzYXkgL3Byb2MvYWJpLy4KPiBJJ2xs
IGZpeCBpdC4KCklzbid0IC9zeXMgKG9yIHJhdGhlciBzeXNmcykgdGhlIHByZWZlcnJlZCBsb2Nh
dGlvbiBmb3IgbW9kZXJuIGNvbnRyb2wKa25vYnMgdGhhdCBtaXJyb3IgdGhlIGtlcm5lbHMgb2Jq
ZWN0IG1vZGVsIG9yIGlzIFNWRSBhIHNwZWNpYWwgY2FzZSBmb3IKZXh0ZW5kaW5nIC9wcm9jPwoK
Cj4KPiAtLS1EYXZlCgoKLS0KQWxleCBCZW5uw6llCl9fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNz
LmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo=
