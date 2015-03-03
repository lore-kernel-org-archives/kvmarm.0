From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/6] target-arm: kvm: save/restore mp state
Date: Tue, 03 Mar 2015 12:06:40 +0100
Message-ID: <54F595C0.5060004@redhat.com>
References: <1424880159-29348-1-git-send-email-alex.bennee@linaro.org>
 <1424880159-29348-2-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA9oWeYGYcGtf8So6VrYLMXjWr4FiZ2tS+jBnDtv87jAKw@mail.gmail.com>
 <8761ai73j1.fsf@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68B8A4782B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Mar 2015 06:00:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n8fll7DADqKf for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Mar 2015 06:00:53 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9A4D747829
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Mar 2015 06:00:53 -0500 (EST)
In-Reply-To: <8761ai73j1.fsf@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, Peter Maydell <peter.maydell@linaro.org>
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAwMy8wMy8yMDE1IDExOjU2LCBBbGV4IEJlbm7DqWUgd3JvdGU6Cj4gPiA+IFRoaXMgYWRk
cyB0aGUgc2F2aW5nIGFuZCByZXN0b3JlIG9mIHRoZSBjdXJyZW50IE11bHRpLVByb2Nlc3Npbmcg
c3RhdGUKPiA+ID4gb2YgdGhlIG1hY2hpbmUuIFdoaWxlIHRoZSBLVk1fR0VUL1NFVF9NUF9TVEFU
RSBBUEkgZXhwb3NlcyBhIG51bWJlciBvZgo+ID4gPiBwb3RlbnRpYWwgc3RhdGVzIGZvciB4ODYg
d2Ugb25seSB1c2UgdHdvIGZvciBBUk0uIEVpdGhlciB0aGUgcHJvY2VzcyBpcwo+ID4gPiBydW5u
aW5nIG9yIG5vdC4KPiA+Cj4gPiBCeSB0aGlzIHlvdSBtZWFuICJpcyB0aGUgQ1BVIGluIHRoZSBQ
U0NJIHBvd2VyZWQgZG93biBzdGF0ZSBvciBub3QiLAo+ID4gcmlnaHQ/Cj4gCj4gRnJvbSB0aGUg
dmNwdSdzIHBlcnNwZWN0aXZlIGl0IGlzIGVpdGhlciBydW5uaW5nIG9yIG5vdC4gSG93ZXZlciBp
dCBpcwo+IHRoZSBzYW1lIG1lY2hhbmlzbSB0aGF0IGlzIHVzZWQgd2hlbiBQU0NJXzBfMl9GTl9D
UFVfT0ZGIGlzIHBhc3NlZCB0aGUKPiBWTSwgaW50ZXJuYWxseSBzZXR0aW5nIHZjcHUtPmFyY2gu
cGF1c2VkLgoKSSBzdWdnZXN0IHRoYXQgeW91IGRlZmluZSBhIG5ldyBNUF9TVEFURSBjb25zdGFu
dCBmb3IgdGhpcy4gIEhBTFRFRCBpbgp4ODYgYW5kIHMzOTAgaXMgdGhlIHN0YXRlIGFuIEFSTSBw
cm9jZXNzb3IgZW50ZXJzIHdoZW4geW91IGV4ZWN1dGUgd2ZpLgogUmlnaHQgbm93IHRoaXMgaXMg
bm90IG1pZ3JhdGVkIG9uIEFSTSBpZiBJIHJlbWVtYmVyIGNvcnJlY3RseSwgYnV0CnBlcmhhcHMg
eW91J2xsIHdhbnQgdG8gYWRkIGl0IGluIHRoZSBmdXR1cmUuCgpQYW9sbwpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
