From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 11/12] KVM: arm64: enable KVM_CAP_SET_GUEST_DEBUG
Date: Thu,  7 May 2015 10:07:14 +0100
Message-ID: <1430989647-22501-4-git-send-email-alex.bennee@linaro.org>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8716350B59
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2015 04:58:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2kUh2iyyT20z for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 May 2015 04:58:21 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DA1F650B65
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 May 2015 04:58:21 -0400 (EDT)
In-Reply-To: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
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
Ynk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KCi0tLQoKdjM6CiAtIHNl
cGFyYXRlZCBjYXBhYmlsaXR5IGNoZWNrIGZyb20gcHJldmlvdXMgcGF0Y2hlcwogLSBtb3ZlZCBp
bnRvIGFybTY0IHNwZWNpZmljIGlvY3RsIGhhbmRsZXIuCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02
NC9rdm0vcmVzZXQuYyBiL2FyY2gvYXJtNjQva3ZtL3Jlc2V0LmMKaW5kZXggMjFkNWE2Mi4uODhl
NTMzMSAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vcmVzZXQuYworKysgYi9hcmNoL2FybTY0
L2t2bS9yZXNldC5jCkBAIC03Niw2ICs3Niw5IEBAIGludCBrdm1fYXJjaF9kZXZfaW9jdGxfY2hl
Y2tfZXh0ZW5zaW9uKGxvbmcgZXh0KQogCWNhc2UgS1ZNX0NBUF9HVUVTVF9ERUJVR19IV19XUFM6
CiAJCXIgID0gZ2V0X251bV93cnBzKCk7CiAJCWJyZWFrOworCWNhc2UgS1ZNX0NBUF9TRVRfR1VF
U1RfREVCVUc6CisJCXIgPSAxOworCQlicmVhazsKIAlkZWZhdWx0OgogCQlyID0gMDsKIAl9Ci0t
IAoyLjMuNQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
