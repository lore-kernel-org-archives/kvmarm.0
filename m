Return-Path: <SRS0=cUgw=G6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A306C433E0
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 12:14:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 12A7720780
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 12:14:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12A7720780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6286A4B122;
	Wed, 27 Jan 2021 07:14:27 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tWnb3QG1Vu9h; Wed, 27 Jan 2021 07:14:26 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D8684B229;
	Wed, 27 Jan 2021 07:14:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8A6D4B125
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 07:14:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id od8ahdYDcRnn for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jan 2021 07:14:24 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A65534B122
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 07:14:24 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQjDF3lVtzjDSK;
 Wed, 27 Jan 2021 20:13:01 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.186.182) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 27 Jan 2021 20:14:07 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Will
 Deacon" <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending state to
 physical side
Date: Wed, 27 Jan 2021 20:13:36 +0800
Message-ID: <20210127121337.1092-4-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210127121337.1092-1-lushenming@huawei.com>
References: <20210127121337.1092-1-lushenming@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.186.182]
X-CFilter-Loop: Reflected
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Cornelia Huck <cohuck@redhat.com>, lushenming@huawei.com,
 Alex Williamson <alex.williamson@redhat.com>
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

RnJvbTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+CgpXaGVuIHNldHRpbmcgdGhl
IGZvcndhcmRpbmcgcGF0aCBvZiBhIFZMUEkgKHN3aXRjaCB0byB0aGUgSFcgbW9kZSksCndlIGNv
dWxkIGFsc28gdHJhbnNmZXIgdGhlIHBlbmRpbmcgc3RhdGUgZnJvbSBpcnEtPnBlbmRpbmdfbGF0
Y2ggdG8KVlBUIChlc3BlY2lhbGx5IGluIG1pZ3JhdGlvbiwgdGhlIHBlbmRpbmcgc3RhdGVzIG9m
IFZMUElzIGFyZSByZXN0b3JlZAppbnRvIGt2beKAmXMgdmdpYyBmaXJzdCkuIEFuZCB3ZSBjdXJy
ZW50bHkgc2VuZCAiSU5UK1ZTWU5DIiB0byB0cmlnZ2VyCmEgVkxQSSB0byBwZW5kaW5nLgoKU2ln
bmVkLW9mZi1ieTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+ClNpZ25lZC1vZmYt
Ynk6IFNoZW5taW5nIEx1IDxsdXNoZW5taW5nQGh1YXdlaS5jb20+Ci0tLQogYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLXY0LmMgfCAxNCArKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQsIDE0
IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQu
YyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCmluZGV4IGFjMDI5YmEzZDMzNy4uYTM1
NDJhZjZmMDRhIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYworKysg
Yi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYwpAQCAtNDQ5LDYgKzQ0OSwyMCBAQCBpbnQg
a3ZtX3ZnaWNfdjRfc2V0X2ZvcndhcmRpbmcoc3RydWN0IGt2bSAqa3ZtLCBpbnQgdmlycSwKIAlp
cnEtPmhvc3RfaXJxCT0gdmlycTsKIAlhdG9taWNfaW5jKCZtYXAudnBlLT52bHBpX2NvdW50KTsK
IAorCS8qIFRyYW5zZmVyIHBlbmRpbmcgc3RhdGUgKi8KKwlpZiAoaXJxLT5wZW5kaW5nX2xhdGNo
KSB7CisJCXJldCA9IGlycV9zZXRfaXJxY2hpcF9zdGF0ZShpcnEtPmhvc3RfaXJxLAorCQkJCQkg
ICAgSVJRQ0hJUF9TVEFURV9QRU5ESU5HLAorCQkJCQkgICAgaXJxLT5wZW5kaW5nX2xhdGNoKTsK
KwkJV0FSTl9SQVRFTElNSVQocmV0LCAiSVJRICVkIiwgaXJxLT5ob3N0X2lycSk7CisKKwkJLyoK
KwkJICogTGV0IGl0IGJlIHBydW5lZCBmcm9tIGFwX2xpc3QgbGF0ZXIgYW5kIGRvbid0IGJvdGhl
cgorCQkgKiB0aGUgTGlzdCBSZWdpc3Rlci4KKwkJICovCisJCWlycS0+cGVuZGluZ19sYXRjaCA9
IGZhbHNlOworCX0KKwogb3V0OgogCW11dGV4X3VubG9jaygmaXRzLT5pdHNfbG9jayk7CiAJcmV0
dXJuIHJldDsKLS0gCjIuMTkuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
