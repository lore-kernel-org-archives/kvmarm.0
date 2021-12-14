Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5785FC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 15:37:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 050CA4B08D;
	Tue, 14 Dec 2021 10:37:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@gmx.net
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id urS7Nir-39bY; Tue, 14 Dec 2021 10:37:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F6E34B21F;
	Tue, 14 Dec 2021 10:37:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A8E94B12E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 03:16:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sg7xo7lMN3QU for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 03:16:56 -0500 (EST)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 789B74B1E2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 03:16:56 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=badeba3b8450; t=1639469812;
 bh=PJPnq36oi3KVB68BG1DJDJd75GxB+lso/SROvT1dtlc=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=Qxxhv+1ybBa8g1A6uoIYzEoSr44mueyQayDjoK+nipIjm6L8/ESMoxLlHV8Ghu5IN
 w96QG+g06pzj0qSu3kCh0hcRJhYbq801i/uJKAtgAUF8TEEdIKrsndqaSNXFJ5PJzb
 AUJYqbSW6kDThclYfrGYS/v1iqC13HK9OE4nQfu0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1My32L-1mapuH3znb-00zZxp; Tue, 14
 Dec 2021 09:16:52 +0100
Message-ID: <2281a255-fef3-c872-963e-2c5274d0d815@gmx.com>
Date: Tue, 14 Dec 2021 16:16:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: Libvirt on little.BIG ARM systems unable to start guest if no
 cpuset is provided
Content-Language: en-US
To: =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>,
 Marc Zyngier <maz@kernel.org>, Peter Maydell <peter.maydell@linaro.org>
References: <70a2f7d6-5ac1-72df-4a88-b1a662d07070@gmx.com>
 <32bb61a9-0938-d254-0453-18a108bc4b63@redhat.com>
 <1dc0403b-c61b-b04b-e7fd-f2d66276ba7b@gmx.com>
 <CAFEAcA-URrpy3w3AtDb8zVfq8fWxvQ8_jtSqEkaeb=3KE99oAQ@mail.gmail.com>
 <87lf0ojvq2.wl-maz@kernel.org> <aa407ba2-e9c4-882e-a085-91e7dd724f78@gmx.com>
 <29409a18-5156-6b3a-6a44-eecd83a20a78@redhat.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <29409a18-5156-6b3a-6a44-eecd83a20a78@redhat.com>
X-Provags-ID: V03:K1:eFTfrvI7Z+XdGY7CO3Elva0VtFsBBntjBNyjhsQGbxnC4jfpH3l
 l6OR/JZGfjPgQhQZjsEo44+OydGIWZ9EIQFHXd+W07YzE58KiNUVsgIOQfVGLLL4oZahXun
 t6JrMJHnT25kVWtf58GTK2wZnZQm0P4FE74pAu5NI9Z7L7di+k1Wzk2Pe27HvAnFXsfV4QN
 vCtdI+pXaFErXa8jkzSxw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BEWE20Pr8iw=:2nVdIt+XmljzaTJtvENL3A
 qu0zpx6DLIvTB+r/tmj2ZdsHq5zDXajz94ngqQqSkxBeXtlzuWaB+mlw7FcmIqJ4v4rDboYjd
 U/npcd/JbmuuJ4WI073qSIvljPWWbX9LhAWlS0gm/rXJS7ri/wws0gDZLxHMFRzS6NsOMXnGm
 YBGoV9yhLhaMfcoG2gCbrfm3W6DzRb/6+awPjam+E1ubFwVkC+eWeSllKCkdh78WtdYDQmEZE
 0tkwdTHKZiDtdUVsgi+N15xwaDK02MTijKhqNk0+tlLu+MLd7CJSy8Ta5PvuBiE/6gPh/WRHC
 JjiFCLGxjRSnui+CFUZJiEgaGRwfGzCXIk0QjHeeke4z6DJr8Sym5DNiWm7fzBOT7qadfBd+M
 65P9PLsCsTARxFdOohz7I97psKep1Cl/N9sukpYHL2P7up79myftV0G4AnjfL14a4RjP9b6iO
 sgd9v9DrvnWCSNQN9Oh7A/em8bsyyO5o9O6ljghJfx6B1m9HrN71uTbc+/OTwkuWWEq5DggsZ
 mmf4/7aEO5PTu+uHCI5Q5N9S9PedqJ3E4iyFAAfMcrLbA4P9R5q7ozAuKk74+Q5M7Dv+hDBzY
 i1Dw4gj/Tm55g9xOqlz1AubIDa3DfIvLPuTRxw9fbbHZ+c0a0VTwNPrnFWryvsMsuDNMg5DHS
 A+RNL6YE7p0wgLhOo0k+y5Z+Odf5CyqtbHKtWsJAjOErX3+GlxpUtMQqdVr18HtESoDN3rPT6
 InZ2Nn/isIq38nYrd13cbu4S4VusPPUIiGXl6+kipQlIjmsa2if1K9Aaijc/PRIo69w4+kdTo
 NVzr5eok/UfpKzcSUe460MRIBnqDvVt083jklY5JMIBok9A7zC9ir8/c0dE1BjuzjjPIRrR++
 iJCC2dEOXApl3+oEAv/tup5wtkaO7pluJ7M3diHqV+M21nyfoW+PTsL22n3sgqt2hOw8xV242
 W6u5Numk1jCKvPL8OybWcnKjonE6iqVyldwJxTX2EPb8sgnLwJVkbk+YUt0A1clZvgqrxtSTu
 41hI0h/MVhIQL8v71sUrW5e24U23cl0SGc7iyzPgP4HphrF1tftIHw8zUik50KxPGZGPU8TjC
 vjkoxGs9Crcxnk=
X-Mailman-Approved-At: Tue, 14 Dec 2021 10:37:24 -0500
Cc: libvirt-users@redhat.com, qemu-arm@nongnu.org,
 kvmarm <kvmarm@lists.cs.columbia.edu>, qemu-discuss@nongnu.org
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

CgpPbiAyMDIxLzEyLzE0IDE1OjUzLCBNaWNoYWwgUHLDrXZvem7DrWsgd3JvdGU6Cj4gT24gMTIv
MTQvMjEgMDE6NDEsIFF1IFdlbnJ1byB3cm90ZToKPj4KPj4KPj4gT24gMjAyMS8xMi8xNCAwMDo0
OSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4gT24gTW9uLCAxMyBEZWMgMjAyMSAxNjowNjoxNCAr
MDAwMCwKPj4+IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9yZz4gd3JvdGU6
Cj4+Pj4KPj4+PiBLVk0gb24gYmlnLmxpdHRsZSBzZXR1cHMgaXMgYSBrZXJuZWwtbGV2ZWwgcXVl
c3Rpb24gcmVhbGx5OyBJJ3ZlCj4+Pj4gY2MnZCB0aGUga3ZtYXJtIGxpc3QuCj4+Pgo+Pj4gVGhh
bmtzIFBldGVyIGZvciB0aHJvd2luZyB1cyB1bmRlciB0aGUgYmlnLWxpdHRsZSBidXMhIDstKQo+
Pj4KPj4+Pgo+Pj4+IE9uIE1vbiwgMTMgRGVjIDIwMjEgYXQgMTU6MDIsIFF1IFdlbnJ1byA8cXV3
ZW5ydW8uYnRyZnNAZ214LmNvbT4gd3JvdGU6Cj4+Pj4+Cj4+Pj4+Cj4+Pj4+Cj4+Pj4+IE9uIDIw
MjEvMTIvMTMgMjE6MTcsIE1pY2hhbCBQcsOtdm96bsOtayB3cm90ZToKPj4+Pj4+IE9uIDEyLzEx
LzIxIDAyOjU4LCBRdSBXZW5ydW8gd3JvdGU6Cj4+Pj4+Pj4gSGksCj4+Pj4+Pj4KPj4+Pj4+PiBS
ZWNlbnRseSBJIGdvdCBteSBsaWJ2aXJ0IHNldHVwIG9uIGJvdGggUkszMzk5IChSb2NrUHJvNjQp
IGFuZCBSUEkKPj4+Pj4+PiBDTTQsCj4+Pj4+Pj4gd2l0aCB1cHN0cmVhbSBrZXJuZWxzLgo+Pj4+
Pj4+Cj4+Pj4+Pj4gRm9yIFJQSSBDTTQgaXRzIG1vc3RseSBzbW9vdGggc2FpbCwgYnV0IG9uIFJL
MzM5OSBkdWUgdG8gaXRzCj4+Pj4+Pj4gbGl0dGxlLkJJRwo+Pj4+Pj4+IHNldHVwIChjb3JlIDAt
MyBhcmUgNHggQTU1IGNvcmVzLCBhbmQgY29yZSA0LTUgYXJlIDJ4IEE3MiBjb3JlcyksIGl0Cj4+
Pj4+Pj4gYnJpbmdzIHF1aXRlIHNvbWUgdHJvdWJsZXMgZm9yIFZNcy4KPj4+Pj4+Pgo+Pj4+Pj4+
IEluIHNob3J0LCB3aXRob3V0IHByb3BlciBjcHVzZXQgdG8gYmluZCB0aGUgVk0gdG8gZWl0aGVy
IGFsbCBBNzIKPj4+Pj4+PiBjb3Jlcwo+Pj4+Pj4+IG9yIGFsbCBBNTUgY29yZXMsIHRoZSBWTSB3
aWxsIG1vc3RseSBmYWlsIHRvIGJvb3QuCj4+Pgo+Pj4gcy9BNTUvQTUzLy4gVGhlcmUgd2VyZSB0
aGFua2Z1bGx5IG5vIEE3MitBNTUgZXZlciBwcm9kdWNlZCAoanVzdCB0aGUKPj4+IHRob3VnaCBv
ZiBpdCBtYWtlcyBtZSBzaWNrKS4KPj4+Cj4+Pj4+Pj4KPj4+Pj4+PiBDdXJyZW50bHkgdGhlIHdv
cmtpbmcgeG1sIGlzOgo+Pj4+Pj4+Cj4+Pj4+Pj4gIMKgwqDCoCA8dmNwdSBwbGFjZW1lbnQ9J3N0
YXRpYycgY3B1c2V0PSc0LTUnPjI8L3ZjcHU+Cj4+Pj4+Pj4gIMKgwqDCoCA8Y3B1IG1vZGU9J2hv
c3QtcGFzc3Rocm91Z2gnIGNoZWNrPSdub25lJy8+Cj4+Pj4+Pj4KPj4+Pj4+PiBCdXQgZXZlbiB3
aXRoIHZjcHVwaW4sIHBpbm5pbmcgZWFjaCB2Y3B1IHRvIGVhY2ggcGh5c2ljYWwgY29yZSwgVk0K
Pj4+Pj4+PiB3aWxsCj4+Pj4+Pj4gbW9zdGx5IGZhaWwgdG8gc3RhcnQgdXAgZHVlIHRvIHZjcHUg
aW5pdGlhbGl6YXRpb24gZmFpbGVkIHdpdGgKPj4+Pj4+PiAtRUlOVkFMLgo+Pj4KPj4+IERpc2Ns
YWltZXI6IEkga25vdyBub3RoaW5nIGFib3V0IGxpYnZpcnQgKGFuZCBubywgSSBkb24ndCB3YW50
IHRvCj4+PiBrbm93ISA7LSkuCj4+Pgo+Pj4gSG93ZXZlciwgZm9yIHRoaW5ncyB0byBiZSByZWxp
YWJsZSwgeW91IG5lZWQgdG8gdGFza3NldCB0aGUgd2hvbGUgUUVNVQo+Pj4gcHJvY2VzcyB0byB0
aGUgQ1BVIHR5cGUgeW91IGludGVuZCB0byB1c2UuCj4+Cj4+IFllcCwgdGhhdCdzIHdoYXQgSSdt
IGRvaW5nLgo+Pgo+Pj4gVGhhdCdzIGJlY2F1c2UsIEFGQUlDVCwKPj4+IFFFTVUgd2lsbCBzbmFw
c2hvdCB0aGUgc3lzdGVtIHJlZ2lzdGVycyBvdXRzaWRlIG9mIHRoZSB2Y3B1IHRocmVhZHMsCj4+
PiBhbmQgYXR0ZW1wdCB0byB1c2UgdGhlIHJlc3VsdCB0byBjb25maWd1cmUgdGhlIGFjdHVhbCB2
Y3B1IHRocmVhZHMuIElmCj4+PiB0aGV5IGhhcHBlbiB0byBydW4gb24gZGlmZmVyZW50IENQVSB0
eXBlcywgdGhlIHN5c3JlZ3Mgd2lsbCBkaWZmZXIgaW4KPj4+IGluY29tcGF0aWJsZSB3YXlzIGFu
ZCBhbiBlcnJvciB3aWxsIGJlIHJldHVybmVkLiBUaGlzIG1heSBvciBtYXkgbm90Cj4+PiBiZSBh
IGJ1ZywgSSBkb24ndCBrbm93IChJIHNlZSBpdCBhcyBhIGZlYXR1cmUpLgo+Pgo+PiBUaGVuIHRo
aXMgYnJpbmdzIGFub3RoZXIgcXVlc3Rpb24uCj4+Cj4+IElmIHdlIGNhbiBwaW4gZWFjaCB2Q1BV
IHRvIGVhY2ggcGh5c2ljYWwgY29yZSAoYm90aCBsaXR0bGUgYW5kIGJpZyksCj4+IHRoZW4gYXMg
bG9uZyBhcyB0aGUgcmVnaXN0ZXJzIGFyZSBwZXItdkNQVSBiYXNlZCwgaXQgc2hvdWxkIGJlIGFi
bGUgdG8KPj4gcGFzcyBib3RoIGJpZyBhbmQgbGl0dGxlIGNvcmVzIHRvIHRoZSBWTS4KPj4KPj4g
WWVhaCwgSSB0b3RhbGx5IHVuZGVyc3RhbmQgdGhpcyBzY3JldyB1cCB0aGUgc2NoZWR1bGluZywg
YnV0IHRoYXQncyBhdAo+PiBsZWFzdCB3aGF0IChzb21lIGluc2FuZSkgdXNlcnMgd2FudCAoanVz
dCBsaWtlIG1lKS4KPj4KPj4+Cj4+PiBJZiB5b3UgYXJlIGFubm95ZWQgd2l0aCB0aGlzIGJlaGF2
aW91ciwgeW91IGNhbiBhbHdheXMgdXNlIGEgZGlmZmVyZW50Cj4+PiBWTU0gdGhhdCB3b24ndCBj
YXJlIGFib3V0IHN1Y2ggZGlmZmVyZW5jZSAoY3Jvc3ZtIG9yIGt2bXRvb2wsIHRvIG5hbWUKPj4+
IGEgZmV3KS4KPj4KPj4gU291bmRzIHByZXR0eSBpbnRlcmVzdGluZywgYSBuZXcgd29ybGQgYnV0
IHdpdGhvdXQgbGlidmlydC4uLgo+Pgo+Pj4gSG93ZXZlciwgdGhlIGd1ZXN0IHdpbGwgYmUgYWJs
ZSB0byBvYnNlcnZlIHRoZSBtaWdyYXRpb24gZnJvbQo+Pj4gb25lIGNwdSB0eXBlIHRvIGFub3Ro
ZXIuIFRoaXMgbWF5IG9yIG1heSBub3QgYWZmZWN0IHlvdXIgZ3Vlc3Qncwo+Pj4gYmVoYXZpb3Vy
Lgo+Pgo+PiBOb3Qgc3VyZSBpZiBpdCdzIHBvc3NpYmxlIHRvIHBpbiBlYWNoIHZDUFUgdGhyZWFk
IHRvIGVhY2ggY29yZSwgYnV0IGxldAo+PiBtZSB0cnkuCj4+Cj4KPiBTdXJlIGl0IGlzLCBmb3Ig
aW5zdGFuY2U6Cj4KPiA8Y3B1dHVuZT4KPiAgICAgIDx2Y3B1cGluIHZjcHU9IjAiIGNwdXNldD0i
MS00LF4yIi8+Cj4gICAgICA8dmNwdXBpbiB2Y3B1PSIxIiBjcHVzZXQ9IjAsMSIvPgo+ICAgICAg
PHZjcHVwaW4gdmNwdT0iMiIgY3B1c2V0PSIyLDMiLz4KPiAgICAgIDx2Y3B1cGluIHZjcHU9IjMi
IGNwdXNldD0iMCw0Ii8+Cj4gICAgICA8ZW11bGF0b3JwaW4gY3B1c2V0PSIxLTMiLz4KPiAgICAg
IDxpb3RocmVhZHBpbiBpb3RocmVhZD0iMSIgY3B1c2V0PSI1LDYiLz4KPiAgICAgIDxpb3RocmVh
ZHBpbiBpb3RocmVhZD0iMiIgY3B1c2V0PSI3LDgiLz4KPiA8L2NwdXR1bmU+CgpUaGF0J3Mgd2hh
dCBJIGhhdmUgYWxyZWFkeSB0cmllZCBiZWZvcmUuCkkgcGlubmVkIHZjcHUgMC02IHRvIHBoeXNp
Y2FsIGNvcmUgMC02LCBhbmQgc3RpbGwgbm8gcmVsaWFibGUgYm9vdCB1cC4KCkFuZCB0aGF0J3Mg
d2h5IEknbSBhc2tpbmcgaGVyZS4KClRoYW5rcywKUXUKCj4KPiBwaW5zIHZDUFUjMCBvbnRvIGhv
c3QgQ1BVcyAxLTQsIGV4Y2x1ZGluZyAyOyB2Q1BVIzEgb250byBob3N0IENQVXMgMC0xCj4gYW5k
IHNvIG9uLiBZb3UgY2FuIGFsc28gcGluIGVtdWxhdG9yIChRRU1VKSBhbmQgaXRzIGlvdGhyZWFk
cy4gSXQncwo+IGRvY3VtZW50ZWQgaGVyZToKPgo+IGh0dHBzOi8vbGlidmlydC5vcmcvZm9ybWF0
ZG9tYWluLmh0bWwjY3B1LXR1bmluZwo+Cj4gTWljaGFsCj4KX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlz
dHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4v
bGlzdGluZm8va3ZtYXJtCg==
