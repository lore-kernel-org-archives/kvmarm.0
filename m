Return-Path: <SRS0=7JFX=ZK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB2A0C432C0
	for <kvmarm@archiver.kernel.org>; Mon, 18 Nov 2019 08:59:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03B3820727
	for <kvmarm@archiver.kernel.org>; Mon, 18 Nov 2019 08:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03B3820727
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 79FEC4A800;
	Mon, 18 Nov 2019 03:59:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q3Zwi-ykO6rE; Mon, 18 Nov 2019 03:59:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 12C354AE8D;
	Mon, 18 Nov 2019 03:59:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F2DA64AC83
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Nov 2019 21:27:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h95otOtio3x0 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 17 Nov 2019 21:27:35 -0500 (EST)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF7B34A65C
 for <kvmarm@lists.cs.columbia.edu>; Sun, 17 Nov 2019 21:27:34 -0500 (EST)
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id D71B4E117DC0D4651E24;
 Mon, 18 Nov 2019 10:27:30 +0800 (CST)
Received: from HGHY4C002233111.china.huawei.com (10.133.205.93) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Mon, 18 Nov 2019 10:27:23 +0800
From: <kuhn.chenqun@huawei.com>
To: <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>, <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH] arm: Add missing test name prefix for pl031
 and spinlock
Date: Mon, 18 Nov 2019 10:27:20 +0800
Message-ID: <20191118022720.17488-1-kuhn.chenqun@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.133.205.93]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Mon, 18 Nov 2019 03:59:55 -0500
Cc: kuhn.chenqun@huawei.com, pannengyuan@huawei.com,
 zhang.zhanghailiang@huawei.com
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

RnJvbTogQ2hlbiBRdW4gPGt1aG4uY2hlbnF1bkBodWF3ZWkuY29tPgoKcGwwMzEgYW5kIHNwaW5s
b2NrIHRlc3RjYXNlIHdpdGhvdXQgcHJlZml4LCB3aGVuIHJ1bm5pbmcKdGhlIHVuaXQgdGVzdHMg
aW4gVEFQIG1vZGUgKC4vcnVuX3Rlc3RzLnNoIC10KSwgaXQgaXMKZGlmZmljdWx0IHRvIHRoZSB0
ZXN0IHJlc3VsdHMuCgpUaGUgdGVzdCByZXN1bHRz77yaCm9rIDEzIC0gUGVyaXBoL1BDZWxsIElE
cyBtYXRjaApvayAxNCAtIFIvTyBmaWVsZHMgYXJlIFIvTwpvayAxNSAtIFJUQyB0aWNrcyBhdCAx
SFoKb2sgMTYgLSBSVEMgSVJRIG5vdCBwZW5kaW5nIHlldAouLi4Kb2sgMjQgLSAgIFJUQyBJUlEg
bm90IHBlbmRpbmcgYW55bW9yZQpvayAyNSAtIENQVTE6IERvbmUgLSBFcnJvcnM6IDAKb2sgMjYg
LSBDUFUwOiBEb25lIC0gRXJyb3JzOiAwCgpJdCBzaG91bGQgYmUgbGlrZSB0aGlz77yaCm9rIDEz
IC0gcGwwMzE6IFBlcmlwaC9QQ2VsbCBJRHMgbWF0Y2gKb2sgMTQgLSBwbDAzMTogUi9PIGZpZWxk
cyBhcmUgUi9PCm9rIDE1IC0gcGwwMzE6IFJUQyB0aWNrcyBhdCAxSFoKb2sgMTYgLSBwbDAzMTog
UlRDIElSUSBub3QgcGVuZGluZyB5ZXQKLi4uCm9rIDI0IC0gcGwwMzE6ICAgUlRDIElSUSBub3Qg
cGVuZGluZyBhbnltb3JlCm9rIDI1IC0gc3BpbmxvY2s6IENQVTA6IERvbmUgLSBFcnJvcnM6IDAK
b2sgMjYgLSBzcGlubG9jazogQ1BVMTogRG9uZSAtIEVycm9yczogMAoKU2lnbmVkLW9mZi1ieTog
Q2hlbiBRdW4gPGt1aG4uY2hlbnF1bkBodWF3ZWkuY29tPgotLS0KIGFybS9wbDAzMS5jICAgICAg
ICAgfCAxICsKIGFybS9zcGlubG9jay10ZXN0LmMgfCAxICsKIDIgZmlsZXMgY2hhbmdlZCwgMiBp
bnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvYXJtL3BsMDMxLmMgYi9hcm0vcGwwMzEuYwppbmRl
eCA1NjcyZjM2Li5kMGM5YzEwIDEwMDY0NAotLS0gYS9hcm0vcGwwMzEuYworKysgYi9hcm0vcGww
MzEuYwpAQCAtMjUyLDYgKzI1Miw3IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikK
IAkJcmV0dXJuIDA7CiAJfQogCisJcmVwb3J0X3ByZWZpeF9wdXNoKCJwbDAzMSIpOwogCXJlcG9y
dCgiUGVyaXBoL1BDZWxsIElEcyBtYXRjaCIsICFjaGVja19pZCgpKTsKIAlyZXBvcnQoIlIvTyBm
aWVsZHMgYXJlIFIvTyIsICFjaGVja19ybygpKTsKIAlyZXBvcnQoIlJUQyB0aWNrcyBhdCAxSFoi
LCAhY2hlY2tfcnRjX2ZyZXEoKSk7CmRpZmYgLS1naXQgYS9hcm0vc3BpbmxvY2stdGVzdC5jIGIv
YXJtL3NwaW5sb2NrLXRlc3QuYwppbmRleCBkNTU0NzFiLi5mZjE2ZmIwIDEwMDY0NAotLS0gYS9h
cm0vc3BpbmxvY2stdGVzdC5jCisrKyBiL2FybS9zcGlubG9jay10ZXN0LmMKQEAgLTcyLDYgKzcy
LDcgQEAgc3RhdGljIHZvaWQgdGVzdF9zcGlubG9jayh2b2lkICpkYXRhIF9fdW51c2VkKQogCiBp
bnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCiB7CisJcmVwb3J0X3ByZWZpeF9wdXNoKCJz
cGlubG9jayIpOwogCWlmIChhcmdjID4gMSAmJiBzdHJjbXAoYXJndlsxXSwgImJhZCIpICE9IDAp
IHsKIAkJbG9ja19vcHMubG9jayA9IGdjY19idWlsdGluX2xvY2s7CiAJCWxvY2tfb3BzLnVubG9j
ayA9IGdjY19idWlsdGluX3VubG9jazsKLS0gCjIuMTQuMS53aW5kb3dzLjEKCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
