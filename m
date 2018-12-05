From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH kvmtool 00/13] Implement reset of virtio devices
Date: Wed, 5 Dec 2018 09:10:33 +0000
Message-ID: <8cc53cd8-1ab3-d7e1-6f21-e40a0447a0fd@arm.com>
References: <1543921726-54571-1-git-send-email-julien.thierry@arm.com>
 <20181205082111.j6vxu7k7daxhgurw@sirius.home.kraxel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C7A14A32B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Dec 2018 04:10:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Igl0J29ALelx for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Dec 2018 04:10:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26F684A1E5
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Dec 2018 04:10:37 -0500 (EST)
In-Reply-To: <20181205082111.j6vxu7k7daxhgurw@sirius.home.kraxel.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAwNS8xMi8xOCAwODoyMSwgR2VyZCBIb2ZmbWFubiB3cm90ZToKPiBPbiBUdWUsIERlYyAw
NCwgMjAxOCBhdCAxMTowODozM0FNICswMDAwLCBKdWxpZW4gVGhpZXJyeSB3cm90ZToKPj4gSGks
Cj4+Cj4+IFRoaXMgc2VyaWVzIHdhcyBkZXZlbG9wcGVkIGJ5IEplYW4tUGhpbGlwcGUgYW5kIGlz
IG5lZWRlZCBmb3IgYSBzZXJpZXMKPj4gSSdsbCBiZSBwb3N0aW5nIHNob3J0bHkgYWZ0ZXIgdG8g
bG9hZCBmaXJtd2FyZXMgb24gYXJtIGt2bXRvb2wuCj4+Cj4+IEN1cnJlbnRseSwgd2hlbiBhIGd1
ZXN0IHRyaWVzIHRvIHJlc2V0IGEgZGV2aWNlLCBhIGxvdCBvZiByZXNzb3VyY2VzCj4+IGFyZW4n
dCByZXNldCAodGhyZWFkcyBrZWVwIHJ1bm5pbmcsIHZpcnRpbyBxdWV1ZSBrZWVwIHRoZWlyIHN0
YXRlLCBldGMpLgo+Pgo+PiBXaGVuIHRoZSBndWVzdCBvbmx5IGRvZXMgdGhlIHJlc2V0IHRvIGlu
aXRpYWxpemUgdGhlIGRldmljZSBhbmQgdGhlcmUKPj4gd2VyZSBubyBwcmV2aW91cyB1c2Vycywg
dGhlcmUgaXMgbm8gbm90aWNlYWJsZSBpc3N1ZS4gQnV0IHdoZW4gYSBndWVzdAo+PiBoYXMgYSBm
aXJtYXJlICsgTGludXgsIGlmIHRoZSBmaXJtd2FyZSB1c2VzIGEgdmlydGlvIGRldmljZSwgTGlu
dXggd2lsbAo+PiBmYWlsIHRvIHByb2JlIHRoYXQgZGV2aWNlLgo+Pgo+PiBUaGlzIHNlcmllcyBh
aW0gdG8gcHJvcGVybHkgcmVzZXQgdGhlIHZpcnRpbyByZXNvdXJjZXMgd2hlbiB0aGUgZ3Vlc3Rz
Cj4+IHJlcXVlc3RzIGl0Lgo+Pgo+PiBSZXNldCBvZiBuZXQgdmhvc3QgaXMgdW5zdXBwb3J0ZWQg
Zm9yIG5vdy4KPj4KPj4gUGF0Y2ggMSBpcyBhIGJ1ZyBmaXggb24gaW9ldmVudGZkCj4+IFBhdGNo
IDItNiBwcm92aWRlIHRoZSBjb3JlIHN1cHBvcnQgc28gZGV2aWNlcyBjYW4gaW1wbGVtZW50IHRo
ZWlyIHJlc2V0Cj4+IFBhdGNoIDctMTMgaW1wbGVtZW50cyB0aGUgcmVzZXQgZm9yIHRoZSB2YXJp
b3VzIHZpcnRpbyBkZXZpY2VzCj4gCj4gRmFpbHMgdG8gYnVpbGQ6Cj4gCj4ga3JheGVsQHNpcml1
cyB+L3Byb2plY3RzL2t2bXRvb2wgKHZpcnRpbykjIG1ha2UgCj4gTWFrZWZpbGU6MzIzOiBTa2lw
cGluZyBvcHRpb25hbCBsaWJyYXJpZXM6IHZuY3NlcnZlcgo+ICAgQ0MgICAgICAgdmlydGlvL2Nv
cmUubwo+IEluIGZpbGUgaW5jbHVkZWQgZnJvbSB2aXJ0aW8vY29yZS5jOjg6MDoKPiB2aXJ0aW8v
Y29yZS5jOiBJbiBmdW5jdGlvbiDigJh2aXJ0aW9fbm90aWZ5X3N0YXR1c+KAmToKPiBpbmNsdWRl
L2t2bS92aXJ0aW8uaDozNzozOiBlcnJvcjog4oCYVklSVElPX0NPTkZJR19TX05FRURTX1JFU0VU
4oCZCj4gdW5kZWNsYXJlZCAoZmlyc3QgdXNlIGluIHRoaXMgZnVuY3Rpb24pCj4gICAgVklSVElP
X0NPTkZJR19TX05FRURTX1JFU0VUIHwgXAo+ICAgIF4KPiB2aXJ0aW8vY29yZS5jOjIzMjoxOTog
bm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmFZJUlRJT19DT05GSUdfU19NQVNL4oCZCj4g
ICB2ZGV2LT5zdGF0dXMgJj0gflZJUlRJT19DT05GSUdfU19NQVNLOwo+IAo+IFllcywgaXQgaXMg
YW4gb2xkZXIgbWFjaGluZSAocmhlbC03KSwgVklSVElPX0NPTkZJR19TX05FRURTX1JFU0VUIGlz
bid0Cj4gaW4gdGhlIHN5c3RlbSBoZWFkZXJzIChJSVJDIHRoaXMgYml0IHdhcyBhZGRlZCB3aXRo
IHZpcnRpby0xLjApLgo+IAoKVGhhbmtzIGZvciByZXBvcnRpbmcgdGhlIGlzc3VlLiBJIHRoaW5r
IHRoaXMgc2VyaWVzIHdhcyBpbml0aWFsbHkKZGV2ZWxvcGVkIHdpdGggdGhlIGludGVudCBvZiBz
dXBwb3J0aW5nIHZpcnRpby0xLjAgYnV0IHRoZW4gcmVzZXQgYW5kCnZpcnRpby0xLjAgd2VyZSBz
cGxpdCBpbnRvIHR3byBzZXJpZXMuCgpJIHRoaW5rIGhlcmUgSSBjYW4ganVzdCByZW1vdmUgdGhh
dCBiaXQgZnJvbSB0aGUgY29uZmlnIG1hc2sgd2hpbGUKdmlydGlvLTEuMCBpcyBub3Qgc3VwcG9y
dGVkLCBhbmQgdGhpbmdzIHNob3VsZCB3b3JrLgoKVGhhbmtzLAoKLS0gCkp1bGllbiBUaGllcnJ5
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
