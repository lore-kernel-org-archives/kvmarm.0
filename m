Return-Path: <SRS0=AgFV=KV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE5EC47088
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 16:33:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C490613E1
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 16:33:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1C490613E1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BCBC4A4C0;
	Wed, 26 May 2021 12:33:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Y4LBrf-AIoOh; Wed, 26 May 2021 12:33:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FD5E4A3A5;
	Wed, 26 May 2021 12:33:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 466A34A3A5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 12:33:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G3kYXrILDoHN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 May 2021 12:33:48 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 363514A198
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 12:33:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622046828;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+8DfRYpfdanrqAB/wuirJR62lU9KY6YLBGRcjSyK7RU=;
 b=QfG4QNxHI7DA2iUiF4Xd26YdEKs959LAZLJuxqX7PY4CH1NbJbOn9iorqE5Uf83vanq+DM
 0i2a3dRSExNj5mFve+GUkr8kilrWaV4s7RieNp+HblSKHY8ot7AxxyU+/Ave4xf32+4l7q
 mwqXnErBr5eWV44Tj5a9udG28glneWE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-tIGEffeTPfGM7jL1NIMpFA-1; Wed, 26 May 2021 12:33:43 -0400
X-MC-Unique: tIGEffeTPfGM7jL1NIMpFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5405E107ACE3;
 Wed, 26 May 2021 16:33:41 +0000 (UTC)
Received: from [10.36.112.15] (ovpn-112-15.ams2.redhat.com [10.36.112.15])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 239A25C3E9;
 Wed, 26 May 2021 16:33:38 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 4/4] arm64: split
 its-migrate-unmapped-collection into KVM and TCG variants
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-5-alex.bennee@linaro.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <5fe1c796-c886-e5c6-6e61-e12d0f73a884@redhat.com>
Date: Wed, 26 May 2021 18:33:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210525172628.2088-5-alex.bennee@linaro.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

SGkgQWxleCwKCk9uIDUvMjUvMjEgNzoyNiBQTSwgQWxleCBCZW5uw6llIHdyb3RlOgo+IFdoZW4g
cnVubmluZyB0aGUgdGVzdCBpbiBUQ0cgd2UgYXJlIGJhc2ljYWxseSBydW5uaW5nIG9uIGJhcmUg
bWV0YWwgc28KPiBkb24ndCByZWx5IG9uIGhhdmluZyBhIHBhcnRpY3VsYXIga2VybmVsIGVycmF0
YSBhcHBsaWVkLgo+IAo+IFlvdSBtaWdodCB3b25kZXIgd2h5IHdlIGhhbmRsZSB0aGlzIHdpdGgg
YSB0b3RhbGx5IG5ldyB0ZXN0IG5hbWUKPiBpbnN0ZWFkIG9mIGFkanVzdGluZyB0aGUgYXBwZW5k
IHRvIHRha2UgYW4gZXh0cmEgcGFyYW1ldGVyPyBXZWxsIHRoZQo+IHJ1bl9taWdyYXRpb24gc2hl
bGwgc2NyaXB0IHVzZXMgZXZhbCAiJEAiIHdoaWNoIHVud3JhcHMgdGhlIC1hcHBlbmQKPiBsZWFk
aW5nIHRvIGFueSBzZWNvbmQgcGFyYW1ldGVyIGJlaW5nIHNwbGl0IGFuZCBsZWF2aW5nIFFFTVUg
dmVyeQo+IGNvbmZ1c2VkIGFuZCB0aGUgdGVzdCBoYW5naW5nLiBUaGlzIHNlZW1lZCBzaW1wbGVy
IHRoYW4gcmUtd3JpdGluZyBhbGwKPiB0aGUgdGVzdCBydW5uaW5nIGxvZ2ljIGluIHNvbWV0aGlu
ZyBzYW5lIDstKQoKdGhlcmUgaXMKbGliL3MzOTB4L3ZtLmg6Ym9vbCB2bV9pc190Y2codm9pZCkK
CmJ1dCBJIGRvbid0IHNlZSBhbnkgcGFydGljdWxhciBJRCB3ZSBjb3VsZCB1c2UgdG8gZGlmZmVy
ZW50aWF0ZSBib3RoIHRoZQpLVk0gYW5kIHRoZSBUQ0cgbW9kZSwgZG8geW91PwoKd2l0aG91dCBh
IG1vcmUgZWxlZ2FudCBzb2x1dGlvbiwKUmV2aWV3ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVn
ZXJAcmVkaGF0LmNvbT4KClRoYW5rcwoKRXJpYwoKCj4gCj4gU2lnbmVkLW9mZi1ieTogQWxleCBC
ZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgo+IENjOiBTaGFzaGkgTWFsbGVsYSA8c2hh
c2hpLm1hbGxlbGFAbGluYXJvLm9yZz4KPiAtLS0KPiAgYXJtL2dpYy5jICAgICAgICAgfCAgOCAr
KysrKysrLQo+ICBhcm0vdW5pdHRlc3RzLmNmZyB8IDEwICsrKysrKysrKy0KPiAgMiBmaWxlcyBj
aGFuZ2VkLCAxNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQg
YS9hcm0vZ2ljLmMgYi9hcm0vZ2ljLmMKPiBpbmRleCBiZWYwNjFhLi4wZmNlMmE0IDEwMDY0NAo+
IC0tLSBhL2FybS9naWMuYwo+ICsrKyBiL2FybS9naWMuYwo+IEBAIC0zNiw2ICszNiw3IEBAIHN0
YXRpYyBzdHJ1Y3QgZ2ljICpnaWM7Cj4gIHN0YXRpYyBpbnQgYWNrZWRbTlJfQ1BVU10sIHNwdXJp
b3VzW05SX0NQVVNdOwo+ICBzdGF0aWMgaW50IGlycV9zZW5kZXJbTlJfQ1BVU10sIGlycV9udW1i
ZXJbTlJfQ1BVU107Cj4gIHN0YXRpYyBjcHVtYXNrX3QgcmVhZHk7Cj4gK3N0YXRpYyBib29sIHVu
ZGVyX3RjZzsKPiAgCj4gIHN0YXRpYyB2b2lkIG5yX2NwdV9jaGVjayhpbnQgbnIpCj4gIHsKPiBA
QCAtODM0LDcgKzgzNSw3IEBAIHN0YXRpYyB2b2lkIHRlc3RfbWlncmF0ZV91bm1hcHBlZF9jb2xs
ZWN0aW9uKHZvaWQpCj4gIAkJZ290byBkb19taWdyYXRlOwo+ICAJfQo+ICAKPiAtCWlmICghZXJy
YXRhKEVSUkFUQV9VTk1BUFBFRF9DT0xMRUNUSU9OUykpIHsKPiArCWlmICghZXJyYXRhKEVSUkFU
QV9VTk1BUFBFRF9DT0xMRUNUSU9OUykgJiYgIXVuZGVyX3RjZykgewo+ICAJCXJlcG9ydF9za2lw
KCJTa2lwcGluZyB0ZXN0LCBhcyB0aGlzIHRlc3QgaGFuZ3Mgd2l0aG91dCB0aGUgZml4LiAiCj4g
IAkJCSAgICAiU2V0ICVzPXkgdG8gZW5hYmxlLiIsIEVSUkFUQV9VTk1BUFBFRF9DT0xMRUNUSU9O
Uyk7Cj4gIAkJdGVzdF9za2lwcGVkID0gdHJ1ZTsKPiBAQCAtMTAwNSw2ICsxMDA2LDExIEBAIGlu
dCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKPiAgCQlyZXBvcnRfcHJlZml4X3B1c2goYXJn
dlsxXSk7Cj4gIAkJdGVzdF9taWdyYXRlX3VubWFwcGVkX2NvbGxlY3Rpb24oKTsKPiAgCQlyZXBv
cnRfcHJlZml4X3BvcCgpOwo+ICsJfSBlbHNlIGlmICghc3RyY21wKGFyZ3ZbMV0sICJpdHMtbWln
cmF0ZS11bm1hcHBlZC1jb2xsZWN0aW9uLXRjZyIpKSB7Cj4gKwkJdW5kZXJfdGNnID0gdHJ1ZTsK
PiArCQlyZXBvcnRfcHJlZml4X3B1c2goYXJndlsxXSk7Cj4gKwkJdGVzdF9taWdyYXRlX3VubWFw
cGVkX2NvbGxlY3Rpb24oKTsKPiArCQlyZXBvcnRfcHJlZml4X3BvcCgpOwo+ICAJfSBlbHNlIGlm
IChzdHJjbXAoYXJndlsxXSwgIml0cy1pbnRyb3NwZWN0aW9uIikgPT0gMCkgewo+ICAJCXJlcG9y
dF9wcmVmaXhfcHVzaChhcmd2WzFdKTsKPiAgCQl0ZXN0X2l0c19pbnRyb3NwZWN0aW9uKCk7Cj4g
ZGlmZiAtLWdpdCBhL2FybS91bml0dGVzdHMuY2ZnIGIvYXJtL3VuaXR0ZXN0cy5jZmcKPiBpbmRl
eCAxYTM5NDI4Li5hZGMxYmJmIDEwMDY0NAo+IC0tLSBhL2FybS91bml0dGVzdHMuY2ZnCj4gKysr
IGIvYXJtL3VuaXR0ZXN0cy5jZmcKPiBAQCAtMjA1LDcgKzIwNSw3IEBAIGV4dHJhX3BhcmFtcyA9
IC1tYWNoaW5lIGdpYy12ZXJzaW9uPTMgLWFwcGVuZCAnaXRzLXBlbmRpbmctbWlncmF0aW9uJwo+
ICBncm91cHMgPSBpdHMgbWlncmF0aW9uCj4gIGFyY2ggPSBhcm02NAo+ICAKPiAtW2l0cy1taWdy
YXRlLXVubWFwcGVkLWNvbGxlY3Rpb25dCj4gK1tpdHMtbWlncmF0ZS11bm1hcHBlZC1jb2xsZWN0
aW9uLWt2bV0KPiAgZmlsZSA9IGdpYy5mbGF0Cj4gIHNtcCA9ICRNQVhfU01QCj4gIGFjY2VsID0g
a3ZtCj4gQEAgLTIxMyw2ICsyMTMsMTQgQEAgZXh0cmFfcGFyYW1zID0gLW1hY2hpbmUgZ2ljLXZl
cnNpb249MyAtYXBwZW5kICdpdHMtbWlncmF0ZS11bm1hcHBlZC1jb2xsZWN0aW9uJwo+ICBncm91
cHMgPSBpdHMgbWlncmF0aW9uCj4gIGFyY2ggPSBhcm02NAo+ICAKPiArW2l0cy1taWdyYXRlLXVu
bWFwcGVkLWNvbGxlY3Rpb24tdGNnXQo+ICtmaWxlID0gZ2ljLmZsYXQKPiArc21wID0gJE1BWF9T
TVAKPiArYWNjZWwgPSB0Y2cKPiArZXh0cmFfcGFyYW1zID0gLW1hY2hpbmUgZ2ljLXZlcnNpb249
MyAtYXBwZW5kICdpdHMtbWlncmF0ZS11bm1hcHBlZC1jb2xsZWN0aW9uLXRjZycKPiArZ3JvdXBz
ID0gaXRzIG1pZ3JhdGlvbgo+ICthcmNoID0gYXJtNjQKPiArCj4gICMgVGVzdCBQU0NJIGVtdWxh
dGlvbgo+ICBbcHNjaV0KPiAgZmlsZSA9IHBzY2kuZmxhdAo+IAoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
