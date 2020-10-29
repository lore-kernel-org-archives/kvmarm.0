Return-Path: <SRS0=BReL=EE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F76AC4741F
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 20:11:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A697206DD
	for <kvmarm@archiver.kernel.org>; Thu, 29 Oct 2020 20:11:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kc/nOuV1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A697206DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B82684B5EB;
	Thu, 29 Oct 2020 16:11:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4qDsogm6fZkR; Thu, 29 Oct 2020 16:11:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D0B54B661;
	Thu, 29 Oct 2020 16:11:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA4B34B60F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 16:11:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MDr4fmi4OWAh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Oct 2020 16:11:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE8E84B5EB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Oct 2020 16:11:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604002276;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=thNG7gXBuBd5xJEE4BsdcfOFEgJERLpzQNqMfjfSQZA=;
 b=Kc/nOuV1COwTkdIdbHMoMwXsNX9bdZq5GOx4SuPfvCGqv0EegZWby3mftV8rkr4tVHvvjI
 bAJz5FY0x6EPOTP5IgGLOL1C7bCJMv/AeStoLL3ynMPFC8SY2X7UD/5AW5lsZ2gUEZdVV3
 pjl/zn5dwqOBFVJgCUVI/1QCMfYgtlE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-1Bz6w3qcN-OkSGRzYqAzoA-1; Thu, 29 Oct 2020 16:11:14 -0400
X-MC-Unique: 1Bz6w3qcN-OkSGRzYqAzoA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 027A080686E;
 Thu, 29 Oct 2020 20:11:13 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.219])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 7CF415C26A;
 Thu, 29 Oct 2020 20:11:09 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 1/3] KVM: arm64: Don't hide ID registers from userspace
Date: Thu, 29 Oct 2020 21:11:03 +0100
Message-Id: <20201029201105.101910-2-drjones@redhat.com>
In-Reply-To: <20201029201105.101910-1-drjones@redhat.com>
References: <20201029201105.101910-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: maz@kernel.org, xu910121@sina.com, Dave.Martin@arm.com
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

SUQgcmVnaXN0ZXJzIGFyZSBSQVogdW50aWwgdGhleSd2ZSBiZWVuIGFsbG9jYXRlZCBhIHB1cnBv
c2UsIGJ1dAp0aGF0IGRvZXNuJ3QgbWVhbiB0aGV5IHNob3VsZCBiZSByZW1vdmVkIGZyb20gdGhl
IEtWTV9HRVRfUkVHX0xJU1QKbGlzdC4gU28gZmFyIHdlIG9ubHkgaGF2ZSBvbmUgcmVnaXN0ZXIs
IFNZU19JRF9BQTY0WkZSMF9FTDEsIHRoYXQKaXMgaGlkZGVuIGZyb20gdXNlcnNwYWNlIHdoZW4g
aXRzIGZ1bmN0aW9uIGlzIG5vdCBwcmVzZW50LiBSZW1vdmluZwp0aGUgdXNlcnNwYWNlIHZpc2li
aWxpdHkgY2hlY2tzIGlzIGVub3VnaCB0byByZWV4cG9zZSBpdCwgYXMgaXQKYWxyZWFkeSBiZWhh
dmVzIGFzIFJBWiB3aGVuIHRoZSBmdW5jdGlvbiBpcyBub3QgcHJlc2VudC4KCkZpeGVzOiA3MzQz
Mzc2MmZjYWUgKCJLVk06IGFybTY0L3N2ZTogU3lzdGVtIHJlZ2lzdGVyIGNvbnRleHQgc3dpdGNo
IGFuZCBhY2Nlc3Mgc3VwcG9ydCIpClJlcG9ydGVkLWJ5OiDlvKDkuJzml60gPHh1OTEwMTIxQHNp
bmEuY29tPgpTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgSm9uZXMgPGRyam9uZXNAcmVkaGF0LmNvbT4K
LS0tCiBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIHwgMTggKy0tLS0tLS0tLS0tLS0tLS0tCiAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDE3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5j
CmluZGV4IGQ5MTE3YmM1NjIzNy4uZDI0ZTY2ZWU1OWIzIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0
L2t2bS9zeXNfcmVncy5jCisrKyBiL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKQEAgLTExOTUs
MTYgKzExOTUsNiBAQCBzdGF0aWMgdW5zaWduZWQgaW50IHN2ZV92aXNpYmlsaXR5KGNvbnN0IHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSwKIAlyZXR1cm4gUkVHX0hJRERFTl9VU0VSIHwgUkVHX0hJRERF
Tl9HVUVTVDsKIH0KIAotLyogVmlzaWJpbGl0eSBvdmVycmlkZXMgZm9yIFNWRS1zcGVjaWZpYyBJ
RCByZWdpc3RlcnMgKi8KLXN0YXRpYyB1bnNpZ25lZCBpbnQgc3ZlX2lkX3Zpc2liaWxpdHkoY29u
c3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAotCQkJCSAgICAgIGNvbnN0IHN0cnVjdCBzeXNfcmVn
X2Rlc2MgKnJkKQotewotCWlmICh2Y3B1X2hhc19zdmUodmNwdSkpCi0JCXJldHVybiAwOwotCi0J
cmV0dXJuIFJFR19ISURERU5fVVNFUjsKLX0KLQogLyogR2VuZXJhdGUgdGhlIGVtdWxhdGVkIElE
X0FBNjRaRlIwX0VMMSB2YWx1ZSBleHBvc2VkIHRvIHRoZSBndWVzdCAqLwogc3RhdGljIHU2NCBn
dWVzdF9pZF9hYTY0emZyMF9lbDEoY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogewpAQCAt
MTIzMSw5ICsxMjIxLDYgQEAgc3RhdGljIGludCBnZXRfaWRfYWE2NHpmcjBfZWwxKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwKIHsKIAl1NjQgdmFsOwogCi0JaWYgKFdBUk5fT04oIXZjcHVfaGFzX3N2
ZSh2Y3B1KSkpCi0JCXJldHVybiAtRU5PRU5UOwotCiAJdmFsID0gZ3Vlc3RfaWRfYWE2NHpmcjBf
ZWwxKHZjcHUpOwogCXJldHVybiByZWdfdG9fdXNlcih1YWRkciwgJnZhbCwgcmVnLT5pZCk7CiB9
CkBAIC0xMjQ2LDkgKzEyMzMsNiBAQCBzdGF0aWMgaW50IHNldF9pZF9hYTY0emZyMF9lbDEoc3Ry
dWN0IGt2bV92Y3B1ICp2Y3B1LAogCWludCBlcnI7CiAJdTY0IHZhbDsKIAotCWlmIChXQVJOX09O
KCF2Y3B1X2hhc19zdmUodmNwdSkpKQotCQlyZXR1cm4gLUVOT0VOVDsKLQogCWVyciA9IHJlZ19m
cm9tX3VzZXIoJnZhbCwgdWFkZHIsIGlkKTsKIAlpZiAoZXJyKQogCQlyZXR1cm4gZXJyOwpAQCAt
MTUxOCw3ICsxNTAyLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2Mgc3lzX3Jl
Z19kZXNjc1tdID0gewogCUlEX1NBTklUSVNFRChJRF9BQTY0UEZSMV9FTDEpLAogCUlEX1VOQUxM
T0NBVEVEKDQsMiksCiAJSURfVU5BTExPQ0FURUQoNCwzKSwKLQl7IFNZU19ERVNDKFNZU19JRF9B
QTY0WkZSMF9FTDEpLCBhY2Nlc3NfaWRfYWE2NHpmcjBfZWwxLCAuZ2V0X3VzZXIgPSBnZXRfaWRf
YWE2NHpmcjBfZWwxLCAuc2V0X3VzZXIgPSBzZXRfaWRfYWE2NHpmcjBfZWwxLCAudmlzaWJpbGl0
eSA9IHN2ZV9pZF92aXNpYmlsaXR5IH0sCisJeyBTWVNfREVTQyhTWVNfSURfQUE2NFpGUjBfRUwx
KSwgYWNjZXNzX2lkX2FhNjR6ZnIwX2VsMSwgLmdldF91c2VyID0gZ2V0X2lkX2FhNjR6ZnIwX2Vs
MSwgLnNldF91c2VyID0gc2V0X2lkX2FhNjR6ZnIwX2VsMSwgfSwKIAlJRF9VTkFMTE9DQVRFRCg0
LDUpLAogCUlEX1VOQUxMT0NBVEVEKDQsNiksCiAJSURfVU5BTExPQ0FURUQoNCw3KSwKLS0gCjIu
MjcuMAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
