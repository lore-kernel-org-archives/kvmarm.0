Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDE5C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 01:01:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D207760F39
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 01:01:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D207760F39
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 859CA49E8C;
	Sat, 14 Aug 2021 21:01:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VHrcfSYiLchH; Sat, 14 Aug 2021 21:01:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DA8E49FE6;
	Sat, 14 Aug 2021 21:01:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F7C34AED4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 21:01:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sE0ppQEPD373 for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Aug 2021 21:01:30 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A6414A500
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 21:01:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628989290;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wWP6RGsbS05Ong3eKswiduOpUs/hgQz8GgliHnHRYWU=;
 b=SRfaEMuD7ZUhDFwK1ZqY3QArxnCK9WZAt1/PU9zGDHVAJVsBNHv43QQyWwX+7CQspF2cgy
 ECgzGwALtlArkjNE0NIfijxrm1ZWVyKrcql424MrJOGT5lETXK0iqL3XekEMlZTc4vW0Ru
 IVsc9Z1fOTIaTwrot/ppr9k1I2sWtfA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-DdB0egO7MQa688jEAG9r8w-1; Sat, 14 Aug 2021 21:01:28 -0400
X-MC-Unique: DdB0egO7MQa688jEAG9r8w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34434801B3D;
 Sun, 15 Aug 2021 01:01:27 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EE3606A05F;
 Sun, 15 Aug 2021 01:01:06 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 01/15] KVM: async_pf: Move struct kvm_async_pf around
Date: Sun, 15 Aug 2021 08:59:33 +0800
Message-Id: <20210815005947.83699-2-gshan@redhat.com>
In-Reply-To: <20210815005947.83699-1-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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

VGhpcyBtb3ZlcyB0aGUgZGVmaW5pdGlvbiBvZiAic3RydWN0IGt2bV9hc3luY19wZiIgYW5kIHRo
ZSByZWxhdGVkCmZ1bmN0aW9ucyBhZnRlciAic3RydWN0IGt2bV92Y3B1IiBzbyB0aGF0IG5ld2x5
IGFkZGVkIGlubGluZSBmdW5jdGlvbnMKaW4gdGhlIHN1YnNlcXVlbnQgcGF0Y2hlcyBjYW4gZGVy
ZWZlcmVuY2UgInN0cnVjdCBrdm1fdmNwdSIgcHJvcGVybHkuCk90aGVyd2lzZSwgdGhlIHVuZXhw
ZWN0ZWQgYnVpbGQgZXJyb3Igd2lsbCBiZSByYWlzZWQ6CgogICBlcnJvcjogZGVyZWZlcmVuY2lu
ZyBwb2ludGVyIHRvIGluY29tcGxldGUgdHlwZSDigJhzdHJ1Y3Qga3ZtX3ZjcHXigJkKICAgcmV0
dXJuICFsaXN0X2VtcHR5X2NhcmVmdWwoJnZjcHUtPmFzeW5jX3BmLmRvbmUpOwogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIF5+ClNpbmNlIHdlJ3JlIGhlcmUsIHRoZSBzZXBhdG9y
IGJldHdlZW4gdHlwZSBhbmQgZmllbGQgaW4gInN0cnVjdCBrdm1fdmNwdSIKaXMgcmVwbGFjZWQg
YnkgdGFiLiBUaGUgZW1wdHkgc3R1YiBrdm1fY2hlY2tfYXN5bmNfcGZfY29tcGxldGlvbigpIGlz
IGFsc28KYWRkZWQgb24gIUNPTkZJR19LVk1fQVNZTkNfUEYsIHdoaWNoIGlzIG5lZWRlZCBieSBz
dWJzZXF1ZW50IHBhdGNoZXMgdG8Kc3VwcG9ydCBhc3luY2hyb25vdXMgcGFnZSBmYXVsdCBvbiBB
Uk02NC4KClNpZ25lZC1vZmYtYnk6IEdhdmluIFNoYW4gPGdzaGFuQHJlZGhhdC5jb20+Ci0tLQog
aW5jbHVkZS9saW51eC9rdm1faG9zdC5oIHwgNDQgKysrKysrKysrKysrKysrKysrKysrLS0tLS0t
LS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDIzIGluc2VydGlvbnMoKyksIDIxIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaCBiL2luY2x1ZGUv
bGludXgva3ZtX2hvc3QuaAppbmRleCBhZTc3MzViNDkwYjQuLjg1YjYxYTQ1NmYxYyAxMDA2NDQK
LS0tIGEvaW5jbHVkZS9saW51eC9rdm1faG9zdC5oCisrKyBiL2luY2x1ZGUvbGludXgva3ZtX2hv
c3QuaApAQCAtMTk5LDI3ICsxOTksNiBAQCBpbnQga3ZtX2lvX2J1c191bnJlZ2lzdGVyX2Rldihz
dHJ1Y3Qga3ZtICprdm0sIGVudW0ga3ZtX2J1cyBidXNfaWR4LAogc3RydWN0IGt2bV9pb19kZXZp
Y2UgKmt2bV9pb19idXNfZ2V0X2RldihzdHJ1Y3Qga3ZtICprdm0sIGVudW0ga3ZtX2J1cyBidXNf
aWR4LAogCQkJCQkgZ3BhX3QgYWRkcik7CiAKLSNpZmRlZiBDT05GSUdfS1ZNX0FTWU5DX1BGCi1z
dHJ1Y3Qga3ZtX2FzeW5jX3BmIHsKLQlzdHJ1Y3Qgd29ya19zdHJ1Y3Qgd29yazsKLQlzdHJ1Y3Qg
bGlzdF9oZWFkIGxpbms7Ci0Jc3RydWN0IGxpc3RfaGVhZCBxdWV1ZTsKLQlzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHU7Ci0Jc3RydWN0IG1tX3N0cnVjdCAqbW07Ci0JZ3BhX3QgY3IyX29yX2dwYTsKLQl1
bnNpZ25lZCBsb25nIGFkZHI7Ci0Jc3RydWN0IGt2bV9hcmNoX2FzeW5jX3BmIGFyY2g7Ci0JYm9v
bCAgIHdha2V1cF9hbGw7Ci0JYm9vbCBub3RwcmVzZW50X2luamVjdGVkOwotfTsKLQotdm9pZCBr
dm1fY2xlYXJfYXN5bmNfcGZfY29tcGxldGlvbl9xdWV1ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUp
Owotdm9pZCBrdm1fY2hlY2tfYXN5bmNfcGZfY29tcGxldGlvbihzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUpOwotYm9vbCBrdm1fc2V0dXBfYXN5bmNfcGYoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBncGFf
dCBjcjJfb3JfZ3BhLAotCQkJdW5zaWduZWQgbG9uZyBodmEsIHN0cnVjdCBrdm1fYXJjaF9hc3lu
Y19wZiAqYXJjaCk7Ci1pbnQga3ZtX2FzeW5jX3BmX3dha2V1cF9hbGwoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KTsKLSNlbmRpZgotCiAjaWZkZWYgS1ZNX0FSQ0hfV0FOVF9NTVVfTk9USUZJRVIKIHN0
cnVjdCBrdm1fZ2ZuX3JhbmdlIHsKIAlzdHJ1Y3Qga3ZtX21lbW9yeV9zbG90ICpzbG90OwpAQCAt
MzQ2LDYgKzMyNSwyOSBAQCBzdHJ1Y3Qga3ZtX3ZjcHUgewogCXN0cnVjdCBrdm1fZGlydHlfcmlu
ZyBkaXJ0eV9yaW5nOwogfTsKIAorI2lmZGVmIENPTkZJR19LVk1fQVNZTkNfUEYKK3N0cnVjdCBr
dm1fYXN5bmNfcGYgeworCXN0cnVjdCB3b3JrX3N0cnVjdAkJd29yazsKKwlzdHJ1Y3QgbGlzdF9o
ZWFkCQlsaW5rOworCXN0cnVjdCBsaXN0X2hlYWQJCXF1ZXVlOworCXN0cnVjdCBrdm1fdmNwdQkJ
CSp2Y3B1OworCXN0cnVjdCBtbV9zdHJ1Y3QJCSptbTsKKwlncGFfdAkJCQljcjJfb3JfZ3BhOwor
CXVuc2lnbmVkIGxvbmcJCQlhZGRyOworCXN0cnVjdCBrdm1fYXJjaF9hc3luY19wZglhcmNoOwor
CWJvb2wJCQkJd2FrZXVwX2FsbDsKKwlib29sCQkJCW5vdHByZXNlbnRfaW5qZWN0ZWQ7Cit9Owor
Cit2b2lkIGt2bV9jbGVhcl9hc3luY19wZl9jb21wbGV0aW9uX3F1ZXVlKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSk7Cit2b2lkIGt2bV9jaGVja19hc3luY19wZl9jb21wbGV0aW9uKHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSk7Citib29sIGt2bV9zZXR1cF9hc3luY19wZihzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsIGdwYV90IGNyMl9vcl9ncGEsCisJCQl1bnNpZ25lZCBsb25nIGh2YSwgc3RydWN0IGt2bV9h
cmNoX2FzeW5jX3BmICphcmNoKTsKK2ludCBrdm1fYXN5bmNfcGZfd2FrZXVwX2FsbChzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUpOworI2Vsc2UKK3N0YXRpYyBpbmxpbmUgdm9pZCBrdm1fY2hlY2tfYXN5
bmNfcGZfY29tcGxldGlvbihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHsgfQorI2VuZGlmCisKIC8q
IG11c3QgYmUgY2FsbGVkIHdpdGggaXJxcyBkaXNhYmxlZCAqLwogc3RhdGljIF9fYWx3YXlzX2lu
bGluZSB2b2lkIGd1ZXN0X2VudGVyX2lycW9mZih2b2lkKQogewotLSAKMi4yMy4wCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
