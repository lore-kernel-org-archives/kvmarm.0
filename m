Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40353C433ED
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 10:18:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A69A261436
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 10:18:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A69A261436
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 389974B23F;
	Wed, 28 Apr 2021 06:18:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id klQjPfKCvpsT; Wed, 28 Apr 2021 06:18:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E7384B241;
	Wed, 28 Apr 2021 06:18:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 204C64B22E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 06:18:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id asMZN9WExlF2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 06:18:50 -0400 (EDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF4AA4B22D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 06:18:49 -0400 (EDT)
Received: by mail-wm1-f47.google.com with SMTP id
 p6-20020a05600c3586b029014131bbe5c7so5605561wmq.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 03:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=from:to:cc:subject:date:message-id:in-reply-to:references
 :mime-version:content-transfer-encoding;
 bh=W/65gl/q8IPHxxfmkIEqzGwlIffS1aBvU9xDbEnZyHM=;
 b=SSrrTtwZJ02Zr0JA6NRj0GmP0uyFPOUSFabhokoV6Sy5GNCyllTC4VWQMLE81igmUe
 Wh0Vi6utYveAA/fpekiI7G8ty768Nqo3K2LOp81FzggyzgrXoRp1v5KCSAMdAMjCuyuX
 r9IM1GiXmva9cV/s22qi9+5GmGGbvx5LX8EDykKoW42J+NlR2k9rKWnZXSzadxTkzeUd
 8J/bswhnJIBlc10SW99J5bPaBrR8JUigyAKh1GY1S03X1swxtLM4p+pB0ZXIwfxYh19v
 CSzoeIhOjW5U/V0rLWA1tjAH0VlGLBK6V5mrPM0R1DcsKn2suEmABcoaH6S5DiU8qNgM
 REDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=W/65gl/q8IPHxxfmkIEqzGwlIffS1aBvU9xDbEnZyHM=;
 b=BgxRkDCjSCEOcm8t+uq4Xfws7s6aQQT1DMn5OmeRbEFnKw20KuK/EuFxCfGSWYhsDu
 +s29Ai6Pv6kCnEnW8AmSOT7y9rjodRdUDQ0AMvZYTSSzMxNVG2hrEdI5uU7Qa9mA0ByF
 eDx9L9LLV3nv97LVJOZurorSOrlTOr+7EAHifs6MGvMRQVTI5VmiozmzAWEMZFvHS36G
 cmbeOzMpOWEVbR6Fmy3b+qN2Z7bTbwbrE9fWTpFf10CK3GSIzlftwPBpPR679BJCTpGK
 J9dXsrpyLo08PG1wOryDDgPpG+d339fQ4Itl310Ez8yZyWVlxxNW6th4Q92r3DDDthY8
 pQ1g==
X-Gm-Message-State: AOAM530+eUHwhcHFD8cdek2Ooa8UYgwdr4/8NJ9G1YtxyMZY3of47XGp
 FM5YRPme8dnKQzue7d4RMXabqg==
X-Google-Smtp-Source: ABdhPJxRO3MjPBAuuf7/5yeRHIOMTjCLbzPgeFWy3MG9Ge5F6gbUkBS3K7ic1Vpc5z70bIjpSShKyA==
X-Received: by 2002:a7b:cd85:: with SMTP id y5mr3586309wmj.93.1619605129193;
 Wed, 28 Apr 2021 03:18:49 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id b14sm7950544wrf.75.2021.04.28.03.18.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 28 Apr 2021 03:18:44 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 27D401FF87;
 Wed, 28 Apr 2021 11:18:44 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v1 1/4] arm64: split its-trigger test into KVM
 and TCG variants
Date: Wed, 28 Apr 2021 11:18:41 +0100
Message-Id: <20210428101844.22656-2-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210428101844.22656-1-alex.bennee@linaro.org>
References: <20210428101844.22656-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Cc: maz@kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
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

QSBmZXcgb2YgdGhlIGl0cy10cmlnZ2VyIHRlc3RzIHJlbHkgb24gSU1QREVGIGJlaGF2aW91ciB3
aGVyZSBjYWNoZXMKYXJlbid0IGZsdXNoZWQgYmVmb3JlIGludmFsbCBldmVudHMuIEhvd2V2ZXIg
VENHIGVtdWxhdGlvbiBkb2Vzbid0Cm1vZGVsIGFueSBpbnZhbGwgYmVoYXZpb3VyIGFuZCBhcyB3
ZSBjYW4ndCBwcm9iZSBmb3IgaXQgd2UgbmVlZCB0byBiZQp0b2xkLiBTcGxpdCB0aGUgdGVzdCBp
bnRvIGEgS1ZNIGFuZCBUQ0cgdmFyaWFudCBhbmQgc2tpcCB0aGUgaW52YWxsCnRlc3RzIHdoZW4g
dW5kZXIgVENHLgoKU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5h
cm8ub3JnPgpDYzogU2hhc2hpIE1hbGxlbGEgPHNoYXNoaS5tYWxsZWxhQGxpbmFyby5vcmc+Ci0t
LQogYXJtL2dpYy5jICAgICAgICAgfCA2MCArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0t
LS0tLS0tLS0tLS0tLS0tLQogYXJtL3VuaXR0ZXN0cy5jZmcgfCAxMSArKysrKysrKy0KIDIgZmls
ZXMgY2hhbmdlZCwgNDUgaW5zZXJ0aW9ucygrKSwgMjYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvYXJtL2dpYy5jIGIvYXJtL2dpYy5jCmluZGV4IDk4MTM1ZWYuLjk2YTMyOWQgMTAwNjQ0Ci0t
LSBhL2FybS9naWMuYworKysgYi9hcm0vZ2ljLmMKQEAgLTM2LDYgKzM2LDcgQEAgc3RhdGljIHN0
cnVjdCBnaWMgKmdpYzsKIHN0YXRpYyBpbnQgYWNrZWRbTlJfQ1BVU10sIHNwdXJpb3VzW05SX0NQ
VVNdOwogc3RhdGljIGludCBpcnFfc2VuZGVyW05SX0NQVVNdLCBpcnFfbnVtYmVyW05SX0NQVVNd
Owogc3RhdGljIGNwdW1hc2tfdCByZWFkeTsKK3N0YXRpYyBib29sIHVuZGVyX3RjZzsKIAogc3Rh
dGljIHZvaWQgbnJfY3B1X2NoZWNrKGludCBucikKIHsKQEAgLTczNCwzMiArNzM1LDM4IEBAIHN0
YXRpYyB2b2lkIHRlc3RfaXRzX3RyaWdnZXIodm9pZCkKIAkvKgogCSAqIHJlLWVuYWJsZSB0aGUg
TFBJIGJ1dCB3aWxsaW5nbHkgZG8gbm90IGNhbGwgaW52YWxsCiAJICogc28gdGhlIGNoYW5nZSBp
biBjb25maWcgaXMgbm90IHRha2VuIGludG8gYWNjb3VudC4KLQkgKiBUaGUgTFBJIHNob3VsZCBu
b3QgaGl0CisJICogVGhlIExQSSBzaG91bGQgbm90IGhpdC4gVGhpcyBkb2VzIGhvd2V2ZXIgZGVw
ZW5kIG9uCisJICogaW1wbGVtZW50YXRpb24gZGVmaW5lZCBiZWhhdmlvdXIgLSB1bmRlciBRRU1V
IFRDRyBlbXVsYXRpb24KKwkgKiBpdCBjYW4gcXVpdGUgY29ycmVjdGx5IHByb2Nlc3MgdGhlIGV2
ZW50IGRpcmVjdGx5LgogCSAqLwotCWdpY3YzX2xwaV9zZXRfY29uZmlnKDgxOTUsIExQSV9QUk9Q
X0RFRkFVTFQpOwotCXN0YXRzX3Jlc2V0KCk7Ci0JY3B1bWFza19jbGVhcigmbWFzayk7Ci0JaXRz
X3NlbmRfaW50KGRldjIsIDIwKTsKLQl3YWl0X2Zvcl9pbnRlcnJ1cHRzKCZtYXNrKTsKLQlyZXBv
cnQoY2hlY2tfYWNrZWQoJm1hc2ssIC0xLCAtMSksCi0JCQkiZGV2Mi9ldmVudGlkPTIwIHN0aWxs
IGRvZXMgbm90IHRyaWdnZXIgYW55IExQSSIpOwotCi0JLyogTm93IGNhbGwgdGhlIGludmFsbCBh
bmQgY2hlY2sgdGhlIExQSSBoaXRzICovCi0Jc3RhdHNfcmVzZXQoKTsKLQljcHVtYXNrX2NsZWFy
KCZtYXNrKTsKLQljcHVtYXNrX3NldF9jcHUoMywgJm1hc2spOwotCWl0c19zZW5kX2ludmFsbChj
b2wzKTsKLQl3YWl0X2Zvcl9pbnRlcnJ1cHRzKCZtYXNrKTsKLQlyZXBvcnQoY2hlY2tfYWNrZWQo
Jm1hc2ssIDAsIDgxOTUpLAotCQkJImRldjIvZXZlbnRpZD0yMCBwZW5kaW5nIExQSSBpcyByZWNl
aXZlZCIpOwotCi0Jc3RhdHNfcmVzZXQoKTsKLQljcHVtYXNrX2NsZWFyKCZtYXNrKTsKLQljcHVt
YXNrX3NldF9jcHUoMywgJm1hc2spOwotCWl0c19zZW5kX2ludChkZXYyLCAyMCk7Ci0Jd2FpdF9m
b3JfaW50ZXJydXB0cygmbWFzayk7Ci0JcmVwb3J0KGNoZWNrX2Fja2VkKCZtYXNrLCAwLCA4MTk1
KSwKLQkJCSJkZXYyL2V2ZW50aWQ9MjAgbm93IHRyaWdnZXJzIGFuIExQSSIpOworCWlmICh1bmRl
cl90Y2cpIHsKKwkJcmVwb3J0X3NraXAoImNoZWNraW5nIExQSSB0cmlnZ2VycyB3aXRob3V0IGlu
dmFsbCIpOworCX0gZWxzZSB7CisJCWdpY3YzX2xwaV9zZXRfY29uZmlnKDgxOTUsIExQSV9QUk9Q
X0RFRkFVTFQpOworCQlzdGF0c19yZXNldCgpOworCQljcHVtYXNrX2NsZWFyKCZtYXNrKTsKKwkJ
aXRzX3NlbmRfaW50KGRldjIsIDIwKTsKKwkJd2FpdF9mb3JfaW50ZXJydXB0cygmbWFzayk7CisJ
CXJlcG9ydChjaGVja19hY2tlZCgmbWFzaywgLTEsIC0xKSwKKwkJICAgICAgICJkZXYyL2V2ZW50
aWQ9MjAgc3RpbGwgZG9lcyBub3QgdHJpZ2dlciBhbnkgTFBJIik7CisKKwkJLyogTm93IGNhbGwg
dGhlIGludmFsbCBhbmQgY2hlY2sgdGhlIExQSSBoaXRzICovCisJCXN0YXRzX3Jlc2V0KCk7CisJ
CWNwdW1hc2tfY2xlYXIoJm1hc2spOworCQljcHVtYXNrX3NldF9jcHUoMywgJm1hc2spOworCQlp
dHNfc2VuZF9pbnZhbGwoY29sMyk7CisJCXdhaXRfZm9yX2ludGVycnVwdHMoJm1hc2spOworCQly
ZXBvcnQoY2hlY2tfYWNrZWQoJm1hc2ssIDAsIDgxOTUpLAorCQkgICAgICAgImRldjIvZXZlbnRp
ZD0yMCBwZW5kaW5nIExQSSBpcyByZWNlaXZlZCIpOworCisJCXN0YXRzX3Jlc2V0KCk7CisJCWNw
dW1hc2tfY2xlYXIoJm1hc2spOworCQljcHVtYXNrX3NldF9jcHUoMywgJm1hc2spOworCQlpdHNf
c2VuZF9pbnQoZGV2MiwgMjApOworCQl3YWl0X2Zvcl9pbnRlcnJ1cHRzKCZtYXNrKTsKKwkJcmVw
b3J0KGNoZWNrX2Fja2VkKCZtYXNrLCAwLCA4MTk1KSwKKwkJICAgICAgICJkZXYyL2V2ZW50aWQ9
MjAgbm93IHRyaWdnZXJzIGFuIExQSSIpOworCX0KIAogCXJlcG9ydF9wcmVmaXhfcG9wKCk7CiAK
QEAgLTk4MSw2ICs5ODgsOSBAQCBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCiAJaWYg
KGFyZ2MgPCAyKQogCQlyZXBvcnRfYWJvcnQoIm5vIHRlc3Qgc3BlY2lmaWVkIik7CiAKKwlpZiAo
YXJnYyA9PSAzICYmIHN0cmNtcChhcmd2WzJdLCAidGNnIikgPT0gMCkKKwkJdW5kZXJfdGNnID0g
dHJ1ZTsKKwogCWlmIChzdHJjbXAoYXJndlsxXSwgImlwaSIpID09IDApIHsKIAkJcmVwb3J0X3By
ZWZpeF9wdXNoKGFyZ3ZbMV0pOwogCQlucl9jcHVfY2hlY2soMik7CmRpZmYgLS1naXQgYS9hcm0v
dW5pdHRlc3RzLmNmZyBiL2FybS91bml0dGVzdHMuY2ZnCmluZGV4IGY3NzZiNjYuLmM3MmRjMzQg
MTAwNjQ0Ci0tLSBhL2FybS91bml0dGVzdHMuY2ZnCisrKyBiL2FybS91bml0dGVzdHMuY2ZnCkBA
IC0xODQsMTMgKzE4NCwyMiBAQCBleHRyYV9wYXJhbXMgPSAtbWFjaGluZSBnaWMtdmVyc2lvbj0z
IC1hcHBlbmQgJ2l0cy1pbnRyb3NwZWN0aW9uJwogZ3JvdXBzID0gaXRzCiBhcmNoID0gYXJtNjQK
IAotW2l0cy10cmlnZ2VyXQorW2l0cy10cmlnZ2VyLWt2bV0KIGZpbGUgPSBnaWMuZmxhdAogc21w
ID0gJE1BWF9TTVAKK2FjY2VsID0ga3ZtCiBleHRyYV9wYXJhbXMgPSAtbWFjaGluZSBnaWMtdmVy
c2lvbj0zIC1hcHBlbmQgJ2l0cy10cmlnZ2VyJwogZ3JvdXBzID0gaXRzCiBhcmNoID0gYXJtNjQK
IAorW2l0cy10cmlnZ2VyLXRjZ10KK2ZpbGUgPSBnaWMuZmxhdAorc21wID0gJE1BWF9TTVAKK2Fj
Y2VsID0gdGNnCitleHRyYV9wYXJhbXMgPSAtbWFjaGluZSBnaWMtdmVyc2lvbj0zIC1hcHBlbmQg
J2l0cy10cmlnZ2VyIHRjZycKK2dyb3VwcyA9IGl0cworYXJjaCA9IGFybTY0CisKIFtpdHMtbWln
cmF0aW9uXQogZmlsZSA9IGdpYy5mbGF0CiBzbXAgPSAkTUFYX1NNUAotLSAKMi4yMC4xCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
