From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v5 03/12] KVM: arm64: guest debug, define API headers
Date: Fri, 29 May 2015 10:30:19 +0100
Message-ID: <1432891828-4816-4-git-send-email-alex.bennee@linaro.org>
References: <1432891828-4816-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6BB27523BD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 05:20:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MIc-Wx6NJ+bt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 29 May 2015 05:20:42 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EA8EC523CE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 29 May 2015 05:20:41 -0400 (EDT)
In-Reply-To: <1432891828-4816-1-git-send-email-alex.bennee@linaro.org>
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
ICAgLSB1c2UgdTMyIGZvciBjb250cm9sIHJlZ3MKdjUKICAgLSByZXZlcnQgdG8gaGF2ZSBhcmNo
IHNwZWNpZmljIEtWTV9HVUVTVERCR19VU0VfU1cvSFdfQlAKICAgLSBybSBzdGFsZSBjb21tZW50
cyBkYmdjdHJsIHdhcyBzdG9yZWQgYXMgdTY0Ci0tLQogYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkv
YXNtL2t2bS5oIHwgMjAgKysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAyMCBp
bnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2
bS5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oCmluZGV4IGQyNjgzMjAuLjQz
NzU4ZTcgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaAorKysg
Yi9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3ZtLmgKQEAgLTEwMCwxMiArMTAwLDMyIEBA
IHN0cnVjdCBrdm1fc3JlZ3Mgewogc3RydWN0IGt2bV9mcHUgewogfTsKIAorLyoKKyAqIFNlZSB2
OCBBUk0gQVJNIEQ3LjM6IERlYnVnIFJlZ2lzdGVycworICoKKyAqIFRoZSBhcmNoaXRlY3R1cmFs
IGxpbWl0IGlzIDE2IGRlYnVnIHJlZ2lzdGVycyBvZiBlYWNoIHR5cGUgYWx0aG91Z2gKKyAqIGlu
IHByYWN0aWNlIHRoZXJlIGFyZSB1c3VhbGx5IGxlc3MgKHNlZSBJRF9BQTY0REZSMF9FTDEpLgor
ICovCisjZGVmaW5lIEtWTV9BUk1fTUFYX0RCR19SRUdTIDE2CiBzdHJ1Y3Qga3ZtX2d1ZXN0X2Rl
YnVnX2FyY2ggeworCV9fdTMyIGRiZ19iY3JbS1ZNX0FSTV9NQVhfREJHX1JFR1NdOworCV9fdTY0
IGRiZ19idnJbS1ZNX0FSTV9NQVhfREJHX1JFR1NdOworCV9fdTMyIGRiZ193Y3JbS1ZNX0FSTV9N
QVhfREJHX1JFR1NdOworCV9fdTY0IGRiZ193dnJbS1ZNX0FSTV9NQVhfREJHX1JFR1NdOwogfTsK
IAogc3RydWN0IGt2bV9kZWJ1Z19leGl0X2FyY2ggeworCV9fdTMyIGhzcjsKKwlfX3U2NCBmYXI7
CiB9OwogCisvKgorICogQXJjaGl0ZWN0dXJlIHNwZWNpZmljIGRlZmluZXMgZm9yIGt2bV9ndWVz
dF9kZWJ1Zy0+Y29udHJvbAorICovCisKKyNkZWZpbmUgS1ZNX0dVRVNUREJHX1VTRV9TV19CUAkJ
KDEgPDwgMTYpCisjZGVmaW5lIEtWTV9HVUVTVERCR19VU0VfSFdfQlAJCSgxIDw8IDE3KQorCiBz
dHJ1Y3Qga3ZtX3N5bmNfcmVncyB7CiB9OwogCi0tIAoyLjQuMQoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
