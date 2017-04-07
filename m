From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [RFC kvm-unit-tests PATCH 4/8] Makefiles: use explicit path for
 including sub-Makefiles
Date: Fri, 07 Apr 2017 10:21:27 +0100
Message-ID: <87mvbsa7zc.fsf@linaro.org>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
 <20170406190727.5624-5-alex.bennee@linaro.org>
 <7f6fe583-a765-b8cd-d1f6-5068ee5d52e0@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 050D340C41
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 05:19:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YOhYlGWvJAin for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Apr 2017 05:19:08 -0400 (EDT)
Received: from mail-wr0-f175.google.com (mail-wr0-f175.google.com
 [209.85.128.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E711240C21
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Apr 2017 05:19:07 -0400 (EDT)
Received: by mail-wr0-f175.google.com with SMTP id c55so24877108wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 07 Apr 2017 02:21:24 -0700 (PDT)
In-reply-to: <7f6fe583-a765-b8cd-d1f6-5068ee5d52e0@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Thomas Huth <thuth@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

ClRob21hcyBIdXRoIDx0aHV0aEByZWRoYXQuY29tPiB3cml0ZXM6Cgo+IE9uIDA2LjA0LjIwMTcg
MjE6MDcsIEFsZXggQmVubsOpZSB3cm90ZToKPj4gSSB3b3VsZCBvZiB0aG91Z2h0IFZQQVRIIHRv
b2sgY2FyZSBvZiB0aGlzIGJ1dCBhcHBhcmVudGx5IG5vdC4KPj4KPj4gU2lnbmVkLW9mZi1ieTog
QWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgo+PiAtLS0KPj4gIE1ha2VmaWxl
ICAgICAgICAgICAgICAgfCA4ICsrKystLS0tCj4+ICBhcm0vTWFrZWZpbGUgICAgICAgICAgIHwg
MiArLQo+PiAgYXJtL01ha2VmaWxlLmFybSAgICAgICB8IDIgKy0KPj4gIGFybS9NYWtlZmlsZS5h
cm02NCAgICAgfCAyICstCj4+ICBwb3dlcnBjL01ha2VmaWxlICAgICAgIHwgMiArLQo+PiAgcG93
ZXJwYy9NYWtlZmlsZS5wcGM2NCB8IDIgKy0KPj4gIHg4Ni9NYWtlZmlsZSAgICAgICAgICAgfCAy
ICstCj4+ICB4ODYvTWFrZWZpbGUuaTM4NiAgICAgIHwgMiArLQo+PiAgeDg2L01ha2VmaWxlLng4
Nl82NCAgICB8IDIgKy0KPj4gIDkgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMTIg
ZGVsZXRpb25zKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlCj4+IGlu
ZGV4IDgwYmM1N2UuLjc4MTE4NmUgMTAwNjQ0Cj4+IC0tLSBhL01ha2VmaWxlCj4+ICsrKyBiL01h
a2VmaWxlCj4+IEBAIC0zMiwxNCArMzIsMTQgQEAgY2ZsYXRvYmpzIDo9IFwKPj4gIAlsaWIvc3Rh
Y2subwo+Pgo+PiAgIyBsaWJmZHQgcGF0aHMKPj4gLUxJQkZEVF9vYmpkaXIgPSBsaWIvbGliZmR0
Cj4+IC1MSUJGRFRfc3JjZGlyID0gbGliL2xpYmZkdAo+PiArTElCRkRUX29iamRpciA9ICQoU1JD
RElSKS9saWIvbGliZmR0Cj4KPiBJIHRoaW5rIHRoaXMgaXMgd3JvbmcgLSBvYmpkaXIgc2hvdWxk
IG5vdCBnZXQgYSBTUkNESVIgcHJlZml4LgoKR29vZCBjYXRjaCAtIHdoaWNoIGV4cGxhaW5zIHdo
eSBJIHdhcyBzZWVpbmcgbGliZmR0LmEgaW4gdGhlIHNvdXJjZSB0cmVlLgoKLS0KQWxleCBCZW5u
w6llCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFy
bSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3Rz
LmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
