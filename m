Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A717EC388F9
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 18:50:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 03F8522275
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 18:50:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RiQcAGBY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 03F8522275
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89F0F4B535;
	Mon,  2 Nov 2020 13:50:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZEWfLZwoMsfr; Mon,  2 Nov 2020 13:50:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E4D44B572;
	Mon,  2 Nov 2020 13:50:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A25F44B552
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 13:50:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5P487njdEBMQ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 13:50:48 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CDF54B36F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 13:50:48 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604343048;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=WarnExKV2VXUqG/qe/UCSIgZycztg/vXjgJOImCnVMw=;
 b=RiQcAGBYmmEWiNTW/KqpozDVk6BLXKLZh71Fq2z8QwqRtRTTtgSLZGh9etKpzZ+2UqQhLY
 mSwPwi2dfyDBKauEoaOUWOOkWLhEPjZwoVLCWmQkuXimBum2DdVcBF+ixqqnENdFZpJVLd
 ipEM1GjbVtoKWNraLo3mWA44N4EJMO8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-3uBJKwGbNqurjoh4Nt5a7w-1; Mon, 02 Nov 2020 13:50:44 -0500
X-MC-Unique: 3uBJKwGbNqurjoh4Nt5a7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 105B31009E23;
 Mon,  2 Nov 2020 18:50:43 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.222])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 960E25C22A;
 Mon,  2 Nov 2020 18:50:41 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 1/3] KVM: arm64: Don't hide ID registers from userspace
Date: Mon,  2 Nov 2020 19:50:35 +0100
Message-Id: <20201102185037.49248-2-drjones@redhat.com>
In-Reply-To: <20201102185037.49248-1-drjones@redhat.com>
References: <20201102185037.49248-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: maz@kernel.org, xu910121@sina.com, Dave.Martin@arm.com,
 stable@vger.kernel.org
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
IGFuZCBhY2Nlc3Mgc3VwcG9ydCIpCkNjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NS4y
KwpSZXBvcnRlZC1ieTog5byg5Lic5petIDx4dTkxMDEyMUBzaW5hLmNvbT4KU2lnbmVkLW9mZi1i
eTogQW5kcmV3IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+Ci0tLQogYXJjaC9hcm02NC9rdm0v
c3lzX3JlZ3MuYyB8IDE4ICstLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9z
eXNfcmVncy5jIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwppbmRleCBmYjEyZDNlZjQyM2Eu
LjZmZjBjMTU1MzFjYSAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYworKysg
Yi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCkBAIC0xMTk1LDE2ICsxMTk1LDYgQEAgc3RhdGlj
IHVuc2lnbmVkIGludCBzdmVfdmlzaWJpbGl0eShjb25zdCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUs
CiAJcmV0dXJuIFJFR19ISURERU5fVVNFUiB8IFJFR19ISURERU5fR1VFU1Q7CiB9CiAKLS8qIFZp
c2liaWxpdHkgb3ZlcnJpZGVzIGZvciBTVkUtc3BlY2lmaWMgSUQgcmVnaXN0ZXJzICovCi1zdGF0
aWMgdW5zaWduZWQgaW50IHN2ZV9pZF92aXNpYmlsaXR5KGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwKLQkJCQkgICAgICBjb25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjICpyZCkKLXsKLQlpZiAo
dmNwdV9oYXNfc3ZlKHZjcHUpKQotCQlyZXR1cm4gMDsKLQotCXJldHVybiBSRUdfSElEREVOX1VT
RVI7Ci19Ci0KIC8qIEdlbmVyYXRlIHRoZSBlbXVsYXRlZCBJRF9BQTY0WkZSMF9FTDEgdmFsdWUg
ZXhwb3NlZCB0byB0aGUgZ3Vlc3QgKi8KIHN0YXRpYyB1NjQgZ3Vlc3RfaWRfYWE2NHpmcjBfZWwx
KGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkKIHsKQEAgLTEyMzEsOSArMTIyMSw2IEBAIHN0
YXRpYyBpbnQgZ2V0X2lkX2FhNjR6ZnIwX2VsMShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCiB7CiAJ
dTY0IHZhbDsKIAotCWlmIChXQVJOX09OKCF2Y3B1X2hhc19zdmUodmNwdSkpKQotCQlyZXR1cm4g
LUVOT0VOVDsKLQogCXZhbCA9IGd1ZXN0X2lkX2FhNjR6ZnIwX2VsMSh2Y3B1KTsKIAlyZXR1cm4g
cmVnX3RvX3VzZXIodWFkZHIsICZ2YWwsIHJlZy0+aWQpOwogfQpAQCAtMTI0Niw5ICsxMjMzLDYg
QEAgc3RhdGljIGludCBzZXRfaWRfYWE2NHpmcjBfZWwxKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwK
IAlpbnQgZXJyOwogCXU2NCB2YWw7CiAKLQlpZiAoV0FSTl9PTighdmNwdV9oYXNfc3ZlKHZjcHUp
KSkKLQkJcmV0dXJuIC1FTk9FTlQ7Ci0KIAllcnIgPSByZWdfZnJvbV91c2VyKCZ2YWwsIHVhZGRy
LCBpZCk7CiAJaWYgKGVycikKIAkJcmV0dXJuIGVycjsKQEAgLTE1MTgsNyArMTUwMiw3IEBAIHN0
YXRpYyBjb25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjIHN5c19yZWdfZGVzY3NbXSA9IHsKIAlJRF9T
QU5JVElTRUQoSURfQUE2NFBGUjFfRUwxKSwKIAlJRF9VTkFMTE9DQVRFRCg0LDIpLAogCUlEX1VO
QUxMT0NBVEVEKDQsMyksCi0JeyBTWVNfREVTQyhTWVNfSURfQUE2NFpGUjBfRUwxKSwgYWNjZXNz
X2lkX2FhNjR6ZnIwX2VsMSwgLmdldF91c2VyID0gZ2V0X2lkX2FhNjR6ZnIwX2VsMSwgLnNldF91
c2VyID0gc2V0X2lkX2FhNjR6ZnIwX2VsMSwgLnZpc2liaWxpdHkgPSBzdmVfaWRfdmlzaWJpbGl0
eSB9LAorCXsgU1lTX0RFU0MoU1lTX0lEX0FBNjRaRlIwX0VMMSksIGFjY2Vzc19pZF9hYTY0emZy
MF9lbDEsIC5nZXRfdXNlciA9IGdldF9pZF9hYTY0emZyMF9lbDEsIC5zZXRfdXNlciA9IHNldF9p
ZF9hYTY0emZyMF9lbDEsIH0sCiAJSURfVU5BTExPQ0FURUQoNCw1KSwKIAlJRF9VTkFMTE9DQVRF
RCg0LDYpLAogCUlEX1VOQUxMT0NBVEVEKDQsNyksCi0tIAoyLjI2LjIKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
