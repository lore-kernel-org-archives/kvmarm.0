Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D31FC4361B
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 17:19:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8E1572388D
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 17:19:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E1572388D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BC8E4B190;
	Mon,  7 Dec 2020 12:19:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zMuVYKfltAVw; Mon,  7 Dec 2020 12:19:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1CA24B2B0;
	Mon,  7 Dec 2020 12:19:40 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D705F4B29C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 12:19:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0o8Qt94ZtBnX for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 12:19:38 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5120C4B2D0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 12:19:34 -0500 (EST)
X-Gm-Message-State: AOAM532McrVp+c+kboj/bF8CCMA0Ly0JrxwbpxPWaEdSd8SXBECT1Lzq
 3lH6OvVh5VXiqZ3vhkS3EBX/c/PpgAojPYNiAsk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1607361573;
 bh=PfQEm+pnl+1l57SShzTHLYyJZchFHq9tbFYL3wUwDFY=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=cR3EzPo8NoiaVaSmFNvaZoG0e/I/1Ko40GzN2L4z7CLzlYrXksCdmx2fcddmtUB8Y
 T/c4Nj0v4mo4Mo3y3Valluc6cnkXY2YuVfpRdIju2SF2028H+1ns4OhlbvDw/bCiNY
 6oAWJmjsZVb6RWz76kwt0bK564oi0qfvTvlNojTMr5YZm5sOAJ/o3z8z/bEYoXqkod
 GWS/Ss8mkOQMoDAgMGURGcMnNSz9kXH7PW0zMp/8ZFXC+1ZtLhzYS/lrN2enG1npZC
 2GT8tVYVCn7RrVXM/sIsaaFB4q+mleFOXWfr9hU2xfG3EfUJH0+q0yKG3rcKMKFOyJ
 8LlaoERyloVsA==
X-Google-Smtp-Source: ABdhPJywa7wSVUMWmg2OO+Yj/m2TrGfijaByuKGFUfz1OasIb8c183SnNhjlTLbfEVCgKWvhXacb+6IsYJEQjk6yEuk=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr13506568otk.108.1607361572622; 
 Mon, 07 Dec 2020 09:19:32 -0800 (PST)
MIME-Version: 1.0
References: <20201207154341.1004276-1-maz@kernel.org>
 <CAMj1kXHb9=KPkCAwYWDFH1ddy_p3sDTZ7QemtvWV8nC_14rN+g@mail.gmail.com>
In-Reply-To: <CAMj1kXHb9=KPkCAwYWDFH1ddy_p3sDTZ7QemtvWV8nC_14rN+g@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 7 Dec 2020 18:19:21 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG9mmC8wY9Gvo-oJat0bZTNk495x1Hmmi-_FXbu-gDzDw@mail.gmail.com>
Message-ID: <CAMj1kXG9mmC8wY9Gvo-oJat0bZTNk495x1Hmmi-_FXbu-gDzDw@mail.gmail.com>
Subject: Re: [PATCH] arm64: Work around broken GCC handling of "S" constraint
To: Marc Zyngier <maz@kernel.org>, David Brazdil <dbrazdil@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Android Kernel Team <kernel-team@android.com>, Will Deacon <will@kernel.org>,
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

KHJlc2VuZCB3aXRoIERhdmlkJ3MgZW1haWwgYWRkcmVzcyBmaXhlZCkKCk9uIE1vbiwgNyBEZWMg
MjAyMCBhdCAxODoxNywgQXJkIEJpZXNoZXV2ZWwgPGFyZGJAa2VybmVsLm9yZz4gd3JvdGU6Cj4K
PiBPbiBNb24sIDcgRGVjIDIwMjAgYXQgMTY6NDMsIE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5v
cmc+IHdyb3RlOgo+ID4KPiA+IEdDQyA0Ljkgc2VlbXMgdG8gaGF2ZSBhIHByb2JsZW0gd2l0aCB0
aGUgIlMiIGFzbSBjb25zdHJhaW50Cj4gPiB3aGVuIHRoZSBzeW1ib2wgbGl2ZXMgaW4gdGhlIHNh
bWUgY29tcGlsYXRpb24gdW5pdCwgYW5kIHByZXRlbmRzCj4gPiB0aGUgY29uc3RyYWludCBpcyBp
bXBvc3NpYmxlOgo+ID4KPiA+ICQgY2F0IHguYwo+ID4gdm9pZCAqZm9vKHZvaWQpCj4gPiB7Cj4g
PiAgICAgICAgIHN0YXRpYyBpbnQgeDsKPiA+ICAgICAgICAgaW50ICphZGRyOwo+ID4gICAgICAg
ICBhc20oImFkcnAgJTAsICUxIiA6ICI9ciIgKGFkZHIpIDogIlMiICgmeCkpOwo+ID4gICAgICAg
ICByZXR1cm4gYWRkcjsKPiA+IH0KPiA+Cj4gPiAkIH4vV29yay9nY2MtbGluYXJvLWFhcmNoNjQt
bGludXgtZ251LTQuOS0yMDE0LjA5X2xpbnV4L2Jpbi9hYXJjaDY0LWxpbnV4LWdudS1nY2MgLVMg
LXggYyAtTzIgeC5jCj4gPiB4LmM6IEluIGZ1bmN0aW9uIOKAmGZvb+KAmToKPiA+IHguYzo1OjI6
IGVycm9yOiBpbXBvc3NpYmxlIGNvbnN0cmFpbnQgaW4g4oCYYXNt4oCZCj4gPiAgIGFzbSgiYWRy
cCAlMCwgJTEiIDogIj1yIiAoYWRkcikgOiAiUyIgKCZ4KSk7Cj4gPiAgIF4KPiA+Cj4gPiBCb28u
IEZvbGxvd2luZyByZXZpc2lvbnMgb2YgdGhlIGNvbXBpbGVyIHdvcmsganVzdCBmaW5lLCB0aG91
Z2guCj4gPgo+ID4gV2UgY2FuIGZhbGxiYWNrIHRvIHRoZSAiaSIgY29uc3RyYWludCBpbiB0aGF0
IGNhc2UsIHdoaWNoCj4gPiAqc2VlbXMqIHRvIGRvIHRoZSByaWdodCB0aGluZy4gSG9wZWZ1bGx5
IHdlIHdpbGwgYmUgYWJsZSB0bwo+ID4gcmVtb3ZlIHRoaXMgYXQgc29tZSBwb2ludCwgYnV0IGlu
IHRoZSBtZWFudGltZSB0aGlzIGdldHMgdXMgZ29pbmcuCj4gPgo+ID4gU2lnbmVkLW9mZi1ieTog
TWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPgo+ID4gLS0tCj4gPiAgYXJjaC9hcm02NC9N
YWtlZmlsZSAgICAgICAgICAgICAgfCA5ICsrKysrKysrKwo+ID4gIGFyY2gvYXJtNjQvaW5jbHVk
ZS9hc20va3ZtX2FzbS5oIHwgOCArKysrKysrLQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgMTYgaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQo+ID4KPiA+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0
L01ha2VmaWxlIGIvYXJjaC9hcm02NC9NYWtlZmlsZQo+ID4gaW5kZXggNTc4OWMyZDE4ZDQzLi5j
NGVlOGU2NGFkMWEgMTAwNjQ0Cj4gPiAtLS0gYS9hcmNoL2FybTY0L01ha2VmaWxlCj4gPiArKysg
Yi9hcmNoL2FybTY0L01ha2VmaWxlCj4gPiBAQCAtNDQsMTIgKzQ0LDIxIEBAIGNjX2hhc19rX2Nv
bnN0cmFpbnQgOj0gJChjYWxsIHRyeS1ydW4sZWNobyAgICAgICAgICAgICAgICAgICAgICAgICAg
XAo+ID4gICAgICAgICAgICAgICAgIHJldHVybiAwOyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgXAo+ID4gICAgICAgICB9JyB8ICQoQ0MpIC1TIC14IGMgLW8g
IiQkVE1QIiAtLCwtRENPTkZJR19DQ19IQVNfS19DT05TVFJBSU5UPTEpCj4gPgo+ID4gK2NjX2hh
c19icm9rZW5fc19jb25zdHJhaW50IDo9ICQoY2FsbCB0cnktcnVuLGVjaG8gICAgICAgICAgICAg
ICAgICAgICAgXAo+ID4gKyAgICAgICAndm9pZCAqZm9vKHZvaWQpIHsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXAo+ID4gKyAgICAgICAgICAgICAgIHN0YXRp
YyBpbnQgeDsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXAo+ID4g
KyAgICAgICAgICAgICAgIGludCAqYWRkcjsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXAo+ID4gKyAgICAgICAgICAgICAgIGFzbSgiYWRycCAlMCwgJTEiIDog
Ij1yIiAoYWRkcikgOiAiUyIgKCZ4KSk7ICAgICAgICAgICAgXAo+ID4gKyAgICAgICAgICAgICAg
IHJldHVybiBhZGRyOyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
XAo+ID4gKyAgICAgICB9JyB8ICQoQ0MpIC1TIC14IGMgLWMgLU8yIC1vICIkJFRNUCIgLSwsLURD
T05GSUdfQ0NfSEFTX0JST0tFTl9TX0NPTlNUUkFJTlQ9MSkKPiA+ICsKPiA+ICBpZmVxICgkKENP
TkZJR19CUk9LRU5fR0FTX0lOU1QpLHkpCj4gPiAgJCh3YXJuaW5nIERldGVjdGVkIGFzc2VtYmxl
ciB3aXRoIGJyb2tlbiAuaW5zdDsgZGlzYXNzZW1ibHkgd2lsbCBiZSB1bnJlbGlhYmxlKQo+ID4g
IGVuZGlmCj4gPgo+ID4gIEtCVUlMRF9DRkxBR1MgICs9IC1tZ2VuZXJhbC1yZWdzLW9ubHkgIFwK
PiA+ICAgICAgICAgICAgICAgICAgICAkKGNvbXBhdF92ZHNvKSAkKGNjX2hhc19rX2NvbnN0cmFp
bnQpCj4gPiArS0JVSUxEX0NGTEFHUyAgKz0gJChjY19oYXNfYnJva2VuX3NfY29uc3RyYWludCkK
PiA+ICBLQlVJTERfQ0ZMQUdTICArPSAkKGNhbGwgY2MtZGlzYWJsZS13YXJuaW5nLCBwc2FiaSkK
PiA+ICBLQlVJTERfQUZMQUdTICArPSAkKGNvbXBhdF92ZHNvKQo+ID4KPiA+IGRpZmYgLS1naXQg
YS9hcmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hc20uaCBiL2FyY2gvYXJtNjQvaW5jbHVkZS9h
c20va3ZtX2FzbS5oCj4gPiBpbmRleCA3Y2NmNzcwYzUzZDkuLmZhOGU4ODY5OThhMyAxMDA2NDQK
PiA+IC0tLSBhL2FyY2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX2FzbS5oCj4gPiArKysgYi9hcmNo
L2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hc20uaAo+ID4gQEAgLTE5OSw2ICsxOTksMTIgQEAgZXh0
ZXJuIHZvaWQgX192Z2ljX3YzX2luaXRfbHJzKHZvaWQpOwo+ID4KPiA+ICBleHRlcm4gdTMyIF9f
a3ZtX2dldF9tZGNyX2VsMih2b2lkKTsKPiA+Cj4gPiArI2lmZGVmIENPTkZJR19DQ19IQVNfQlJP
S0VOX1NfQ09OU1RSQUlOVAo+ID4gKyNkZWZpbmUgU1lNX0NPTlNUUkFJTlQgImkiCj4gPiArI2Vs
c2UKPiA+ICsjZGVmaW5lIFNZTV9DT05TVFJBSU5UICJTIgo+ID4gKyNlbmRpZgo+ID4gKwo+Cj4g
Q291bGQgd2UganVzdCBjaGVjayBHQ0NfVkVSU0lPTiBoZXJlPwo+Cj4gPiAgLyoKPiA+ICAgKiBP
YnRhaW4gdGhlIFBDLXJlbGF0aXZlIGFkZHJlc3Mgb2YgYSBrZXJuZWwgc3ltYm9sCj4gPiAgICog
czogc3ltYm9sCj4gPiBAQCAtMjE1LDcgKzIyMSw3IEBAIGV4dGVybiB1MzIgX19rdm1fZ2V0X21k
Y3JfZWwyKHZvaWQpOwo+ID4gICAgICAgICAgICAgICAgIHR5cGVvZihzKSAqYWRkcjsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXAo+ID4gICAgICAgICAgICAgICAgIGFz
bSgiYWRycCAgICAgICAlMCwgJTFcbiIgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXAo+
ID4gICAgICAgICAgICAgICAgICAgICAiYWRkICAgICAgICAlMCwgJTAsIDpsbzEyOiUxXG4iICAg
ICAgICAgICAgICAgICAgICAgXAo+ID4gLSAgICAgICAgICAgICAgICAgICA6ICI9ciIgKGFkZHIp
IDogIlMiICgmcykpOyAgICAgICAgICAgICAgICAgICAgICAgICAgXAo+ID4gKyAgICAgICAgICAg
ICAgICAgICA6ICI9ciIgKGFkZHIpIDogU1lNX0NPTlNUUkFJTlQgKCZzKSk7ICAgICAgICAgICAg
ICAgXAo+ID4gICAgICAgICAgICAgICAgIGFkZHI7ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgXAo+ID4gICAgICAgICB9KQo+ID4KPiA+IC0tCj4gPiAy
LjI5LjIKPiA+Cl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
