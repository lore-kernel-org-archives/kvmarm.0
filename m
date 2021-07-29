Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1F22C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 10:44:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6120D60EC0
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 10:44:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 6120D60EC0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14A764A4A0;
	Thu, 29 Jul 2021 06:44:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1kfyMr4ekI+o; Thu, 29 Jul 2021 06:44:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECEF44A7FD;
	Thu, 29 Jul 2021 06:44:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE21249FB0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:44:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qUFZGeEb+Dh6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 06:44:12 -0400 (EDT)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1372149F5D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:44:12 -0400 (EDT)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.206])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gb6NZ3C6lz6FG8P;
 Thu, 29 Jul 2021 18:34:54 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 12:44:11 +0200
Received: from A2006125610.china.huawei.com (10.47.90.183) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 29 Jul 2021 11:44:04 +0100
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 4/4] KVM: arm64: Clear active_vmids on vCPU schedule out
Date: Thu, 29 Jul 2021 11:40:09 +0100
Message-ID: <20210729104009.382-5-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
References: <20210729104009.382-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.47.90.183]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, maz@kernel.org, linuxarm@huawei.com,
 catalin.marinas@arm.com, will@kernel.org
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

TGlrZSBBU0lEIGFsbG9jYXRvciwgd2UgY29weSB0aGUgYWN0aXZlX3ZtaWRzIGludG8gdGhlCnJl
c2VydmVkX3ZtaWRzIG9uIGEgcm9sbG92ZXIuIEJ1dCBpdCdzIHVubGlrZWx5IHRoYXQKZXZlcnkg
Q1BVIHdpbGwgaGF2ZSBhwqB2Q1BVIGFzIGN1cnJlbnQgdGFzayBhbmQgd2UgbWF5CmVuZCB1cCB1
bm5lY2Vzc2FyaWx5wqByZXNlcnZpbmcgdGhlIFZNSUQgc3BhY2UuCgpIZW5jZSwgY2xlYXIgYWN0
aXZlX3ZtaWRzIHdoZW4gc2NoZWR1bGluZyBvdXQgYSB2Q1BVLgoKU3VnZ2VzdGVkLWJ5OiBXaWxs
IERlYWNvbiA8d2lsbEBrZXJuZWwub3JnPgpTaWduZWQtb2ZmLWJ5OiBTaGFtZWVyIEtvbG90aHVt
IDxzaGFtZWVyYWxpLmtvbG90aHVtLnRob2RpQGh1YXdlaS5jb20+Ci0tLQogYXJjaC9hcm02NC9p
bmNsdWRlL2FzbS9rdm1faG9zdC5oIHwgMSArCiBhcmNoL2FybTY0L2t2bS9hcm0uYyAgICAgICAg
ICAgICAgfCAxICsKIGFyY2gvYXJtNjQva3ZtL3ZtaWQuYyAgICAgICAgICAgICB8IDYgKysrKysr
CiAzIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJt
NjQvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2hv
c3QuaAppbmRleCBiYjk5M2JjZTEzNjMuLmQ5MzE0MWNiOGQxNiAxMDA2NDQKLS0tIGEvYXJjaC9h
cm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCisrKyBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20v
a3ZtX2hvc3QuaApAQCAtNjg3LDYgKzY4Nyw3IEBAIGV4dGVybiB1bnNpZ25lZCBpbnQga3ZtX2Fy
bV92bWlkX2JpdHM7CiBpbnQga3ZtX2FybV92bWlkX2FsbG9jX2luaXQodm9pZCk7CiB2b2lkIGt2
bV9hcm1fdm1pZF9hbGxvY19mcmVlKHZvaWQpOwogdm9pZCBrdm1fYXJtX3ZtaWRfdXBkYXRlKHN0
cnVjdCBrdm1fdm1pZCAqa3ZtX3ZtaWQpOwordm9pZCBrdm1fYXJtX3ZtaWRfY2xlYXJfYWN0aXZl
KHZvaWQpOwogCiBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX2FybV9wdnRpbWVfdmNwdV9pbml0KHN0
cnVjdCBrdm1fdmNwdV9hcmNoICp2Y3B1X2FyY2gpCiB7CmRpZmYgLS1naXQgYS9hcmNoL2FybTY0
L2t2bS9hcm0uYyBiL2FyY2gvYXJtNjQva3ZtL2FybS5jCmluZGV4IDA3N2U1NWE1MTFhOS4uYjEz
NGExYjg5Yzg0IDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2bS9hcm0uYworKysgYi9hcmNoL2Fy
bTY0L2t2bS9hcm0uYwpAQCAtNDM1LDYgKzQzNSw3IEBAIHZvaWQga3ZtX2FyY2hfdmNwdV9wdXQo
c3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogCWt2bV90aW1lcl92Y3B1X3B1dCh2Y3B1KTsKIAlrdm1f
dmdpY19wdXQodmNwdSk7CiAJa3ZtX3ZjcHVfcG11X3Jlc3RvcmVfaG9zdCh2Y3B1KTsKKwlrdm1f
YXJtX3ZtaWRfY2xlYXJfYWN0aXZlKCk7CiAKIAl2Y3B1LT5jcHUgPSAtMTsKIH0KZGlmZiAtLWdp
dCBhL2FyY2gvYXJtNjQva3ZtL3ZtaWQuYyBiL2FyY2gvYXJtNjQva3ZtL3ZtaWQuYwppbmRleCA1
NTg0ZTg0YWVkOTUuLjVmZDUxZjU0NDVjMSAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vdm1p
ZC5jCisrKyBiL2FyY2gvYXJtNjQva3ZtL3ZtaWQuYwpAQCAtMTE2LDYgKzExNiwxMiBAQCBzdGF0
aWMgdTY0IG5ld192bWlkKHN0cnVjdCBrdm1fdm1pZCAqa3ZtX3ZtaWQpCiAJcmV0dXJuIGlkeDJ2
bWlkKHZtaWQpIHwgZ2VuZXJhdGlvbjsKIH0KIAorLyogQ2FsbCB3aXRoIHByZWVtcHRpb24gZGlz
YWJsZWQgKi8KK3ZvaWQga3ZtX2FybV92bWlkX2NsZWFyX2FjdGl2ZSh2b2lkKQoreworCWF0b21p
YzY0X3NldCh0aGlzX2NwdV9wdHIoJmFjdGl2ZV92bWlkcyksIDApOworfQorCiB2b2lkIGt2bV9h
cm1fdm1pZF91cGRhdGUoc3RydWN0IGt2bV92bWlkICprdm1fdm1pZCkKIHsKIAl1bnNpZ25lZCBs
b25nIGZsYWdzOwotLSAKMi4xNy4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
