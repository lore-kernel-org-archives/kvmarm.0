Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9388C6379D
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 08:35:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2ECEB20727
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 08:35:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2ECEB20727
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93ED54BB04;
	Mon, 23 Nov 2020 03:35:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CwMShy8GKjwC; Mon, 23 Nov 2020 03:35:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 306EB4BB41;
	Mon, 23 Nov 2020 03:35:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59D674BA61
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 01:55:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OXdvheFA0Ssr for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 01:55:01 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B6D84BA50
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 01:55:01 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CfdDt1sSMzhg2x;
 Mon, 23 Nov 2020 14:54:38 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.187.74) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 23 Nov 2020 14:54:46 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, "Julien
 Thierry" <julien.thierry.kdev@gmail.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Eric Auger <eric.auger@redhat.com>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Christoffer Dall
 <christoffer.dall@arm.com>
Subject: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending state
 to physical side
Date: Mon, 23 Nov 2020 14:54:09 +0800
Message-ID: <20201123065410.1915-4-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20201123065410.1915-1-lushenming@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Mon, 23 Nov 2020 03:35:49 -0500
Cc: Neo Jia <cjia@nvidia.com>, Cornelia Huck <cohuck@redhat.com>,
 Kirti Wankhede <kwankhede@nvidia.com>, lushenming@huawei.com,
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
IGZvcndhcmRpbmcgcGF0aCBvZiBhIFZMUEksIGl0IGlzIG1vcmUgY29uc2lzdGVudCB0bwphbHNv
IHRyYW5zZmVyIHRoZSBwZW5kaW5nIHN0YXRlIGZyb20gaXJxLT5wZW5kaW5nX2xhdGNoIHRvIFZQ
VCAoZXNwZWNpYWxseQppbiBtaWdyYXRpb24sIHRoZSBwZW5kaW5nIHN0YXRlcyBvZiBWTFBJcyBh
cmUgcmVzdG9yZWQgaW50byBrdm3igJlzIHZnaWMKZmlyc3QpLiBBbmQgd2UgY3VycmVudGx5IHNl
bmQgIklOVCtWU1lOQyIgdG8gdHJpZ2dlciBhIFZMUEkgdG8gcGVuZGluZy4KClNpZ25lZC1vZmYt
Ynk6IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgpTaWduZWQtb2ZmLWJ5OiBTaGVu
bWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPgotLS0KIGFyY2gvYXJtNjQva3ZtL3ZnaWMv
dmdpYy12NC5jIHwgMTIgKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9u
cygrKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jIGIvYXJjaC9h
cm02NC9rdm0vdmdpYy92Z2ljLXY0LmMKaW5kZXggYjVmYTczYzlmZDM1Li5jYzNhYjljZWExODIg
MTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jCisrKyBiL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy12NC5jCkBAIC00MTgsNiArNDE4LDE4IEBAIGludCBrdm1fdmdpY192
NF9zZXRfZm9yd2FyZGluZyhzdHJ1Y3Qga3ZtICprdm0sIGludCB2aXJxLAogCWlycS0+aG9zdF9p
cnEJPSB2aXJxOwogCWF0b21pY19pbmMoJm1hcC52cGUtPnZscGlfY291bnQpOwogCisJLyogVHJh
bnNmZXIgcGVuZGluZyBzdGF0ZSAqLworCXJldCA9IGlycV9zZXRfaXJxY2hpcF9zdGF0ZShpcnEt
Pmhvc3RfaXJxLAorCQkJCSAgICBJUlFDSElQX1NUQVRFX1BFTkRJTkcsCisJCQkJICAgIGlycS0+
cGVuZGluZ19sYXRjaCk7CisJV0FSTl9SQVRFTElNSVQocmV0LCAiSVJRICVkIiwgaXJxLT5ob3N0
X2lycSk7CisKKwkvKgorCSAqIExldCBpdCBiZSBwcnVuZWQgZnJvbSBhcF9saXN0IGxhdGVyIGFu
ZCBkb24ndCBib3RoZXIKKwkgKiB0aGUgTGlzdCBSZWdpc3Rlci4KKwkgKi8KKwlpcnEtPnBlbmRp
bmdfbGF0Y2ggPSBmYWxzZTsKKwogb3V0OgogCW11dGV4X3VubG9jaygmaXRzLT5pdHNfbG9jayk7
CiAJcmV0dXJuIHJldDsKLS0gCjIuMjMuMAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29s
dW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8v
a3ZtYXJtCg==
