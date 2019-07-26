Return-Path: <SRS0=RR3A=VZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFEEC7618B
	for <kvmarm@archiver.kernel.org>; Sun, 28 Jul 2019 10:21:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 551772075B
	for <kvmarm@archiver.kernel.org>; Sun, 28 Jul 2019 10:21:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="c91SAV8u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 551772075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C2024A51F;
	Sun, 28 Jul 2019 06:21:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cCWoVHIhmndZ; Sun, 28 Jul 2019 06:21:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90C034A554;
	Sun, 28 Jul 2019 06:21:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0237B4A60B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jul 2019 07:27:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id n6YRj9HvGt7h for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Jul 2019 07:27:17 -0400 (EDT)
Received: from mail-lf1-f67.google.com (mail-lf1-f67.google.com
 [209.85.167.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE4914A5E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jul 2019 07:27:17 -0400 (EDT)
Received: by mail-lf1-f67.google.com with SMTP id s19so36843360lfb.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Jul 2019 04:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Z9HY70wJXKPs0Bv25UYCD9x0V9nBKcfnlqiIvTFUOZc=;
 b=c91SAV8uhLOcljWjQ8Ab9ri7kVRPcfAovbVniOu6W3Y7+7Si7G3ZkkP7PwDPvbwwZO
 tXE9mCuBPj28+YfwZhE9ZBUX0mlLJ2ZhgHnb9RoKMsj9lqK6gzK9osC9DQ1o3CBtbldM
 THIcpaGSet5VHt7d07KdP9xi4rTQVkmqyt5Q4dRIphqGXVuJvxTFnVBLNL7Ln/5KT/79
 KN/XJg9iOqLN/Ht9Lmb0TwwZ6uPeZjdsSlivfBcZSR5tO3redUCcob0WqfNxyx/iHSOh
 ZlUePfMRzln5doV68I92erwnugKUcHqGY/U+5iwOMomiq5Tco6Z3dJtXLTcJ/2JbF9ru
 d+Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=Z9HY70wJXKPs0Bv25UYCD9x0V9nBKcfnlqiIvTFUOZc=;
 b=n/Ju2d+DLRHaDiVm9JTr8ww+Nx9CaBaqMCThJZn7lKaICvNUUCaqAapGfwnI0XO+vv
 qgcgLnMoEcDhjgg5wPyzLViGQzJ0DtOcC4pu04Kha/urJbcYANW4I8pa6cuXsL0EbTag
 aOrnfFP+oxpZ1V+V62DytIyIkxOr/Nepv64i4py8SEn8hDR58+Pykpmbl3+0Qh68zmxC
 osBOmvcMSpeqkqdu0cUr1gFadCiyKaLB+yfOCtgXqxvTaN5vqNQA8eixaIz23+wTkR3+
 bqELlibDcxYroU3qotPJZ+0lhWY/YhphOpFWNxAxhTiCKi1eNyF3E081KCmUqvJKo06X
 E8iA==
X-Gm-Message-State: APjAAAVk0iyL1ZsfyJHw4rLHahTpuWuwdOQsaF+sbYCxmTRqT+sKCYyO
 pUNfegF2R9VC09JNlcaocbaj2Q==
X-Google-Smtp-Source: APXvYqz0zDV4DU1xCLE+wRCoXoQJs4j/uYCwZ1M3A6PeINVW1+FbpvuzjWzQ55z1yFlxnkhf1+WfaA==
X-Received: by 2002:ac2:419a:: with SMTP id z26mr44458557lfh.21.1564140436505; 
 Fri, 26 Jul 2019 04:27:16 -0700 (PDT)
Received: from localhost (c-243c70d5.07-21-73746f28.bbcust.telenor.se.
 [213.112.60.36])
 by smtp.gmail.com with ESMTPSA id j90sm9987780ljb.29.2019.07.26.04.27.15
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Fri, 26 Jul 2019 04:27:15 -0700 (PDT)
From: Anders Roxell <anders.roxell@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Subject: [PATCH 2/2] arm64: KVM: hyp: debug-sr: Mark expected switch
 fall-through
Date: Fri, 26 Jul 2019 13:27:10 +0200
Message-Id: <20190726112710.19051-1-anders.roxell@linaro.org>
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
bG93aW5nIHdhcm5pbmdzCndhcyBzdGFydGluZyB0byBzaG93IHVwOgoKLi4vYXJjaC9hcm02NC9r
dm0vaHlwL2RlYnVnLXNyLmM6IEluIGZ1bmN0aW9uIOKAmF9fZGVidWdfc2F2ZV9zdGF0ZeKAmToK
Li4vYXJjaC9hcm02NC9rdm0vaHlwL2RlYnVnLXNyLmM6MjA6MTk6IHdhcm5pbmc6IHRoaXMgc3Rh
dGVtZW50IG1heSBmYWxsCiB0aHJvdWdoIFstV2ltcGxpY2l0LWZhbGx0aHJvdWdoPV0KICBjYXNl
IDE1OiBwdHJbMTVdID0gcmVhZF9kZWJ1ZyhyZWcsIDE1KTsgICBcCi4uL2FyY2gvYXJtNjQva3Zt
L2h5cC9kZWJ1Zy1zci5jOjExMzoyOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCYc2F2
ZV9kZWJ1Z+KAmQogIHNhdmVfZGVidWcoZGJnLT5kYmdfYmNyLCBkYmdiY3IsIGJycHMpOwogIF5+
fn5+fn5+fn4KLi4vYXJjaC9hcm02NC9rdm0vaHlwL2RlYnVnLXNyLmM6MjE6Mjogbm90ZTogaGVy
ZQogIGNhc2UgMTQ6IHB0clsxNF0gPSByZWFkX2RlYnVnKHJlZywgMTQpOyAgIFwKICBefn5+Ci4u
L2FyY2gvYXJtNjQva3ZtL2h5cC9kZWJ1Zy1zci5jOjExMzoyOiBub3RlOiBpbiBleHBhbnNpb24g
b2YgbWFjcm8g4oCYc2F2ZV9kZWJ1Z+KAmQogIHNhdmVfZGVidWcoZGJnLT5kYmdfYmNyLCBkYmdi
Y3IsIGJycHMpOwogIF5+fn5+fn5+fn4KLi4vYXJjaC9hcm02NC9rdm0vaHlwL2RlYnVnLXNyLmM6
MjE6MTk6IHdhcm5pbmc6IHRoaXMgc3RhdGVtZW50IG1heSBmYWxsCiB0aHJvdWdoIFstV2ltcGxp
Y2l0LWZhbGx0aHJvdWdoPV0KICBjYXNlIDE0OiBwdHJbMTRdID0gcmVhZF9kZWJ1ZyhyZWcsIDE0
KTsgICBcCi4uL2FyY2gvYXJtNjQva3ZtL2h5cC9kZWJ1Zy1zci5jOjExMzoyOiBub3RlOiBpbiBl
eHBhbnNpb24gb2YgbWFjcm8g4oCYc2F2ZV9kZWJ1Z+KAmQogIHNhdmVfZGVidWcoZGJnLT5kYmdf
YmNyLCBkYmdiY3IsIGJycHMpOwogIF5+fn5+fn5+fn4KLi4vYXJjaC9hcm02NC9rdm0vaHlwL2Rl
YnVnLXNyLmM6MjI6Mjogbm90ZTogaGVyZQogIGNhc2UgMTM6IHB0clsxM10gPSByZWFkX2RlYnVn
KHJlZywgMTMpOyAgIFwKICBefn5+Ci4uL2FyY2gvYXJtNjQva3ZtL2h5cC9kZWJ1Zy1zci5jOjEx
MzoyOiBub3RlOiBpbiBleHBhbnNpb24gb2YgbWFjcm8g4oCYc2F2ZV9kZWJ1Z+KAmQogIHNhdmVf
ZGVidWcoZGJnLT5kYmdfYmNyLCBkYmdiY3IsIGJycHMpOwogIF5+fn5+fn5+fn4KClJld29yayB0
byBhZGQgYSAnYnJlYWs7JyB3aGVyZSB0aGUgY29tcGlsZXIgd2FybmVkIGFib3V0IGZhbGwtdGhy
b3VnaC4KCkZpeGVzOiBkOTM1MTJlZjBmMGUgKCJNYWtlZmlsZTogR2xvYmFsbHkgZW5hYmxlIGZh
bGwtdGhyb3VnaCB3YXJuaW5nIikKU2lnbmVkLW9mZi1ieTogQW5kZXJzIFJveGVsbCA8YW5kZXJz
LnJveGVsbEBsaW5hcm8ub3JnPgotLS0KIGFyY2gvYXJtNjQva3ZtL2h5cC9kZWJ1Zy1zci5jIHwg
MzAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdlZCwgMzAgaW5z
ZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL2h5cC9kZWJ1Zy1zci5jIGIv
YXJjaC9hcm02NC9rdm0vaHlwL2RlYnVnLXNyLmMKaW5kZXggMjY3ODFkYTNhZDNlLi4wZmM5ODcy
YTE0NjcgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva3ZtL2h5cC9kZWJ1Zy1zci5jCisrKyBiL2Fy
Y2gvYXJtNjQva3ZtL2h5cC9kZWJ1Zy1zci5jCkBAIC0xOCw0MCArMTgsNzAgQEAKICNkZWZpbmUg
c2F2ZV9kZWJ1ZyhwdHIscmVnLG5yKQkJCQkJCVwKIAlzd2l0Y2ggKG5yKSB7CQkJCQkJCVwKIAlj
YXNlIDE1OglwdHJbMTVdID0gcmVhZF9kZWJ1ZyhyZWcsIDE1KTsJCQlcCisJCQkvKiBGYWxsIHRo
cm91Z2ggKi8JCQkJXAogCWNhc2UgMTQ6CXB0clsxNF0gPSByZWFkX2RlYnVnKHJlZywgMTQpOwkJ
CVwKKwkJCS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlcCiAJY2FzZSAxMzoJcHRyWzEzXSA9IHJlYWRf
ZGVidWcocmVnLCAxMyk7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDEy
OglwdHJbMTJdID0gcmVhZF9kZWJ1ZyhyZWcsIDEyKTsJCQlcCisJCQkvKiBGYWxsIHRocm91Z2gg
Ki8JCQkJXAogCWNhc2UgMTE6CXB0clsxMV0gPSByZWFkX2RlYnVnKHJlZywgMTEpOwkJCVwKKwkJ
CS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlcCiAJY2FzZSAxMDoJcHRyWzEwXSA9IHJlYWRfZGVidWco
cmVnLCAxMCk7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDk6CQlwdHJb
OV0gPSByZWFkX2RlYnVnKHJlZywgOSk7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwK
IAljYXNlIDg6CQlwdHJbOF0gPSByZWFkX2RlYnVnKHJlZywgOCk7CQkJXAorCQkJLyogRmFsbCB0
aHJvdWdoICovCQkJCVwKIAljYXNlIDc6CQlwdHJbN10gPSByZWFkX2RlYnVnKHJlZywgNyk7CQkJ
XAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDY6CQlwdHJbNl0gPSByZWFkX2Rl
YnVnKHJlZywgNik7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDU6CQlw
dHJbNV0gPSByZWFkX2RlYnVnKHJlZywgNSk7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJ
CVwKIAljYXNlIDQ6CQlwdHJbNF0gPSByZWFkX2RlYnVnKHJlZywgNCk7CQkJXAorCQkJLyogRmFs
bCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDM6CQlwdHJbM10gPSByZWFkX2RlYnVnKHJlZywgMyk7
CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDI6CQlwdHJbMl0gPSByZWFk
X2RlYnVnKHJlZywgMik7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDE6
CQlwdHJbMV0gPSByZWFkX2RlYnVnKHJlZywgMSk7CQkJXAorCQkJLyogRmFsbCB0aHJvdWdoICov
CQkJCVwKIAlkZWZhdWx0OglwdHJbMF0gPSByZWFkX2RlYnVnKHJlZywgMCk7CQkJXAogCX0KIAog
I2RlZmluZSByZXN0b3JlX2RlYnVnKHB0cixyZWcsbnIpCQkJCQlcCiAJc3dpdGNoIChucikgewkJ
CQkJCQlcCiAJY2FzZSAxNToJd3JpdGVfZGVidWcocHRyWzE1XSwgcmVnLCAxNSk7CQkJXAorCQkJ
LyogRmFsbCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDE0Ogl3cml0ZV9kZWJ1ZyhwdHJbMTRdLCBy
ZWcsIDE0KTsJCQlcCisJCQkvKiBGYWxsIHRocm91Z2ggKi8JCQkJXAogCWNhc2UgMTM6CXdyaXRl
X2RlYnVnKHB0clsxM10sIHJlZywgMTMpOwkJCVwKKwkJCS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlc
CiAJY2FzZSAxMjoJd3JpdGVfZGVidWcocHRyWzEyXSwgcmVnLCAxMik7CQkJXAorCQkJLyogRmFs
bCB0aHJvdWdoICovCQkJCVwKIAljYXNlIDExOgl3cml0ZV9kZWJ1ZyhwdHJbMTFdLCByZWcsIDEx
KTsJCQlcCisJCQkvKiBGYWxsIHRocm91Z2ggKi8JCQkJXAogCWNhc2UgMTA6CXdyaXRlX2RlYnVn
KHB0clsxMF0sIHJlZywgMTApOwkJCVwKKwkJCS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlcCiAJY2Fz
ZSA5OgkJd3JpdGVfZGVidWcocHRyWzldLCByZWcsIDkpOwkJCVwKKwkJCS8qIEZhbGwgdGhyb3Vn
aCAqLwkJCQlcCiAJY2FzZSA4OgkJd3JpdGVfZGVidWcocHRyWzhdLCByZWcsIDgpOwkJCVwKKwkJ
CS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlcCiAJY2FzZSA3OgkJd3JpdGVfZGVidWcocHRyWzddLCBy
ZWcsIDcpOwkJCVwKKwkJCS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlcCiAJY2FzZSA2OgkJd3JpdGVf
ZGVidWcocHRyWzZdLCByZWcsIDYpOwkJCVwKKwkJCS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlcCiAJ
Y2FzZSA1OgkJd3JpdGVfZGVidWcocHRyWzVdLCByZWcsIDUpOwkJCVwKKwkJCS8qIEZhbGwgdGhy
b3VnaCAqLwkJCQlcCiAJY2FzZSA0OgkJd3JpdGVfZGVidWcocHRyWzRdLCByZWcsIDQpOwkJCVwK
KwkJCS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlcCiAJY2FzZSAzOgkJd3JpdGVfZGVidWcocHRyWzNd
LCByZWcsIDMpOwkJCVwKKwkJCS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlcCiAJY2FzZSAyOgkJd3Jp
dGVfZGVidWcocHRyWzJdLCByZWcsIDIpOwkJCVwKKwkJCS8qIEZhbGwgdGhyb3VnaCAqLwkJCQlc
CiAJY2FzZSAxOgkJd3JpdGVfZGVidWcocHRyWzFdLCByZWcsIDEpOwkJCVwKKwkJCS8qIEZhbGwg
dGhyb3VnaCAqLwkJCQlcCiAJZGVmYXVsdDoJd3JpdGVfZGVidWcocHRyWzBdLCByZWcsIDApOwkJ
CVwKIAl9CiAKLS0gCjIuMjAuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEu
ZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJt
Cg==
