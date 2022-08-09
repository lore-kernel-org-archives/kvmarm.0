Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F64FC25B0C
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 13:43:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBA7F4CCB6;
	Tue,  9 Aug 2022 09:43:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WUqhdSKGeC4h; Tue,  9 Aug 2022 09:43:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 682684CC9D;
	Tue,  9 Aug 2022 09:43:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 728D34CC96
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 09:43:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RKjbeLL-rPDO for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 09:43:03 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87B074CC88
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 09:43:03 -0400 (EDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M2DhM4j6czjXPs;
 Tue,  9 Aug 2022 21:39:47 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 9 Aug 2022 21:42:58 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 9 Aug
 2022 21:42:57 +0800
From: Yang Yingliang <yangyingliang@huawei.com>
To: <linux-kernel@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v2] KVM: arm64: fix compile error because of shift overflow
Date: Tue, 9 Aug 2022 21:51:27 +0800
Message-ID: <20220809135127.480285-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
b2ZmLWJ5OiBZYW5nIFlpbmdsaWFuZyA8eWFuZ3lpbmdsaWFuZ0BodWF3ZWkuY29tPgotLS0KdjI6
CiAgVXNpbmcgR0VOTUFTSygpIHRvIGdlbmVyYXRlIHRoZSBtYXNrcy4KLS0tCiBhcmNoL2FybTY0
L2luY2x1ZGUvdWFwaS9hc20va3ZtLmggfCA0ICsrLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRl
L3VhcGkvYXNtL2t2bS5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oCmluZGV4
IDNiYjEzNDM1NTg3NC4uNWU3ZGZhZjc2ZWMxIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2luY2x1
ZGUvdWFwaS9hc20va3ZtLmgKKysrIGIvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5o
CkBAIC03NSw5ICs3NSw5IEBAIHN0cnVjdCBrdm1fcmVncyB7CiAKIC8qIEtWTV9BUk1fU0VUX0RF
VklDRV9BRERSIGlvY3RsIGlkIGVuY29kaW5nICovCiAjZGVmaW5lIEtWTV9BUk1fREVWSUNFX1RZ
UEVfU0hJRlQJMAotI2RlZmluZSBLVk1fQVJNX0RFVklDRV9UWVBFX01BU0sJKDB4ZmZmZiA8PCBL
Vk1fQVJNX0RFVklDRV9UWVBFX1NISUZUKQorI2RlZmluZSBLVk1fQVJNX0RFVklDRV9UWVBFX01B
U0sJR0VOTUFTSygxNSwgS1ZNX0FSTV9ERVZJQ0VfVFlQRV9TSElGVCkKICNkZWZpbmUgS1ZNX0FS
TV9ERVZJQ0VfSURfU0hJRlQJCTE2Ci0jZGVmaW5lIEtWTV9BUk1fREVWSUNFX0lEX01BU0sJCSgw
eGZmZmYgPDwgS1ZNX0FSTV9ERVZJQ0VfSURfU0hJRlQpCisjZGVmaW5lIEtWTV9BUk1fREVWSUNF
X0lEX01BU0sJCUdFTk1BU0soMzEsIEtWTV9BUk1fREVWSUNFX0lEX1NISUZUKQogCiAvKiBTdXBw
b3J0ZWQgZGV2aWNlIElEcyAqLwogI2RlZmluZSBLVk1fQVJNX0RFVklDRV9WR0lDX1YyCQkwCi0t
IAoyLjI1LjEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
