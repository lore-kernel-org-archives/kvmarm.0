Return-Path: <SRS0=uq+A=EM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B9DC61DD8
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 16:44:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 964FF2222B
	for <kvmarm@archiver.kernel.org>; Fri,  6 Nov 2020 16:44:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="y0Knw6SX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 964FF2222B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CB4F4B8B0;
	Fri,  6 Nov 2020 11:44:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Fai7zmtI+Hyg; Fri,  6 Nov 2020 11:44:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FE744B8B6;
	Fri,  6 Nov 2020 11:44:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C730C4B8A7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 11:44:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DvsEId+R4uWl for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 Nov 2020 11:44:39 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 811264B8A2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 Nov 2020 11:44:39 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8B5F9217A0;
 Fri,  6 Nov 2020 16:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604681078;
 bh=t0K1Uzu+49PExG7zsJdALxOgNu8sv7rz5YDcQXoVCJY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=y0Knw6SXwkuIvEg2uWUQ/PrrwXU0Cup7lBqjLmSlH3uf72/RKpQZ9dOI4ig17Uf4E
 NF9jRnOkkDZgCzsf1c4qRUJIXZQfhuFdoWmvBf85dshrgexy8qMYW6oFU70shSl1hx
 13TGB/J7sIsA7MVpBxI3o7/48OIJ/3RYjg/9oYjs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kb4qq-008FYW-NV; Fri, 06 Nov 2020 16:44:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 2/5] KVM: arm64: Don't hide ID registers from userspace
Date: Fri,  6 Nov 2020 16:44:13 +0000
Message-Id: <20201106164416.326787-3-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201106164416.326787-1-maz@kernel.org>
References: <20201106164416.326787-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, drjones@redhat.com,
 eric.auger@redhat.com, gshan@redhat.com, xu910121@sina.com,
 dave.martin@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvm@vger.kernel.org, stable@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 =?UTF-8?q?=E5=BC=A0=E4=B8=9C=E6=97=AD?= <xu910121@sina.com>,
 linux-arm-kernel@lists.infradead.org, dave.martin@arm.com
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

RnJvbTogQW5kcmV3IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+CgpJRCByZWdpc3RlcnMgYXJl
IFJBWiB1bnRpbCB0aGV5J3ZlIGJlZW4gYWxsb2NhdGVkIGEgcHVycG9zZSwgYnV0CnRoYXQgZG9l
c24ndCBtZWFuIHRoZXkgc2hvdWxkIGJlIHJlbW92ZWQgZnJvbSB0aGUgS1ZNX0dFVF9SRUdfTElT
VApsaXN0LiBTbyBmYXIgd2Ugb25seSBoYXZlIG9uZSByZWdpc3RlciwgU1lTX0lEX0FBNjRaRlIw
X0VMMSwgdGhhdAppcyBoaWRkZW4gZnJvbSB1c2Vyc3BhY2Ugd2hlbiBpdHMgZnVuY3Rpb24sIFNW
RSwgaXMgbm90IHByZXNlbnQuCgpFeHBvc2UgU1lTX0lEX0FBNjRaRlIwX0VMMSB0byB1c2Vyc3Bh
Y2UgYXMgUkFaIHdoZW4gU1ZFIGlzIG5vdAppbXBsZW1lbnRlZC4gUmVtb3ZpbmcgdGhlIHVzZXJz
cGFjZSB2aXNpYmlsaXR5IGNoZWNrcyBpcyBlbm91Z2gKdG8gcmVleHBvc2UgaXQsIGFzIGl0IHdp
bGwgYWxyZWFkeSByZXR1cm4gemVybyB0byB1c2Vyc3BhY2Ugd2hlbgpTVkUgaXMgbm90IHByZXNl
bnQuIFRoZSByZWdpc3RlciBhbHJlYWR5IGJlaGF2ZXMgYXMgUkFaIGZvciB0aGUKZ3Vlc3Qgd2hl
biBTVkUgaXMgbm90IHByZXNlbnQuCgpGaXhlczogNzM0MzM3NjJmY2FlICgiS1ZNOiBhcm02NC9z
dmU6IFN5c3RlbSByZWdpc3RlciBjb250ZXh0IHN3aXRjaCBhbmQgYWNjZXNzIHN1cHBvcnQiKQpS
ZXBvcnRlZC1ieTog5byg5Lic5petIDx4dTkxMDEyMUBzaW5hLmNvbT4KU2lnbmVkLW9mZi1ieTog
QW5kcmV3IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IE1hcmMgWnlu
Z2llciA8bWF6QGtlcm5lbC5vcmc+CkNjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnI3Y1LjIrCkxp
bms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMDExMDUwOTEwMjIuMTUzNzMtMi1kcmpv
bmVzQHJlZGhhdC5jb20KLS0tCiBhcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jIHwgMTggKy0tLS0t
LS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDE3IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3N5c19yZWdzLmMgYi9hcmNoL2FybTY0
L2t2bS9zeXNfcmVncy5jCmluZGV4IDk4Mzk5NGYwMWE2My4uM2FmMzA2ZTZiOWNkIDEwMDY0NAot
LS0gYS9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCisrKyBiL2FyY2gvYXJtNjQva3ZtL3N5c19y
ZWdzLmMKQEAgLTExOTMsMTYgKzExOTMsNiBAQCBzdGF0aWMgdW5zaWduZWQgaW50IHN2ZV92aXNp
YmlsaXR5KGNvbnN0IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKIAlyZXR1cm4gUkVHX0hJRERFTl9V
U0VSIHwgUkVHX0hJRERFTl9HVUVTVDsKIH0KIAotLyogVmlzaWJpbGl0eSBvdmVycmlkZXMgZm9y
IFNWRS1zcGVjaWZpYyBJRCByZWdpc3RlcnMgKi8KLXN0YXRpYyB1bnNpZ25lZCBpbnQgc3ZlX2lk
X3Zpc2liaWxpdHkoY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAotCQkJCSAgICAgIGNvbnN0
IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnJkKQotewotCWlmICh2Y3B1X2hhc19zdmUodmNwdSkpCi0J
CXJldHVybiAwOwotCi0JcmV0dXJuIFJFR19ISURERU5fVVNFUjsKLX0KLQogLyogR2VuZXJhdGUg
dGhlIGVtdWxhdGVkIElEX0FBNjRaRlIwX0VMMSB2YWx1ZSBleHBvc2VkIHRvIHRoZSBndWVzdCAq
Lwogc3RhdGljIHU2NCBndWVzdF9pZF9hYTY0emZyMF9lbDEoY29uc3Qgc3RydWN0IGt2bV92Y3B1
ICp2Y3B1KQogewpAQCAtMTIyOSw5ICsxMjE5LDYgQEAgc3RhdGljIGludCBnZXRfaWRfYWE2NHpm
cjBfZWwxKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwKIHsKIAl1NjQgdmFsOwogCi0JaWYgKFdBUk5f
T04oIXZjcHVfaGFzX3N2ZSh2Y3B1KSkpCi0JCXJldHVybiAtRU5PRU5UOwotCiAJdmFsID0gZ3Vl
c3RfaWRfYWE2NHpmcjBfZWwxKHZjcHUpOwogCXJldHVybiByZWdfdG9fdXNlcih1YWRkciwgJnZh
bCwgcmVnLT5pZCk7CiB9CkBAIC0xMjQ0LDkgKzEyMzEsNiBAQCBzdGF0aWMgaW50IHNldF9pZF9h
YTY0emZyMF9lbDEoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAogCWludCBlcnI7CiAJdTY0IHZhbDsK
IAotCWlmIChXQVJOX09OKCF2Y3B1X2hhc19zdmUodmNwdSkpKQotCQlyZXR1cm4gLUVOT0VOVDsK
LQogCWVyciA9IHJlZ19mcm9tX3VzZXIoJnZhbCwgdWFkZHIsIGlkKTsKIAlpZiAoZXJyKQogCQly
ZXR1cm4gZXJyOwpAQCAtMTUwOSw3ICsxNDkzLDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBzeXNf
cmVnX2Rlc2Mgc3lzX3JlZ19kZXNjc1tdID0gewogCUlEX1NBTklUSVNFRChJRF9BQTY0UEZSMV9F
TDEpLAogCUlEX1VOQUxMT0NBVEVEKDQsMiksCiAJSURfVU5BTExPQ0FURUQoNCwzKSwKLQl7IFNZ
U19ERVNDKFNZU19JRF9BQTY0WkZSMF9FTDEpLCBhY2Nlc3NfaWRfYWE2NHpmcjBfZWwxLCAuZ2V0
X3VzZXIgPSBnZXRfaWRfYWE2NHpmcjBfZWwxLCAuc2V0X3VzZXIgPSBzZXRfaWRfYWE2NHpmcjBf
ZWwxLCAudmlzaWJpbGl0eSA9IHN2ZV9pZF92aXNpYmlsaXR5IH0sCisJeyBTWVNfREVTQyhTWVNf
SURfQUE2NFpGUjBfRUwxKSwgYWNjZXNzX2lkX2FhNjR6ZnIwX2VsMSwgLmdldF91c2VyID0gZ2V0
X2lkX2FhNjR6ZnIwX2VsMSwgLnNldF91c2VyID0gc2V0X2lkX2FhNjR6ZnIwX2VsMSwgfSwKIAlJ
RF9VTkFMTE9DQVRFRCg0LDUpLAogCUlEX1VOQUxMT0NBVEVEKDQsNiksCiAJSURfVU5BTExPQ0FU
RUQoNCw3KSwKLS0gCjIuMjguMAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
