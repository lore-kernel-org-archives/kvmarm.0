Return-Path: <SRS0=WQmE=TD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37144C43219
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:44:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE9892075E
	for <kvmarm@archiver.kernel.org>; Fri,  3 May 2019 12:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE9892075E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96AFC4A4BD;
	Fri,  3 May 2019 08:44:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id f-+hAwilQ5W7; Fri,  3 May 2019 08:44:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A0944A501;
	Fri,  3 May 2019 08:44:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 157F44A4C5
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:44:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7iYaEI8x5IEI for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 May 2019 08:44:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 529DF4A50C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 May 2019 08:44:50 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC1D0374;
 Fri,  3 May 2019 05:44:49 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95A253F220;
 Fri,  3 May 2019 05:44:46 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 02/56] arm64: fpsimd: Always set TIF_FOREIGN_FPSTATE on task
 state flush
Date: Fri,  3 May 2019 13:43:33 +0100
Message-Id: <20190503124427.190206-3-marc.zyngier@arm.com>
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

RnJvbTogRGF2ZSBNYXJ0aW4gPERhdmUuTWFydGluQGFybS5jb20+CgpUaGlzIHBhdGNoIHVwZGF0
ZXMgZnBzaW1kX2ZsdXNoX3Rhc2tfc3RhdGUoKSB0byBtaXJyb3IgdGhlIG5ldwpzZW1hbnRpY3Mg
b2YgZnBzaW1kX2ZsdXNoX2NwdV9zdGF0ZSgpIGludHJvZHVjZWQgYnkgY29tbWl0CmQ4YWQ3MWZh
MzhhOSAoImFybTY0OiBmcHNpbWQ6IEZpeCBUSUZfRk9SRUlHTl9GUFNUQVRFIGFmdGVyCmludmFs
aWRhdGluZyBjcHUgcmVncyIpLiAgQm90aCBmdW5jdGlvbnMgbm93IGltcGxpY2l0bHkgc2V0ClRJ
Rl9GT1JFSUdOX0ZQU1RBVEUgdG8gaW5kaWNhdGUgdGhhdCB0aGUgdGFzaydzIEZQU0lNRCBzdGF0
ZSBpcyBub3QKbG9hZGVkIGludG8gdGhlIGNwdS4KCkFzIGEgc2lkZS1lZmZlY3QsIGZwc2ltZF9m
bHVzaF90YXNrX3N0YXRlKCkgbm93IHNldHMKVElGX0ZPUkVJR05fRlBTVEFURSBldmVuIGZvciBu
b24tcnVubmluZyB0YXNrcy4gIEluIHRoZSBjYXNlIG9mCm5vbi1ydW5uaW5nIHRhc2tzIHRoaXMg
aXMgbm90IHVzZWZ1bCBidXQgYWxzbyBoYXJtbGVzcywgYmVjYXVzZSB0aGUKZmxhZyBpcyBsaXZl
IG9ubHkgd2hpbGUgdGhlIGNvcnJlc3BvbmRpbmcgdGFzayBpcyBydW5uaW5nLiAgVGhpcwpmdW5j
dGlvbiBpcyBub3QgY2FsbGVkIGZyb20gZmFzdCBwYXRocywgc28gc3BlY2lhbC1jYXNpbmcgdGhp
cyBmb3IKdGhlIHRhc2sgPT0gY3VycmVudCBjYXNlIGlzIG5vdCByZWFsbHkgd29ydGggaXQuCgpD
b21waWxlciBiYXJyaWVycyBwcmV2aW91c2x5IHByZXNlbnQgaW4gcmVzdG9yZV9zdmVfZnBzaW1k
X2NvbnRleHQoKQphcmUgcHVsbGVkIGludG8gZnBzaW1kX2ZsdXNoX3Rhc2tfc3RhdGUoKSBzbyB0
aGF0IGl0IGNhbiBiZSBzYWZlbHkKY2FsbGVkIHdpdGggcHJlZW1wdGlvbiBlbmFibGVkIGlmIG5l
Y2Vzc2FyeS4KCkV4cGxpY2l0IGNhbGxzIHRvIHNldCBUSUZfRk9SRUlHTl9GUFNUQVRFIHRoYXQg
YWNjb21wYW55CmZwc2ltZF9mbHVzaF90YXNrX3N0YXRlKCkgY2FsbHMgYW5kIGFyZSBub3cgcmVk
dW5kYW50IGFyZSByZW1vdmVkCmFzIGFwcHJvcHJpYXRlLgoKZnBzaW1kX2ZsdXNoX3Rhc2tfc3Rh
dGUoKSBpcyB1c2VkIHRvIGdldCBleGNsdXNpdmUgYWNjZXNzIHRvIHRoZQpyZXByZXNlbnRhdGlv
biBvZiB0aGUgdGFzaydzIHN0YXRlIHZpYSB0YXNrX3N0cnVjdCwgZm9yIHRoZSBwdXJwb3NlCm9m
IHJlcGxhY2luZyB0aGUgc3RhdGUuICBUaHVzLCB0aGUgY2FsbCB0byB0aGlzIGZ1bmN0aW9uIHNo
b3VsZApoYXBwZW4gYmVmb3JlIG1hbmlwdWxhdGluZyBmcHNpbWRfc3RhdGUgb3Igc3ZlX3N0YXRl
IGV0Yy4gaW4KdGFza19zdHJ1Y3QuICBBbm9tYWxvdXMgY2FzZXMgYXJlIHJlb3JkZXJlZCBhcHBy
b3ByaWF0ZWx5IGluIG9yZGVyCnRvIG1ha2UgdGhlIGNvZGUgbW9yZSBjb25zaXN0ZW50LCBhbHRo
b3VnaCB0aGVyZSBzaG91bGQgYmUgbm8KZnVuY3Rpb25hbCBkaWZmZXJlbmNlIHNpbmNlIHRoZXNl
IGNhc2VzIGFyZSBwcm90ZWN0ZWQgYnkKbG9jYWxfYmhfZGlzYWJsZSgpIGFueXdheS4KClNpZ25l
ZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPgpSZXZpZXdlZC1ieTog
QWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgpSZXZpZXdlZC1ieTogSnVsaWVu
IEdyYWxsIDxqdWxpZW4uZ3JhbGxAYXJtLmNvbT4KVGVzdGVkLWJ5OiB6aGFuZy5sZWkgPHpoYW5n
LmxlaUBqcC5mdWppdHN1LmNvbT4KU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXJjLnp5
bmdpZXJAYXJtLmNvbT4KLS0tCiBhcmNoL2FybTY0L2tlcm5lbC9mcHNpbWQuYyB8IDI1ICsrKysr
KysrKysrKysrKysrKystLS0tLS0KIGFyY2gvYXJtNjQva2VybmVsL3NpZ25hbC5jIHwgIDUgLS0t
LS0KIDIgZmlsZXMgY2hhbmdlZCwgMTkgaW5zZXJ0aW9ucygrKSwgMTEgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rZXJuZWwvZnBzaW1kLmMgYi9hcmNoL2FybTY0L2tlcm5l
bC9mcHNpbWQuYwppbmRleCA1ZWJlNzNiNjk5NjEuLjYyYzM3ZjBhYzk0NiAxMDA2NDQKLS0tIGEv
YXJjaC9hcm02NC9rZXJuZWwvZnBzaW1kLmMKKysrIGIvYXJjaC9hcm02NC9rZXJuZWwvZnBzaW1k
LmMKQEAgLTU1MCw3ICs1NTAsNiBAQCBpbnQgc3ZlX3NldF92ZWN0b3JfbGVuZ3RoKHN0cnVjdCB0
YXNrX3N0cnVjdCAqdGFzaywKIAkJbG9jYWxfYmhfZGlzYWJsZSgpOwogCiAJCWZwc2ltZF9zYXZl
KCk7Ci0JCXNldF90aHJlYWRfZmxhZyhUSUZfRk9SRUlHTl9GUFNUQVRFKTsKIAl9CiAKIAlmcHNp
bWRfZmx1c2hfdGFza19zdGF0ZSh0YXNrKTsKQEAgLTgxNiwxMiArODE1LDExIEBAIGFzbWxpbmth
Z2Ugdm9pZCBkb19zdmVfYWNjKHVuc2lnbmVkIGludCBlc3IsIHN0cnVjdCBwdF9yZWdzICpyZWdz
KQogCWxvY2FsX2JoX2Rpc2FibGUoKTsKIAogCWZwc2ltZF9zYXZlKCk7Ci0JZnBzaW1kX3RvX3N2
ZShjdXJyZW50KTsKIAogCS8qIEZvcmNlIHJldF90b191c2VyIHRvIHJlbG9hZCB0aGUgcmVnaXN0
ZXJzOiAqLwogCWZwc2ltZF9mbHVzaF90YXNrX3N0YXRlKGN1cnJlbnQpOwotCXNldF90aHJlYWRf
ZmxhZyhUSUZfRk9SRUlHTl9GUFNUQVRFKTsKIAorCWZwc2ltZF90b19zdmUoY3VycmVudCk7CiAJ
aWYgKHRlc3RfYW5kX3NldF90aHJlYWRfZmxhZyhUSUZfU1ZFKSkKIAkJV0FSTl9PTigxKTsgLyog
U1ZFIGFjY2VzcyBzaG91bGRuJ3QgaGF2ZSB0cmFwcGVkICovCiAKQEAgLTg5NCw5ICs4OTIsOSBA
QCB2b2lkIGZwc2ltZF9mbHVzaF90aHJlYWQodm9pZCkKIAogCWxvY2FsX2JoX2Rpc2FibGUoKTsK
IAorCWZwc2ltZF9mbHVzaF90YXNrX3N0YXRlKGN1cnJlbnQpOwogCW1lbXNldCgmY3VycmVudC0+
dGhyZWFkLnV3LmZwc2ltZF9zdGF0ZSwgMCwKIAkgICAgICAgc2l6ZW9mKGN1cnJlbnQtPnRocmVh
ZC51dy5mcHNpbWRfc3RhdGUpKTsKLQlmcHNpbWRfZmx1c2hfdGFza19zdGF0ZShjdXJyZW50KTsK
IAogCWlmIChzeXN0ZW1fc3VwcG9ydHNfc3ZlKCkpIHsKIAkJY2xlYXJfdGhyZWFkX2ZsYWcoVElG
X1NWRSk7CkBAIC05MzMsOCArOTMxLDYgQEAgdm9pZCBmcHNpbWRfZmx1c2hfdGhyZWFkKHZvaWQp
CiAJCQljdXJyZW50LT50aHJlYWQuc3ZlX3ZsX29uZXhlYyA9IDA7CiAJfQogCi0Jc2V0X3RocmVh
ZF9mbGFnKFRJRl9GT1JFSUdOX0ZQU1RBVEUpOwotCiAJbG9jYWxfYmhfZW5hYmxlKCk7CiB9CiAK
QEAgLTEwNDMsMTIgKzEwMzksMjkgQEAgdm9pZCBmcHNpbWRfdXBkYXRlX2N1cnJlbnRfc3RhdGUo
c3RydWN0IHVzZXJfZnBzaW1kX3N0YXRlIGNvbnN0ICpzdGF0ZSkKIAogLyoKICAqIEludmFsaWRh
dGUgbGl2ZSBDUFUgY29waWVzIG9mIHRhc2sgdCdzIEZQU0lNRCBzdGF0ZQorICoKKyAqIFRoaXMg
ZnVuY3Rpb24gbWF5IGJlIGNhbGxlZCB3aXRoIHByZWVtcHRpb24gZW5hYmxlZC4gIFRoZSBiYXJy
aWVyKCkKKyAqIGVuc3VyZXMgdGhhdCB0aGUgYXNzaWdubWVudCB0byBmcHNpbWRfY3B1IGlzIHZp
c2libGUgdG8gYW55CisgKiBwcmVlbXB0aW9uL3NvZnRpcnEgdGhhdCBjb3VsZCByYWNlIHdpdGgg
c2V0X3Rza190aHJlYWRfZmxhZygpLCBzbworICogdGhhdCBUSUZfRk9SRUlHTl9GUFNUQVRFIGNh
bm5vdCBiZSBzcHVyaW91c2x5IHJlLWNsZWFyZWQuCisgKgorICogVGhlIGZpbmFsIGJhcnJpZXIg
ZW5zdXJlcyB0aGF0IFRJRl9GT1JFSUdOX0ZQU1RBVEUgaXMgc2VlbiBzZXQgYnkgYW55CisgKiBz
dWJzZXF1ZW50IGNvZGUuCiAgKi8KIHZvaWQgZnBzaW1kX2ZsdXNoX3Rhc2tfc3RhdGUoc3RydWN0
IHRhc2tfc3RydWN0ICp0KQogewogCXQtPnRocmVhZC5mcHNpbWRfY3B1ID0gTlJfQ1BVUzsKKwor
CWJhcnJpZXIoKTsKKwlzZXRfdHNrX3RocmVhZF9mbGFnKHQsIFRJRl9GT1JFSUdOX0ZQU1RBVEUp
OworCisJYmFycmllcigpOwogfQogCisvKgorICogSW52YWxpZGF0ZSBhbnkgdGFzaydzIEZQU0lN
RCBzdGF0ZSB0aGF0IGlzIHByZXNlbnQgb24gdGhpcyBjcHUuCisgKiBUaGlzIGZ1bmN0aW9uIG11
c3QgYmUgY2FsbGVkIHdpdGggc29mdGlycXMgZGlzYWJsZWQuCisgKi8KIHZvaWQgZnBzaW1kX2Zs
dXNoX2NwdV9zdGF0ZSh2b2lkKQogewogCV9fdGhpc19jcHVfd3JpdGUoZnBzaW1kX2xhc3Rfc3Rh
dGUuc3QsIE5VTEwpOwpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rZXJuZWwvc2lnbmFsLmMgYi9h
cmNoL2FybTY0L2tlcm5lbC9zaWduYWwuYwppbmRleCA4NjdhN2NlYTcwZTUuLmE5YjA0ODVkZjA3
NCAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rZXJuZWwvc2lnbmFsLmMKKysrIGIvYXJjaC9hcm02
NC9rZXJuZWwvc2lnbmFsLmMKQEAgLTI5NiwxMSArMjk2LDYgQEAgc3RhdGljIGludCByZXN0b3Jl
X3N2ZV9mcHNpbWRfY29udGV4dChzdHJ1Y3QgdXNlcl9jdHhzICp1c2VyKQogCSAqLwogCiAJZnBz
aW1kX2ZsdXNoX3Rhc2tfc3RhdGUoY3VycmVudCk7Ci0JYmFycmllcigpOwotCS8qIEZyb20gbm93
LCBmcHNpbWRfdGhyZWFkX3N3aXRjaCgpIHdvbid0IGNsZWFyIFRJRl9GT1JFSUdOX0ZQU1RBVEUg
Ki8KLQotCXNldF90aHJlYWRfZmxhZyhUSUZfRk9SRUlHTl9GUFNUQVRFKTsKLQliYXJyaWVyKCk7
CiAJLyogRnJvbSBub3csIGZwc2ltZF90aHJlYWRfc3dpdGNoKCkgd29uJ3QgdG91Y2ggdGhyZWFk
LnN2ZV9zdGF0ZSAqLwogCiAJc3ZlX2FsbG9jKGN1cnJlbnQpOwotLSAKMi4yMC4xCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
