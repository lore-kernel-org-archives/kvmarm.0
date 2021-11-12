Return-Path: <SRS0=9vag=P7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2F9EC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 14:25:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1C2D26103D
	for <kvmarm@archiver.kernel.org>; Fri, 12 Nov 2021 14:25:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 1C2D26103D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 813A74B2C5;
	Fri, 12 Nov 2021 09:25:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0Q5kEBMDm8e6; Fri, 12 Nov 2021 09:25:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54F434B2D0;
	Fri, 12 Nov 2021 09:25:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E02E4B2C5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 09:25:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id On3o2QpTB48E for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Nov 2021 09:25:00 -0500 (EST)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com
 [209.85.128.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F0DD4B2C4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 09:25:00 -0500 (EST)
Received: by mail-wm1-f48.google.com with SMTP id
 67-20020a1c1946000000b0030d4c90fa87so6893485wmz.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Nov 2021 06:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=mCchX4v/Fcx1Qw8e/Kgnp+lsdk0xg73uHEXcXcz9oFU=;
 b=aH4TB+ISknzm/p2JFPos2dzjfyrQ+pheBKg1LdACZsb/bOtxlFt/AU1GFR+BjlnnHc
 Ael6r7GaYyw6vn4DwRU/OzyHafc/OLskHJ4KyHqwXsmgy5B83QBfXzjRulh6w+hRs4P1
 QHDgu7KHsatnKVwdLkaGxKIcqkc2HVdNrRC0mRcr34ynmUxF5U7SdeqWudmCBkOXK8++
 7xfsggB6FsYk6UkITpYPtph+fRWFU65h/toNZJ/KFLrHEWWI6YVpxhbyFyzBUuzDmtae
 36F529MdcPzazY0eqbaFqV8iy8JENrzYEC+TrVXLHS7/s+j4lhxwshKXBJ84Pbgms4LA
 n9Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=mCchX4v/Fcx1Qw8e/Kgnp+lsdk0xg73uHEXcXcz9oFU=;
 b=sj2OTd2q44WUyPhdtRcu3jx99BZRu6os36/vaI7tQSDUQARt8OpLDwG7BSy2Kio4hm
 NN/rtsd6QQkX4MyK7iQuSNzcsnCZBt09XDDYHG9X0tR5ywWWJmSqeaY/jTn3/9D/hoit
 a7F9xYTbbUycI0451m3PzejDdhLlhzh/zVLOTPijgDYnCP2TBdVia0KJmTT9+gir1r0x
 hhCgJRnCAV19OuAMpuNhzsZd/ZmKiw56GsYafM3+DVXi3x7rgruUqq0FQHjea5722gqV
 Rz2hDDyWaKF3D0j8CGFOa5wtsbiATVJFHLYOoB6m0xJFY2B2MQNdEhB+SjDH/HFdHkQD
 P81Q==
X-Gm-Message-State: AOAM530Lkj0a/SMYEwln8l1H2ErR0eIcKgfkkEdaSdAIbsdMNdxc3s/H
 r1uh0XrJJEdHnaBm0OYSQ9oztw==
X-Google-Smtp-Source: ABdhPJx6dd8ODC5PRVeasF6GbND+Y3hUscef1E1G4kdca1HAtVpCh/e4iiU0gQT560sssELYvgYphA==
X-Received: by 2002:a1c:9d48:: with SMTP id g69mr36632983wme.188.1636727099083; 
 Fri, 12 Nov 2021 06:24:59 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id m14sm8352559wrp.28.2021.11.12.06.24.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 12 Nov 2021 06:24:58 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 9AA281FF96;
 Fri, 12 Nov 2021 14:24:57 +0000 (GMT)
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home>
User-agent: mu4e 1.7.4; emacs 28.0.60
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Date: Fri, 12 Nov 2021 14:24:18 +0000
In-reply-to: <20211112132312.qrgmby55mlenj72p@gator.home>
Message-ID: <87sfw1fo3q.fsf@linaro.org>
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
IDEyLCAyMDIxIGF0IDExOjQ3OjMxQU0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4gSGks
Cj4+IAo+PiBTb3JyeSB0aGlzIGhhcyBiZWVuIHNpdHRpbmcgaW4gbXkgdHJlZSBzbyBsb25nLiBU
aGUgY2hhbmdlcyBhcmUgZmFpcmx5Cj4+IG1pbm9yIGZyb20gdjIuIEkgbm8gbG9uZ2VyIHNwbGl0
IHRoZSB0ZXN0cyB1cCBpbnRvIFRDRyBhbmQgS1ZNCj4+IHZlcnNpb25zIGFuZCBpbnN0ZWFkIGp1
c3QgZW5zdXJlIHRoYXQgRVJSQVRBX0ZPUkNFIGlzIGFsd2F5cyBzZXQgd2hlbgo+PiBydW4gdW5k
ZXIgVENHLgo+PiAKPj4gQWxleCBCZW5uw6llICgzKToKPj4gICBhcm02NDogcmVtb3ZlIGludmFs
aWQgY2hlY2sgZnJvbSBpdHMtdHJpZ2dlciB0ZXN0Cj4+ICAgYXJtNjQ6IGVuYWJsZSBpdHMtbWln
cmF0aW9uIHRlc3RzIGZvciBUQ0cKPj4gICBhcmNoLXJ1bjogZG8gbm90IHByb2Nlc3MgRVJSQVRB
IHdoZW4gcnVubmluZyB1bmRlciBUQ0cKPj4gCj4+ICBzY3JpcHRzL2FyY2gtcnVuLmJhc2ggfCAg
NCArKystCj4+ICBhcm0vZ2ljLmMgICAgICAgICAgICAgfCAxNiArKysrKystLS0tLS0tLS0tCj4+
ICBhcm0vdW5pdHRlc3RzLmNmZyAgICAgfCAgMyAtLS0KPj4gIDMgZmlsZXMgY2hhbmdlZCwgOSBp
bnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkKPj4gCj4+IC0tIAo+PiAyLjMwLjIKPj4gCj4+
IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCj4+IGt2bWFy
bSBtYWlsaW5nIGxpc3QKPj4ga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQo+PiBodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo+Cj4gSGkgQWxl
eCwKPgo+IFRoYW5rcyBmb3IgdGhpcy4gSSd2ZSBhcHBsaWVkIHRvIGFybS9xdWV1ZSwgYnV0IEkg
c2VlIHRoYXQKPgo+IEZBSUw6IGdpY3YzOiBpdHMtdHJpZ2dlcjogaW52L2ludmFsbDogZGV2Mi9l
dmVudGlkPTIwIHBlbmRpbmcgTFBJIGlzIHJlY2VpdmVkCj4KPiBjb25zaXN0ZW50bHkgZmFpbHMg
Zm9yIG1lLiBJcyB0aGF0IGV4cGVjdGVkPyBEb2VzIGl0IHdvcmsgZm9yIHlvdT8KCkhtbSBzbyBp
dCB3b3JrcyB3aXRoIEtWTSBzbyBJIHN1c3BlY3QgaXQncyBzaG93aW5nIHVwIGFuIGVycm9yIGlu
IHRoZQpUQ0cgSVRTIGltcGxlbWVudGF0aW9uIHdoaWNoIEkgZGlkbid0IHNlZSBpbiBlYXJsaWVy
IHJ1bnMuCgo+Cj4gVGhhbmtzLAo+IGRyZXcKCgotLSAKQWxleCBCZW5uw6llCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
