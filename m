From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 03/12] KVM: arm64: guest debug, define API headers
Date: Wed,  6 May 2015 17:23:18 +0100
Message-ID: <1430929407-3487-4-git-send-email-alex.bennee@linaro.org>
References: <1430929407-3487-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B7F350898
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2015 12:14:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ITVmtvcFgTHg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 May 2015 12:14:08 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A55B15088B
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 May 2015 12:14:08 -0400 (EDT)
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, jan.kiszka@siemens.com, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>, dahi@linux.vnet.ibm.com, r65777@freescale.com, bp@suse.de
List-Id: kvmarm@lists.cs.columbia.edu

VGhpcyBjb21taXQgZGVmaW5lcyB0aGUgQVBJIGhlYWRlcnMgZm9yIGd1ZXN0IGRlYnVnZ2luZy4g
VGhlcmUgYXJlIHR3bwphcmNoaXRlY3R1cmUgc3BlY2lmaWMgZGVidWcgc3RydWN0dXJlczoKCiAg
LSBrdm1fZ3Vlc3RfZGVidWdfYXJjaCwgYWxsb3dzIHVzIHRvIHBhc3MgaW4gSFcgZGVidWcgcmVn
aXN0ZXJzCiAgLSBrdm1fZGVidWdfZXhpdF9hcmNoLCBzaWduYWxzIGV4Y2VwdGlvbiBhbmQgcG9z
c2libGUgZmF1bHRpbmcgYWRkcmVzcwoKVGhlIHR5cGUgb2YgZGVidWdnaW5nIGJlaW5nIHVzZWQg
aXMgY29udHJvbGxlZCBieSB0aGUgYXJjaGl0ZWN0dXJlCnNwZWNpZmljIGNvbnRyb2wgYml0cyBv
ZiB0aGUga3ZtX2d1ZXN0X2RlYnVnLT5jb250cm9sIGZsYWdzIGluIHRoZSBpb2N0bApzdHJ1Y3R1
cmUuCgpTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+
ClJldmlld2VkLWJ5OiBEYXZpZCBIaWxkZW5icmFuZCA8ZGFoaUBsaW51eC52bmV0LmlibS5jb20+
ClJldmlld2VkLWJ5OiBBbmRyZXcgSm9uZXMgPGRyam9uZXNAcmVkaGF0LmNvbT4KCi0tLQp2Mgog
ICAtIGV4cG9zZSBoc3IgYW5kIHBjIGRpcmVjdGx5IHRvIHVzZXItc3BhY2UKdjMKICAgLSBzL2Nv
bnRyb2wvY29udHJvbGxlZC8gaW4gY29tbWl0IG1lc3NhZ2UKICAgLSBhZGQgdjggdG8gQVJNIEFS
TSBjb21tZW50IChBUk0gQXJjaGl0ZWN0dXJlIFJlZmVyZW5jZSBNYW51YWwpCiAgIC0gYWRkIHJi
IHRhZwogICAtIHJtIHBjLCBhZGQgZmFyCiAgIC0gcmUtd29yZCBjb21tZW50cyBvbiBhbGlnbm1l
bnQKICAgLSByZW5hbWUgS1ZNX0FSTV9OREJHX1JFR1MgLT4gS1ZNX0FSTV9NQVhfREJHX1JFR1MK
CmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmggYi9hcmNoL2Fy
bTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgKaW5kZXggZDI2ODMyMC4uMDQ5NTdkNyAxMDA2NDQK
LS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oCisrKyBiL2FyY2gvYXJtNjQv
aW5jbHVkZS91YXBpL2FzbS9rdm0uaApAQCAtMTAwLDEwICsxMDAsMjggQEAgc3RydWN0IGt2bV9z
cmVncyB7CiBzdHJ1Y3Qga3ZtX2ZwdSB7CiB9OwogCisvKgorICogU2VlIHY4IEFSTSBBUk0gRDcu
MzogRGVidWcgUmVnaXN0ZXJzCisgKgorICogVGhlIGNvbnRyb2wgcmVnaXN0ZXJzIGFyZSBhcmNo
aXRlY3R1cmFsbHkgZGVmaW5lZCBhcyAzMiBiaXRzIGJ1dCBhcmUKKyAqIHN0b3JlZCBhcyA2NCBi
aXQgdmFsdWVzIGFsb25nc2lkZSB0aGUgdmFsdWUgcmVnaXN0ZXJzLiBUaGlzIGlzIGRvbmUKKyAq
IHRvIGtlZXAgdGhlIGNvcHlpbmcgb2YgdGhlc2UgdmFsdWVzIGludG8gdGhlIHZjcHUgY29udGV4
dCBzaW1wbGUgYXMKKyAqIGV2ZXJ5dGhpbmcgaXMgNjQgYml0IGFsaWduZWQgKHNlZSBEQkdCQ1Iw
X0VMMSBvbndhcmRzIGluIGt2bV9hc20uaCkuCisgKgorICogVGhlIGFyY2hpdGVjdHVyYWwgbGlt
aXQgaXMgMTYgZGVidWcgcmVnaXN0ZXJzIG9mIGVhY2ggdHlwZSBhbHRob3VnaAorICogaW4gcHJh
Y3RpY2UgdGhlcmUgYXJlIHVzdWFsbHkgbGVzcyAoc2VlIElEX0FBNjRERlIwX0VMMSkuCisgKi8K
KyNkZWZpbmUgS1ZNX0FSTV9NQVhfREJHX1JFR1MgMTYKIHN0cnVjdCBrdm1fZ3Vlc3RfZGVidWdf
YXJjaCB7CisJX191NjQgZGJnX2JjcltLVk1fQVJNX01BWF9EQkdfUkVHU107CisJX191NjQgZGJn
X2J2cltLVk1fQVJNX01BWF9EQkdfUkVHU107CisJX191NjQgZGJnX3djcltLVk1fQVJNX01BWF9E
QkdfUkVHU107CisJX191NjQgZGJnX3d2cltLVk1fQVJNX01BWF9EQkdfUkVHU107CiB9OwogCiBz
dHJ1Y3Qga3ZtX2RlYnVnX2V4aXRfYXJjaCB7CisJX191MzIgaHNyOworCV9fdTY0IGZhcjsKIH07
CiAKIHN0cnVjdCBrdm1fc3luY19yZWdzIHsKQEAgLTIxNiw0ICsyMzQsMTEgQEAgc3RydWN0IGt2
bV9hcmNoX21lbW9yeV9zbG90IHsKIAogI2VuZGlmCiAKKy8qCisgKiBBcmNoaXRlY3R1cmUgcmVs
YXRlZCBkZWJ1ZyBkZWZpbmVzIC0gdXBwZXIgMTYgYml0cyBvZgorICoga3ZtX2d1ZXN0X2RlYnVn
LT5jb250cm9sCisgKi8KKyNkZWZpbmUgS1ZNX0dVRVNUREJHX1VTRV9TV19CUAkgICAgICAgIF9f
S1ZNX0dVRVNUREJHX1VTRV9TV19CUAorI2RlZmluZSBLVk1fR1VFU1REQkdfVVNFX0hXX0JQCQlf
X0tWTV9HVUVTVERCR19VU0VfSFdfQlAKKwogI2VuZGlmIC8qIF9fQVJNX0tWTV9IX18gKi8KLS0g
CjIuMy41CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
