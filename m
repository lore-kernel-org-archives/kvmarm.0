Return-Path: <SRS0=cUgw=G6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8F0C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 12:14:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DAC4820773
	for <kvmarm@archiver.kernel.org>; Wed, 27 Jan 2021 12:14:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAC4820773
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6170C4B0FA;
	Wed, 27 Jan 2021 07:14:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AWvzJWrdIGyG; Wed, 27 Jan 2021 07:14:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C6D84B248;
	Wed, 27 Jan 2021 07:14:30 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3416D4B241
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 07:14:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CYPEQyJjiCjd for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 Jan 2021 07:14:28 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 035194B238
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 Jan 2021 07:14:27 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DQjDL5nQDz7bnS;
 Wed, 27 Jan 2021 20:13:06 +0800 (CST)
Received: from DESKTOP-7FEPK9S.china.huawei.com (10.174.186.182) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 27 Jan 2021 20:14:09 +0800
From: Shenming Lu <lushenming@huawei.com>
To: Marc Zyngier <maz@kernel.org>, Eric Auger <eric.auger@redhat.com>, "Will
 Deacon" <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 4/4] KVM: arm64: GICv4.1: Give a chance to save VLPI's
 pending state
Date: Wed, 27 Jan 2021 20:13:37 +0800
Message-ID: <20210127121337.1092-5-lushenming@huawei.com>
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

QmVmb3JlIEdJQ3Y0LjEsIHdlIGRvbid0IGhhdmUgZGlyZWN0IGFjY2VzcyB0byB0aGUgVkxQSSdz
IHBlbmRpbmcKc3RhdGUuIFNvIHdlIHNpbXBseSBsZXQgaXQgZmFpbCBlYXJseSB3aGVuIGVuY291
bnRlcmluZyBhbnkgVkxQSS4KCkJ1dCBub3cgd2UgZG9uJ3QgaGF2ZSB0byByZXR1cm4gLUVBQ0NF
UyBkaXJlY3RseSBpZiBvbiBHSUN2NC4xLiBTbwpsZXTigJlzIGNoYW5nZSB0aGUgaGFyZCBjb2Rl
IGFuZCBnaXZlIGEgY2hhbmNlIHRvIHNhdmUgdGhlIFZMUEkncyBwZW5kaW5nCnN0YXRlIChhbmQg
cHJlc2VydmUgdGhlIFVBUEkpLgoKU2lnbmVkLW9mZi1ieTogU2hlbm1pbmcgTHUgPGx1c2hlbm1p
bmdAaHVhd2VpLmNvbT4KLS0tCiBEb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZn
aWMtaXRzLnJzdCB8IDIgKy0KIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1pdHMuYyAgICAgICAg
ICAgICAgICAgIHwgNiArKystLS0KIDIgZmlsZXMgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA0
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNl
cy9hcm0tdmdpYy1pdHMucnN0IGIvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9kZXZpY2VzL2FybS12
Z2ljLWl0cy5yc3QKaW5kZXggNmMzMDRmZDJiMWI0Li5kMjU3ZWRkYmFlMjkgMTAwNjQ0Ci0tLSBh
L0RvY3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNlcy9hcm0tdmdpYy1pdHMucnN0CisrKyBiL0Rv
Y3VtZW50YXRpb24vdmlydC9rdm0vZGV2aWNlcy9hcm0tdmdpYy1pdHMucnN0CkBAIC04MCw3ICs4
MCw3IEBAIEtWTV9ERVZfQVJNX1ZHSUNfR1JQX0NUUkwKICAgICAtRUZBVUxUICBJbnZhbGlkIGd1
ZXN0IHJhbSBhY2Nlc3MKICAgICAtRUJVU1kgICBPbmUgb3IgbW9yZSBWQ1BVUyBhcmUgcnVubmlu
ZwogICAgIC1FQUNDRVMgIFRoZSB2aXJ0dWFsIElUUyBpcyBiYWNrZWQgYnkgYSBwaHlzaWNhbCBH
SUN2NCBJVFMsIGFuZCB0aGUKLQkgICAgIHN0YXRlIGlzIG5vdCBhdmFpbGFibGUKKwkgICAgIHN0
YXRlIGlzIG5vdCBhdmFpbGFibGUgd2l0aG91dCBHSUN2NC4xCiAgICAgPT09PT09PSAgPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQogCiBL
Vk1fREVWX0FSTV9WR0lDX0dSUF9JVFNfUkVHUwpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0v
dmdpYy92Z2ljLWl0cy5jIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWl0cy5jCmluZGV4IDQw
Y2JhY2E4MTMzMy4uZWM3NTQzYTk2MTdjIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2bS92Z2lj
L3ZnaWMtaXRzLmMKKysrIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLWl0cy5jCkBAIC0yMjE4
LDEwICsyMjE4LDEwIEBAIHN0YXRpYyBpbnQgdmdpY19pdHNfc2F2ZV9pdHQoc3RydWN0IHZnaWNf
aXRzICppdHMsIHN0cnVjdCBpdHNfZGV2aWNlICpkZXZpY2UpCiAJCS8qCiAJCSAqIElmIGFuIExQ
SSBjYXJyaWVzIHRoZSBIVyBiaXQsIHRoaXMgbWVhbnMgdGhhdCB0aGlzCiAJCSAqIGludGVycnVw
dCBpcyBjb250cm9sbGVkIGJ5IEdJQ3Y0LCBhbmQgd2UgZG8gbm90Ci0JCSAqIGhhdmUgZGlyZWN0
IGFjY2VzcyB0byB0aGF0IHN0YXRlLiBMZXQncyBzaW1wbHkgZmFpbAotCQkgKiB0aGUgc2F2ZSBv
cGVyYXRpb24uLi4KKwkJICogaGF2ZSBkaXJlY3QgYWNjZXNzIHRvIHRoYXQgc3RhdGUgd2l0aG91
dCBHSUN2NC4xLgorCQkgKiBMZXQncyBzaW1wbHkgZmFpbCB0aGUgc2F2ZSBvcGVyYXRpb24uLi4K
IAkJICovCi0JCWlmIChpdGUtPmlycS0+aHcpCisJCWlmIChpdGUtPmlycS0+aHcgJiYgIWt2bV92
Z2ljX2dsb2JhbF9zdGF0ZS5oYXNfZ2ljdjRfMSkKIAkJCXJldHVybiAtRUFDQ0VTOwogCiAJCXJl
dCA9IHZnaWNfaXRzX3NhdmVfaXRlKGl0cywgZGV2aWNlLCBpdGUsIGdwYSwgaXRlX2Vzeik7Ci0t
IAoyLjE5LjEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
