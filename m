Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D173C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 18:29:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5CD249EF7;
	Tue, 25 Jan 2022 13:29:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1bzQfneJiyHE; Tue, 25 Jan 2022 13:29:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E13949EE9;
	Tue, 25 Jan 2022 13:29:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DEEA349EC5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 13:29:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gm+HW6WzFU6d for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 13:29:17 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ADB6049E08
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 13:29:17 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643135357;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=OguiwXEbcW8UNqgrCV2TtbVUcGVCkasrwnWQMbIucmw=;
 b=No4YgpPRSKsVkH9izR0gP5hXe596UNPOQiHCroYMUoHClHIbiw4UqjjC53dg7z08VxNlGu
 +GFVxDpsJYEYKeEsd4cs5T+Ov4VEbpIUtcJQCajz7fJAQTd3D+MnnxD7KiOSdJDWKzX9yx
 5+6dKITjz/p6qkJKrzgFYDbXbEY81mE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-1uVGVWaAOh6EnpE4RtsWOw-1; Tue, 25 Jan 2022 13:29:16 -0500
X-MC-Unique: 1uVGVWaAOh6EnpE4RtsWOw-1
Received: by mail-wm1-f72.google.com with SMTP id
 c16-20020a1c9a10000000b0034dd409329eso1889534wme.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 10:29:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=OguiwXEbcW8UNqgrCV2TtbVUcGVCkasrwnWQMbIucmw=;
 b=1xVwlMrAxVCKGvrjIq6iHFRbDgoq4qViFsBTyg/Vt05fArtfR4lUAeHkdhP3x9FF56
 erMNeTbDpGv+2sJlD1dY5a+Rjhdyl93/feTBlHw3yvGI3lr37tRkbtH4usRQLzm+mCO0
 et8mbrClcdDg10DnVtgZ2VPuywcDZ/0dzoMtNiFPGSkU8xMIxT32Wo33aj/civjNlBni
 a8oQNDRfAEhvlRE7NtyGVKKtsaD9DBXKQ7CtRcixcu0pC4Zm6Oy3tU5vxIY9HL8on7Sr
 Ep6NR52nkpC0Ft92+S2V7M0V6GV1qTcAPB+PX/3gc0mzXl9mdgblmBqlATUPE4XQi7dP
 s2gg==
X-Gm-Message-State: AOAM533NxdjyLzcsxBhGEPdQNmJR2qAls6lvXPAc6fPgMggxSrd7ehQX
 TzEpqfXvVOmoPWV/acDw6Yc4lJmPRQiGi1+dSq+D9U1QwW4DpNrN5dKYoc3RvKfa2dnHUWzfnWL
 PumhDlP5dxSLcdgM9/zWsu8Lv
X-Received: by 2002:a1c:a98f:: with SMTP id s137mr4093519wme.51.1643135354830; 
 Tue, 25 Jan 2022 10:29:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUlVxRuqvD0OsvPGHGKQUo7uU7drlEMBvdZthikmOuCgmqnzJuuqfomDCZp9tl7pdc4yBi/w==
X-Received: by 2002:a1c:a98f:: with SMTP id s137mr4093493wme.51.1643135354598; 
 Tue, 25 Jan 2022 10:29:14 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id 21sm1093214wmk.45.2022.01.25.10.29.13
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 25 Jan 2022 10:29:14 -0800 (PST)
Subject: Re: [PATCH v4 06/21] KVM: arm64: Support SDEI_EVENT_CONTEXT hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-7-gshan@redhat.com>
 <d9471e38-1840-1f79-c028-8f78afc0d2c7@redhat.com>
 <28219c6a-5200-b8f3-09e1-6aa08565030a@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <33a1ba7a-ad97-00db-a381-3dbc88835e15@redhat.com>
Date: Tue, 25 Jan 2022 19:29:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <28219c6a-5200-b8f3-09e1-6aa08565030a@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org, pbonzini@redhat.com, will@kernel.org,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com
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

SGkgR2F2aW4sCgpPbiAxLzEyLzIyIDM6MzMgQU0sIEdhdmluIFNoYW4gd3JvdGU6Cj4gSGkgRXJp
YywKPiAKPiBPbiAxMS8xMC8yMSA3OjE2IFBNLCBFcmljIEF1Z2VyIHdyb3RlOgo+PiBPbiA4LzE1
LzIxIDI6MTMgQU0sIEdhdmluIFNoYW4gd3JvdGU6Cj4+PiBUaGlzIHN1cHBvcnRzIFNERUlfRVZF
TlRfQ09OVEVYVCBoeXBlcmNhbGwuIEl0J3MgdXNlZCBieSB0aGUgZ3Vlc3QKPj4+IHRvIHJldHJp
ZXZlZCB0aGUgb3JpZ2luYWwgcmVnaXN0ZXJzIChSMCAtIFIxNykgaW4gaXRzIFNERUkgZXZlbnQK
Pj4+IGhhbmRsZXIuIFRob3NlIHJlZ2lzdGVycyBjYW4gYmUgY29ycnVwdGVkIGR1cmluZyB0aGUg
U0RFSSBldmVudAo+Pj4gZGVsaXZlcnkuCj4+Pgo+Pj4gU2lnbmVkLW9mZi1ieTogR2F2aW4gU2hh
biA8Z3NoYW5AcmVkaGF0LmNvbT4KPj4+IC0tLQo+Pj4gwqAgYXJjaC9hcm02NC9rdm0vc2RlaS5j
IHwgNDAgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+Pj4gwqAgMSBm
aWxlIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKykKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cm02NC9rdm0vc2RlaS5jIGIvYXJjaC9hcm02NC9rdm0vc2RlaS5jCj4+PiBpbmRleCBiMDIyY2Uw
YTIwMmIuLmI0MTYyZWZkYTQ3MCAxMDA2NDQKPj4+IC0tLSBhL2FyY2gvYXJtNjQva3ZtL3NkZWku
Ywo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vc2RlaS5jCj4+PiBAQCAtMjcwLDYgKzI3MCw0NCBA
QCBzdGF0aWMgdW5zaWduZWQgbG9uZwo+Pj4ga3ZtX3NkZWlfaHlwZXJjYWxsX2VuYWJsZShzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUsCj4+PiDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+PiDCoCB9Cj4+
PiDCoCArc3RhdGljIHVuc2lnbmVkIGxvbmcga3ZtX3NkZWlfaHlwZXJjYWxsX2NvbnRleHQoc3Ry
dWN0IGt2bV92Y3B1Cj4+PiAqdmNwdSkKPj4+ICt7Cj4+PiArwqDCoMKgIHN0cnVjdCBrdm0gKmt2
bSA9IHZjcHUtPmt2bTsKPj4+ICvCoMKgwqAgc3RydWN0IGt2bV9zZGVpX2t2bSAqa3NkZWkgPSBr
dm0tPmFyY2guc2RlaTsKPj4+ICvCoMKgwqAgc3RydWN0IGt2bV9zZGVpX3ZjcHUgKnZzZGVpID0g
dmNwdS0+YXJjaC5zZGVpOwo+Pj4gK8KgwqDCoCBzdHJ1Y3Qga3ZtX3NkZWlfdmNwdV9yZWdzICpy
ZWdzOwo+Pj4gK8KgwqDCoCB1bnNpZ25lZCBsb25nIGluZGV4ID0gc21jY2NfZ2V0X2FyZzEodmNw
dSk7Cj4+IHMvaW5kZXgvcGFyYW1faWQgdG8gbWF0Y2ggdGhlIHNwZWM/Cj4gCj4gU3VyZSwgYnV0
ICJyZWdfaWQiIHNlZW1zIGJldHRlciBoZXJlLiBBcyB0aGUgcGFyYW1ldGVyIGluZGljYXRlcyB0
aGUgR1BSCj4gaW5kZXgKPiB0byBiZSBmZXRjaGVkIG9uIHJlcXVlc3Qgb2YgdGhlIGd1ZXN0IGtl
cm5lbC4KZmluZSB3aXRoIG1lLgo+IAo+Pj4gK8KgwqDCoCB1bnNpZ25lZCBsb25nIHJldCA9IFNE
RUlfU1VDQ0VTUzsKPj4+ICsKPj4+ICvCoMKgwqAgLyogU2FuaXR5IGNoZWNrICovCj4+PiArwqDC
oMKgIGlmICghKGtzZGVpICYmIHZzZGVpKSkgewo+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldCA9IFNE
RUlfTk9UX1NVUFBPUlRFRDsKPj4+ICvCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsKPj4+ICvCoMKg
wqAgfQo+Pj4gKwo+Pj4gK8KgwqDCoCBpZiAoaW5kZXggPiBBUlJBWV9TSVpFKHZzZGVpLT5zdGF0
ZS5jcml0aWNhbF9yZWdzLnJlZ3MpKSB7Cj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0gU0RFSV9J
TlZBTElEX1BBUkFNRVRFUlM7Cj4+PiArwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+PiArwqDC
oMKgIH0KPj4gSSB3b3VsZCBtb3ZlIHRoZSBhYm92ZSBhZnRlciByZWdzID0gYW5kIHVzZSByZWdz
IHRoZXJlIChhbHRob3VnaCB0aGUKPj4gcmVncyBBUlJBWV9TSVpFIG9mIGJvdGggaXMgaWRlbnRp
ZmljYWwpCj4gCj4gT2suCj4gCj4+PiArCj4+PiArwqDCoMKgIC8qIENoZWNrIGlmIHRoZSBwZW5k
aW5nIGV2ZW50IGV4aXN0cyAqLwo+Pj4gK8KgwqDCoCBzcGluX2xvY2soJnZzZGVpLT5sb2NrKTsK
Pj4+ICvCoMKgwqAgaWYgKCEodnNkZWktPmNyaXRpY2FsX2V2ZW50IHx8IHZzZGVpLT5ub3JtYWxf
ZXZlbnQpKSB7Cj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0gU0RFSV9ERU5JRUQ7Cj4+PiArwqDC
oMKgwqDCoMKgwqAgZ290byB1bmxvY2s7Cj4+PiArwqDCoMKgIH0KPj4+ICsKPj4+ICvCoMKgwqAg
LyogRmV0Y2ggdGhlIHJlcXVlc3RlZCByZWdpc3RlciAqLwo+Pj4gK8KgwqDCoCByZWdzID0gdnNk
ZWktPmNyaXRpY2FsX2V2ZW50ID8gJnZzZGVpLT5zdGF0ZS5jcml0aWNhbF9yZWdzIDoKPj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAmdnNkZWktPnN0YXRl
Lm5vcm1hbF9yZWdzOwo+Pj4gK8KgwqDCoCByZXQgPSByZWdzLT5yZWdzW2luZGV4XTsKPj4+ICsK
Pj4+ICt1bmxvY2s6Cj4+PiArwqDCoMKgIHNwaW5fdW5sb2NrKCZ2c2RlaS0+bG9jayk7Cj4+PiAr
b3V0Ogo+Pj4gK8KgwqDCoCByZXR1cm4gcmV0Owo+Pj4gK30KPj4+ICsKPj4+IMKgIGludCBrdm1f
c2RlaV9oeXBlcmNhbGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+Pj4gwqAgewo+Pj4gwqDCoMKg
wqDCoCB1MzIgZnVuYyA9IHNtY2NjX2dldF9mdW5jdGlvbih2Y3B1KTsKPj4+IEBAIC0yOTAsNiAr
MzI4LDggQEAgaW50IGt2bV9zZGVpX2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4+
PiDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0ga3ZtX3NkZWlfaHlwZXJjYWxsX2VuYWJsZSh2Y3B1
LCBmYWxzZSk7Cj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4+PiDCoMKgwqDCoMKgIGNh
c2UgU0RFSV8xXzBfRk5fU0RFSV9FVkVOVF9DT05URVhUOgo+Pj4gK8KgwqDCoMKgwqDCoMKgIHJl
dCA9IGt2bV9zZGVpX2h5cGVyY2FsbF9jb250ZXh0KHZjcHUpOwo+Pj4gK8KgwqDCoMKgwqDCoMKg
IGJyZWFrOwo+Pj4gwqDCoMKgwqDCoCBjYXNlIFNERUlfMV8wX0ZOX1NERUlfRVZFTlRfQ09NUExF
VEU6Cj4+PiDCoMKgwqDCoMKgIGNhc2UgU0RFSV8xXzBfRk5fU0RFSV9FVkVOVF9DT01QTEVURV9B
TkRfUkVTVU1FOgo+Pj4gwqDCoMKgwqDCoCBjYXNlIFNERUlfMV8wX0ZOX1NERUlfRVZFTlRfVU5S
RUdJU1RFUjoKPj4+Cj4gCj4gVGhhbmtzLAo+IEdhdmluCj4gCkVyaWMKCl9fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3Zt
YXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9t
YWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
