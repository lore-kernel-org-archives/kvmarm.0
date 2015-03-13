From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2 1/6] target-arm: kvm: save/restore mp state
Date: Fri, 13 Mar 2015 10:40:51 +0000
Message-ID: <87h9tpb2oc.fsf@linaro.org>
References: <1425479753-18349-1-git-send-email-alex.bennee@linaro.org>
 <1425479753-18349-2-git-send-email-alex.bennee@linaro.org>
 <CAFEAcA-286NkXcSAtRpB-_UEAszSg_Fawc-7pa+OXDY8NupYhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 62E7248988
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 06:34:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XJjuqijZCp17 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Mar 2015 06:34:13 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61F2948959
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Mar 2015 06:34:13 -0400 (EDT)
In-reply-to: <CAFEAcA-286NkXcSAtRpB-_UEAszSg_Fawc-7pa+OXDY8NupYhA@mail.gmail.com>
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
Cc: kvm-devel <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, QEMU Developers <qemu-devel@nongnu.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

ClBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9yZz4gd3JpdGVzOgoKPiBPbiA0
IE1hcmNoIDIwMTUgYXQgMTQ6MzUsIEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9y
Zz4gd3JvdGU6Cj4+IFRoaXMgYWRkcyB0aGUgc2F2aW5nIGFuZCByZXN0b3JlIG9mIHRoZSBjdXJy
ZW50IE11bHRpLVByb2Nlc3Npbmcgc3RhdGUKPj4gb2YgdGhlIG1hY2hpbmUuIFdoaWxlIHRoZSBL
Vk1fR0VUL1NFVF9NUF9TVEFURSBBUEkgZXhwb3NlcyBhIG51bWJlciBvZgo+PiBwb3RlbnRpYWwg
c3RhdGVzIGZvciB4ODYgd2Ugb25seSB1c2UgdHdvIGZvciBBUk0uIEVpdGhlciB0aGUgcHJvY2Vz
cyBpcwo+PiBydW5uaW5nIG9yIG5vdC4gV2UgdGhlbiBzYXZlIHRoaXMgc3RhdGUgaW50byB0aGUg
Y3B1X3Bvd2VyZWQgVENHIHN0YXRlCj4+IHRvIGF2b2lkIGNoYW5naW5nIHRoZSBzZXJpYWxpc2F0
aW9uIGZvcm1hdC4KPj4KPj4gU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5l
ZUBsaW5hcm8ub3JnPgo+Pgo+PiAtLS0KPj4gdjIKPj4gICAtIG1ha2UgbXBzdGF0ZSBmaWVsZCBy
dW50aW1lIGRlcGVuZGFudCAoa3ZtX2VuYWJsZWQoKSkKPj4gICAtIGRyb3AgaW5pdGlhbCBLVk1f
Q0FQX01QX1NUQVRFIHJlcXVpcmVtZW50Cj4+ICAgLSByZS11c2UgY3B1X3Bvd2VyZWQgaW5zdGVh
ZCBvZiBuZXcgZmllbGQKPj4KPj4gZGlmZiAtLWdpdCBhL3RhcmdldC1hcm0vbWFjaGluZS5jIGIv
dGFyZ2V0LWFybS9tYWNoaW5lLmMKPj4gaW5kZXggOTQ0NmU1YS4uMTg1ZjlhMiAxMDA2NDQKPj4g
LS0tIGEvdGFyZ2V0LWFybS9tYWNoaW5lLmMKPj4gKysrIGIvdGFyZ2V0LWFybS9tYWNoaW5lLmMK
Pj4gQEAgLTE2MSw2ICsxNjEsNyBAQCBzdGF0aWMgY29uc3QgVk1TdGF0ZUluZm8gdm1zdGF0ZV9j
cHNyID0gewo+PiAgICAgIC5wdXQgPSBwdXRfY3BzciwKPj4gIH07Cj4+Cj4+ICsKPj4gIHN0YXRp
YyB2b2lkIGNwdV9wcmVfc2F2ZSh2b2lkICpvcGFxdWUpCj4+ICB7Cj4+ICAgICAgQVJNQ1BVICpj
cHUgPSBvcGFxdWU7Cj4+IEBAIC0xNzAsNiArMTcxLDIwIEBAIHN0YXRpYyB2b2lkIGNwdV9wcmVf
c2F2ZSh2b2lkICpvcGFxdWUpCj4+ICAgICAgICAgICAgICAvKiBUaGlzIHNob3VsZCBuZXZlciBm
YWlsICovCj4+ICAgICAgICAgICAgICBhYm9ydCgpOwo+PiAgICAgICAgICB9Cj4+ICsjaWYgZGVm
aW5lZCBDT05GSUdfS1ZNCj4+ICsgICAgICAgIGlmIChrdm1fY2hlY2tfZXh0ZW5zaW9uKENQVShj
cHUpLT5rdm1fc3RhdGUsIEtWTV9DQVBfTVBfU1RBVEUpKSB7Cj4+ICsgICAgICAgICAgICBzdHJ1
Y3Qga3ZtX21wX3N0YXRlIG1wX3N0YXRlOwo+PiArICAgICAgICAgICAgaW50IHJldCA9IGt2bV92
Y3B1X2lvY3RsKENQVShjcHUpLCBLVk1fR0VUX01QX1NUQVRFLCAmbXBfc3RhdGUpOwo+PiArICAg
ICAgICAgICAgaWYgKHJldCkgewo+PiArICAgICAgICAgICAgICAgIGZwcmludGYoc3RkZXJyLCAi
JXM6IGZhaWxlZCB0byBnZXQgTVBfU1RBVEUgJWQvJXNcbiIsCj4+ICsgICAgICAgICAgICAgICAg
ICAgICAgICBfX2Z1bmNfXywgcmV0LCBzdHJlcnJvcihyZXQpKTsKPj4gKyAgICAgICAgICAgICAg
ICBhYm9ydCgpOwo+PiArICAgICAgICAgICAgfQo+PiArICAgICAgICAgICAgY3B1LT5wb3dlcmVk
X29mZiA9Cj4+ICsgICAgICAgICAgICAgICAgKG1wX3N0YXRlLm1wX3N0YXRlID09IEtWTV9NUF9T
VEFURV9SVU5OQUJMRSkKPj4gKyAgICAgICAgICAgICAgICA/IGZhbHNlIDogdHJ1ZTsKPgo+IFRl
cm5hcnkgb3BlcmF0b3IgdG8gcHJvZHVjZSBhIHRydWUtb3ItZmFsc2UgcmVzdWx0IGlzIGEgYml0
Cj4gcmVkdW5kYW50Li4uCj4KPj4gKyAgICAgICAgfQo+PiArI2VuZGlmCj4KPiBXaHkgaXMgdGhp
cyBpbiBwcmUtc2F2ZS9wb3N0LWxvYWQgcmF0aGVyIHRoYW4gaW4gdGhlCj4ga3ZtX2FyY2hfZ2V0
L3B1dF9yZWdpc3RlcnMgZnVuY3Rpb25zIGxpa2UgYWxsIHRoZSBvdGhlcgo+IHN5bmNpbmcgY29k
ZT8KClllYWggdGhlICNpZmRlZnMgc2hvdWxkIGhhdmUgd2F2ZWQgdGhlIHJlZCBmbGFnIC0gSSds
bCBtb3ZlIGl0IDstKQoKPgo+IC0tIFBNTQoKLS0gCkFsZXggQmVubsOpZQpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
