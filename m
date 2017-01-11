From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH 0/6] Documentation misc fixes
Date: Wed, 11 Jan 2017 16:28:35 +0000
Message-ID: <20170111162841.15569-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FF33404F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 11:27:08 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Tw1Grv0tbgVe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Jan 2017 11:27:06 -0500 (EST)
Received: from mail-wj0-f180.google.com (mail-wj0-f180.google.com
 [209.85.210.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5B2374027C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 11:27:06 -0500 (EST)
Received: by mail-wj0-f180.google.com with SMTP id tn15so106672126wjb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Jan 2017 08:28:51 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: drjones@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

SGksCgpJIGJyb2tlIHRoZXNlIG91dCBvZiBteSBlYXJsaWVyIE1UVENHIHRlc3Qgc2VyaWVzIGFz
IHRoZXkgYXJlIG5vdApzdHJpY3RseSByZWxhdGVkLiBUaGUgbGliY2ZsYXQvcGNpIGZpeGVzIGFy
ZSBhIHJlc3VsdCBvZiB0cnlpbmcgdG8KY3Jvc3MtY29tcGlsZSBhcm0zMiBiaW5hcmllcyBvbiBt
eSBhcm02NCBib3ggd2l0aCBhIGFybS1ub25lLWFiaQpjb21waWxlci4gSSd2ZSBhbHNvIHRpZGll
ZCB1cCBzb21lIGRvY3VtZW50YXRpb24gKGFsb25nIHdpdGggYQpjb250cm92ZXJzaWFsIG1vdmUg
dG8gTWFya2Rvd24gOy0pLiBBbmQgZmluYWxseSB0aGUgcnVuX3NjcmlwdCBub3cKZm9sbG93cyB0
aGUgY29udmVudGlvbiBvZiBwYXNzaW5nIGFyZ3VtZW50cyBhZnRlciAtLSB0byB0aGUgY2hpbGQK
cHJvY2Vzcy4KCkFsZXggQmVubsOpZSAoNik6CiAgbGliY2ZsYXQ6IGFkZCBQUkkoZHV4KTMyIGZv
cm1hdCB0eXBlcwogIGxpYi9wY2k6IGZpeCBCQVIgZm9ybWF0IHN0cmluZ3MKICBkb2NzOiBtb3Zl
IFJFQURNRSB0byBSRUFETUUubWQgYW5kIHN5bWxpbmsKICBkb2NzOiBtZW50aW9uIGNoZWNrcGF0
Y2ggaW4gdGhlIFJFQURNRQogIGRvY3M6IG1lbnRpb24gbW9kaWZ5aW5nIGVudiB2YXJzIGluIFJF
QURNRQogIHJ1bl90ZXN0czogYWxsb3cgcGFzc2luZyBvZiBvcHRpb25zIHRvIFFFTVUKCiBNYWtl
ZmlsZSAgICAgICAgICAgICAgIHwgIDEgKwogUkVBRE1FICAgICAgICAgICAgICAgICB8IDY5ICst
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogUkVBRE1FLm1kICAgICAgICAgICAg
ICB8IDk2ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
CiBjb25maWd1cmUgICAgICAgICAgICAgIHwgMTMgKysrKysrKwogbGliL2xpYmNmbGF0LmggICAg
ICAgICB8ICA5ICsrKysrCiBsaWIvcGNpLmMgICAgICAgICAgICAgIHwgIDQgKy0tCiBydW5fdGVz
dHMuc2ggICAgICAgICAgIHwgMTMgKysrKystLQogc2NyaXB0cy9mdW5jdGlvbnMuYmFzaCB8ICA3
ICsrLS0KIDggZmlsZXMgY2hhbmdlZCwgMTM3IGluc2VydGlvbnMoKyksIDc1IGRlbGV0aW9ucygt
KQogbW9kZSBjaGFuZ2UgMTAwNjQ0ID0+IDEyMDAwMCBSRUFETUUKIGNyZWF0ZSBtb2RlIDEwMDY0
NCBSRUFETUUubWQKCi0tIAoyLjExLjAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
