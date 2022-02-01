Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B83C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  1 Feb 2022 13:10:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C826B49EFE;
	Tue,  1 Feb 2022 08:10:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LvRuf9GtM7d7; Tue,  1 Feb 2022 08:10:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EB9449F01;
	Tue,  1 Feb 2022 08:10:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E44249EFE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 08:10:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p747nwd+CD8P for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Feb 2022 08:10:48 -0500 (EST)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com
 [209.85.218.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D083749EF8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Feb 2022 08:10:48 -0500 (EST)
Received: by mail-ej1-f47.google.com with SMTP id k25so53698390ejp.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 01 Feb 2022 05:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=eC9jzuaPZejKnjk0GWhMgTqAMqfuhRTIOSuZXWu8eXw=;
 b=RVU7etuW7MdtYnJbRNNzCMVAbSLc0oeE2iBAn+ct+xMR+grBtuJ1qUUeBZLcCvGI1K
 oUvlcs7F46KsoYJ0m5IiGJqkTdBg4goYrwlXMl1TvwS5BxJiedmK6fk9xO4i1Ww1soE9
 ERYNf8mO3lqKe0csETjVPelTqe7JWgv+yMPw9RmVY0M8nsW+E6oXmVp1aV+0SRMMIdoO
 JnbOtcuAcg/CMKIh/13RQytM7CmRQrZTXGEaq8YEtXpkSsma9f2dqOqEopZOaD3LFfL6
 ccCy2nZIwqdpS1g55iRaQNL10jYJKewglt6AVfEoRzHztlTJXpB3uDKD1IZ1OtPMy/D0
 nb7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=eC9jzuaPZejKnjk0GWhMgTqAMqfuhRTIOSuZXWu8eXw=;
 b=IjDfruB1iHgfdyS2gHpzwYouVh4O8orzksgm/09SubZc1q+MkUeQhnE1mWtx7mbQSy
 7rXSoxI5wO5/w2nv5AM2UUSTiY4lQEMAVkOWAh+kdPwAQpmTB/rZAWkeVNqhMfVcmLXF
 r4OfWsO7VYlNy2tD0n8G1LJG4u10pucs5TJ1SwyUfF1TnyKqXm4HFIeuw0EP1LSJFFeR
 BD8D6bPaTYyr2RDYENk/K6iiJg3JleWrecH50WCBaqdahIRkXJhYxsIGKqNHem4LKCto
 R6phjKAtQg7wkvV+9Si4YrCowQqk60yRHvlNAtDK/NKe2DlCxwon3Fwg0jBd9BlMGvl6
 geTA==
X-Gm-Message-State: AOAM532MrtI+hlgc4qQgqXxdtfKA9LBxR2LZYmYgCPBlG6pTywd7/mx+
 PQVjnbBdBIPOdwPBJvRofwXTTQ==
X-Google-Smtp-Source: ABdhPJw4SkHe643vb01cK/lUVBDhWsTREIoWAOkvnRgbkkMXJUhRgtRI4kvtYUdz1RXFlTq+jqGZAw==
X-Received: by 2002:a17:907:1c1c:: with SMTP id
 nc28mr20850529ejc.651.1643721047776; 
 Tue, 01 Feb 2022 05:10:47 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id jl17sm14870439ejc.13.2022.02.01.05.10.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 01 Feb 2022 05:10:46 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id E8B0C1FFB7;
 Tue,  1 Feb 2022 13:10:45 +0000 (GMT)
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home> <87wnldfoul.fsf@linaro.org>
 <20211112145442.5ktlpwyolwdsxlnx@gator.home> <877dd4umy6.fsf@linaro.org>
 <20211119183059.jwrhb77jfjbv5rbz@gator.home> <87a6hlzq8t.fsf@linaro.org>
 <20211130143425.bh27yy47vpihllvs@gator.home>
User-agent: mu4e 1.7.6; emacs 28.0.91
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Date: Tue, 01 Feb 2022 13:10:13 +0000
In-reply-to: <20211130143425.bh27yy47vpihllvs@gator.home>
Message-ID: <87sft2yboq.fsf@linaro.org>
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

CkFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cgo+IE9uIFR1ZSwgTm92
IDMwLCAyMDIxIGF0IDAyOjExOjM0UE0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4gCj4+
IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cj4+IAo+PiA+IE9uIEZy
aSwgTm92IDE5LCAyMDIxIGF0IDA0OjMwOjQ3UE0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToK
Pj4gPj4gCj4+ID4+IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cj4+
ID4+IAo+PiA+PiA+IE9uIEZyaSwgTm92IDEyLCAyMDIxIGF0IDAyOjA4OjAxUE0gKzAwMDAsIEFs
ZXggQmVubsOpZSB3cm90ZToKPj4gPj4gPj4gCj4+ID4+ID4+IEFuZHJldyBKb25lcyA8ZHJqb25l
c0ByZWRoYXQuY29tPiB3cml0ZXM6Cj4+ID4+ID4+IAo+PiA+PiA+PiA+IE9uIEZyaSwgTm92IDEy
LCAyMDIxIGF0IDExOjQ3OjMxQU0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4gPj4gPj4g
Pj4gSGksCj4+ID4+ID4+ID4+IAo+PiA+PiA+PiA+PiBTb3JyeSB0aGlzIGhhcyBiZWVuIHNpdHRp
bmcgaW4gbXkgdHJlZSBzbyBsb25nLiBUaGUgY2hhbmdlcyBhcmUgZmFpcmx5Cj4+ID4+ID4+ID4+
IG1pbm9yIGZyb20gdjIuIEkgbm8gbG9uZ2VyIHNwbGl0IHRoZSB0ZXN0cyB1cCBpbnRvIFRDRyBh
bmQgS1ZNCj4+ID4+ID4+ID4+IHZlcnNpb25zIGFuZCBpbnN0ZWFkIGp1c3QgZW5zdXJlIHRoYXQg
RVJSQVRBX0ZPUkNFIGlzIGFsd2F5cyBzZXQgd2hlbgo+PiA+PiA+PiA+PiBydW4gdW5kZXIgVENH
Lgo+PiA+PiA+PiA+PiAKPj4gPj4gPj4gPj4gQWxleCBCZW5uw6llICgzKToKPj4gPj4gPj4gPj4g
ICBhcm02NDogcmVtb3ZlIGludmFsaWQgY2hlY2sgZnJvbSBpdHMtdHJpZ2dlciB0ZXN0Cj4+ID4+
ID4+ID4+ICAgYXJtNjQ6IGVuYWJsZSBpdHMtbWlncmF0aW9uIHRlc3RzIGZvciBUQ0cKPj4gPj4g
Pj4gPj4gICBhcmNoLXJ1bjogZG8gbm90IHByb2Nlc3MgRVJSQVRBIHdoZW4gcnVubmluZyB1bmRl
ciBUQ0cKPj4gPj4gPj4gPj4gCj4+ID4+ID4+ID4+ICBzY3JpcHRzL2FyY2gtcnVuLmJhc2ggfCAg
NCArKystCj4+ID4+ID4+ID4+ICBhcm0vZ2ljLmMgICAgICAgICAgICAgfCAxNiArKysrKystLS0t
LS0tLS0tCj4+ID4+ID4+ID4+ICBhcm0vdW5pdHRlc3RzLmNmZyAgICAgfCAgMyAtLS0KPj4gPj4g
Pj4gPj4gIDMgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkK
Pj4gPj4gPj4gPj4gCj4+ID4+ID4+ID4+IC0tIAo+PiA+PiA+PiA+PiAyLjMwLjIKPj4gPj4gPj4g
Pj4gCj4+ID4+ID4+ID4+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCj4+ID4+ID4+ID4+IGt2bWFybSBtYWlsaW5nIGxpc3QKPj4gPj4gPj4gPj4ga3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQo+PiA+PiA+PiA+PiBodHRwczovL2xpc3RzLmNzLmNvbHVt
YmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo+PiA+PiA+PiA+Cj4+ID4+ID4+ID4gSGkg
QWxleCwKPj4gPj4gPj4gPgo+PiA+PiA+PiA+IFRoYW5rcyBmb3IgdGhpcy4gSSd2ZSBhcHBsaWVk
IHRvIGFybS9xdWV1ZSwgYnV0IEkgc2VlIHRoYXQKPj4gPj4gPj4gPgo+PiA+PiA+PiA+IEZBSUw6
IGdpY3YzOiBpdHMtdHJpZ2dlcjogaW52L2ludmFsbDogZGV2Mi9ldmVudGlkPTIwIHBlbmRpbmcg
TFBJIGlzIHJlY2VpdmVkCj4+ID4+ID4+ID4KPj4gPj4gPj4gPiBjb25zaXN0ZW50bHkgZmFpbHMg
Zm9yIG1lLiBJcyB0aGF0IGV4cGVjdGVkPyBEb2VzIGl0IHdvcmsgZm9yIHlvdT8KPj4gPj4gPj4g
Cj4+ID4+ID4+IGRvaCAtIGxvb2tzIGxpa2UgSSBjb2NrZWQgdXAgdGhlIG1lcmdlIGNvbmZsaWN0
Li4uCj4+ID4+ID4+IAo+PiA+PiA+PiBEaWQgaXQgZmFpbCBmb3IgVENHIG9yIGZvciBLVk0gKG9y
IGJvdGgpPwo+PiA+PiA+Cj4+ID4+ID4gSnVzdCBUQ0csIHdoaWNoIHdhcyB3aHkgSSB3YXMgd29u
ZGVyaW5nIGlmIGl0IHdhcyBleHBlY3RlZC4gSSd2ZSBuZXZlciBydW4KPj4gPj4gPiB0aGVzZSB0
ZXN0cyB3aXRoIFRDRyBiZWZvcmUuCj4+ID4+IAo+PiA+PiBIbW0gSSB0aGluayBleHBlY3Rpbmcg
dGhlIElSUSBhdCBhbGwgaXMgYnJva2VuIHNvIEkgdGhpbmsgSSBzaG91bGQKPj4gPj4gZGVsZXRl
IHRoZSB3aG9sZSBwZW5kaW5nIHRlc3QuCj4+ID4KPj4gPiBGZWVsIGZyZWUgdG8gcmVwb3N0LiBJ
J2xsIHVwZGF0ZSB0aGUgcGF0Y2hlcyBpbiBhcm0vcXVldWUgYmVmb3JlIG15IG5leHQKPj4gPiBN
Ui4KPj4gCj4+IEFjdHVhbGx5IEkgdGhpbmsgdGhlIHByb2JsZW0gd2FzIHdpdGggYSByZWdyZXNz
aW9uIGluIHRoZSBUQ0cgSVRTCj4+IHN1cHBvcnQgKG5vdyBmaXhlZCBpbiBtYXN0ZXIpLiBTbyBJ
IGJlbGlldmUgYXMgb2YgdjMgZXZlcnl0aGluZyBpcwo+PiBjb3JyZWN0IChhbmQgdjQgc2hvdWxk
IGJlIGlnbm9yZWQpLgo+PiAKPj4gQXJlIHlvdSBoYXBweSB0byBhcHBseSB0aGlzIHNlcmllcyBv
ciBkbyB5b3Ugd2FudCBtZSB0byByZXBvc3QgaXQgYXMgdjU/Cj4KPiBObyBuZWVkIHRvIHJlcG9z
dC4gSSdsbCByZXRlc3QgdjMgd2l0aCBsYXRlc3QgUUVNVS4KCkdlbnRsZSBwaW5nLCBJJ20gdHJ5
aW5nIHRvIGNsZWFyIHRoaXMgb2ZmIG15IGludGVybmFsIEpJUkEgc28gbGV0IG1lCmtub3cgaWYg
eW91IHdhbnQgbWUgdG8gZG8gYW55dGhpbmcgdG8gaGVscC4KCj4KPiBUaGFua3MsCj4gZHJldwoK
Ci0tIApBbGV4IEJlbm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
