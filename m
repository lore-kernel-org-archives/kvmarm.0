Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59097C433C1
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 06:02:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0453461927
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 06:02:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0453461927
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABEB94B421;
	Mon, 22 Mar 2021 02:02:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GqYSr7jzvuvV; Mon, 22 Mar 2021 02:02:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACE6B4B38A;
	Mon, 22 Mar 2021 02:02:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29EA74B1C9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 02:02:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JhuckSxRaRiX for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 02:02:47 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E5EBC4B41F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 02:02:46 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F3kPn19bLz19GH0;
 Mon, 22 Mar 2021 14:00:45 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Mar 2021 14:02:33 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Will
 Deacon" <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 6/6] KVM: arm64: GICv4.1: Give a chance to save VLPI state
Date: Mon, 22 Mar 2021 14:01:58 +0800
Message-ID: <20210322060158.1584-7-lushenming@huawei.com>
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

QmVmb3JlIEdJQ3Y0LjEsIHdlIGRvbid0IGhhdmUgZGlyZWN0IGFjY2VzcyB0byB0aGUgVkxQSSBz
dGF0ZS4gU28Kd2Ugc2ltcGx5IGxldCBpdCBmYWlsIGVhcmx5IHdoZW4gZW5jb3VudGVyaW5nIGFu
eSBWTFBJIGluIHNhdmluZy4KCkJ1dCBub3cgd2UgZG9uJ3QgaGF2ZSB0byByZXR1cm4gLUVBQ0NF
UyBkaXJlY3RseSBpZiBvbiBHSUN2NC4xLiBMZXTigJlzCmNoYW5nZSB0aGUgaGFyZCBjb2RlIGFu
ZCBnaXZlIGEgY2hhbmNlIHRvIHNhdmUgdGhlIFZMUEkgc3RhdGUgKGFuZApwcmVzZXJ2ZSB0aGUg
VUFQSSkuCgpTaWduZWQtb2ZmLWJ5OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29t
PgotLS0KIERvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNlcy9hcm0tdmdpYy1pdHMucnN0IHwg
MiArLQogYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWl0cy5jICAgICAgICAgICAgICAgICAgfCA2
ICsrKy0tLQogMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0p
CgpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9kZXZpY2VzL2FybS12Z2ljLWl0
cy5yc3QgYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZnaWMtaXRzLnJzdApp
bmRleCA2YzMwNGZkMmIxYjQuLmQyNTdlZGRiYWUyOSAxMDA2NDQKLS0tIGEvRG9jdW1lbnRhdGlv
bi92aXJ0L2t2bS9kZXZpY2VzL2FybS12Z2ljLWl0cy5yc3QKKysrIGIvRG9jdW1lbnRhdGlvbi92
aXJ0L2t2bS9kZXZpY2VzL2FybS12Z2ljLWl0cy5yc3QKQEAgLTgwLDcgKzgwLDcgQEAgS1ZNX0RF
Vl9BUk1fVkdJQ19HUlBfQ1RSTAogICAgIC1FRkFVTFQgIEludmFsaWQgZ3Vlc3QgcmFtIGFjY2Vz
cwogICAgIC1FQlVTWSAgIE9uZSBvciBtb3JlIFZDUFVTIGFyZSBydW5uaW5nCiAgICAgLUVBQ0NF
UyAgVGhlIHZpcnR1YWwgSVRTIGlzIGJhY2tlZCBieSBhIHBoeXNpY2FsIEdJQ3Y0IElUUywgYW5k
IHRoZQotCSAgICAgc3RhdGUgaXMgbm90IGF2YWlsYWJsZQorCSAgICAgc3RhdGUgaXMgbm90IGF2
YWlsYWJsZSB3aXRob3V0IEdJQ3Y0LjEKICAgICA9PT09PT09ICA9PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CiAKIEtWTV9ERVZfQVJNX1ZH
SUNfR1JQX0lUU19SRUdTCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXRz
LmMgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXRzLmMKaW5kZXggNDBjYmFjYTgxMzMzLi5l
Yzc1NDNhOTYxN2MgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pdHMuYwor
KysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXRzLmMKQEAgLTIyMTgsMTAgKzIyMTgsMTAg
QEAgc3RhdGljIGludCB2Z2ljX2l0c19zYXZlX2l0dChzdHJ1Y3QgdmdpY19pdHMgKml0cywgc3Ry
dWN0IGl0c19kZXZpY2UgKmRldmljZSkKIAkJLyoKIAkJICogSWYgYW4gTFBJIGNhcnJpZXMgdGhl
IEhXIGJpdCwgdGhpcyBtZWFucyB0aGF0IHRoaXMKIAkJICogaW50ZXJydXB0IGlzIGNvbnRyb2xs
ZWQgYnkgR0lDdjQsIGFuZCB3ZSBkbyBub3QKLQkJICogaGF2ZSBkaXJlY3QgYWNjZXNzIHRvIHRo
YXQgc3RhdGUuIExldCdzIHNpbXBseSBmYWlsCi0JCSAqIHRoZSBzYXZlIG9wZXJhdGlvbi4uLgor
CQkgKiBoYXZlIGRpcmVjdCBhY2Nlc3MgdG8gdGhhdCBzdGF0ZSB3aXRob3V0IEdJQ3Y0LjEuCisJ
CSAqIExldCdzIHNpbXBseSBmYWlsIHRoZSBzYXZlIG9wZXJhdGlvbi4uLgogCQkgKi8KLQkJaWYg
KGl0ZS0+aXJxLT5odykKKwkJaWYgKGl0ZS0+aXJxLT5odyAmJiAha3ZtX3ZnaWNfZ2xvYmFsX3N0
YXRlLmhhc19naWN2NF8xKQogCQkJcmV0dXJuIC1FQUNDRVM7CiAKIAkJcmV0ID0gdmdpY19pdHNf
c2F2ZV9pdGUoaXRzLCBkZXZpY2UsIGl0ZSwgZ3BhLCBpdGVfZXN6KTsKLS0gCjIuMTkuMQoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxp
bmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29s
dW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
