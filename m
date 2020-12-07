Return-Path: <SRS0=wPN+=FL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26DAC433FE
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 17:18:12 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54AAC23899
	for <kvmarm@archiver.kernel.org>; Mon,  7 Dec 2020 17:18:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54AAC23899
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B52514B29C;
	Mon,  7 Dec 2020 12:18:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JUY97Ze4mXM0; Mon,  7 Dec 2020 12:18:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F874B2A4;
	Mon,  7 Dec 2020 12:18:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E50CD4B29C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 12:18:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SbyCiU44oMB7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Dec 2020 12:18:08 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CEB484B274
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Dec 2020 12:18:07 -0500 (EST)
X-Gm-Message-State: AOAM532YfHq+L37o8+5w+BTVPhy8Ru0NI8JVDJ1TZdCm/tQh3anIZPW5
 F+e/6s9TlLZyHxKaCpFq5ztVR/QRKpPMW0GlqBo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1607361486;
 bh=rabPTk5CZLKaWMps5qa/GHaM0zMGApQrfczMdOMe6KY=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=ZdX6kJL8Rf365IhRZL9jLnlEKMp64NijVopWd3NfrK0vbb1td33GZrXrnrTGk/3AH
 TC3v7bLN4ARe3uAT3l4ffva0qHWMTUFei99mtOv2sCQGgJgpD+ffoIC5KSie9mEypX
 w4AGek9g9LE/gJLl8o8UA1NJRj9RvduCSgYpXp6szsOUNx69uRTdQeTzTvwVebONbj
 uVWIh7PZ5EGwM3jYZIxKUck+Tppjv+PQucR5+wYKJZTw/0Ra4Dovo/EHbRmabc8f1l
 FcsHXYf+vctxAc3h7gsthFWQjJ1POoROT5Zh2PuMWeVtWgYbYmM/HYwtU0otIou6ns
 Bzmo282Beus0w==
X-Google-Smtp-Source: ABdhPJwWrUZ6t0E6ANdfxUxRK8GXcjXRiURzPsVtXIgPHIUKXJctdCx1ANHrdICllFYprdF0y6wSyPpt6LLFWbEhrQM=
X-Received: by 2002:aca:b809:: with SMTP id i9mr13029503oif.174.1607361485877; 
 Mon, 07 Dec 2020 09:18:05 -0800 (PST)
MIME-Version: 1.0
References: <20201207154341.1004276-1-maz@kernel.org>
In-Reply-To: <20201207154341.1004276-1-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 7 Dec 2020 18:17:54 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHb9=KPkCAwYWDFH1ddy_p3sDTZ7QemtvWV8nC_14rN+g@mail.gmail.com>
Message-ID: <CAMj1kXHb9=KPkCAwYWDFH1ddy_p3sDTZ7QemtvWV8nC_14rN+g@mail.gmail.com>
Subject: Re: [PATCH] arm64: Work around broken GCC handling of "S" constraint
To: Marc Zyngier <maz@kernel.org>
Cc: Android Kernel Team <kernel-team@android.com>,
 Catalin Marinas <catalin.marinas@arm.com>, dbradzil@google.com,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>,
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

T24gTW9uLCA3IERlYyAyMDIwIGF0IDE2OjQzLCBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3Jn
PiB3cm90ZToKPgo+IEdDQyA0Ljkgc2VlbXMgdG8gaGF2ZSBhIHByb2JsZW0gd2l0aCB0aGUgIlMi
IGFzbSBjb25zdHJhaW50Cj4gd2hlbiB0aGUgc3ltYm9sIGxpdmVzIGluIHRoZSBzYW1lIGNvbXBp
bGF0aW9uIHVuaXQsIGFuZCBwcmV0ZW5kcwo+IHRoZSBjb25zdHJhaW50IGlzIGltcG9zc2libGU6
Cj4KPiAkIGNhdCB4LmMKPiB2b2lkICpmb28odm9pZCkKPiB7Cj4gICAgICAgICBzdGF0aWMgaW50
IHg7Cj4gICAgICAgICBpbnQgKmFkZHI7Cj4gICAgICAgICBhc20oImFkcnAgJTAsICUxIiA6ICI9
ciIgKGFkZHIpIDogIlMiICgmeCkpOwo+ICAgICAgICAgcmV0dXJuIGFkZHI7Cj4gfQo+Cj4gJCB+
L1dvcmsvZ2NjLWxpbmFyby1hYXJjaDY0LWxpbnV4LWdudS00LjktMjAxNC4wOV9saW51eC9iaW4v
YWFyY2g2NC1saW51eC1nbnUtZ2NjIC1TIC14IGMgLU8yIHguYwo+IHguYzogSW4gZnVuY3Rpb24g
4oCYZm9v4oCZOgo+IHguYzo1OjI6IGVycm9yOiBpbXBvc3NpYmxlIGNvbnN0cmFpbnQgaW4g4oCY
YXNt4oCZCj4gICBhc20oImFkcnAgJTAsICUxIiA6ICI9ciIgKGFkZHIpIDogIlMiICgmeCkpOwo+
ICAgXgo+Cj4gQm9vLiBGb2xsb3dpbmcgcmV2aXNpb25zIG9mIHRoZSBjb21waWxlciB3b3JrIGp1
c3QgZmluZSwgdGhvdWdoLgo+Cj4gV2UgY2FuIGZhbGxiYWNrIHRvIHRoZSAiaSIgY29uc3RyYWlu
dCBpbiB0aGF0IGNhc2UsIHdoaWNoCj4gKnNlZW1zKiB0byBkbyB0aGUgcmlnaHQgdGhpbmcuIEhv
cGVmdWxseSB3ZSB3aWxsIGJlIGFibGUgdG8KPiByZW1vdmUgdGhpcyBhdCBzb21lIHBvaW50LCBi
dXQgaW4gdGhlIG1lYW50aW1lIHRoaXMgZ2V0cyB1cyBnb2luZy4KPgo+IFNpZ25lZC1vZmYtYnk6
IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+Cgo+IC0tLQo+ICBhcmNoL2FybTY0L01ha2Vm
aWxlICAgICAgICAgICAgICB8IDkgKysrKysrKysrCj4gIGFyY2gvYXJtNjQvaW5jbHVkZS9hc20v
a3ZtX2FzbS5oIHwgOCArKysrKysrLQo+ICAyIGZpbGVzIGNoYW5nZWQsIDE2IGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkKPgo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L01ha2VmaWxlIGIv
YXJjaC9hcm02NC9NYWtlZmlsZQo+IGluZGV4IDU3ODljMmQxOGQ0My4uYzRlZThlNjRhZDFhIDEw
MDY0NAo+IC0tLSBhL2FyY2gvYXJtNjQvTWFrZWZpbGUKPiArKysgYi9hcmNoL2FybTY0L01ha2Vm
aWxlCj4gQEAgLTQ0LDEyICs0NCwyMSBAQCBjY19oYXNfa19jb25zdHJhaW50IDo9ICQoY2FsbCB0
cnktcnVuLGVjaG8gICAgICAgICAgICAgICAgICAgICAgICAgIFwKPiAgICAgICAgICAgICAgICAg
cmV0dXJuIDA7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBc
Cj4gICAgICAgICB9JyB8ICQoQ0MpIC1TIC14IGMgLW8gIiQkVE1QIiAtLCwtRENPTkZJR19DQ19I
QVNfS19DT05TVFJBSU5UPTEpCj4KPiArY2NfaGFzX2Jyb2tlbl9zX2NvbnN0cmFpbnQgOj0gJChj
YWxsIHRyeS1ydW4sZWNobyAgICAgICAgICAgICAgICAgICAgICBcCj4gKyAgICAgICAndm9pZCAq
Zm9vKHZvaWQpIHsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
XAo+ICsgICAgICAgICAgICAgICBzdGF0aWMgaW50IHg7ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIFwKPiArICAgICAgICAgICAgICAgaW50ICphZGRyOyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcCj4gKyAgICAgICAgICAgICAg
IGFzbSgiYWRycCAlMCwgJTEiIDogIj1yIiAoYWRkcikgOiAiUyIgKCZ4KSk7ICAgICAgICAgICAg
XAo+ICsgICAgICAgICAgICAgICByZXR1cm4gYWRkcjsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIFwKPiArICAgICAgIH0nIHwgJChDQykgLVMgLXggYyAtYyAtTzIg
LW8gIiQkVE1QIiAtLCwtRENPTkZJR19DQ19IQVNfQlJPS0VOX1NfQ09OU1RSQUlOVD0xKQo+ICsK
PiAgaWZlcSAoJChDT05GSUdfQlJPS0VOX0dBU19JTlNUKSx5KQo+ICAkKHdhcm5pbmcgRGV0ZWN0
ZWQgYXNzZW1ibGVyIHdpdGggYnJva2VuIC5pbnN0OyBkaXNhc3NlbWJseSB3aWxsIGJlIHVucmVs
aWFibGUpCj4gIGVuZGlmCj4KPiAgS0JVSUxEX0NGTEFHUyAgKz0gLW1nZW5lcmFsLXJlZ3Mtb25s
eSAgXAo+ICAgICAgICAgICAgICAgICAgICAkKGNvbXBhdF92ZHNvKSAkKGNjX2hhc19rX2NvbnN0
cmFpbnQpCj4gK0tCVUlMRF9DRkxBR1MgICs9ICQoY2NfaGFzX2Jyb2tlbl9zX2NvbnN0cmFpbnQp
Cj4gIEtCVUlMRF9DRkxBR1MgICs9ICQoY2FsbCBjYy1kaXNhYmxlLXdhcm5pbmcsIHBzYWJpKQo+
ICBLQlVJTERfQUZMQUdTICArPSAkKGNvbXBhdF92ZHNvKQo+Cj4gZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQvaW5jbHVkZS9hc20va3ZtX2FzbS5oIGIvYXJjaC9hcm02NC9pbmNsdWRlL2FzbS9rdm1f
YXNtLmgKPiBpbmRleCA3Y2NmNzcwYzUzZDkuLmZhOGU4ODY5OThhMyAxMDA2NDQKPiAtLS0gYS9h
cmNoL2FybTY0L2luY2x1ZGUvYXNtL2t2bV9hc20uaAo+ICsrKyBiL2FyY2gvYXJtNjQvaW5jbHVk
ZS9hc20va3ZtX2FzbS5oCj4gQEAgLTE5OSw2ICsxOTksMTIgQEAgZXh0ZXJuIHZvaWQgX192Z2lj
X3YzX2luaXRfbHJzKHZvaWQpOwo+Cj4gIGV4dGVybiB1MzIgX19rdm1fZ2V0X21kY3JfZWwyKHZv
aWQpOwo+Cj4gKyNpZmRlZiBDT05GSUdfQ0NfSEFTX0JST0tFTl9TX0NPTlNUUkFJTlQKPiArI2Rl
ZmluZSBTWU1fQ09OU1RSQUlOVCAiaSIKPiArI2Vsc2UKPiArI2RlZmluZSBTWU1fQ09OU1RSQUlO
VCAiUyIKPiArI2VuZGlmCj4gKwoKQ291bGQgd2UganVzdCBjaGVjayBHQ0NfVkVSU0lPTiBoZXJl
PwoKPiAgLyoKPiAgICogT2J0YWluIHRoZSBQQy1yZWxhdGl2ZSBhZGRyZXNzIG9mIGEga2VybmVs
IHN5bWJvbAo+ICAgKiBzOiBzeW1ib2wKPiBAQCAtMjE1LDcgKzIyMSw3IEBAIGV4dGVybiB1MzIg
X19rdm1fZ2V0X21kY3JfZWwyKHZvaWQpOwo+ICAgICAgICAgICAgICAgICB0eXBlb2YocykgKmFk
ZHI7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwKPiAgICAgICAgICAg
ICAgICAgYXNtKCJhZHJwICAgICAgICUwLCAlMVxuIiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBcCj4gICAgICAgICAgICAgICAgICAgICAiYWRkICAgICAgICAlMCwgJTAsIDpsbzEyOiUx
XG4iICAgICAgICAgICAgICAgICAgICAgXAo+IC0gICAgICAgICAgICAgICAgICAgOiAiPXIiIChh
ZGRyKSA6ICJTIiAoJnMpKTsgICAgICAgICAgICAgICAgICAgICAgICAgIFwKPiArICAgICAgICAg
ICAgICAgICAgIDogIj1yIiAoYWRkcikgOiBTWU1fQ09OU1RSQUlOVCAoJnMpKTsgICAgICAgICAg
ICAgICBcCj4gICAgICAgICAgICAgICAgIGFkZHI7ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgXAo+ICAgICAgICAgfSkKPgo+IC0tCj4gMi4yOS4yCj4K
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
