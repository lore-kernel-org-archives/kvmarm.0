From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Fangu=C3=A8de?=
 <j.fanguede@virtualopensystems.com>
Subject: [RFC 1/4] linux-headers update
Date: Tue,  5 May 2015 11:13:44 +0200
Message-ID: <1430817227-6278-2-git-send-email-j.fanguede@virtualopensystems.com>
References: <1430817227-6278-1-git-send-email-j.fanguede@virtualopensystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E08F4F8FD
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2015 05:05:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ix4W6SaA4WwU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2015 05:05:11 -0400 (EDT)
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com
 [209.85.212.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 876CE4F8DF
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2015 05:05:11 -0400 (EDT)
Received: by wizk4 with SMTP id k4so152035414wiz.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 May 2015 02:13:55 -0700 (PDT)
In-Reply-To: <1430817227-6278-1-git-send-email-j.fanguede@virtualopensystems.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org
Cc: tech@virtualopensystems.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

QWRkIEtWTV9GTFVTSF9EQ0FDSEVfR1BBIGlvY3RsLgoKU2lnbmVkLW9mZi1ieTogSsOpcsOpbXkg
RmFuZ3XDqGRlIDxqLmZhbmd1ZWRlQHZpcnR1YWxvcGVuc3lzdGVtcy5jb20+Ci0tLQogbGludXgt
aGVhZGVycy9saW51eC9rdm0uaCB8IDYgKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNlcnRp
b25zKCspCgpkaWZmIC0tZ2l0IGEvbGludXgtaGVhZGVycy9saW51eC9rdm0uaCBiL2xpbnV4LWhl
YWRlcnMvbGludXgva3ZtLmgKaW5kZXggYjk2ZDk3OC4uODFkMmY2NCAxMDA2NDQKLS0tIGEvbGlu
dXgtaGVhZGVycy9saW51eC9rdm0uaAorKysgYi9saW51eC1oZWFkZXJzL2xpbnV4L2t2bS5oCkBA
IC05NzgsNiArOTc4LDExIEBAIHN0cnVjdCBrdm1fYXJtX2RldmljZV9hZGRyIHsKIAlfX3U2NCBh
ZGRyOwogfTsKIAorc3RydWN0IGt2bV9tZW1fYWRkciB7CisJX191NjQgYWRkcjsKKwlfX3UzMiBs
ZW47Cit9OworCiAvKgogICogRGV2aWNlIGNvbnRyb2wgQVBJLCBhdmFpbGFibGUgd2l0aCBLVk1f
Q0FQX0RFVklDRV9DVFJMCiAgKi8KQEAgLTExOTksNiArMTIwNCw3IEBAIHN0cnVjdCBrdm1fczM5
MF91Y2FzX21hcHBpbmcgewogLyogQXZhaWxhYmxlIHdpdGggS1ZNX0NBUF9TMzkwX0lSUV9TVEFU
RSAqLwogI2RlZmluZSBLVk1fUzM5MF9TRVRfSVJRX1NUQVRFCSAgX0lPVyhLVk1JTywgMHhiNSwg
c3RydWN0IGt2bV9zMzkwX2lycV9zdGF0ZSkKICNkZWZpbmUgS1ZNX1MzOTBfR0VUX0lSUV9TVEFU
RQkgIF9JT1coS1ZNSU8sIDB4YjYsIHN0cnVjdCBrdm1fczM5MF9pcnFfc3RhdGUpCisjZGVmaW5l
IEtWTV9GTFVTSF9EQ0FDSEVfR1BBICAgICBfSU9XKEtWTUlPLCAgMHhiNywgc3RydWN0IGt2bV9t
ZW1fYWRkcikKIAogI2RlZmluZSBLVk1fREVWX0FTU0lHTl9FTkFCTEVfSU9NTVUJKDEgPDwgMCkK
ICNkZWZpbmUgS1ZNX0RFVl9BU1NJR05fUENJXzJfMwkJKDEgPDwgMSkKLS0gCjEuOS4xCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
