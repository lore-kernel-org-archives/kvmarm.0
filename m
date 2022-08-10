Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE2C7C19F2D
	for <kvmarm@archiver.kernel.org>; Wed, 10 Aug 2022 01:26:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 64EF44D184;
	Tue,  9 Aug 2022 21:26:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k3SRs88WFEHC; Tue,  9 Aug 2022 21:26:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14CFF4D187;
	Tue,  9 Aug 2022 21:26:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98D0E4D184
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 21:26:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lrwprsct10Z9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 21:26:11 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 48AC94D183
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 21:26:11 -0400 (EDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.55])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M2XJz3RDFzmVcn;
 Wed, 10 Aug 2022 09:24:03 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 09:26:07 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 10 Aug
 2022 09:26:06 +0800
From: Yang Yingliang <yangyingliang@huawei.com>
To: <linux-kernel@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3] KVM: arm64: fix compile error because of shift overflow
Date: Wed, 10 Aug 2022 09:34:35 +0800
Message-ID: <20220810013435.1525363-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
Cc: maz@kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

VXNpbmcgR0VOTUFTSygpIHRvIGdlbmVyYXRlIHRoZSBtYXNrcyBvZiBkZXZpY2UgdHlwZSBhbmQg
ZGV2aWNlIGlkLCBpdCBtYWtlcwpjb2RlIHVuYW1iaWd1b3VzLCBhbHNvIGl0IGNhbiBmaXggdGhl
IGZvbGxvd2luZyBmaXggY29tcGlsZSBlcnJvciBiZWNhdXNlIG9mCnNoaWZ0IG92ZXJmbG93IHdo
ZW4gdXNpbmcgbG93IHZlcmlzb24gZ2NjKG1pbmUgdmVyc2lvbiBpcyA3LjUpOgoKSW4gZnVuY3Rp
b24g4oCYa3ZtX3ZtX2lvY3RsX3NldF9kZXZpY2VfYWRkci5pc3JhLjM44oCZLAogICAgaW5saW5l
ZCBmcm9tIOKAmGt2bV9hcmNoX3ZtX2lvY3Rs4oCZIGF0IGFyY2gvYXJtNjQva3ZtL2FybS5jOjE0
NTQ6MTA6Ci4vLi9pbmNsdWRlL2xpbnV4L2NvbXBpbGVyX3R5cGVzLmg6MzU0OjM4OiBlcnJvcjog
Y2FsbCB0byDigJhfX2NvbXBpbGV0aW1lX2Fzc2VydF81OTnigJkgXApkZWNsYXJlZCB3aXRoIGF0
dHJpYnV0ZSBlcnJvcjogRklFTERfR0VUOiBtYXNrIGlzIG5vdCBjb25zdGFudAogIF9jb21waWxl
dGltZV9hc3NlcnQoY29uZGl0aW9uLCBtc2csIF9fY29tcGlsZXRpbWVfYXNzZXJ0XywgX19DT1VO
VEVSX18pCgpGaXhlczogOWY5NjhjOTI2NmFhICgiS1ZNOiBhcm02NDogdmdpYy12MjogQWRkIGhl
bHBlciBmb3IgbGVnYWN5IGRpc3QvY3B1aWYgYmFzZSBhZGRyZXNzIHNldHRpbmciKQpTaWduZWQt
b2ZmLWJ5OiBZYW5nIFlpbmdsaWFuZyA8eWFuZ3lpbmdsaWFuZ0BodWF3ZWkuY29tPgotLS0KdjM6
CiByZXBsYWNlICcxNS8zMScgd2l0aCAnU0hJRlQgKyAxNScgdG8gbWFrZSBpdCBtb3JlIHJlYWRh
YmxlLgp2MjoKICBVc2luZyBHRU5NQVNLKCkgdG8gZ2VuZXJhdGUgdGhlIG1hc2tzLgotLS0KIGFy
Y2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaCB8IDYgKysrKy0tCiAxIGZpbGUgY2hhbmdl
ZCwgNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQvaW5jbHVkZS91YXBpL2FzbS9rdm0uaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS91YXBpL2FzbS9r
dm0uaAppbmRleCAzYmIxMzQzNTU4NzQuLjMxNjkxN2I5ODcwNyAxMDA2NDQKLS0tIGEvYXJjaC9h
cm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oCisrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS91YXBp
L2FzbS9rdm0uaApAQCAtNzUsOSArNzUsMTEgQEAgc3RydWN0IGt2bV9yZWdzIHsKIAogLyogS1ZN
X0FSTV9TRVRfREVWSUNFX0FERFIgaW9jdGwgaWQgZW5jb2RpbmcgKi8KICNkZWZpbmUgS1ZNX0FS
TV9ERVZJQ0VfVFlQRV9TSElGVAkwCi0jZGVmaW5lIEtWTV9BUk1fREVWSUNFX1RZUEVfTUFTSwko
MHhmZmZmIDw8IEtWTV9BUk1fREVWSUNFX1RZUEVfU0hJRlQpCisjZGVmaW5lIEtWTV9BUk1fREVW
SUNFX1RZUEVfTUFTSwlHRU5NQVNLKEtWTV9BUk1fREVWSUNFX1RZUEVfU0hJRlQgKyAxNSwgXAor
CQkJCQkJS1ZNX0FSTV9ERVZJQ0VfVFlQRV9TSElGVCkKICNkZWZpbmUgS1ZNX0FSTV9ERVZJQ0Vf
SURfU0hJRlQJCTE2Ci0jZGVmaW5lIEtWTV9BUk1fREVWSUNFX0lEX01BU0sJCSgweGZmZmYgPDwg
S1ZNX0FSTV9ERVZJQ0VfSURfU0hJRlQpCisjZGVmaW5lIEtWTV9BUk1fREVWSUNFX0lEX01BU0sJ
CUdFTk1BU0soS1ZNX0FSTV9ERVZJQ0VfSURfU0hJRlQgKyAxNSwgXAorCQkJCQkJS1ZNX0FSTV9E
RVZJQ0VfSURfU0hJRlQpCiAKIC8qIFN1cHBvcnRlZCBkZXZpY2UgSURzICovCiAjZGVmaW5lIEtW
TV9BUk1fREVWSUNFX1ZHSUNfVjIJCTAKLS0gCjIuMjUuMQoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
