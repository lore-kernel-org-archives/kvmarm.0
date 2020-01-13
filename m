Return-Path: <SRS0=vgt5=3C=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235A3C33CAE
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jan 2020 17:38:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D0822207FF
	for <kvmarm@archiver.kernel.org>; Mon, 13 Jan 2020 17:38:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nqIxncL1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0822207FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C0BF4AC80;
	Mon, 13 Jan 2020 12:38:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Hupfbo2drhLQ; Mon, 13 Jan 2020 12:38:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 30CF54AEFC;
	Mon, 13 Jan 2020 12:38:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC7754AEF5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jan 2020 12:38:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lYQ-qduDklLj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Jan 2020 12:38:06 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 680364A5A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jan 2020 12:38:06 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id y11so9499970wrt.6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Jan 2020 09:38:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:in-reply-to:date
 :message-id:mime-version:content-transfer-encoding;
 bh=eI/hjqguFIOdMUSo3q0+87ouKq6C8zjThus+1sH1VO0=;
 b=nqIxncL1yFiSxKpJfW7b03JH6kat4Dudfk5nBxAOSe9fy852eC0rgDnVwIWEsn77zM
 dE2aPjfeec9grIBn2D6TKVGWvlCbHoPkDREmeg0ugSwGl0uKWjOqlhz9PFubYFsQ8hJq
 8AHQ6VOa8ibgvSsql/4I74XQVotBz96ZolcljqE4cr4l+8cvTw7sEml7DFJSNlRp/B9+
 eVWnY0PZROjEhdpBdVDxSkNBYF88APTOPXCBepgcHORk1RgjGlFS/BVQMBIB13S3DoM4
 qS2qi++eAdhVtdEtzeRHg8B93xPXcGOz8lnvTcAHy50WvUnbCWZgk+TBfG75rYhImHj8
 +nrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject
 :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
 bh=eI/hjqguFIOdMUSo3q0+87ouKq6C8zjThus+1sH1VO0=;
 b=dQEHJb0CJ8QmS8A8S+0RFzHBUoq0JDNJknDH1PdbMHp7hWkNWrLPWxrXB5/YT55KkZ
 71KL/GjRtXeQwZVSC+RD1Ja74kiuG9bZq2f/LUcmRsVI/0iwzOSk+AFo0YbyWK8gI1YS
 FlHZuzkksDJl2ZUYIUjD8W/VqSwlL8iQdXcGeucUsFoSZ67mI1V33UBZCWFacZZGRG2F
 l6G/sCMy58UfnAhxZx/RLOiAFH6baSThc6c7poCGsO9SmJFRNk9tV0E0bibhWs6ws1mm
 Oh5812eRyuUpBnd3Hc+lHu+ItHwKLwE6XIQ/Y4sUKr3M9m5itOD0uCBIjMA5osbGX22R
 +EaA==
X-Gm-Message-State: APjAAAWwgcCynr2sLkk7RwsaFzASS+wEYjqdWh0sh7TVHFvFoje86x0A
 d32TnMAMCmHjmr6xx4Kzyghc7A==
X-Google-Smtp-Source: APXvYqyNWRIWYrBMrEZC8POMivYqJE726L4BZ9LWUi0lr76+NdJQGfH6a/xGkKlsVQXVJu8cb+LQmw==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr20201081wrt.367.1578937085286; 
 Mon, 13 Jan 2020 09:38:05 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id x14sm14824060wmj.42.2020.01.13.09.38.04
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Jan 2020 09:38:04 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id 7EF811FF87;
 Mon, 13 Jan 2020 17:38:03 +0000 (GMT)
References: <20200110160511.17821-1-alex.bennee@linaro.org>
 <8455cdf6-e5c3-bd84-5b85-33ffad581d0e@arm.com>
User-agent: mu4e 1.3.6; emacs 28.0.50
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH] arm: expand the timer tests
In-reply-to: <8455cdf6-e5c3-bd84-5b85-33ffad581d0e@arm.com>
Date: Mon, 13 Jan 2020 17:38:03 +0000
Message-ID: <871rs3ntok.fsf@linaro.org>
MIME-Version: 1.0
Cc: linux-arm-kernel@lists.infradead.org, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

CkFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4gd3JpdGVzOgoKPiBI
aSwKPgo+IE9uIDEvMTAvMjAgNDowNSBQTSwgQWxleCBCZW5uw6llIHdyb3RlOgo+PiBUaGlzIHdh
cyBhbiBhdHRlbXB0IHRvIHJlcGxpY2F0ZSBhIFFFTVUgYnVnLiBIb3dldmVyIHRvIHRyaWdnZXIg
dGhlCj4+IGJ1ZyB5b3UgbmVlZCB0byBoYXZlIGFuIG9mZnNldCBzZXQgaW4gRUwyIHdoaWNoIGt2
bS11bml0LXRlc3RzIGlzCj4+IHVuYWJsZSB0byBkby4gSG93ZXZlciBpdCBkb2VzIGV4ZXJjaXNl
IHNvbWUgbW9yZSBjb3JuZXIgY2FzZXMuCj4+Cj4+IEJ1ZzogaHR0cHM6Ly9idWdzLmxhdW5jaHBh
ZC5uZXQvYnVncy8xODU5MDIxCj4KPiBJJ20gbm90IGF3YXJlIG9mIGFueSBCdWc6IHRhZ3MgaW4g
dGhlIExpbnV4IGtlcm5lbC4gSWYgeW91IHdhbnQgcGVvcGxlIHRvIGZvbGxvdwo+IHRoZSBsaW5r
IHRvIHRoZSBidWcsIGhvdyBhYm91dCByZWZlcmVuY2luZyBzb21ldGhpbmcgbGlrZSB0aGlzOgo+
Cj4gIlRoaXMgd2FzIGFuIGF0dGVtcHQgdG8gcmVwbGljYXRlIGEgUUVNVSBidWcgWzFdLiBbLi5d
Cj4KPiBbMV0gaHR0cHM6Ly9idWdzLmxhdW5jaHBhZC5uZXQvcWVtdS8rYnVnLzE4NTkwMjEiCgpP
SywgSSdsbCBmaXggdGhhdCBpbiB2Mi4KCj4KPiBBbHNvLCBhcmUgbGF1bmNocGFkIGJ1ZyByZXBv
cnRzIHBlcm1hbmVudD8gV2lsbCB0aGUgbGluayBzdGlsbCB3b3JrIGluCj4gYSB5ZWFycycgdGlt
ZT8KClRoZXkgc2hvdWxkIGJlIC0gdGhleSBhcmUgYSB1bmlxdWUgaWQgYW5kIHdlIHVzZSB0aGVt
IGluIHRoZSBRRU1VIHNvdXJjZQp0cmVlLgoKPgo+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4IEJlbm7D
qWUgPGFsZXguYmVubmVlQGxpbmFyby5vcmc+Cj4+IC0tLQo+PiAgYXJtL3RpbWVyLmMgfCAyNyAr
KysrKysrKysrKysrKysrKysrKysrKysrKy0KPj4gIDEgZmlsZSBjaGFuZ2VkLCAyNiBpbnNlcnRp
b25zKCspLCAxIGRlbGV0aW9uKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9hcm0vdGltZXIuYyBiL2Fy
bS90aW1lci5jCj4+IGluZGV4IGYzOTBlOGUuLmFlMWQyOTkgMTAwNjQ0Cj4+IC0tLSBhL2FybS90
aW1lci5jCj4+ICsrKyBiL2FybS90aW1lci5jCj4+IEBAIC0yMTQsMjEgKzIxNCw0NiBAQCBzdGF0
aWMgdm9pZCB0ZXN0X3RpbWVyKHN0cnVjdCB0aW1lcl9pbmZvICppbmZvKQo+PiAgCSAqIHN0aWxs
IHJlYWQgdGhlIHBlbmRpbmcgc3RhdGUgZXZlbiBpZiBpdCdzIGRpc2FibGVkLiAqLwo+PiAgCXNl
dF90aW1lcl9pcnFfZW5hYmxlZChpbmZvLCBmYWxzZSk7Cj4+ICAKPj4gKwkvKiBWZXJpZnkgY291
bnQgZ29lcyB1cCAqLwo+PiArCXJlcG9ydChpbmZvLT5yZWFkX2NvdW50ZXIoKSA+PSBub3csICJj
b3VudGVyIGluY3JlbWVudHMiKTsKPj4gKwo+PiAgCS8qIEVuYWJsZSB0aGUgdGltZXIsIGJ1dCBz
Y2hlZHVsZSBpdCBmb3IgbXVjaCBsYXRlciAqLwo+PiAgCWluZm8tPndyaXRlX2N2YWwobGF0ZXIp
Owo+PiAgCWluZm8tPndyaXRlX2N0bChBUkNIX1RJTUVSX0NUTF9FTkFCTEUpOwo+PiAgCWlzYigp
Owo+PiAtCXJlcG9ydCghZ2ljX3RpbWVyX3BlbmRpbmcoaW5mbyksICJub3QgcGVuZGluZyBiZWZv
cmUiKTsKPj4gKwlyZXBvcnQoIWdpY190aW1lcl9wZW5kaW5nKGluZm8pLCAibm90IHBlbmRpbmcg
YmVmb3JlIDEwcyIpOwo+PiArCj4+ICsJLyogQ2hlY2sgd2l0aCBhIG1heGltdW0gcG9zc2libGUg
Y3ZhbCAqLwo+PiArCWluZm8tPndyaXRlX2N2YWwoVUlOVDY0X01BWCk7Cj4+ICsJaXNiKCk7Cj4+
ICsJcmVwb3J0KCFnaWNfdGltZXJfcGVuZGluZyhpbmZvKSwgIm5vdCBwZW5kaW5nIGJlZm9yZSBV
SU5UNjRfTUFYIik7Cj4+ICsKPj4gKwkvKiBhbHNvIGJ5IHNldHRpbmcgdHZhbCAqLwo+Cj4gQWxs
IHRoZSBjb21tZW50cyBpbiB0aGlzIGZpbGUgc2VlbSB0byBzdGFydCB3aXRoIGEgY2FwaXRhbCBs
ZXR0ZXIuCj4KPj4gKwlpbmZvLT53cml0ZV90dmFsKHRpbWVfMTBzKTsKPj4gKwlpc2IoKTsKPj4g
KwlyZXBvcnQoIWdpY190aW1lcl9wZW5kaW5nKGluZm8pLCAibm90IHBlbmRpbmcgYmVmb3JlIDEw
cyAodmlhIHR2YWwpIik7Cj4KPiBZb3UgY2FuIHJlbW92ZSB0aGUgIih2aWEgdHZhbCkiIHBhcnQg
LSB0aGUgbWVzc2FnZSBpcyB1bmlxdWUgZW5vdWdoIHRvIGZpZ3VyZSBvdXQKPiB3aGljaCBwYXJ0
IG9mIHRoZSB0ZXN0IGl0IHJlZmVycyB0by4KCkkgYWRkZWQgaXQgdG8gZGlmZmVyZW50aWF0ZSB3
aXRoIHRoZSBtZXNzYWdlIGEgbGl0dGxlIGZ1cnRoZXIgYWJvdmUuCgo+PiArCXJlcG9ydF9pbmZv
KCJUVkFMIGlzICVkIChkZWx0YSBDVkFMICVsZCkgdGlja3MiLAo+PiArCQkgICAgaW5mby0+cmVh
ZF90dmFsKCksIGluZm8tPnJlYWRfY3ZhbCgpIC0gaW5mby0+cmVhZF9jb3VudGVyKCkpOwo+Cj4g
SSdtIG5vdCBzdXJlIHdoYXQgeW91IGFyZSB0cnlpbmcgdG8gYWNoaWV2ZSB3aXRoIHRoaXMuIFlv
dSBjYW4gdHJhbnNmb3JtIGl0IHRvCj4gY2hlY2sgdGhhdCBUVkFMIGlzIGluZGVlZCBwb3NpdGl2
ZSBhbmQgKGFsbW9zdCkgZXF1YWwgdG8gY3ZhbCAtIGNudHBjdCwgc29tZXRoaW5nCj4gbGlrZSB0
aGlzOgo+Cj4gKwlzMzIgdHZhbCA9IGluZm8tPnJlYWRfdHZhbCgpOwo+ICsJcmVwb3J0KHR2YWwg
PiAwICYmIHR2YWwgPD0gaW5mby0+cmVhZF9jdmFsKCkgLQo+IGluZm8tPnJlYWRfY291bnRlcigp
LCAiVFZBTCBtZWFzdXJlcyB0aW1lIHRvIG5leHQgaW50ZXJydXB0Iik7CgpZZXMgaXQgd2FzIHB1
cmVseSBpbmZvcm1hdGlvbmFsIHRvIHNheSB0dmFsIGRlY3JlbWVudHMgdG93YXJkcyB0aGUgbmV4
dApJUlEuIEkgY2FuIG1ha2UgaXQgYSBwdXJlIHRlc3QuCgo+Cj4+ICAKPj4gKyAgICAgICAgLyog
Y2hlY2sgcGVuZGluZyBvbmNlIGN2YWwgaXMgYmVmb3JlIG5vdyAqLwo+Cj4gVGhpcyBjb21tZW50
IGFkZHMgbm90aGluZyB0byB0aGUgdGVzdC4KCmRyb3BwZWQuCgo+Cj4+ICAJaW5mby0+d3JpdGVf
Y3ZhbChub3cgLSAxKTsKPj4gIAlpc2IoKTsKPj4gIAlyZXBvcnQoZ2ljX3RpbWVyX3BlbmRpbmco
aW5mbyksICJpbnRlcnJ1cHQgc2lnbmFsIHBlbmRpbmciKTsKPj4gKwlyZXBvcnRfaW5mbygiVFZB
TCBpcyAlZCB0aWNrcyIsIGluZm8tPnJlYWRfdHZhbCgpKTsKPgo+IFlvdSBjYW4gdGVzdCB0aGF0
IFRWQUwgaXMgbmVnYXRpdmUgaGVyZSBpbnN0ZWFkIG9mIHByaW50aW5nIHRoZSB2YWx1ZS4KCm9r
LgoKPgo+PiAgCj4+ICAJLyogRGlzYWJsZSB0aGUgdGltZXIgYWdhaW4gYW5kIHByZXBhcmUgdG8g
dGFrZSBpbnRlcnJ1cHRzICovCj4+ICAJaW5mby0+d3JpdGVfY3RsKDApOwo+PiAgCXNldF90aW1l
cl9pcnFfZW5hYmxlZChpbmZvLCB0cnVlKTsKPj4gIAlyZXBvcnQoIWdpY190aW1lcl9wZW5kaW5n
KGluZm8pLCAiaW50ZXJydXB0IHNpZ25hbCBubyBsb25nZXIgcGVuZGluZyIpOwo+PiAgCj4+ICsJ
LyogUUVNVSBidWcgd2hlbiBjbnR2b2ZmX2VsMiA+IDAKPj4gKwkgKiBodHRwczovL2J1Z3MubGF1
bmNocGFkLm5ldC9idWdzLzE4NTkwMjEgKi8KPgo+IFRoaXMgbG9va3MgY29uZnVzaW5nIHRvIG1l
LiBGcm9tIHRoZSBjb21taXQgbWVzc2FnZSwgSSBnb3QgdGhhdCBrdm0tdW5pdC10ZXN0cwo+IG5l
ZWRzIHFlbXUgdG8gc2V0IGEgc3BlY2lhbCB2YWx1ZSBmb3IgQ05UVk9GRl9FTDIuIEJ1dCB0aGUg
Y29tbWVudHMgc2VlbXMgdG8KPiBzdWdnZXN0IHRoYXQga3ZtLXVuaXQtdGVzdHMgY2FuIHRyaWdn
ZXIgdGhlIGJ1ZyB3aXRob3V0IHFlbXUgZG9pbmcgYW55dGhpbmcKPiBzcGVjaWFsLiBDYW4geW91
IGVsYWJvcmF0ZSB1bmRlciB3aGljaCBjb25kaXRpb24ga3ZtLXVuaXQtdGVzdHMgY2FuCj4gdHJp
Z2dlciB0aGUgYnVnPwoKSXQgY2FuJ3Qgd2l0aG91dCBzb21lIHNvcnQgb2YgbWVjaGFuaXNtIHRv
IHNldCB0aGUgaHlwZXJ2aXNvciByZWdpc3RlcnMKYmVmb3JlIHJ1bm5pbmcgdGhlIHRlc3QuIFRo
ZSBRRU1VIGJ1ZyBpcyBhbiBvdmVyZmxvdyB3aGVuIGN2YWwgb2YgVUlOVDY0X01BWAp3aXRoIGEg
bm9uLXplcm8gQ05UVk9GRl9FTDIuCgpSdW5uaW5nIHVuZGVyIEtWTSB0aGUgaG9zdCBrZXJuZWwg
d2lsbCBoYXZlIGxpa2VseSBzZXQgQ05UVk9GRl9FTDIgdG8Kc29tZSBzb3J0IG9mIHZhbHVlIHdp
dGg6CgoJdXBkYXRlX3Z0aW1lcl9jbnR2b2ZmKHZjcHUsIGt2bV9waHlzX3RpbWVyX3JlYWQoKSk7
Cgo+Cj4+ICsJaW5mby0+d3JpdGVfY3RsKEFSQ0hfVElNRVJfQ1RMX0VOQUJMRSk7Cj4+ICsJaW5m
by0+d3JpdGVfY3ZhbChVSU5UNjRfTUFYKTsKPgo+IFRoZSBvcmRlciBpcyB3cm9uZyAtIHlvdSB3
cml0ZSBDVkFMIGZpcnN0LCAqdGhlbiogZW5hYmxlIHRvIHRpbWVyLiBPdGhlcndpc2UgeW91Cj4g
bWlnaHQgZ2V0IGFuIGludGVycnVwdCBiZWNhdXNlIG9mIHRoZSBwcmV2aW91cyBDVkFMIHZhbHVl
Lgo+Cj4gVGhlIHByZXZpb3VzIHZhbHVlIGZvciBDVkFMIHdhcyBub3cgLTEsIHNvIHlvdXIgY2hh
bmdlIHRyaWdnZXJzIGFuIHVud2FudGVkCj4gaW50ZXJydXB0IGFmdGVyIGVuYWJsaW5nIHRoZSB0
aW1lci4gVGhlIGludGVycnVwdCBoYW5kbGVyIG1hc2tzIHRoZSB0aW1lcgo+IGludGVycnVwdCBh
dCB0aGUgdGltZXIgbGV2ZWwsIHdoaWNoIG1lYW5zIHRoYXQgYXMgZmFyIGFzIHRoZSBnaWMgaXMg
Y29uY2VybmVkIHRoZQo+IGludGVycnVwdCBpcyBub3QgcGVuZGluZywgbWFraW5nIHRoZSByZXBv
cnQgY2FsbCBhZnRlcndhcmRzIHVzZWxlc3MuCj4KPj4gKwlpc2IoKTsKPj4gKwlyZXBvcnQoIWdp
Y190aW1lcl9wZW5kaW5nKGluZm8pLCAibm90IHBlbmRpbmcgYmVmb3JlIFVJTlQ2NF9NQVggKGly
cXMgb24pIik7Cj4KPiBUaGlzIGNoZWNrIGNhbiBiZSBpbXByb3ZlZC4gWW91IHdhbnQgdG8gY2hl
Y2sgdGhlIHRpbWVyIENUTC5JU1RBVFVTIGhlcmUsIG5vdCB0aGUKPiBnaWMuIEEgZGV2aWNlIChp
biB0aGlzIGNhc2UsIHRoZSB0aW1lcikgY2FuIGFzc2VydCB0aGUgaW50ZXJydXB0LCBidXQgdGhl
IGdpYyBkb2VzCj4gbm90IHNhbXBsZSBpdCBpbW1lZGlhdGVseS4gQ29tZSB0byB0aGluayBvZiBp
dCwgdGhlIGVudGlyZSB0aW1lciB0ZXN0IGlzIHdyb25nCj4gYmVjYXVzZSBvZiB0aGlzLgoKSXMg
aXQgd29ydGggc3RpbGwgY2hlY2tpbmcgdGhlIEdJQyBvciBqdXN0IHJlcGxhY2luZyBldmVyeXRo
aW5nIHdpdGgKY2FsbHMgdG86CgogIHN0YXRpYyBib29sIHRpbWVyX3BlbmRpbmcoc3RydWN0IHRp
bWVyX2luZm8gKmluZm8pCiAgewogICAgICAgICAgcmV0dXJuIGluZm8tPnJlYWRfY3RsKCkgJiBB
UkNIX1RJTUVSX0NUTF9JU1RBVFVTOwogIH0KCj4KPiBUaGFua3MsCj4gQWxleAo+PiArCWluZm8t
PndyaXRlX2N0bCgwKTsKPj4gKwo+PiAgCXJlcG9ydCh0ZXN0X2N2YWxfMTBtc2VjKGluZm8pLCAi
bGF0ZW5jeSB3aXRoaW4gMTAgbXMiKTsKPj4gIAlyZXBvcnQoaW5mby0+aXJxX3JlY2VpdmVkLCAi
aW50ZXJydXB0IHJlY2VpdmVkIik7Cj4+ICAKCgotLSAKQWxleCBCZW5uw6llCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
