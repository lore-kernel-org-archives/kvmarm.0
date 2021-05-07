Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE5EC433ED
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:41:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B3B6F613C8
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:41:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3B6F613C8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EDFC4B314;
	Fri,  7 May 2021 02:41:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YfcC3HZk0Z6R; Fri,  7 May 2021 02:41:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9AC024B54C;
	Fri,  7 May 2021 02:41:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A13D44B47E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:41:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XyOJmVBGABpy for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 02:41:00 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9614B2FA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:41:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620369660;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=M8lFeeN8be7qhuOQQpXtHcaLdac3IpsizI/USRchIjU=;
 b=SRLL8xXb9na4hLcwmpXb6Cn5y1P0R+MLljmEJpGDfzFc1WuQeK8TyIMyVzJClq/pjrdGPo
 7A5vsDfgZ1hPttPhA/qaLXncy/adIAF7CCV38iXo3npo85AwE21g7c2unjbekmgmCjqvQf
 8gAb+8hmqq/QdIDnZrWW6ko/EZk+5n0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-L3HFR7wINaeUNi4LrcfFOg-1; Fri, 07 May 2021 02:40:59 -0400
X-MC-Unique: L3HFR7wINaeUNi4LrcfFOg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C139C80059E;
 Fri,  7 May 2021 06:40:57 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 9EC065C276;
 Fri,  7 May 2021 06:40:54 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 01/15] KVM: async_pf: Move struct kvm_async_pf around
Date: Fri,  7 May 2021 16:40:39 +0800
Message-Id: <20210507084053.44407-2-gshan@redhat.com>
In-Reply-To: <20210507084053.44407-1-gshan@redhat.com>
References: <20210507084053.44407-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
eSBhZGRlZCBpbmxpbmUgZnVuY3Rpb25zCmluIHRoZSBzdWJzZXF1ZW50IHBhdGNoZXMgY2FuIGRl
cmVmZXJlbmNlICJzdHJ1Y3Qga3ZtX3ZjcHUiIHByb3Blcmx5LgpPdGhlcndpc2UsIHRoZSB1bmV4
cGVjdGVkIGJ1aWxkIGVycm9yIHdpbGwgYmUgcmFpc2VkOgoKICAgZXJyb3I6IGRlcmVmZXJlbmNp
bmcgcG9pbnRlciB0byBpbmNvbXBsZXRlIHR5cGUg4oCYc3RydWN0IGt2bV92Y3B14oCZCiAgIHJl
dHVybiAhbGlzdF9lbXB0eV9jYXJlZnVsKCZ2Y3B1LT5hc3luY19wZi5kb25lKTsKICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBefgoKU29tZSBjbGVhbnVwcyBhcmUgYWxzbyBhcHBs
aWVkIHNpbmNlIHdlJ3JlIGhlcmU6CgogICAqIFRoZSBzZXBhdG9yIGJldHdlZW4gdHlwZSBhbmQg
ZmllbGQgaXMgcmVwbGFjZWQgYnkgdGFiIGZvciAic3RydWN0CiAgICAga3ZtX2FzeW5jX3BmIi4K
CiAgICogQWRkZWQgc3R1YiBrdm1fY2hlY2tfYXN5bmNfcGZfY29tcGxldGlvbigpIHdoZW4gQ09O
RklHX0tWTV9BU1lNQ19QRgogICAgIGlzIGRpc2FibGVkLgoKU2lnbmVkLW9mZi1ieTogR2F2aW4g
U2hhbiA8Z3NoYW5AcmVkaGF0LmNvbT4KLS0tCiBpbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggfCA0
NCArKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgMjMgaW5zZXJ0aW9ucygrKSwgMjEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVk
ZS9saW51eC9rdm1faG9zdC5oIGIvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oCmluZGV4IDg4OTVi
OTViNmEyMi4uZDU0YWRiYTZlYmY3IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2t2bV9ob3N0
LmgKKysrIGIvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oCkBAIC0xOTcsMjcgKzE5Nyw2IEBAIGlu
dCBrdm1faW9fYnVzX3VucmVnaXN0ZXJfZGV2KHN0cnVjdCBrdm0gKmt2bSwgZW51bSBrdm1fYnVz
IGJ1c19pZHgsCiBzdHJ1Y3Qga3ZtX2lvX2RldmljZSAqa3ZtX2lvX2J1c19nZXRfZGV2KHN0cnVj
dCBrdm0gKmt2bSwgZW51bSBrdm1fYnVzIGJ1c19pZHgsCiAJCQkJCSBncGFfdCBhZGRyKTsKIAot
I2lmZGVmIENPTkZJR19LVk1fQVNZTkNfUEYKLXN0cnVjdCBrdm1fYXN5bmNfcGYgewotCXN0cnVj
dCB3b3JrX3N0cnVjdCB3b3JrOwotCXN0cnVjdCBsaXN0X2hlYWQgbGluazsKLQlzdHJ1Y3QgbGlz
dF9oZWFkIHF1ZXVlOwotCXN0cnVjdCBrdm1fdmNwdSAqdmNwdTsKLQlzdHJ1Y3QgbW1fc3RydWN0
ICptbTsKLQlncGFfdCBjcjJfb3JfZ3BhOwotCXVuc2lnbmVkIGxvbmcgYWRkcjsKLQlzdHJ1Y3Qg
a3ZtX2FyY2hfYXN5bmNfcGYgYXJjaDsKLQlib29sICAgd2FrZXVwX2FsbDsKLQlib29sIG5vdHBy
ZXNlbnRfaW5qZWN0ZWQ7Ci19OwotCi12b2lkIGt2bV9jbGVhcl9hc3luY19wZl9jb21wbGV0aW9u
X3F1ZXVlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Ci12b2lkIGt2bV9jaGVja19hc3luY19wZl9j
b21wbGV0aW9uKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7Ci1ib29sIGt2bV9zZXR1cF9hc3luY19w
ZihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdwYV90IGNyMl9vcl9ncGEsCi0JCQl1bnNpZ25lZCBs
b25nIGh2YSwgc3RydWN0IGt2bV9hcmNoX2FzeW5jX3BmICphcmNoKTsKLWludCBrdm1fYXN5bmNf
cGZfd2FrZXVwX2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwotI2VuZGlmCi0KICNpZmRlZiBL
Vk1fQVJDSF9XQU5UX01NVV9OT1RJRklFUgogc3RydWN0IGt2bV9nZm5fcmFuZ2UgewogCXN0cnVj
dCBrdm1fbWVtb3J5X3Nsb3QgKnNsb3Q7CkBAIC0zMzgsNiArMzE3LDI5IEBAIHN0cnVjdCBrdm1f
dmNwdSB7CiAJc3RydWN0IGt2bV9kaXJ0eV9yaW5nIGRpcnR5X3Jpbmc7CiB9OwogCisjaWZkZWYg
Q09ORklHX0tWTV9BU1lOQ19QRgorc3RydWN0IGt2bV9hc3luY19wZiB7CisJc3RydWN0IHdvcmtf
c3RydWN0CQl3b3JrOworCXN0cnVjdCBsaXN0X2hlYWQJCWxpbms7CisJc3RydWN0IGxpc3RfaGVh
ZAkJcXVldWU7CisJc3RydWN0IGt2bV92Y3B1CQkJKnZjcHU7CisJc3RydWN0IG1tX3N0cnVjdAkJ
Km1tOworCWdwYV90CQkJCWNyMl9vcl9ncGE7CisJdW5zaWduZWQgbG9uZwkJCWFkZHI7CisJc3Ry
dWN0IGt2bV9hcmNoX2FzeW5jX3BmCWFyY2g7CisJYm9vbAkJCQl3YWtldXBfYWxsOworCWJvb2wJ
CQkJbm90cHJlc2VudF9pbmplY3RlZDsKK307CisKK3ZvaWQga3ZtX2NsZWFyX2FzeW5jX3BmX2Nv
bXBsZXRpb25fcXVldWUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsKK3ZvaWQga3ZtX2NoZWNrX2Fz
eW5jX3BmX2NvbXBsZXRpb24oc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsKK2Jvb2wga3ZtX3NldHVw
X2FzeW5jX3BmKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgZ3BhX3QgY3IyX29yX2dwYSwKKwkJCXVu
c2lnbmVkIGxvbmcgaHZhLCBzdHJ1Y3Qga3ZtX2FyY2hfYXN5bmNfcGYgKmFyY2gpOworaW50IGt2
bV9hc3luY19wZl93YWtldXBfYWxsKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7CisjZWxzZQorc3Rh
dGljIGlubGluZSB2b2lkIGt2bV9jaGVja19hc3luY19wZl9jb21wbGV0aW9uKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSkgeyB9CisjZW5kaWYKKwogc3RhdGljIGlubGluZSBpbnQga3ZtX3ZjcHVfZXhp
dGluZ19ndWVzdF9tb2RlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIHsKIAkvKgotLSAKMi4yMy4w
CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0g
bWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
