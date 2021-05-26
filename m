Return-Path: <SRS0=AgFV=KV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C88C47089
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 15:06:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E6A0D613CA
	for <kvmarm@archiver.kernel.org>; Wed, 26 May 2021 15:06:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6A0D613CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89A0340569;
	Wed, 26 May 2021 11:06:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id F1shbfAb+f8C; Wed, 26 May 2021 11:06:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5723649E5F;
	Wed, 26 May 2021 11:06:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F02A6402A9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 11:06:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lXoUnqdnLqcO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 May 2021 11:06:19 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17D7D4024F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 May 2021 11:06:19 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1622041579;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PjLovZI7QWiNVj3Yel3XdwAUC8rzUPkP/bc1/f02aIQ=;
 b=aSfmyRpV9ZKor/R2p2aAn3/wfDcrpRlVHbPQl0yaTIVR8qlErYcCBgogneDwgZ0aC3fWKd
 U9Sw6GfI8cNMQ40jgahevaTkSV0m2TAjtL5AoT4HHJg+6MotOSf0XVfQ+TR/3mifVO8/GR
 l19OCL1LOX68qnxEIzvOZDv7H31tPyw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-gZN-IZcqPomryu_2wOp4Lw-1; Wed, 26 May 2021 11:06:14 -0400
X-MC-Unique: gZN-IZcqPomryu_2wOp4Lw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEFC7107ACE3;
 Wed, 26 May 2021 15:06:12 +0000 (UTC)
Received: from [10.36.112.15] (ovpn-112-15.ams2.redhat.com [10.36.112.15])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D716419D9D;
 Wed, 26 May 2021 15:06:09 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 1/4] arm64: remove invalid check from
 its-trigger test
To: =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-2-alex.bennee@linaro.org>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <70b9dbfb-2b0f-f77b-d779-09dc1f766c7c@redhat.com>
Date: Wed, 26 May 2021 17:06:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210525172628.2088-2-alex.bennee@linaro.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

SGkgQWxleCwKCk9uIDUvMjUvMjEgNzoyNiBQTSwgQWxleCBCZW5uw6llIHdyb3RlOgo+IFdoaWxl
IGFuIElSUSBpcyBub3QgImd1YXJhbnRlZWQgdG8gYmUgdmlzaWJsZSB1bnRpbCBhbiBhcHByb3By
aWF0ZQo+IGludmFsaWRhdGlvbiIgaXQgZG9lc24ndCBzdG9wIHRoZSBhY3R1YWwgaW1wbGVtZW50
YXRpb24gZGVsaXZlcmluZyBpdAo+IGVhcmxpZXIgaWYgaXQgd2FudHMgdG8uIFRoaXMgaXMgdGhl
IGNhc2UgZm9yIFFFTVUncyBUQ0cgYW5kIGFzIHRlc3RzCj4gc2hvdWxkIG9ubHkgYmUgY2hlY2tp
bmcgYXJjaGl0ZWN0dXJhbCBjb21wbGlhbmNlIHRoaXMgY2hlY2sgaXMKPiBpbnZhbGlkLgo+IAo+
IFNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KPiBD
YzogU2hhc2hpIE1hbGxlbGEgPHNoYXNoaS5tYWxsZWxhQGxpbmFyby5vcmc+Cj4gLS0tCj4gIGFy
bS9naWMuYyB8IDE0ICsrKysrKy0tLS0tLS0tCj4gIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlv
bnMoKyksIDggZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2FybS9naWMuYyBiL2FybS9n
aWMuYwo+IGluZGV4IDk4MTM1ZWYuLmJlZjA2MWEgMTAwNjQ0Cj4gLS0tIGEvYXJtL2dpYy5jCj4g
KysrIGIvYXJtL2dpYy5jCj4gQEAgLTczMiwyMSArNzMyLDE5IEBAIHN0YXRpYyB2b2lkIHRlc3Rf
aXRzX3RyaWdnZXIodm9pZCkKPiAgCQkJImRldjIvZXZlbnRpZD0yMCBkb2VzIG5vdCB0cmlnZ2Vy
IGFueSBMUEkiKTsKPiAgCj4gIAkvKgo+IC0JICogcmUtZW5hYmxlIHRoZSBMUEkgYnV0IHdpbGxp
bmdseSBkbyBub3QgY2FsbCBpbnZhbGwKPiAtCSAqIHNvIHRoZSBjaGFuZ2UgaW4gY29uZmlnIGlz
IG5vdCB0YWtlbiBpbnRvIGFjY291bnQuCj4gLQkgKiBUaGUgTFBJIHNob3VsZCBub3QgaGl0Cj4g
KwkgKiByZS1lbmFibGUgdGhlIExQSSBidXQgd2lsbGluZ2x5IGRvIG5vdCBjYWxsIGludmFsbCBz
byB0aGUKPiArCSAqIGNoYW5nZSBpbiBjb25maWcgaXMgbm90IHRha2VuIGludG8gYWNjb3VudC4g
V2hpbGUgIkEgY2hhbmdlClNvIHlvdSBtYXkgbmVlZCB0byByZW1vdmUgdGhlIGFib3ZlIGNvbW1l
bnQsIGllLiAiYnV0IHdpbGxpbmdseSBkbyBub3QKY2FsbCBpbnZhbGwgc28gdGhlIGNoYW5nZSBp
biBjb25maWcgaXMgbm90IHRha2VuIGludG8gYWNjb3VudC4iIGFzIHRoZQpjb25jbHVzaW9uIG9m
IHRoaXMgdGhyZWFkIGlzIGl0IGNhbiBiZSB0YWtlbiBpbnRvIGFjY291bnQgaW1tZWRpYXRseS4K
CmFuZCBhbHNvIGNvbmNhdCB0aGUgY29tbWVudCBiZWxvdywgIi8qIE5vdyBjYWxsIHRoZSBpbnZh
bGwgYW5kIGNoZWNrIHRoZQpMUEkgaGl0cyAqLyIKVGhpcyBpcyBhbiAiYXRvbWljIiB0ZXN0IG5v
dz8KCndpdGggdGhhdCBjaGFuZ2UKUmV2aWV3ZWQtYnk6IEVyaWMgQXVnZXIgPGVyaWMuYXVnZXJA
cmVkaGF0LmNvbT4KCgpUaGFua3MKCkVyaWMKPiArCSAqIHRvIHRoZSBMUEkgY29uZmlndXJhdGlv
biBpcyBub3QgZ3VhcmFudGVlZCB0byBiZSB2aXNpYmxlCj4gKwkgKiB1bnRpbCBhbiBhcHByb3By
aWF0ZSBpbnZhbGlkYXRpb24gb3BlcmF0aW9uIGhhcyBjb21wbGV0ZWQiCj4gKwkgKiBoYXJkd2Fy
ZSB0aGF0IGRvZXNuJ3QgaW1wbGVtZW50IGNhY2hlcyBtYXkgaGF2ZSBkZWxpdmVyZWQKPiArCSAq
IHRoZSBldmVudCBhdCBhbnkgcG9pbnQgYWZ0ZXIgdGhlIGVuYWJsaW5nLgo+ICAJICovCj4gIAln
aWN2M19scGlfc2V0X2NvbmZpZyg4MTk1LCBMUElfUFJPUF9ERUZBVUxUKTsKPiAgCXN0YXRzX3Jl
c2V0KCk7Cj4gIAljcHVtYXNrX2NsZWFyKCZtYXNrKTsKPiAgCWl0c19zZW5kX2ludChkZXYyLCAy
MCk7Cj4gLQl3YWl0X2Zvcl9pbnRlcnJ1cHRzKCZtYXNrKTsKPiAtCXJlcG9ydChjaGVja19hY2tl
ZCgmbWFzaywgLTEsIC0xKSwKPiAtCQkJImRldjIvZXZlbnRpZD0yMCBzdGlsbCBkb2VzIG5vdCB0
cmlnZ2VyIGFueSBMUEkiKTsKPiAgCj4gIAkvKiBOb3cgY2FsbCB0aGUgaW52YWxsIGFuZCBjaGVj
ayB0aGUgTFBJIGhpdHMgKi8KPiAtCXN0YXRzX3Jlc2V0KCk7Cj4gLQljcHVtYXNrX2NsZWFyKCZt
YXNrKTsKPiAgCWNwdW1hc2tfc2V0X2NwdSgzLCAmbWFzayk7Cj4gIAlpdHNfc2VuZF9pbnZhbGwo
Y29sMyk7Cj4gIAl3YWl0X2Zvcl9pbnRlcnJ1cHRzKCZtYXNrKTsKPiAKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
