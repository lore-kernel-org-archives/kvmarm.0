From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] ARM: KVM: Correctly order SGI register entries in the
 cp15 array
Date: Thu, 4 Oct 2018 20:38:21 -0700
Message-ID: <f32a99ed-a37b-889a-bab5-0faa9bd8fb42@gmail.com>
References: <20181004092946.59836-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE8184A20D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Oct 2018 23:38:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yWBLVCTx6AvG for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Oct 2018 23:38:26 -0400 (EDT)
Received: from mail-oi1-f195.google.com (mail-oi1-f195.google.com
 [209.85.167.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DC6C44A206
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Oct 2018 23:38:25 -0400 (EDT)
Received: by mail-oi1-f195.google.com with SMTP id v69-v6so9323473oif.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Oct 2018 20:38:25 -0700 (PDT)
In-Reply-To: <20181004092946.59836-1-marc.zyngier@arm.com>
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
To: Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

TGUgMTAvMDQvMTggw6AgMDI6MjksIE1hcmMgWnluZ2llciBhIMOpY3JpdMKgOgo+IFRoZSBJQ0Nf
QVNHSTFSIGFuZCBJQ0NfU0dJMFIgcmVnaXN0ZXIgZW50cmllcyBpbiB0aGUgY3AxNSBhcnJheQo+
IGFyZSBub3QgY29ycmVjdGx5IG9yZGVyZWQsIGxlYWRpbmcgdG8gYSBCVUcoKSBhdCBib290IHRp
bWUuCj4gCj4gTW92ZSB0aGVtIHRvIHRoZWlyIG5hdHVyYWwgbG9jYXRpb24uCj4gCj4gRml4ZXM6
IDNlOGE4YTUwYzdlZiAoIktWTTogYXJtOiB2Z2ljLXYzOiBBZGQgc3VwcG9ydCBmb3IgSUNDX1NH
STBSIGFuZCBJQ0NfQVNHSTFSIGFjY2Vzc2VzIikKPiBSZXBvcnRlZC1ieTogRmxvcmlhbiBGYWlu
ZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+Cj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVy
IDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KClRlc3RlZC1ieTogRmxvcmlhbiBGYWluZWxsaSA8Zi5m
YWluZWxsaUBnbWFpbC5jb20+CgpUaGFua3MhCi0tIApGbG9yaWFuCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
