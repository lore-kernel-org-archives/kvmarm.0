Return-Path: <SRS0=/4+A=FV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB03C4361B
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 11:13:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 036262389B
	for <kvmarm@archiver.kernel.org>; Thu, 17 Dec 2020 11:13:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 036262389B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DFEC4B25F;
	Thu, 17 Dec 2020 06:13:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LdBQ0pVw8bxq; Thu, 17 Dec 2020 06:13:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 641574B262;
	Thu, 17 Dec 2020 06:13:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D62D4B25F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Dec 2020 06:13:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r2wBloB+Q282 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Dec 2020 06:13:48 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DF3604B25C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Dec 2020 06:13:47 -0500 (EST)
X-Gm-Message-State: AOAM531xVExjdSv/5zBrkzUGxWuGEeOdWeqYDTydWXPWBIlGpF37PrKG
 FJZIeIso8gCJ0rvSLUtL5EdUXNQCCZNjgcTBsI8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1608203626;
 bh=qPWVJog8PCJWyW3kB33ZP8lBQqb5xLtGN0RtCKvjbMI=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=HPVlUZbnvmCh9vXaF6SBqFK9Gx3XLhaNPolhjbyH44J3cUPNplGY4y4kaOeO3f2HT
 FOkMYW0bi34v7P7UpALe60H6Ki5P4hXDniSQ229BsH60EyMUQ/Uctlsh58FGVOl9B/
 cqZWM3yxJYXQQu00MVV1p8D7AT9jD+gwWdPS4eRCBByQi5yCRVH1F7nZrfSo93yP88
 iqUt/nMuCjLKM7Y+01OOSI8w1LamynSbr60Zybc7mANmdoV6WHNbdaxflqjnlQnIHG
 /pgwEYIO7FOyF/65YsGc0pIOIwwLiF0O4TVHK9HPAVuzE4V57zL8/dJ9DD5+YLbmdY
 32G8os3lpeBvQ==
X-Google-Smtp-Source: ABdhPJyVM/TSBxJYqjq2JnN2EowRHDIRLhXZiDaMXkJnlHznknk1o2U8vHXqLOtr4rwYB5SfFgv370i8gTLDKyJwnBY=
X-Received: by 2002:a05:6830:1c24:: with SMTP id
 f4mr28294281ote.108.1608203625993; 
 Thu, 17 Dec 2020 03:13:45 -0800 (PST)
MIME-Version: 1.0
References: <20201217111135.1536658-1-maz@kernel.org>
In-Reply-To: <20201217111135.1536658-1-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 17 Dec 2020 12:13:35 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFDXpaN2Sq5AA3ofvXpoUBjiT5iTyF46A7Y=Gy8XnJAww@mail.gmail.com>
Message-ID: <CAMj1kXFDXpaN2Sq5AA3ofvXpoUBjiT5iTyF46A7Y=Gy8XnJAww@mail.gmail.com>
Subject: Re: [PATCH] arm64: Work around broken GCC 4.9 handling of "S"
 constraint
To: Marc Zyngier <maz@kernel.org>
Cc: Android Kernel Team <kernel-team@android.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>
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

T24gVGh1LCAxNyBEZWMgMjAyMCBhdCAxMjoxMSwgTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9y
Zz4gd3JvdGU6Cj4KPiBHQ0MgNC45IHNlZW1zIHRvIGhhdmUgYSBwcm9ibGVtIHdpdGggdGhlICJT
IiBhc20gY29uc3RyYWludAo+IHdoZW4gdGhlIHN5bWJvbCBsaXZlcyBpbiB0aGUgc2FtZSBjb21w
aWxhdGlvbiB1bml0LCBhbmQgcHJldGVuZHMKPiB0aGUgY29uc3RyYWludCBpcyBpbXBvc3NpYmxl
Ogo+Cj4gJCBjYXQgeC5jCj4gdm9pZCAqZm9vKHZvaWQpCj4gewo+ICAgICAgICAgc3RhdGljIGlu
dCB4Owo+ICAgICAgICAgaW50ICphZGRyOwo+ICAgICAgICAgYXNtKCJhZHJwICUwLCAlMSIgOiAi
PXIiIChhZGRyKSA6ICJTIiAoJngpKTsKPiAgICAgICAgIHJldHVybiBhZGRyOwo+IH0KPgo+ICQg
fi9Xb3JrL2djYy1saW5hcm8tYWFyY2g2NC1saW51eC1nbnUtNC45LTIwMTQuMDlfbGludXgvYmlu
L2FhcmNoNjQtbGludXgtZ251LWdjYyAtUyAteCBjIC1PMiB4LmMKPiB4LmM6IEluIGZ1bmN0aW9u
IOKAmGZvb+KAmToKPiB4LmM6NToyOiBlcnJvcjogaW1wb3NzaWJsZSBjb25zdHJhaW50IGluIOKA
mGFzbeKAmQo+ICAgYXNtKCJhZHJwICUwLCAlMSIgOiAiPXIiIChhZGRyKSA6ICJTIiAoJngpKTsK
PiAgIF4KPgo+IEJvby4gRm9sbG93aW5nIHJldmlzaW9ucyBvZiB0aGUgY29tcGlsZXIgd29yayBq
dXN0IGZpbmUsIHRob3VnaC4KPgo+IFdlIGNhbiBmYWxsYmFjayB0byB0aGUgImkiIGNvbnN0cmFp
bnQgZm9yIEdDQyB2ZXJzaW9uIHByaW9yIHRvIDUuMCwKPiB3aGljaCAqc2VlbXMqIHRvIGRvIHRo
ZSByaWdodCB0aGluZy4gSG9wZWZ1bGx5IHdlIHdpbGwgYmUgYWJsZSB0bwo+IHJlbW92ZSB0aGlz
IGF0IHNvbWUgcG9pbnQsIGJ1dCBpbiB0aGUgbWVhbnRpbWUgdGhpcyBnZXRzIHVzIGdvaW5nLgo+
Cj4gU2lnbmVkLW9mZi1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KCkFja2VkLWJ5
OiBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPgoKPiAtLS0KPiAqIEZyb20gdjE6IERy
b3BwZWQgdGhlIGRldGVjdGlvbiBoYWNrIGFuZCByZWx5IG9uIEdDQ19WRVJTSU9OCj4KPiAgYXJj
aC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fYXNtLmggfCA4ICsrKysrKystCj4gIDEgZmlsZSBjaGFu
Z2VkLCA3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKPgo+IGRpZmYgLS1naXQgYS9hcmNo
L2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hc20uaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3Zt
X2FzbS5oCj4gaW5kZXggN2NjZjc3MGM1M2Q5Li44YTMzZDgzZWE4NDMgMTAwNjQ0Cj4gLS0tIGEv
YXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1fYXNtLmgKPiArKysgYi9hcmNoL2FybTY0L2luY2x1
ZGUvYXNtL2t2bV9hc20uaAo+IEBAIC0xOTksNiArMTk5LDEyIEBAIGV4dGVybiB2b2lkIF9fdmdp
Y192M19pbml0X2xycyh2b2lkKTsKPgo+ICBleHRlcm4gdTMyIF9fa3ZtX2dldF9tZGNyX2VsMih2
b2lkKTsKPgo+ICsjaWYgZGVmaW5lZChHQ0NfVkVSU0lPTikgJiYgR0NDX1ZFUlNJT04gPCA1MDAw
MAo+ICsjZGVmaW5lIFNZTV9DT05TVFJBSU5UICJpIgo+ICsjZWxzZQo+ICsjZGVmaW5lIFNZTV9D
T05TVFJBSU5UICJTIgo+ICsjZW5kaWYKPiArCj4gIC8qCj4gICAqIE9idGFpbiB0aGUgUEMtcmVs
YXRpdmUgYWRkcmVzcyBvZiBhIGtlcm5lbCBzeW1ib2wKPiAgICogczogc3ltYm9sCj4gQEAgLTIx
NSw3ICsyMjEsNyBAQCBleHRlcm4gdTMyIF9fa3ZtX2dldF9tZGNyX2VsMih2b2lkKTsKPiAgICAg
ICAgICAgICAgICAgdHlwZW9mKHMpICphZGRyOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBcCj4gICAgICAgICAgICAgICAgIGFzbSgiYWRycCAgICAgICAlMCwgJTFcbiIg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXAo+ICAgICAgICAgICAgICAgICAgICAgImFk
ZCAgICAgICAgJTAsICUwLCA6bG8xMjolMVxuIiAgICAgICAgICAgICAgICAgICAgIFwKPiAtICAg
ICAgICAgICAgICAgICAgIDogIj1yIiAoYWRkcikgOiAiUyIgKCZzKSk7ICAgICAgICAgICAgICAg
ICAgICAgICAgICBcCj4gKyAgICAgICAgICAgICAgICAgICA6ICI9ciIgKGFkZHIpIDogU1lNX0NP
TlNUUkFJTlQgKCZzKSk7ICAgICAgICAgICAgICAgXAo+ICAgICAgICAgICAgICAgICBhZGRyOyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwKPiAgICAg
ICAgIH0pCj4KPiAtLQo+IDIuMjkuMgo+Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo=
