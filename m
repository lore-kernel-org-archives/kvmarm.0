From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2] KVM: arm64: fix misleading comments in save/restore
Date: Thu,  4 Jun 2015 14:28:37 +0100
Message-ID: <1433424517-31816-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD1B752F78
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2015 09:18:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UtthaLuwUJP0 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Jun 2015 09:18:21 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D88C552F24
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Jun 2015 09:18:21 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

VGhlIGVscl9lbDIgYW5kIHNwc3JfZWwyIHJlZ2lzdGVycyBpbiBmYWN0IGNvbnRhaW4gdGhlIHBy
b2Nlc3NvciBzdGF0ZQpiZWZvcmUgZW50cnkgaW50byBFTDIuIEluIHRoZSBjYXNlIG9mIGd1ZXN0
IHN0YXRlIGl0IGNvdWxkIGJlIGluIGVpdGhlcgplbDAgb3IgZWwxLgoKU2lnbmVkLW9mZi1ieTog
QWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgoKLS0tCnYyCiAgLSBzL2h5cGVy
dmlzb3IgY29kZS9FTDIvCiAgLSBjb21tZW50OiBwYy9wc3RhdGUgYmVmb3JlIGVudGVyaW5nL29u
IHJldHVybiBmcm9tIGVsMgotLS0KIGFyY2gvYXJtNjQva3ZtL2h5cC5TIHwgOCArKysrLS0tLQog
MSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9hcmNoL2FybTY0L2t2bS9oeXAuUyBiL2FyY2gvYXJtNjQva3ZtL2h5cC5TCmluZGV4IDVi
ZWZkMDEuLjUxOTgwNWYgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL2h5cC5TCisrKyBiL2Fy
Y2gvYXJtNjQva3ZtL2h5cC5TCkBAIC01MCw4ICs1MCw4IEBACiAJc3RwCXgyOSwgbHIsIFt4Mywg
IzgwXQogCiAJbXJzCXgxOSwgc3BfZWwwCi0JbXJzCXgyMCwgZWxyX2VsMgkJLy8gRUwxIFBDCi0J
bXJzCXgyMSwgc3Bzcl9lbDIJCS8vIEVMMSBwc3RhdGUKKwltcnMJeDIwLCBlbHJfZWwyCQkvLyBw
YyBiZWZvcmUgZW50ZXJpbmcgZWwyCisJbXJzCXgyMSwgc3Bzcl9lbDIJCS8vIHBzdGF0ZSBiZWZv
cmUgZW50ZXJpbmcgZWwyCiAKIAlzdHAJeDE5LCB4MjAsIFt4MywgIzk2XQogCXN0cgl4MjEsIFt4
MywgIzExMl0KQEAgLTgyLDggKzgyLDggQEAKIAlsZHIJeDIxLCBbeDMsICMxNl0KIAogCW1zcglz
cF9lbDAsIHgxOQotCW1zcgllbHJfZWwyLCB4MjAgCQkJCS8vIEVMMSBQQwotCW1zcglzcHNyX2Vs
MiwgeDIxIAkJCQkvLyBFTDEgcHN0YXRlCisJbXNyCWVscl9lbDIsIHgyMCAJCS8vIHBjIG9uIHJl
dHVybiBmcm9tIGVsMgorCW1zcglzcHNyX2VsMiwgeDIxIAkJLy8gcHN0YXRlIG9uIHJldHVybiBm
cm9tIGVsMgogCiAJYWRkCXgzLCB4MiwgI0NQVV9YUkVHX09GRlNFVCgxOSkKIAlsZHAJeDE5LCB4
MjAsIFt4M10KLS0gCjIuNC4yCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
