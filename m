Return-Path: <SRS0=f3Zk=JZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02AE0C433B4
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 12:07:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 398BE6023C
	for <kvmarm@archiver.kernel.org>; Wed, 28 Apr 2021 12:07:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 398BE6023C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 982234B240;
	Wed, 28 Apr 2021 08:07:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tnNP0mJcfNyw; Wed, 28 Apr 2021 08:07:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 902894B1F6;
	Wed, 28 Apr 2021 08:07:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7AB064B1F6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 08:07:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TUokyzNwQjkD for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Apr 2021 08:07:10 -0400 (EDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com
 [209.85.221.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E9A34B1F5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 08:07:10 -0400 (EDT)
Received: by mail-wr1-f54.google.com with SMTP id t18so5181522wry.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Apr 2021 05:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=EOOU8pYthgPf7utb7CYoUc60xCQM7rwCYX3vaXiEcTY=;
 b=F4GdgxcmXXhLc3/XBCKHrYL27+JBaWB8OxsWPWRpQRp2glFiKJ+OfMnMINqT95sIUF
 FcOUF37ihPPvyvrZ5V6f8GD0wbQV3ho3clkhffwW+IHs1XzhvvbDaoUdslKfxrwJHFfv
 NJEYWDeHLHOkM7goak1Oe9i6ktoufCft4HMCkFXTIrHJ7JOfphu77MtyB+5iCf4CZujB
 4er7AajJ5R1PWCg3RKDKbBqxZ9kEo2hX2j4js8IZME8mrXK/EoJbyXW5Y9In3nwIb68W
 wp+GhyTop/Xn7hx1D9xWeDEAHmMpRLFTGA07gvVXRpyPo0/2s/U5tEl85ErX1+qrZQhw
 kzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=EOOU8pYthgPf7utb7CYoUc60xCQM7rwCYX3vaXiEcTY=;
 b=cMxdCBHPYaiiw6X0Y5pjoh/r3t7m0a8SXaf8vomh4FTqOkBJTAadK5xuTC6qhGlzwR
 TU3COm1bwQjdpK9lZWoUExcWypJEYTuNo7ShySkQj9mDlShiUm/rraXt1HT4dgwiV/dY
 XpUvoJcclzsOE9q4GpYdoHYX0EqPLDX+/MzqPqTqOZZyX4iH2I6Nm2h9RwjH/47BH0Jd
 EdVbctOQP9iAsWOR2UW2WBQZBCzcnLfYvx88/oLFuFnw1GuuJuiisGj9JGU8hNfee/oO
 4SI/ZUPprw+IHWbVhqY4EUnLEKAplFnwACKJICvz7qag26L/oCDhS3HbNpo8ABh8Nm60
 VYXw==
X-Gm-Message-State: AOAM530rmG/cvKXksNwF1s2fRcB2/WdEDi+lv441v7ogklxYApmzJ2+F
 WquA2txnGeVGob7UtBgd2KCv3A==
X-Google-Smtp-Source: ABdhPJyMSCceZ77YJwhl0z1r0OY0A22a0uOCG55/fGlq8eYfKoD8tFH0GLGzFe4gBYmNj6SvelIxjw==
X-Received: by 2002:adf:ec82:: with SMTP id z2mr26141037wrn.214.1619611629386; 
 Wed, 28 Apr 2021 05:07:09 -0700 (PDT)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id z18sm8011759wrh.16.2021.04.28.05.07.08
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 28 Apr 2021 05:07:08 -0700 (PDT)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id B1ADC1FF7E;
 Wed, 28 Apr 2021 13:07:07 +0100 (BST)
References: <20210428101844.22656-1-alex.bennee@linaro.org>
 <20210428101844.22656-2-alex.bennee@linaro.org>
 <eaed3c63988513fe2849c2d6f22937af@kernel.org>
User-agent: mu4e 1.5.12; emacs 28.0.50
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [kvm-unit-tests PATCH v1 1/4] arm64: split its-trigger test
 into KVM and TCG variants
Date: Wed, 28 Apr 2021 13:06:18 +0100
In-reply-to: <eaed3c63988513fe2849c2d6f22937af@kernel.org>
Message-ID: <87fszasjdg.fsf@linaro.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, shashi.mallela@linaro.org, qemu-arm@nongnu.org,
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

Ck1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+IHdyaXRlczoKCj4gT24gMjAyMS0wNC0yOCAx
MToxOCwgQWxleCBCZW5uw6llIHdyb3RlOgo+PiBBIGZldyBvZiB0aGUgaXRzLXRyaWdnZXIgdGVz
dHMgcmVseSBvbiBJTVBERUYgYmVoYXZpb3VyIHdoZXJlIGNhY2hlcwo+PiBhcmVuJ3QgZmx1c2hl
ZCBiZWZvcmUgaW52YWxsIGV2ZW50cy4gSG93ZXZlciBUQ0cgZW11bGF0aW9uIGRvZXNuJ3QKPj4g
bW9kZWwgYW55IGludmFsbCBiZWhhdmlvdXIgYW5kIGFzIHdlIGNhbid0IHByb2JlIGZvciBpdCB3
ZSBuZWVkIHRvIGJlCj4+IHRvbGQuIFNwbGl0IHRoZSB0ZXN0IGludG8gYSBLVk0gYW5kIFRDRyB2
YXJpYW50IGFuZCBza2lwIHRoZSBpbnZhbGwKPj4gdGVzdHMgd2hlbiB1bmRlciBUQ0cuCj4+IFNp
Z25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KPj4gQ2M6
IFNoYXNoaSBNYWxsZWxhIDxzaGFzaGkubWFsbGVsYUBsaW5hcm8ub3JnPgo+PiAtLS0KPj4gIGFy
bS9naWMuYyAgICAgICAgIHwgNjAgKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0t
LS0tLS0tLS0tLS0KPj4gIGFybS91bml0dGVzdHMuY2ZnIHwgMTEgKysrKysrKystCj4+ICAyIGZp
bGVzIGNoYW5nZWQsIDQ1IGluc2VydGlvbnMoKyksIDI2IGRlbGV0aW9ucygtKQo+PiBkaWZmIC0t
Z2l0IGEvYXJtL2dpYy5jIGIvYXJtL2dpYy5jCj4+IGluZGV4IDk4MTM1ZWYuLjk2YTMyOWQgMTAw
NjQ0Cj4+IC0tLSBhL2FybS9naWMuYwo+PiArKysgYi9hcm0vZ2ljLmMKPj4gQEAgLTM2LDYgKzM2
LDcgQEAgc3RhdGljIHN0cnVjdCBnaWMgKmdpYzsKPj4gIHN0YXRpYyBpbnQgYWNrZWRbTlJfQ1BV
U10sIHNwdXJpb3VzW05SX0NQVVNdOwo+PiAgc3RhdGljIGludCBpcnFfc2VuZGVyW05SX0NQVVNd
LCBpcnFfbnVtYmVyW05SX0NQVVNdOwo+PiAgc3RhdGljIGNwdW1hc2tfdCByZWFkeTsKPj4gK3N0
YXRpYyBib29sIHVuZGVyX3RjZzsKPj4gIHN0YXRpYyB2b2lkIG5yX2NwdV9jaGVjayhpbnQgbnIp
Cj4+ICB7Cj4+IEBAIC03MzQsMzIgKzczNSwzOCBAQCBzdGF0aWMgdm9pZCB0ZXN0X2l0c190cmln
Z2VyKHZvaWQpCj4+ICAJLyoKPj4gIAkgKiByZS1lbmFibGUgdGhlIExQSSBidXQgd2lsbGluZ2x5
IGRvIG5vdCBjYWxsIGludmFsbAo+PiAgCSAqIHNvIHRoZSBjaGFuZ2UgaW4gY29uZmlnIGlzIG5v
dCB0YWtlbiBpbnRvIGFjY291bnQuCj4+IC0JICogVGhlIExQSSBzaG91bGQgbm90IGhpdAo+PiAr
CSAqIFRoZSBMUEkgc2hvdWxkIG5vdCBoaXQuIFRoaXMgZG9lcyBob3dldmVyIGRlcGVuZCBvbgo+
PiArCSAqIGltcGxlbWVudGF0aW9uIGRlZmluZWQgYmVoYXZpb3VyIC0gdW5kZXIgUUVNVSBUQ0cg
ZW11bGF0aW9uCj4+ICsJICogaXQgY2FuIHF1aXRlIGNvcnJlY3RseSBwcm9jZXNzIHRoZSBldmVu
dCBkaXJlY3RseS4KPgo+IEl0IGxvb2tzIHRvIG1lIHRoYXQgeW91IGFyZSB1c2luZyBhbiBJTVBE
RUYgYmVoYXZpb3VyIG9mICpUQ0cqCj4gaGVyZS4gVGhlIHByb2dyYW1taW5nIG1vZGVsIG1hbmRh
dGVzIHRoYXQgdGhlcmUgaXMgYW4gaW52YWxpZGF0aW9uCj4gaWYgeW91IGNoYW5nZSB0aGUgY29u
ZmlndXJhdGlvbiBvZiB0aGUgTFBJLgoKQnV0IGRvZXMgaXQgbWFuZGF0ZSB0aGF0IHRoZSBMUEkg
Y2Fubm90IGJlIHNlbnQgdW50aWwgdGhlIGludmFsaWRhdGlvbj8KCj4KPiAgICAgICAgIE0uCgoK
LS0gCkFsZXggQmVubsOpZQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUK
aHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
