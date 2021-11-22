Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BC2EC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 22 Nov 2021 12:19:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22E374B164;
	Mon, 22 Nov 2021 07:19:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vMmawYDEFXDe; Mon, 22 Nov 2021 07:19:49 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B65A54B0DD;
	Mon, 22 Nov 2021 07:19:49 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A1F94B15C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 07:19:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FKkfNeDk-yul for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Nov 2021 07:19:47 -0500 (EST)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
 [185.176.79.56])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 50DFA4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Nov 2021 07:19:47 -0500 (EST)
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.226])
 by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HyRBx0H9Pz6H8CN;
 Mon, 22 Nov 2021 20:18:49 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 22 Nov 2021 13:19:45 +0100
Received: from A2006125610.china.huawei.com (10.202.227.178) by
 lhreml710-chm.china.huawei.com (10.201.108.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 22 Nov 2021 12:19:39 +0000
From: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 4/4] KVM: arm64: Make active_vmids invalid on vCPU schedule
 out
Date: Mon, 22 Nov 2021 12:18:44 +0000
Message-ID: <20211122121844.867-5-shameerali.kolothum.thodi@huawei.com>
X-Mailer: git-send-email 2.12.0.windows.1
In-Reply-To: <20211122121844.867-1-shameerali.kolothum.thodi@huawei.com>
References: <20211122121844.867-1-shameerali.kolothum.thodi@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.202.227.178]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Cc: jean-philippe@linaro.org, maz@kernel.org, linuxarm@huawei.com,
 jonathan.cameron@huawei.com, catalin.marinas@arm.com, will@kernel.org
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
bm5lY2Vzc2FyaWx5wqByZXNlcnZpbmcgdGhlIFZNSUQgc3BhY2UuCgpIZW5jZSwgc2V0IGFjdGl2
ZV92bWlkcyB0byBhbiBpbnZhbGlkIG9uZSB3aGVuIHNjaGVkdWxpbmcKb3V0IGEgdkNQVS4KClNp
Z25lZC1vZmYtYnk6IFNoYW1lZXIgS29sb3RodW0gPHNoYW1lZXJhbGkua29sb3RodW0udGhvZGlA
aHVhd2VpLmNvbT4KLS0tCiBhcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmggfCAgMSAr
CiBhcmNoL2FybTY0L2t2bS9hcm0uYyAgICAgICAgICAgICAgfCAgMSArCiBhcmNoL2FybTY0L2t2
bS92bWlkLmMgICAgICAgICAgICAgfCAyNSArKysrKysrKysrKysrKysrKysrKysrLS0tCiAzIGZp
bGVzIGNoYW5nZWQsIDI0IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1faG9zdC5oIGIvYXJjaC9hcm02NC9pbmNsdWRl
L2FzbS9rdm1faG9zdC5oCmluZGV4IDc1MmQ0NDA4ZTNkMC4uMjJmOTUyZWZmZDAzIDEwMDY0NAot
LS0gYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKKysrIGIvYXJjaC9hcm02NC9p
bmNsdWRlL2FzbS9rdm1faG9zdC5oCkBAIC02OTIsNiArNjkyLDcgQEAgZXh0ZXJuIHVuc2lnbmVk
IGludCBrdm1fYXJtX3ZtaWRfYml0czsKIGludCBrdm1fYXJtX3ZtaWRfYWxsb2NfaW5pdCh2b2lk
KTsKIHZvaWQga3ZtX2FybV92bWlkX2FsbG9jX2ZyZWUodm9pZCk7CiB2b2lkIGt2bV9hcm1fdm1p
ZF91cGRhdGUoc3RydWN0IGt2bV92bWlkICprdm1fdm1pZCk7Cit2b2lkIGt2bV9hcm1fdm1pZF9j
bGVhcl9hY3RpdmUodm9pZCk7CiAKIHN0YXRpYyBpbmxpbmUgdm9pZCBrdm1fYXJtX3B2dGltZV92
Y3B1X2luaXQoc3RydWN0IGt2bV92Y3B1X2FyY2ggKnZjcHVfYXJjaCkKIHsKZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQva3ZtL2FybS5jIGIvYXJjaC9hcm02NC9rdm0vYXJtLmMKaW5kZXggMDU0NDAx
MWIwZmM2Li5iZmU5MjY4MDUyNDAgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL2FybS5jCisr
KyBiL2FyY2gvYXJtNjQva3ZtL2FybS5jCkBAIC00MzEsNiArNDMxLDcgQEAgdm9pZCBrdm1fYXJj
aF92Y3B1X3B1dChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCiAJa3ZtX3RpbWVyX3ZjcHVfcHV0KHZj
cHUpOwogCWt2bV92Z2ljX3B1dCh2Y3B1KTsKIAlrdm1fdmNwdV9wbXVfcmVzdG9yZV9ob3N0KHZj
cHUpOworCWt2bV9hcm1fdm1pZF9jbGVhcl9hY3RpdmUoKTsKIAogCXZjcHUtPmNwdSA9IC0xOwog
fQpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vdm1pZC5jIGIvYXJjaC9hcm02NC9rdm0vdm1p
ZC5jCmluZGV4IDlhZmY2OTJiNmI3ZC4uOTY2ZWJiMmQxMmU1IDEwMDY0NAotLS0gYS9hcmNoL2Fy
bTY0L2t2bS92bWlkLmMKKysrIGIvYXJjaC9hcm02NC9rdm0vdm1pZC5jCkBAIC0zMiw2ICszMiwx
MyBAQCBzdGF0aWMgREVGSU5FX1BFUl9DUFUodTY0LCByZXNlcnZlZF92bWlkcyk7CiAjZGVmaW5l
IHZtaWQyaWR4KHZtaWQpCQkoKHZtaWQpICYgflZNSURfTUFTSykKICNkZWZpbmUgaWR4MnZtaWQo
aWR4KQkJdm1pZDJpZHgoaWR4KQogCisvKgorICogQXMgdm1pZCAjMCBpcyBhbHdheXMgcmVzZXJ2
ZWQsIHdlIHdpbGwgbmV2ZXIgYWxsb2NhdGUgb25lCisgKiBhcyBiZWxvdyBhbmQgY2FuIGJlIHRy
ZWF0ZWQgYXMgaW52YWxpZC4gVGhpcyBpcyB1c2VkIHRvCisgKiBzZXQgdGhlIGFjdGl2ZV92bWlk
cyBvbiB2Q1BVIHNjaGVkdWxlIG91dC4KKyAqLworI2RlZmluZSBWTUlEX0FDVElWRV9JTlZBTElE
CQlWTUlEX0ZJUlNUX1ZFUlNJT04KKwogI2RlZmluZSB2bWlkX2dlbl9tYXRjaCh2bWlkKSBcCiAJ
KCEoKCh2bWlkKSBeIGF0b21pYzY0X3JlYWQoJnZtaWRfZ2VuZXJhdGlvbikpID4+IGt2bV9hcm1f
dm1pZF9iaXRzKSkKIApAQCAtMTIyLDYgKzEyOSwxMiBAQCBzdGF0aWMgdTY0IG5ld192bWlkKHN0
cnVjdCBrdm1fdm1pZCAqa3ZtX3ZtaWQpCiAJcmV0dXJuIHZtaWQ7CiB9CiAKKy8qIENhbGxlZCBm
cm9tIHZDUFUgc2NoZWQgb3V0IHdpdGggcHJlZW1wdGlvbiBkaXNhYmxlZCAqLwordm9pZCBrdm1f
YXJtX3ZtaWRfY2xlYXJfYWN0aXZlKHZvaWQpCit7CisJYXRvbWljNjRfc2V0KHRoaXNfY3B1X3B0
cigmYWN0aXZlX3ZtaWRzKSwgVk1JRF9BQ1RJVkVfSU5WQUxJRCk7Cit9CisKIHZvaWQga3ZtX2Fy
bV92bWlkX3VwZGF0ZShzdHJ1Y3Qga3ZtX3ZtaWQgKmt2bV92bWlkKQogewogCXVuc2lnbmVkIGxv
bmcgZmxhZ3M7CkBAIC0xMzIsMTEgKzE0NSwxNyBAQCB2b2lkIGt2bV9hcm1fdm1pZF91cGRhdGUo
c3RydWN0IGt2bV92bWlkICprdm1fdm1pZCkKIAkvKgogCSAqIFBsZWFzZSByZWZlciBjb21tZW50
cyBpbiBjaGVja19hbmRfc3dpdGNoX2NvbnRleHQoKSBpbgogCSAqIGFyY2gvYXJtNjQvbW0vY29u
dGV4dC5jLgorCSAqCisJICogVW5saWtlIEFTSUQgYWxsb2NhdG9yLCB3ZSBzZXQgdGhlIGFjdGl2
ZV92bWlkcyB0bworCSAqIFZNSURfQUNUSVZFX0lOVkFMSUQgb24gdkNQVSBzY2hlZHVsZSBvdXQg
dG8gYXZvaWQKKwkgKiByZXNlcnZpbmcgdGhlIFZNSUQgc3BhY2UgbmVlZGxlc3NseSBvbiByb2xs
b3Zlci4KKwkgKiBIZW5jZSBleHBsaWNpdGx5IGNoZWNrIGhlcmUgZm9yIGEgIiE9IDAiIHRvCisJ
ICogaGFuZGxlIHRoZSBzeW5jIHdpdGggYSBjb25jdXJyZW50IHJvbGxvdmVyLgogCSAqLwogCW9s
ZF9hY3RpdmVfdm1pZCA9IGF0b21pYzY0X3JlYWQodGhpc19jcHVfcHRyKCZhY3RpdmVfdm1pZHMp
KTsKLQlpZiAob2xkX2FjdGl2ZV92bWlkICYmIHZtaWRfZ2VuX21hdGNoKHZtaWQpICYmCi0JICAg
IGF0b21pYzY0X2NtcHhjaGdfcmVsYXhlZCh0aGlzX2NwdV9wdHIoJmFjdGl2ZV92bWlkcyksCi0J
CQkJICAgICBvbGRfYWN0aXZlX3ZtaWQsIHZtaWQpKQorCWlmIChvbGRfYWN0aXZlX3ZtaWQgIT0g
MCAmJiB2bWlkX2dlbl9tYXRjaCh2bWlkKSAmJgorCSAgICAwICE9IGF0b21pYzY0X2NtcHhjaGdf
cmVsYXhlZCh0aGlzX2NwdV9wdHIoJmFjdGl2ZV92bWlkcyksCisJCQkJCSAgb2xkX2FjdGl2ZV92
bWlkLCB2bWlkKSkKIAkJcmV0dXJuOwogCiAJcmF3X3NwaW5fbG9ja19pcnFzYXZlKCZjcHVfdm1p
ZF9sb2NrLCBmbGFncyk7Ci0tIAoyLjE3LjEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
