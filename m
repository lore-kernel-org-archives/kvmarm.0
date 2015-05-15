From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v4 03/12] KVM: arm64: guest debug, define API headers
Date: Fri, 15 May 2015 15:27:06 +0100
Message-ID: <1431700035-23479-4-git-send-email-alex.bennee@linaro.org>
References: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF8795168C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 10:17:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dsefUmBu7VjG for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2015 10:17:20 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D98E551683
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2015 10:17:19 -0400 (EDT)
In-Reply-To: <1431700035-23479-1-git-send-email-alex.bennee@linaro.org>
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
ClJldmlld2VkLWJ5OiBBbmRyZXcgSm9uZXMgPGRyam9uZXNAcmVkaGF0LmNvbT4KQWNrZWQtYnk6
IENocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAbGluYXJvLm9yZz4KCi0tLQp2Mgog
ICAtIGV4cG9zZSBoc3IgYW5kIHBjIGRpcmVjdGx5IHRvIHVzZXItc3BhY2UKdjMKICAgLSBzL2Nv
bnRyb2wvY29udHJvbGxlZC8gaW4gY29tbWl0IG1lc3NhZ2UKICAgLSBhZGQgdjggdG8gQVJNIEFS
TSBjb21tZW50IChBUk0gQXJjaGl0ZWN0dXJlIFJlZmVyZW5jZSBNYW51YWwpCiAgIC0gYWRkIHJi
IHRhZwogICAtIHJtIHBjLCBhZGQgZmFyCiAgIC0gcmUtd29yZCBjb21tZW50cyBvbiBhbGlnbm1l
bnQKICAgLSByZW5hbWUgS1ZNX0FSTV9OREJHX1JFR1MgLT4gS1ZNX0FSTV9NQVhfREJHX1JFR1MK
djQKICAgLSBub3cgdXNlcyBjb21tb24gSFcvU1cgQlAgZGVmaW5lCiAgIC0gYWRkIGEtYi10YWcK
ICAgLSB1c2UgdTMyIGZvciBjb250cm9sIHJlZ3MKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2lu
Y2x1ZGUvdWFwaS9hc20va3ZtLmggYi9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgK
aW5kZXggZDI2ODMyMC4uODc5NjYxMCAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL3Vh
cGkvYXNtL2t2bS5oCisrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaApAQCAt
MTAwLDEwICsxMDAsMjggQEAgc3RydWN0IGt2bV9zcmVncyB7CiBzdHJ1Y3Qga3ZtX2ZwdSB7CiB9
OwogCisvKgorICogU2VlIHY4IEFSTSBBUk0gRDcuMzogRGVidWcgUmVnaXN0ZXJzCisgKgorICog
VGhlIGNvbnRyb2wgcmVnaXN0ZXJzIGFyZSBhcmNoaXRlY3R1cmFsbHkgZGVmaW5lZCBhcyAzMiBi
aXRzIGJ1dCBhcmUKKyAqIHN0b3JlZCBhcyA2NCBiaXQgdmFsdWVzIGFsb25nc2lkZSB0aGUgdmFs
dWUgcmVnaXN0ZXJzLiBUaGlzIGlzIGRvbmUKKyAqIHRvIGtlZXAgdGhlIGNvcHlpbmcgb2YgdGhl
c2UgdmFsdWVzIGludG8gdGhlIHZjcHUgY29udGV4dCBzaW1wbGUgYXMKKyAqIGV2ZXJ5dGhpbmcg
aXMgNjQgYml0IGFsaWduZWQgKHNlZSBEQkdCQ1IwX0VMMSBvbndhcmRzIGluIGt2bV9hc20uaCku
CisgKgorICogVGhlIGFyY2hpdGVjdHVyYWwgbGltaXQgaXMgMTYgZGVidWcgcmVnaXN0ZXJzIG9m
IGVhY2ggdHlwZSBhbHRob3VnaAorICogaW4gcHJhY3RpY2UgdGhlcmUgYXJlIHVzdWFsbHkgbGVz
cyAoc2VlIElEX0FBNjRERlIwX0VMMSkuCisgKi8KKyNkZWZpbmUgS1ZNX0FSTV9NQVhfREJHX1JF
R1MgMTYKIHN0cnVjdCBrdm1fZ3Vlc3RfZGVidWdfYXJjaCB7CisJX191MzIgZGJnX2JjcltLVk1f
QVJNX01BWF9EQkdfUkVHU107CisJX191NjQgZGJnX2J2cltLVk1fQVJNX01BWF9EQkdfUkVHU107
CisJX191MzIgZGJnX3djcltLVk1fQVJNX01BWF9EQkdfUkVHU107CisJX191NjQgZGJnX3d2cltL
Vk1fQVJNX01BWF9EQkdfUkVHU107CiB9OwogCiBzdHJ1Y3Qga3ZtX2RlYnVnX2V4aXRfYXJjaCB7
CisJX191MzIgaHNyOworCV9fdTY0IGZhcjsKIH07CiAKIHN0cnVjdCBrdm1fc3luY19yZWdzIHsK
LS0gCjIuMy41CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
