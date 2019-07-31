Return-Path: <SRS0=xH8Q=V4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6212FC433FF
	for <kvmarm@archiver.kernel.org>; Wed, 31 Jul 2019 17:37:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 27BFE2067D
	for <kvmarm@archiver.kernel.org>; Wed, 31 Jul 2019 17:37:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27BFE2067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D208C4A55C;
	Wed, 31 Jul 2019 13:37:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8p5ARnyOqLnR; Wed, 31 Jul 2019 13:37:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A943C4A55A;
	Wed, 31 Jul 2019 13:37:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29D454A511
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Jul 2019 13:37:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cs6oyzOc+vGa for <kvmarm@lists.cs.columbia.edu>;
 Wed, 31 Jul 2019 13:37:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD3854A558
 for <kvmarm@lists.cs.columbia.edu>; Wed, 31 Jul 2019 13:37:15 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67BC615BF;
 Wed, 31 Jul 2019 10:37:15 -0700 (PDT)
Received: from big-swifty.lan (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B672C3F71F;
 Wed, 31 Jul 2019 10:37:12 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 5/5] arm64: KVM: hyp: debug-sr: Mark expected switch
 fall-through
Date: Wed, 31 Jul 2019 18:36:50 +0100
Message-Id: <20190731173650.12627-6-maz@kernel.org>
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
LXRocm91Z2ggd2FybmluZ3Mgd2FzIGVuYWJsZWQgYnkgZGVmYXVsdCB0aGUgZm9sbG93aW5nIHdh
cm5pbmdzCndhcyBzdGFydGluZyB0byBzaG93IHVwOgoKLi4vYXJjaC9hcm02NC9rdm0vaHlwL2Rl
YnVnLXNyLmM6IEluIGZ1bmN0aW9uIOKAmF9fZGVidWdfc2F2ZV9zdGF0ZeKAmToKLi4vYXJjaC9h
cm02NC9rdm0vaHlwL2RlYnVnLXNyLmM6MjA6MTk6IHdhcm5pbmc6IHRoaXMgc3RhdGVtZW50IG1h
eSBmYWxsCiB0aHJvdWdoIFstV2ltcGxpY2l0LWZhbGx0aHJvdWdoPV0KICBjYXNlIDE1OiBwdHJb
MTVdID0gcmVhZF9kZWJ1ZyhyZWcsIDE1KTsgICBcCi4uL2FyY2gvYXJtNjQva3ZtL2h5cC9kZWJ1
Zy1zci5jOjExMzoyOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCYc2F2ZV9kZWJ1Z+KA
mQogIHNhdmVfZGVidWcoZGJnLT5kYmdfYmNyLCBkYmdiY3IsIGJycHMpOwogIF5+fn5+fn5+fn4K
Li4vYXJjaC9hcm02NC9rdm0vaHlwL2RlYnVnLXNyLmM6MjE6Mjogbm90ZTogaGVyZQogIGNhc2Ug
MTQ6IHB0clsxNF0gPSByZWFkX2RlYnVnKHJlZywgMTQpOyAgIFwKICBefn5+Ci4uL2FyY2gvYXJt
NjQva3ZtL2h5cC9kZWJ1Zy1zci5jOjExMzoyOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g
4oCYc2F2ZV9kZWJ1Z+KAmQogIHNhdmVfZGVidWcoZGJnLT5kYmdfYmNyLCBkYmdiY3IsIGJycHMp
OwogIF5+fn5+fn5+fn4KLi4vYXJjaC9hcm02NC9rdm0vaHlwL2RlYnVnLXNyLmM6MjE6MTk6IHdh
cm5pbmc6IHRoaXMgc3RhdGVtZW50IG1heSBmYWxsCiB0aHJvdWdoIFstV2ltcGxpY2l0LWZhbGx0
aHJvdWdoPV0KICBjYXNlIDE0OiBwdHJbMTRdID0gcmVhZF9kZWJ1ZyhyZWcsIDE0KTsgICBcCi4u
L2FyY2gvYXJtNjQva3ZtL2h5cC9kZWJ1Zy1zci5jOjExMzoyOiBub3RlOiBpbiBleHBhbnNpb24g
b2YgbWFjcm8g4oCYc2F2ZV9kZWJ1Z+KAmQogIHNhdmVfZGVidWcoZGJnLT5kYmdfYmNyLCBkYmdi
Y3IsIGJycHMpOwogIF5+fn5+fn5+fn4KLi4vYXJjaC9hcm02NC9rdm0vaHlwL2RlYnVnLXNyLmM6
MjI6Mjogbm90ZTogaGVyZQogIGNhc2UgMTM6IHB0clsxM10gPSByZWFkX2RlYnVnKHJlZywgMTMp
OyAgIFwKICBefn5+Ci4uL2FyY2gvYXJtNjQva3ZtL2h5cC9kZWJ1Zy1zci5jOjExMzoyOiBub3Rl
OiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCYc2F2ZV9kZWJ1Z+KAmQogIHNhdmVfZGVidWcoZGJn
LT5kYmdfYmNyLCBkYmdiY3IsIGJycHMpOwogIF5+fn5+fn5+fn4KClJld29yayB0byBhZGQgYSAn
RmFsbCB0aHJvdWdoJyBjb21tZW50IHdoZXJlIHRoZSBjb21waWxlciB3YXJuZWQKYWJvdXQgZmFs
bC10aHJvdWdoLCBoZW5jZSBzaWxlbmNpbmcgdGhlIHdhcm5pbmcuCgpGaXhlczogZDkzNTEyZWYw
ZjBlICgiTWFrZWZpbGU6IEdsb2JhbGx5IGVuYWJsZSBmYWxsLXRocm91Z2ggd2FybmluZyIpClNp
Z25lZC1vZmYtYnk6IEFuZGVycyBSb3hlbGwgPGFuZGVycy5yb3hlbGxAbGluYXJvLm9yZz4KW21h
ejogZml4ZWQgY29tbWl0IG1lc3NhZ2VdClNpZ25lZC1vZmYtYnk6IE1hcmMgWnluZ2llciA8bWF6
QGtlcm5lbC5vcmc+Ci0tLQogYXJjaC9hcm02NC9rdm0vaHlwL2RlYnVnLXNyLmMgfCAzMCArKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysKIDEgZmlsZSBjaGFuZ2VkLCAzMCBpbnNlcnRpb25z
KCspCgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0vaHlwL2RlYnVnLXNyLmMgYi9hcmNoL2Fy
bTY0L2t2bS9oeXAvZGVidWctc3IuYwppbmRleCAyNjc4MWRhM2FkM2UuLjBmYzk4NzJhMTQ2NyAx
MDA2NDQKLS0tIGEvYXJjaC9hcm02NC9rdm0vaHlwL2RlYnVnLXNyLmMKKysrIGIvYXJjaC9hcm02
NC9rdm0vaHlwL2RlYnVnLXNyLmMKQEAgLTE4LDQwICsxOCw3MCBAQAogI2RlZmluZSBzYXZlX2Rl
YnVnKHB0cixyZWcsbnIpCQkJCQkJXAogCXN3aXRjaCAobnIpIHsJCQkJCQkJXAogCWNhc2UgMTU6
CXB0clsxNV0gPSByZWFkX2RlYnVnKHJlZywgMTUpOwkJCVwKKwkJCS8qIEZhbGwgdGhyb3VnaCAq
LwkJCQlcCiAJY2FzZSAxNDoJcHRyWzE0XSA9IHJlYWRfZGVidWcocmVnLCAxNCk7CQkJXAorCQkJ
LyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDEzOglwdHJbMTNdID0gcmVhZF9kZWJ1Zyhy
ZWcsIDEzKTsJCQlcCisJCQkvKiBGYWxsIHRocm91Z2ggKi8JCQkJXAogCWNhc2UgMTI6CXB0clsx
Ml0gPSByZWFkX2RlYnVnKHJlZywgMTIpOwkJCVwKKwkJCS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlc
CiAJY2FzZSAxMToJcHRyWzExXSA9IHJlYWRfZGVidWcocmVnLCAxMSk7CQkJXAorCQkJLyogRmFs
bCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDEwOglwdHJbMTBdID0gcmVhZF9kZWJ1ZyhyZWcsIDEw
KTsJCQlcCisJCQkvKiBGYWxsIHRocm91Z2ggKi8JCQkJXAogCWNhc2UgOToJCXB0cls5XSA9IHJl
YWRfZGVidWcocmVnLCA5KTsJCQlcCisJCQkvKiBGYWxsIHRocm91Z2ggKi8JCQkJXAogCWNhc2Ug
ODoJCXB0cls4XSA9IHJlYWRfZGVidWcocmVnLCA4KTsJCQlcCisJCQkvKiBGYWxsIHRocm91Z2gg
Ki8JCQkJXAogCWNhc2UgNzoJCXB0cls3XSA9IHJlYWRfZGVidWcocmVnLCA3KTsJCQlcCisJCQkv
KiBGYWxsIHRocm91Z2ggKi8JCQkJXAogCWNhc2UgNjoJCXB0cls2XSA9IHJlYWRfZGVidWcocmVn
LCA2KTsJCQlcCisJCQkvKiBGYWxsIHRocm91Z2ggKi8JCQkJXAogCWNhc2UgNToJCXB0cls1XSA9
IHJlYWRfZGVidWcocmVnLCA1KTsJCQlcCisJCQkvKiBGYWxsIHRocm91Z2ggKi8JCQkJXAogCWNh
c2UgNDoJCXB0cls0XSA9IHJlYWRfZGVidWcocmVnLCA0KTsJCQlcCisJCQkvKiBGYWxsIHRocm91
Z2ggKi8JCQkJXAogCWNhc2UgMzoJCXB0clszXSA9IHJlYWRfZGVidWcocmVnLCAzKTsJCQlcCisJ
CQkvKiBGYWxsIHRocm91Z2ggKi8JCQkJXAogCWNhc2UgMjoJCXB0clsyXSA9IHJlYWRfZGVidWco
cmVnLCAyKTsJCQlcCisJCQkvKiBGYWxsIHRocm91Z2ggKi8JCQkJXAogCWNhc2UgMToJCXB0clsx
XSA9IHJlYWRfZGVidWcocmVnLCAxKTsJCQlcCisJCQkvKiBGYWxsIHRocm91Z2ggKi8JCQkJXAog
CWRlZmF1bHQ6CXB0clswXSA9IHJlYWRfZGVidWcocmVnLCAwKTsJCQlcCiAJfQogCiAjZGVmaW5l
IHJlc3RvcmVfZGVidWcocHRyLHJlZyxucikJCQkJCVwKIAlzd2l0Y2ggKG5yKSB7CQkJCQkJCVwK
IAljYXNlIDE1Ogl3cml0ZV9kZWJ1ZyhwdHJbMTVdLCByZWcsIDE1KTsJCQlcCisJCQkvKiBGYWxs
IHRocm91Z2ggKi8JCQkJXAogCWNhc2UgMTQ6CXdyaXRlX2RlYnVnKHB0clsxNF0sIHJlZywgMTQp
OwkJCVwKKwkJCS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlcCiAJY2FzZSAxMzoJd3JpdGVfZGVidWco
cHRyWzEzXSwgcmVnLCAxMyk7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNl
IDEyOgl3cml0ZV9kZWJ1ZyhwdHJbMTJdLCByZWcsIDEyKTsJCQlcCisJCQkvKiBGYWxsIHRocm91
Z2ggKi8JCQkJXAogCWNhc2UgMTE6CXdyaXRlX2RlYnVnKHB0clsxMV0sIHJlZywgMTEpOwkJCVwK
KwkJCS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlcCiAJY2FzZSAxMDoJd3JpdGVfZGVidWcocHRyWzEw
XSwgcmVnLCAxMCk7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDk6CQl3
cml0ZV9kZWJ1ZyhwdHJbOV0sIHJlZywgOSk7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJ
CVwKIAljYXNlIDg6CQl3cml0ZV9kZWJ1ZyhwdHJbOF0sIHJlZywgOCk7CQkJXAorCQkJLyogRmFs
bCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDc6CQl3cml0ZV9kZWJ1ZyhwdHJbN10sIHJlZywgNyk7
CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDY6CQl3cml0ZV9kZWJ1Zyhw
dHJbNl0sIHJlZywgNik7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDU6
CQl3cml0ZV9kZWJ1ZyhwdHJbNV0sIHJlZywgNSk7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICov
CQkJCVwKIAljYXNlIDQ6CQl3cml0ZV9kZWJ1ZyhwdHJbNF0sIHJlZywgNCk7CQkJXAorCQkJLyog
RmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDM6CQl3cml0ZV9kZWJ1ZyhwdHJbM10sIHJlZywg
Myk7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDI6CQl3cml0ZV9kZWJ1
ZyhwdHJbMl0sIHJlZywgMik7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNl
IDE6CQl3cml0ZV9kZWJ1ZyhwdHJbMV0sIHJlZywgMSk7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdo
ICovCQkJCVwKIAlkZWZhdWx0Ogl3cml0ZV9kZWJ1ZyhwdHJbMF0sIHJlZywgMCk7CQkJXAogCX0K
IAotLSAKMi4yMC4xCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0
cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
