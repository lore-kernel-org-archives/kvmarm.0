Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21644C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 24 Nov 2021 11:40:54 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FB594A7FD;
	Wed, 24 Nov 2021 06:40:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Mck6FMwgf-8W; Wed, 24 Nov 2021 06:40:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ECAB4B090;
	Wed, 24 Nov 2021 06:40:53 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27BD84A500
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 06:40:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id opNq0aRO78Rc for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Nov 2021 06:40:50 -0500 (EST)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B73554A49C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 06:40:50 -0500 (EST)
Received: by mail-wr1-f45.google.com with SMTP id s13so3672234wrb.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Nov 2021 03:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=references:user-agent:from:to:cc:subject:date:in-reply-to
 :message-id:mime-version:content-transfer-encoding;
 bh=2K0wsomzgh65pxyMR01YlCbXKdEx0pDcUxqUMns577k=;
 b=Sfu3deC8QPpKw8RLoNIOunpBhi3wbkvbFEAU+b9GYNCt65IE6wMyF0nKcKxYURkLrx
 soFCapY8m7USXq0UN+WYlLeRLD0eaTXatpamAnvWMwbHO9OuOK1xNfUMZu1W06lVD0tr
 CLN81fGb9GJ9GCAEKJ6v1Gry2ZtYPxptuFJb0X9QIKZG2SpDnOg5B1le82M/xY+Us8vT
 j26x8aszNuzSWVHUq5QOGd6kUFPV12AchtaNke+GsasuY9/1g1RTCHpf8lHzALPFvk6A
 FCGmm5lWE++dvYOzTiISAG1TaXugAddQC1DPVS9VJsxCAoulnBROZxWlPTFqM5zRR8Pg
 bsdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
 :in-reply-to:message-id:mime-version:content-transfer-encoding;
 bh=2K0wsomzgh65pxyMR01YlCbXKdEx0pDcUxqUMns577k=;
 b=2n+vMrjRU9VXY5AbenHA0rfd0VhhCqllqrEIx2txxlOKk/3gF4Ec1Sjfv5E3Nnukpn
 S4WY6HZeWjghHq1HLi676g7jfd8bhGQiLhFC3s7JxF/vVs28ve0NhsioTokSsvRt82SS
 Gk+DMuYToybTv6FcNUZvkL2htO+E9qiVG8MBPApFtkTMkerb3AVQVHhTWFslg1F/Y8AF
 6GxPRaJY6b2KupLqDvm2nNsmwMs/xRHA/oyLKVfiTJUQX3PR2SZ+8S5eVj6vqJUtdoWp
 uWEWWBJLEXM7NusYH7rnBbMinW9MLnM89XjaDLiiKaxNVaQgoRMkh4iDGg0fEJozZyud
 FzMA==
X-Gm-Message-State: AOAM530l9OMaPN+y1+WYHKqg/2jZnd2n8e4bxn9qHA74szo7wUIw+Irf
 ilyp3AlBTuSWsLp4ijGsBU5iuQ==
X-Google-Smtp-Source: ABdhPJzRW8uzG46gcBI49r340DNmx92ia6YGcRI1t9MGnAGV8eyVJJHrLIBpiKqfjwlrVEr9f+/oug==
X-Received: by 2002:adf:e0d0:: with SMTP id m16mr17852876wri.74.1637754049648; 
 Wed, 24 Nov 2021 03:40:49 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
 by smtp.gmail.com with ESMTPSA id z14sm15521995wrp.70.2021.11.24.03.40.48
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 24 Nov 2021 03:40:48 -0800 (PST)
Received: from zen (localhost [127.0.0.1])
 by zen.linaroharston (Postfix) with ESMTP id DB9DE1FF96;
 Wed, 24 Nov 2021 11:40:47 +0000 (GMT)
References: <20211118184650.661575-1-alex.bennee@linaro.org>
 <20211118184650.661575-2-alex.bennee@linaro.org>
 <20211124110659.jhjuuzez6ij5v7g7@gator.home>
User-agent: mu4e 1.7.5; emacs 28.0.60
From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v8 01/10] docs: mention checkpatch in the
 README
Date: Wed, 24 Nov 2021 11:38:16 +0000
In-reply-to: <20211124110659.jhjuuzez6ij5v7g7@gator.home>
Message-ID: <87y25dhjcw.fsf@linaro.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-arm@nongnu.org,
 idan.horowitz@gmail.com, kvmarm@lists.cs.columbia.edu,
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

CkFuZHJldyBKb25lcyA8ZHJqb25lc0ByZWRoYXQuY29tPiB3cml0ZXM6Cgo+IE9uIFRodSwgTm92
IDE4LCAyMDIxIGF0IDA2OjQ2OjQxUE0gKzAwMDAsIEFsZXggQmVubsOpZSB3cm90ZToKPj4gU2ln
bmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgo+PiAtLS0K
Pj4gIFJFQURNRS5tZCB8IDIgKysKPj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykK
Pj4gCj4+IGRpZmYgLS1naXQgYS9SRUFETUUubWQgYi9SRUFETUUubWQKPj4gaW5kZXggYjQ5OGFh
Zi4uNWRiNDhlNSAxMDA2NDQKPj4gLS0tIGEvUkVBRE1FLm1kCj4+ICsrKyBiL1JFQURNRS5tZAo+
PiBAQCAtMTgyLDMgKzE4Miw1IEBAIHRoZSBjb2RlIGZpbGVzLiAgV2UgYWxzbyBzdGFydCB3aXRo
IGNvbW1vbiBjb2RlIGFuZCBmaW5pc2ggd2l0aCB1bml0IHRlc3QKPj4gIGNvZGUuIGdpdC1kaWZm
J3Mgb3JkZXJGaWxlIGZlYXR1cmUgYWxsb3dzIHVzIHRvIHNwZWNpZnkgdGhlIG9yZGVyIGluIGEK
Pj4gIGZpbGUuICBUaGUgb3JkZXJGaWxlIHdlIHVzZSBpcyBgc2NyaXB0cy9naXQuZGlmZm9yZGVy
YDsgYWRkaW5nIHRoZSBjb25maWcKPj4gIHdpdGggYGdpdCBjb25maWcgZGlmZi5vcmRlckZpbGUg
c2NyaXB0cy9naXQuZGlmZm9yZGVyYCBlbmFibGVzIGl0Lgo+PiArCj4+ICtQbGVhc2UgcnVuIHRo
ZSBrZXJuZWwncyAuL3NjcmlwdHMvY2hlY2twYXRjaC5wbCBvbiBuZXcgcGF0Y2hlcwo+Cj4gVGhp
cyBpcyBhIGJpdCBvZiBhIHByb2JsZW0gZm9yIGt2bS11bml0LXRlc3RzIGNvZGUgd2hpY2ggc3Rp
bGwgaGFzIGEgbWl4Cj4gb2Ygc3R5bGVzIHNpbmNlIGl0IHdhcyBvcmlnaW5hbGx5IHdyaXR0ZW4g
d2l0aCBhIHN0cmFuZ2UgdGFiIGFuZCBzcGFjZQo+IG1peGVkIHN0eWxlLiBJZiBzb21lYm9keSBp
cyBwYXRjaGluZyBvbmUgb2YgdGhvc2UgZmlsZXMgd2UndmUgdXN1YWxseQo+IHRyaWVkIHRvIG1h
aW50YWluIHRoZSBvcmlnaW5hbCBzdHlsZSByYXRoZXIgdGhhbiByZWZvcm1hdCB0aGUgd2hvbGUK
PiB0aGluZyAoaW4gaGluZHNpZ2h0IG1heWJlIHdlIHNob3VsZCBoYXZlIGp1c3QgcmVmb3JtYXR0
ZWQpLiBXZSdyZSBhbHNvCj4gbW9yZSBmbGV4aWJsZSB3aXRoIGxpbmUgbGVuZ3RoIHRoYW4gTGlu
dXgsIGFsdGhvdWdoIExpbnV4IG5vdyBvbmx5IHdhcm5zCj4gZm9yIGFueXRoaW5nIG92ZXIgODAg
YXMgbG9uZyBhcyBpdCdzIHVuZGVyIDEwMCwgd2hpY2ggaXMgcHJvYmFibHkgZ29vZAo+IGVub3Vn
aCBmb3IgdXMgdG9vLiBBbnl3YXksIGxldCdzIHNlZSB3aGF0IFBhb2xvIGFuZCBUaG9tYXMgc2F5
LiBQZXJzb25hbGx5Cj4gSSB3b3VsZG4ndCBtaW5kIGFkZGluZyB0aGlzIGxpbmUgdG8gdGhlIGRv
Y3VtZW50YXRpb24sIHNvIEknbGwgYWNrIGl0Lgo+IEFueXdheSwgd2UgY2FuIGFsc28gaWdub3Jl
IG91ciBvd24gYWR2aXNlIHdoZW4gaXQgc3VpdHMgdXMgOi0pCj4KPiBBY2tlZC1ieTogQW5kcmV3
IEpvbmVzIDxkcmpvbmVzQHJlZGhhdC5jb20+CgpJIGNhbiBtYWtlIHRoZSB3b3JkaW5nIG1vcmUg
d2Vhc2VsbHk6CgogV2Ugc3RyaXZlIHRvIGZvbGxvdyB0aGUgTGludXgga2VybmVscyBjb2Rpbmcg
c3R5bGUgc28gaXQncyByZWNvbW1lbmRlZAogdG8gcnVuIHRoZSBrZXJuZWwncyAuL3NjcmlwdHMv
Y2hlY2twYXRjaC5wbCBvbiBuZXcgcGF0Y2hlcy4KCkkgYWRkZWQgdGhpcyByZWZlcmVuY2UgYmVj
YXVzZSBvbiB0aGUgb2xkZXIgaXRlcmF0aW9ucyBvZiB0aGVzZSB0ZXN0CmRpdmVyZ2VuY2UgZnJv
bSB0aGUga2VybmVsIGNvZGluZyBzdHlsZSB3YXMgcG9pbnRlZCBvdXQgYW5kIEkndmUgZml4ZWQK
dGhlbSBpbiB0aGlzIGl0ZXJhdGlvbi4KCj4KPiBUaGFua3MsCj4gZHJldwoKCi0tIApBbGV4IEJl
bm7DqWUKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
