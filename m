Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7481C56202
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 08:35:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA12520729
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 08:35:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA12520729
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 68FE64BB45;
	Mon, 23 Nov 2020 03:35:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 74+SjflExRCf; Mon, 23 Nov 2020 03:35:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2D8E4BB32;
	Mon, 23 Nov 2020 03:35:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1662A4BA30
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 01:54:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ATMVLdU3BpmZ for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 01:54:54 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4AE324BA5F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 01:54:54 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CfdDn1KpJzhg2v;
 Mon, 23 Nov 2020 14:54:33 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.187.74) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 23 Nov 2020 14:54:43 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, "Julien
 Thierry" <julien.thierry.kdev@gmail.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Eric Auger <eric.auger@redhat.com>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Christoffer Dall
 <christoffer.dall@arm.com>
Subject: [RFC PATCH v1 2/4] KVM: arm64: GICv4.1: Try to save hw pending state
 in save_pending_tables
Date: Mon, 23 Nov 2020 14:54:08 +0800
Message-ID: <20201123065410.1915-3-lushenming@huawei.com>
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

QWZ0ZXIgcGF1c2luZyBhbGwgdkNQVXMgYW5kIGRldmljZXMgY2FwYWJsZSBvZiBpbnRlcnJ1cHRp
bmcsIGluIG9yZGVyCnRvIHNhdmUgdGhlIGluZm9ybWF0aW9uIG9mIGFsbCBpbnRlcnJ1cHRzLCBi
ZXNpZGVzIGZsdXNoaW5nIHRoZSBwZW5kaW5nCnN0YXRlcyBpbiBrdm3igJlzIHZnaWMsIHdlIGFs
c28gdHJ5IHRvIGZsdXNoIHRoZSBzdGF0ZXMgb2YgVkxQSXMgaW4gdGhlCnZpcnR1YWwgcGVuZGlu
ZyB0YWJsZXMgaW50byBndWVzdCBSQU0sIGJ1dCB3ZSBuZWVkIHRvIGhhdmUgR0lDdjQuMSBhbmQK
c2FmZWx5IHVubWFwIHRoZSB2UEVzIGZpcnN0LgoKU2lnbmVkLW9mZi1ieTogU2hlbm1pbmcgTHUg
PGx1c2hlbm1pbmdAaHVhd2VpLmNvbT4KLS0tCiBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMu
YyB8IDYyICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgNTYgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtdjMuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jCmlu
ZGV4IDljZGYzOWE5NGE2My4uZTFiM2FhNGIyYjEyIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2
bS92Z2ljL3ZnaWMtdjMuYworKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYwpAQCAt
MSw2ICsxLDggQEAKIC8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKIAog
I2luY2x1ZGUgPGxpbnV4L2lycWNoaXAvYXJtLWdpYy12My5oPgorI2luY2x1ZGUgPGxpbnV4L2ly
cS5oPgorI2luY2x1ZGUgPGxpbnV4L2lycWRvbWFpbi5oPgogI2luY2x1ZGUgPGxpbnV4L2t2bS5o
PgogI2luY2x1ZGUgPGxpbnV4L2t2bV9ob3N0Lmg+CiAjaW5jbHVkZSA8a3ZtL2FybV92Z2ljLmg+
CkBAIC0zNTYsNiArMzU4LDM5IEBAIGludCB2Z2ljX3YzX2xwaV9zeW5jX3BlbmRpbmdfc3RhdHVz
KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IHZnaWNfaXJxICppcnEpCiAJcmV0dXJuIDA7CiB9CiAK
Ky8qCisgKiBXaXRoIEdJQ3Y0LjEsIHdlIGNhbiBnZXQgdGhlIFZMUEkncyBwZW5kaW5nIHN0YXRl
IGFmdGVyIHVubWFwcGluZworICogdGhlIHZQRS4gVGhlIGRlYWN0aXZhdGlvbiBvZiB0aGUgZG9v
cmJlbGwgaW50ZXJydXB0IHdpbGwgdHJpZ2dlcgorICogdGhlIHVubWFwcGluZyBvZiB0aGUgYXNz
b2NpYXRlZCB2UEUuCisgKi8KK3N0YXRpYyB2b2lkIGdldF92bHBpX3N0YXRlX3ByZShzdHJ1Y3Qg
dmdpY19kaXN0ICpkaXN0KQoreworCXN0cnVjdCBpcnFfZGVzYyAqZGVzYzsKKwlpbnQgaTsKKwor
CWlmICgha3ZtX3ZnaWNfZ2xvYmFsX3N0YXRlLmhhc19naWN2NF8xKQorCQlyZXR1cm47CisKKwlm
b3IgKGkgPSAwOyBpIDwgZGlzdC0+aXRzX3ZtLm5yX3ZwZXM7IGkrKykgeworCQlkZXNjID0gaXJx
X3RvX2Rlc2MoZGlzdC0+aXRzX3ZtLnZwZXNbaV0tPmlycSk7CisJCWlycV9kb21haW5fZGVhY3Rp
dmF0ZV9pcnEoaXJxX2Rlc2NfZ2V0X2lycV9kYXRhKGRlc2MpKTsKKwl9Cit9CisKK3N0YXRpYyB2
b2lkIGdldF92bHBpX3N0YXRlX3Bvc3Qoc3RydWN0IHZnaWNfZGlzdCAqZGlzdCkKK3sKKwlzdHJ1
Y3QgaXJxX2Rlc2MgKmRlc2M7CisJaW50IGk7CisKKwlpZiAoIWt2bV92Z2ljX2dsb2JhbF9zdGF0
ZS5oYXNfZ2ljdjRfMSkKKwkJcmV0dXJuOworCisJZm9yIChpID0gMDsgaSA8IGRpc3QtPml0c192
bS5ucl92cGVzOyBpKyspIHsKKwkJZGVzYyA9IGlycV90b19kZXNjKGRpc3QtPml0c192bS52cGVz
W2ldLT5pcnEpOworCQlpcnFfZG9tYWluX2FjdGl2YXRlX2lycShpcnFfZGVzY19nZXRfaXJxX2Rh
dGEoZGVzYyksIGZhbHNlKTsKKwl9Cit9CisKIC8qKgogICogdmdpY192M19zYXZlX3BlbmRpbmdf
dGFibGVzIC0gU2F2ZSB0aGUgcGVuZGluZyB0YWJsZXMgaW50byBndWVzdCBSQU0KICAqIGt2bSBs
b2NrIGFuZCBhbGwgdmNwdSBsb2NrIG11c3QgYmUgaGVsZApAQCAtMzY1LDE0ICs0MDAsMTcgQEAg
aW50IHZnaWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxlcyhzdHJ1Y3Qga3ZtICprdm0pCiAJc3RydWN0
IHZnaWNfZGlzdCAqZGlzdCA9ICZrdm0tPmFyY2gudmdpYzsKIAlzdHJ1Y3QgdmdpY19pcnEgKmly
cTsKIAlncGFfdCBsYXN0X3B0ciA9IH4oZ3BhX3QpMDsKLQlpbnQgcmV0OworCWludCByZXQgPSAw
OwogCXU4IHZhbDsKIAorCWdldF92bHBpX3N0YXRlX3ByZShkaXN0KTsKKwogCWxpc3RfZm9yX2Vh
Y2hfZW50cnkoaXJxLCAmZGlzdC0+bHBpX2xpc3RfaGVhZCwgbHBpX2xpc3QpIHsKIAkJaW50IGJ5
dGVfb2Zmc2V0LCBiaXRfbnI7CiAJCXN0cnVjdCBrdm1fdmNwdSAqdmNwdTsKIAkJZ3BhX3QgcGVu
ZGJhc2UsIHB0cjsKIAkJYm9vbCBzdG9yZWQ7CisJCWJvb2wgaXNfcGVuZGluZyA9IGlycS0+cGVu
ZGluZ19sYXRjaDsKIAogCQl2Y3B1ID0gaXJxLT50YXJnZXRfdmNwdTsKIAkJaWYgKCF2Y3B1KQpA
QCAtMzg3LDI0ICs0MjUsMzYgQEAgaW50IHZnaWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxlcyhzdHJ1
Y3Qga3ZtICprdm0pCiAJCWlmIChwdHIgIT0gbGFzdF9wdHIpIHsKIAkJCXJldCA9IGt2bV9yZWFk
X2d1ZXN0X2xvY2soa3ZtLCBwdHIsICZ2YWwsIDEpOwogCQkJaWYgKHJldCkKLQkJCQlyZXR1cm4g
cmV0OworCQkJCWdvdG8gb3V0OwogCQkJbGFzdF9wdHIgPSBwdHI7CiAJCX0KIAogCQlzdG9yZWQg
PSB2YWwgJiAoMVUgPDwgYml0X25yKTsKLQkJaWYgKHN0b3JlZCA9PSBpcnEtPnBlbmRpbmdfbGF0
Y2gpCisKKwkJLyogYWxzbyBmbHVzaCBodyBwZW5kaW5nIHN0YXRlICovCisJCWlmIChpcnEtPmh3
KSB7CisJCQlXQVJOX1JBVEVMSU1JVChpcnFfZ2V0X2lycWNoaXBfc3RhdGUoaXJxLT5ob3N0X2ly
cSwKKwkJCQkJCUlSUUNISVBfU1RBVEVfUEVORElORywgJmlzX3BlbmRpbmcpLAorCQkJCSAgICAg
ICAiSVJRICVkIiwgaXJxLT5ob3N0X2lycSk7CisJCX0KKworCQlpZiAoc3RvcmVkID09IGlzX3Bl
bmRpbmcpCiAJCQljb250aW51ZTsKIAotCQlpZiAoaXJxLT5wZW5kaW5nX2xhdGNoKQorCQlpZiAo
aXNfcGVuZGluZykKIAkJCXZhbCB8PSAxIDw8IGJpdF9ucjsKIAkJZWxzZQogCQkJdmFsICY9IH4o
MSA8PCBiaXRfbnIpOwogCiAJCXJldCA9IGt2bV93cml0ZV9ndWVzdF9sb2NrKGt2bSwgcHRyLCAm
dmFsLCAxKTsKIAkJaWYgKHJldCkKLQkJCXJldHVybiByZXQ7CisJCQlnb3RvIG91dDsKIAl9Ci0J
cmV0dXJuIDA7CisKK291dDoKKwlnZXRfdmxwaV9zdGF0ZV9wb3N0KGRpc3QpOworCisJcmV0dXJu
IHJldDsKIH0KIAogLyoqCi0tIAoyLjIzLjAKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
