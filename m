Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B849AC19F2D
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 10:28:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 747EB4C514;
	Tue,  9 Aug 2022 06:28:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z6u8m6tQGXHm; Tue,  9 Aug 2022 06:28:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 844FE4C967;
	Tue,  9 Aug 2022 06:28:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 757364C5B9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:33:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id f1kptq1kt9qs for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:33:34 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3EAE04C3F8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:33:34 -0400 (EDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M278W3cP5zjXWx;
 Tue,  9 Aug 2022 17:30:19 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 9 Aug 2022 17:33:29 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 9 Aug
 2022 17:33:29 +0800
From: Yang Yingliang <yangyingliang@huawei.com>
To: <linux-kernel@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] KVM: arm64: fix compile error because of shift overflow
Date: Tue, 9 Aug 2022 17:41:58 +0800
Message-ID: <20220809094158.4080636-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Tue, 09 Aug 2022 06:28:50 -0400
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

Q2hhbmdlIHRoZSBtYXNrIHRvIHVuc2lnbmVkIHRvIGZpeCB0aGUgZm9sbG93aW5nIGZpeCBjb21w
aWxlIGVycm9yCmJlY2F1c2Ugb2Ygc2hpZnQgb3ZlcmZsb3cgd2hlbiB1c2luZyBsb3cgdmVyaXNv
biBnY2MobWluZSB2ZXJzaW9uIGlzIDcuNSk6CgpJbiBmdW5jdGlvbiDigJhrdm1fdm1faW9jdGxf
c2V0X2RldmljZV9hZGRyLmlzcmEuMzjigJksCiAgICBpbmxpbmVkIGZyb20g4oCYa3ZtX2FyY2hf
dm1faW9jdGzigJkgYXQgYXJjaC9hcm02NC9rdm0vYXJtLmM6MTQ1NDoxMDoKLi8uL2luY2x1ZGUv
bGludXgvY29tcGlsZXJfdHlwZXMuaDozNTQ6Mzg6IGVycm9yOiBjYWxsIHRvIOKAmF9fY29tcGls
ZXRpbWVfYXNzZXJ0XzU5OeKAmSBcCmRlY2xhcmVkIHdpdGggYXR0cmlidXRlIGVycm9yOiBGSUVM
RF9HRVQ6IG1hc2sgaXMgbm90IGNvbnN0YW50CiAgX2NvbXBpbGV0aW1lX2Fzc2VydChjb25kaXRp
b24sIG1zZywgX19jb21waWxldGltZV9hc3NlcnRfLCBfX0NPVU5URVJfXykKCkZpeGVzOiA5Zjk2
OGM5MjY2YWEgKCJLVk06IGFybTY0OiB2Z2ljLXYyOiBBZGQgaGVscGVyIGZvciBsZWdhY3kgZGlz
dC9jcHVpZiBiYXNlIGFkZHJlc3Mgc2V0dGluZyIpClNpZ25lZC1vZmYtYnk6IFlhbmcgWWluZ2xp
YW5nIDx5YW5neWluZ2xpYW5nQGh1YXdlaS5jb20+Ci0tLQogYXJjaC9hcm02NC9pbmNsdWRlL3Vh
cGkvYXNtL2t2bS5oIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRl
bGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5o
IGIvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oCmluZGV4IDNiYjEzNDM1NTg3NC4u
MDRmZmExM2Q1ZTBhIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvdWFwaS9hc20va3Zt
LmgKKysrIGIvYXJjaC9hcm02NC9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oCkBAIC03Nyw3ICs3Nyw3
IEBAIHN0cnVjdCBrdm1fcmVncyB7CiAjZGVmaW5lIEtWTV9BUk1fREVWSUNFX1RZUEVfU0hJRlQJ
MAogI2RlZmluZSBLVk1fQVJNX0RFVklDRV9UWVBFX01BU0sJKDB4ZmZmZiA8PCBLVk1fQVJNX0RF
VklDRV9UWVBFX1NISUZUKQogI2RlZmluZSBLVk1fQVJNX0RFVklDRV9JRF9TSElGVAkJMTYKLSNk
ZWZpbmUgS1ZNX0FSTV9ERVZJQ0VfSURfTUFTSwkJKDB4ZmZmZiA8PCBLVk1fQVJNX0RFVklDRV9J
RF9TSElGVCkKKyNkZWZpbmUgS1ZNX0FSTV9ERVZJQ0VfSURfTUFTSwkJKDB4ZmZmZnUgPDwgS1ZN
X0FSTV9ERVZJQ0VfSURfU0hJRlQpCiAKIC8qIFN1cHBvcnRlZCBkZXZpY2UgSURzICovCiAjZGVm
aW5lIEtWTV9BUk1fREVWSUNFX1ZHSUNfVjIJCTAKLS0gCjIuMjUuMQoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1h
cm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21h
aWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
