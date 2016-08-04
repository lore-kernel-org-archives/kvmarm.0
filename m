From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 2/8] KVM: Add devid in kvm_kernel_irq_routing_entry
Date: Thu,  4 Aug 2016 13:40:30 +0200
Message-ID: <1470310836-10371-3-git-send-email-christoffer.dall@linaro.org>
References: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09C6049B61
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:33:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 37ka9VGx-kId for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2016 07:33:55 -0400 (EDT)
Received: from mail-lf0-f53.google.com (mail-lf0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E922F49B47
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2016 07:33:53 -0400 (EDT)
Received: by mail-lf0-f53.google.com with SMTP id l69so180217109lfg.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2016 04:40:46 -0700 (PDT)
In-Reply-To: <1470310836-10371-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

RnJvbTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgoKRW5oYW5jZSBrdm1fa2Vy
bmVsX2lycV9yb3V0aW5nX2VudHJ5IHRvIHRyYW5zcG9ydCB0aGUgZGV2aWNlIGlkCmZpZWxkLCBk
ZXZpZC4gQSBuZXcgZmxhZ3MgZmllbGQgbWFrZXMgcG9zc2libGUgdG8gaW5kaWNhdGUgdGhlCmRl
dmlkIGlzIHZhbGlkLiBUaG9zZSBhZGRpdGlvbnMgYXJlIHVzZWQgZm9yIEFSTSBHSUN2MyBJVFMg
TVNJCmluamVjdGlvbi4gVGhlIG9yaWdpbmFsIHN0cnVjdCBtc2lfbXNnIG1zaSBmaWVsZCBpcyBy
ZXBsYWNlZCBieQphIG5ldyBjdXN0b20gc3RydWN0dXJlIHRoYXQgZW1iZWRzIHRoZSBuZXcgZmll
bGRzLgoKU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgpT
dWdnZXN0ZWQtYnk6IFJhZGltIEtyxI1tw6HFmSA8cmtyY21hckByZWRoYXQuY29tPgpBY2tlZC1i
eTogUmFkaW0gS3LEjW3DocWZIDxya3JjbWFyQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IE1h
cmMgWnluZ2llciA8bWFyYy56eW5naWVyQGFybS5jb20+Ci0tLQogaW5jbHVkZS9saW51eC9rdm1f
aG9zdC5oIHwgOCArKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaCBiL2luY2x1
ZGUvbGludXgva3ZtX2hvc3QuaAppbmRleCA2MTRhOTgxLi5hMTU4MjhmIDEwMDY0NAotLS0gYS9p
bmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKKysrIGIvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oCkBA
IC0zMTcsNyArMzE3LDEzIEBAIHN0cnVjdCBrdm1fa2VybmVsX2lycV9yb3V0aW5nX2VudHJ5IHsK
IAkJCXVuc2lnbmVkIGlycWNoaXA7CiAJCQl1bnNpZ25lZCBwaW47CiAJCX0gaXJxY2hpcDsKLQkJ
c3RydWN0IG1zaV9tc2cgbXNpOworCQlzdHJ1Y3QgeworCQkJdTMyIGFkZHJlc3NfbG87CisJCQl1
MzIgYWRkcmVzc19oaTsKKwkJCXUzMiBkYXRhOworCQkJdTMyIGZsYWdzOworCQkJdTMyIGRldmlk
OworCQl9IG1zaTsKIAkJc3RydWN0IGt2bV9zMzkwX2FkYXB0ZXJfaW50IGFkYXB0ZXI7CiAJCXN0
cnVjdCBrdm1faHZfc2ludCBodl9zaW50OwogCX07Ci0tIAoxLjkuMQoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1h
cm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21h
aWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
