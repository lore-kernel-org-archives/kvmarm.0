Return-Path: <SRS0=H2W4=6I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B22C55191
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 13:40:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6D54B20736
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 13:40:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSx+T6Pt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D54B20736
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 262264B242;
	Fri, 24 Apr 2020 09:40:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id k0OULghuIKbB; Fri, 24 Apr 2020 09:40:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8BE44B250;
	Fri, 24 Apr 2020 09:40:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 257764B296
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 02:45:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xzdb5hsinZ+u for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2020 02:45:49 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A53614B274
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 02:45:49 -0400 (EDT)
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com
 [209.85.166.179])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9C09E21655
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 06:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587710748;
 bh=p2q55OLx4UPloM+vgfVQMuUale07BQMtfAZ7tOi6RnU=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=JSx+T6PtvoWL6GnpDqhKz/MwjKZxO/9BHdc7hOg/ev4nwZ7P+2eTqw+Bk7V9rSzej
 z9yI/xhe6ykQgZSG85qtADknL2sRRw5myyRLI1lmU3k3gmRIPFTqpOIua3M2LloCT+
 YSac4oCFt0ktHk4KQH6htBnfaDhvwfjk7UZTXjhs=
Received: by mail-il1-f179.google.com with SMTP id q10so8296445ile.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Apr 2020 23:45:48 -0700 (PDT)
X-Gm-Message-State: AGi0PubXh0SUaC7NjVZN7P9vzAO17q7aQQi4ooroUI3NBlP/c/LtbfP9
 TswcQBICKrwJkapOlE+6i+ywrmSCwIVN0k9gGTA=
X-Google-Smtp-Source: APiQypLtBOfLTUCgAhYdZRnGLbRyu71+dwoV1T4y4Mmeic6g1JZnuZsFCD3CRzF/Ys/eH3kOjeDK4ksjZqc5dzL+Mos=
X-Received: by 2002:a92:607:: with SMTP id x7mr6630624ilg.218.1587710747942;
 Thu, 23 Apr 2020 23:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
 <CAMj1kXEjckV3HzcX_XXTSn-tDDQ5H8=LgteDcP5USThn=OgTQg@mail.gmail.com>
 <9e742184-86c1-a4be-c2cb-fe96979e0f1f@arm.com>
In-Reply-To: <9e742184-86c1-a4be-c2cb-fe96979e0f1f@arm.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 24 Apr 2020 08:45:37 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGMHfENDCkAyPCvS0avaYGOVbjDkPi964L3y0DVvz8m8A@mail.gmail.com>
Message-ID: <CAMj1kXGMHfENDCkAyPCvS0avaYGOVbjDkPi964L3y0DVvz8m8A@mail.gmail.com>
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
To: =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
X-Mailman-Approved-At: Fri, 24 Apr 2020 09:40:38 -0400
Cc: kvm@vger.kernel.org, Raphael Gault <raphael.gault@arm.com>,
 Sami Mujawar <sami.mujawar@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

T24gVGh1LCAyMyBBcHIgMjAyMCBhdCAyMzozMiwgQW5kcsOpIFByenl3YXJhIDxhbmRyZS5wcnp5
d2FyYUBhcm0uY29tPiB3cm90ZToKPgo+IE9uIDIzLzA0LzIwMjAgMjE6NDMsIEFyZCBCaWVzaGV1
dmVsIHdyb3RlOgo+Cj4gSGkgQXJkLAo+Cj4gPiBPbiBUaHUsIDIzIEFwciAyMDIwIGF0IDE5OjU1
LCBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPiB3cm90ZToKPiA+Pgo+ID4+IE9uIFRo
dSwgMjMgQXByIDIwMjAgYXQgMTk6MzksIEFuZHJlIFByenl3YXJhIDxhbmRyZS5wcnp5d2FyYUBh
cm0uY29tPiB3cm90ZToKPiA+Pj4KPiA+Pj4gSGksCj4gPj4+Cj4gPj4+IGFuIHVwZGF0ZSBmb3Ig
dGhlIENGSSBmbGFzaCBlbXVsYXRpb24sIGFkZHJlc3NpbmcgQWxleCcgY29tbWVudHMgYW5kCj4g
Pj4+IGFkZGluZyBkaXJlY3QgbWFwcGluZyBzdXBwb3J0Lgo+ID4+PiBUaGUgYWN0dWFsIGNvZGUg
Y2hhbmdlcyB0byB0aGUgZmxhc2ggZW11bGF0aW9uIGFyZSBtaW5pbWFsLCBtb3N0bHkgdGhpcwo+
ID4+PiBpcyBhYm91dCByZW5hbWluZyBhbmQgY2xlYW51cHMuCj4gPj4+IFRoaXMgdmVyc2lvbnMg
bm93IGFkZHMgc29tZSBwYXRjaGVzLiAxLzUgaXMgYSByZXF1aXJlZCBmaXgsIHRoZSBsYXN0Cj4g
Pj4+IHRocmVlIHBhdGNoZXMgYWRkIG1hcHBpbmcgc3VwcG9ydCBhcyBhbiBleHRlbnNpb24uIFNl
ZSBiZWxvdy4KPiA+Pj4KPiA+Pj4gSW4gYWRkaXRpb24gdG8gYSBicmFuY2ggd2l0aCB0aGlzIHNl
cmllc1sxXSwgSSBhbHNvIHB1dCBhIGdpdCBicmFuY2ggd2l0aAo+ID4+PiBhbGwgdGhlIGNoYW5n
ZXMgY29tcGFyZWQgdG8gdjNbMl0gYXMgc2VwYXJhdGUgcGF0Y2hlcyBvbiB0aGUgc2VydmVyLCBw
bGVhc2UKPiA+Pj4gaGF2ZSBhIGxvb2sgaWYgeW91IHdhbnQgdG8gdmVyaWZ5IGFnYWluc3QgYSBw
cmV2aW91cyByZXZpZXcuCj4gPj4+Cj4gPj4+ID09PT09PT09PT09PT09PQo+ID4+PiBUaGUgRURL
IElJIFVFRkkgZmlybXdhcmUgaW1wbGVtZW50YXRpb24gcmVxdWlyZXMgc29tZSBzdG9yYWdlIGZv
ciB0aGUgRUZJCj4gPj4+IHZhcmlhYmxlcywgd2hpY2ggaXMgdHlwaWNhbGx5IHNvbWUgZmxhc2gg
c3RvcmFnZS4KPiA+Pj4gU2luY2UgdGhpcyBpcyBhbHJlYWR5IHN1cHBvcnRlZCBvbiB0aGUgRURL
IElJIHNpZGUsIGFuZCBsb29rcyBsaWtlIGEKPiA+Pj4gZ2VuZXJpYyBzdGFuZGFyZCwgdGhpcyBz
ZXJpZXMgYWRkcyBhIENGSSBmbGFzaCBlbXVsYXRpb24gdG8ga3ZtdG9vbC4KPiA+Pj4KPiA+Pj4g
UGF0Y2ggMi81IGlzIHRoZSBhY3R1YWwgZW11bGF0aW9uIGNvZGUsIHBhdGNoIDEvNSBpcyBhIGJ1
Zy1maXggZm9yCj4gPj4+IHJlZ2lzdGVyaW5nIE1NSU8gZGV2aWNlcywgd2hpY2ggaXMgbmVlZGVk
IGZvciB0aGlzIGRldmljZS4KPiA+Pj4gUGF0Y2hlcyAzLTUgYWRkIHN1cHBvcnQgZm9yIG1hcHBp
bmcgdGhlIGZsYXNoIG1lbW9yeSBpbnRvIGd1ZXN0LCBzaG91bGQKPiA+Pj4gaXQgYmUgaW4gcmVh
ZC1hcnJheSBtb2RlLiBGb3IgdGhpcyB0byB3b3JrLCBwYXRjaCAzLzUgaXMgY2hlcnJ5LXBpY2tl
ZAo+ID4+PiBmcm9tIEFsZXgnIFBDSWUgcmVhc3NpZ25hYmxlIEJBUiBzZXJpZXMsIHRvIHN1cHBv
cnQgcmVtb3ZpbmcgYSBtZW1zbG90Cj4gPj4+IG1hcHBpbmcuIFBhdGNoIDQvNSBhZGRzIHN1cHBv
cnQgZm9yIHJlYWQtb25seSBtYXBwaW5ncywgd2hpbGUgcGF0Y2ggNS81Cj4gPj4+IGFkZHMgb3Ig
cmVtb3ZlcyB0aGUgbWFwcGluZyBiYXNlZCBvbiB0aGUgY3VycmVudCBzdGF0ZS4KPiA+Pj4gSSBh
bSBoYXBweSB0byBzcXVhc2ggNS81IGludG8gMi81LCBpZiB3ZSBhZ3JlZSB0aGF0IHBhdGNoIDMv
NSBzaG91bGQgYmUKPiA+Pj4gbWVyZ2VkIGVpdGhlciBzZXBhcmF0ZWx5IG9yIHRoZSBQQ0llIHNl
cmllcyBpcyBhY3R1YWxseSBtZXJnZWQgYmVmb3JlCj4gPj4+IHRoaXMgb25lLgo+ID4+Pgo+ID4+
PiBUaGlzIGlzIG9uZSBtaXNzaW5nIHBpZWNlIHRvd2FyZHMgYSB3b3JraW5nIFVFRkkgYm9vdCB3
aXRoIGt2bXRvb2wgb24KPiA+Pj4gQVJNIGd1ZXN0cywgdGhlIG90aGVyIGlzIHRvIHByb3ZpZGUg
d3JpdGFibGUgUENJIEJBUnMsIHdoaWNoIGlzIFdJUC4KPiA+Pj4gVGhpcyBzZXJpZXMgYWxvbmUg
YWxyZWFkeSBlbmFibGVzIFVFRkkgYm9vdCwgYnV0IG9ubHkgd2l0aCB2aXJ0aW8tbW1pby4KPiA+
Pj4KPiA+Pgo+ID4+IEV4Y2VsbGVudCEgVGhhbmtzIGZvciB0YWtpbmcgdGhlIHRpbWUgdG8gaW1w
bGVtZW50IHRoZSByL28gbWVtc2xvdCBmb3IKPiA+PiB0aGUgZmxhc2gsIGl0IHJlYWxseSBtYWtl
cyB0aGUgVUVGSSBmaXJtd2FyZSBtdWNoIG1vcmUgdXNhYmxlLgo+ID4+Cj4gPj4gSSB3aWxsIHRl
c3QgdGhpcyBhcyBzb29uIGFzIEkgZ2V0IGEgY2hhbmNlLCBwcm9iYWJseSB0b21vcnJvdy4KPiA+
Pgo+ID4KPiA+IEkgdGVzdGVkIHRoaXMgb24gYSBTeW5RdWFjZXIgYm94IGFzIGEgaG9zdCwgdXNp
bmcgRUZJIGZpcm13YXJlIFswXQo+ID4gYnVpbHQgZnJvbSBwYXRjaGVzIHByb3ZpZGVkIGJ5IFNh
bWkuCj4gPgo+ID4gSSBib290ZWQgdGhlIERlYmlhbiBidXN0ZXIgaW5zdGFsbGVyLCBjb21wbGV0
ZWQgdGhlIGluc3RhbGxhdGlvbiwgYW5kCj4gPiBjb3VsZCBib290IGludG8gdGhlIHN5c3RlbS4g
VGhlIG9ubHkgZ2xpdGNoIHdhcyB0aGUgZmFjdCB0aGF0IHRoZQo+ID4gcmVib290IGRpZG4ndCB3
b3JrLCBidXQgSSBzdXBwb3NlIHdlIGFyZSBub3QgcHJlc2VydmluZyB0aGUgbWVtb3J5IHRoZQo+
ID4gY29udGFpbnMgdGhlIGZpcm13YXJlIGltYWdlLCBzbyB0aGVyZSBpcyBub3RoaW5nIHRvIHJl
Ym9vdCBpbnRvLgo+Cj4gSXQncyBldmVuIHdvcnRoLCBrdm10b29sIGRvZXMgYWN0dWFsbHkgbm90
IHN1cHBvcnQgcmVzZXQgYXQgYWxsOgo+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L3dpbGwva3ZtdG9vbC5naXQvdHJlZS9rdm0tY3B1LmMjbjIyMAo+Cj4g
QW5kIHllYWgsIHRoZSBVRUZJIGZpcm13YXJlIGlzIGxvYWRlZCBhdCB0aGUgYmVnaW5uaW5nIG9m
IFJBTSwgc28gbW9zdAo+IG9mIGl0IGlzIGxvbmcgZ29uZSBieSB0aGVuLgo+IGt2bXRvb2wgY291
bGQgcmVsb2FkIHRoZSBpbWFnZSBhbmQgcmVzZXQgdGhlIFZDUFVzLCBidXQgZXZlcnkgZGV2aWNl
Cj4gZW11bGF0aW9uIHdvdWxkIG5lZWQgdG8gYmUgcmVzZXQsIGZvciB3aGljaCB0aGVyZSBpcyBu
byBjb2RlIHlldC4KPgoKRmFpciBlbm91Z2guIEZvciBteSB1c2UgY2FzZSwgaXQgZG9lc24ndCBy
ZWFsbHkgbWF0dGVyIGFueXdheS4KCj4gPiBCdXQKPiA+IGp1c3QgcmVzdGFydGluZyBrdm10b29s
IHdpdGggdGhlIGZsYXNoIGltYWdlIGNvbnRhaW5pbmcgdGhlIEVGSQo+ID4gdmFyaWFibGVzIGdv
dCBtZSBzdHJhaWdodCBpbnRvIEdSVUIgYW5kIHRoZSBpbnN0YWxsZWQgT1MuCj4KPiBTbywgeWVh
aCwgdGhpcyBpcyB0aGUgd2F5IHRvIGRvIGl0IDstKQo+Cj4gPiBUZXN0ZWQtYnk6IEFyZCBCaWVz
aGV1dmVsIDxhcmRiQGtlcm5lbC5vcmc+Cj4KPiBNYW55IHRoYW5rcyBmb3IgdGhhdCEKPgo+ID4g
VGhhbmtzIGFnYWluIGZvciBnZXR0aW5nIHRoaXMgc29ydGVkLgo+Cj4gSXQgd2FzIGFjdHVhbGx5
IGVhc2llciB0aGFuIEkgdGhvdWdodCAoc2VlIHRoZSBsYXN0IHBhdGNoKS4KPgo+IEp1c3QgY3Vy
aW91czogdGhlIGltYWdlcyBTYW1pIGdhdmUgbWUgdGhpcyBtb3JuaW5nIGRpZCBub3Qgc2hvdyBh
bnkKPiBpc3N1ZXMgYW55bW9yZSAobm8gbm8tc3luZHJvbWUgZmF1bHQsIG5vIGFsaWdubWVudCBp
c3N1ZXMpLCBldmVuIHdpdGhvdXQKPiB0aGUgbWFwcGluZyBbMV0uIEFuZCBldmVuIHRob3VnaCBJ
IHNhdyB0aGUgODAwayByZWFkIHRyYXBzLCBJIGRpZG4ndAo+IG5vdGljZSBhbnkgcmVhbCBwZXJm
b3JtYW5jZSBkaWZmZXJlbmNlIChvbiBhIEp1bm8pLiBUaGUgUFhFIHRpbWVvdXQgd2FzCj4gZGVm
aW5pdGVseSBtdWNoIG1vcmUgbm90aWNlYWJsZS4KPgo+IFNvIGRpZCB5b3Ugc2VlIGFueSBwZXJm
b3JtYW5jZSBpbXBhY3Qgd2l0aCB0aGlzIHNlcmllcz8KPgoKWW91IG5vcm1hbGx5IGRvbid0IFBY
RSBib290LiBUaGVyZSBpcyBhbiBpc3N1ZSB3aXRoIHRoZSBpU0NTSSBkcml2ZXIKYXMgd2VsbCwg
d2hpY2ggY2F1c2VzIGEgYm9vdCBkZWxheSBmb3Igc29tZSByZWFzb24sIHNvIEkgZGlzYWJsZWQg
dGhhdAppbiBteSBidWlsZC4KCkkgZGVmaW5pdGVseSAqZmVlbHMqIGZhc3RlciA6LSkgQnV0IGlu
IGFueSBjYXNlLCBleHBvc2luZyB0aGUgYXJyYXkKbW9kZSBhcyBhIHIvbyBtZW1zbG90IGlzIGRl
ZmluaXRlbHkgdGhlIHJpZ2h0IHdheSB0byBkZWFsIHdpdGggdGhpcy4KRXZlbiBpZiBTYW1pIGRp
ZCBmaW5kIGEgd29ya2Fyb3VuZCB0aGF0IG1hc2tzIHRoZSBlcnJvciwgaXQgaXMgbm8KZ3VhcmFu
dGVlIHRoYXQgYWxsIGFjY2Vzc2VzIGdvIHRocm91Z2ggdGhhdCBsaWJyYXJ5LgoKCj4gPiBbMF0g
aHR0cHM6Ly9wZW9wbGUubGluYXJvLm9yZy9+YXJkLmJpZXNoZXV2ZWwvS1ZNVE9PTF9FRkkuZmQK
Pgo+IEFoLCBuaWNlLCB3aWxsIHRoaXMgc3RheSB0aGVyZSBmb3IgYSB3aGlsZT8gSSBjYW4ndCBw
cm92aWRlIGJpbmFyaWVzLAo+IGJ1dCB3YW50ZWQgb3RoZXJzIHRvIGJlIGFibGUgdG8gZWFzaWx5
IHRlc3QgdGhpcy4KPgoKU3VyZSwgSSB3aWxsIGxlYXZlIGl0IHVwIHVudGlsIExpbmFybyBkZWNp
ZGVzIHRvIHRha2UgZG93biBteSBhY2NvdW50LgpfX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5j
b2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5m
by9rdm1hcm0K
