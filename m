Return-Path: <SRS0=xH8Q=V4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F010C32753
	for <kvmarm@archiver.kernel.org>; Wed, 31 Jul 2019 17:37:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DBDA3208E4
	for <kvmarm@archiver.kernel.org>; Wed, 31 Jul 2019 17:37:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBDA3208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 808804A553;
	Wed, 31 Jul 2019 13:37:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b1DYcnf8dM7q; Wed, 31 Jul 2019 13:37:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CBC34A55A;
	Wed, 31 Jul 2019 13:37:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 872674A511
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Jul 2019 13:37:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VSfKbBZqgSFR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Jul 2019 13:37:07 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F0284A558
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Jul 2019 13:37:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35BDC1596;
 Wed, 31 Jul 2019 10:37:06 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D8E13F71F;
 Wed, 31 Jul 2019 10:37:02 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 2/5] arm64: KVM: regmap: Fix unexpected switch fall-through
Date: Wed, 31 Jul 2019 18:36:47 +0100
Message-Id: <20190731173650.12627-3-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190731173650.12627-1-maz@kernel.org>
References: <20190731173650.12627-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Anders Roxell <anders.roxell@linaro.org>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

RnJvbTogQW5kZXJzIFJveGVsbCA8YW5kZXJzLnJveGVsbEBsaW5hcm8ub3JnPgoKV2hlbiBmYWxs
LXRocm91Z2ggd2FybmluZ3Mgd2FzIGVuYWJsZWQgYnkgZGVmYXVsdCwgY29tbWl0IGQ5MzUxMmVm
MGYwZQooIk1ha2VmaWxlOiBHbG9iYWxseSBlbmFibGUgZmFsbC10aHJvdWdoIHdhcm5pbmciKSwg
dGhlIGZvbGxvd2luZwp3YXJuaW5ncyB3YXMgc3RhcnRpbmcgdG8gc2hvdyB1cDoKCkluIGZpbGUg
aW5jbHVkZWQgZnJvbSAuLi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9lbXVsYXRlLmg6MTks
CiAgICAgICAgICAgICAgICAgZnJvbSAuLi9hcmNoL2FybTY0L2t2bS9yZWdtYXAuYzoxMzoKLi4v
YXJjaC9hcm02NC9rdm0vcmVnbWFwLmM6IEluIGZ1bmN0aW9uIOKAmHZjcHVfd3JpdGVfc3BzcjMy
4oCZOgouLi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaDozMTozOiB3YXJuaW5nOiB0
aGlzIHN0YXRlbWVudCBtYXkgZmFsbAogdGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1d
CiAgIGFzbSB2b2xhdGlsZShBTFRFUk5BVElWRShfX21zcl9zKHIjI252aCwgIiV4MCIpLCBcCiAg
IF5+fgouLi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaDo0NjozMTogbm90ZTogaW4g
ZXhwYW5zaW9uIG9mIG1hY3JvIOKAmHdyaXRlX3N5c3JlZ19lbHjigJkKICNkZWZpbmUgd3JpdGVf
c3lzcmVnX2VsMSh2LHIpIHdyaXRlX3N5c3JlZ19lbHgodiwgciwgX0VMMSwgX0VMMTIpCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fn5+Ci4uL2FyY2gvYXJtNjQv
a3ZtL3JlZ21hcC5jOjE4MDozOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCYd3JpdGVf
c3lzcmVnX2VsMeKAmQogICB3cml0ZV9zeXNyZWdfZWwxKHYsIFNZU19TUFNSKTsKICAgXn5+fn5+
fn5+fn5+fn5+fgouLi9hcmNoL2FybTY0L2t2bS9yZWdtYXAuYzoxODE6Mjogbm90ZTogaGVyZQog
IGNhc2UgS1ZNX1NQU1JfQUJUOgogIF5+fn4KSW4gZmlsZSBpbmNsdWRlZCBmcm9tIC4uL2FyY2gv
YXJtNjQvaW5jbHVkZS9hc20vY3B1dHlwZS5oOjEzMiwKICAgICAgICAgICAgICAgICBmcm9tIC4u
L2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vY2FjaGUuaDo4LAogICAgICAgICAgICAgICAgIGZyb20g
Li4vaW5jbHVkZS9saW51eC9jYWNoZS5oOjYsCiAgICAgICAgICAgICAgICAgZnJvbSAuLi9pbmNs
dWRlL2xpbnV4L3ByaW50ay5oOjksCiAgICAgICAgICAgICAgICAgZnJvbSAuLi9pbmNsdWRlL2xp
bnV4L2tlcm5lbC5oOjE1LAogICAgICAgICAgICAgICAgIGZyb20gLi4vaW5jbHVkZS9hc20tZ2Vu
ZXJpYy9idWcuaDoxOCwKICAgICAgICAgICAgICAgICBmcm9tIC4uL2FyY2gvYXJtNjQvaW5jbHVk
ZS9hc20vYnVnLmg6MjYsCiAgICAgICAgICAgICAgICAgZnJvbSAuLi9pbmNsdWRlL2xpbnV4L2J1
Zy5oOjUsCiAgICAgICAgICAgICAgICAgZnJvbSAuLi9pbmNsdWRlL2xpbnV4L21tZGVidWcuaDo1
LAogICAgICAgICAgICAgICAgIGZyb20gLi4vaW5jbHVkZS9saW51eC9tbS5oOjksCiAgICAgICAg
ICAgICAgICAgZnJvbSAuLi9hcmNoL2FybTY0L2t2bS9yZWdtYXAuYzoxMToKLi4vYXJjaC9hcm02
NC9pbmNsdWRlL2FzbS9zeXNyZWcuaDo4Mzc6Mjogd2FybmluZzogdGhpcyBzdGF0ZW1lbnQgbWF5
IGZhbGwKIHRocm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQogIGFzbSB2b2xhdGlsZSgi
bXNyICIgX19zdHJpbmdpZnkocikgIiwgJXgwIiAgXAogIF5+fgouLi9hcmNoL2FybTY0L2t2bS9y
ZWdtYXAuYzoxODI6Mzogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmHdyaXRlX3N5c3Jl
Z+KAmQogICB3cml0ZV9zeXNyZWcodiwgc3Bzcl9hYnQpOwogICBefn5+fn5+fn5+fn4KLi4vYXJj
aC9hcm02NC9rdm0vcmVnbWFwLmM6MTgzOjI6IG5vdGU6IGhlcmUKICBjYXNlIEtWTV9TUFNSX1VO
RDoKICBefn5+CgpSZXdvcmsgdG8gYWRkIGEgJ2JyZWFrOycgaW4gdGhlIHN3aWNoLWNhc2Ugc2lu
Y2UgaXQgZGlkbid0IGhhdmUgdGhhdCwKbGVhZGluZyB0byBhbiBpbnRlcnJlc3Rpbmcgc2V0IG9m
IGJ1Z3MuCgpDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZyAjIHY0LjE3KwpGaXhlczogYTg5Mjgx
OTU2MGM0ICgiS1ZNOiBhcm02NDogUHJlcGFyZSB0byBoYW5kbGUgZGVmZXJyZWQgc2F2ZS9yZXN0
b3JlIG9mIDMyLWJpdCByZWdpc3RlcnMiKQpTaWduZWQtb2ZmLWJ5OiBBbmRlcnMgUm94ZWxsIDxh
bmRlcnMucm94ZWxsQGxpbmFyby5vcmc+ClttYXo6IHJld29ya2VkIGNvbW1pdCBtZXNzYWdlLCBm
aXhlZCBzdGFibGUgcmFuZ2VdClNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWF6QGtlcm5l
bC5vcmc+Ci0tLQogYXJjaC9hcm02NC9rdm0vcmVnbWFwLmMgfCA1ICsrKysrCiAxIGZpbGUgY2hh
bmdlZCwgNSBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vcmVnbWFw
LmMgYi9hcmNoL2FybTY0L2t2bS9yZWdtYXAuYwppbmRleCAwZDYwZTRmMGFmNjYuLmE5MDAxODFl
Mzg2NyAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vcmVnbWFwLmMKKysrIGIvYXJjaC9hcm02
NC9rdm0vcmVnbWFwLmMKQEAgLTE3OCwxMyArMTc4LDE4IEBAIHZvaWQgdmNwdV93cml0ZV9zcHNy
MzIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1bnNpZ25lZCBsb25nIHYpCiAJc3dpdGNoIChzcHNy
X2lkeCkgewogCWNhc2UgS1ZNX1NQU1JfU1ZDOgogCQl3cml0ZV9zeXNyZWdfZWwxKHYsIFNZU19T
UFNSKTsKKwkJYnJlYWs7CiAJY2FzZSBLVk1fU1BTUl9BQlQ6CiAJCXdyaXRlX3N5c3JlZyh2LCBz
cHNyX2FidCk7CisJCWJyZWFrOwogCWNhc2UgS1ZNX1NQU1JfVU5EOgogCQl3cml0ZV9zeXNyZWco
diwgc3Bzcl91bmQpOworCQlicmVhazsKIAljYXNlIEtWTV9TUFNSX0lSUToKIAkJd3JpdGVfc3lz
cmVnKHYsIHNwc3JfaXJxKTsKKwkJYnJlYWs7CiAJY2FzZSBLVk1fU1BTUl9GSVE6CiAJCXdyaXRl
X3N5c3JlZyh2LCBzcHNyX2ZpcSk7CisJCWJyZWFrOwogCX0KIH0KLS0gCjIuMjAuMQoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcg
bGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1i
aWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
