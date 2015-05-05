From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Fangu=C3=A8de?=
 <j.fanguede@virtualopensystems.com>
Subject: [RFC 0/4] arm/arm64: KVM: Get around cache incoherency
Date: Tue,  5 May 2015 11:13:43 +0200
Message-ID: <1430817227-6278-1-git-send-email-j.fanguede@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37FE14F8E8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2015 05:05:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zIq9NCkzFQRa for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2015 05:05:09 -0400 (EDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 32CBE4F8B7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2015 05:05:09 -0400 (EDT)
Received: by wizk4 with SMTP id k4so152033839wiz.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 May 2015 02:13:53 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org
Cc: tech@virtualopensystems.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

VGhpcyBSRkMgc2VyaWVzIHNob3dzIGhvdyB3ZSBjYW4gc29sdmUgY2FjaGUgaW5jb2hlbnJlbmN5
IGlzc3VlcyBvbgpBUk0vQVJNNjQuIFRoaXMgaW1wbGVtZW50YXRpb24gdXNlcyBhbiBpb2N0bCB0
aGF0IGZsdXNoZXMgdGhlIGRhdGEKY2FjaGUgZm9yIGEgZ2l2ZW4gcmFuZ2Ugb2YgdGhlIGd1ZXN0
IHBoeXNpY2FsIG1lbW9yeSwgdGhpcyBwb3NzaWJsZQpzb2x1dGlvbiB3YXMgYWxyZWFkeSBicm9h
Y2hlZCBpbiB0aGUgcHJldmlvdXMgZGlzY3Vzc2lvbiBbMV1bMl0uCgpFYWNoIGFjY2VzcyAocmVh
ZCBvciB3cml0ZSkgdG8gdGhlIGd1ZXN0IG1lbW9yeSB0aGF0IGNvdWxkIGxlYWQgdG8KaW5jb25z
aXN0ZW5jeSBpcyBmbHVzaGVkIGlmIG5lZWRlZC4gQSBsaWdodCBvcHRpbWl6YXRpb24gaXMgZG9u
ZSB0bwptaW5pbWl6ZSB0aGUgaW9jdGwgY2FsbC4KCkN1cnJlbnRseSB0ZXN0ZWQgd2l0aCB0aGUg
Zm9sbG93aW5nIGRldmljZXM6IGUxMDAwLCBtZWdhc2FzLApsc2k1M2M4OTVhLCBuZWMtdXNiLXho
Y2ksIHVzYi1laGNpICh3aXRoIHVzYi1ob3N0LCB1c2ItdGFibGV0LCB1c2Ita2JkCmFuZCB1c2It
bW91c2UpLCB3aGljaCB3ZXJlIGZhaWxsaW5nIHdpdGggS1ZNIGFuZCBub3cgd29yayBmaW5lIHdp
dGgKdGhpcyBwYXRjaC4KClRoZSBrZXJuZWwgbmVlZHMgdGhpcyBwYXRjaDogCltSRkNdIEFSTS9B
Uk02NDogS1ZNOiBJbXBsZW1lbnQgS1ZNX0ZMVVNIX0RDQUNIRV9HUEEgaW9jdGwKClsxXSBodHRw
czovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9waXBlcm1haWwva3ZtYXJtLzIwMTUtRmVicnVhcnkv
MDEzNTkzLmh0bWwKWzJdIGh0dHBzOi8vbGlzdHMubm9uZ251Lm9yZy9hcmNoaXZlL2h0bWwvcWVt
dS1kZXZlbC8yMDE1LTAzL21zZzAxMjU0Lmh0bWwKCkrDqXLDqW15IEZhbmd1w6hkZSAoNCk6CiAg
bGludXgtaGVhZGVycyB1cGRhdGUKICB0YXJnZXQtYXJtL2t2bTogRmx1c2ggZGF0YSBjYWNoZSBz
dXBwb3J0CiAga3ZtLWFsbDogUHJlLXJ1biBjYWNoZSBjb2hlcmVuY3kgbWFpbnRlbmFuY2UKICBl
eGVjOiBGbHVzaCBkYXRhIGNhY2hlIHdoZW4gbmVlZGVkCgogZXhlYy5jICAgICAgICAgICAgICAg
ICAgICB8IDE5ICsrKysrKysrKysrKysrKysrKwogaW5jbHVkZS9zeXNlbXUva3ZtLmggICAgICB8
ICAzICsrKwoga3ZtLWFsbC5jICAgICAgICAgICAgICAgICB8ICAxICsKIGxpbnV4LWhlYWRlcnMv
bGludXgva3ZtLmggfCAgNiArKysrKysKIHN0dWJzL2t2bS5jICAgICAgICAgICAgICAgfCAgOSAr
KysrKysrKysKIHRhcmdldC1hcm0va3ZtLmMgICAgICAgICAgfCA1MSArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwogNiBmaWxlcyBjaGFuZ2VkLCA4OSBpbnNl
cnRpb25zKCspCgotLSAKMS45LjEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlh
LmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFy
bQo=
