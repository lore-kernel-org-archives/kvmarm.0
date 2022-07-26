Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6554BC43334
	for <kvmarm@archiver.kernel.org>; Tue, 26 Jul 2022 07:38:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E5C64C543;
	Tue, 26 Jul 2022 03:38:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mde4mXUIik99; Tue, 26 Jul 2022 03:38:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D24C24C545;
	Tue, 26 Jul 2022 03:38:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 350EA4C53A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id b-oXGesyFbye for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jul 2022 03:38:32 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F083F4C54A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 03:38:29 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31f3a3b8c17so21033937b3.23
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jul 2022 00:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc:content-transfer-encoding;
 bh=xrCZ3JDmoRPruDDfTE2MIoljy3aPp6Mt1Jsyf41HvKw=;
 b=m6IsAPXeraH4sveiwup4g2zagtiCTkNBAzqv8fgM0IoJl7hrB2JzWnIspy1lIY7osA
 NzAq3F6sO2d8uqWMdVFrS63sBkmLaYviVNj7S5bFoNxZW4aM3kSxz16b2fsJs1wHVodj
 XYTsyXv2EdLxUTOBL2TRNlpw2hv5izPXRxd/Z8NCB05ZO1KoHvjIeAKzQ/wCMrPfIjkF
 CwDZjSNE4xTOp8O6+44f6VUzoPj0PPtSHzUMylIR6Z8gIUsJG12CccrP3jvNWY5L6ovS
 GpZRrij++WgXDPzUdF+AuJ2mJkEU3GESYnoDG1tN06qjgOizHU6Q+SpIz3jEcMDcit9j
 EyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc:content-transfer-encoding;
 bh=xrCZ3JDmoRPruDDfTE2MIoljy3aPp6Mt1Jsyf41HvKw=;
 b=CvktUQRbz2NG+ebIcN4TaZ21B+GAXLjxEhMqqv0vlYXih8Fl+eHiT8ILjPDW+1Q/WH
 IaRzURC85AAAY0bp07TKJNXgewlFy4txG4VbwRwQEw/MrnVWw4TTN9LoxzqKWmlimL7X
 2TiwkjWgkYnC1MkSClh/A3E++OlnTJ5G8r3tqAkkCL6CKmUHIJtNj1GxVZqRiQa/h+1y
 pZ5CN2nuE6dXTUm5Bk1ud52RMdyP1fTaOyTlvbnJZ8R7xxSjjR6dtzXM3qYt6ePUqE0g
 Oh4zKUWM2Y0nY97wSf1HJgR9Xsy7+7ZUU6HSz8nf2QWQe1ETkDAvMgp8kuEBWpl2DfOx
 T2Ow==
X-Gm-Message-State: AJIora+vkioi2IVfcSOIxF6v0tXbBUVxDT4Y6jbk0gSWIztHdr+w/sKP
 KkCfZtJamvf+ZVa089CPJtFiJ4BthAf5iccwvw==
X-Google-Smtp-Source: AGRyM1tNxOOKtnk6pZWo0eI8iYyyinuUNbf8mMV5eXM2bUjJGrThxUTbi7FD+57/XnORNw3Rkfp420sRl8CYsBg42g==
X-Received: from kaleshsingh.mtv.corp.google.com
 ([2620:15c:211:200:4f77:3b64:736a:394e])
 (user=kaleshsingh job=sendgmr) by 2002:a05:6902:1542:b0:66e:e116:95b8 with
 SMTP id r2-20020a056902154200b0066ee11695b8mr12799119ybu.218.1658821109572;
 Tue, 26 Jul 2022 00:38:29 -0700 (PDT)
Date: Tue, 26 Jul 2022 00:37:47 -0700
In-Reply-To: <20220726073750.3219117-1-kaleshsingh@google.com>
Message-Id: <20220726073750.3219117-15-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20220726073750.3219117-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v6 14/17] KVM: arm64: Stub implementation of pKVM HYP stack
 unwinder
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

QWRkIHNvbWUgc3R1YiBpbXBsZW1lbnRhdGlvbnMgb2YgcHJvdGVjdGVkIG5WSEUgc3RhY2sgdW53
aW5kZXIsIGZvcgpidWlsZGluZy4gVGhlc2UgYXJlIGltcGxlbWVudGVkIGxhdGVyIGluIHRoaXMg
c2VyaWVzLgoKU2lnbmVkLW9mZi1ieTogS2FsZXNoIFNpbmdoIDxrYWxlc2hzaW5naEBnb29nbGUu
Y29tPgpSZXZpZXdlZC1ieTogRnVhZCBUYWJiYSA8dGFiYmFAZ29vZ2xlLmNvbT4KVGVzdGVkLWJ5
OiBGdWFkIFRhYmJhIDx0YWJiYUBnb29nbGUuY29tPgotLS0KCkNoYW5nZXMgaW4gdjY6CiAgLSBB
ZGQgRnVhZOKAmXMgUmV2aWV3ZWQtYnkgYW5kIFRlc3RlZC1ieSB0YWdzCgpDaGFuZ2VzIGluIHY1
OgogIC0gTWFyayB1bndpbmRfbmV4dCgpIGFzIGlubGluZSwgcGVyIE1hcmMKCiBhcmNoL2FybTY0
L2luY2x1ZGUvYXNtL3N0YWNrdHJhY2UvbnZoZS5oIHwgMzUgKysrKysrKysrKysrKysrKysrKysr
Ky0tCiAxIGZpbGUgY2hhbmdlZCwgMzMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N0YWNrdHJhY2UvbnZoZS5oIGIvYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9zdGFja3RyYWNlL252aGUuaAppbmRleCAxNzBmZTc0NTlmN2Mu
LjJjZTU5YzA1ODgwNiAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9zdGFja3Ry
YWNlL252aGUuaAorKysgYi9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL3N0YWNrdHJhY2UvbnZoZS5o
CkBAIC05LDYgKzksMTAgQEAKICAqICAgICAgdG8gYWxsb2NhdGUgc2hhcmVkIGJ1ZmZlcnMgZm9y
IHRoZSBob3N0IHRvIHJlYWQgdGhlIHVud2luZGVkCiAgKiAgICAgIHN0YWNrdHJhY2UuCiAgKgor
ICogICAyKSBwS1ZNIChwcm90ZWN0ZWQgblZIRSkgbW9kZSAtIHRoZSBob3N0IGNhbm5vdCBkaXJl
Y3RseSBhY2Nlc3MKKyAqICAgICAgdGhlIEhZUCBtZW1vcnkuIFRoZSBzdGFjayBpcyB1bndpbmRl
ZCBpbiBFTDIgYW5kIGR1bXBlZCB0byBhIHNoYXJlZAorICogICAgICBidWZmZXIgd2hlcmUgdGhl
IGhvc3QgY2FuIHJlYWQgYW5kIHByaW50IHRoZSBzdGFja3RyYWNlLgorICoKICAqIENvcHlyaWdo
dCAoQykgMjAyMiBHb29nbGUgTExDCiAgKi8KICNpZm5kZWYgX19BU01fU1RBQ0tUUkFDRV9OVkhF
X0gKQEAgLTQ5LDcgKzUzLDM0IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBvbl9hY2Nlc3NpYmxlX3N0
YWNrKGNvbnN0IHN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrLAogCXJldHVybiBmYWxzZTsKIH0KIAot
I2lmbmRlZiBfX0tWTV9OVkhFX0hZUEVSVklTT1JfXworI2lmZGVmIF9fS1ZNX05WSEVfSFlQRVJW
SVNPUl9fCisvKgorICogUHJvdGVjdGVkIG5WSEUgSFlQIHN0YWNrIHVud2luZGVyCisgKgorICog
SW4gcHJvdGVjdGVkIG1vZGUsIHRoZSB1bndpbmRpbmcgaXMgZG9uZSBieSB0aGUgaHlwZXJ2aXNv
ciBpbiBFTDIuCisgKi8KKworI2lmZGVmIENPTkZJR19QUk9URUNURURfTlZIRV9TVEFDS1RSQUNF
CitzdGF0aWMgaW5saW5lIGJvb2wgb25fb3ZlcmZsb3dfc3RhY2sodW5zaWduZWQgbG9uZyBzcCwg
dW5zaWduZWQgbG9uZyBzaXplLAorCQkJCSAgICAgc3RydWN0IHN0YWNrX2luZm8gKmluZm8pCit7
CisJcmV0dXJuIGZhbHNlOworfQorCitzdGF0aWMgaW5saW5lIGJvb2wgb25faHlwX3N0YWNrKHVu
c2lnbmVkIGxvbmcgc3AsIHVuc2lnbmVkIGxvbmcgc2l6ZSwKKwkJCQlzdHJ1Y3Qgc3RhY2tfaW5m
byAqaW5mbykKK3sKKwlyZXR1cm4gZmFsc2U7Cit9CisKK3N0YXRpYyBpbmxpbmUgaW50IG5vdHJh
Y2UgdW53aW5kX25leHQoc3RydWN0IHVud2luZF9zdGF0ZSAqc3RhdGUpCit7CisJcmV0dXJuIDA7
Cit9CitOT0tQUk9CRV9TWU1CT0wodW53aW5kX25leHQpOworI2VuZGlmCS8qIENPTkZJR19QUk9U
RUNURURfTlZIRV9TVEFDS1RSQUNFICovCisKKyNlbHNlCS8qICFfX0tWTV9OVkhFX0hZUEVSVklT
T1JfXyAqLwogLyoKICAqIENvbnZlbnRpb25hbCAobm9uLXByb3RlY3RlZCkgblZIRSBIWVAgc3Rh
Y2sgdW53aW5kZXIKICAqCkBAIC0xMzIsNSArMTYzLDUgQEAgc3RhdGljIGlubGluZSBpbnQgbm90
cmFjZSB1bndpbmRfbmV4dChzdHJ1Y3QgdW53aW5kX3N0YXRlICpzdGF0ZSkKIH0KIE5PS1BST0JF
X1NZTUJPTCh1bndpbmRfbmV4dCk7CiAKLSNlbmRpZgkvKiAhX19LVk1fTlZIRV9IWVBFUlZJU09S
X18gKi8KKyNlbmRpZgkvKiBfX0tWTV9OVkhFX0hZUEVSVklTT1JfXyAqLwogI2VuZGlmCS8qIF9f
QVNNX1NUQUNLVFJBQ0VfTlZIRV9IICovCi0tIAoyLjM3LjEuMzU5LmdkMTM2YzZjM2UyLWdvb2cK
Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBt
YWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNz
LmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
