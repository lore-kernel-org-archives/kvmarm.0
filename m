Return-Path: <SRS0=H2W4=6I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018D4C55191
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 13:40:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AF13720767
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 13:40:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSuoz731"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF13720767
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 687284B24C;
	Fri, 24 Apr 2020 09:40:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nTbJmc2l-rkX; Fri, 24 Apr 2020 09:40:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C531E4B25B;
	Fri, 24 Apr 2020 09:40:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8FAD4B25C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 08:25:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id coww-k0qAEOd for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2020 08:25:27 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BC974B1E7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 08:25:27 -0400 (EDT)
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com
 [209.85.166.53])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 703C721473
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 12:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587731126;
 bh=At8xmfKBJxQ9CafuQrxhSF7RQSm74iu7lK9/pffz/Kk=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=hSuoz731MrEwMi2PEd3c9/Zupwr84KMTfGVXuHRXhm9aYcqRY78XoDs+Mpcsx3yqj
 FY7Q37+129/tYtL2RZlzP0k3Pks6aQ6AAO2WWK9PoTkIpeGmMvZcI65R2iR/2l0ieX
 c0Bqu6hvqyghzrOyJIAUYtUacnE0LgptmtjJcXQg=
Received: by mail-io1-f53.google.com with SMTP id f19so10131706iog.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 05:25:26 -0700 (PDT)
X-Gm-Message-State: AGi0PuaM/upjxLC+YFJA1J3gUSVzZuIqJcgxgmEk2S5RC6+nsr8PYaEZ
 ooMI+JE7wpVxPVajGBMuKKFai8r2wViAYzAiCKs=
X-Google-Smtp-Source: APiQypJc/nkscRMyfcPd01oltQYjyEJquNAjGFcmgHSSoISonFfv+XMnS8tZSLIDvipgwz2NbSPAKVS/Gu9zhzUEeD4=
X-Received: by 2002:a6b:ef03:: with SMTP id k3mr8349793ioh.203.1587731125790; 
 Fri, 24 Apr 2020 05:25:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
 <CAMj1kXEjckV3HzcX_XXTSn-tDDQ5H8=LgteDcP5USThn=OgTQg@mail.gmail.com>
 <9e742184-86c1-a4be-c2cb-fe96979e0f1f@arm.com>
 <CAMj1kXGMHfENDCkAyPCvS0avaYGOVbjDkPi964L3y0DVvz8m8A@mail.gmail.com>
 <df9a0aeb-39ed-f9bc-c506-71d2f134bc62@arm.com>
In-Reply-To: <df9a0aeb-39ed-f9bc-c506-71d2f134bc62@arm.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 24 Apr 2020 14:25:14 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEr0fVVG1xCxEJtcrrKe3_OYbOmAmbYy0TceSeX+3gfww@mail.gmail.com>
Message-ID: <CAMj1kXEr0fVVG1xCxEJtcrrKe3_OYbOmAmbYy0TceSeX+3gfww@mail.gmail.com>
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
To: =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
X-Mailman-Approved-At: Fri, 24 Apr 2020 09:40:38 -0400
Cc: kvm@vger.kernel.org, Raphael Gault <raphael.gault@arm.com>,
 Sami Mujawar <sami.mujawar@arm.com>, Leif Lindholm <leif@nuviainc.com>,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

T24gRnJpLCAyNCBBcHIgMjAyMCBhdCAxNDowOCwgQW5kcsOpIFByenl3YXJhIDxhbmRyZS5wcnp5
d2FyYUBhcm0uY29tPiB3cm90ZToKPgo+IE9uIDI0LzA0LzIwMjAgMDc6NDUsIEFyZCBCaWVzaGV1
dmVsIHdyb3RlOgo+Cj4gSGksCj4KPiAoYWRkaW5nIExlaWYgZm9yIEVESy0yIGRpc2N1c3Npb24p
Cj4KPiA+IE9uIFRodSwgMjMgQXByIDIwMjAgYXQgMjM6MzIsIEFuZHLDqSBQcnp5d2FyYSA8YW5k
cmUucHJ6eXdhcmFAYXJtLmNvbT4gd3JvdGU6Cj4gPj4KPiA+PiBPbiAyMy8wNC8yMDIwIDIxOjQz
LCBBcmQgQmllc2hldXZlbCB3cm90ZToKPgo+IFsgLi4uIGt2bXRvb2wgc2VyaWVzIHRvIGFkZCBD
RkkgZmxhc2ggZW11bGF0aW9uIGFsbG93aW5nIEVESy0yIHRvIHN0b3JlCj4gdmFyaWFibGVzLiBT
dGFydGluZyB3aXRoIHRoaXMgdmVyc2lvbiAodjQpIHRoZSBmbGFzaCBtZW1vcnkgcmVnaW9uIGlz
Cj4gcHJlc2VudGVkIGFzIGEgcmVhZC1vbmx5IG1lbXNsb3QgdG8gS1ZNLCB0byBhbGxvdyBkaXJl
Y3QgZ3Vlc3QgYWNjZXNzZXMKPiBhcyBvcHBvc2VkIHRvIHRyYXAtYW5kLWVtdWxhdGUgZXZlbiBy
ZWFkIGFjY2Vzc2VzIHRvIHRoZSBhcnJheS5dCj4KPiA+Pgo+ID4+Cj4gPj4gSnVzdCBjdXJpb3Vz
OiB0aGUgaW1hZ2VzIFNhbWkgZ2F2ZSBtZSB0aGlzIG1vcm5pbmcgZGlkIG5vdCBzaG93IGFueQo+
ID4+IGlzc3VlcyBhbnltb3JlIChubyBuby1zeW5kcm9tZSBmYXVsdCwgbm8gYWxpZ25tZW50IGlz
c3VlcyksIGV2ZW4gd2l0aG91dAo+ID4+IHRoZSBtYXBwaW5nIFsxXS4gQW5kIGV2ZW4gdGhvdWdo
IEkgc2F3IHRoZSA4MDBrIHJlYWQgdHJhcHMsIEkgZGlkbid0Cj4gPj4gbm90aWNlIGFueSByZWFs
IHBlcmZvcm1hbmNlIGRpZmZlcmVuY2UgKG9uIGEgSnVubykuIFRoZSBQWEUgdGltZW91dCB3YXMK
PiA+PiBkZWZpbml0ZWx5IG11Y2ggbW9yZSBub3RpY2VhYmxlLgo+ID4+Cj4gPj4gU28gZGlkIHlv
dSBzZWUgYW55IHBlcmZvcm1hbmNlIGltcGFjdCB3aXRoIHRoaXMgc2VyaWVzPwo+ID4+Cj4gPgo+
ID4gWW91IG5vcm1hbGx5IGRvbid0IFBYRSBib290LiBUaGVyZSBpcyBhbiBpc3N1ZSB3aXRoIHRo
ZSBpU0NTSSBkcml2ZXIKPiA+IGFzIHdlbGwsIHdoaWNoIGNhdXNlcyBhIGJvb3QgZGVsYXkgZm9y
IHNvbWUgcmVhc29uLCBzbyBJIGRpc2FibGVkIHRoYXQKPiA+IGluIG15IGJ1aWxkLgo+ID4KPiA+
IEkgZGVmaW5pdGVseSAqZmVlbHMqIGZhc3RlciA6LSkgQnV0IGluIGFueSBjYXNlLCBleHBvc2lu
ZyB0aGUgYXJyYXkKPiA+IG1vZGUgYXMgYSByL28gbWVtc2xvdCBpcyBkZWZpbml0ZWx5IHRoZSBy
aWdodCB3YXkgdG8gZGVhbCB3aXRoIHRoaXMuCj4gPiBFdmVuIGlmIFNhbWkgZGlkIGZpbmQgYSB3
b3JrYXJvdW5kIHRoYXQgbWFza3MgdGhlIGVycm9yLCBpdCBpcyBubwo+ID4gZ3VhcmFudGVlIHRo
YXQgYWxsIGFjY2Vzc2VzIGdvIHRocm91Z2ggdGhhdCBsaWJyYXJ5Lgo+Cj4gU28gSSB3YXMgd29u
ZGVyaW5nIGFib3V0IHRoaXMsIG1heWJlIHlvdSBjYW4gY29uZmlybSBvciBkZWJ1bmsgdGhpczoK
PiAtIEFueSBtZW1vcnkgZ2l2ZW4gdG8gdGhlIGNvbXBpbGVyICh0aHJvdWdoIGEgcG9pbnRlcikg
aXMgYXNzdW1lZCB0byBiZQo+ICJub3JtYWwiIG1lbW9yeTogdGhlIGNvbXBpbGVyIGNhbiByZS1h
cnJhbmdlIGFjY2Vzc2VzLCBzcGxpdCB0aGVtIHVwIG9yCj4gY29sbGF0ZSB0aGVtLiBBbHNvIHVu
YWxpZ25lZCBhY2Nlc3NlcyBzaG91bGQgYmUgYWxsb3dlZCAtIGFsdGhvdWdoIEkKPiBndWVzcyBt
b3N0IGNvbXBpbGVycyB3b3VsZCBhdm9pZCB0aGVtLgo+IC0gVGhpcyBub3JtYWxseSBmb3JiaWRz
IHRvIGdpdmUgYSBwb2ludGVyIHRvIG1lbW9yeSBtYXBwZWQgYXMgImRldmljZQo+IG1lbW9yeSIg
dG8gdGhlIGNvbXBpbGVyLCBzaW5jZSB0aGlzIHdvdWxkIHZpb2xhdGUgYWxsIG9mIHRoZSBhc3N1
bXB0aW9ucwo+IGFib3ZlLgo+IC0gSWYgdGhlIGRldmljZSBtYXBwZWQgYXMgImRldmljZSBtZW1v
cnkiIGlzIGFjdHVhbGx5IG1lbW9yeSAoU1JBTSwKPiBST00vZmxhc2gsIGZyYW1lYnVmZmVyKSwg
dGhlbiBtb3N0IG9mIHRoZSBhc3N1bXB0aW9ucyBhcmUgbWV0LCBleGNlcHQKPiB0aGUgYWxpZ25t
ZW50IHJlcXVpcmVtZW50LCB3aGljaCBpcyBib3VuZCB0byB0aGUgbWFwcGluZyB0eXBlLCBub3Qg
dGhlCj4gYWN0dWFsIGRldmljZSAoQVJNdjggQVJNOiBVbmFsaWduZWQgYWNjZXNzZXMgdG8gZGV2
aWNlIG1lbW9yeSBhbHdheXMKPiB0cmFwLCByZWdhcmRsZXNzIG9mIFNDVExSLkEpCj4gLSBUbyBh
Y2NvbW1vZGF0ZSB0aGUgbGF0dGVyLCBHQ0Mga25vd3MgdGhlIG9wdGlvbiAtbWFsaWduLXN0cmlj
dCwgdG8KPiBhdm9pZCB1bmFsaWduZWQgYWNjZXNzZXMuIFRGLUEgYW5kIFUtQm9vdCB1c2UgdGhp
cyBvcHRpb24sIHRvIHJ1bgo+IHdpdGhvdXQgdGhlIE1NVSBlbmFibGVkLgo+Cj4gTm93IGlmIEVE
Sy0yIGxldHMgdGhlIGNvbXBpbGVyIGRlYWwgd2l0aCB0aGUgZmxhc2ggbWVtb3J5IHJlZ2lvbgo+
IGRpcmVjdGx5LCBJIHRoaW5rIHRoaXMgd291bGQgc3RpbGwgYmUgcHJvbmUgdG8gYWxpZ25tZW50
IGZhdWx0cy4gSW4gZmFjdAo+IGFuIGVhcmxpZXIgYnVpbGQgSSBnb3QgZnJvbSBTYW1pIGZhdWx0
ZWQgb24gZXhhY3RseSB0aGF0LCB3aGVuIEkgcmFuIGl0LAo+IGV2ZW4gd2l0aCB0aGUgci9vIG1l
bXNsb3QgbWFwcGluZyBpbiBwbGFjZS4KPgo+IFNvIHNob3VsZCBFREstMiBhZGQgLW1hbGlnbi1z
dHJpY3QgdG8gYmUgc2FmZT8KCkl0IGFscmVhZHkgdXNlcyB0aGlzIGluIHZhcmlvdXMgcGxhY2Vz
IHdoZXJlIGl0IG1hdHRlcnMuCgo+ICAgICAgICAgb3IKPiBTaG91bGQgRURLLTIgYWRkIGFuIGFk
ZGl0aW9uYWwgb3IgYWx0ZXJuYXRlIG1hcHBpbmcgdXNpbmcgYSBub24tZGV2aWNlCj4gbWVtb3J5
IHR5cGUgKHdpdGggYWxsIHRoZSBtaXNtYXRjaGVkIGF0dHJpYnV0ZXMgY29uc2VxdWVuY2VzKT8K
ClRoZSBtZW1vcnkgbWFwcGVkIE5PUiBmbGFzaCBpbiBVRUZJIGlzIHJlYWxseSBhIHNwZWNpYWwg
Y2FzZSwgc2luY2Ugd2UKbmVlZCB0aGUgT1MgdG8gbWFwIGl0IGZvciB1cyBhdCBydW50aW1lLCBh
bmQgd2UgY2Fubm90IHRlbGwgaXQgdG8Kc3dpdGNoIGJldHdlZW4gbm9ybWFsLU5DIGFuZCBkZXZp
Y2UgYXR0cmlidXRlcyBkZXBlbmRpbmcgb24gd2hpY2ggbW9kZQp0aGUgZmlybXdhcmUgaXMgdXNp
bmcgaXQgaW4uCgpOb3RlIHRoYXQgdGhpcyBpcyBub3QgYW55IGRpZmZlcmVudCBvbiBiYXJlIG1l
dGFsLgoKPiAgICAgICAgIG9yCj4gU2hvdWxkIEVESy0yIG9ubHkgdG91Y2ggdGhlIGZsYXNoIHJl
Z2lvbiB1c2luZyBNTUlPIGFjY2Vzc29ycywgYW5kCj4gZm9yYmlkIHRoZSBjb21waWxlciBkaXJl
Y3QgYWNjZXNzIHRvIHRoYXQgcmVnaW9uPwo+CgpJdCBzaG91bGQgb25seSB0b3VjaCB0aG9zZSBy
ZWdpb25zIHVzaW5nIGFic3RyYWN0aW9ucyBpdCBkZWZpbmVzCml0c2VsZiwgYW5kIHdoaWNoIGNh
biBiZSBiYWNrZWQgaW4gZGlmZmVyZW50IHdheXMuIFRoaXMgaXMgYWxyZWFkeSB0aGUKY2FzZSBp
biBFREsyOiBpdCBoYXMgaXRzIG93biBDb3B5TWVtLCBaZXJvTWVtLCBldGMgc3RyaW5nIGxpYnJh
cnksIGFuZApiYW5zIHRoZSB1c2UgdGhlIHN0YW5kYXJkIEMgb25lcy4gT24gdG9wIG9mIHRoYXQs
IGl0IGJhbnMgc3RydWN0CmFzc2lnbm1lbnQsIGluaXRpYWxpemVycyBmb3IgYXV0b21hdGljIHZh
cmlhYmxlcyBhbmQgYXJlIHRoaW5ncyB0aGF0CnJlc3VsdCBpbiBzdWNoIGNhbGxzIHRvIGJlIGVt
aXR0ZWQgaW1wbGljaXRseS4KClNvIGluIHByYWN0aWNlLCB0aGlzIGlzc3VlIGlzIHVuZGVyIGNv
bnRyb2wsIHVubGVzcyB5b3UgdXNlIGEgdmVyc2lvbgpvZiB0aG9zZSBhYnN0cmFjdGlvbnMgdGhh
dCB3aWxsaW5nbHkgdXNlcyB1bmFsaWduZWQgYWNjZXNzZXMgKHdlIGhhdmUKb3B0aW1pemVkIHZl
cnNpb25zIGJhc2VkIG9uIHRoZSBjb3J0ZXgtc3RyaW5ncyBsaWJyYXJ5KS4gU28gbXkKc3VzcGlj
aW9uIGlzIHRoYXQgdGhpcyBtYXkgaGF2ZSBjYXVzZWQgdGhlIGNyYXNoOiBvbiBiYXJlIG1ldGFs
LCB3ZQpoYXZlIHRvIHN3aXRjaCB0byB0aGUgbm9uLW9wdGltaXplZCBzdHJpbmcgbGlicmFyeSBm
b3IgdGhlIHZhcmlhYmxlCmRyaXZlciBmb3IgdGhpcyByZWFzb24uCgpUaGUgcmVhbCBzb2x1dGlv
biBpcyB0byBmaXggRURLMiwgYW5kIG1ha2UgdGhlIHZhcmlhYmxlIHN0YWNrIHdvcmsKd2l0aCBO
T1IgZmxhc2ggdGhhdCBpcyBub24tbWVtb3J5IG1hcHBlZC4gVGhpcyBpcyBzb21ldGhpbmcgdGhh
dCBoYXMKY29tZSB1cCBiZWZvcmUsIGFuZCB0aGUgb3RoZXIgZGF5LCBTYW1pIGFuZCBJIHdlcmUg
anVzdCBkaXNjdXNzaW5nCmxvZ2dpbmcgdGhpcyBhcyBhIHdpc2hsaXN0IGl0ZW0gZm9yIHRoZSBm
aXJtd2FyZSB0ZWFtLgoKCj4gU28gZG9lcyBFREstMiBnZXQgYXdheSB3aXRoIHRoaXMgYmVjYXVz
ZSB0aGUgY29tcGlsZXIgdHlwaWNhbGx5IGF2b2lkcwo+IHVuYWxpZ25lZCBhY2Nlc3Nlcz8KPgoK
VGhlcmUgYXJlIGNlcnRhaW5seSBzb21lIHBsYWNlcyBpbiB0aGUgY3VycmVudCBjb2RlIGJhc2Ug
d2hlcmUgaXQgaXMKdGhlIGNvbXBpbGVyIHRoYXQgaXMgZW1pdHRpbmcgcmVhZHMgZnJvbSB0aGUg
Tk9SIGZsYXNoIHJlZ2lvbiwgYnV0CnRoZXJlIGFyZW4ndCB0aGF0IG1hbnkuIE1vdmluZyB0aGUg
dmFyaWFibGUgZGF0YSBpdHNlbGYgaW4gYW5kIG91dAp3aWxsIHR5cGljYWxseSB1c2UgdGhlIGFi
c3RyYWN0aW9ucywgc2luY2UgaXQgaXMgbW92aW5nIGFub255bW91cwpjaHVua3Mgb2YgZGF0YS4g
SG93ZXZlciwgdGhlcmUgYXJlIHBsYWNlcyB3aGVyZSwgZS5nLiwgZmllbGRzIGluIHRoZQpGUyBt
ZXRhZGF0YSBhcmUgYmVpbmcgcmVhZCBieSB0aGUgY29kZSwgYW5kIHRoZXJlIGl0IGp1c3QgY2Fz
dHMgYW4KYWRkcmVzcyBwb2ludGluZyBpbnRvIHRoZSBOT1IgZmxhc2ggcmVnaW9uIHRvIHRoZSBh
cHByb3ByaWF0ZSBzdHJ1Y3QKdHlwZSwgYW5kIGRlcmVmZXJlbmNlcyB0aGUgZmllbGRzLgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
