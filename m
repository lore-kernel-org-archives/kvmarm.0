From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 03/10] KVM: arm: guest debug, define API headers
Date: Tue, 31 Mar 2015 16:08:01 +0100
Message-ID: <1427814488-28467-4-git-send-email-alex.bennee@linaro.org>
References: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 868B84A6B0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2015 11:01:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CjjMZINSKep5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Mar 2015 11:01:14 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AC5084A6B1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2015 11:01:14 -0400 (EDT)
In-Reply-To: <1427814488-28467-1-git-send-email-alex.bennee@linaro.org>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de
List-Id: kvmarm@lists.cs.columbia.edu

VGhpcyBjb21taXQgZGVmaW5lcyB0aGUgQVBJIGhlYWRlcnMgZm9yIGd1ZXN0IGRlYnVnZ2luZy4g
VGhlcmUgYXJlIHR3bwphcmNoaXRlY3R1cmUgc3BlY2lmaWMgZGVidWcgc3RydWN0dXJlczoKCiAg
LSBrdm1fZ3Vlc3RfZGVidWdfYXJjaCwgYWxsb3dzIHVzIHRvIHBhc3MgaW4gSFcgZGVidWcgcmVn
aXN0ZXJzCiAgLSBrdm1fZGVidWdfZXhpdF9hcmNoLCBzaWduYWxzIHRoZSBleGFjdCBkZWJ1ZyBl
eGl0IGFuZCBwYwoKVGhlIHR5cGUgb2YgZGVidWdnaW5nIGJlaW5nIHVzZWQgaXMgY29udHJvbCBi
eSB0aGUgYXJjaGl0ZWN0dXJlIHNwZWNpZmljCmNvbnRyb2wgYml0cyBvZiB0aGUga3ZtX2d1ZXN0
X2RlYnVnLT5jb250cm9sIGZsYWdzIGluIHRoZSBpb2N0bApzdHJ1Y3R1cmUuCgpTaWduZWQtb2Zm
LWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+CgotLS0KdjIKICAgLSBl
eHBvc2UgaHNyIGFuZCBwYyBkaXJlY3RseSB0byB1c2VyLXNwYWNlCgpkaWZmIC0tZ2l0IGEvYXJj
aC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkv
YXNtL2t2bS5oCmluZGV4IDNlZjc3YTQuLjZlZTcwYTAgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQv
aW5jbHVkZS91YXBpL2FzbS9rdm0uaAorKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20v
a3ZtLmgKQEAgLTEwMCwxMCArMTAwLDI0IEBAIHN0cnVjdCBrdm1fc3JlZ3Mgewogc3RydWN0IGt2
bV9mcHUgewogfTsKIAorLyoKKyAqIFNlZSBBUk0gQVJNIEQ3LjM6IERlYnVnIFJlZ2lzdGVycwor
ICoKKyAqIFRoZSBjb250cm9sIHJlZ2lzdGVycyBhcmUgYXJjaGl0ZWN0dXJhbGx5IGRlZmluZWQg
YXMgMzIgYml0cyBidXQgYXJlCisgKiBzdG9yZWQgYXMgNjQgYml0IHZhbHVlcyBhbG9uZyBzaWRl
IHRoZSB2YWx1ZSByZWdpc3RlcnMgYW5kIGFsaWduZWQKKyAqIHdpdGggdGhlIHJlc3QgNjQgYml0
IHJlZ2lzdGVycyBpbiB0aGUgbm9ybWFsIENQVSBjb250ZXh0LgorICovCisjZGVmaW5lIEtWTV9B
Uk1fTkRCR19SRUdTIDE2CiBzdHJ1Y3Qga3ZtX2d1ZXN0X2RlYnVnX2FyY2ggeworCV9fdTY0IGRi
Z19iY3JbS1ZNX0FSTV9OREJHX1JFR1NdOworCV9fdTY0IGRiZ19idnJbS1ZNX0FSTV9OREJHX1JF
R1NdOworCV9fdTY0IGRiZ193Y3JbS1ZNX0FSTV9OREJHX1JFR1NdOworCV9fdTY0IGRiZ193dnJb
S1ZNX0FSTV9OREJHX1JFR1NdOwogfTsKIAogc3RydWN0IGt2bV9kZWJ1Z19leGl0X2FyY2ggewor
CV9fdTY0IHBjOworCV9fdTMyIGhzcjsKIH07CiAKIHN0cnVjdCBrdm1fc3luY19yZWdzIHsKQEAg
LTIwNyw0ICsyMjEsMTEgQEAgc3RydWN0IGt2bV9hcmNoX21lbW9yeV9zbG90IHsKIAogI2VuZGlm
CiAKKy8qCisgKiBBcmNoaXRlY3R1cmUgcmVsYXRlZCBkZWJ1ZyBkZWZpbmVzIC0gdXBwZXIgMTYg
Yml0cyBvZgorICoga3ZtX2d1ZXN0X2RlYnVnLT5jb250cm9sCisgKi8KKyNkZWZpbmUgS1ZNX0dV
RVNUREJHX1VTRV9TV19CUAkgICAgICAgIF9fS1ZNX0dVRVNUREJHX1VTRV9TV19CUAorI2RlZmlu
ZSBLVk1fR1VFU1REQkdfVVNFX0hXX0JQCQlfX0tWTV9HVUVTVERCR19VU0VfSFdfQlAKKwogI2Vu
ZGlmIC8qIF9fQVJNX0tWTV9IX18gKi8KLS0gCjIuMy40CgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
