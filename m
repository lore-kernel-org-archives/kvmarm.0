From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC v7 2/7] KVM: kvm_host: add devid in
 kvm_kernel_irq_routing_entry
Date: Thu, 21 Jul 2016 22:47:54 +0200
Message-ID: <de7c204f-65ba-b774-d5d6-57f45b77bde9@redhat.com>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
 <1468848357-2331-3-git-send-email-eric.auger@redhat.com>
 <20160721161328.GC32739@potion> <5790FE42.103@arm.com>
 <20160721172239.GA9019@potion> <5791059C.70700@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE7FE49B35
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2016 16:41:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7bZSYfaf6pyo for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jul 2016 16:41:44 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9748449B34
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jul 2016 16:41:44 -0400 (EDT)
In-Reply-To: <5791059C.70700@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

SGksCgpPbiAyMS8wNy8yMDE2IDE5OjI1LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gMjEvMDcv
MTYgMTg6MjIsIFJhZGltIEtyxI1tw6HFmSB3cm90ZToKPj4gMjAxNi0wNy0yMSAxNzo1NCswMTAw
LCBNYXJjIFp5bmdpZXI6Cj4+PiBPbiAyMS8wNy8xNiAxNzoxMywgUmFkaW0gS3LEjW3DocWZIHdy
b3RlOgo+Pj4+IDIwMTYtMDctMTggMTM6MjUrMDAwMCwgRXJpYyBBdWdlcjoKPj4+Pj4gRXh0ZW5k
IGt2bV9rZXJuZWxfaXJxX3JvdXRpbmdfZW50cnkgdG8gdHJhbnNwb3J0IHRoZSBkZXZpY2UgaWQK
Pj4+Pj4gZmllbGQsIGRldmlkLiBBIG5ldyBmbGFncyBmaWVsZCBtYWtlcyBwb3NzaWJsZSB0byBp
bmRpY2F0ZSB0aGUKPj4+Pj4gZGV2aWQgaXMgdmFsaWQuIFRob3NlIGFkZGl0aW9ucyBhcmUgdXNl
ZCBmb3IgQVJNIEdJQ3YzIElUUyBNU0kKPj4+Pj4gaW5qZWN0aW9uLgo+Pj4+Pgo+Pj4+PiBTaWdu
ZWQtb2ZmLWJ5OiBFcmljIEF1Z2VyIDxlcmljLmF1Z2VyQHJlZGhhdC5jb20+Cj4+Pj4+IEFja2Vk
LWJ5OiBDaHJpc3RvZmZlciBEYWxsIDxjaHJpc3RvZmZlci5kYWxsQGxpbmFyby5vcmc+Cj4+Pj4+
Cj4+Pj4+IC0tLQo+Pj4+PiB2NiAtPiB2NzoKPj4+Pj4gLSBhZGRlZCBtc2lfIHByZWZpeCB0byBm
bGFncyBhbmQgZGV2X2lkIGZpZWxkcwo+Pj4+Pgo+Pj4+PiB2NCAtPiB2NToKPj4+Pj4gLSBhZGQg
Q2hyaXN0b2ZmZXIncyBSLWIKPj4+Pj4KPj4+Pj4gdjIgLT4gdjM6Cj4+Pj4+IC0gYWRkIGZsYWdz
Cj4+Pj4+Cj4+Pj4+IHYxIC0+IHYyOgo+Pj4+PiAtIHJlcGxhY2UgbXNpX21zZyBmaWVsZCBieSBh
IHN0cnVjdCBjb21wb3NlZCBvZiBtc2lfbXNnIGFuZCBkZXZpZAo+Pj4+Pgo+Pj4+PiBSRkMgLT4g
UEFUQ0g6Cj4+Pj4+IC0gcmV3b3JkIHRoZSBjb21taXQgbWVzc2FnZSBhZnRlciBjaGFuZ2UgaW4g
Zmlyc3QgcGF0Y2ggKHVhcGkpCj4+Pj4+IC0tLQo+Pj4+PiAgaW5jbHVkZS9saW51eC9rdm1faG9z
dC5oIHwgNiArKysrKy0KPj4+Pj4gIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkKPj4+Pj4KPj4+Pj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgva3ZtX2hv
c3QuaCBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaAo+Pj4+PiBpbmRleCBjODdmZTZmLi4zZDJj
YmI0IDEwMDY0NAo+Pj4+PiAtLS0gYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKPj4+Pj4gKysr
IGIvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oCj4+Pj4+IEBAIC0zMTcsNyArMzE3LDExIEBAIHN0
cnVjdCBrdm1fa2VybmVsX2lycV9yb3V0aW5nX2VudHJ5IHsKPj4+Pj4gIAkJCXVuc2lnbmVkIGly
cWNoaXA7Cj4+Pj4+ICAJCQl1bnNpZ25lZCBwaW47Cj4+Pj4+ICAJCX0gaXJxY2hpcDsKPj4+Pj4g
LQkJc3RydWN0IG1zaV9tc2cgbXNpOwo+Pj4+PiArCQlzdHJ1Y3Qgewo+Pj4+PiArCQkJc3RydWN0
IG1zaV9tc2cgbXNpOwo+Pj4+PiArCQkJdTMyIG1zaV9mbGFnczsKPj4+Pj4gKwkJCXUzMiBtc2lf
ZGV2aWQ7Cj4+Pj4KPj4+PiBJJ2QgbXVjaCByYXRoZXIgc2VlIHRoZW0gYXMgbXNpLmZsYWdzIGFu
ZCBtc2kuZGV2aWQuCj4+Pgo+Pj4gVGhhdCdzIG5vdCByZWFsbHkgcG9zc2libGUsIGFzIG1zaV9t
c2cgaXMgdGhlIGNvcmUgZGF0YSBzdHJ1Y3R1cmUgZm9yCj4+PiBNU0lzLCBhbmQgbm9ib2R5IHJl
YWxseSBleHBlY3RzIHRoaXMgdHJ1Y3R1cmUgdG8gY2hhbmdlLgo+Pj4KPj4+PiBJIGRpZG4ndCBu
b3RpY2UgYSBjb2RlIHRoYXQgcGFzc2VzIHN0cnVjdCBtc2lfbXNnIGFueXdoZXJlLCBzbyB1c2lu
ZyBhbgo+Pj4+IGFkLWhvYyBzdHJ1Y3QgbGlrZSBpcnFjaGlwIG9yIGRlZmluaW5nIGEgbmV3IG9u
ZSB3b3VsZCB3b3JrIGZpbmUuCj4+Pgo+Pj4gSSBndWVzcyB3ZSBjb3VsZCBoYXZlIGFuIGFybS1z
cGVjaWZpYyBvbmU6Cj4+Pgo+Pj4gCQlzdHJ1Y3QgYXJtX21zaSB7Cj4+PiAJCQlzdHJ1Y3QgbXNp
X21zZyBtc2c7Cj4+PiAJCQl1MzIgZmxhZ3M7Cj4+PiAJCQl1MzIgZGV2aWQ7Cj4+PiAJCX07Cj4+
Pgo+Pj4gYW5kIHVzZSB0aGF0LiBXb3VsZCB0aGF0IGJlIE9LIHdpdGggeW91Pwo+Pgo+PiBUaGUg
ZmVhdHVyZSB3YW50cyB0byBiZSBhcmNoLW5ldXRyYWwsIHNvIEkgd291bGQgcmF0aGVyIGlnbm9y
ZSBzdHJ1Y3QKPj4gbXNpX21zZy4gIGt2bV9rZXJuZWxfaXJxX3JvdXRpbmdfZW50cnkgcHJhY3Rp
Y2FsbHkgbWlycm9ycyByb3V0aW5nCj4+IGVudHJpZXMgZnJvbSBLVk0gQVBJIGFuZCB0aGVyZSB3
ZSBoYXZlOgo+Pgo+PiAgIHN0cnVjdCBrdm1fbXNpIHsKPj4gICAJX191MzIgYWRkcmVzc19sbzsK
Pj4gICAJX191MzIgYWRkcmVzc19oaTsKPj4gICAJX191MzIgZGF0YTsKPj4gICAJX191MzIgZmxh
Z3M7Cj4+ICAgCV9fdTMyIGRldmlkOwo+PiAgIAlfX3U4ICBwYWRbMTJdOwo+PiAgIH07Cj4+Cj4+
IEkgdGhpbmsgdGhhdCBzb21ldGhpbmcgbGlrZQo+Pgo+PiAgIHN0cnVjdCB7Cj4+ICAgCXUzMiBh
ZGRyZXNzX2xvOwo+PiAgIAl1MzIgYWRkcmVzc19oaTsKPj4gICAJdTMyIGRhdGE7Cj4+ICAgCXUz
MiBmbGFnczsKPj4gICAJdTMyIGRldmlkOwo+PiAgIH0gbXNpOwo+Pgo+PiB3b3VsZCBnZXQgdXMg
Y29uc2lzdGVuY3ksIG1pbmltYWwgY2hhbmdlcyB0byBleGlzdGluZyBjb2RlLCBubyBuYW1lc3Bh
Y2UKPj4gaGllcmFyY2h5LCBhbmQgbm8gIi4iIHZzICJfIiBtaXN0YWtlcyBhdCBhIGdvb2QgcHJp
Y2Ugb2Ygc29tZSBjb2RlCj4+IGR1cGxpY2F0aW9uIGFuZCBjb25jZXB0IHNlcGFyYXRpb24uCj4g
Cj4gRmFpciBlbm91Z2guIEVyaWMsIGNhbiB5b3UgZ2l2ZSB0aGlzIGEgdHJ5PwpZZXMgSSB3aWxs
IHJlc3BpbiBxdWlja2x5IHJlcGxhY2luZyB0aGUgc3RydWN0IG1zaV9tc2cgbXNpIGJ5IHRoZSBz
dHJ1Y3QKcHJvcG9zZWQgYnkgUmFkaW0uCgpUaGFua3MKCkVyaWMKPiAKPiBUaGFua3MsCj4gCj4g
CU0uCj4gCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
