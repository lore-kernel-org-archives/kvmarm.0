Return-Path: <SRS0=9gNu=IL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21E2C433E6
	for <kvmarm@archiver.kernel.org>; Sat, 13 Mar 2021 08:40:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 47EDA64DF3
	for <kvmarm@archiver.kernel.org>; Sat, 13 Mar 2021 08:40:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47EDA64DF3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2EDE4B51B;
	Sat, 13 Mar 2021 03:40:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q6NRjduI7Xxs; Sat, 13 Mar 2021 03:40:01 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0F4F4B556;
	Sat, 13 Mar 2021 03:40:00 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0CAF4B531
 for <kvmarm@lists.cs.columbia.edu>; Sat, 13 Mar 2021 03:39:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XaxPpc6XNTea for <kvmarm@lists.cs.columbia.edu>;
 Sat, 13 Mar 2021 03:39:58 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E7F44B49A
 for <kvmarm@lists.cs.columbia.edu>; Sat, 13 Mar 2021 03:39:58 -0500 (EST)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DyGKT1Vswz8wxp;
 Sat, 13 Mar 2021 16:38:05 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Sat, 13 Mar 2021 16:39:45 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Will
 Deacon" <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 5/6] KVM: arm64: GICv4.1: Restore VLPI pending state to
 physical side
Date: Sat, 13 Mar 2021 16:38:59 +0800
Message-ID: <20210313083900.234-6-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210313083900.234-1-lushenming@huawei.com>
References: <20210313083900.234-1-lushenming@huawei.com>
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
L3ZnaWMvdmdpYy12NC5jIHwgMTggKysrKysrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwg
MTggaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12
NC5jIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMKaW5kZXggYWMwMjliYTNkMzM3Li4z
YjgyYWI4MGMyZjMgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCisr
KyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCkBAIC00NDksNiArNDQ5LDI0IEBAIGlu
dCBrdm1fdmdpY192NF9zZXRfZm9yd2FyZGluZyhzdHJ1Y3Qga3ZtICprdm0sIGludCB2aXJxLAog
CWlycS0+aG9zdF9pcnEJPSB2aXJxOwogCWF0b21pY19pbmMoJm1hcC52cGUtPnZscGlfY291bnQp
OwogCisJLyogVHJhbnNmZXIgcGVuZGluZyBzdGF0ZSAqLworCWlmIChpcnEtPnBlbmRpbmdfbGF0
Y2gpIHsKKwkJdW5zaWduZWQgbG9uZyBmbGFnczsKKworCQlyZXQgPSBpcnFfc2V0X2lycWNoaXBf
c3RhdGUoaXJxLT5ob3N0X2lycSwKKwkJCQkJICAgIElSUUNISVBfU1RBVEVfUEVORElORywKKwkJ
CQkJICAgIGlycS0+cGVuZGluZ19sYXRjaCk7CisJCVdBUk5fUkFURUxJTUlUKHJldCwgIklSUSAl
ZCIsIGlycS0+aG9zdF9pcnEpOworCisJCS8qCisJCSAqIENsZWFyIHBlbmRpbmdfbGF0Y2ggYW5k
IGNvbW11bmljYXRlIHRoaXMgc3RhdGUKKwkJICogY2hhbmdlIHZpYSB2Z2ljX3F1ZXVlX2lycV91
bmxvY2suCisJCSAqLworCQlyYXdfc3Bpbl9sb2NrX2lycXNhdmUoJmlycS0+aXJxX2xvY2ssIGZs
YWdzKTsKKwkJaXJxLT5wZW5kaW5nX2xhdGNoID0gZmFsc2U7CisJCXZnaWNfcXVldWVfaXJxX3Vu
bG9jayhrdm0sIGlycSwgZmxhZ3MpOworCX0KKwogb3V0OgogCW11dGV4X3VubG9jaygmaXRzLT5p
dHNfbG9jayk7CiAJcmV0dXJuIHJldDsKLS0gCjIuMTkuMQoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
