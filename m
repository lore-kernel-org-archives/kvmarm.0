Return-Path: <SRS0=YGC0=PG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 724A7C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 19:01:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CED1661283
	for <kvmarm@archiver.kernel.org>; Mon, 18 Oct 2021 19:01:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CED1661283
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 47FBD4B1F8;
	Mon, 18 Oct 2021 15:01:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zYkVQqb83Gcu; Mon, 18 Oct 2021 15:01:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3564B4B242;
	Mon, 18 Oct 2021 15:01:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 069014B236
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 15:01:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9yOb3E+FT5T0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Oct 2021 15:01:36 -0400 (EDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com
 [209.85.167.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DCCAD4B1FD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 15:01:35 -0400 (EDT)
Received: by mail-lf1-f52.google.com with SMTP id x27so1837638lfa.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Oct 2021 12:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=fwx/Jdsb71I9qqjyP9iwj3S7LzNPiAYBS7CN0/ADUFg=;
 b=C/xWv8z4hO/zAwymhxR1GYxdOfWIW/k70z0EoQAsQUgS6plpkTb9SDaWe57WmLT5Wv
 xMu+xyq++TvjIo0EhXlZKlUySxKWa6SG04Fdq3v5yBr8fwV8fVSy5RGjhMItAa8bPf9F
 9fwAdordg6ZOTd3ErvjOXfmc/HCMrqKf6kgi+rISJSKwexR9AmLdglugJA7x8B5rfoir
 zQYlbld4wW9qENYRr/bawhjI65QflFY5jYx7gdjgKv5d1F24AhCpm5CfZXnoBL5NrqsY
 H3FubHqFzfaEVxQ04QCHq1RGvhzNlPMMz3viqIXk6HB/EeiDfvOX6WC3Dp9synfXjOxs
 iMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=fwx/Jdsb71I9qqjyP9iwj3S7LzNPiAYBS7CN0/ADUFg=;
 b=IfvmI+xQMPNxMFkLnNpAHHnGRFtLNqmZQwERpT69XzLR16+PTfacPgqwfkY5+0RYus
 LvG/39o8wY2BUup9n3XU6w74ltkNZwgT/eNR4LBhxDUbHNrM8Z8ZpvVA9IIPakKTUAJS
 +otthfSekTNu7GhnDJBp9j3yxsi15lGxaLj5dYekMBx4JrYgW9BXfqY4+RoEjn3HoNdc
 5Hl6K2YdAfVRtbmS2L7RkOUDS8usAtIo3RkkWlV8HkWk7KA93Fv1lVgBow+bJxshlmTI
 z0nkYPLTA3oMt14SPaHXDI1tH7NvE/dsZKB8xgee7/jzv8Nisxoz5xzc+4z5T8B1tLgU
 FNKQ==
X-Gm-Message-State: AOAM532fb+6pX43SQxDMvjvgWoWgpI6Ugx4o8KQDuVr6u3YAEJea3kdf
 v5xoOgxTa3WWEmmVQ79txdk0QREvS/PDMXXMZF0=
X-Google-Smtp-Source: ABdhPJzEGBBUSrJdDL9mUUf2Nc7Kkma7mIEYspmFkkS23uekdiqVod6zQGmaf3ZFRMgdCQlkDPEvCOAEuxMrKtDiuGI=
X-Received: by 2002:ac2:5dd4:: with SMTP id x20mr1437374lfq.313.1634583694297; 
 Mon, 18 Oct 2021 12:01:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAFLP=uDhb8Zq5pAnTbvXi_OU047Uw3WRkw2YJsYNEsCkdHzkJQ@mail.gmail.com>
 <877decvf9x.wl-maz@kernel.org>
 <CAFLP=uDY-Eh6gvA2UvAtd=u1wa61tg9TAmdnqiJGZE+Yan8PpA@mail.gmail.com>
 <87zgr6odec.wl-maz@kernel.org>
In-Reply-To: <87zgr6odec.wl-maz@kernel.org>
From: Chenxu Wang <irakatz51@gmail.com>
Date: Tue, 19 Oct 2021 03:01:23 +0800
Message-ID: <CAFLP=uDAvg_6m3NLgOXnAYLtZe74nqhv_bOJdTwX=iZCrwXs0A@mail.gmail.com>
Subject: Re: Problems about Stage-2 translation
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.cs.columbia.edu
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

SGkgTWFyYywKClNvcnJ5LCBidXQgSSBjb3VsZCBub3QgZmluZCB0aGUgYm90dG9tIHBvc3Rpbmcg
bW9kZSBpbiBHbWFpbC4KCkFsc28sIHRoYW5rcyBmb3IgeW91ciByZXBseSwgSSBjb250aW51ZSB0
byBkaXNjb3ZlciBob3cgdGhlIFN0YWdlLTIKdHJhbnNsYXRpb24gd29ya3MgaW4gS1ZNLgpCdXQs
IHdoZW4gSSByZWFkIHRoZSBIQ1JfRUwyIHJlZ2lzdGVyIGluIEhvc3QgIChpdCBpcyB2NS4zLjAp
ICwgaXRzCnZhbHVlIGlzIDB4NF84ODAwXzAwMDAuIFNvCigxKSBJIGFtIGluIFZIRSBtb2RlLgoo
MikgVGhlIFN0YWdlLTIgdHJhbnNsYXRpb24gaXMgZGlzYWJsZWQuCgpJIGFtIHN1cmUgdGhhdCBJ
IGhhdmUgcnVuIGEgTm9uLVNlY3VyZSBWTSB3aXRoIFFFTVUsIHNvIGlzIGl0IGNvcnJlY3QKdGhh
dCB0aGUgUy0yIHRyYW5zbGF0aW9uIGlzIGRpc2FibGVkIGluIFZIRSBtb2RlPyBJZiBzbywgaG93
IGl0CmhhbmRsZXMgdGhlIG1lbW9yeSBtYW5hZ2VtZW50IGZvciBHdWVzdD8KCgpDb25mdXNlZCwK
V2FuZwoKCk1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+IOS6jjIwMjHlubQxMOaciDE45pel
5ZGo5LiAIOS4i+WNiDY6MDblhpnpgZPvvJoKPgo+IFdhbmcsCj4KPiBQbGVhc2UgZG9uJ3QgdG9w
LXBvc3QsIGFuZCBzdGljayB0byBwbGFpbiB0ZXh0IGluc3RlYWQgb2YgSFRNTC4KPgo+IE9uIE1v
biwgMTggT2N0IDIwMjEgMDk6MzY6MDUgKzAxMDAsCj4gQ2hlbnh1IFdhbmcgPGlyYWthdHo1MUBn
bWFpbC5jb20+IHdyb3RlOgo+ID4KPiA+IEhpIE1hcmMsCj4gPgo+ID4gVGhhbmtzIGZvciB5b3Vy
IGhlbHAuIEkgc3R1ZGllZCB0aGUga3ZtX2hhbmRsZV9ndWVzdF9hYm9ydCgpIGhhbmRsZXIsIGFu
ZAo+ID4gYmFzaWNhbGx5IGtub3cgdGhlIHJlYXNvbiBmb3IgInJldHVybiAwIi4KPiA+IEJ1dCBJ
IHN0aWxsIGNhbm5vdCBzb2x2ZSB0aGUgbWFwcGluZyBwcm9ibGVtLgo+ID4KPiA+IEkgd2FudCB0
byBmaW5kIGEgZnVuY3Rpb24gb3IgQVBJcywgd2hvc2UgaW5wdXQgcGFyYW1ldGVycyBhcmUgKDEp
IHJlZ2lvbgo+ID4gYmFzZSBJUEEgYW5kIHNpemUgKDIpIG1hcHBlZCBQQSBpbiBIb3N0IChpZiBJ
UEE9UEEsIGl0IGNvdWxkIGJlIGJldHRlcikgKDMpCj4gPiBSL1cvWCBhdHRyaWJ1dGVzLgo+ID4g
VGhlbiwgd2hlbiBJIGNhbGwgdGhlIGZ1bmMoSVBBIHN0YXJ0LCBJUEEgZW5kLCBQQSBzdGFydCwg
YXR0ciksIEkgY2FuIGdldAo+ID4gdGhlIG1hcC4KPgo+IFRoZXJlIGlzIG5vIHN1Y2ggZnVuY3Rp
b24sIGJlY2F1c2UgdGhhdCdzIG5vdCBob3cgS1ZNIHdvcmtzLgo+Cj4gPiBXaGVyZSBzaG91bGQg
SSBmb2xsb3c/IFNob3VsZCBJIGZvbGxvdyB0aGUgInRyYW5zbGF0aW9uIGZhdWx0IHBhdGgiIGFn
YWluPwo+ID4gT3IgY3JlYXRlIHRoZSBtYXBwaW5nIGZ1bmN0aW9uIGJ5IG15c2VsZj8KPgo+IE5l
aXRoZXIuIFlvdSBjYW5ub3QgZGlyZWN0bHkgbWFwIHJhbmRvbSBwaHlzaWNhbCByYW5nZXMgaW50
byBhIFZNLgo+IE1lbW9yeSB0aGF0IGdldHMgbWFwcGVkIGludG8gYSBWTSBuZWVkcyB0byBiZSBl
eHBvc2VkIGJ5IHVzZXJzcGFjZSBpbgo+IHRoZSBmb3JtIG9mIGEgbWVtc2xvdC4gS1ZNIHdpbGwg
dGhlbiBtYXAgdGhhdCBtZW1vcnkgb24gZGVtYW5kIGFzIHRoZQo+IGd1ZXN0IGFjY2Vzc2VzIGl0
Lgo+Cj4gVGhhbmtzLAo+Cj4gICAgICAgICBNLgo+Cj4gLS0KPiBXaXRob3V0IGRldmlhdGlvbiBm
cm9tIHRoZSBub3JtLCBwcm9ncmVzcyBpcyBub3QgcG9zc2libGUuCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
