Return-Path: <SRS0=RR3A=VZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF15AC76191
	for <kvmarm@archiver.kernel.org>; Sun, 28 Jul 2019 10:21:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 872E0214C6
	for <kvmarm@archiver.kernel.org>; Sun, 28 Jul 2019 10:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Qs5hDsYN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 872E0214C6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 339174A558;
	Sun, 28 Jul 2019 06:21:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bc6bTOj9o-CZ; Sun, 28 Jul 2019 06:21:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ACF844A55C;
	Sun, 28 Jul 2019 06:21:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B0AD4A5F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jul 2019 07:28:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ygUbyazQsUuR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jul 2019 07:28:37 -0400 (EDT)
Received: from mail-lj1-f193.google.com (mail-lj1-f193.google.com
 [209.85.208.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 24B654A5E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jul 2019 07:28:37 -0400 (EDT)
Received: by mail-lj1-f193.google.com with SMTP id p17so51157368ljg.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jul 2019 04:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=9u9CYuUvpswbH949bqEBTSxc6yUDGnUSUcquJxjAfws=;
 b=Qs5hDsYNRU3XsuhsUT5LoYh9H2yYIMx8duYxg6mWxxWMAUMbImQG+9HQrXaPkuZOWU
 NQ3JDWVRtBVse7vWN0EQedlArPeIP+VdKG/kcW22GMeAK0D8Rvz8puGSqcrmRNxxl1BF
 fZbTCesF+1uP4QoRJYi9h+LByxF/lRIdJoEJKRyKCMGiVK4AWoUclwfptVFmgD7O1xLm
 /WUXnq2XphbPUvCXVip34slPxmd0gU/1DukG9h40JCr+RigFMot1JveTXCyQQhRWmAo1
 3tvAZ1TaMuU8J/twMpxD+F9W9uzynrED2rNHzMAozJZR9YKUn7YY+6p4uTXvYdh5DKkB
 CGfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=9u9CYuUvpswbH949bqEBTSxc6yUDGnUSUcquJxjAfws=;
 b=OG1jBO2Iccdc+PoVybKdR99NHciLMwgZf6PEUfzih8zFb6IiBLQSNhoqt7wBYhOjDj
 oyOdetPgbn9Q+3/pXUzwf0hed9XQH+MpR4+Pkzimy1IPpwKAw+RCOpKlKiA1VdNW1gnr
 mjbOGVUevuATlGy0gvniSE2HeQ0aHrorKlMcvfQfuQb/tIV6hjxomxI1oFYbs5kK2lvP
 gr6/e/Di1h04ihrZCG3NSjKmu6A0FvOlgSIME5y9J9BAj47hy3ftbSbAnAYds+07Vmz6
 /pA3k6VHNqGRychisf3ffeUCT5kyipDaf5Kw98bSop9Ik3ZmfiIwtIlkbZVJN/u3koOI
 7kIg==
X-Gm-Message-State: APjAAAV57jHeoQ53jZnFUWTEY7AmSdGZ7OaUt/xsavCYGyOzpEoTrXej
 DbRzgTQ1M8BZ5b0d0WMdX50kfg==
X-Google-Smtp-Source: APXvYqwQdkpGbyaQOc5x7/xdgJkd0OQT2+j10xmlo8V5RVnCSXizO9kaU/pk141EQCFbvi0220t1Kw==
X-Received: by 2002:a2e:9685:: with SMTP id q5mr34535218lji.227.1564140515726; 
 Fri, 26 Jul 2019 04:28:35 -0700 (PDT)
Received: from localhost (c-243c70d5.07-21-73746f28.bbcust.telenor.se.
 [213.112.60.36])
 by smtp.gmail.com with ESMTPSA id k23sm5390909ljg.90.2019.07.26.04.28.34
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Fri, 26 Jul 2019 04:28:35 -0700 (PDT)
From: Anders Roxell <anders.roxell@linaro.org>
To: maz@kernel.org
Subject: [PATCH] KVM: arm: vgic-v3: Mark expected switch fall-through
Date: Fri, 26 Jul 2019 13:28:31 +0200
Message-Id: <20190726112831.19878-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Mailman-Approved-At: Sun, 28 Jul 2019 06:21:14 -0400
Cc: Anders Roxell <anders.roxell@linaro.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

V2hlbiBmYWxsLXRocm91Z2ggd2FybmluZ3Mgd2FzIGVuYWJsZWQgYnkgZGVmYXVsdCB0aGUgZm9s
bG93aW5nIHdhcm5pbmdzCndhcyBzdGFydGluZyB0byBzaG93IHVwOgoKLi4vdmlydC9rdm0vYXJt
L2h5cC92Z2ljLXYzLXNyLmM6IEluIGZ1bmN0aW9uIOKAmF9fdmdpY192M19zYXZlX2FwcnPigJk6
Ci4uL3ZpcnQva3ZtL2FybS9oeXAvdmdpYy12My1zci5jOjM1MToyNDogd2FybmluZzogdGhpcyBz
dGF0ZW1lbnQgbWF5IGZhbGwKIHRocm91Z2ggWy1XaW1wbGljaXQtZmFsbHRocm91Z2g9XQogICBj
cHVfaWYtPnZnaWNfYXAwclsyXSA9IF9fdmdpY192M19yZWFkX2FwMHJuKDIpOwogICB+fn5+fn5+
fn5+fn5+fn5+fn5+fn5efn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+Ci4uL3ZpcnQva3ZtL2FybS9o
eXAvdmdpYy12My1zci5jOjM1MjoyOiBub3RlOiBoZXJlCiAgY2FzZSA2OgogIF5+fn4KLi4vdmly
dC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmM6MzUzOjI0OiB3YXJuaW5nOiB0aGlzIHN0YXRlbWVu
dCBtYXkgZmFsbAogdGhyb3VnaCBbLVdpbXBsaWNpdC1mYWxsdGhyb3VnaD1dCiAgIGNwdV9pZi0+
dmdpY19hcDByWzFdID0gX192Z2ljX3YzX3JlYWRfYXAwcm4oMSk7CiAgIH5+fn5+fn5+fn5+fn5+
fn5+fn5+fl5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn4KLi4vdmlydC9rdm0vYXJtL2h5cC92Z2lj
LXYzLXNyLmM6MzU0OjI6IG5vdGU6IGhlcmUKICBkZWZhdWx0OgogIF5+fn5+fn4KClJld29yayBz
byB0aGF0IHRoZSBjb21waWxlciBkb2Vzbid0IHdhcm4gYWJvdXQgZmFsbC10aHJvdWdoLgoKRml4
ZXM6IGQ5MzUxMmVmMGYwZSAoIk1ha2VmaWxlOiBHbG9iYWxseSBlbmFibGUgZmFsbC10aHJvdWdo
IHdhcm5pbmciKQpTaWduZWQtb2ZmLWJ5OiBBbmRlcnMgUm94ZWxsIDxhbmRlcnMucm94ZWxsQGxp
bmFyby5vcmc+Ci0tLQogdmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmMgfCA4ICsrKysrKysr
CiAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspCgpkaWZmIC0tZ2l0IGEvdmlydC9rdm0v
YXJtL2h5cC92Z2ljLXYzLXNyLmMgYi92aXJ0L2t2bS9hcm0vaHlwL3ZnaWMtdjMtc3IuYwppbmRl
eCAyNTRjNWYxOTBhM2QuLmNjZjFmZGU5ODM2YyAxMDA2NDQKLS0tIGEvdmlydC9rdm0vYXJtL2h5
cC92Z2ljLXYzLXNyLmMKKysrIGIvdmlydC9rdm0vYXJtL2h5cC92Z2ljLXYzLXNyLmMKQEAgLTM0
OSw4ICszNDksMTAgQEAgdm9pZCBfX2h5cF90ZXh0IF9fdmdpY192M19zYXZlX2FwcnMoc3RydWN0
IGt2bV92Y3B1ICp2Y3B1KQogCWNhc2UgNzoKIAkJY3B1X2lmLT52Z2ljX2FwMHJbM10gPSBfX3Zn
aWNfdjNfcmVhZF9hcDBybigzKTsKIAkJY3B1X2lmLT52Z2ljX2FwMHJbMl0gPSBfX3ZnaWNfdjNf
cmVhZF9hcDBybigyKTsKKwkJLyogRmFsbCB0aHJvdWdoICovCiAJY2FzZSA2OgogCQljcHVfaWYt
PnZnaWNfYXAwclsxXSA9IF9fdmdpY192M19yZWFkX2FwMHJuKDEpOworCQkvKiBGYWxsIHRocm91
Z2ggKi8KIAlkZWZhdWx0OgogCQljcHVfaWYtPnZnaWNfYXAwclswXSA9IF9fdmdpY192M19yZWFk
X2FwMHJuKDApOwogCX0KQEAgLTM1OSw4ICszNjEsMTAgQEAgdm9pZCBfX2h5cF90ZXh0IF9fdmdp
Y192M19zYXZlX2FwcnMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogCWNhc2UgNzoKIAkJY3B1X2lm
LT52Z2ljX2FwMXJbM10gPSBfX3ZnaWNfdjNfcmVhZF9hcDFybigzKTsKIAkJY3B1X2lmLT52Z2lj
X2FwMXJbMl0gPSBfX3ZnaWNfdjNfcmVhZF9hcDFybigyKTsKKwkJLyogRmFsbCB0aHJvdWdoICov
CiAJY2FzZSA2OgogCQljcHVfaWYtPnZnaWNfYXAxclsxXSA9IF9fdmdpY192M19yZWFkX2FwMXJu
KDEpOworCQkvKiBGYWxsIHRocm91Z2ggKi8KIAlkZWZhdWx0OgogCQljcHVfaWYtPnZnaWNfYXAx
clswXSA9IF9fdmdpY192M19yZWFkX2FwMXJuKDApOwogCX0KQEAgLTM4Miw4ICszODYsMTAgQEAg
dm9pZCBfX2h5cF90ZXh0IF9fdmdpY192M19yZXN0b3JlX2FwcnMoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1KQogCWNhc2UgNzoKIAkJX192Z2ljX3YzX3dyaXRlX2FwMHJuKGNwdV9pZi0+dmdpY19hcDBy
WzNdLCAzKTsKIAkJX192Z2ljX3YzX3dyaXRlX2FwMHJuKGNwdV9pZi0+dmdpY19hcDByWzJdLCAy
KTsKKwkJLyogRmFsbCB0aHJvdWdoICovCiAJY2FzZSA2OgogCQlfX3ZnaWNfdjNfd3JpdGVfYXAw
cm4oY3B1X2lmLT52Z2ljX2FwMHJbMV0sIDEpOworCQkvKiBGYWxsIHRocm91Z2ggKi8KIAlkZWZh
dWx0OgogCQlfX3ZnaWNfdjNfd3JpdGVfYXAwcm4oY3B1X2lmLT52Z2ljX2FwMHJbMF0sIDApOwog
CX0KQEAgLTM5Miw4ICszOTgsMTAgQEAgdm9pZCBfX2h5cF90ZXh0IF9fdmdpY192M19yZXN0b3Jl
X2FwcnMoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQogCWNhc2UgNzoKIAkJX192Z2ljX3YzX3dyaXRl
X2FwMXJuKGNwdV9pZi0+dmdpY19hcDFyWzNdLCAzKTsKIAkJX192Z2ljX3YzX3dyaXRlX2FwMXJu
KGNwdV9pZi0+dmdpY19hcDFyWzJdLCAyKTsKKwkJLyogRmFsbCB0aHJvdWdoICovCiAJY2FzZSA2
OgogCQlfX3ZnaWNfdjNfd3JpdGVfYXAxcm4oY3B1X2lmLT52Z2ljX2FwMXJbMV0sIDEpOworCQkv
KiBGYWxsIHRocm91Z2ggKi8KIAlkZWZhdWx0OgogCQlfX3ZnaWNfdjNfd3JpdGVfYXAxcm4oY3B1
X2lmLT52Z2ljX2FwMXJbMF0sIDApOwogCX0KLS0gCjIuMjAuMQoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
