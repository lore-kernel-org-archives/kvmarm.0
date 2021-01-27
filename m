Return-Path: <SRS0=cUgw=G6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE653C433E6
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 12:14:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3757C20780
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 12:14:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3757C20780
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEE9B4B241;
	Wed, 27 Jan 2021 07:14:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KBLCUf7C8mvP; Wed, 27 Jan 2021 07:14:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B99B4B229;
	Wed, 27 Jan 2021 07:14:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 740094B22F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 07:14:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l7pPcgWUOgft for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jan 2021 07:14:17 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F35764B24C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 07:14:16 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DQjDF3NKpzjDLd;
 Wed, 27 Jan 2021 20:13:01 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.186.182) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 27 Jan 2021 20:14:04 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Will
 Deacon" <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/4] KVM: arm64: GICv4.1: Try to save hw pending state in
 save_pending_tables
Date: Wed, 27 Jan 2021 20:13:35 +0800
Message-ID: <20210127121337.1092-3-lushenming@huawei.com>
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

QWZ0ZXIgcGF1c2luZyBhbGwgdkNQVXMgYW5kIGRldmljZXMgY2FwYWJsZSBvZiBpbnRlcnJ1cHRp
bmcsIGluIG9yZGVyCnRvIHNhdmUgdGhlIGluZm9ybWF0aW9uIG9mIGFsbCBpbnRlcnJ1cHRzLCBi
ZXNpZGVzIGZsdXNoaW5nIHRoZSBwZW5kaW5nCnN0YXRlcyBpbiBrdm3igJlzIHZnaWMsIHdlIGFs
c28gdHJ5IHRvIGZsdXNoIHRoZSBzdGF0ZXMgb2YgVkxQSXMgaW4gdGhlCnZpcnR1YWwgcGVuZGlu
ZyB0YWJsZXMgaW50byBndWVzdCBSQU0sIGJ1dCB3ZSBuZWVkIHRvIGhhdmUgR0lDdjQuMSBhbmQK
c2FmZWx5IHVubWFwIHRoZSB2UEVzIGZpcnN0LgoKQXMgZm9yIHRoZSBzYXZpbmcgb2YgVlNHSXMs
IHdoaWNoIG5lZWRzIHRoZSB2UEVzIHRvIGJlIG1hcHBlZCBhbmQgbWlnaHQKY29uZmxpY3Qgd2l0
aCB0aGUgc2F2aW5nIG9mIFZMUElzLCBidXQgc2luY2Ugd2Ugd2lsbCBtYXAgdGhlIHZQRXMgYmFj
awphdCB0aGUgZW5kIG9mIHNhdmVfcGVuZGluZ190YWJsZXMgYW5kIGJvdGggc2F2aW5ncyByZXF1
aXJlIHRoZSBrdm0tPmxvY2sKdG8gYmUgaGVsZCAob25seSBoYXBwZW4gc2VyaWFsbHkpLCBpdCB3
aWxsIHdvcmsgZmluZS4KClNpZ25lZC1vZmYtYnk6IFNoZW5taW5nIEx1IDxsdXNoZW5taW5nQGh1
YXdlaS5jb20+Ci0tLQogYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMgfCA2MSArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDU1IGluc2VydGlv
bnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92
Z2ljLXYzLmMgYi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMuYwppbmRleCA1MjkxNWIzNDIz
NTEuLjA2YjExNjJiN2EwYSAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYz
LmMKKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMKQEAgLTEsNiArMSw4IEBACiAv
LyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5CiAKICNpbmNsdWRlIDxsaW51
eC9pcnFjaGlwL2FybS1naWMtdjMuaD4KKyNpbmNsdWRlIDxsaW51eC9pcnEuaD4KKyNpbmNsdWRl
IDxsaW51eC9pcnFkb21haW4uaD4KICNpbmNsdWRlIDxsaW51eC9rdm0uaD4KICNpbmNsdWRlIDxs
aW51eC9rdm1faG9zdC5oPgogI2luY2x1ZGUgPGt2bS9hcm1fdmdpYy5oPgpAQCAtMzU2LDYgKzM1
OCwzMiBAQCBpbnQgdmdpY192M19scGlfc3luY19wZW5kaW5nX3N0YXR1cyhzdHJ1Y3Qga3ZtICpr
dm0sIHN0cnVjdCB2Z2ljX2lycSAqaXJxKQogCXJldHVybiAwOwogfQogCisvKgorICogVGhlIGRl
YWN0aXZhdGlvbiBvZiB0aGUgZG9vcmJlbGwgaW50ZXJydXB0IHdpbGwgdHJpZ2dlciB0aGUKKyAq
IHVubWFwcGluZyBvZiB0aGUgYXNzb2NpYXRlZCB2UEUuCisgKi8KK3N0YXRpYyB2b2lkIHVubWFw
X2FsbF92cGVzKHN0cnVjdCB2Z2ljX2Rpc3QgKmRpc3QpCit7CisJc3RydWN0IGlycV9kZXNjICpk
ZXNjOworCWludCBpOworCisJZm9yIChpID0gMDsgaSA8IGRpc3QtPml0c192bS5ucl92cGVzOyBp
KyspIHsKKwkJZGVzYyA9IGlycV90b19kZXNjKGRpc3QtPml0c192bS52cGVzW2ldLT5pcnEpOwor
CQlpcnFfZG9tYWluX2RlYWN0aXZhdGVfaXJxKGlycV9kZXNjX2dldF9pcnFfZGF0YShkZXNjKSk7
CisJfQorfQorCitzdGF0aWMgdm9pZCBtYXBfYWxsX3ZwZXMoc3RydWN0IHZnaWNfZGlzdCAqZGlz
dCkKK3sKKwlzdHJ1Y3QgaXJxX2Rlc2MgKmRlc2M7CisJaW50IGk7CisKKwlmb3IgKGkgPSAwOyBp
IDwgZGlzdC0+aXRzX3ZtLm5yX3ZwZXM7IGkrKykgeworCQlkZXNjID0gaXJxX3RvX2Rlc2MoZGlz
dC0+aXRzX3ZtLnZwZXNbaV0tPmlycSk7CisJCWlycV9kb21haW5fYWN0aXZhdGVfaXJxKGlycV9k
ZXNjX2dldF9pcnFfZGF0YShkZXNjKSwgZmFsc2UpOworCX0KK30KKwogLyoqCiAgKiB2Z2ljX3Yz
X3NhdmVfcGVuZGluZ190YWJsZXMgLSBTYXZlIHRoZSBwZW5kaW5nIHRhYmxlcyBpbnRvIGd1ZXN0
IFJBTQogICoga3ZtIGxvY2sgYW5kIGFsbCB2Y3B1IGxvY2sgbXVzdCBiZSBoZWxkCkBAIC0zNjUs
MTQgKzM5MywyNiBAQCBpbnQgdmdpY192M19zYXZlX3BlbmRpbmdfdGFibGVzKHN0cnVjdCBrdm0g
Kmt2bSkKIAlzdHJ1Y3QgdmdpY19kaXN0ICpkaXN0ID0gJmt2bS0+YXJjaC52Z2ljOwogCXN0cnVj
dCB2Z2ljX2lycSAqaXJxOwogCWdwYV90IGxhc3RfcHRyID0gfihncGFfdCkwOwotCWludCByZXQ7
CisJYm9vbCB2bHBpX2F2YWlsID0gZmFsc2U7CisJaW50IHJldCA9IDA7CiAJdTggdmFsOwogCisJ
LyoKKwkgKiBBcyBhIHByZXBhcmF0aW9uIGZvciBnZXR0aW5nIGFueSBWTFBJIHN0YXRlcy4KKwkg
KiBUaGUgdmdpYyBpbml0aWFsaXplZCBjaGVjayBlbnN1cmVzIHRoYXQgdGhlIGFsbG9jYXRpb24g
YW5kCisJICogZW5hYmxpbmcgb2YgdGhlIGRvb3JiZWxscyBoYXZlIGFscmVhZHkgYmVlbiBkb25l
LgorCSAqLworCWlmIChrdm1fdmdpY19nbG9iYWxfc3RhdGUuaGFzX2dpY3Y0XzEgJiYgIVdBUk5f
T04oIXZnaWNfaW5pdGlhbGl6ZWQoa3ZtKSkpIHsKKwkJdW5tYXBfYWxsX3ZwZXMoZGlzdCk7CisJ
CXZscGlfYXZhaWwgPSB0cnVlOworCX0KKwogCWxpc3RfZm9yX2VhY2hfZW50cnkoaXJxLCAmZGlz
dC0+bHBpX2xpc3RfaGVhZCwgbHBpX2xpc3QpIHsKIAkJaW50IGJ5dGVfb2Zmc2V0LCBiaXRfbnI7
CiAJCXN0cnVjdCBrdm1fdmNwdSAqdmNwdTsKIAkJZ3BhX3QgcGVuZGJhc2UsIHB0cjsKIAkJYm9v
bCBzdG9yZWQ7CisJCWJvb2wgaXNfcGVuZGluZyA9IGlycS0+cGVuZGluZ19sYXRjaDsKIAogCQl2
Y3B1ID0gaXJxLT50YXJnZXRfdmNwdTsKIAkJaWYgKCF2Y3B1KQpAQCAtMzg3LDI0ICs0MjcsMzMg
QEAgaW50IHZnaWNfdjNfc2F2ZV9wZW5kaW5nX3RhYmxlcyhzdHJ1Y3Qga3ZtICprdm0pCiAJCWlm
IChwdHIgIT0gbGFzdF9wdHIpIHsKIAkJCXJldCA9IGt2bV9yZWFkX2d1ZXN0X2xvY2soa3ZtLCBw
dHIsICZ2YWwsIDEpOwogCQkJaWYgKHJldCkKLQkJCQlyZXR1cm4gcmV0OworCQkJCWdvdG8gb3V0
OwogCQkJbGFzdF9wdHIgPSBwdHI7CiAJCX0KIAogCQlzdG9yZWQgPSB2YWwgJiAoMVUgPDwgYml0
X25yKTsKLQkJaWYgKHN0b3JlZCA9PSBpcnEtPnBlbmRpbmdfbGF0Y2gpCisKKwkJaWYgKGlycS0+
aHcgJiYgdmxwaV9hdmFpbCkKKwkJCXZnaWNfdjRfZ2V0X3ZscGlfc3RhdGUoaXJxLCAmaXNfcGVu
ZGluZyk7CisKKwkJaWYgKHN0b3JlZCA9PSBpc19wZW5kaW5nKQogCQkJY29udGludWU7CiAKLQkJ
aWYgKGlycS0+cGVuZGluZ19sYXRjaCkKKwkJaWYgKGlzX3BlbmRpbmcpCiAJCQl2YWwgfD0gMSA8
PCBiaXRfbnI7CiAJCWVsc2UKIAkJCXZhbCAmPSB+KDEgPDwgYml0X25yKTsKIAogCQlyZXQgPSBr
dm1fd3JpdGVfZ3Vlc3RfbG9jayhrdm0sIHB0ciwgJnZhbCwgMSk7CiAJCWlmIChyZXQpCi0JCQly
ZXR1cm4gcmV0OworCQkJZ290byBvdXQ7CiAJfQotCXJldHVybiAwOworCitvdXQ6CisJaWYgKHZs
cGlfYXZhaWwpCisJCW1hcF9hbGxfdnBlcyhkaXN0KTsKKworCXJldHVybiByZXQ7CiB9CiAKIC8q
KgotLSAKMi4xOS4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
