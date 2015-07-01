From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v7 10/11] KVM: arm64: enable KVM_CAP_SET_GUEST_DEBUG
Date: Wed,  1 Jul 2015 19:29:02 +0100
Message-ID: <1435775343-20034-11-git-send-email-alex.bennee@linaro.org>
References: <1435775343-20034-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 088A25757A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2015 14:18:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2yh8TgSXzPdl for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jul 2015 14:18:30 -0400 (EDT)
Received: from mail-wg0-f54.google.com (mail-wg0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 30CAB57585
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2015 14:18:29 -0400 (EDT)
Received: by wgjx7 with SMTP id x7so43919785wgj.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Jul 2015 11:29:44 -0700 (PDT)
In-Reply-To: <1435775343-20034-1-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de, drjones@redhat.com, pbonzini@redhat.com, zhichao.huang@linaro.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Gleb Natapov <gleb@kernel.org>, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de
List-Id: kvmarm@lists.cs.columbia.edu

RmluYWxseSBhZHZlcnRpc2UgdGhlIEtWTSBjYXBhYmlsaXR5IGZvciBTRVRfR1VFU1RfREVCVUcu
IE9uY2UgYXJtCnN1cHBvcnQgaXMgYWRkZWQgdGhpcyBjaGVjayBjYW4gYmUgbW92ZWQgdG8gdGhl
IGNvbW1vbgprdm1fdm1faW9jdGxfY2hlY2tfZXh0ZW5zaW9uKCkgY29kZS4KClNpZ25lZC1vZmYt
Ynk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KQWNrZWQtYnk6IENocmlz
dG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAbGluYXJvLm9yZz4KCi0tLQoKdjM6CiAtIHNl
cGFyYXRlZCBjYXBhYmlsaXR5IGNoZWNrIGZyb20gcHJldmlvdXMgcGF0Y2hlcwogLSBtb3ZlZCBp
bnRvIGFybTY0IHNwZWNpZmljIGlvY3RsIGhhbmRsZXIuCnY0OgogLSBhZGQgYS1iLXRhZwotLS0K
IGFyY2gvYXJtNjQva3ZtL3Jlc2V0LmMgfCAzICsrKwogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0
aW9ucygrKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3Jlc2V0LmMgYi9hcmNoL2FybTY0
L2t2bS9yZXNldC5jCmluZGV4IDIxZDVhNjIuLjg4ZTUzMzEgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJt
NjQva3ZtL3Jlc2V0LmMKKysrIGIvYXJjaC9hcm02NC9rdm0vcmVzZXQuYwpAQCAtNzYsNiArNzYs
OSBAQCBpbnQga3ZtX2FyY2hfZGV2X2lvY3RsX2NoZWNrX2V4dGVuc2lvbihsb25nIGV4dCkKIAlj
YXNlIEtWTV9DQVBfR1VFU1RfREVCVUdfSFdfV1BTOgogCQlyICA9IGdldF9udW1fd3JwcygpOwog
CQlicmVhazsKKwljYXNlIEtWTV9DQVBfU0VUX0dVRVNUX0RFQlVHOgorCQlyID0gMTsKKwkJYnJl
YWs7CiAJZGVmYXVsdDoKIAkJciA9IDA7CiAJfQotLSAKMi40LjUKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
