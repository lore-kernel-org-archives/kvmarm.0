Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB23C43219
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4BEB72081C
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4BEB72081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EAD9C4A519;
	Fri,  3 May 2019 08:45:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uyp-5C2ftv4g; Fri,  3 May 2019 08:45:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F5D44A51E;
	Fri,  3 May 2019 08:45:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B25C14A4F7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:45:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ajzbl-nfXP+h for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:45:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FD7F4A4DB
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:45:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEC38374;
 Fri,  3 May 2019 05:45:17 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A77853F220;
 Fri,  3 May 2019 05:45:14 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 10/56] KVM: arm64: Propagate vcpu into read_id_reg()
Date: Fri,  3 May 2019 13:43:41 +0100
Message-Id: <20190503124427.190206-11-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>,
 "zhang . lei" <zhang.lei@jp.fujitsu.com>, Julien Grall <julien.grall@arm.com>,
 kvmarm@lists.cs.columbia.edu, Amit Daniel Kachhap <amit.kachhap@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
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

RnJvbTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+CgpBcmNoaXRlY3R1cmUgZmVh
dHVyZXMgdGhhdCBhcmUgY29uZGl0aW9uYWxseSB2aXNpYmxlIHRvIHRoZSBndWVzdAp3aWxsIHJl
cXVpcmUgcnVuLXRpbWUgY2hlY2tzIGluIHRoZSBJRCByZWdpc3RlciBhY2Nlc3NvciBmdW5jdGlv
bnMuCkluIHBhcnRpY3VsYXIsIHJlYWRfaWRfcmVnKCkgd2lsbCBuZWVkIHRvIHBlcmZvcm0gY2hl
Y2tzIGluIG9yZGVyCnRvIGdlbmVyYXRlIHRoZSBjb3JyZWN0IGVtdWxhdGVkIHZhbHVlIGZvciBj
ZXJ0YWluIElEIHJlZ2lzdGVyCmZpZWxkcyBzdWNoIGFzIElEX0FBNjRQRlIwX0VMMS5TVkUgZm9y
IGV4YW1wbGUuCgpUaGlzIHBhdGNoIHByb3BhZ2F0ZXMgdmNwdSBpbnRvIHJlYWRfaWRfcmVnKCkg
c28gdGhhdCBmdXR1cmUKcGF0Y2hlcyBjYW4gYWRkIHJ1bi10aW1lIGNoZWNrcyBvbiB0aGUgZ3Vl
c3QgY29uZmlndXJhdGlvbiBoZXJlLgoKRm9yIG5vdywgdGhlcmUgaXMgbm8gZnVuY3Rpb25hbCBj
aGFuZ2UuCgpTaWduZWQtb2ZmLWJ5OiBEYXZlIE1hcnRpbiA8RGF2ZS5NYXJ0aW5AYXJtLmNvbT4K
UmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KVGVzdGVk
LWJ5OiB6aGFuZy5sZWkgPHpoYW5nLmxlaUBqcC5mdWppdHN1LmNvbT4KU2lnbmVkLW9mZi1ieTog
TWFyYyBaeW5naWVyIDxtYXJjLnp5bmdpZXJAYXJtLmNvbT4KLS0tCiBhcmNoL2FybTY0L2t2bS9z
eXNfcmVncy5jIHwgMjMgKysrKysrKysrKysrKy0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAx
MyBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0
L2t2bS9zeXNfcmVncy5jIGIvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuYwppbmRleCA1MzlmZWVj
ZGE1YjguLmE1ZDE0YjVlMmVhNCAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vc3lzX3JlZ3Mu
YworKysgYi9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jCkBAIC0xMDQ0LDcgKzEwNDQsOCBAQCBz
dGF0aWMgYm9vbCBhY2Nlc3NfYXJjaF90aW1lcihzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsCiB9CiAK
IC8qIFJlYWQgYSBzYW5pdGlzZWQgY3B1ZmVhdHVyZSBJRCByZWdpc3RlciBieSBzeXNfcmVnX2Rl
c2MgKi8KLXN0YXRpYyB1NjQgcmVhZF9pZF9yZWcoc3RydWN0IHN5c19yZWdfZGVzYyBjb25zdCAq
ciwgYm9vbCByYXopCitzdGF0aWMgdTY0IHJlYWRfaWRfcmVnKGNvbnN0IHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSwKKwkJc3RydWN0IHN5c19yZWdfZGVzYyBjb25zdCAqciwgYm9vbCByYXopCiB7CiAJ
dTMyIGlkID0gc3lzX3JlZygodTMyKXItPk9wMCwgKHUzMilyLT5PcDEsCiAJCQkgKHUzMilyLT5D
Um4sICh1MzIpci0+Q1JtLCAodTMyKXItPk9wMik7CkBAIC0xMDc4LDcgKzEwNzksNyBAQCBzdGF0
aWMgYm9vbCBfX2FjY2Vzc19pZF9yZWcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAogCWlmIChwLT5p
c193cml0ZSkKIAkJcmV0dXJuIHdyaXRlX3RvX3JlYWRfb25seSh2Y3B1LCBwLCByKTsKIAotCXAt
PnJlZ3ZhbCA9IHJlYWRfaWRfcmVnKHIsIHJheik7CisJcC0+cmVndmFsID0gcmVhZF9pZF9yZWco
dmNwdSwgciwgcmF6KTsKIAlyZXR1cm4gdHJ1ZTsKIH0KIApAQCAtMTEwNywxNiArMTEwOCwxOCBA
QCBzdGF0aWMgdTY0IHN5c19yZWdfdG9faW5kZXgoY29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYyAq
cmVnKTsKICAqIGFyZSBzdG9yZWQsIGFuZCBmb3Igc2V0X2lkX3JlZygpIHdlIGRvbid0IGFsbG93
IHRoZSBlZmZlY3RpdmUgdmFsdWUKICAqIHRvIGJlIGNoYW5nZWQuCiAgKi8KLXN0YXRpYyBpbnQg
X19nZXRfaWRfcmVnKGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnJkLCB2b2lkIF9fdXNlciAq
dWFkZHIsCitzdGF0aWMgaW50IF9fZ2V0X2lkX3JlZyhjb25zdCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsCisJCQljb25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjICpyZCwgdm9pZCBfX3VzZXIgKnVhZGRy
LAogCQkJYm9vbCByYXopCiB7CiAJY29uc3QgdTY0IGlkID0gc3lzX3JlZ190b19pbmRleChyZCk7
Ci0JY29uc3QgdTY0IHZhbCA9IHJlYWRfaWRfcmVnKHJkLCByYXopOworCWNvbnN0IHU2NCB2YWwg
PSByZWFkX2lkX3JlZyh2Y3B1LCByZCwgcmF6KTsKIAogCXJldHVybiByZWdfdG9fdXNlcih1YWRk
ciwgJnZhbCwgaWQpOwogfQogCi1zdGF0aWMgaW50IF9fc2V0X2lkX3JlZyhjb25zdCBzdHJ1Y3Qg
c3lzX3JlZ19kZXNjICpyZCwgdm9pZCBfX3VzZXIgKnVhZGRyLAorc3RhdGljIGludCBfX3NldF9p
ZF9yZWcoY29uc3Qgc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAorCQkJY29uc3Qgc3RydWN0IHN5c19y
ZWdfZGVzYyAqcmQsIHZvaWQgX191c2VyICp1YWRkciwKIAkJCWJvb2wgcmF6KQogewogCWNvbnN0
IHU2NCBpZCA9IHN5c19yZWdfdG9faW5kZXgocmQpOwpAQCAtMTEyOCw3ICsxMTMxLDcgQEAgc3Rh
dGljIGludCBfX3NldF9pZF9yZWcoY29uc3Qgc3RydWN0IHN5c19yZWdfZGVzYyAqcmQsIHZvaWQg
X191c2VyICp1YWRkciwKIAkJcmV0dXJuIGVycjsKIAogCS8qIFRoaXMgaXMgd2hhdCB3ZSBtZWFu
IGJ5IGludmFyaWFudDogeW91IGNhbid0IGNoYW5nZSBpdC4gKi8KLQlpZiAodmFsICE9IHJlYWRf
aWRfcmVnKHJkLCByYXopKQorCWlmICh2YWwgIT0gcmVhZF9pZF9yZWcodmNwdSwgcmQsIHJheikp
CiAJCXJldHVybiAtRUlOVkFMOwogCiAJcmV0dXJuIDA7CkBAIC0xMTM3LDI1ICsxMTQwLDI1IEBA
IHN0YXRpYyBpbnQgX19zZXRfaWRfcmVnKGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnJkLCB2
b2lkIF9fdXNlciAqdWFkZHIsCiBzdGF0aWMgaW50IGdldF9pZF9yZWcoc3RydWN0IGt2bV92Y3B1
ICp2Y3B1LCBjb25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjICpyZCwKIAkJICAgICAgY29uc3Qgc3Ry
dWN0IGt2bV9vbmVfcmVnICpyZWcsIHZvaWQgX191c2VyICp1YWRkcikKIHsKLQlyZXR1cm4gX19n
ZXRfaWRfcmVnKHJkLCB1YWRkciwgZmFsc2UpOworCXJldHVybiBfX2dldF9pZF9yZWcodmNwdSwg
cmQsIHVhZGRyLCBmYWxzZSk7CiB9CiAKIHN0YXRpYyBpbnQgc2V0X2lkX3JlZyhzdHJ1Y3Qga3Zt
X3ZjcHUgKnZjcHUsIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnJkLAogCQkgICAgICBjb25z
dCBzdHJ1Y3Qga3ZtX29uZV9yZWcgKnJlZywgdm9pZCBfX3VzZXIgKnVhZGRyKQogewotCXJldHVy
biBfX3NldF9pZF9yZWcocmQsIHVhZGRyLCBmYWxzZSk7CisJcmV0dXJuIF9fc2V0X2lkX3JlZyh2
Y3B1LCByZCwgdWFkZHIsIGZhbHNlKTsKIH0KIAogc3RhdGljIGludCBnZXRfcmF6X2lkX3JlZyhz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGNvbnN0IHN0cnVjdCBzeXNfcmVnX2Rlc2MgKnJkLAogCQkJ
ICBjb25zdCBzdHJ1Y3Qga3ZtX29uZV9yZWcgKnJlZywgdm9pZCBfX3VzZXIgKnVhZGRyKQogewot
CXJldHVybiBfX2dldF9pZF9yZWcocmQsIHVhZGRyLCB0cnVlKTsKKwlyZXR1cm4gX19nZXRfaWRf
cmVnKHZjcHUsIHJkLCB1YWRkciwgdHJ1ZSk7CiB9CiAKIHN0YXRpYyBpbnQgc2V0X3Jhel9pZF9y
ZWcoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBjb25zdCBzdHJ1Y3Qgc3lzX3JlZ19kZXNjICpyZCwK
IAkJCSAgY29uc3Qgc3RydWN0IGt2bV9vbmVfcmVnICpyZWcsIHZvaWQgX191c2VyICp1YWRkcikK
IHsKLQlyZXR1cm4gX19zZXRfaWRfcmVnKHJkLCB1YWRkciwgdHJ1ZSk7CisJcmV0dXJuIF9fc2V0
X2lkX3JlZyh2Y3B1LCByZCwgdWFkZHIsIHRydWUpOwogfQogCiBzdGF0aWMgYm9vbCBhY2Nlc3Nf
Y3RyKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IHN5c19yZWdfcGFyYW1zICpwLAotLSAK
Mi4yMC4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
