From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v6 02/12] KVM: arm64: fix misleading comments in save/restore
Date: Fri, 19 Jun 2015 13:23:40 +0100
Message-ID: <1434716630-18260-3-git-send-email-alex.bennee@linaro.org>
References: <1434716630-18260-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A0275617C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 08:13:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MTcBmZ2b-W4i for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jun 2015 08:13:05 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE02E56133
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 08:13:05 -0400 (EDT)
In-Reply-To: <1434716630-18260-1-git-send-email-alex.bennee@linaro.org>
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

VGhlIGVscl9lbDIgYW5kIHNwc3JfZWwyIHJlZ2lzdGVycyBpbiBmYWN0IGNvbnRhaW4gdGhlIHBy
b2Nlc3NvciBzdGF0ZQpiZWZvcmUgZW50cnkgaW50byB0aGUgaHlwZXJ2aXNvciBjb2RlLiBJbiB0
aGUgY2FzZSBvZiBndWVzdCBzdGF0ZSBpdApjb3VsZCBiZSBpbiBlaXRoZXIgZWwwIG9yIGVsMS4K
ClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KLS0t
CiBhcmNoL2FybTY0L2t2bS9oeXAuUyB8IDggKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA0IGlu
c2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0v
aHlwLlMgYi9hcmNoL2FybTY0L2t2bS9oeXAuUwppbmRleCA1YmVmZDAxLi5jYjliZGQ4IDEwMDY0
NAotLS0gYS9hcmNoL2FybTY0L2t2bS9oeXAuUworKysgYi9hcmNoL2FybTY0L2t2bS9oeXAuUwpA
QCAtNTAsOCArNTAsOCBAQAogCXN0cAl4MjksIGxyLCBbeDMsICM4MF0KIAogCW1ycwl4MTksIHNw
X2VsMAotCW1ycwl4MjAsIGVscl9lbDIJCS8vIEVMMSBQQwotCW1ycwl4MjEsIHNwc3JfZWwyCQkv
LyBFTDEgcHN0YXRlCisJbXJzCXgyMCwgZWxyX2VsMgkJLy8gUEMgYmVmb3JlIGh5cCBlbnRyeQor
CW1ycwl4MjEsIHNwc3JfZWwyCQkvLyBwc3RhdGUgYmVmb3JlIGh5cCBlbnRyeQogCiAJc3RwCXgx
OSwgeDIwLCBbeDMsICM5Nl0KIAlzdHIJeDIxLCBbeDMsICMxMTJdCkBAIC04Miw4ICs4Miw4IEBA
CiAJbGRyCXgyMSwgW3gzLCAjMTZdCiAKIAltc3IJc3BfZWwwLCB4MTkKLQltc3IJZWxyX2VsMiwg
eDIwIAkJCQkvLyBFTDEgUEMKLQltc3IJc3Bzcl9lbDIsIHgyMSAJCQkJLy8gRUwxIHBzdGF0ZQor
CW1zcgllbHJfZWwyLCB4MjAgCQkvLyBQQyB0byByZXN0b3JlCisJbXNyCXNwc3JfZWwyLCB4MjEg
CQkvLyBwc3RhdGUgdG8gcmVzdG9yZQogCiAJYWRkCXgzLCB4MiwgI0NQVV9YUkVHX09GRlNFVCgx
OSkKIAlsZHAJeDE5LCB4MjAsIFt4M10KLS0gCjIuNC4zCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
