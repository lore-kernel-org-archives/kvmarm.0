Return-Path: <SRS0=gWTa=IU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 898DBC433E2
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 06:02:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0D45F6196D
	for <kvmarm@archiver.kernel.org>; Mon, 22 Mar 2021 06:02:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D45F6196D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4A024B3B7;
	Mon, 22 Mar 2021 02:02:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yJ-5-LJZ07jz; Mon, 22 Mar 2021 02:02:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FD324B432;
	Mon, 22 Mar 2021 02:02:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 722EE4B429
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 02:02:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B+S9d2gbd0pn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Mar 2021 02:02:41 -0400 (EDT)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 552C64B3F9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Mar 2021 02:02:40 -0400 (EDT)
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F3kP41tbhzNq3t;
 Mon, 22 Mar 2021 14:00:08 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.135) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Mon, 22 Mar 2021 14:02:30 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Will
 Deacon" <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 4/6] KVM: arm64: GICv4.1: Try to save VLPI state in
 save_pending_tables
Date: Mon, 22 Mar 2021 14:01:56 +0800
Message-ID: <20210322060158.1584-5-lushenming@huawei.com>
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

QWZ0ZXIgcGF1c2luZyBhbGwgdkNQVXMgYW5kIGRldmljZXMgY2FwYWJsZSBvZiBpbnRlcnJ1cHRp
bmcsIGluIG9yZGVyCnRvIHNhdmUgdGhlIHN0YXRlcyBvZiBhbGwgaW50ZXJydXB0cywgYmVzaWRl
cyBmbHVzaGluZyB0aGUgc3RhdGVzIGluCmt2beKAmXMgdmdpYywgd2UgYWxzbyB0cnkgdG8gZmx1
c2ggdGhlIHN0YXRlcyBvZiBWTFBJcyBpbiB0aGUgdmlydHVhbApwZW5kaW5nIHRhYmxlcyBpbnRv
IGd1ZXN0IFJBTSwgYnV0IHdlIG5lZWQgdG8gaGF2ZSBHSUN2NC4xIGFuZCBzYWZlbHkKdW5tYXAg
dGhlIHZQRXMgZmlyc3QuCgpBcyBmb3IgdGhlIHNhdmluZyBvZiBWU0dJcywgd2hpY2ggbmVlZHMg
dGhlIHZQRXMgdG8gYmUgbWFwcGVkIGFuZCBtaWdodApjb25mbGljdCB3aXRoIHRoZSBzYXZpbmcg
b2YgVkxQSXMsIGJ1dCBzaW5jZSB3ZSB3aWxsIG1hcCB0aGUgdlBFcyBiYWNrCmF0IHRoZSBlbmQg
b2Ygc2F2ZV9wZW5kaW5nX3RhYmxlcyBhbmQgYm90aCBzYXZpbmdzIHJlcXVpcmUgdGhlIGt2bS0+
bG9jawp0byBiZSBoZWxkICh0aHVzIG9ubHkgaGFwcGVuIHNlcmlhbGx5KSwgaXQgd2lsbCB3b3Jr
IGZpbmUuCgpTaWduZWQtb2ZmLWJ5OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29t
PgotLS0KIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jIHwgNjYgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKy0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA2MCBpbnNlcnRpb25zKCspLCA2
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5j
IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMKaW5kZXggNmY1MzA5MjVhMjMxLi40MWVj
ZjIxOWMzMzMgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jCisrKyBi
L2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jCkBAIC0xLDYgKzEsOCBAQAogLy8gU1BEWC1M
aWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQogCiAjaW5jbHVkZSA8bGludXgvaXJxY2hp
cC9hcm0tZ2ljLXYzLmg+CisjaW5jbHVkZSA8bGludXgvaXJxLmg+CisjaW5jbHVkZSA8bGludXgv
aXJxZG9tYWluLmg+CiAjaW5jbHVkZSA8bGludXgva3ZtLmg+CiAjaW5jbHVkZSA8bGludXgva3Zt
X2hvc3QuaD4KICNpbmNsdWRlIDxrdm0vYXJtX3ZnaWMuaD4KQEAgLTM1Niw2ICszNTgsMzIgQEAg
aW50IHZnaWNfdjNfbHBpX3N5bmNfcGVuZGluZ19zdGF0dXMoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1
Y3QgdmdpY19pcnEgKmlycSkKIAlyZXR1cm4gMDsKIH0KIAorLyoKKyAqIFRoZSBkZWFjdGl2YXRp
b24gb2YgdGhlIGRvb3JiZWxsIGludGVycnVwdCB3aWxsIHRyaWdnZXIgdGhlCisgKiB1bm1hcHBp
bmcgb2YgdGhlIGFzc29jaWF0ZWQgdlBFLgorICovCitzdGF0aWMgdm9pZCB1bm1hcF9hbGxfdnBl
cyhzdHJ1Y3QgdmdpY19kaXN0ICpkaXN0KQoreworCXN0cnVjdCBpcnFfZGVzYyAqZGVzYzsKKwlp
bnQgaTsKKworCWZvciAoaSA9IDA7IGkgPCBkaXN0LT5pdHNfdm0ubnJfdnBlczsgaSsrKSB7CisJ
CWRlc2MgPSBpcnFfdG9fZGVzYyhkaXN0LT5pdHNfdm0udnBlc1tpXS0+aXJxKTsKKwkJaXJxX2Rv
bWFpbl9kZWFjdGl2YXRlX2lycShpcnFfZGVzY19nZXRfaXJxX2RhdGEoZGVzYykpOworCX0KK30K
Kworc3RhdGljIHZvaWQgbWFwX2FsbF92cGVzKHN0cnVjdCB2Z2ljX2Rpc3QgKmRpc3QpCit7CisJ
c3RydWN0IGlycV9kZXNjICpkZXNjOworCWludCBpOworCisJZm9yIChpID0gMDsgaSA8IGRpc3Qt
Pml0c192bS5ucl92cGVzOyBpKyspIHsKKwkJZGVzYyA9IGlycV90b19kZXNjKGRpc3QtPml0c192
bS52cGVzW2ldLT5pcnEpOworCQlpcnFfZG9tYWluX2FjdGl2YXRlX2lycShpcnFfZGVzY19nZXRf
aXJxX2RhdGEoZGVzYyksIGZhbHNlKTsKKwl9Cit9CisKIC8qKgogICogdmdpY192M19zYXZlX3Bl
bmRpbmdfdGFibGVzIC0gU2F2ZSB0aGUgcGVuZGluZyB0YWJsZXMgaW50byBndWVzdCBSQU0KICAq
IGt2bSBsb2NrIGFuZCBhbGwgdmNwdSBsb2NrIG11c3QgYmUgaGVsZApAQCAtMzY1LDEzICszOTMs
MjggQEAgaW50IHZnaWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxlcyhzdHJ1Y3Qga3ZtICprdm0pCiAJ
c3RydWN0IHZnaWNfZGlzdCAqZGlzdCA9ICZrdm0tPmFyY2gudmdpYzsKIAlzdHJ1Y3QgdmdpY19p
cnEgKmlycTsKIAlncGFfdCBsYXN0X3B0ciA9IH4oZ3BhX3QpMDsKLQlpbnQgcmV0OworCWJvb2wg
dmxwaV9hdmFpbCA9IGZhbHNlOworCWludCByZXQgPSAwOwogCXU4IHZhbDsKIAorCWlmICh1bmxp
a2VseSghdmdpY19pbml0aWFsaXplZChrdm0pKSkKKwkJcmV0dXJuIC1FTlhJTzsKKworCS8qCisJ
ICogQSBwcmVwYXJhdGlvbiBmb3IgZ2V0dGluZyBhbnkgVkxQSSBzdGF0ZXMuCisJICogVGhlIGFi
b3ZlIHZnaWMgaW5pdGlhbGl6ZWQgY2hlY2sgYWxzbyBlbnN1cmVzIHRoYXQgdGhlIGFsbG9jYXRp
b24KKwkgKiBhbmQgZW5hYmxpbmcgb2YgdGhlIGRvb3JiZWxscyBoYXZlIGFscmVhZHkgYmVlbiBk
b25lLgorCSAqLworCWlmIChrdm1fdmdpY19nbG9iYWxfc3RhdGUuaGFzX2dpY3Y0XzEpIHsKKwkJ
dW5tYXBfYWxsX3ZwZXMoZGlzdCk7CisJCXZscGlfYXZhaWwgPSB0cnVlOworCX0KKwogCWxpc3Rf
Zm9yX2VhY2hfZW50cnkoaXJxLCAmZGlzdC0+bHBpX2xpc3RfaGVhZCwgbHBpX2xpc3QpIHsKIAkJ
aW50IGJ5dGVfb2Zmc2V0LCBiaXRfbnI7CiAJCXN0cnVjdCBrdm1fdmNwdSAqdmNwdTsKIAkJZ3Bh
X3QgcGVuZGJhc2UsIHB0cjsKKwkJYm9vbCBpc19wZW5kaW5nOwogCQlib29sIHN0b3JlZDsKIAog
CQl2Y3B1ID0gaXJxLT50YXJnZXRfdmNwdTsKQEAgLTM4NywyNCArNDMwLDM1IEBAIGludCB2Z2lj
X3YzX3NhdmVfcGVuZGluZ190YWJsZXMoc3RydWN0IGt2bSAqa3ZtKQogCQlpZiAocHRyICE9IGxh
c3RfcHRyKSB7CiAJCQlyZXQgPSBrdm1fcmVhZF9ndWVzdF9sb2NrKGt2bSwgcHRyLCAmdmFsLCAx
KTsKIAkJCWlmIChyZXQpCi0JCQkJcmV0dXJuIHJldDsKKwkJCQlnb3RvIG91dDsKIAkJCWxhc3Rf
cHRyID0gcHRyOwogCQl9CiAKIAkJc3RvcmVkID0gdmFsICYgKDFVIDw8IGJpdF9ucik7Ci0JCWlm
IChzdG9yZWQgPT0gaXJxLT5wZW5kaW5nX2xhdGNoKQorCisJCWlzX3BlbmRpbmcgPSBpcnEtPnBl
bmRpbmdfbGF0Y2g7CisKKwkJaWYgKGlycS0+aHcgJiYgdmxwaV9hdmFpbCkKKwkJCXZnaWNfdjRf
Z2V0X3ZscGlfc3RhdGUoaXJxLCAmaXNfcGVuZGluZyk7CisKKwkJaWYgKHN0b3JlZCA9PSBpc19w
ZW5kaW5nKQogCQkJY29udGludWU7CiAKLQkJaWYgKGlycS0+cGVuZGluZ19sYXRjaCkKKwkJaWYg
KGlzX3BlbmRpbmcpCiAJCQl2YWwgfD0gMSA8PCBiaXRfbnI7CiAJCWVsc2UKIAkJCXZhbCAmPSB+
KDEgPDwgYml0X25yKTsKIAogCQlyZXQgPSBrdm1fd3JpdGVfZ3Vlc3RfbG9jayhrdm0sIHB0ciwg
JnZhbCwgMSk7CiAJCWlmIChyZXQpCi0JCQlyZXR1cm4gcmV0OworCQkJZ290byBvdXQ7CiAJfQot
CXJldHVybiAwOworCitvdXQ6CisJaWYgKHZscGlfYXZhaWwpCisJCW1hcF9hbGxfdnBlcyhkaXN0
KTsKKworCXJldHVybiByZXQ7CiB9CiAKIC8qKgotLSAKMi4xOS4xCgpfX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFy
bUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFp
bG1hbi9saXN0aW5mby9rdm1hcm0K
