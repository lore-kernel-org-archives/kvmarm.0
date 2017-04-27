From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC kvm-unit-tests PATCH 5/8] Makefile: add explicit mkdir for
 .o targets
Date: Thu, 27 Apr 2017 17:57:36 +0200
Message-ID: <a8eb190a-3487-1a89-0069-789b62860b3e@redhat.com>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
 <20170406190727.5624-6-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D58043C73
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 11:54:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MWxuNGHcG6M9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Apr 2017 11:54:49 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52E7243C6E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Apr 2017 11:54:49 -0400 (EDT)
In-Reply-To: <20170406190727.5624-6-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, drjones@redhat.com
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAwNi8wNC8yMDE3IDIxOjA3LCBBbGV4IEJlbm7DqWUgd3JvdGU6Cj4gVGhpcyBpcyBmYWly
bHkgZGlyZWN0IHdheSBvZiBlbnN1cmluZyB0aGUgdGFyZ2V0IGJ1aWxkIGRpcmVjdG9yaWVzIGFy
ZQo+IGNyZWF0ZWQgYmVmb3JlIHdlIGJ1aWxkIGEgYmluYXJ5IGJsb2IuIG1rZGlyIC1wIGZhaWxz
IGdyYWNlZnVsbHkgaWYKPiB0aGUgZGlyZWN0b3J5IGlzIGFscmVhZHkgdGhlcmUuCj4gCj4gU2ln
bmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgo+IC0tLQo+
ICBNYWtlZmlsZSB8IDUgKysrKysKPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQo+
IAo+IGRpZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlCj4gaW5kZXggNzgxMTg2ZS4uNTY1
OThkZiAxMDA2NDQKPiAtLS0gYS9NYWtlZmlsZQo+ICsrKyBiL01ha2VmaWxlCj4gQEAgLTc5LDgg
Kzc5LDEzIEBAICQoTElCRkRUX2FyY2hpdmUpOiAkKGFkZHByZWZpeCAkKExJQkZEVF9vYmpkaXIp
LywkKExJQkZEVF9PQkpTKSkKPiAgCSQoQVIpIHJjcyAkQCAkXgo+ICAKPiAgJS5vOiAlLlMKPiAr
CW1rZGlyIC1wICQoZGlyICRAKQoKU2hvdWxkIHRoaXMgdXNlIEAgZm9yIGNsZWFubGluZXNzPwoK
UGFvbG8KCj4gIAkkKENDKSAkKENGTEFHUykgLWMgLW5vc3RkbGliIC1vICRAICQ8Cj4gIAo+ICsl
Lm86ICUuYwo+ICsJbWtkaXIgLXAgJChkaXIgJEApCj4gKwkkKENDKSAkKENGTEFHUykgLWMgLW8g
JEAgJDwKPiArCj4gIC1pbmNsdWRlICovLiouZCAqLyovLiouZAo+ICAKPiAgYWxsOiAkKHNoZWxs
IGdpdCAtQyAkKFNSQ0RJUikgcmV2LXBhcnNlIC0tdmVyaWZ5IC0tc2hvcnQ9OCBIRUFEID5idWls
ZC1oZWFkIDI+L2Rldi9udWxsKQo+IApfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
