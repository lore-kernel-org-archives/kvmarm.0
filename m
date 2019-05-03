Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47797C004C9
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 097492081C
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:45:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 097492081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9073E4A51D;
	Fri,  3 May 2019 08:45:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3pMbQ5Eb58dX; Fri,  3 May 2019 08:45:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A7B34A4F8;
	Fri,  3 May 2019 08:45:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D91FD4A50F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:45:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tsOarqACQYyA for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:45:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D31E4A519
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:45:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD82D1682;
 Fri,  3 May 2019 05:45:10 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A3EEF3F220;
 Fri,  3 May 2019 05:45:07 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 08/56] arm64/sve: Enable SVE state tracking for non-task
 contexts
Date: Fri,  3 May 2019 13:43:39 +0100
Message-Id: <20190503124427.190206-9-marc.zyngier@arm.com>
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

RnJvbTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+CgpUaGUgY3VycmVudCBGUFNJ
TUQvU1ZFIGNvbnRleHQgaGFuZGxpbmcgc3VwcG9ydCBmb3Igbm9uLXRhc2sgKGkuZS4sCktWTSB2
Y3B1KSBjb250ZXh0cyBkb2VzIG5vdCB0YWtlIFNWRSBpbnRvIGFjY291bnQuICBUaGlzIG1lYW5z
IHRoYXQKb25seSB0YXNrIGNvbnRleHRzIGNhbiBzYWZlbHkgdXNlIFNWRSBhdCBwcmVzZW50LgoK
SW4gcHJlcGFyYXRpb24gZm9yIGVuYWJsaW5nIEtWTSBndWVzdHMgdG8gdXNlIFNWRSwgaXQgaXMg
bmVjZXNzYXJ5CnRvIGtlZXAgdHJhY2sgb2YgU1ZFIHN0YXRlIGZvciBub24tdGFzayBjb250ZXh0
cyB0b28uCgpUaGlzIHBhdGNoIGFkZHMgdGhlIG5lY2Vzc2FyeSBzdXBwb3J0LCByZW1vdmluZyBh
c3N1bXB0aW9ucyBmcm9tCnRoZSBjb250ZXh0IHN3aXRjaCBjb2RlIGFib3V0IHRoZSBsb2NhdGlv
biBvZiB0aGUgU1ZFIGNvbnRleHQKc3RvcmFnZS4KCldoZW4gYmluZGluZyBhIHZjcHUgY29udGV4
dCwgaXRzIHZlY3RvciBsZW5ndGggaXMgYXJiaXRyYXJpbHkKc3BlY2lmaWVkIGFzIFNWRV9WTF9N
SU4gZm9yIG5vdy4gIEluIGFueSBjYXNlLCBiZWNhdXNlIFRJRl9TVkUgaXMKcHJlc2VudGx5IGNs
ZWFyZWQgYXQgdmNwdSBjb250ZXh0IGJpbmQgdGltZSwgdGhlIHNwZWNpZmllZCB2ZWN0b3IKbGVu
Z3RoIHdpbGwgbm90IGJlIHVzZWQgZm9yIGFueXRoaW5nIHlldC4gIEluIGxhdGVyIHBhdGNoZXMg
VElGX1NWRQp3aWxsIGJlIHNldCBoZXJlIGFzIGFwcHJvcHJpYXRlLCBhbmQgdGhlIGFwcHJvcHJp
YXRlIG1heGltdW0gdmVjdG9yCmxlbmd0aCBmb3IgdGhlIHZjcHUgd2lsbCBiZSBwYXNzZWQgd2hl
biBiaW5kaW5nLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5j
b20+ClJldmlld2VkLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+ClJl
dmlld2VkLWJ5OiBKdWxpZW4gR3JhbGwgPGp1bGllbi5ncmFsbEBhcm0uY29tPgpUZXN0ZWQtYnk6
IHpoYW5nLmxlaSA8emhhbmcubGVpQGpwLmZ1aml0c3UuY29tPgpTaWduZWQtb2ZmLWJ5OiBNYXJj
IFp5bmdpZXIgPG1hcmMuenluZ2llckBhcm0uY29tPgotLS0KIGFyY2gvYXJtNjQvaW5jbHVkZS9h
c20vZnBzaW1kLmggfCAgMyArKy0KIGFyY2gvYXJtNjQva2VybmVsL2Zwc2ltZC5jICAgICAgfCAy
MCArKysrKysrKysrKysrKystLS0tLQogYXJjaC9hcm02NC9rdm0vZnBzaW1kLmMgICAgICAgICB8
ICA1ICsrKystCiAzIGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9mcHNpbWQuaCBiL2FyY2gv
YXJtNjQvaW5jbHVkZS9hc20vZnBzaW1kLmgKaW5kZXggOTY0YWRjOWYzMTJkLi5kZjdhMTQzMDUy
MjIgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vZnBzaW1kLmgKKysrIGIvYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9mcHNpbWQuaApAQCAtNTYsNyArNTYsOCBAQCBleHRlcm4gdm9p
ZCBmcHNpbWRfcmVzdG9yZV9jdXJyZW50X3N0YXRlKHZvaWQpOwogZXh0ZXJuIHZvaWQgZnBzaW1k
X3VwZGF0ZV9jdXJyZW50X3N0YXRlKHN0cnVjdCB1c2VyX2Zwc2ltZF9zdGF0ZSBjb25zdCAqc3Rh
dGUpOwogCiBleHRlcm4gdm9pZCBmcHNpbWRfYmluZF90YXNrX3RvX2NwdSh2b2lkKTsKLWV4dGVy
biB2b2lkIGZwc2ltZF9iaW5kX3N0YXRlX3RvX2NwdShzdHJ1Y3QgdXNlcl9mcHNpbWRfc3RhdGUg
KnN0YXRlKTsKK2V4dGVybiB2b2lkIGZwc2ltZF9iaW5kX3N0YXRlX3RvX2NwdShzdHJ1Y3QgdXNl
cl9mcHNpbWRfc3RhdGUgKnN0YXRlLAorCQkJCSAgICAgdm9pZCAqc3ZlX3N0YXRlLCB1bnNpZ25l
ZCBpbnQgc3ZlX3ZsKTsKIAogZXh0ZXJuIHZvaWQgZnBzaW1kX2ZsdXNoX3Rhc2tfc3RhdGUoc3Ry
dWN0IHRhc2tfc3RydWN0ICp0YXJnZXQpOwogZXh0ZXJuIHZvaWQgZnBzaW1kX2ZsdXNoX2NwdV9z
dGF0ZSh2b2lkKTsKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva2VybmVsL2Zwc2ltZC5jIGIvYXJj
aC9hcm02NC9rZXJuZWwvZnBzaW1kLmMKaW5kZXggYjIxOTc5NmE0MDgxLi44YTkzYWZhNzg2MDAg
MTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva2VybmVsL2Zwc2ltZC5jCisrKyBiL2FyY2gvYXJtNjQv
a2VybmVsL2Zwc2ltZC5jCkBAIC0xMjEsNiArMTIxLDggQEAKICAqLwogc3RydWN0IGZwc2ltZF9s
YXN0X3N0YXRlX3N0cnVjdCB7CiAJc3RydWN0IHVzZXJfZnBzaW1kX3N0YXRlICpzdDsKKwl2b2lk
ICpzdmVfc3RhdGU7CisJdW5zaWduZWQgaW50IHN2ZV92bDsKIH07CiAKIHN0YXRpYyBERUZJTkVf
UEVSX0NQVShzdHJ1Y3QgZnBzaW1kX2xhc3Rfc3RhdGVfc3RydWN0LCBmcHNpbWRfbGFzdF9zdGF0
ZSk7CkBAIC0yNDEsMTQgKzI0MywxNSBAQCBzdGF0aWMgdm9pZCB0YXNrX2Zwc2ltZF9sb2FkKHZv
aWQpCiAgKi8KIHZvaWQgZnBzaW1kX3NhdmUodm9pZCkKIHsKLQlzdHJ1Y3QgdXNlcl9mcHNpbWRf
c3RhdGUgKnN0ID0gX190aGlzX2NwdV9yZWFkKGZwc2ltZF9sYXN0X3N0YXRlLnN0KTsKKwlzdHJ1
Y3QgZnBzaW1kX2xhc3Rfc3RhdGVfc3RydWN0IGNvbnN0ICpsYXN0ID0KKwkJdGhpc19jcHVfcHRy
KCZmcHNpbWRfbGFzdF9zdGF0ZSk7CiAJLyogc2V0IGJ5IGZwc2ltZF9iaW5kX3Rhc2tfdG9fY3B1
KCkgb3IgZnBzaW1kX2JpbmRfc3RhdGVfdG9fY3B1KCkgKi8KIAogCVdBUk5fT04oIWluX3NvZnRp
cnEoKSAmJiAhaXJxc19kaXNhYmxlZCgpKTsKIAogCWlmICghdGVzdF90aHJlYWRfZmxhZyhUSUZf
Rk9SRUlHTl9GUFNUQVRFKSkgewogCQlpZiAoc3lzdGVtX3N1cHBvcnRzX3N2ZSgpICYmIHRlc3Rf
dGhyZWFkX2ZsYWcoVElGX1NWRSkpIHsKLQkJCWlmIChXQVJOX09OKHN2ZV9nZXRfdmwoKSAhPSBj
dXJyZW50LT50aHJlYWQuc3ZlX3ZsKSkgeworCQkJaWYgKFdBUk5fT04oc3ZlX2dldF92bCgpICE9
IGxhc3QtPnN2ZV92bCkpIHsKIAkJCQkvKgogCQkJCSAqIENhbid0IHNhdmUgdGhlIHVzZXIgcmVn
cywgc28gY3VycmVudCB3b3VsZAogCQkJCSAqIHJlLWVudGVyIHVzZXIgd2l0aCBjb3JydXB0IHN0
YXRlLgpAQCAtMjU4LDkgKzI2MSwxMSBAQCB2b2lkIGZwc2ltZF9zYXZlKHZvaWQpCiAJCQkJcmV0
dXJuOwogCQkJfQogCi0JCQlzdmVfc2F2ZV9zdGF0ZShzdmVfcGZmcigmY3VycmVudC0+dGhyZWFk
KSwgJnN0LT5mcHNyKTsKKwkJCXN2ZV9zYXZlX3N0YXRlKChjaGFyICopbGFzdC0+c3ZlX3N0YXRl
ICsKKwkJCQkJCXN2ZV9mZnJfb2Zmc2V0KGxhc3QtPnN2ZV92bCksCisJCQkJICAgICAgICZsYXN0
LT5zdC0+ZnBzcik7CiAJCX0gZWxzZQotCQkJZnBzaW1kX3NhdmVfc3RhdGUoc3QpOworCQkJZnBz
aW1kX3NhdmVfc3RhdGUobGFzdC0+c3QpOwogCX0KIH0KIApAQCAtMTAzNCw2ICsxMDM5LDggQEAg
dm9pZCBmcHNpbWRfYmluZF90YXNrX3RvX2NwdSh2b2lkKQogCQl0aGlzX2NwdV9wdHIoJmZwc2lt
ZF9sYXN0X3N0YXRlKTsKIAogCWxhc3QtPnN0ID0gJmN1cnJlbnQtPnRocmVhZC51dy5mcHNpbWRf
c3RhdGU7CisJbGFzdC0+c3ZlX3N0YXRlID0gY3VycmVudC0+dGhyZWFkLnN2ZV9zdGF0ZTsKKwls
YXN0LT5zdmVfdmwgPSBjdXJyZW50LT50aHJlYWQuc3ZlX3ZsOwogCWN1cnJlbnQtPnRocmVhZC5m
cHNpbWRfY3B1ID0gc21wX3Byb2Nlc3Nvcl9pZCgpOwogCiAJaWYgKHN5c3RlbV9zdXBwb3J0c19z
dmUoKSkgewpAQCAtMTA0Nyw3ICsxMDU0LDggQEAgdm9pZCBmcHNpbWRfYmluZF90YXNrX3RvX2Nw
dSh2b2lkKQogCX0KIH0KIAotdm9pZCBmcHNpbWRfYmluZF9zdGF0ZV90b19jcHUoc3RydWN0IHVz
ZXJfZnBzaW1kX3N0YXRlICpzdCkKK3ZvaWQgZnBzaW1kX2JpbmRfc3RhdGVfdG9fY3B1KHN0cnVj
dCB1c2VyX2Zwc2ltZF9zdGF0ZSAqc3QsIHZvaWQgKnN2ZV9zdGF0ZSwKKwkJCSAgICAgIHVuc2ln
bmVkIGludCBzdmVfdmwpCiB7CiAJc3RydWN0IGZwc2ltZF9sYXN0X3N0YXRlX3N0cnVjdCAqbGFz
dCA9CiAJCXRoaXNfY3B1X3B0cigmZnBzaW1kX2xhc3Rfc3RhdGUpOwpAQCAtMTA1NSw2ICsxMDYz
LDggQEAgdm9pZCBmcHNpbWRfYmluZF9zdGF0ZV90b19jcHUoc3RydWN0IHVzZXJfZnBzaW1kX3N0
YXRlICpzdCkKIAlXQVJOX09OKCFpbl9zb2Z0aXJxKCkgJiYgIWlycXNfZGlzYWJsZWQoKSk7CiAK
IAlsYXN0LT5zdCA9IHN0OworCWxhc3QtPnN2ZV9zdGF0ZSA9IHN2ZV9zdGF0ZTsKKwlsYXN0LT5z
dmVfdmwgPSBzdmVfdmw7CiB9CiAKIC8qCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9mcHNp
bWQuYyBiL2FyY2gvYXJtNjQva3ZtL2Zwc2ltZC5jCmluZGV4IGFhYzc4MDhjZTIxNi4uMWNmNGYw
MjY5NDcxIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2t2bS9mcHNpbWQuYworKysgYi9hcmNoL2Fy
bTY0L2t2bS9mcHNpbWQuYwpAQCAtOSw2ICs5LDcgQEAKICNpbmNsdWRlIDxsaW51eC9zY2hlZC5o
PgogI2luY2x1ZGUgPGxpbnV4L3RocmVhZF9pbmZvLmg+CiAjaW5jbHVkZSA8bGludXgva3ZtX2hv
c3QuaD4KKyNpbmNsdWRlIDxhc20vZnBzaW1kLmg+CiAjaW5jbHVkZSA8YXNtL2t2bV9hc20uaD4K
ICNpbmNsdWRlIDxhc20va3ZtX2hvc3QuaD4KICNpbmNsdWRlIDxhc20va3ZtX21tdS5oPgpAQCAt
ODUsNyArODYsOSBAQCB2b2lkIGt2bV9hcmNoX3ZjcHVfY3R4c3luY19mcChzdHJ1Y3Qga3ZtX3Zj
cHUgKnZjcHUpCiAJV0FSTl9PTl9PTkNFKCFpcnFzX2Rpc2FibGVkKCkpOwogCiAJaWYgKHZjcHUt
PmFyY2guZmxhZ3MgJiBLVk1fQVJNNjRfRlBfRU5BQkxFRCkgewotCQlmcHNpbWRfYmluZF9zdGF0
ZV90b19jcHUoJnZjcHUtPmFyY2guY3R4dC5ncF9yZWdzLmZwX3JlZ3MpOworCQlmcHNpbWRfYmlu
ZF9zdGF0ZV90b19jcHUoJnZjcHUtPmFyY2guY3R4dC5ncF9yZWdzLmZwX3JlZ3MsCisJCQkJCSBO
VUxMLCBTVkVfVkxfTUlOKTsKKwogCQljbGVhcl90aHJlYWRfZmxhZyhUSUZfRk9SRUlHTl9GUFNU
QVRFKTsKIAkJY2xlYXJfdGhyZWFkX2ZsYWcoVElGX1NWRSk7CiAJfQotLSAKMi4yMC4xCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
