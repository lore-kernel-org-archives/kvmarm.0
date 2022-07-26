Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE370C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 993184C54C;
	Tue, 26 Jul 2022 03:38:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qkk0usQtXaYz; Tue, 26 Jul 2022 03:38:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 45BDF4C545;
	Tue, 26 Jul 2022 03:38:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 85F054C437
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TXyQQbukKRh5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:07 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C2D804C508
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:05 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 f85-20020a253858000000b00670a44473e2so10394940yba.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc:content-transfer-encoding;
 bh=KintJzFkc3fGk0PZThBnEs9+mVIkzS8MGNi7+4hHocM=;
 b=F99U/GyUMm86I5hhUPAEh3i37Efs41f+NjVsXrba2/WKPQPyfrqe2tZkqcM8WLdn4N
 tjoyQVaWZBceiGc+IiYE68nlfbCinUJe03/UFDa39xJ3UpbZdD9kbzr1fXgF94y52jEV
 rS8Lbe7khCJnAGE3uuqPQYZcwfmKGiiahXSgT5hnhAxspgLgUZwx2XcFjsYvNHIlG4TO
 Kz3pafuhE8xSvKeQKTkBbd6h7vha4xx8mVypWM60J3ynB/E+WPGvUVSThWgp4tikyd+6
 meIxa9eGPMfqTbQzFurHAAv657oZE/ifKVL3Y5P3LVWtokWYf79sEL7M95vb7JRmvBTK
 wWkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc:content-transfer-encoding;
 bh=KintJzFkc3fGk0PZThBnEs9+mVIkzS8MGNi7+4hHocM=;
 b=MmdcvogkwaWZfkxut6UwYLtCMFAh0lF90UrpBGzidRKEZGbKuLuUJVBFn5A0XHc//5
 s25BKQsp+iII2lOX3Dd/tU2meXMQD3/QTP6WMW5e+/2+xJb4NGEJ3I/ibe++qTbG0T3c
 ylexzPUJIi/bmvvDHzq1ab3jl//SSnO4XbsMQbfyjn9rb4C5F2OATEx++Nyqr8ldVlMc
 RdG02kbHoL/Bzs/WqfScC/W8jhnoC9gNs/vEkmMFcXjS9uTE/DbFKpK4YT90pABy70KW
 ksOb6BivFWRyHnoVGrdswJCN/oA3vP4eD7jNOU92sWqGryf+0PE6wBiZlnXE1Eh85itv
 bAUA==
X-Gm-Message-State: AJIora9lXqq2s8pkkjGvlVh8p+w/3HRx/OvyVjqp8DiHV7Pr3DM6Enn8
 DcPbIcmzJTi9nWwZrwM421cn+dT9livGfXpCxA==
X-Google-Smtp-Source: AGRyM1tViIgbjsnsd0F2wwzY/mHFi+V+awQaQAAf7taOX+okajo7NRVMTiuzJzRWy3+FHjR02RHuf/ccxOBvmI+klQ==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a25:d796:0:b0:671:6696:d824 with SMTP
 id o144-20020a25d796000000b006716696d824mr3624037ybg.52.1658821085312; Tue,
 26 Jul 2022 00:38:05 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:37 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-5-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 04/17] arm64: stacktrace: Handle frame pointer from
 different address spaces
From: Kalesh Singh <kaleshsingh@google.com>
To: maz@kernel.org, mark.rutland@arm.com, broonie@kernel.org, 
 madvenka@linux.microsoft.com, tabba@google.com, oliver.upton@linux.dev
Cc: wangkefeng.wang@huawei.com, catalin.marinas@arm.com, ast@kernel.org,
 vincenzo.frascino@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 android-mm@google.com, kernel-team@android.com, elver@google.com,
 linux-arm-kernel@lists.infradead.org, andreyknvl@gmail.com,
 linux-kernel@vger.kernel.org, mhiramat@kernel.org
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

VGhlIHVud2luZGVyIGNvZGUgaXMgbWFkZSByZXVzYWJsZSBzbyB0aGF0IGl0IGNhbiBiZSB1c2Vk
IHRvCnVud2luZCB2YXJpb3VzIHR5cGVzIG9mIHN0YWNrcy4gT25lIHVzZWNhc2UgaXMgdW53aW5k
aW5nIHRoZQpuVkhFIGh5cCBzdGFjayBmcm9tIHRoZSBob3N0IChFTDEpIGluIG5vbi1wcm90ZWN0
ZWQgbW9kZS4gVGhpcwptZWFucyB0aGF0IHRoZSB1bndpbmRlciBtdXN0IGJlIGFibGUgdG8gdHJh
bnNsYXRlIEhZUCBzdGFjawphZGRyZXNzZXMgdG8ga2VybmVsIGFkZHJlc3Nlcy4KCkFkZCBhIGNh
bGxiYWNrIChzdGFja190cmFjZV90cmFuc2xhdGVfZnBfZm4pIHRvIGFsbG93IHNwZWNpZnlpbmcK
dGhlIHRyYW5zbGF0aW9uIGZ1bmN0aW9uLgoKU2lnbmVkLW9mZi1ieTogS2FsZXNoIFNpbmdoIDxr
YWxlc2hzaW5naEBnb29nbGUuY29tPgpSZXZpZXdlZC1ieTogRnVhZCBUYWJiYSA8dGFiYmFAZ29v
Z2xlLmNvbT4KVGVzdGVkLWJ5OiBGdWFkIFRhYmJhIDx0YWJiYUBnb29nbGUuY29tPgotLS0KCkNo
YW5nZXMgaW4gdjY6CiAgLSBGaXggdHlwbyBpbiBjb21tZW50LCBwZXIgRnVhZAogIC0gQWRkIEZ1
YWTigJlzIFJldmlld2VkLWJ5IHRhZyBhbmQgVGVzdGVkLWJ5IHRhZ3MKCkNoYW5nZXMgaW4gdjU6
CiAgLSBGaXggdHlwbyBpbiBjb21taXQgdGV4dCwgcGVyIEZ1YWQKICAtIFVwZGF0ZSB1bndpbmRf
bmV4dF9jb21tb24oKSB0byBub3QgaGF2ZSBzaWRlIGVmZmVjdHMgb24gZmFpbHVyZSwgcGVyIEZ1
YWQKICAtIFVzZSByZWd1bGFyIGNvbW1lbnQgaW5zdGVhZCBvZiBkb2MgY29tbWVudHMsIHBlciBG
dWFkCgogYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zdGFja3RyYWNlL2NvbW1vbi5oIHwgMjkgKysr
KysrKysrKysrKysrKysrKy0tLQogYXJjaC9hcm02NC9rZXJuZWwvc3RhY2t0cmFjZS5jICAgICAg
ICAgICAgIHwgIDIgKy0KIDIgZmlsZXMgY2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKSwgNSBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N0YWNrdHJhY2Uv
Y29tbW9uLmggYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N0YWNrdHJhY2UvY29tbW9uLmgKaW5k
ZXggMGM1Y2JmZGI1NmI1Li5iMjQxZWRiYTVjNzYgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQvaW5j
bHVkZS9hc20vc3RhY2t0cmFjZS9jb21tb24uaAorKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNt
L3N0YWNrdHJhY2UvY29tbW9uLmgKQEAgLTEyNCwxMSArMTI0LDI1IEBAIHN0YXRpYyBpbmxpbmUg
dm9pZCB1bndpbmRfaW5pdF9jb21tb24oc3RydWN0IHVud2luZF9zdGF0ZSAqc3RhdGUsCiAJc3Rh
dGUtPnByZXZfdHlwZSA9IFNUQUNLX1RZUEVfVU5LTk9XTjsKIH0KIAorLyoKKyAqIHN0YWNrX3Ry
YWNlX3RyYW5zbGF0ZV9mcF9mbigpIC0gVHJhbnNsYXRlcyBhIG5vbi1rZXJuZWwgZnJhbWUgcG9p
bnRlciB0bworICogYSBrZXJuZWwgYWRkcmVzcy4KKyAqCisgKiBAZnA6ICAgdGhlIGZyYW1lIHBv
aW50ZXIgdG8gYmUgdXBkYXRlZCB0byBpdHMga2VybmVsIGFkZHJlc3MuCisgKiBAdHlwZTogdGhl
IHN0YWNrIHR5cGUgYXNzb2NpYXRlZCB3aXRoIGZyYW1lIHBvaW50ZXIgQGZwCisgKgorICogUmV0
dXJucyB0cnVlIGFuZCBzdWNjZXNzIGFuZCBAZnAgaXMgdXBkYXRlZCB0byB0aGUgY29ycmVzcG9u
ZGluZworICoga2VybmVsIHZpcnR1YWwgYWRkcmVzczsgb3RoZXJ3aXNlIHJldHVybnMgZmFsc2Uu
CisgKi8KK3R5cGVkZWYgYm9vbCAoKnN0YWNrX3RyYWNlX3RyYW5zbGF0ZV9mcF9mbikodW5zaWdu
ZWQgbG9uZyAqZnAsCisJCQkJCSAgICBlbnVtIHN0YWNrX3R5cGUgdHlwZSk7CisKIHN0YXRpYyBp
bmxpbmUgaW50IHVud2luZF9uZXh0X2NvbW1vbihzdHJ1Y3QgdW53aW5kX3N0YXRlICpzdGF0ZSwK
LQkJCQkgICAgIHN0cnVjdCBzdGFja19pbmZvICppbmZvKQorCQkJCSAgICAgc3RydWN0IHN0YWNr
X2luZm8gKmluZm8sCisJCQkJICAgICBzdGFja190cmFjZV90cmFuc2xhdGVfZnBfZm4gdHJhbnNs
YXRlX2ZwKQogeworCXVuc2lnbmVkIGxvbmcgZnAgPSBzdGF0ZS0+ZnAsIGtlcm5fZnAgPSBmcDsK
IAlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRzayA9IHN0YXRlLT50YXNrOwotCXVuc2lnbmVkIGxvbmcg
ZnAgPSBzdGF0ZS0+ZnA7CiAKIAlpZiAoZnAgJiAweDcpCiAJCXJldHVybiAtRUlOVkFMOwpAQCAt
MTM5LDYgKzE1MywxMyBAQCBzdGF0aWMgaW5saW5lIGludCB1bndpbmRfbmV4dF9jb21tb24oc3Ry
dWN0IHVud2luZF9zdGF0ZSAqc3RhdGUsCiAJaWYgKHRlc3RfYml0KGluZm8tPnR5cGUsIHN0YXRl
LT5zdGFja3NfZG9uZSkpCiAJCXJldHVybiAtRUlOVkFMOwogCisJLyoKKwkgKiBJZiBmcCBpcyBu
b3QgZnJvbSB0aGUgY3VycmVudCBhZGRyZXNzIHNwYWNlIHBlcmZvcm0gdGhlIG5lY2Vzc2FyeQor
CSAqIHRyYW5zbGF0aW9uIGJlZm9yZSBkZXJlZmVyZW5jaW5nIGl0IHRvIGdldCB0aGUgbmV4dCBm
cC4KKwkgKi8KKwlpZiAodHJhbnNsYXRlX2ZwICYmICF0cmFuc2xhdGVfZnAoJmtlcm5fZnAsIGlu
Zm8tPnR5cGUpKQorCQlyZXR1cm4gLUVJTlZBTDsKKwogCS8qCiAJICogQXMgc3RhY2tzIGdyb3cg
ZG93bndhcmQsIGFueSB2YWxpZCByZWNvcmQgb24gdGhlIHNhbWUgc3RhY2sgbXVzdCBiZQogCSAq
IGF0IGEgc3RyaWN0bHkgaGlnaGVyIGFkZHJlc3MgdGhhbiB0aGUgcHJpb3IgcmVjb3JkLgpAQCAt
MTYzLDggKzE4NCw4IEBAIHN0YXRpYyBpbmxpbmUgaW50IHVud2luZF9uZXh0X2NvbW1vbihzdHJ1
Y3QgdW53aW5kX3N0YXRlICpzdGF0ZSwKIAkgKiBSZWNvcmQgdGhpcyBmcmFtZSByZWNvcmQncyB2
YWx1ZXMgYW5kIGxvY2F0aW9uLiBUaGUgcHJldl9mcCBhbmQKIAkgKiBwcmV2X3R5cGUgYXJlIG9u
bHkgbWVhbmluZ2Z1bCB0byB0aGUgbmV4dCB1bndpbmRfbmV4dCgpIGludm9jYXRpb24uCiAJICov
Ci0Jc3RhdGUtPmZwID0gUkVBRF9PTkNFKCoodW5zaWduZWQgbG9uZyAqKShmcCkpOwotCXN0YXRl
LT5wYyA9IFJFQURfT05DRSgqKHVuc2lnbmVkIGxvbmcgKikoZnAgKyA4KSk7CisJc3RhdGUtPmZw
ID0gUkVBRF9PTkNFKCoodW5zaWduZWQgbG9uZyAqKShrZXJuX2ZwKSk7CisJc3RhdGUtPnBjID0g
UkVBRF9PTkNFKCoodW5zaWduZWQgbG9uZyAqKShrZXJuX2ZwICsgOCkpOwogCXN0YXRlLT5wcmV2
X2ZwID0gZnA7CiAJc3RhdGUtPnByZXZfdHlwZSA9IGluZm8tPnR5cGU7CiAKZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQva2VybmVsL3N0YWNrdHJhY2UuYyBiL2FyY2gvYXJtNjQva2VybmVsL3N0YWNr
dHJhY2UuYwppbmRleCA4MzQ4NTE5MzkzNjQuLmVlZjNjZjZiZjJkNyAxMDA2NDQKLS0tIGEvYXJj
aC9hcm02NC9rZXJuZWwvc3RhY2t0cmFjZS5jCisrKyBiL2FyY2gvYXJtNjQva2VybmVsL3N0YWNr
dHJhY2UuYwpAQCAtODcsNyArODcsNyBAQCBzdGF0aWMgaW50IG5vdHJhY2UgdW53aW5kX25leHQo
c3RydWN0IHVud2luZF9zdGF0ZSAqc3RhdGUpCiAJaWYgKGZwID09ICh1bnNpZ25lZCBsb25nKXRh
c2tfcHRfcmVncyh0c2spLT5zdGFja2ZyYW1lKQogCQlyZXR1cm4gLUVOT0VOVDsKIAotCWVyciA9
IHVud2luZF9uZXh0X2NvbW1vbihzdGF0ZSwgJmluZm8pOworCWVyciA9IHVud2luZF9uZXh0X2Nv
bW1vbihzdGF0ZSwgJmluZm8sIE5VTEwpOwogCWlmIChlcnIpCiAJCXJldHVybiBlcnI7CiAKLS0g
CjIuMzcuMS4zNTkuZ2QxMzZjNmMzZTItZ29vZwoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
