Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA27C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 19 Dec 2021 12:12:17 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FCD34B2E3;
	Sun, 19 Dec 2021 07:12:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tjeb4q8CVz6b; Sun, 19 Dec 2021 07:12:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E2484B2F6;
	Sun, 19 Dec 2021 07:12:13 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50D394B314
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 11:20:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RIpNVyYLOFzF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Dec 2021 11:20:26 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7686A4B315
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 11:20:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639758026;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=yeSLiX88ywUnJSn3OPy2dA6dAW/L5+XCxa+K1ZsSMkg=;
 b=TWIWESzZgHoJYZiKLbWzgVeJaI3lge7psdu8lxDBC27Y4/4x6s6rVB/i3lFmQYQ4KoLcyT
 epsj2S4I0PPuMCpk9S5L9M2fvQa6r83y3OZRQS+WGlmRbqYdtFJEZcFKCT1XGOWntTiMRn
 N5PS6WIj9U9xyzl8HF7ElG4wryTxS/I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-_wCOHnwYN9uwESrqPZEkpA-1; Fri, 17 Dec 2021 11:20:23 -0500
X-MC-Unique: _wCOHnwYN9uwESrqPZEkpA-1
Received: by mail-wr1-f69.google.com with SMTP id
 l13-20020adfbd8d000000b001a23a990dbfso769803wrh.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Dec 2021 08:20:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
 :references:user-agent:mime-version:content-transfer-encoding;
 bh=yeSLiX88ywUnJSn3OPy2dA6dAW/L5+XCxa+K1ZsSMkg=;
 b=RDRkGKI2SsboWnRMTt4UXmzs4/SREx2Pz/31MT90aTWVWLvZPfd5VOt8M8jXRmeEkf
 16T0UCQJ8fC+fqiMEYbjDWe5yHtndZYiHJu9TcBWdNml+g8S64EvTrZERPBVqSbGsre5
 JOYRUVBnzKlHqF57LV+ROZ4W4gzi0U7Qfj3ncdsU2gj9ygSS97DDVs8C614kJYDkNGzD
 7V/eQvaNHEUgeyxS1Xdny5s4/NZsAOESM6ecN+rjRB9weoisXdvMXVvuw5fXV9nNS+0U
 OW6UtgJb7/fvQ0seh9gdReoHB5cSr334jMlNEv7lL7C8E2c0gjiUkWszwoab7rPTXt4P
 c21A==
X-Gm-Message-State: AOAM530dZN5zXLCsdGCvAEYTu6+WQ77RFxtZBG+OoyoX7HA7X/L3D5ZT
 ZnriRF2EbD4LF7DIcIay5EcacQj0jALlbmUefE4D65We/EbUmfedHiVtgt6jvGyr6s1LjsIQs5I
 H9t2eRXOzSXboKxESRzS70foG
X-Received: by 2002:a5d:6483:: with SMTP id o3mr3128444wri.634.1639758022088; 
 Fri, 17 Dec 2021 08:20:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwk2ba7Tbij6WYWb1HqhmTZxhP9T+f29JbPI5KYAluKtYZQtdJHeX0aXwhZAJkm79KXnc0PuQ==
X-Received: by 2002:a5d:6483:: with SMTP id o3mr3128421wri.634.1639758021885; 
 Fri, 17 Dec 2021 08:20:21 -0800 (PST)
Received: from ?IPv6:2a0c:5a80:3511:9200:f938:102b:34c2:d5db?
 ([2a0c:5a80:3511:9200:f938:102b:34c2:d5db])
 by smtp.gmail.com with ESMTPSA id b10sm8204839wrg.19.2021.12.17.08.20.21
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 17 Dec 2021 08:20:21 -0800 (PST)
Message-ID: <27231550b5600072da918aa41c07404dea13590e.camel@redhat.com>
Subject: Re: Possible nohz-full/RCU issue in arm64 KVM
From: Nicolas Saenz Julienne <nsaenzju@redhat.com>
To: paulmck@kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 17 Dec 2021 17:20:21 +0100
In-Reply-To: <20211217160749.GS641268@paulmck-ThinkPad-P17-Gen-1>
References: <d80e440375896f75d45e227d40af60ca7ba24ceb.camel@redhat.com>
 <YbyO40zDW/kvUHEE@FVFF77S0Q05N>
 <70f112072d9496d21901946ea82832d3ed3a8cb2.camel@redhat.com>
 <Ybyg1r/Q6EfeuXGV@FVFF77S0Q05N>
 <9ab8107f-ff41-6a9e-57e1-a261bea93aca@redhat.com>
 <20211217160749.GS641268@paulmck-ThinkPad-P17-Gen-1>
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35)
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=nsaenzju@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
X-Mailman-Approved-At: Sun, 19 Dec 2021 07:12:12 -0500
Cc: maz <maz@kernel.org>, frederic <frederic@kernel.org>,
 linux-kernel <linux-kernel@vger.kernel.org>, rcu <rcu@vger.kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
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

SGkgUGF1bCwKCk9uIEZyaSwgMjAyMS0xMi0xNyBhdCAwODowNyAtMDgwMCwgUGF1bCBFLiBNY0tl
bm5leSB3cm90ZToKPiBPbiBGcmksIERlYyAxNywgMjAyMSBhdCAwNDo1NDoyMlBNICswMTAwLCBQ
YW9sbyBCb256aW5pIHdyb3RlOgo+ID4gT24gMTIvMTcvMjEgMTU6MzgsIE1hcmsgUnV0bGFuZCB3
cm90ZToKPiA+ID4gRm9yIGV4YW1wbGUga3ZtX2d1ZXN0X2VudGVyX2lycW9mZigpIGNhbGxzIGd1
ZXN0X2VudGVyX2lycV9vZmYoKSB3aGljaCBjYWxscwo+ID4gPiB2dGltZV9hY2NvdW50X2d1ZXN0
X2VudGVyKCksIGJ1dCBrdm1fZ3Vlc3RfZXhpdF9pcnFvZmYoKSBkb2Vzbid0IGNhbGwKPiA+ID4g
Z3Vlc3RfZXhpdF9pcnFfb2ZmKCkgYW5kIHRoZSBjYWxsIHRvIHZ0aW1lX2FjY291bnRfZ3Vlc3Rf
ZXhpdCgpIGlzIG9wZW4tY29kZWQKPiA+ID4gZWxzZXdoZXJlLiBBbHNvLCBndWVzdF9lbnRlcl9p
cnFfb2ZmKCkgY29uZGl0aW9uYWxseSBjYWxscwo+ID4gPiByY3VfdmlydF9ub3RlX2NvbnRleHRf
c3dpdGNoKCksIGJ1dCBJIGNhbid0IGltbWVkaWF0ZWx5IHNwb3QgYW55dGhpbmcgb24gdGhlCj4g
PiA+IGV4aXQgc2lkZSB0aGF0IGNvcnJlc3BvbmRlZCB3aXRoIHRoYXQsIHdoaWNoIGxvb2tzIHN1
c3BpY2lvdXMuCj4gPiAKPiA+IHJjdV9ub3RlX2NvbnRleHRfc3dpdGNoKCkgaXMgYSBwb2ludC1p
bi10aW1lIG5vdGlmaWNhdGlvbjsgaXQncyBub3Qgc3RyaWN0bHkKPiA+IG5lY2Vzc2FyeSwgYnV0
IGl0IG1heSBpbXByb3ZlIHBlcmZvcm1hbmNlIGEgYml0IGJ5IGF2b2lkaW5nIHVubmVjZXNzYXJ5
IElQSXMKPiA+IGZyb20gdGhlIFJDVSBzdWJzeXN0ZW0uCj4gPiAKPiA+IFRoZXJlJ3Mgbm8gYmVu
ZWZpdCBmcm9tIGRvaW5nIGl0IHdoZW4geW91J3JlIGJhY2sgZnJvbSB0aGUgZ3Vlc3QsIGJlY2F1
c2UgYXQKPiA+IHRoYXQgcG9pbnQgdGhlIENQVSBpcyBqdXN0IHJ1bm5pbmcgbm9ybWFsIGtlcm5l
bCBjb2RlLgo+IAo+IERvIHNjaGVkdWxpbmctY2xvY2sgaW50ZXJydXB0cyBmcm9tIGd1ZXN0IG1v
ZGUgaGF2ZSB0aGUgInVzZXIiIHBhcmFtZXRlcgo+IHNldD8gIElmIHNvLCB0aGF0IHdvdWxkIGtl
ZXAgUkNVIGhhcHB5LgoKQXJlIHlvdSByZWZlcnJpbmcgdG8gdGhlIHVzZXJfbW9kZSgpIGNoZWNr
IGluIGlycWVudHJ5X2VudGVyKCk/IElmIHNvIEkgZG9uJ3QKdGhpbmsgaXQnbGwgaGVscCwgYXJt
NjQgZG9lc24ndCB1c2UgdGhhdCBmdW5jdGlvbi4gSXQgZGlyZWN0bHkgY2FsbHMKZW50ZXJfZnJv
bV97dXNlcixrZXJuZWx9X21vZGUoKSB0aHJvdWdoIGl0cyBjdXN0b20gZW50cnkvZXhpdCByb3V0
aW5lcy4KClJlZ2FyZHMsCgotLSAKTmljb2zDoXMgU8OhZW56CgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBs
aXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1h
bi9saXN0aW5mby9rdm1hcm0K
