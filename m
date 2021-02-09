Return-Path: <SRS0=2BI6=HL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F7BC433DB
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:04:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2258664EBA
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:04:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2258664EBA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9FC74B68E;
	Tue,  9 Feb 2021 00:04:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y+CHzOu2LXke; Tue,  9 Feb 2021 00:04:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BDAB4B6F4;
	Tue,  9 Feb 2021 00:04:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6C64B559
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:04:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AsGaXqEk9h9w for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2021 00:04:27 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0B214B6F4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:04:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612847066;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=0II6lOIWtDqZONeydOmeOtky4VbHS29zjzqopD/ZPWM=;
 b=EbCxrkpVJKTSleqEDtn/M0hHxxCd8kzP5NkUnc3hQIgjBEihX2rkgR5h/vWJIvseWtGt9E
 2bm8RmSSkylGQuQ3bQrvGL2zccW/j4hOEtUnpzM7CY3lQGbeooJ8uWuhIbA1rjTyKgAjC/
 nTXsh4/f5WfH+RaiNQC5GR+Mtn8FPBQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-513-Ivgy9iiUNoO7sTYvi6--fw-1; Tue, 09 Feb 2021 00:04:21 -0500
X-MC-Unique: Ivgy9iiUNoO7sTYvi6--fw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 932DD803F4D;
 Tue,  9 Feb 2021 05:04:19 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-26.bne.redhat.com [10.64.54.26])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 9E16F5D9C0;
 Tue,  9 Feb 2021 05:04:16 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 01/17] KVM: async_pf: Move struct kvm_async_pf around
Date: Tue,  9 Feb 2021 13:03:47 +0800
Message-Id: <20210209050403.103143-2-gshan@redhat.com>
In-Reply-To: <20210209050403.103143-1-gshan@redhat.com>
References: <20210209050403.103143-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, will@kernel.org
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

VGhpcyBtb3ZlcyB0aGUgZGVmaW5pdGlvbnMgb2YgInN0cnVjdCBrdm1fYXN5bmNfcGYiIGFuZCB0
aGUgcmVsYXRlZApmdW5jdGlvbnMgYWZ0ZXIgInN0cnVjdCBrdm1fdmNwdSIgc28gdGhhdCBuZXds
eSBhZGRlZCBpbmxpbmUgZnVuY3Rpb24KY2FuIGRlcmVmZXJlbmNlICJzdHJ1Y3Qga3ZtX3ZjcHUi
IHByb3Blcmx5LiBPdGhlcndpc2UsIHRoZSB1bmV4cGVjdGVkCmJ1aWxkIGVycm9yIHdpbGwgYmUg
cmFpc2VkOgoKICAgZXJyb3I6IGRlcmVmZXJlbmNpbmcgcG9pbnRlciB0byBpbmNvbXBsZXRlIHR5
cGUg4oCYc3RydWN0IGt2bV92Y3B14oCZCiAgIHJldHVybiAhbGlzdF9lbXB0eV9jYXJlZnVsKCZ2
Y3B1LT5hc3luY19wZi5kb25lKTsKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBe
fgoKVGhlIHNlcGF0b3IgYmV0d2VlbiB0eXBlIGFuZCBmaWVsZCBpcyByZXBsYWNlZCBieSB0YWIg
Zm9yICJzdHJ1Y3QKa3ZtX2FzeW5jX3BmIiBzaW5jZSB3ZSdyZSBoZXJlLiBUaGlzIGlzIHByZXBh
cmF0b3J5IHdvcmsgZm9yIGFkZGluZwpuZXcgaW5saW5lIGZ1bmN0aW9uIGZvciBuZXh0IHBhdGNo
LiBUaGlzIHNob3VsZG4ndCBjYXVzZSBsb2dpY2FsCmNoYW5nZXMuCgpTaWduZWQtb2ZmLWJ5OiBH
YXZpbiBTaGFuIDxnc2hhbkByZWRoYXQuY29tPgotLS0KIGluY2x1ZGUvbGludXgva3ZtX2hvc3Qu
aCB8IDQzICsrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBj
aGFuZ2VkLCAyMiBpbnNlcnRpb25zKCspLCAyMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9p
bmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKaW5kZXgg
ZjNiMTAxM2ZiMjJjLi5iNjY5N2VlMTE4MmUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgva3Zt
X2hvc3QuaAorKysgYi9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmgKQEAgLTE5NiwyNyArMTk2LDYg
QEAgdm9pZCBrdm1faW9fYnVzX3VucmVnaXN0ZXJfZGV2KHN0cnVjdCBrdm0gKmt2bSwgZW51bSBr
dm1fYnVzIGJ1c19pZHgsCiBzdHJ1Y3Qga3ZtX2lvX2RldmljZSAqa3ZtX2lvX2J1c19nZXRfZGV2
KHN0cnVjdCBrdm0gKmt2bSwgZW51bSBrdm1fYnVzIGJ1c19pZHgsCiAJCQkJCSBncGFfdCBhZGRy
KTsKIAotI2lmZGVmIENPTkZJR19LVk1fQVNZTkNfUEYKLXN0cnVjdCBrdm1fYXN5bmNfcGYgewot
CXN0cnVjdCB3b3JrX3N0cnVjdCB3b3JrOwotCXN0cnVjdCBsaXN0X2hlYWQgbGluazsKLQlzdHJ1
Y3QgbGlzdF9oZWFkIHF1ZXVlOwotCXN0cnVjdCBrdm1fdmNwdSAqdmNwdTsKLQlzdHJ1Y3QgbW1f
c3RydWN0ICptbTsKLQlncGFfdCBjcjJfb3JfZ3BhOwotCXVuc2lnbmVkIGxvbmcgYWRkcjsKLQlz
dHJ1Y3Qga3ZtX2FyY2hfYXN5bmNfcGYgYXJjaDsKLQlib29sICAgd2FrZXVwX2FsbDsKLQlib29s
IG5vdHByZXNlbnRfaW5qZWN0ZWQ7Ci19OwotCi12b2lkIGt2bV9jbGVhcl9hc3luY19wZl9jb21w
bGV0aW9uX3F1ZXVlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Ci12b2lkIGt2bV9jaGVja19hc3lu
Y19wZl9jb21wbGV0aW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Ci1ib29sIGt2bV9zZXR1cF9h
c3luY19wZihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdwYV90IGNyMl9vcl9ncGEsCi0JCQl1bnNp
Z25lZCBsb25nIGh2YSwgc3RydWN0IGt2bV9hcmNoX2FzeW5jX3BmICphcmNoKTsKLWludCBrdm1f
YXN5bmNfcGZfd2FrZXVwX2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwotI2VuZGlmCi0KIGVu
dW0gewogCU9VVFNJREVfR1VFU1RfTU9ERSwKIAlJTl9HVUVTVF9NT0RFLApAQCAtMzIzLDYgKzMw
MiwyOCBAQCBzdHJ1Y3Qga3ZtX3ZjcHUgewogCXN0cnVjdCBrdm1fZGlydHlfcmluZyBkaXJ0eV9y
aW5nOwogfTsKIAorI2lmZGVmIENPTkZJR19LVk1fQVNZTkNfUEYKK3N0cnVjdCBrdm1fYXN5bmNf
cGYgeworCXN0cnVjdCB3b3JrX3N0cnVjdAkJd29yazsKKwlzdHJ1Y3QgbGlzdF9oZWFkCQlsaW5r
OworCXN0cnVjdCBsaXN0X2hlYWQJCXF1ZXVlOworCXN0cnVjdCBrdm1fdmNwdQkJCSp2Y3B1Owor
CXN0cnVjdCBtbV9zdHJ1Y3QJCSptbTsKKwlncGFfdAkJCQljcjJfb3JfZ3BhOworCXVuc2lnbmVk
IGxvbmcJCQlhZGRyOworCXN0cnVjdCBrdm1fYXJjaF9hc3luY19wZglhcmNoOworCWJvb2wJCQkJ
d2FrZXVwX2FsbDsKKwlib29sCQkJCW5vdHByZXNlbnRfaW5qZWN0ZWQ7Cit9OworCit2b2lkIGt2
bV9jbGVhcl9hc3luY19wZl9jb21wbGV0aW9uX3F1ZXVlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7
Cit2b2lkIGt2bV9jaGVja19hc3luY19wZl9jb21wbGV0aW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSk7Citib29sIGt2bV9zZXR1cF9hc3luY19wZihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdwYV90
IGNyMl9vcl9ncGEsCisJCQl1bnNpZ25lZCBsb25nIGh2YSwgc3RydWN0IGt2bV9hcmNoX2FzeW5j
X3BmICphcmNoKTsKK2ludCBrdm1fYXN5bmNfcGZfd2FrZXVwX2FsbChzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUpOworI2VuZGlmCisKKwogc3RhdGljIGlubGluZSBpbnQga3ZtX3ZjcHVfZXhpdGluZ19n
dWVzdF9tb2RlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIHsKIAkvKgotLSAKMi4yMy4wCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
