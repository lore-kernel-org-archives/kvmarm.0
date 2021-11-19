Return-Path: <SRS0=LYRx=QG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4AAC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 16:31:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2425961B1E
	for <kvmarm@archiver.kernel.org>; Fri, 19 Nov 2021 16:31:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2425961B1E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97C344B0B8;
	Fri, 19 Nov 2021 11:31:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fF-lIzS-zyng; Fri, 19 Nov 2021 11:31:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 637914B0BD;
	Fri, 19 Nov 2021 11:31:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6504B0B8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 11:31:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GbieOErReP0v for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Nov 2021 11:31:17 -0500 (EST)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
 [209.85.128.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 21BDB4B0B4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 11:31:17 -0500 (EST)
Received: by mail-wm1-f53.google.com with SMTP id i12so9033902wmq.4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Nov 2021 08:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=XonVBN9UhK3TNdc3A1YJVcvvL67hZKsmNPxUpmHwItk=;
 b=rC9uz1gZXdPk56Nk1Dga+Mzt5srm/6DA12btE8+r1C7t9CBSmkBwo3Hfqjj6Mb8vR6
 tg+TM3G1LBeSNXK4nxjLnlPiIoEL7X4Q//7jHhzVC7cNFTuivF3BEq9xCb92F4wAds+6
 wlrQPPts1zZpw5JMvTmfXlg3+KZE0AK6wEAEPQfT5+Sb8mvLhQxfAdxG2gb8wmoSLJJB
 TmOEln4YDW8P3hndFtguagY9LGjYmDu3WY4p7xJbQmUP5nfm/JA5angfK4H1ibFwJTOE
 cAW+8F0EQvtMc5V5XrU+TZ0W/wTqWj3VxqErijViSeeVEbkM/sIN4RaJiCGVtX+xNafp
 K2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=XonVBN9UhK3TNdc3A1YJVcvvL67hZKsmNPxUpmHwItk=;
 b=Tprt4rnOds3FjkUEtz44fKqVV1qxAOdM9u9ejIaurx+3dZNw9GwMaE/c0dJTRx1FNU
 rmnba6NkB4bEs8tiIqbiwA1s8SObX9ZCVRh19fcAZPGJ5F/1vOBfsgiW4Abm4GNWWLCD
 0DzFs3tu7EBmRzjvpyd4DWI6K8t9RlL9RpilJqAe/NWvnpl5JyyBh2CMw6gpXF/Yw39o
 54fbF27jXmJUvUCwSJYpEJD5WuBK/R6PVZTY/DuBtXBZGqQ76gHBrds7EZdnN0sPGAkt
 KFx2aobNEd2UEUsHpLJ+X559ylbA55IYHub7ng9EQfCPcObb0QHvC+mCtjE5e/8+5ZVH
 frtA==
X-Gm-Message-State: AOAM533YTnf11CqMl9FuSOrij1SfbgRX6qiiC8NLmwxY6+NXQhugv3fI
 LqtvUPhqpLDKOAJS1HhQ58vbdg==
X-Google-Smtp-Source: ABdhPJy4m0XfeadVPe3VvpHbxVbveI8YvM0lUgplP9BkWybjPN0yJWrOgZpbmCDr2hgqJbZc+aGBMQ==
X-Received: by 2002:a1c:790d:: with SMTP id l13mr1116489wme.101.1637339476035; 
 Fri, 19 Nov 2021 08:31:16 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id h15sm15359588wmq.32.2021.11.19.08.31.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 19 Nov 2021 08:31:14 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 053491FF96;
 Fri, 19 Nov 2021 16:31:14 +0000 (GMT)
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home> <87wnldfoul.fsf@linaro.org>
 <20211112145442.5ktlpwyolwdsxlnx@gator.home>
User-agent: mu4e 1.7.5; emacs 28.0.60
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Date: Fri, 19 Nov 2021 16:30:47 +0000
In-reply-to: <20211112145442.5ktlpwyolwdsxlnx@gator.home>
Message-ID: <877dd4umy6.fsf@linaro.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, maz@kernel.org, shashi.mallela@linaro.org,
 qemu-arm@nongnu.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

CkFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cgo+IE9uIEZyaSwgTm92
IDEyLCAyMDIxIGF0IDAyOjA4OjAxUE0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4gCj4+
IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cj4+IAo+PiA+IE9uIEZy
aSwgTm92IDEyLCAyMDIxIGF0IDExOjQ3OjMxQU0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToK
Pj4gPj4gSGksCj4+ID4+IAo+PiA+PiBTb3JyeSB0aGlzIGhhcyBiZWVuIHNpdHRpbmcgaW4gbXkg
dHJlZSBzbyBsb25nLiBUaGUgY2hhbmdlcyBhcmUgZmFpcmx5Cj4+ID4+IG1pbm9yIGZyb20gdjIu
IEkgbm8gbG9uZ2VyIHNwbGl0IHRoZSB0ZXN0cyB1cCBpbnRvIFRDRyBhbmQgS1ZNCj4+ID4+IHZl
cnNpb25zIGFuZCBpbnN0ZWFkIGp1c3QgZW5zdXJlIHRoYXQgRVJSQVRBX0ZPUkNFIGlzIGFsd2F5
cyBzZXQgd2hlbgo+PiA+PiBydW4gdW5kZXIgVENHLgo+PiA+PiAKPj4gPj4gQWxleCBCZW5uw6ll
ICgzKToKPj4gPj4gICBhcm02NDogcmVtb3ZlIGludmFsaWQgY2hlY2sgZnJvbSBpdHMtdHJpZ2dl
ciB0ZXN0Cj4+ID4+ICAgYXJtNjQ6IGVuYWJsZSBpdHMtbWlncmF0aW9uIHRlc3RzIGZvciBUQ0cK
Pj4gPj4gICBhcmNoLXJ1bjogZG8gbm90IHByb2Nlc3MgRVJSQVRBIHdoZW4gcnVubmluZyB1bmRl
ciBUQ0cKPj4gPj4gCj4+ID4+ICBzY3JpcHRzL2FyY2gtcnVuLmJhc2ggfCAgNCArKystCj4+ID4+
ICBhcm0vZ2ljLmMgICAgICAgICAgICAgfCAxNiArKysrKystLS0tLS0tLS0tCj4+ID4+ICBhcm0v
dW5pdHRlc3RzLmNmZyAgICAgfCAgMyAtLS0KPj4gPj4gIDMgZmlsZXMgY2hhbmdlZCwgOSBpbnNl
cnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkKPj4gPj4gCj4+ID4+IC0tIAo+PiA+PiAyLjMwLjIK
Pj4gPj4gCj4+ID4+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fCj4+ID4+IGt2bWFybSBtYWlsaW5nIGxpc3QKPj4gPj4ga3ZtYXJtQGxpc3RzLmNzLmNvbHVt
YmlhLmVkdQo+PiA+PiBodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3Rp
bmZvL2t2bWFybQo+PiA+Cj4+ID4gSGkgQWxleCwKPj4gPgo+PiA+IFRoYW5rcyBmb3IgdGhpcy4g
SSd2ZSBhcHBsaWVkIHRvIGFybS9xdWV1ZSwgYnV0IEkgc2VlIHRoYXQKPj4gPgo+PiA+IEZBSUw6
IGdpY3YzOiBpdHMtdHJpZ2dlcjogaW52L2ludmFsbDogZGV2Mi9ldmVudGlkPTIwIHBlbmRpbmcg
TFBJIGlzIHJlY2VpdmVkCj4+ID4KPj4gPiBjb25zaXN0ZW50bHkgZmFpbHMgZm9yIG1lLiBJcyB0
aGF0IGV4cGVjdGVkPyBEb2VzIGl0IHdvcmsgZm9yIHlvdT8KPj4gCj4+IGRvaCAtIGxvb2tzIGxp
a2UgSSBjb2NrZWQgdXAgdGhlIG1lcmdlIGNvbmZsaWN0Li4uCj4+IAo+PiBEaWQgaXQgZmFpbCBm
b3IgVENHIG9yIGZvciBLVk0gKG9yIGJvdGgpPwo+Cj4gSnVzdCBUQ0csIHdoaWNoIHdhcyB3aHkg
SSB3YXMgd29uZGVyaW5nIGlmIGl0IHdhcyBleHBlY3RlZC4gSSd2ZSBuZXZlciBydW4KPiB0aGVz
ZSB0ZXN0cyB3aXRoIFRDRyBiZWZvcmUuCgpIbW0gSSB0aGluayBleHBlY3RpbmcgdGhlIElSUSBh
dCBhbGwgaXMgYnJva2VuIHNvIEkgdGhpbmsgSSBzaG91bGQKZGVsZXRlIHRoZSB3aG9sZSBwZW5k
aW5nIHRlc3QuCgo+Cj4gVGhhbmtzLAo+IGRyZXcKCgotLSAKQWxleCBCZW5uw6llCl9fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxp
c3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlh
LmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
