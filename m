Return-Path: <SRS0=H2W4=6I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDF6C54FCB
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 12:08:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93B5220728
	for <kvmarm@archiver.kernel.org>; Fri, 24 Apr 2020 12:08:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93B5220728
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D56414B238;
	Fri, 24 Apr 2020 08:08:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gC2HgMXgtJim; Fri, 24 Apr 2020 08:08:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99FF24B24C;
	Fri, 24 Apr 2020 08:08:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC34C4B240
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 08:08:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EJDzG7--nG5k for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Apr 2020 08:08:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 409584B22D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Apr 2020 08:08:54 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C9C9C1FB;
 Fri, 24 Apr 2020 05:08:53 -0700 (PDT)
Received: from [192.168.2.22] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C10C3F6CF;
 Fri, 24 Apr 2020 05:08:52 -0700 (PDT)
Subject: Re: [PATCH kvmtool v4 0/5] Add CFI flash emulation
To: Ard Biesheuvel <ardb@kernel.org>
References: <20200423173844.24220-1-andre.przywara@arm.com>
 <CAMj1kXGDjzLA3sZg33EK2RVrSmYGuCm4cZ0Y9X=ZLxN8R--7=g@mail.gmail.com>
 <CAMj1kXEjckV3HzcX_XXTSn-tDDQ5H8=LgteDcP5USThn=OgTQg@mail.gmail.com>
 <9e742184-86c1-a4be-c2cb-fe96979e0f1f@arm.com>
 <CAMj1kXGMHfENDCkAyPCvS0avaYGOVbjDkPi964L3y0DVvz8m8A@mail.gmail.com>
From: =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Autocrypt: addr=andre.przywara@arm.com; prefer-encrypt=mutual; keydata=
 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
 i4aIXCH3Wv6K
Organization: ARM Ltd.
Message-ID: <df9a0aeb-39ed-f9bc-c506-71d2f134bc62@arm.com>
Date: Fri, 24 Apr 2020 13:08:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAMj1kXGMHfENDCkAyPCvS0avaYGOVbjDkPi964L3y0DVvz8m8A@mail.gmail.com>
Content-Language: en-US
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

T24gMjQvMDQvMjAyMCAwNzo0NSwgQXJkIEJpZXNoZXV2ZWwgd3JvdGU6CgpIaSwKCihhZGRpbmcg
TGVpZiBmb3IgRURLLTIgZGlzY3Vzc2lvbikKCj4gT24gVGh1LCAyMyBBcHIgMjAyMCBhdCAyMzoz
MiwgQW5kcsOpIFByenl3YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0uY29tPiB3cm90ZToKPj4KPj4g
T24gMjMvMDQvMjAyMCAyMTo0MywgQXJkIEJpZXNoZXV2ZWwgd3JvdGU6CgpbIC4uLiBrdm10b29s
IHNlcmllcyB0byBhZGQgQ0ZJIGZsYXNoIGVtdWxhdGlvbiBhbGxvd2luZyBFREstMiB0byBzdG9y
ZQp2YXJpYWJsZXMuIFN0YXJ0aW5nIHdpdGggdGhpcyB2ZXJzaW9uICh2NCkgdGhlIGZsYXNoIG1l
bW9yeSByZWdpb24gaXMKcHJlc2VudGVkIGFzIGEgcmVhZC1vbmx5IG1lbXNsb3QgdG8gS1ZNLCB0
byBhbGxvdyBkaXJlY3QgZ3Vlc3QgYWNjZXNzZXMKYXMgb3Bwb3NlZCB0byB0cmFwLWFuZC1lbXVs
YXRlIGV2ZW4gcmVhZCBhY2Nlc3NlcyB0byB0aGUgYXJyYXkuXQoKPj4KPj4KPj4gSnVzdCBjdXJp
b3VzOiB0aGUgaW1hZ2VzIFNhbWkgZ2F2ZSBtZSB0aGlzIG1vcm5pbmcgZGlkIG5vdCBzaG93IGFu
eQo+PiBpc3N1ZXMgYW55bW9yZSAobm8gbm8tc3luZHJvbWUgZmF1bHQsIG5vIGFsaWdubWVudCBp
c3N1ZXMpLCBldmVuIHdpdGhvdXQKPj4gdGhlIG1hcHBpbmcgWzFdLiBBbmQgZXZlbiB0aG91Z2gg
SSBzYXcgdGhlIDgwMGsgcmVhZCB0cmFwcywgSSBkaWRuJ3QKPj4gbm90aWNlIGFueSByZWFsIHBl
cmZvcm1hbmNlIGRpZmZlcmVuY2UgKG9uIGEgSnVubykuIFRoZSBQWEUgdGltZW91dCB3YXMKPj4g
ZGVmaW5pdGVseSBtdWNoIG1vcmUgbm90aWNlYWJsZS4KPj4KPj4gU28gZGlkIHlvdSBzZWUgYW55
IHBlcmZvcm1hbmNlIGltcGFjdCB3aXRoIHRoaXMgc2VyaWVzPwo+Pgo+IAo+IFlvdSBub3JtYWxs
eSBkb24ndCBQWEUgYm9vdC4gVGhlcmUgaXMgYW4gaXNzdWUgd2l0aCB0aGUgaVNDU0kgZHJpdmVy
Cj4gYXMgd2VsbCwgd2hpY2ggY2F1c2VzIGEgYm9vdCBkZWxheSBmb3Igc29tZSByZWFzb24sIHNv
IEkgZGlzYWJsZWQgdGhhdAo+IGluIG15IGJ1aWxkLgo+IAo+IEkgZGVmaW5pdGVseSAqZmVlbHMq
IGZhc3RlciA6LSkgQnV0IGluIGFueSBjYXNlLCBleHBvc2luZyB0aGUgYXJyYXkKPiBtb2RlIGFz
IGEgci9vIG1lbXNsb3QgaXMgZGVmaW5pdGVseSB0aGUgcmlnaHQgd2F5IHRvIGRlYWwgd2l0aCB0
aGlzLgo+IEV2ZW4gaWYgU2FtaSBkaWQgZmluZCBhIHdvcmthcm91bmQgdGhhdCBtYXNrcyB0aGUg
ZXJyb3IsIGl0IGlzIG5vCj4gZ3VhcmFudGVlIHRoYXQgYWxsIGFjY2Vzc2VzIGdvIHRocm91Z2gg
dGhhdCBsaWJyYXJ5LgoKU28gSSB3YXMgd29uZGVyaW5nIGFib3V0IHRoaXMsIG1heWJlIHlvdSBj
YW4gY29uZmlybSBvciBkZWJ1bmsgdGhpczoKLSBBbnkgbWVtb3J5IGdpdmVuIHRvIHRoZSBjb21w
aWxlciAodGhyb3VnaCBhIHBvaW50ZXIpIGlzIGFzc3VtZWQgdG8gYmUKIm5vcm1hbCIgbWVtb3J5
OiB0aGUgY29tcGlsZXIgY2FuIHJlLWFycmFuZ2UgYWNjZXNzZXMsIHNwbGl0IHRoZW0gdXAgb3IK
Y29sbGF0ZSB0aGVtLiBBbHNvIHVuYWxpZ25lZCBhY2Nlc3NlcyBzaG91bGQgYmUgYWxsb3dlZCAt
IGFsdGhvdWdoIEkKZ3Vlc3MgbW9zdCBjb21waWxlcnMgd291bGQgYXZvaWQgdGhlbS4KLSBUaGlz
IG5vcm1hbGx5IGZvcmJpZHMgdG8gZ2l2ZSBhIHBvaW50ZXIgdG8gbWVtb3J5IG1hcHBlZCBhcyAi
ZGV2aWNlCm1lbW9yeSIgdG8gdGhlIGNvbXBpbGVyLCBzaW5jZSB0aGlzIHdvdWxkIHZpb2xhdGUg
YWxsIG9mIHRoZSBhc3N1bXB0aW9ucwphYm92ZS4KLSBJZiB0aGUgZGV2aWNlIG1hcHBlZCBhcyAi
ZGV2aWNlIG1lbW9yeSIgaXMgYWN0dWFsbHkgbWVtb3J5IChTUkFNLApST00vZmxhc2gsIGZyYW1l
YnVmZmVyKSwgdGhlbiBtb3N0IG9mIHRoZSBhc3N1bXB0aW9ucyBhcmUgbWV0LCBleGNlcHQKdGhl
IGFsaWdubWVudCByZXF1aXJlbWVudCwgd2hpY2ggaXMgYm91bmQgdG8gdGhlIG1hcHBpbmcgdHlw
ZSwgbm90IHRoZQphY3R1YWwgZGV2aWNlIChBUk12OCBBUk06IFVuYWxpZ25lZCBhY2Nlc3NlcyB0
byBkZXZpY2UgbWVtb3J5IGFsd2F5cwp0cmFwLCByZWdhcmRsZXNzIG9mIFNDVExSLkEpCi0gVG8g
YWNjb21tb2RhdGUgdGhlIGxhdHRlciwgR0NDIGtub3dzIHRoZSBvcHRpb24gLW1hbGlnbi1zdHJp
Y3QsIHRvCmF2b2lkIHVuYWxpZ25lZCBhY2Nlc3Nlcy4gVEYtQSBhbmQgVS1Cb290IHVzZSB0aGlz
IG9wdGlvbiwgdG8gcnVuCndpdGhvdXQgdGhlIE1NVSBlbmFibGVkLgoKTm93IGlmIEVESy0yIGxl
dHMgdGhlIGNvbXBpbGVyIGRlYWwgd2l0aCB0aGUgZmxhc2ggbWVtb3J5IHJlZ2lvbgpkaXJlY3Rs
eSwgSSB0aGluayB0aGlzIHdvdWxkIHN0aWxsIGJlIHByb25lIHRvIGFsaWdubWVudCBmYXVsdHMu
IEluIGZhY3QKYW4gZWFybGllciBidWlsZCBJIGdvdCBmcm9tIFNhbWkgZmF1bHRlZCBvbiBleGFj
dGx5IHRoYXQsIHdoZW4gSSByYW4gaXQsCmV2ZW4gd2l0aCB0aGUgci9vIG1lbXNsb3QgbWFwcGlu
ZyBpbiBwbGFjZS4KClNvIHNob3VsZCBFREstMiBhZGQgLW1hbGlnbi1zdHJpY3QgdG8gYmUgc2Fm
ZT8KCW9yClNob3VsZCBFREstMiBhZGQgYW4gYWRkaXRpb25hbCBvciBhbHRlcm5hdGUgbWFwcGlu
ZyB1c2luZyBhIG5vbi1kZXZpY2UKbWVtb3J5IHR5cGUgKHdpdGggYWxsIHRoZSBtaXNtYXRjaGVk
IGF0dHJpYnV0ZXMgY29uc2VxdWVuY2VzKT8KCW9yClNob3VsZCBFREstMiBvbmx5IHRvdWNoIHRo
ZSBmbGFzaCByZWdpb24gdXNpbmcgTU1JTyBhY2Nlc3NvcnMsIGFuZApmb3JiaWQgdGhlIGNvbXBp
bGVyIGRpcmVjdCBhY2Nlc3MgdG8gdGhhdCByZWdpb24/CgpTbyBkb2VzIEVESy0yIGdldCBhd2F5
IHdpdGggdGhpcyBiZWNhdXNlIHRoZSBjb21waWxlciB0eXBpY2FsbHkgYXZvaWRzCnVuYWxpZ25l
ZCBhY2Nlc3Nlcz8KCkNoZWVycywKQW5kcmUKCj4+PiBbMF0gaHR0cHM6Ly9wZW9wbGUubGluYXJv
Lm9yZy9+YXJkLmJpZXNoZXV2ZWwvS1ZNVE9PTF9FRkkuZmQKPj4KPj4gQWgsIG5pY2UsIHdpbGwg
dGhpcyBzdGF5IHRoZXJlIGZvciBhIHdoaWxlPyBJIGNhbid0IHByb3ZpZGUgYmluYXJpZXMsCj4+
IGJ1dCB3YW50ZWQgb3RoZXJzIHRvIGJlIGFibGUgdG8gZWFzaWx5IHRlc3QgdGhpcy4KPj4KPiAK
PiBTdXJlLCBJIHdpbGwgbGVhdmUgaXQgdXAgdW50aWwgTGluYXJvIGRlY2lkZXMgdG8gdGFrZSBk
b3duIG15IGFjY291bnQuCj4gCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5l
ZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
