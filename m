Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F788C433C1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 06:02:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A0F7161966
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 06:02:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0F7161966
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43D1B4B43D;
	Mon, 22 Mar 2021 02:02:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BR2e+4jkXDe9; Mon, 22 Mar 2021 02:02:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 416704B40B;
	Mon, 22 Mar 2021 02:02:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15AA74B409
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 02:02:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MJ1Dhp1Jo5l7 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 02:02:40 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6DDB4B3D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 02:02:39 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F3kP41QwnzNq3Y;
 Mon, 22 Mar 2021 14:00:08 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Mar 2021 14:02:31 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Will
 Deacon" <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 5/6] KVM: arm64: GICv4.1: Restore VLPI pending state to
 physical side
Date: Mon, 22 Mar 2021 14:01:57 +0800
Message-ID: <20210322060158.1584-6-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210322060158.1584-1-lushenming@huawei.com>
References: <20210322060158.1584-1-lushenming@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.184.135]
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
IGZvcndhcmRpbmcgcGF0aCBvZiBhIFZMUEkgKHN3aXRjaCB0byB0aGUgSFcgbW9kZSksCndlIGNh
biBhbHNvIHRyYW5zZmVyIHRoZSBwZW5kaW5nIHN0YXRlIGZyb20gaXJxLT5wZW5kaW5nX2xhdGNo
IHRvClZQVCAoZXNwZWNpYWxseSBpbiBtaWdyYXRpb24sIHRoZSBwZW5kaW5nIHN0YXRlcyBvZiBW
TFBJcyBhcmUgcmVzdG9yZWQKaW50byBrdm3igJlzIHZnaWMgZmlyc3QpLiBBbmQgd2UgY3VycmVu
dGx5IHNlbmQgIklOVCtWU1lOQyIgdG8gdHJpZ2dlcgphIFZMUEkgdG8gcGVuZGluZy4KClNpZ25l
ZC1vZmYtYnk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgpTaWduZWQtb2ZmLWJ5
OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPgotLS0KIGFyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy12NC5jIHwgMTkgKysrKysrKysrKysrKysrKysrKwogMSBmaWxlIGNoYW5nZWQs
IDE5IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
djQuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCmluZGV4IGFjMDI5YmEzZDMzNy4u
YzE4NDVkOGY1ZjdlIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYwor
KysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjQuYwpAQCAtNDA0LDYgKzQwNCw3IEBAIGlu
dCBrdm1fdmdpY192NF9zZXRfZm9yd2FyZGluZyhzdHJ1Y3Qga3ZtICprdm0sIGludCB2aXJxLAog
CXN0cnVjdCB2Z2ljX2l0cyAqaXRzOwogCXN0cnVjdCB2Z2ljX2lycSAqaXJxOwogCXN0cnVjdCBp
dHNfdmxwaV9tYXAgbWFwOworCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAJaW50IHJldDsKIAogCWlm
ICghdmdpY19zdXBwb3J0c19kaXJlY3RfbXNpcyhrdm0pKQpAQCAtNDQ5LDYgKzQ1MCwyNCBAQCBp
bnQga3ZtX3ZnaWNfdjRfc2V0X2ZvcndhcmRpbmcoc3RydWN0IGt2bSAqa3ZtLCBpbnQgdmlycSwK
IAlpcnEtPmhvc3RfaXJxCT0gdmlycTsKIAlhdG9taWNfaW5jKCZtYXAudnBlLT52bHBpX2NvdW50
KTsKIAorCS8qIFRyYW5zZmVyIHBlbmRpbmcgc3RhdGUgKi8KKwlyYXdfc3Bpbl9sb2NrX2lycXNh
dmUoJmlycS0+aXJxX2xvY2ssIGZsYWdzKTsKKwlpZiAoaXJxLT5wZW5kaW5nX2xhdGNoKSB7CisJ
CXJldCA9IGlycV9zZXRfaXJxY2hpcF9zdGF0ZShpcnEtPmhvc3RfaXJxLAorCQkJCQkgICAgSVJR
Q0hJUF9TVEFURV9QRU5ESU5HLAorCQkJCQkgICAgaXJxLT5wZW5kaW5nX2xhdGNoKTsKKwkJV0FS
Tl9SQVRFTElNSVQocmV0LCAiSVJRICVkIiwgaXJxLT5ob3N0X2lycSk7CisKKwkJLyoKKwkJICog
Q2xlYXIgcGVuZGluZ19sYXRjaCBhbmQgY29tbXVuaWNhdGUgdGhpcyBzdGF0ZQorCQkgKiBjaGFu
Z2UgdmlhIHZnaWNfcXVldWVfaXJxX3VubG9jay4KKwkJICovCisJCWlycS0+cGVuZGluZ19sYXRj
aCA9IGZhbHNlOworCQl2Z2ljX3F1ZXVlX2lycV91bmxvY2soa3ZtLCBpcnEsIGZsYWdzKTsKKwl9
IGVsc2UgeworCQlyYXdfc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaXJxLT5pcnFfbG9jaywgZmxh
Z3MpOworCX0KKwogb3V0OgogCW11dGV4X3VubG9jaygmaXRzLT5pdHNfbG9jayk7CiAJcmV0dXJu
IHJldDsKLS0gCjIuMTkuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
