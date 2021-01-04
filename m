Return-Path: <SRS0=G82f=GH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60FDEC433E0
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 08:17:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E23D720758
	for <kvmarm@archiver.kernel.org>; Mon,  4 Jan 2021 08:17:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E23D720758
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 900EC4B2F4;
	Mon,  4 Jan 2021 03:17:09 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RYRGnfVByubU; Mon,  4 Jan 2021 03:17:08 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 780BE4B2E7;
	Mon,  4 Jan 2021 03:17:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF7ED4B202
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 03:17:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 44QDDiPBMct9 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Jan 2021 03:17:06 -0500 (EST)
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A9D534B192
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Jan 2021 03:17:05 -0500 (EST)
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4D8T3G2xDrzMF8d;
 Mon,  4 Jan 2021 16:15:54 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.184.196) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Mon, 4 Jan 2021 16:16:55 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Will
 Deacon" <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 4/4] KVM: arm64: GICv4.1: Give a chance to save VLPI's
 pending state
Date: Mon, 4 Jan 2021 16:16:13 +0800
Message-ID: <20210104081613.100-5-lushenming@huawei.com>
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

QmVmb3JlIEdJQ3Y0LjEsIHdlIGRvIG5vdCBoYXZlIGRpcmVjdCBhY2Nlc3MgdG8gdGhlIFZMUEkn
cyBwZW5kaW5nCnN0YXRlLiBTbyB3ZSBzaW1wbHkgbGV0IGl0IGZhaWwgZWFybHkgd2hlbiBlbmNv
dW50ZXJpbmcgYW55IFZMUEkuCgpCdXQgbm93IHdlIGRvbid0IGhhdmUgdG8gcmV0dXJuIC1FQUND
RVMgZGlyZWN0bHkgaWYgb24gR0lDdjQuMS4gU28KbGV04oCZcyBjaGFuZ2UgdGhlIGhhcmQgY29k
ZSBhbmQgZ2l2ZSBhIGNoYW5jZSB0byBzYXZlIHRoZSBWTFBJJ3MgcGVuZGluZwpzdGF0ZSAoYW5k
IHByZXNlcnZlIHRoZSBVQVBJKS4KClNpZ25lZC1vZmYtYnk6IFNoZW5taW5nIEx1IDxsdXNoZW5t
aW5nQGh1YXdlaS5jb20+Ci0tLQogRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9kZXZpY2VzL2FybS12
Z2ljLWl0cy5yc3QgfCAyICstCiBhcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtaXRzLmMgICAgICAg
ICAgICAgICAgICB8IDYgKysrLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwg
NCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2Rldmlj
ZXMvYXJtLXZnaWMtaXRzLnJzdCBiL0RvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNlcy9hcm0t
dmdpYy1pdHMucnN0CmluZGV4IDZjMzA0ZmQyYjFiNC4uZDI1N2VkZGJhZTI5IDEwMDY0NAotLS0g
YS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZnaWMtaXRzLnJzdAorKysgYi9E
b2N1bWVudGF0aW9uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZnaWMtaXRzLnJzdApAQCAtODAsNyAr
ODAsNyBAQCBLVk1fREVWX0FSTV9WR0lDX0dSUF9DVFJMCiAgICAgLUVGQVVMVCAgSW52YWxpZCBn
dWVzdCByYW0gYWNjZXNzCiAgICAgLUVCVVNZICAgT25lIG9yIG1vcmUgVkNQVVMgYXJlIHJ1bm5p
bmcKICAgICAtRUFDQ0VTICBUaGUgdmlydHVhbCBJVFMgaXMgYmFja2VkIGJ5IGEgcGh5c2ljYWwg
R0lDdjQgSVRTLCBhbmQgdGhlCi0JICAgICBzdGF0ZSBpcyBub3QgYXZhaWxhYmxlCisJICAgICBz
dGF0ZSBpcyBub3QgYXZhaWxhYmxlIHdpdGhvdXQgR0lDdjQuMQogICAgID09PT09PT0gID09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KIAog
S1ZNX0RFVl9BUk1fVkdJQ19HUlBfSVRTX1JFR1MKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3Zt
L3ZnaWMvdmdpYy1pdHMuYyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pdHMuYwppbmRleCA0
MGNiYWNhODEzMzMuLmVjNzU0M2E5NjE3YyAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLWl0cy5jCisrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pdHMuYwpAQCAtMjIx
OCwxMCArMjIxOCwxMCBAQCBzdGF0aWMgaW50IHZnaWNfaXRzX3NhdmVfaXR0KHN0cnVjdCB2Z2lj
X2l0cyAqaXRzLCBzdHJ1Y3QgaXRzX2RldmljZSAqZGV2aWNlKQogCQkvKgogCQkgKiBJZiBhbiBM
UEkgY2FycmllcyB0aGUgSFcgYml0LCB0aGlzIG1lYW5zIHRoYXQgdGhpcwogCQkgKiBpbnRlcnJ1
cHQgaXMgY29udHJvbGxlZCBieSBHSUN2NCwgYW5kIHdlIGRvIG5vdAotCQkgKiBoYXZlIGRpcmVj
dCBhY2Nlc3MgdG8gdGhhdCBzdGF0ZS4gTGV0J3Mgc2ltcGx5IGZhaWwKLQkJICogdGhlIHNhdmUg
b3BlcmF0aW9uLi4uCisJCSAqIGhhdmUgZGlyZWN0IGFjY2VzcyB0byB0aGF0IHN0YXRlIHdpdGhv
dXQgR0lDdjQuMS4KKwkJICogTGV0J3Mgc2ltcGx5IGZhaWwgdGhlIHNhdmUgb3BlcmF0aW9uLi4u
CiAJCSAqLwotCQlpZiAoaXRlLT5pcnEtPmh3KQorCQlpZiAoaXRlLT5pcnEtPmh3ICYmICFrdm1f
dmdpY19nbG9iYWxfc3RhdGUuaGFzX2dpY3Y0XzEpCiAJCQlyZXR1cm4gLUVBQ0NFUzsKIAogCQly
ZXQgPSB2Z2ljX2l0c19zYXZlX2l0ZShpdHMsIGRldmljZSwgaXRlLCBncGEsIGl0ZV9lc3opOwot
LSAKMi4xOS4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
