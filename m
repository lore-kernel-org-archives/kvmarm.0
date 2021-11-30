Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A2BC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 30 Nov 2021 14:13:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 693904B18A;
	Tue, 30 Nov 2021 09:13:00 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UHc6DLbq8RdI; Tue, 30 Nov 2021 09:12:58 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C3F44B19D;
	Tue, 30 Nov 2021 09:12:58 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3FDF4B18A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 09:12:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tpeAkqf+suDP for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Nov 2021 09:12:52 -0500 (EST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 973434B130
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 09:12:52 -0500 (EST)
Received: by mail-wm1-f49.google.com with SMTP id o29so17579042wms.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Nov 2021 06:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=8Xn93JXcXYRTtOD7EOYXIoNbaeFJmOBsAiqitoLCgJk=;
 b=ywuB381uBd+1hkeF830EzjJV9PawMLMyPgGheyiUNoGiytxE9CgXK+tu0Xcv2uisGh
 RTRhw0w36uD0f/XK/ILRhM7WJEcb5SL+qJn5P0DLZLzilOOstZS8Kx7s81HK8HEDhv8/
 Z+Simda2xsu44BdPlX3XXhLBt+cv/SdxOCwNdGgaPrzlDFuomkTZkofVEd0g01KNoI+m
 QjEGkdpVfjkvGaDwfemisa30Z4SMegqTCYo+gqm9AK6A/74rUV0xdkzeNmSKIeG3q2ZJ
 Sxw0XnIj2SK8ZvN/J1W/x41xIlUHWJg9TFajZFfsFIbiEb1Myyr5ZjgZXA0a1ikJDoiN
 XLOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=8Xn93JXcXYRTtOD7EOYXIoNbaeFJmOBsAiqitoLCgJk=;
 b=n5gnPUhcIhuOyvANqHu6hHv/ipSMLh3WTVkAWkQPossHY5GT8BtTRRqEh7/dsH0oGN
 GND7NwdDt6gIm6hCZq0qXFT0meGUYFKRxi39ypmnGWnBwEAw6/GLl21r+ek8nVSuNJKa
 nprO+NLrJX1bnUcJB4zr88OHsiiMFrgO3Yy3DOBQsvmMWr9Aez8apOFhUIFHIcSB6iy0
 o5vEb0VSmidBj4o3GPY+ifZZ3qEcJy6VSKsSwZLGGG1ktTB7c6Y82vxaHYovip0i8LYb
 Z4wbyHof+DGuFV7ZEQf2QsTTc2uIbFQ6zW3jAe9x5hDYdQ0WpUfsnivMR5zDzGSmvKzx
 UkcQ==
X-Gm-Message-State: AOAM530og2BhVGnlDRadrMMP4FSV13D97d2ZqSd/LDpLU4rqXjR1QGoZ
 3RAcWlg/sFKLskl6FETQ7EpJ3Q==
X-Google-Smtp-Source: ABdhPJzSykfHQLSLPFOrDvCzXmZApy1OjVhVgAuZ/JmM7o9Bb+dUIPemMJrbmTKFbG6uFli3i/0RRg==
X-Received: by 2002:a05:600c:294c:: with SMTP id
 n12mr5276099wmd.71.1638281571604; 
 Tue, 30 Nov 2021 06:12:51 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id x13sm16592862wrr.47.2021.11.30.06.12.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 30 Nov 2021 06:12:50 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 1E4681FF96;
 Tue, 30 Nov 2021 14:12:50 +0000 (GMT)
References: <20211112114734.3058678-1-alex.bennee@linaro.org>
 <20211112132312.qrgmby55mlenj72p@gator.home> <87wnldfoul.fsf@linaro.org>
 <20211112145442.5ktlpwyolwdsxlnx@gator.home> <877dd4umy6.fsf@linaro.org>
 <20211119183059.jwrhb77jfjbv5rbz@gator.home>
User-agent: mu4e 1.7.5; emacs 28.0.60
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] GIC ITS tests
Date: Tue, 30 Nov 2021 14:11:34 +0000
In-reply-to: <20211119183059.jwrhb77jfjbv5rbz@gator.home>
Message-ID: <87a6hlzq8t.fsf@linaro.org>
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
IDE5LCAyMDIxIGF0IDA0OjMwOjQ3UE0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4gCj4+
IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cj4+IAo+PiA+IE9uIEZy
aSwgTm92IDEyLCAyMDIxIGF0IDAyOjA4OjAxUE0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToK
Pj4gPj4gCj4+ID4+IEFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cj4+
ID4+IAo+PiA+PiA+IE9uIEZyaSwgTm92IDEyLCAyMDIxIGF0IDExOjQ3OjMxQU0gKzAwMDAsIEFs
ZXggQmVubsOpZSB3cm90ZToKPj4gPj4gPj4gSGksCj4+ID4+ID4+IAo+PiA+PiA+PiBTb3JyeSB0
aGlzIGhhcyBiZWVuIHNpdHRpbmcgaW4gbXkgdHJlZSBzbyBsb25nLiBUaGUgY2hhbmdlcyBhcmUg
ZmFpcmx5Cj4+ID4+ID4+IG1pbm9yIGZyb20gdjIuIEkgbm8gbG9uZ2VyIHNwbGl0IHRoZSB0ZXN0
cyB1cCBpbnRvIFRDRyBhbmQgS1ZNCj4+ID4+ID4+IHZlcnNpb25zIGFuZCBpbnN0ZWFkIGp1c3Qg
ZW5zdXJlIHRoYXQgRVJSQVRBX0ZPUkNFIGlzIGFsd2F5cyBzZXQgd2hlbgo+PiA+PiA+PiBydW4g
dW5kZXIgVENHLgo+PiA+PiA+PiAKPj4gPj4gPj4gQWxleCBCZW5uw6llICgzKToKPj4gPj4gPj4g
ICBhcm02NDogcmVtb3ZlIGludmFsaWQgY2hlY2sgZnJvbSBpdHMtdHJpZ2dlciB0ZXN0Cj4+ID4+
ID4+ICAgYXJtNjQ6IGVuYWJsZSBpdHMtbWlncmF0aW9uIHRlc3RzIGZvciBUQ0cKPj4gPj4gPj4g
ICBhcmNoLXJ1bjogZG8gbm90IHByb2Nlc3MgRVJSQVRBIHdoZW4gcnVubmluZyB1bmRlciBUQ0cK
Pj4gPj4gPj4gCj4+ID4+ID4+ICBzY3JpcHRzL2FyY2gtcnVuLmJhc2ggfCAgNCArKystCj4+ID4+
ID4+ICBhcm0vZ2ljLmMgICAgICAgICAgICAgfCAxNiArKysrKystLS0tLS0tLS0tCj4+ID4+ID4+
ICBhcm0vdW5pdHRlc3RzLmNmZyAgICAgfCAgMyAtLS0KPj4gPj4gPj4gIDMgZmlsZXMgY2hhbmdl
ZCwgOSBpbnNlcnRpb25zKCspLCAxNCBkZWxldGlvbnMoLSkKPj4gPj4gPj4gCj4+ID4+ID4+IC0t
IAo+PiA+PiA+PiAyLjMwLjIKPj4gPj4gPj4gCj4+ID4+ID4+IF9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCj4+ID4+ID4+IGt2bWFybSBtYWlsaW5nIGxpc3QK
Pj4gPj4gPj4ga3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQo+PiA+PiA+PiBodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo+PiA+PiA+Cj4+ID4+
ID4gSGkgQWxleCwKPj4gPj4gPgo+PiA+PiA+IFRoYW5rcyBmb3IgdGhpcy4gSSd2ZSBhcHBsaWVk
IHRvIGFybS9xdWV1ZSwgYnV0IEkgc2VlIHRoYXQKPj4gPj4gPgo+PiA+PiA+IEZBSUw6IGdpY3Yz
OiBpdHMtdHJpZ2dlcjogaW52L2ludmFsbDogZGV2Mi9ldmVudGlkPTIwIHBlbmRpbmcgTFBJIGlz
IHJlY2VpdmVkCj4+ID4+ID4KPj4gPj4gPiBjb25zaXN0ZW50bHkgZmFpbHMgZm9yIG1lLiBJcyB0
aGF0IGV4cGVjdGVkPyBEb2VzIGl0IHdvcmsgZm9yIHlvdT8KPj4gPj4gCj4+ID4+IGRvaCAtIGxv
b2tzIGxpa2UgSSBjb2NrZWQgdXAgdGhlIG1lcmdlIGNvbmZsaWN0Li4uCj4+ID4+IAo+PiA+PiBE
aWQgaXQgZmFpbCBmb3IgVENHIG9yIGZvciBLVk0gKG9yIGJvdGgpPwo+PiA+Cj4+ID4gSnVzdCBU
Q0csIHdoaWNoIHdhcyB3aHkgSSB3YXMgd29uZGVyaW5nIGlmIGl0IHdhcyBleHBlY3RlZC4gSSd2
ZSBuZXZlciBydW4KPj4gPiB0aGVzZSB0ZXN0cyB3aXRoIFRDRyBiZWZvcmUuCj4+IAo+PiBIbW0g
SSB0aGluayBleHBlY3RpbmcgdGhlIElSUSBhdCBhbGwgaXMgYnJva2VuIHNvIEkgdGhpbmsgSSBz
aG91bGQKPj4gZGVsZXRlIHRoZSB3aG9sZSBwZW5kaW5nIHRlc3QuCj4KPiBGZWVsIGZyZWUgdG8g
cmVwb3N0LiBJJ2xsIHVwZGF0ZSB0aGUgcGF0Y2hlcyBpbiBhcm0vcXVldWUgYmVmb3JlIG15IG5l
eHQKPiBNUi4KCkFjdHVhbGx5IEkgdGhpbmsgdGhlIHByb2JsZW0gd2FzIHdpdGggYSByZWdyZXNz
aW9uIGluIHRoZSBUQ0cgSVRTCnN1cHBvcnQgKG5vdyBmaXhlZCBpbiBtYXN0ZXIpLiBTbyBJIGJl
bGlldmUgYXMgb2YgdjMgZXZlcnl0aGluZyBpcwpjb3JyZWN0IChhbmQgdjQgc2hvdWxkIGJlIGln
bm9yZWQpLgoKQXJlIHlvdSBoYXBweSB0byBhcHBseSB0aGlzIHNlcmllcyBvciBkbyB5b3Ugd2Fu
dCBtZSB0byByZXBvc3QgaXQgYXMgdjU/Cgo+Cj4gVGhhbmtzLAo+IGRyZXcKCgotLSAKQWxleCBC
ZW5uw6llCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
