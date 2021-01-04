Return-Path: <SRS0=G82f=GH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63044C433E9
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 08:17:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F038420798
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 08:17:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F038420798
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2D5E4B1D3;
	Mon,  4 Jan 2021 03:17:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EIPhCSSVutuP; Mon,  4 Jan 2021 03:17:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 982524B2E7;
	Mon,  4 Jan 2021 03:17:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 93F3E4B2F2
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 03:17:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NoZnA7BHFNSk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2021 03:17:07 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AADD54B20B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 03:17:05 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D8T3G3CvKzMF8l;
 Mon,  4 Jan 2021 16:15:54 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.196) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 4 Jan 2021 16:16:52 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Will
 Deacon" <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 2/4] KVM: arm64: GICv4.1: Try to save hw pending state
 in save_pending_tables
Date: Mon, 4 Jan 2021 16:16:11 +0800
Message-ID: <20210104081613.100-3-lushenming@huawei.com>
X-Mailer: git-send-email 2.27.0.windows.1
In-Reply-To: <20210104081613.100-1-lushenming@huawei.com>
References: <20210104081613.100-1-lushenming@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.184.196]
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

QWZ0ZXIgcGF1c2luZyBhbGwgdkNQVXMgYW5kIGRldmljZXMgY2FwYWJsZSBvZiBpbnRlcnJ1cHRp
bmcsIGluIG9yZGVyCnRvIHNhdmUgdGhlIGluZm9ybWF0aW9uIG9mIGFsbCBpbnRlcnJ1cHRzLCBi
ZXNpZGVzIGZsdXNoaW5nIHRoZSBwZW5kaW5nCnN0YXRlcyBpbiBrdm3igJlzIHZnaWMsIHdlIGFs
c28gdHJ5IHRvIGZsdXNoIHRoZSBzdGF0ZXMgb2YgVkxQSXMgaW4gdGhlCnZpcnR1YWwgcGVuZGlu
ZyB0YWJsZXMgaW50byBndWVzdCBSQU0sIGJ1dCB3ZSBuZWVkIHRvIGhhdmUgR0lDdjQuMSBhbmQK
c2FmZWx5IHVubWFwIHRoZSB2UEVzIGZpcnN0LgoKU2lnbmVkLW9mZi1ieTogU2hlbm1pbmcgTHUg
PGx1c2hlbm1pbmdAaHVhd2VpLmNvbT4KLS0tCiBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMu
YyB8IDU4ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgNTIgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtdjMuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jCmlu
ZGV4IDljZGYzOWE5NGE2My4uYTU4Yzk0MTI3Y2IwIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2
bS92Z2ljL3ZnaWMtdjMuYworKysgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYwpAQCAt
MSw2ICsxLDggQEAKIC8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkKIAog
I2luY2x1ZGUgPGxpbnV4L2lycWNoaXAvYXJtLWdpYy12My5oPgorI2luY2x1ZGUgPGxpbnV4L2ly
cS5oPgorI2luY2x1ZGUgPGxpbnV4L2lycWRvbWFpbi5oPgogI2luY2x1ZGUgPGxpbnV4L2t2bS5o
PgogI2luY2x1ZGUgPGxpbnV4L2t2bV9ob3N0Lmg+CiAjaW5jbHVkZSA8a3ZtL2FybV92Z2ljLmg+
CkBAIC0zNTYsNiArMzU4LDM4IEBAIGludCB2Z2ljX3YzX2xwaV9zeW5jX3BlbmRpbmdfc3RhdHVz
KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IHZnaWNfaXJxICppcnEpCiAJcmV0dXJuIDA7CiB9CiAK
Ky8qCisgKiBUaGUgZGVhY3RpdmF0aW9uIG9mIHRoZSBkb29yYmVsbCBpbnRlcnJ1cHQgd2lsbCB0
cmlnZ2VyIHRoZQorICogdW5tYXBwaW5nIG9mIHRoZSBhc3NvY2lhdGVkIHZQRS4KKyAqLworc3Rh
dGljIHZvaWQgdW5tYXBfYWxsX3ZwZXMoc3RydWN0IHZnaWNfZGlzdCAqZGlzdCkKK3sKKwlzdHJ1
Y3QgaXJxX2Rlc2MgKmRlc2M7CisJaW50IGk7CisKKwlpZiAoIWt2bV92Z2ljX2dsb2JhbF9zdGF0
ZS5oYXNfZ2ljdjRfMSkKKwkJcmV0dXJuOworCisJZm9yIChpID0gMDsgaSA8IGRpc3QtPml0c192
bS5ucl92cGVzOyBpKyspIHsKKwkJZGVzYyA9IGlycV90b19kZXNjKGRpc3QtPml0c192bS52cGVz
W2ldLT5pcnEpOworCQlpcnFfZG9tYWluX2RlYWN0aXZhdGVfaXJxKGlycV9kZXNjX2dldF9pcnFf
ZGF0YShkZXNjKSk7CisJfQorfQorCitzdGF0aWMgdm9pZCBtYXBfYWxsX3ZwZXMoc3RydWN0IHZn
aWNfZGlzdCAqZGlzdCkKK3sKKwlzdHJ1Y3QgaXJxX2Rlc2MgKmRlc2M7CisJaW50IGk7CisKKwlp
ZiAoIWt2bV92Z2ljX2dsb2JhbF9zdGF0ZS5oYXNfZ2ljdjRfMSkKKwkJcmV0dXJuOworCisJZm9y
IChpID0gMDsgaSA8IGRpc3QtPml0c192bS5ucl92cGVzOyBpKyspIHsKKwkJZGVzYyA9IGlycV90
b19kZXNjKGRpc3QtPml0c192bS52cGVzW2ldLT5pcnEpOworCQlpcnFfZG9tYWluX2FjdGl2YXRl
X2lycShpcnFfZGVzY19nZXRfaXJxX2RhdGEoZGVzYyksIGZhbHNlKTsKKwl9Cit9CisKIC8qKgog
ICogdmdpY192M19zYXZlX3BlbmRpbmdfdGFibGVzIC0gU2F2ZSB0aGUgcGVuZGluZyB0YWJsZXMg
aW50byBndWVzdCBSQU0KICAqIGt2bSBsb2NrIGFuZCBhbGwgdmNwdSBsb2NrIG11c3QgYmUgaGVs
ZApAQCAtMzY1LDE0ICszOTksMTggQEAgaW50IHZnaWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxlcyhz
dHJ1Y3Qga3ZtICprdm0pCiAJc3RydWN0IHZnaWNfZGlzdCAqZGlzdCA9ICZrdm0tPmFyY2gudmdp
YzsKIAlzdHJ1Y3QgdmdpY19pcnEgKmlycTsKIAlncGFfdCBsYXN0X3B0ciA9IH4oZ3BhX3QpMDsK
LQlpbnQgcmV0OworCWludCByZXQgPSAwOwogCXU4IHZhbDsKIAorCS8qIEFzIGEgcHJlcGFyYXRp
b24gZm9yIGdldHRpbmcgYW55IFZMUEkgc3RhdGVzLiAqLworCXVubWFwX2FsbF92cGVzKGRpc3Qp
OworCiAJbGlzdF9mb3JfZWFjaF9lbnRyeShpcnEsICZkaXN0LT5scGlfbGlzdF9oZWFkLCBscGlf
bGlzdCkgewogCQlpbnQgYnl0ZV9vZmZzZXQsIGJpdF9ucjsKIAkJc3RydWN0IGt2bV92Y3B1ICp2
Y3B1OwogCQlncGFfdCBwZW5kYmFzZSwgcHRyOwogCQlib29sIHN0b3JlZDsKKwkJYm9vbCBpc19w
ZW5kaW5nID0gaXJxLT5wZW5kaW5nX2xhdGNoOwogCiAJCXZjcHUgPSBpcnEtPnRhcmdldF92Y3B1
OwogCQlpZiAoIXZjcHUpCkBAIC0zODcsMjQgKzQyNSwzMiBAQCBpbnQgdmdpY192M19zYXZlX3Bl
bmRpbmdfdGFibGVzKHN0cnVjdCBrdm0gKmt2bSkKIAkJaWYgKHB0ciAhPSBsYXN0X3B0cikgewog
CQkJcmV0ID0ga3ZtX3JlYWRfZ3Vlc3RfbG9jayhrdm0sIHB0ciwgJnZhbCwgMSk7CiAJCQlpZiAo
cmV0KQotCQkJCXJldHVybiByZXQ7CisJCQkJZ290byBvdXQ7CiAJCQlsYXN0X3B0ciA9IHB0cjsK
IAkJfQogCiAJCXN0b3JlZCA9IHZhbCAmICgxVSA8PCBiaXRfbnIpOwotCQlpZiAoc3RvcmVkID09
IGlycS0+cGVuZGluZ19sYXRjaCkKKworCQlpZiAoaXJxLT5odykKKwkJCXZnaWNfdjRfZ2V0X3Zs
cGlfc3RhdGUoaXJxLCAmaXNfcGVuZGluZyk7CisKKwkJaWYgKHN0b3JlZCA9PSBpc19wZW5kaW5n
KQogCQkJY29udGludWU7CiAKLQkJaWYgKGlycS0+cGVuZGluZ19sYXRjaCkKKwkJaWYgKGlzX3Bl
bmRpbmcpCiAJCQl2YWwgfD0gMSA8PCBiaXRfbnI7CiAJCWVsc2UKIAkJCXZhbCAmPSB+KDEgPDwg
Yml0X25yKTsKIAogCQlyZXQgPSBrdm1fd3JpdGVfZ3Vlc3RfbG9jayhrdm0sIHB0ciwgJnZhbCwg
MSk7CiAJCWlmIChyZXQpCi0JCQlyZXR1cm4gcmV0OworCQkJZ290byBvdXQ7CiAJfQotCXJldHVy
biAwOworCitvdXQ6CisJbWFwX2FsbF92cGVzKGRpc3QpOworCisJcmV0dXJuIHJldDsKIH0KIAog
LyoqCi0tIAoyLjE5LjEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
