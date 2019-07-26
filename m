Return-Path: <SRS0=RR3A=VZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FAFC433FF
	for <kvmarm@archiver.kernel.org>; Sun, 28 Jul 2019 10:21:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D2D92075B
	for <kvmarm@archiver.kernel.org>; Sun, 28 Jul 2019 10:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oFWvs4Mv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D2D92075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A54134A52D;
	Sun, 28 Jul 2019 06:21:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LxedJqoII7xa; Sun, 28 Jul 2019 06:21:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D7434A548;
	Sun, 28 Jul 2019 06:21:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F30D64A60F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jul 2019 07:27:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ehlwosz7lbg2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jul 2019 07:27:12 -0400 (EDT)
Received: from mail-lj1-f196.google.com (mail-lj1-f196.google.com
 [209.85.208.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CE6BB4A5E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jul 2019 07:27:11 -0400 (EDT)
Received: by mail-lj1-f196.google.com with SMTP id i21so51173045ljj.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jul 2019 04:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=/ZeEPeRDOknxPoC0/mlXSl8BxnaCt+PLZvPwsv+/Wqg=;
 b=oFWvs4MvlL5GP1gOZX6EZCUM2DYpnzic9Y3aW+lbwp2ZlxCnqCK7T5Bah4HG/joNOs
 hV63e0w5+svVL8XhftgWoWP/xCsWoblTf6/31WWKzPb/CwML3ON89eWY42RteRNyjwNS
 I197pa9xb3Qz6rxDm9hDLNq5ZbkJvSiwlFXcR8fDGrI/kDNBHrhXDuf88fagsz5HwmT7
 MpJtdv/j3qYcrqljuvU0aunOcizbibYaxbPC/XFelw2VXEj2hKS0CyZoB45ls2x83PYh
 RbSW/E8DfU+T4TjCdPusX2d4I4gsNutKuwZXekucTrsBKtxPwVCvIaPHjB+M/RwiEKaA
 KCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=/ZeEPeRDOknxPoC0/mlXSl8BxnaCt+PLZvPwsv+/Wqg=;
 b=CzIW1RSU+89s16uFAlxBATKz72xVA2Atk8DgjTSBZL0NzeGpkPNlPeHSO5XGFZXoG7
 2rHIIhaDAnhLxhWRCBXaNRQCs6MHOXUYY22etMaVtRll8e+rS8sVbsw0q0MX/dilAQsd
 qOFk9vFtRR8BK0T1UESXxrl0qUZ8nM1NB/gk24pZerSTQLWsYnYzVgPo9RUY7ScHmkKV
 LBv/sRyKiehQUse0KbTKHVs/jo/6SFXiRITtklHvXOk3Yt/fKvUCsbb4LZBleXtwV1ez
 PwCoIsLSsQQseidWFDwERHKD1yOEnvMmdFBcxoc/5VzbtxAKqPkC+uuNPhUktvxjRl56
 gdrw==
X-Gm-Message-State: APjAAAUmSZKc7OZbr9RUqrJYiKQ8FHLzRjHgl3+h4mHurge55O9p46Ci
 yWrh2sO1u567XGdbP6VPYgfEIQ==
X-Google-Smtp-Source: APXvYqzBzw39/qTQ5qot67rMP7b47yVgMBStFTk75r4a7FEttMNWySTKLQVrAfua6AJQua/mT8NDOA==
X-Received: by 2002:a2e:9593:: with SMTP id w19mr1978301ljh.69.1564140430346; 
 Fri, 26 Jul 2019 04:27:10 -0700 (PDT)
Received: from localhost (c-243c70d5.07-21-73746f28.bbcust.telenor.se.
 [213.112.60.36])
 by smtp.gmail.com with ESMTPSA id q2sm8196273lfj.25.2019.07.26.04.27.09
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Fri, 26 Jul 2019 04:27:09 -0700 (PDT)
From: Anders Roxell <anders.roxell@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Subject: [PATCH 1/2] arm64: KVM: regmap: Mark expected switch fall-through
Date: Fri, 26 Jul 2019 13:27:05 +0200
Message-Id: <20190726112705.19000-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Mailman-Approved-At: Sun, 28 Jul 2019 06:21:14 -0400
Cc: stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

V2hlbiBmYWxsLXRocm91Z2ggd2FybmluZ3Mgd2FzIGVuYWJsZWQgYnkgZGVmYXVsdCwgY29tbWl0
IGQ5MzUxMmVmMGYwZQooIk1ha2VmaWxlOiBHbG9iYWxseSBlbmFibGUgZmFsbC10aHJvdWdoIHdh
cm5pbmciKSwgdGhlIGZvbGxvd2luZwp3YXJuaW5ncyB3YXMgc3RhcnRpbmcgdG8gc2hvdyB1cDoK
CkluIGZpbGUgaW5jbHVkZWQgZnJvbSAuLi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9lbXVs
YXRlLmg6MTksCiAgICAgICAgICAgICAgICAgZnJvbSAuLi9hcmNoL2FybTY0L2t2bS9yZWdtYXAu
YzoxMzoKLi4vYXJjaC9hcm02NC9rdm0vcmVnbWFwLmM6IEluIGZ1bmN0aW9uIOKAmHZjcHVfd3Jp
dGVfc3BzcjMy4oCZOgouLi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaDozMTozOiB3
YXJuaW5nOiB0aGlzIHN0YXRlbWVudCBtYXkgZmFsbAogdGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxs
dGhyb3VnaD1dCiAgIGFzbSB2b2xhdGlsZShBTFRFUk5BVElWRShfX21zcl9zKHIjI252aCwgIiV4
MCIpLCBcCiAgIF5+fgouLi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9oeXAuaDo0NjozMTog
bm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmHdyaXRlX3N5c3JlZ19lbHjigJkKICNkZWZp
bmUgd3JpdGVfc3lzcmVnX2VsMSh2LHIpIHdyaXRlX3N5c3JlZ19lbHgodiwgciwgX0VMMSwgX0VM
MTIpCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fn5+Ci4uL2Fy
Y2gvYXJtNjQva3ZtL3JlZ21hcC5jOjE4MDozOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g
4oCYd3JpdGVfc3lzcmVnX2VsMeKAmQogICB3cml0ZV9zeXNyZWdfZWwxKHYsIFNZU19TUFNSKTsK
ICAgXn5+fn5+fn5+fn5+fn5+fgouLi9hcmNoL2FybTY0L2t2bS9yZWdtYXAuYzoxODE6Mjogbm90
ZTogaGVyZQogIGNhc2UgS1ZNX1NQU1JfQUJUOgogIF5+fn4KSW4gZmlsZSBpbmNsdWRlZCBmcm9t
IC4uL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vY3B1dHlwZS5oOjEzMiwKICAgICAgICAgICAgICAg
ICBmcm9tIC4uL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20vY2FjaGUuaDo4LAogICAgICAgICAgICAg
ICAgIGZyb20gLi4vaW5jbHVkZS9saW51eC9jYWNoZS5oOjYsCiAgICAgICAgICAgICAgICAgZnJv
bSAuLi9pbmNsdWRlL2xpbnV4L3ByaW50ay5oOjksCiAgICAgICAgICAgICAgICAgZnJvbSAuLi9p
bmNsdWRlL2xpbnV4L2tlcm5lbC5oOjE1LAogICAgICAgICAgICAgICAgIGZyb20gLi4vaW5jbHVk
ZS9hc20tZ2VuZXJpYy9idWcuaDoxOCwKICAgICAgICAgICAgICAgICBmcm9tIC4uL2FyY2gvYXJt
NjQvaW5jbHVkZS9hc20vYnVnLmg6MjYsCiAgICAgICAgICAgICAgICAgZnJvbSAuLi9pbmNsdWRl
L2xpbnV4L2J1Zy5oOjUsCiAgICAgICAgICAgICAgICAgZnJvbSAuLi9pbmNsdWRlL2xpbnV4L21t
ZGVidWcuaDo1LAogICAgICAgICAgICAgICAgIGZyb20gLi4vaW5jbHVkZS9saW51eC9tbS5oOjks
CiAgICAgICAgICAgICAgICAgZnJvbSAuLi9hcmNoL2FybTY0L2t2bS9yZWdtYXAuYzoxMToKLi4v
YXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zeXNyZWcuaDo4Mzc6Mjogd2FybmluZzogdGhpcyBzdGF0
ZW1lbnQgbWF5IGZhbGwKIHRocm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQogIGFzbSB2
b2xhdGlsZSgibXNyICIgX19zdHJpbmdpZnkocikgIiwgJXgwIiAgXAogIF5+fgouLi9hcmNoL2Fy
bTY0L2t2bS9yZWdtYXAuYzoxODI6Mzogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmHdy
aXRlX3N5c3JlZ+KAmQogICB3cml0ZV9zeXNyZWcodiwgc3Bzcl9hYnQpOwogICBefn5+fn5+fn5+
fn4KLi4vYXJjaC9hcm02NC9rdm0vcmVnbWFwLmM6MTgzOjI6IG5vdGU6IGhlcmUKICBjYXNlIEtW
TV9TUFNSX1VORDoKICBefn5+CgpSZXdvcmsgdG8gYWRkIGEgJ2JyZWFrOycgaW4gdGhlIHN3aWNo
LWNhc2Ugc2luY2UgaXQgZGlkbid0IGhhdmUgdGhhdC4KVGhhdCBhbHNvIG1hZGUgdGhlIGNvbXBp
bGVyIGhhcHB5IGFuZCBkaWRuJ3Qgd2FybiBhYm91dCBmYWxsLXRocm91Z2guCgpDYzogc3RhYmxl
QHZnZXIua2VybmVsLm9yZyAjIHYzLjE2KwpGaXhlczogYTg5MjgxOTU2MGM0ICgiS1ZNOiBhcm02
NDogUHJlcGFyZSB0byBoYW5kbGUgZGVmZXJyZWQgc2F2ZS9yZXN0b3JlIG9mIDMyLWJpdCByZWdp
c3RlcnMiKQpTaWduZWQtb2ZmLWJ5OiBBbmRlcnMgUm94ZWxsIDxhbmRlcnMucm94ZWxsQGxpbmFy
by5vcmc+Ci0tLQogYXJjaC9hcm02NC9rdm0vcmVnbWFwLmMgfCA1ICsrKysrCiAxIGZpbGUgY2hh
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
