From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v9 3/6] target-arm: kvm - support for single step
Date: Tue, 08 Dec 2015 11:49:49 +0000
Message-ID: <87r3ixp3c2.fsf@linaro.org>
References: <1447345251-22625-1-git-send-email-alex.bennee@linaro.org>
 <1447345251-22625-4-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA-YQ384sY1OWLaV9YAjzTZSyWqVLHx2moH-sCa+O6FvOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 225E04113E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 06:48:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3pFbincrENq5 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2015 06:48:02 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B88240B40
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 06:48:02 -0500 (EST)
Received: by wmww144 with SMTP id w144so177772634wmw.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Dec 2015 03:49:51 -0800 (PST)
In-reply-to: <CAFEAcA-YQ384sY1OWLaV9YAjzTZSyWqVLHx2moH-sCa+O6FvOw@mail.gmail.com>
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
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, qemu-arm@nongnu.org, Zhichao Huang <zhichao.huang@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

ClBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9yZz4gd3JpdGVzOgoKPiBPbiAx
MiBOb3ZlbWJlciAyMDE1IGF0IDE2OjIwLCBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFy
by5vcmc+IHdyb3RlOgo+PiBUaGlzIGFkZHMgc3VwcG9ydCBmb3Igc2luZ2xlLXN0ZXAuIFRoZXJl
IGlzbid0IG11Y2ggdG8gZG8gb24gdGhlIFFFTVUKPj4gc2lkZSBhcyBhZnRlciB3ZSBzZXQtdXAg
dGhlIHJlcXVlc3QgZm9yIHNpbmdsZSBzdGVwIHZpYSB0aGUgZGVidWcgaW9jdGwKPj4gaXQgaXMg
YWxsIGhhbmRsZWQgd2l0aGluIHRoZSBrZXJuZWwuCj4+Cj4+IFNpZ25lZC1vZmYtYnk6IEFsZXgg
QmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KPj4KPj4gLS0tCj4+IHYyCj4+ICAgLSBj
b252ZXJ0IHRvIHVzaW5nIEhTUl9FQwo+PiB2Mwo+PiAgIC0gdXNlIGludGVybmFscy5oIGRlZmlu
aXRpb25zCj4+IC0tLQo+PiAgdGFyZ2V0LWFybS9rdm0uYyB8IDEwICsrKysrKysrKysKPj4gIDEg
ZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspCj4+Cj4+IGRpZmYgLS1naXQgYS90YXJnZXQt
YXJtL2t2bS5jIGIvdGFyZ2V0LWFybS9rdm0uYwo+PiBpbmRleCA1MGY3MGVmLi5kNTA1YTdlIDEw
MDY0NAo+PiAtLS0gYS90YXJnZXQtYXJtL2t2bS5jCj4+ICsrKyBiL3RhcmdldC1hcm0va3ZtLmMK
Pj4gQEAgLTUzNSw2ICs1MzUsMTMgQEAgc3RhdGljIGludCBrdm1faGFuZGxlX2RlYnVnKENQVVN0
YXRlICpjcywgc3RydWN0IGt2bV9ydW4gKnJ1bikKPj4gICAgICBrdm1fY3B1X3N5bmNocm9uaXpl
X3N0YXRlKGNzKTsKPj4KPj4gICAgICBzd2l0Y2ggKGhzcl9lYykgewo+PiArICAgIGNhc2UgRUNf
U09GVFdBUkVTVEVQOgo+PiArICAgICAgICBpZiAoY3MtPnNpbmdsZXN0ZXBfZW5hYmxlZCkgewo+
PiArICAgICAgICAgICAgcmV0dXJuIHRydWU7Cj4+ICsgICAgICAgIH0gZWxzZSB7Cj4+ICsgICAg
ICAgICAgICBlcnJvcl9yZXBvcnQoIkNhbWUgb3V0IG9mIFNJTkdMRSBTVEVQIHdoZW4gbm90IGVu
YWJsZWQiKTsKPj4gKyAgICAgICAgfQo+PiArICAgICAgICBicmVhazsKPj4gICAgICBjYXNlIEVD
X0FBNjRfQktQVDoKPj4gICAgICAgICAgaWYgKGt2bV9maW5kX3N3X2JyZWFrcG9pbnQoY3MsIGVu
di0+cGMpKSB7Cj4+ICAgICAgICAgICAgICByZXR1cm4gdHJ1ZTsKPj4gQEAgLTU5NSw2ICs2MDIs
OSBAQCBpbnQga3ZtX2FyY2hfb25fc2lnYnVzKGludCBjb2RlLCB2b2lkICphZGRyKQo+Pgo+PiAg
dm9pZCBrdm1fYXJjaF91cGRhdGVfZ3Vlc3RfZGVidWcoQ1BVU3RhdGUgKmNzLCBzdHJ1Y3Qga3Zt
X2d1ZXN0X2RlYnVnICpkYmcpCj4+ICB7Cj4+ICsgICAgaWYgKGNzLT5zaW5nbGVzdGVwX2VuYWJs
ZWQpIHsKPj4gKyAgICAgICAgZGJnLT5jb250cm9sIHw9IEtWTV9HVUVTVERCR19FTkFCTEUgfCBL
Vk1fR1VFU1REQkdfU0lOR0xFU1RFUDsKPj4gKyAgICB9Cj4KPiBEb2Vzbid0IGt2bV91cGRhdGVf
Z3Vlc3RfZGVidWcoKSBhbHJlYWR5IHNldCB0aGVzZSBiaXRzLCBvciBhbQo+IEkgbWlzcmVhZGlu
ZyBpdD8KClllYWguIFRoaXMgcmFpc2VzIGFuIGludGVyZXN0aW5nIHByb2JsZW0gYWJvdXQgd2hh
dCB0byBkbyB3aGVuIHdlIGRvbid0CmhhdmUgdGhlIGNhcGFiaWxpdHkuIEkgY291bGQgc3VwcHJl
c3MgdGhvc2UgYml0cyBpbiB0aGUgdXBkYXRlIGZ1bmN0aW9uCmJ1dCB0aGF0IHNlZW1zIGEgYml0
IGhhY2t5LgoKTG9va2luZyBhdCB0aGUgR0RCIGNhcGFiaWxpdHkgY29kZSB0aGVyZSBkb2Vzbid0
IHNlZW0gdG8gcmVwb3J0CmJyZWFrcG9pbnQgY2FwYWJpbGl0eSBzaG9ydCBvZiBqdXN0IGZhaWxp
bmcgd2hlbiB5b3UgdHJ5IHRvIHNldCBvbmUuCgo+Cj4+ICAgICAgaWYgKGt2bV9zd19icmVha3Bv
aW50c19hY3RpdmUoY3MpKSB7Cj4+ICAgICAgICAgIGRiZy0+Y29udHJvbCB8PSBLVk1fR1VFU1RE
QkdfRU5BQkxFIHwgS1ZNX0dVRVNUREJHX1VTRV9TV19CUDsKPj4gICAgICB9Cj4+IC0tCj4+IDIu
Ni4zCj4KPiB0aGFua3MKPiAtLSBQTU0KCgotLQpBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1h
cm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21h
aWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
