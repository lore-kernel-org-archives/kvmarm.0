Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00F6C43219
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:47:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 90D8D2075E
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:47:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90D8D2075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49E954A544;
	Fri,  3 May 2019 08:47:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 02qfgkx4Bs-a; Fri,  3 May 2019 08:47:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 288DF4A57D;
	Fri,  3 May 2019 08:47:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 886794A51A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:47:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X7xcgSQ6vWoL for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:47:07 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29A644A594
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:47:07 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA8DE15AD;
 Fri,  3 May 2019 05:47:06 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 736623F220;
 Fri,  3 May 2019 05:47:03 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 41/56] KVM: Clarify KVM_{SET,
 GET}_ONE_REG error code documentation
Date: Fri,  3 May 2019 13:44:12 +0100
Message-Id: <20190503124427.190206-42-marc.zyngier@arm.com>
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

RnJvbTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+CgpUaGUgY3VycmVudCBlcnJv
ciBjb2RlIGRvY3VtZW50YXRpb24gZm9yIEtWTV9HRVRfT05FX1JFRyBhbmQKS1ZNX1NFVF9PTkVf
UkVHIGNvdWxkIGJlIHJlYWQgYXMgaW1wbHlpbmcgdGhhdCBhbGwgYXJjaGl0ZWN0dXJlcwppbXBs
ZW1lbnQgdGhlc2UgZXJyb3IgY29kZXMsIG9yIHRoYXQgS1ZNIGd1YXJhbnRlZXMgd2hpY2ggZXJy
b3IKY29kZSBpcyByZXR1cm5lZCBpbiBhIHBhcnRpY3VsYXIgc2l0dWF0aW9uLgoKQmVjYXVzZSB0
aGlzIGlzIG5vdCByZWFsbHkgdGhlIGNhc2UsIHRoaXMgcGF0Y2ggd2F0ZXJzIGRvd24gdGhlCmRv
Y3VtZW50YXRpb24gZXhwbGljaXRseSB0byByZW1vdmUgc3VjaCBndWFyYW50ZWVzLgoKRVBFUk0g
aXMgbWFya2VkIGFzIGFybTY0LXNwZWNpZmljLCBzaW5jZSBmb3Igbm93IGFybTY0IHJlYWxseSBp
cwp0aGUgb25seSBhcmNoaXRlY3R1cmUgdGhhdCB5aWVsZHMgdGhpcyBlcnJvciBjb2RlIGZvciB0
aGUKZmluYWxpemF0aW9uLXJlcXVpcmVkIGNhc2UuICBLZWVwaW5nIHRoaXMgYXMgYSBkaXN0aW5j
dCBlcnJvciBjb2RlCmlzIHVzZWZ1bCBob3dldmVyIGZvciBkZWJ1Z2dpbmcgZHVlIHRvIHRoZSBz
dGF0ZWZ1bG5lc3Mgb2YgdGhlIEFQSQppbiB0aGlzIGluc3RhbmNlLgoKTm8gZnVuY3Rpb25hbCBj
aGFuZ2UuCgpTdWdnZXN0ZWQtYnk6IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPgpG
aXhlczogMzk1ZjU2MmYyYjRjICgiS1ZNOiBEb2N1bWVudCBlcnJvcnMgZm9yIEtWTV9HRVRfT05F
X1JFRyBhbmQgS1ZNX1NFVF9PTkVfUkVHIikKRml4ZXM6IDUwMDM2YWQwNmI3ZiAoIktWTTogYXJt
NjQvc3ZlOiBEb2N1bWVudCBLVk0gQVBJIGV4dGVuc2lvbnMgZm9yIFNWRSIpClNpZ25lZC1vZmYt
Ynk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgpSZXZpZXdlZC1ieTogQW5kcmV3
IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+ClNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8
bWFyYy56eW5naWVyQGFybS5jb20+Ci0tLQogRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9hcGku
dHh0IHwgMTQgKysrKysrKysrLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyks
IDUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9h
cGkudHh0IGIvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9hcGkudHh0CmluZGV4IDU1MTlkZjBk
M2VkMC4uODE4YWM5N2ZkYWJjIDEwMDY0NAotLS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnR1YWwva3Zt
L2FwaS50eHQKKysrIGIvRG9jdW1lbnRhdGlvbi92aXJ0dWFsL2t2bS9hcGkudHh0CkBAIC0xODcz
LDggKzE4NzMsMTAgQEAgUGFyYW1ldGVyczogc3RydWN0IGt2bV9vbmVfcmVnIChpbikKIFJldHVy
bnM6IDAgb24gc3VjY2VzcywgbmVnYXRpdmUgdmFsdWUgb24gZmFpbHVyZQogRXJyb3JzOgogIMKg
RU5PRU5UOiDCoMKgbm8gc3VjaCByZWdpc3RlcgotIMKgRVBFUk06IMKgwqDCoHJlZ2lzdGVyIGFj
Y2VzcyBmb3JiaWRkZW4gZm9yIGFyY2hpdGVjdHVyZS1kZXBlbmRlbnQgcmVhc29ucwotIMKgRUlO
VkFMOiDCoMKgb3RoZXIgZXJyb3JzLCBzdWNoIGFzIGJhZCBzaXplIGVuY29kaW5nIGZvciBhIGtu
b3duIHJlZ2lzdGVyCisgwqBFSU5WQUw6IMKgwqBpbnZhbGlkIHJlZ2lzdGVyIElELCBvciBubyBz
dWNoIHJlZ2lzdGVyCisgwqBFUEVSTTogwqDCoMKgKGFybTY0KSByZWdpc3RlciBhY2Nlc3Mgbm90
IGFsbG93ZWQgYmVmb3JlIHZjcHUgZmluYWxpemF0aW9uCisoVGhlc2UgZXJyb3IgY29kZXMgYXJl
IGluZGljYXRpdmUgb25seTogZG8gbm90IHJlbHkgb24gYSBzcGVjaWZpYyBlcnJvcgorY29kZSBi
ZWluZyByZXR1cm5lZCBpbiBhIHNwZWNpZmljIHNpdHVhdGlvbi4pCiAKIHN0cnVjdCBrdm1fb25l
X3JlZyB7CiAgICAgICAgX191NjQgaWQ7CkBAIC0yMjYwLDEwICsyMjYyLDEyIEBAIEFyY2hpdGVj
dHVyZXM6IGFsbAogVHlwZTogdmNwdSBpb2N0bAogUGFyYW1ldGVyczogc3RydWN0IGt2bV9vbmVf
cmVnIChpbiBhbmQgb3V0KQogUmV0dXJuczogMCBvbiBzdWNjZXNzLCBuZWdhdGl2ZSB2YWx1ZSBv
biBmYWlsdXJlCi1FcnJvcnM6CitFcnJvcnMgaW5jbHVkZToKICDCoEVOT0VOVDogwqDCoG5vIHN1
Y2ggcmVnaXN0ZXIKLSDCoEVQRVJNOiDCoMKgwqByZWdpc3RlciBhY2Nlc3MgZm9yYmlkZGVuIGZv
ciBhcmNoaXRlY3R1cmUtZGVwZW5kZW50IHJlYXNvbnMKLSDCoEVJTlZBTDogwqDCoG90aGVyIGVy
cm9ycywgc3VjaCBhcyBiYWQgc2l6ZSBlbmNvZGluZyBmb3IgYSBrbm93biByZWdpc3RlcgorIMKg
RUlOVkFMOiDCoMKgaW52YWxpZCByZWdpc3RlciBJRCwgb3Igbm8gc3VjaCByZWdpc3RlcgorIMKg
RVBFUk06IMKgwqDCoChhcm02NCkgcmVnaXN0ZXIgYWNjZXNzIG5vdCBhbGxvd2VkIGJlZm9yZSB2
Y3B1IGZpbmFsaXphdGlvbgorKFRoZXNlIGVycm9yIGNvZGVzIGFyZSBpbmRpY2F0aXZlIG9ubHk6
IGRvIG5vdCByZWx5IG9uIGEgc3BlY2lmaWMgZXJyb3IKK2NvZGUgYmVpbmcgcmV0dXJuZWQgaW4g
YSBzcGVjaWZpYyBzaXR1YXRpb24uKQogCiBUaGlzIGlvY3RsIGFsbG93cyB0byByZWNlaXZlIHRo
ZSB2YWx1ZSBvZiBhIHNpbmdsZSByZWdpc3RlciBpbXBsZW1lbnRlZAogaW4gYSB2Y3B1LiBUaGUg
cmVnaXN0ZXIgdG8gcmVhZCBpcyBpbmRpY2F0ZWQgYnkgdGhlICJpZCIgZmllbGQgb2YgdGhlCi0t
IAoyLjIwLjEKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
