Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0D1C388F7
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 09:10:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 133192080D
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 09:10:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YgPBHp9Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 133192080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DE214B46C;
	Thu,  5 Nov 2020 04:10:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MFN+QyuOlzP7; Thu,  5 Nov 2020 04:10:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 41D104B3A1;
	Thu,  5 Nov 2020 04:10:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABBDE4B376
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 04:10:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v5885Zd9ofdq for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 04:10:31 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C60BE4B368
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 04:10:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604567431;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gBUo5HypwA4PuYQyt1U4d6R+DIGqPE+gmLZ1KTreC+w=;
 b=YgPBHp9Y8nCwCt3l0Ld1Wo259lb0XNaWM2SDVN+sFY9MVhuTVqUhvLVr1PuuS5UwxhUDgO
 HR5mGL9Bi7r67MViXpB/k3Ch319ZFXH+rR9ycHG/4w11dKsjfXGd1LC44aSwKNxyf3UF5n
 6Y5JrXYmqmEiQLk0mQPlRFS7j6/pzm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-8fIEmcnxMFqCLCKXmevYTw-1; Thu, 05 Nov 2020 04:10:29 -0500
X-MC-Unique: 8fIEmcnxMFqCLCKXmevYTw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 387B610866D4;
 Thu,  5 Nov 2020 09:10:28 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.18])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 8A75F60C17;
 Thu,  5 Nov 2020 09:10:26 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 1/4] KVM: arm64: Don't hide ID registers from userspace
Date: Thu,  5 Nov 2020 10:10:19 +0100
Message-Id: <20201105091022.15373-2-drjones@redhat.com>
In-Reply-To: <20201105091022.15373-1-drjones@redhat.com>
References: <20201105091022.15373-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
aXRzIGZ1bmN0aW9uLCBTVkUsIGlzIG5vdCBwcmVzZW50LgoKRXhwb3NlIFNZU19JRF9BQTY0WkZS
MF9FTDEgdG8gdXNlcnNwYWNlIGFzIFJBWiB3aGVuIFNWRSBpcyBub3QKaW1wbGVtZW50ZWQuIFJl
bW92aW5nIHRoZSB1c2Vyc3BhY2UgdmlzaWJpbGl0eSBjaGVja3MgaXMgZW5vdWdoCnRvIHJlZXhw
b3NlIGl0LCBhcyBpdCB3aWxsIGFscmVhZHkgcmV0dXJuIHplcm8gdG8gdXNlcnNwYWNlIHdoZW4K
U1ZFIGlzIG5vdCBwcmVzZW50LiBUaGUgcmVnaXN0ZXIgYWxyZWFkeSBiZWhhdmVzIGFzIFJBWiBm
b3IgdGhlCmd1ZXN0IHdoZW4gU1ZFIGlzIG5vdCBwcmVzZW50LgoKRml4ZXM6IDczNDMzNzYyZmNh
ZSAoIktWTTogYXJtNjQvc3ZlOiBTeXN0ZW0gcmVnaXN0ZXIgY29udGV4dCBzd2l0Y2ggYW5kIGFj
Y2VzcyBzdXBwb3J0IikKQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcjdjUuMisKUmVwb3J0ZWQt
Ynk6IOW8oOS4nOaXrSA8eHU5MTAxMjFAc2luYS5jb20+ClNpZ25lZC1vZmYtYnk6IEFuZHJldyBK
b25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPgotLS0KIGFyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMg
fCAxOCArLS0tLS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MTcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYyBi
L2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKaW5kZXggZmIxMmQzZWY0MjNhLi42ZmYwYzE1NTMx
Y2EgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMKKysrIGIvYXJjaC9hcm02
NC9rdm0vc3lzX3JlZ3MuYwpAQCAtMTE5NSwxNiArMTE5NSw2IEBAIHN0YXRpYyB1bnNpZ25lZCBp
bnQgc3ZlX3Zpc2liaWxpdHkoY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAogCXJldHVybiBS
RUdfSElEREVOX1VTRVIgfCBSRUdfSElEREVOX0dVRVNUOwogfQogCi0vKiBWaXNpYmlsaXR5IG92
ZXJyaWRlcyBmb3IgU1ZFLXNwZWNpZmljIElEIHJlZ2lzdGVycyAqLwotc3RhdGljIHVuc2lnbmVk
IGludCBzdmVfaWRfdmlzaWJpbGl0eShjb25zdCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCi0JCQkJ
ICAgICAgY29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYyAqcmQpCi17Ci0JaWYgKHZjcHVfaGFzX3N2
ZSh2Y3B1KSkKLQkJcmV0dXJuIDA7Ci0KLQlyZXR1cm4gUkVHX0hJRERFTl9VU0VSOwotfQotCiAv
KiBHZW5lcmF0ZSB0aGUgZW11bGF0ZWQgSURfQUE2NFpGUjBfRUwxIHZhbHVlIGV4cG9zZWQgdG8g
dGhlIGd1ZXN0ICovCiBzdGF0aWMgdTY0IGd1ZXN0X2lkX2FhNjR6ZnIwX2VsMShjb25zdCBzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpCiB7CkBAIC0xMjMxLDkgKzEyMjEsNiBAQCBzdGF0aWMgaW50IGdl
dF9pZF9hYTY0emZyMF9lbDEoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAogewogCXU2NCB2YWw7CiAK
LQlpZiAoV0FSTl9PTighdmNwdV9oYXNfc3ZlKHZjcHUpKSkKLQkJcmV0dXJuIC1FTk9FTlQ7Ci0K
IAl2YWwgPSBndWVzdF9pZF9hYTY0emZyMF9lbDEodmNwdSk7CiAJcmV0dXJuIHJlZ190b191c2Vy
KHVhZGRyLCAmdmFsLCByZWctPmlkKTsKIH0KQEAgLTEyNDYsOSArMTIzMyw2IEBAIHN0YXRpYyBp
bnQgc2V0X2lkX2FhNjR6ZnIwX2VsMShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCiAJaW50IGVycjsK
IAl1NjQgdmFsOwogCi0JaWYgKFdBUk5fT04oIXZjcHVfaGFzX3N2ZSh2Y3B1KSkpCi0JCXJldHVy
biAtRU5PRU5UOwotCiAJZXJyID0gcmVnX2Zyb21fdXNlcigmdmFsLCB1YWRkciwgaWQpOwogCWlm
IChlcnIpCiAJCXJldHVybiBlcnI7CkBAIC0xNTE4LDcgKzE1MDIsNyBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IHN5c19yZWdfZGVzYyBzeXNfcmVnX2Rlc2NzW10gPSB7CiAJSURfU0FOSVRJU0VEKElE
X0FBNjRQRlIxX0VMMSksCiAJSURfVU5BTExPQ0FURUQoNCwyKSwKIAlJRF9VTkFMTE9DQVRFRCg0
LDMpLAotCXsgU1lTX0RFU0MoU1lTX0lEX0FBNjRaRlIwX0VMMSksIGFjY2Vzc19pZF9hYTY0emZy
MF9lbDEsIC5nZXRfdXNlciA9IGdldF9pZF9hYTY0emZyMF9lbDEsIC5zZXRfdXNlciA9IHNldF9p
ZF9hYTY0emZyMF9lbDEsIC52aXNpYmlsaXR5ID0gc3ZlX2lkX3Zpc2liaWxpdHkgfSwKKwl7IFNZ
U19ERVNDKFNZU19JRF9BQTY0WkZSMF9FTDEpLCBhY2Nlc3NfaWRfYWE2NHpmcjBfZWwxLCAuZ2V0
X3VzZXIgPSBnZXRfaWRfYWE2NHpmcjBfZWwxLCAuc2V0X3VzZXIgPSBzZXRfaWRfYWE2NHpmcjBf
ZWwxLCB9LAogCUlEX1VOQUxMT0NBVEVEKDQsNSksCiAJSURfVU5BTExPQ0FURUQoNCw2KSwKIAlJ
RF9VTkFMTE9DQVRFRCg0LDcpLAotLSAKMi4yNi4yCgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
