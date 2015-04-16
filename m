From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: ARM: PCI devices emulation broken with KVM due to cache issue
Date: Thu, 16 Apr 2015 18:02:27 +0200
Message-ID: <552FDD13.4090006@redhat.com>
References: <CAGE1QJoXVDP_O0W9dRCsN+FBW3BEYn5gqiCvGh07CfadNp2kHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EA8E4DD01
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2015 11:54:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8MaBXTdHlkbQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2015 11:54:37 -0400 (EDT)
Received: from mail-wi0-f181.google.com (mail-wi0-f181.google.com
 [209.85.212.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7A4464DCFE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2015 11:54:37 -0400 (EDT)
Received: by wiun10 with SMTP id n10so102871984wiu.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2015 09:02:32 -0700 (PDT)
In-Reply-To: <CAGE1QJoXVDP_O0W9dRCsN+FBW3BEYn5gqiCvGh07CfadNp2kHw@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?B?SsOpcsOpbXkgRmFuZ3XDqGRl?= <j.fanguede@virtualopensystems.com>, QEMU Developers <qemu-devel@nongnu.org>
Cc: VirtualOpenSystems Technical Team <tech@virtualopensystems.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

CgpPbiAxNi8wNC8yMDE1IDE3OjU0LCBKw6lyw6lteSBGYW5ndcOoZGUgd3JvdGU6Cj4gVGhlIGd1
ZXN0IGtlcm5lbCBkcml2ZXIgb2YgdGhlIGxzaSBkZXZpY2UgZmFpbHMgdG8gZW5hYmxlIGl0IGNv
cnJlY3RseQo+IHdpdGggYSBjYWNoZSBlcnJvcjoKPiBbLi4uXQo+IHN5bTUzYzh4eCAwMDAwOjAw
OjAxLjA6IGVuYWJsaW5nIGRldmljZSAoMDEwMCAtPiAwMTAzKQo+IHN5bTA6IDw4OTVhPiByZXYg
MHgwIGF0IHBjaSAwMDAwOjAwOjAxLjAgaXJxIDU0Cj4gc3ltMDogTm8gTlZSQU0sIElEIDcsIEZh
c3QtNDAsIExWRCwgcGFyaXR5IGNoZWNraW5nCj4gQ0FDSEUgVEVTVCBGQUlMRUQ6IGNoaXAgd3Jv
dGUgMiwgaG9zdCByZWFkIDEuCj4gc3ltMDogQ0FDSEUgSU5DT1JSRUNUTFkgQ09ORklHVVJFRC4K
PiBzeW0wOiBnaXZpbmcgdXAgLi4uCj4gWy4uLl0KCk5vdGUgdGhhdCB0aGlzIGlzIGp1c3QgYSBm
YWlsdXJlIGluIHRoZSBkcml2ZXIgc2VsZi10ZXN0LiAgSXQgaGFzCm5vdGhpbmcgdG8gZG8gd2l0
aCB0aGUgcHJvY2Vzc29yIGNhY2hlICh0aG91Z2ggdGhlcmUgYXJlIG90aGVyIHByb2JsZW1zCndp
dGggUENJIGFuZCB0aGUgcHJvY2Vzc29yIGNhY2hlIGluIEtWTSBtb2RlKS4KCkRvIG5vdCB1c2Ug
dGhpcyBRRU1VIGRldmljZS4gIFRoZSBlbXVsYXRpb24gaXMgaW5jb21wbGV0ZSBhbmQgaXQncyBz
bG93LgogVXNlIHZpcnRpby1zY3NpIG9yIG1lZ2FzYXMgaW5zdGVhZC4gIFN0aWxsLCBJJ20gbm90
IHN1cmUgdGhhdCB3b3VsZAp3b3JrIHdpdGggS1ZNOyBhcyBmYXIgYXMgSSBrbm93LCBtb3N0IHdv
cmsgb24gdGhlIEFSTSBQQ0kgaG9zdCBicmlkZ2UKd2FzIGRvbmUgdXNpbmcgVUVGSSBmaXJtd2Fy
ZS4KClBhb2xvCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
