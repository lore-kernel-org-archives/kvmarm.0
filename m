From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/2] config: move x86 kvm_guest.config to a common locaton
Date: Wed, 21 Sep 2016 15:10:30 -0500
Message-ID: <CAL_JsqKe=N=VLDfVNJbb2rLWcT+UVJP2JNcdk4tSkSua0FXU_Q@mail.gmail.com>
References: <20160908184102.8592-1-robh@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE14149AFA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2016 16:01:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oxcqLjfmOkCC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Sep 2016 16:01:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.136])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 294C440C9D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2016 16:01:49 -0400 (EDT)
Received: from mail.kernel.org (localhost [127.0.0.1])
 by mail.kernel.org (Postfix) with ESMTP id 4DAE12047C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2016 20:10:54 +0000 (UTC)
Received: from mail-yb0-f169.google.com (mail-yb0-f169.google.com
 [209.85.213.169])
 (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id ECE3F203AA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2016 20:10:51 +0000 (UTC)
Received: by mail-yb0-f169.google.com with SMTP id 2so36626360ybv.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Sep 2016 13:10:51 -0700 (PDT)
In-Reply-To: <20160908184102.8592-1-robh@kernel.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

T24gVGh1LCBTZXAgOCwgMjAxNiBhdCAxOjQxIFBNLCBSb2IgSGVycmluZyA8cm9iaEBrZXJuZWwu
b3JnPiB3cm90ZToKPiBrdm1fZ3Vlc3QuY29uZmlnIGlzIHVzZWZ1bCBmb3IgS1ZNIGd1ZXN0cyBv
biBvdGhlciBhcmNoZXMsIGFuZCBub3RoaW5nCj4gaW4gaXQgYXBwZWFycyB0byBiZSB4ODYgc3Bl
Y2lmaWMsIHNvIGp1c3QgbW92ZSB0aGUgd2hvbGUgZmlsZS4gS2J1aWxkCj4gd2lsbCBmaW5kIGl0
IGluIGVpdGhlciBsb2NhdGlvbi4KPgo+IFNpZ25lZC1vZmYtYnk6IFJvYiBIZXJyaW5nIDxyb2Jo
QGtlcm5lbC5vcmc+Cj4gQ2M6IENocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAbGlu
YXJvLm9yZz4KPiBDYzogTWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KPiBDYzog
UGFvbG8gQm9uemluaSA8cGJvbnppbmlAcmVkaGF0LmNvbT4KPiBDYzogIlJhZGltIEtyxI1tw6HF
mSIgPHJrcmNtYXJAcmVkaGF0LmNvbT4KPiBDYzoga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQo+IENjOiBrdm1Admdlci5rZXJuZWwub3JnCgpQaW5nPwoKUm9iCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
