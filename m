From: Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH kvmtool 00/13] Implement reset of virtio devices
Date: Wed, 5 Dec 2018 09:21:11 +0100
Message-ID: <20181205082111.j6vxu7k7daxhgurw@sirius.home.kraxel.org>
References: <1543921726-54571-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 371B44A1FA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Dec 2018 03:21:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Pc5OFFr6Qfey for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Dec 2018 03:21:14 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 531CC4A1DF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Dec 2018 03:21:14 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1543921726-54571-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Thierry <julien.thierry@arm.com>
Cc: will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gVHVlLCBEZWMgMDQsIDIwMTggYXQgMTE6MDg6MzNBTSArMDAwMCwgSnVsaWVuIFRoaWVycnkg
d3JvdGU6Cj4gSGksCj4gCj4gVGhpcyBzZXJpZXMgd2FzIGRldmVsb3BwZWQgYnkgSmVhbi1QaGls
aXBwZSBhbmQgaXMgbmVlZGVkIGZvciBhIHNlcmllcwo+IEknbGwgYmUgcG9zdGluZyBzaG9ydGx5
IGFmdGVyIHRvIGxvYWQgZmlybXdhcmVzIG9uIGFybSBrdm10b29sLgo+IAo+IEN1cnJlbnRseSwg
d2hlbiBhIGd1ZXN0IHRyaWVzIHRvIHJlc2V0IGEgZGV2aWNlLCBhIGxvdCBvZiByZXNzb3VyY2Vz
Cj4gYXJlbid0IHJlc2V0ICh0aHJlYWRzIGtlZXAgcnVubmluZywgdmlydGlvIHF1ZXVlIGtlZXAg
dGhlaXIgc3RhdGUsIGV0YykuCj4gCj4gV2hlbiB0aGUgZ3Vlc3Qgb25seSBkb2VzIHRoZSByZXNl
dCB0byBpbml0aWFsaXplIHRoZSBkZXZpY2UgYW5kIHRoZXJlCj4gd2VyZSBubyBwcmV2aW91cyB1
c2VycywgdGhlcmUgaXMgbm8gbm90aWNlYWJsZSBpc3N1ZS4gQnV0IHdoZW4gYSBndWVzdAo+IGhh
cyBhIGZpcm1hcmUgKyBMaW51eCwgaWYgdGhlIGZpcm13YXJlIHVzZXMgYSB2aXJ0aW8gZGV2aWNl
LCBMaW51eCB3aWxsCj4gZmFpbCB0byBwcm9iZSB0aGF0IGRldmljZS4KPiAKPiBUaGlzIHNlcmll
cyBhaW0gdG8gcHJvcGVybHkgcmVzZXQgdGhlIHZpcnRpbyByZXNvdXJjZXMgd2hlbiB0aGUgZ3Vl
c3RzCj4gcmVxdWVzdHMgaXQuCj4gCj4gUmVzZXQgb2YgbmV0IHZob3N0IGlzIHVuc3VwcG9ydGVk
IGZvciBub3cuCj4gCj4gUGF0Y2ggMSBpcyBhIGJ1ZyBmaXggb24gaW9ldmVudGZkCj4gUGF0Y2gg
Mi02IHByb3ZpZGUgdGhlIGNvcmUgc3VwcG9ydCBzbyBkZXZpY2VzIGNhbiBpbXBsZW1lbnQgdGhl
aXIgcmVzZXQKPiBQYXRjaCA3LTEzIGltcGxlbWVudHMgdGhlIHJlc2V0IGZvciB0aGUgdmFyaW91
cyB2aXJ0aW8gZGV2aWNlcwoKRmFpbHMgdG8gYnVpbGQ6CgprcmF4ZWxAc2lyaXVzIH4vcHJvamVj
dHMva3ZtdG9vbCAodmlydGlvKSMgbWFrZSAKTWFrZWZpbGU6MzIzOiBTa2lwcGluZyBvcHRpb25h
bCBsaWJyYXJpZXM6IHZuY3NlcnZlcgogIENDICAgICAgIHZpcnRpby9jb3JlLm8KSW4gZmlsZSBp
bmNsdWRlZCBmcm9tIHZpcnRpby9jb3JlLmM6ODowOgp2aXJ0aW8vY29yZS5jOiBJbiBmdW5jdGlv
biDigJh2aXJ0aW9fbm90aWZ5X3N0YXR1c+KAmToKaW5jbHVkZS9rdm0vdmlydGlvLmg6Mzc6Mzog
ZXJyb3I6IOKAmFZJUlRJT19DT05GSUdfU19ORUVEU19SRVNFVOKAmQp1bmRlY2xhcmVkIChmaXJz
dCB1c2UgaW4gdGhpcyBmdW5jdGlvbikKICAgVklSVElPX0NPTkZJR19TX05FRURTX1JFU0VUIHwg
XAogICBeCnZpcnRpby9jb3JlLmM6MjMyOjE5OiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g
4oCYVklSVElPX0NPTkZJR19TX01BU0vigJkKICB2ZGV2LT5zdGF0dXMgJj0gflZJUlRJT19DT05G
SUdfU19NQVNLOwoKWWVzLCBpdCBpcyBhbiBvbGRlciBtYWNoaW5lIChyaGVsLTcpLCBWSVJUSU9f
Q09ORklHX1NfTkVFRFNfUkVTRVQgaXNuJ3QKaW4gdGhlIHN5c3RlbSBoZWFkZXJzIChJSVJDIHRo
aXMgYml0IHdhcyBhZGRlZCB3aXRoIHZpcnRpby0xLjApLgoKY2hlZXJzLAogIEdlcmQKCl9fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5n
IGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
