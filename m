From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC PATCH v2 00/23] KVM: arm64: Initial support for SVE guests
Date: Thu, 22 Nov 2018 15:34:16 +0000
Message-ID: <875zwpi0sn.fsf@linaro.org>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 01C324A1E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 10:34:20 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cZBKLJpLiTBE for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Nov 2018 10:34:19 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 194A14A1DF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 10:34:19 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id v13so6195651wrw.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Nov 2018 07:34:19 -0800 (PST)
In-reply-to: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFRoaXMgc2VyaWVz
IGltcGxlbWVudHMgYmFzaWMgc3VwcG9ydCBmb3IgYWxsb3dpbmcgS1ZNIGd1ZXN0cyB0byB1c2Ug
dGhlCj4gQXJtIFNjYWxhYmxlIFZlY3RvciBFeHRlbnNpb24gKFNWRSkuCj4KPiBUaGUgcGF0Y2hl
cyBhcmUgYmFzZWQgb24gdjQuMTktcmM1Lgo+Cj4gVGhlIHBhdGNoZXMgYXJlIGFsc28gYXZhaWxh
YmxlIG9uIGEgYnJhbmNoIGZvciByZXZpZXdlciBjb252ZW5pZW5jZS4gWzFdCj4KPiBUaGlzIGlz
IGEgc2lnbmlmaWNhbnQgb3ZlcmhhdWwgb2YgdGhlIHByZXZpb3VzIHByZWxpbWluYXJ5IHNlcmll
cyBbMl0sCj4gd2l0aCB0aGUgbWFqb3IgY2hhbmdlcyBvdXRsaW5lZCBiZWxvdywgYW5kIGFkZGl0
aW9uYWwgbWlub3IgdXBkYXRlcyBpbgo+IHJlc3BvbnNlIHRvIHJldmlldyBmZWVkYmFjayAoc2Vl
IHRoZSBpbmRpdmlkdWFsIHBhdGNoZXMgZm9yIHRob3NlKS4KPgo+IEluIHRoZSBpbnRlcmVzdCBv
ZiBnZXR0aW5nIHRoaXMgc2VyaWVzIG91dCBmb3IgcmV2aWV3LAo+IFRoaXMgc2VyaWVzIGlzICoq
Y29tcGxldGVseSB1bnRlc3RlZCoqLgoKUmljaGFyZCBpcyBjdXJyZW50bHkgd29ya2luZyBvbiBW
SEUgc3VwcG9ydCBmb3IgUUVNVSBhbmQgd2UgYWxyZWFkeSBoYXZlClNWRSBzeXN0ZW0gZW11bGF0
aW9uIHN1cHBvcnQgYXMgb2YgMy4xIHNvIGhvcGVmdWxseSBRRU1VIHdpbGwgYmUgYWJsZSB0bwp0
ZXN0IHRoaXMgc29vbiAoYW5kIHByb2JhYmx5IHNoYWtlIG91dCBhIGZldyBvZiBvdXIgb3duIGJ1
Z3MgOy0pLgoKPiBSZXZpZXdlcnMgc2hvdWxkIGZvY3VzIG9uIHRoZSBwcm9wb3NlZCBBUEkgKGJ1
dCBhbnkgb3RoZXIgY29tbWVudHMgYXJlCj4gb2YgY291cnNlIHdlbGNvbWUhKQo8c25pcD4KCkkn
dmUgZmluaXNoZWQgbXkgcGFzcyBmb3IgdGhpcyByZXZpc2lvbi4gU29ycnkgaXQgdG9vayBzbyBs
b25nIHRvIGdldCB0bwppdC4KCi0tCkFsZXggQmVubsOpZQpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
