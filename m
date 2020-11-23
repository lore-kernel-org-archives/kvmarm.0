Return-Path: <SRS0=PaY3=E5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF97C2D0E4
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 08:35:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E226E2078E
	for <kvmarm@archiver.kernel.org>; Mon, 23 Nov 2020 08:35:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E226E2078E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7705A4B964;
	Mon, 23 Nov 2020 03:35:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hE85HNxG+3HN; Mon, 23 Nov 2020 03:35:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BBAF4BB3E;
	Mon, 23 Nov 2020 03:35:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF1624BA50
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 01:55:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ADax6boiuUlS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Nov 2020 01:54:59 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADCE94BA30
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Nov 2020 01:54:59 -0500 (EST)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CfdDt1V1Kzhg2q;
 Mon, 23 Nov 2020 14:54:38 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.187.74) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Mon, 23 Nov 2020 14:54:49 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, "Julien
 Thierry" <julien.thierry.kdev@gmail.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Eric Auger <eric.auger@redhat.com>,
 <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Christoffer Dall
 <christoffer.dall@arm.com>
Subject: [RFC PATCH v1 4/4] KVM: arm64: GICv4.1: Give a chance to save VLPI's
 pending state
Date: Mon, 23 Nov 2020 14:54:10 +0800
Message-ID: <20201123065410.1915-5-lushenming@huawei.com>
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

QmVmb3JlIEdJQ3Y0LjEsIHdlIGRvIG5vdCBoYXZlIGRpcmVjdCBhY2Nlc3MgdG8gdGhlIFZMUEkn
cyBwZW5kaW5nCnN0YXRlLiBTbyB3ZSBzaW1wbHkgbGV0IGl0IGZhaWwgZWFybHkgd2hlbiBlbmNv
dW50ZXJpbmcgYW55IFZMUEkuCgpCdXQgbm93IHdlIGRvbid0IGhhdmUgdG8gcmV0dXJuIC1FQUND
RVMgZGlyZWN0bHkgaWYgb24gR0lDdjQuMS4gU28KbGV04oCZcyBjaGFuZ2UgdGhlIGhhcmQgY29k
ZSBhbmQgZ2l2ZSBhIGNoYW5jZSB0byBzYXZlIHRoZSBWTFBJJ3MgcGVuZGluZwpzdGF0ZSAoYW5k
IHByZXNlcnZlIHRoZSBpbnRlcmZhY2VzKS4KClNpZ25lZC1vZmYtYnk6IFNoZW5taW5nIEx1IDxs
dXNoZW5taW5nQGh1YXdlaS5jb20+Ci0tLQogRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9kZXZpY2Vz
L2FybS12Z2ljLWl0cy5yc3QgfCAyICstCiBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXRzLmMg
ICAgICAgICAgICAgICAgICB8IDYgKysrLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9u
cygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3Zt
L2RldmljZXMvYXJtLXZnaWMtaXRzLnJzdCBiL0RvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNl
cy9hcm0tdmdpYy1pdHMucnN0CmluZGV4IDZjMzA0ZmQyYjFiNC4uZDI1N2VkZGJhZTI5IDEwMDY0
NAotLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZnaWMtaXRzLnJzdAor
KysgYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZnaWMtaXRzLnJzdApAQCAt
ODAsNyArODAsNyBAQCBLVk1fREVWX0FSTV9WR0lDX0dSUF9DVFJMCiAgICAgLUVGQVVMVCAgSW52
YWxpZCBndWVzdCByYW0gYWNjZXNzCiAgICAgLUVCVVNZICAgT25lIG9yIG1vcmUgVkNQVVMgYXJl
IHJ1bm5pbmcKICAgICAtRUFDQ0VTICBUaGUgdmlydHVhbCBJVFMgaXMgYmFja2VkIGJ5IGEgcGh5
c2ljYWwgR0lDdjQgSVRTLCBhbmQgdGhlCi0JICAgICBzdGF0ZSBpcyBub3QgYXZhaWxhYmxlCisJ
ICAgICBzdGF0ZSBpcyBub3QgYXZhaWxhYmxlIHdpdGhvdXQgR0lDdjQuMQogICAgID09PT09PT0g
ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0KIAogS1ZNX0RFVl9BUk1fVkdJQ19HUlBfSVRTX1JFR1MKZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQva3ZtL3ZnaWMvdmdpYy1pdHMuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pdHMuYwpp
bmRleCA0MGNiYWNhODEzMzMuLmVjNzU0M2E5NjE3YyAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9r
dm0vdmdpYy92Z2ljLWl0cy5jCisrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pdHMuYwpA
QCAtMjIxOCwxMCArMjIxOCwxMCBAQCBzdGF0aWMgaW50IHZnaWNfaXRzX3NhdmVfaXR0KHN0cnVj
dCB2Z2ljX2l0cyAqaXRzLCBzdHJ1Y3QgaXRzX2RldmljZSAqZGV2aWNlKQogCQkvKgogCQkgKiBJ
ZiBhbiBMUEkgY2FycmllcyB0aGUgSFcgYml0LCB0aGlzIG1lYW5zIHRoYXQgdGhpcwogCQkgKiBp
bnRlcnJ1cHQgaXMgY29udHJvbGxlZCBieSBHSUN2NCwgYW5kIHdlIGRvIG5vdAotCQkgKiBoYXZl
IGRpcmVjdCBhY2Nlc3MgdG8gdGhhdCBzdGF0ZS4gTGV0J3Mgc2ltcGx5IGZhaWwKLQkJICogdGhl
IHNhdmUgb3BlcmF0aW9uLi4uCisJCSAqIGhhdmUgZGlyZWN0IGFjY2VzcyB0byB0aGF0IHN0YXRl
IHdpdGhvdXQgR0lDdjQuMS4KKwkJICogTGV0J3Mgc2ltcGx5IGZhaWwgdGhlIHNhdmUgb3BlcmF0
aW9uLi4uCiAJCSAqLwotCQlpZiAoaXRlLT5pcnEtPmh3KQorCQlpZiAoaXRlLT5pcnEtPmh3ICYm
ICFrdm1fdmdpY19nbG9iYWxfc3RhdGUuaGFzX2dpY3Y0XzEpCiAJCQlyZXR1cm4gLUVBQ0NFUzsK
IAogCQlyZXQgPSB2Z2ljX2l0c19zYXZlX2l0ZShpdHMsIGRldmljZSwgaXRlLCBncGEsIGl0ZV9l
c3opOwotLSAKMi4yMy4wCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
