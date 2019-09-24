Return-Path: <SRS0=oENQ=XT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D70C4360C
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 15:22:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 06D93217F4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Sep 2019 15:22:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06D93217F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 86BEC4A688;
	Tue, 24 Sep 2019 11:22:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xwjR7zVL6SeR; Tue, 24 Sep 2019 11:22:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FE934A699;
	Tue, 24 Sep 2019 11:22:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 592714A672
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 11:22:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IT3go8tfdxnn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Sep 2019 11:22:36 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 211C34A5A3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Sep 2019 11:22:36 -0400 (EDT)
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 4F6A85461CE3B3AB5C3B;
 Tue, 24 Sep 2019 23:22:34 +0800 (CST)
Received: from linux-Bxxcye.huawei.com (10.175.104.222) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.439.0; Tue, 24 Sep 2019 23:22:24 +0800
From: Heyi Guo <guoheyi@huawei.com>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <qemu-arm@nongnu.org>
Subject: [RFC PATCH 2/2] kvm/arm64: expose hypercall_forwarding capability
Date: Tue, 24 Sep 2019 23:20:54 +0800
Message-ID: <1569338454-26202-3-git-send-email-guoheyi@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569338454-26202-1-git-send-email-guoheyi@huawei.com>
References: <1569338454-26202-1-git-send-email-guoheyi@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.104.222]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Heyi Guo <guoheyi@huawei.com>, Will Deacon <will@kernel.org>,
 Dave Martin <Dave.Martin@arm.com>
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

QWRkIG5ldyBLVk0gY2FwYWJpbGl0eSAiS1ZNX0NBUF9GT1JXQVJEX0hZUEVSQ0FMTCIgZm9yIHVz
ZXIgc3BhY2UgdG8KcHJvYmUgd2hldGhlciBLVk0gc3VwcG9ydHMgZm9yd2FyZGluZyBoeXBlcmNh
bGwuCgpUaGUgY2FwYWJpbGl0eSBzaG91bGQgYmUgZW5hYmxlZCBieSB1c2VyIHNwYWNlIGV4cGxp
Y2l0bHksIGZvciB3ZQpkb24ndCB3YW50IHVzZXIgc3BhY2UgYXBwbGljYXRpb24gdG8gZGVhbCB3
aXRoIHVuZXhwZWN0ZWQgaHlwZXJjYWxsCmV4aXRzLiBXZSBhbHNvIHVzZSBhbiBhZGRpdGlvbmFs
IGFyZ3VtZW50IHRvIHBhc3MgZXhjZXB0aW9uIGJpdCBtYXNrLAp0byByZXF1ZXN0IEtWTSB0byBm
b3J3YXJkIGFsbCBoeXBlcmNhbGxzIGV4Y2VwdCB0aGUgY2xhc3NlcyBzcGVjaWZpZWQKaW4gdGhl
IGJpdCBtYXNrLgoKQ3VycmVudGx5IG9ubHkgUFNDSSBjYW4gYmUgc2V0IGFzIGV4Y2VwdGlvbiwg
c28gdGhhdCB3ZSBjYW4gc3RpbGwga2VlcApjb25zaXN0ZW50IHdpdGggdGhlIG9sZCBQU0NJIHBy
b2Nlc3NpbmcgZmxvdy4KClNpZ25lZC1vZmYtYnk6IEhleWkgR3VvIDxndW9oZXlpQGh1YXdlaS5j
b20+CkNjOiBQZXRlciBNYXlkZWxsIDxwZXRlci5tYXlkZWxsQGxpbmFyby5vcmc+CkNjOiBEYXZl
IE1hcnRpbiA8RGF2ZS5NYXJ0aW5AYXJtLmNvbT4KQ2M6IE1hcmMgWnluZ2llciA8bWFyYy56eW5n
aWVyQGFybS5jb20+CkNjOiBNYXJrIFJ1dGxhbmQgPG1hcmsucnV0bGFuZEBhcm0uY29tPgpDYzog
SmFtZXMgTW9yc2UgPGphbWVzLm1vcnNlQGFybS5jb20+CkNjOiBKdWxpZW4gVGhpZXJyeSA8anVs
aWVuLnRoaWVycnkua2RldkBnbWFpbC5jb20+CkNjOiBTdXp1a2kgSyBQb3Vsb3NlIDxzdXp1a2ku
cG91bG9zZUBhcm0uY29tPgpDYzogQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1hcmluYXNAYXJt
LmNvbT4KQ2M6IFdpbGwgRGVhY29uIDx3aWxsQGtlcm5lbC5vcmc+CkNjOiBQYW9sbyBCb256aW5p
IDxwYm9uemluaUByZWRoYXQuY29tPgpDYzogIlJhZGltIEtyxI1tw6HFmSIgPHJrcmNtYXJAcmVk
aGF0LmNvbT4KLS0tCiBhcmNoL2FybTY0L2t2bS9yZXNldC5jICAgfCAyNSArKysrKysrKysrKysr
KysrKysrKysrKysrCiBpbmNsdWRlL3VhcGkvbGludXgva3ZtLmggfCAgMyArKysKIDIgZmlsZXMg
Y2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3Jl
c2V0LmMgYi9hcmNoL2FybTY0L2t2bS9yZXNldC5jCmluZGV4IGY0YThhZTkuLjIyMDFiNjIgMTAw
NjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL3Jlc2V0LmMKKysrIGIvYXJjaC9hcm02NC9rdm0vcmVz
ZXQuYwpAQCAtOTUsNiArOTUsOSBAQCBpbnQga3ZtX2FyY2hfdm1faW9jdGxfY2hlY2tfZXh0ZW5z
aW9uKHN0cnVjdCBrdm0gKmt2bSwgbG9uZyBleHQpCiAJCXIgPSBoYXNfdmhlKCkgJiYgc3lzdGVt
X3N1cHBvcnRzX2FkZHJlc3NfYXV0aCgpICYmCiAJCQkJIHN5c3RlbV9zdXBwb3J0c19nZW5lcmlj
X2F1dGgoKTsKIAkJYnJlYWs7CisJY2FzZSBLVk1fQ0FQX0ZPUldBUkRfSFlQRVJDQUxMOgorCQly
ID0gMTsKKwkJYnJlYWs7CiAJZGVmYXVsdDoKIAkJciA9IDA7CiAJfQpAQCAtMTAyLDYgKzEwNSwy
OCBAQCBpbnQga3ZtX2FyY2hfdm1faW9jdGxfY2hlY2tfZXh0ZW5zaW9uKHN0cnVjdCBrdm0gKmt2
bSwgbG9uZyBleHQpCiAJcmV0dXJuIHI7CiB9CiAKK2ludCBrdm1fdm1faW9jdGxfZW5hYmxlX2Nh
cChzdHJ1Y3Qga3ZtICprdm0sCisJCQkgICAgc3RydWN0IGt2bV9lbmFibGVfY2FwICpjYXApCit7
CisJaWYgKGNhcC0+ZmxhZ3MpCisJCXJldHVybiAtRUlOVkFMOworCisJc3dpdGNoIChjYXAtPmNh
cCkgeworCWNhc2UgS1ZNX0NBUF9GT1JXQVJEX0hZUEVSQ0FMTDogeworCQlfX3U2NCBleGNsdWRl
X2ZsYWdzID0gY2FwLT5hcmdzWzBdOworCQkvKiBPbmx5IHN1cHBvcnQgZXhjbHVkaW5nIFBTQ0kg
cmlnaHQgbm93ICovCisJCWlmIChleGNsdWRlX2ZsYWdzICYgfktWTV9DQVBfRk9SV0FSRF9IWVBF
UkNBTExfRVhDTF9QU0NJKQorCQkJcmV0dXJuIC1FSU5WQUw7CisJCWt2bS0+YXJjaC5oeXBlcmNh
bGxfZm9yd2FyZCA9IHRydWU7CisJCWlmIChleGNsdWRlX2ZsYWdzICYgS1ZNX0NBUF9GT1JXQVJE
X0hZUEVSQ0FMTF9FWENMX1BTQ0kpCisJCQlrdm0tPmFyY2guaHlwZXJjYWxsX2V4Y2xfcHNjaSA9
IHRydWU7CisJCXJldHVybiAwOworCX0KKwl9CisKKwlyZXR1cm4gLUVJTlZBTDsKK30KKwogdW5z
aWduZWQgaW50IGt2bV9zdmVfbWF4X3ZsOwogCiBpbnQga3ZtX2FybV9pbml0X3N2ZSh2b2lkKQpk
aWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2t2bS5oIGIvaW5jbHVkZS91YXBpL2xpbnV4
L2t2bS5oCmluZGV4IDVlM2YxMmQuLmUzZTU3ODcgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvdWFwaS9s
aW51eC9rdm0uaAorKysgYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgKQEAgLTcxMSw2ICs3MTEs
OCBAQCBzdHJ1Y3Qga3ZtX2VuYWJsZV9jYXAgewogCV9fdTggIHBhZFs2NF07CiB9OwogCisjZGVm
aW5lIEtWTV9DQVBfRk9SV0FSRF9IWVBFUkNBTExfRVhDTF9QU0NJCSgxIDw8IDApCisKIC8qIGZv
ciBLVk1fUFBDX0dFVF9QVklORk8gKi8KIAogI2RlZmluZSBLVk1fUFBDX1BWSU5GT19GTEFHU19F
Vl9JRExFICAgKDE8PDApCkBAIC05OTYsNiArOTk4LDcgQEAgc3RydWN0IGt2bV9wcGNfcmVzaXpl
X2hwdCB7CiAjZGVmaW5lIEtWTV9DQVBfQVJNX1BUUkFVVEhfQUREUkVTUyAxNzEKICNkZWZpbmUg
S1ZNX0NBUF9BUk1fUFRSQVVUSF9HRU5FUklDIDE3MgogI2RlZmluZSBLVk1fQ0FQX1BNVV9FVkVO
VF9GSUxURVIgMTczCisjZGVmaW5lIEtWTV9DQVBfRk9SV0FSRF9IWVBFUkNBTEwgMTc0CiAKICNp
ZmRlZiBLVk1fQ0FQX0lSUV9ST1VUSU5HCiAKLS0gCjEuOC4zLjEKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
