From: Thomas Huth <thuth@redhat.com>
Subject: Re: [RFC kvm-unit-tests PATCH 4/8] Makefiles: use explicit path for
 including sub-Makefiles
Date: Fri, 7 Apr 2017 10:53:01 +0200
Message-ID: <7f6fe583-a765-b8cd-d1f6-5068ee5d52e0@redhat.com>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
 <20170406190727.5624-5-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E699440C41
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 04:50:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i8XR2hfZsYGQ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Apr 2017 04:50:49 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 12FAE40C2A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 04:50:48 -0400 (EDT)
In-Reply-To: <20170406190727.5624-5-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, drjones@redhat.com, pbonzini@redhat.com
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

T24gMDYuMDQuMjAxNyAyMTowNywgQWxleCBCZW5uw6llIHdyb3RlOgo+IEkgd291bGQgb2YgdGhv
dWdodCBWUEFUSCB0b29rIGNhcmUgb2YgdGhpcyBidXQgYXBwYXJlbnRseSBub3QuCj4gCj4gU2ln
bmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgo+IC0tLQo+
ICBNYWtlZmlsZSAgICAgICAgICAgICAgIHwgOCArKysrLS0tLQo+ICBhcm0vTWFrZWZpbGUgICAg
ICAgICAgIHwgMiArLQo+ICBhcm0vTWFrZWZpbGUuYXJtICAgICAgIHwgMiArLQo+ICBhcm0vTWFr
ZWZpbGUuYXJtNjQgICAgIHwgMiArLQo+ICBwb3dlcnBjL01ha2VmaWxlICAgICAgIHwgMiArLQo+
ICBwb3dlcnBjL01ha2VmaWxlLnBwYzY0IHwgMiArLQo+ICB4ODYvTWFrZWZpbGUgICAgICAgICAg
IHwgMiArLQo+ICB4ODYvTWFrZWZpbGUuaTM4NiAgICAgIHwgMiArLQo+ICB4ODYvTWFrZWZpbGUu
eDg2XzY0ICAgIHwgMiArLQo+ICA5IGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDEy
IGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlCj4gaW5k
ZXggODBiYzU3ZS4uNzgxMTg2ZSAxMDA2NDQKPiAtLS0gYS9NYWtlZmlsZQo+ICsrKyBiL01ha2Vm
aWxlCj4gQEAgLTMyLDE0ICszMiwxNCBAQCBjZmxhdG9ianMgOj0gXAo+ICAJbGliL3N0YWNrLm8K
PiAgCj4gICMgbGliZmR0IHBhdGhzCj4gLUxJQkZEVF9vYmpkaXIgPSBsaWIvbGliZmR0Cj4gLUxJ
QkZEVF9zcmNkaXIgPSBsaWIvbGliZmR0Cj4gK0xJQkZEVF9vYmpkaXIgPSAkKFNSQ0RJUikvbGli
L2xpYmZkdAoKSSB0aGluayB0aGlzIGlzIHdyb25nIC0gb2JqZGlyIHNob3VsZCBub3QgZ2V0IGEg
U1JDRElSIHByZWZpeC4KCiBUaG9tYXMKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
