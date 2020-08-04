Return-Path: <SRS0=bLIx=BO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B42C433DF
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 12:44:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 180432067D
	for <kvmarm@archiver.kernel.org>; Tue,  4 Aug 2020 12:44:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T8YDxwS+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 180432067D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BFA324B7D2;
	Tue,  4 Aug 2020 08:44:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K-KrwoNHl5AO; Tue,  4 Aug 2020 08:44:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72C454B7B2;
	Tue,  4 Aug 2020 08:44:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 019794B731
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 08:44:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ou-FVka-eq2C for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2020 08:44:24 -0400 (EDT)
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com
 [209.85.128.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8EF3E4B6C9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2020 08:44:23 -0400 (EDT)
Received: by mail-wm1-f66.google.com with SMTP id p14so2550425wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Aug 2020 05:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=bN3d8Ia77BH2nBiHDQ6zBNPByWQO01hAGf1Nc3k/FjU=;
 b=T8YDxwS+GAi/l87EqEDVnHA6L2vWdoJLRomogp4zswguktwRhtfY6a3S80oC+la+7Y
 uBOGZPkWUazcUyhEPQsfO3QZ16muTbOfxNxa4uXdYwfXdmkfVzoMRSW4m/T7f0i4RLf7
 dX+k8C7kUSi09yoGq/WkXRUuQWQIUOu80qSJ8B9K9QLhl5toYoFUrNUqUcTwdRw8GrmH
 fMUA0SnmjEveRBv57i02a+TxYyxNXCrEDBzYs7JuFuOONWrjDdCFY0ND5r47wpeLc24V
 fJMl0bur8BNgusZj++pQeoEnXBDmf1q7b4PbFj3Wzq0ri29fof8CCFp8ai4icK9pDdY1
 JhtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=bN3d8Ia77BH2nBiHDQ6zBNPByWQO01hAGf1Nc3k/FjU=;
 b=P3IJ1A33e/Av5cvyZfQkcCkv4LyyP5DBH/2IsaZJ0Z0R5JFwV4JOJqcuxAkultJYML
 XGd/36zdm7E/B4d3opdKHyTpwDvyfe7hiwktNk/k0vGFQNN4goA0rnQ7XFnOR12q6qtW
 dQ/m3T0oSBL+too+0E7dE1HHROxbCaZkkyxHxU5jAVnaNn+2SuAlLniOZf4l5g2z9qid
 Sqw5rdauW9oxJKy4Dm+ptjwgjCMh7/TORaNRvQNvuEgzYtZpXMqPHP5gCPey81EiTFJi
 jWVnjRMWzt8frD7lPH9Uw/IkWJPmQSR5nmleO5cpoIAxTseXqrDkga5iDqh96EHRydZY
 FSDg==
X-Gm-Message-State: AOAM53116w4VUu8K65pYJ2vTO/rGXelx/jrLYLhDLwji4AB9ER6YCIKU
 Q2xzkJEC1/U9S2Rkxw/v1KtsVQ==
X-Google-Smtp-Source: ABdhPJz9A0fUr0s+57vaSQaPT8GQEVwMIBWtT6cib6RQGYxAGZypLJ4R2NHV8/yEEKGRo0R1n0bqCQ==
X-Received: by 2002:a7b:c257:: with SMTP id b23mr3829607wmj.164.1596545062751; 
 Tue, 04 Aug 2020 05:44:22 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id b137sm4843577wmb.9.2020.08.04.05.44.18
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 04 Aug 2020 05:44:18 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 860581FF87;
 Tue,  4 Aug 2020 13:44:17 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v1 1/3] arm64: allow de-selection of ThunderX PCI controllers
Date: Tue,  4 Aug 2020 13:44:15 +0100
Message-Id: <20200804124417.27102-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200804124417.27102-1-alex.bennee@linaro.org>
References: <20200804124417.27102-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Cc: maz@kernel.org, linux-kernel@vger.kernel.org,
 Robert Richter <rrichter@marvell.com>, linux-pci@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
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

Rm9yIGEgcHVyZSBWaXJ0SU8gZ3Vlc3QgYnJpbmdpbmcgaW4gYWxsIHRoZSBQQ0kgcXVpcmsgaGFu
ZGxpbmcgYWRkcyBhCnNpZ25pZmljYW50IGFtb3VudCBvZiBibG9hdCB0byBrZXJuZWwgd2UgZG9u
J3QgbmVlZC4gU29sdmUgdGhpcyBieQphZGRpbmcgYSBDT05GSUcgc3ltYm9sIGZvciB0aGUgVGh1
bmRlclggUENJIGRldmljZXMgYW5kIGFsbG93aW5nIGl0IHRvCmJlIHR1cm5lZCBvZmYuIFNhdmlu
ZyBvdmVyIDMwMGsgZnJvbSB0aGUgdW5jb21wcmVzc2VkIHZtbGludXg6CgogIC1yd3hyLXhyLXgg
MSBhbGV4IGFsZXggIDg1NjUyNDcyIEF1ZyAgMyAxNjo0OCB2bWxpbnV4KgogIC1yd3hyLXhyLXgg
MSBhbGV4IGFsZXggIDg2MDMzODgwIEF1ZyAgMyAxNjozOSB2bWxpbnV4Lm9yaWcqCgpTaWduZWQt
b2ZmLWJ5OiBBbGV4IEJlbm7DqWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+CkNjOiBSb2JlcnQg
UmljaHRlciA8cnJpY2h0ZXJAbWFydmVsbC5jb20+CkNjOiBsaW51eC1wY2lAdmdlci5rZXJuZWwu
b3JnCkNjOiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcKLS0tCiBhcmNoL2Fy
bTY0L0tjb25maWcucGxhdGZvcm1zICAgIHwgMiArKwogYXJjaC9hcm02NC9jb25maWdzL2RlZmNv
bmZpZyAgICB8IDEgKwogZHJpdmVycy9wY2kvY29udHJvbGxlci9LY29uZmlnICB8IDcgKysrKysr
KwogZHJpdmVycy9wY2kvY29udHJvbGxlci9NYWtlZmlsZSB8IDQgKystLQogNCBmaWxlcyBjaGFu
Z2VkLCAxMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQvS2NvbmZpZy5wbGF0Zm9ybXMgYi9hcmNoL2FybTY0L0tjb25maWcucGxhdGZvcm1zCmlu
ZGV4IDhkZDA1YjJhOTI1Yy4uYTMyOGVlYmRhYTU5IDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L0tj
b25maWcucGxhdGZvcm1zCisrKyBiL2FyY2gvYXJtNjQvS2NvbmZpZy5wbGF0Zm9ybXMKQEAgLTI1
MywxMiArMjUzLDE0IEBAIGNvbmZpZyBBUkNIX1NQUkQKIAogY29uZmlnIEFSQ0hfVEhVTkRFUgog
CWJvb2wgIkNhdml1bSBJbmMuIFRodW5kZXIgU29DIEZhbWlseSIKKyAgICAgICAgc2VsZWN0IFBD
SV9USFVOREVSCiAJaGVscAogCSAgVGhpcyBlbmFibGVzIHN1cHBvcnQgZm9yIENhdml1bSdzIFRo
dW5kZXIgRmFtaWx5IG9mIFNvQ3MuCiAKIGNvbmZpZyBBUkNIX1RIVU5ERVIyCiAJYm9vbCAiQ2F2
aXVtIFRodW5kZXJYMiBTZXJ2ZXIgUHJvY2Vzc29ycyIKIAlzZWxlY3QgR1BJT0xJQgorICAgICAg
ICBzZWxlY3QgUENJX1RIVU5ERVIKIAloZWxwCiAJICBUaGlzIGVuYWJsZXMgc3VwcG9ydCBmb3Ig
Q2F2aXVtJ3MgVGh1bmRlclgyIENOOTlYWCBmYW1pbHkgb2YKIAkgIHNlcnZlciBwcm9jZXNzb3Jz
LgpkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9jb25maWdzL2RlZmNvbmZpZyBiL2FyY2gvYXJtNjQv
Y29uZmlncy9kZWZjb25maWcKaW5kZXggMmNhN2JhNjljMzE4Li5kODQwY2JhOTk5NDEgMTAwNjQ0
Ci0tLSBhL2FyY2gvYXJtNjQvY29uZmlncy9kZWZjb25maWcKKysrIGIvYXJjaC9hcm02NC9jb25m
aWdzL2RlZmNvbmZpZwpAQCAtMTk5LDYgKzE5OSw3IEBAIENPTkZJR19QQ0lfSE9TVF9HRU5FUklD
PXkKIENPTkZJR19QQ0lfWEdFTkU9eQogQ09ORklHX1BDSUVfQUxURVJBPXkKIENPTkZJR19QQ0lF
X0FMVEVSQV9NU0k9eQorQ09ORklHX1BDSV9USFVOREVSPXkKIENPTkZJR19QQ0lfSE9TVF9USFVO
REVSX1BFTT15CiBDT05GSUdfUENJX0hPU1RfVEhVTkRFUl9FQ0FNPXkKIENPTkZJR19QQ0lFX1JP
Q0tDSElQX0hPU1Q9bQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wY2kvY29udHJvbGxlci9LY29uZmln
IGIvZHJpdmVycy9wY2kvY29udHJvbGxlci9LY29uZmlnCmluZGV4IGFkZGRmMjFmYTM4MS4uMjgz
MzVmZmE1ZDQ4IDEwMDY0NAotLS0gYS9kcml2ZXJzL3BjaS9jb250cm9sbGVyL0tjb25maWcKKysr
IGIvZHJpdmVycy9wY2kvY29udHJvbGxlci9LY29uZmlnCkBAIC0yODYsNiArMjg2LDEzIEBAIGNv
bmZpZyBQQ0lfTE9PTkdTT04KIAkgIFNheSBZIGhlcmUgaWYgeW91IHdhbnQgdG8gZW5hYmxlIFBD
SSBjb250cm9sbGVyIHN1cHBvcnQgb24KIAkgIExvb25nc29uIHN5c3RlbXMuCiAKK2NvbmZpZyBQ
Q0lfVEhVTkRFUgorICAgICAgIGJvb2wgIlRodW5kZXIgWCBQQ0lFIGNvbnRyb2xsZXJzIgorICAg
ICAgIGRlcGVuZHMgb24gQVJNNjQKKyAgICAgICBzZWxlY3QgUENJX1FVSVJLUworICAgICAgIGhl
bHAKKyAgICAgICAgICBTYXkgWSBoZXJlIHRvIGVuYWJsZSBUaHVuZGVyWCBFQ0FNIGFuZCBQRU0g
UENJIGNvbnRyb2xsZXJzLgorCiBzb3VyY2UgImRyaXZlcnMvcGNpL2NvbnRyb2xsZXIvZHdjL0tj
b25maWciCiBzb3VyY2UgImRyaXZlcnMvcGNpL2NvbnRyb2xsZXIvbW9iaXZlaWwvS2NvbmZpZyIK
IHNvdXJjZSAiZHJpdmVycy9wY2kvY29udHJvbGxlci9jYWRlbmNlL0tjb25maWciCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3BjaS9jb250cm9sbGVyL01ha2VmaWxlIGIvZHJpdmVycy9wY2kvY29udHJv
bGxlci9NYWtlZmlsZQppbmRleCBlZmQ5NzMzZWFkMjYuLjhmYWQ0NzgxYTVkMyAxMDA2NDQKLS0t
IGEvZHJpdmVycy9wY2kvY29udHJvbGxlci9NYWtlZmlsZQorKysgYi9kcml2ZXJzL3BjaS9jb250
cm9sbGVyL01ha2VmaWxlCkBAIC00NSw4ICs0NSw4IEBAIG9iai15CQkJCSs9IG1vYml2ZWlsLwog
IyBBUk02NCBhbmQgdXNlIGludGVybmFsIGlmZGVmcyB0byBvbmx5IGJ1aWxkIHRoZSBwaWVjZXMg
d2UgbmVlZAogIyBkZXBlbmRpbmcgb24gd2hldGhlciBBQ1BJLCB0aGUgRFQgZHJpdmVyLCBvciBi
b3RoIGFyZSBlbmFibGVkLgogCitvYmotJChDT05GSUdfUENJX1RIVU5ERVIpICs9IHBjaS10aHVu
ZGVyLWVjYW0ubworb2JqLSQoQ09ORklHX1BDSV9USFVOREVSKSArPSBwY2ktdGh1bmRlci1wZW0u
bwogaWZkZWYgQ09ORklHX1BDSQotb2JqLSQoQ09ORklHX0FSTTY0KSArPSBwY2ktdGh1bmRlci1l
Y2FtLm8KLW9iai0kKENPTkZJR19BUk02NCkgKz0gcGNpLXRodW5kZXItcGVtLm8KIG9iai0kKENP
TkZJR19BUk02NCkgKz0gcGNpLXhnZW5lLm8KIGVuZGlmCi0tIAoyLjIwLjEKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
