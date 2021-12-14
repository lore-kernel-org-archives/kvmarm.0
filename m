Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC51C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 15:37:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 19B704B131;
	Tue, 14 Dec 2021 10:37:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmx.net
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 23xAwvO+3ifG; Tue, 14 Dec 2021 10:37:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BEE64B1A4;
	Tue, 14 Dec 2021 10:37:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B0564B18F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 05:21:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8++mW2z9omzv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 05:21:52 -0500 (EST)
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6291A4B15C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 05:21:52 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
 s=badeba3b8450; t=1639477306;
 bh=NYq4bmHCGhprM7/N+mmAj3wKqXzhjkD/CUMmv8ySpns=;
 h=X-UI-Sender-Class:Date:To:Cc:References:From:Subject:In-Reply-To;
 b=Ujik4AwkUYn3QU0RhdSSKwAKcAByO4f0x1DS5uvk66wgvmyNRO5nr2Rotk1uSK0ZN
 6UPx1LsllG9j8CiwTCKpROLYkL6/FcpI3IRYj8cJW87EtMX/HfK+fhrF0yaiurYP8F
 bnc4SsnbLROgii/Qv/6Ih4CB7aWsnTTEa9HSJYmU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MHXBp-1mk6Uy39Xd-00DbTM; Tue, 14
 Dec 2021 11:21:46 +0100
Message-ID: <242ff064-ba82-a045-a407-eaf9dbe5bb40@gmx.com>
Date: Tue, 14 Dec 2021 18:21:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>
References: <70a2f7d6-5ac1-72df-4a88-b1a662d07070@gmx.com>
 <32bb61a9-0938-d254-0453-18a108bc4b63@redhat.com>
 <1dc0403b-c61b-b04b-e7fd-f2d66276ba7b@gmx.com>
 <CAFEAcA-URrpy3w3AtDb8zVfq8fWxvQ8_jtSqEkaeb=3KE99oAQ@mail.gmail.com>
 <87lf0ojvq2.wl-maz@kernel.org> <aa407ba2-e9c4-882e-a085-91e7dd724f78@gmx.com>
 <29409a18-5156-6b3a-6a44-eecd83a20a78@redhat.com>
 <2281a255-fef3-c872-963e-2c5274d0d815@gmx.com> <87ee6fjyyh.wl-maz@kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: Libvirt on little.BIG ARM systems unable to start guest if no
 cpuset is provided
In-Reply-To: <87ee6fjyyh.wl-maz@kernel.org>
X-Provags-ID: V03:K1:JqYwaNg7wHc9rXIm8WHDHGj83HDfltjIsn2laP/F/rZFMIuIvGC
 hNLefZlzysaHxFmfzLIIVLcXnSqj5MpBJrw9O49XhxkIgUTHWhGQ8tXHVFm5bxXVBKR6Ot0
 BcwUm2eC2hS85qyyOzNXHL4Q1UTBlhHpAfJSBKOIFTIm4gI2qgeOLBkwGyQ/vQPgrMNJTf4
 YS2aFPHSxfsHSMRXE2IeA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:etQc8zhf+I0=:48T23MizxsjVL9QKwn+Cdv
 +Q/GBU8+vcql+OCZSlM6qjs/RLRbMKsYRW3L4fRB+gBpTIYCfiEffvsJHBb01Y3YzQfmiH29X
 F3AKwoZ/YZKC2ZmHN7V7ONfrQY3FfzNAm2pjrkWd30YUW2p2IKPSnehc4lfqxKP5JfD+zsdSv
 wrIShvcIaCIMaVifqjIICSt6M/Jhk96YWsBUFywXIOj0S9L0fZd9P+rh19HTziteV+bNsp/pw
 oRI2yK0toJ1aaTLXS6DQSu9IN5iYoL33cquipLFFPZr8WiMbzUQfog4QUerWCexJn9hd5ZqGV
 8SqUW8FuvemvOqqE0a3/b00gzp7kZZ2iGMeogb7wSfQzsA14zf++x4+Ru25Ek9UUcGsCLciAH
 yCE7yX4H4aVkm588+ZUycduF3FKrF8m5XSQIJmGh7bSKFWfCEO4FEe0bv0ez5hoH0LG7RDoZP
 ZO0hXCwkiFxXUkElYFX2jXYuTxicVuftxcfH5e4q6AZnEtvkmPHXgl9Xv1RZV46Ksla43nE9V
 mhWT29vePVpmDmjb4TRBk+DczWOTfHmki0PsvPAYfYiwyC0uxupkUnLwjvk6dPhzqMp/016gV
 VY7Wre/ElHGX9mbI1IL6EpSHya4XkJljr3fQiEZfun+rZQATCE7/v6ahvAdJGGVRpHDI2/n5N
 uKNQZ0TbKioH82qPZxpEb62/jPXX1Gt+3H7m8ydUak4cFG1fdPO8zvR91FFsJNsSAx409bxOH
 Gt8b89L9eWfIhbGp4qjzDhsqrog26571uX15995haKFjJUWvhWFvu6LxrjDV+A/L/k/kgYjPs
 pXRL/Tw8ulpv7iCZ4QZw94G4Q5C04gWeZX6rHuNi01ylquJ7OaMEbPIG1s7EmLxzrZ+WXOJh/
 KFGid8MUxeyblYmuXfX+MU6dZZg9AKIvGuDQa8BEfVJVhObn+w3+fi5xAhly1U1mChAKNKWFX
 E4VvrLgyL3gGEQF2jzqHq3u/wkj51844ulGJOkI40ETGPCyKIPQTB/7W1jjqax7IRfWtM0y+g
 kDgD4OmMpWXEJjJMZ+SAWsT5yUN5NC0tqoTcuvuFEb4l596r5KyyJFZELo3lG2n3TXjIa9aBr
 QApuVQBL0EL5a8=
X-Mailman-Approved-At: Tue, 14 Dec 2021 10:37:24 -0500
Cc: =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>,
 qemu-discuss@nongnu.org, libvirt-users@redhat.com, qemu-arm@nongnu.org,
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

CgpPbiAyMDIxLzEyLzE0IDE3OjUyLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gT24gVHVlLCAxNCBE
ZWMgMjAyMSAwODoxNjo0MCArMDAwMCwKPiBRdSBXZW5ydW8gPHF1d2VucnVvLmJ0cmZzQGdteC5j
b20+IHdyb3RlOgo+Pgo+Pgo+Pgo+PiBPbiAyMDIxLzEyLzE0IDE1OjUzLCBNaWNoYWwgUHLDrXZv
em7DrWsgd3JvdGU6Cj4+PiBPbiAxMi8xNC8yMSAwMTo0MSwgUXUgV2VucnVvIHdyb3RlOgo+Pj4+
Cj4+Pj4KPj4+PiBPbiAyMDIxLzEyLzE0IDAwOjQ5LCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+Pj4+
IE9uIE1vbiwgMTMgRGVjIDIwMjEgMTY6MDY6MTQgKzAwMDAsCj4+Pj4+IFBldGVyIE1heWRlbGwg
PHBldGVyLm1heWRlbGxAbGluYXJvLm9yZz4gd3JvdGU6Cj4+Pj4+Pgo+Pj4+Pj4gS1ZNIG9uIGJp
Zy5saXR0bGUgc2V0dXBzIGlzIGEga2VybmVsLWxldmVsIHF1ZXN0aW9uIHJlYWxseTsgSSd2ZQo+
Pj4+Pj4gY2MnZCB0aGUga3ZtYXJtIGxpc3QuCj4+Pj4+Cj4+Pj4+IFRoYW5rcyBQZXRlciBmb3Ig
dGhyb3dpbmcgdXMgdW5kZXIgdGhlIGJpZy1saXR0bGUgYnVzISA7LSkKPj4+Pj4KPj4+Pj4+Cj4+
Pj4+PiBPbiBNb24sIDEzIERlYyAyMDIxIGF0IDE1OjAyLCBRdSBXZW5ydW8gPHF1d2VucnVvLmJ0
cmZzQGdteC5jb20+IHdyb3RlOgo+Pj4+Pj4+Cj4+Pj4+Pj4KPj4+Pj4+Pgo+Pj4+Pj4+IE9uIDIw
MjEvMTIvMTMgMjE6MTcsIE1pY2hhbCBQcsOtdm96bsOtayB3cm90ZToKPj4+Pj4+Pj4gT24gMTIv
MTEvMjEgMDI6NTgsIFF1IFdlbnJ1byB3cm90ZToKPj4+Pj4+Pj4+IEhpLAo+Pj4+Pj4+Pj4KPj4+
Pj4+Pj4+IFJlY2VudGx5IEkgZ290IG15IGxpYnZpcnQgc2V0dXAgb24gYm90aCBSSzMzOTkgKFJv
Y2tQcm82NCkgYW5kIFJQSQo+Pj4+Pj4+Pj4gQ000LAo+Pj4+Pj4+Pj4gd2l0aCB1cHN0cmVhbSBr
ZXJuZWxzLgo+Pj4+Pj4+Pj4KPj4+Pj4+Pj4+IEZvciBSUEkgQ000IGl0cyBtb3N0bHkgc21vb3Ro
IHNhaWwsIGJ1dCBvbiBSSzMzOTkgZHVlIHRvIGl0cwo+Pj4+Pj4+Pj4gbGl0dGxlLkJJRwo+Pj4+
Pj4+Pj4gc2V0dXAgKGNvcmUgMC0zIGFyZSA0eCBBNTUgY29yZXMsIGFuZCBjb3JlIDQtNSBhcmUg
MnggQTcyIGNvcmVzKSwgaXQKPj4+Pj4+Pj4+IGJyaW5ncyBxdWl0ZSBzb21lIHRyb3VibGVzIGZv
ciBWTXMuCj4+Pj4+Pj4+Pgo+Pj4+Pj4+Pj4gSW4gc2hvcnQsIHdpdGhvdXQgcHJvcGVyIGNwdXNl
dCB0byBiaW5kIHRoZSBWTSB0byBlaXRoZXIgYWxsIEE3Mgo+Pj4+Pj4+Pj4gY29yZXMKPj4+Pj4+
Pj4+IG9yIGFsbCBBNTUgY29yZXMsIHRoZSBWTSB3aWxsIG1vc3RseSBmYWlsIHRvIGJvb3QuCj4+
Pj4+Cj4+Pj4+IHMvQTU1L0E1My8uIFRoZXJlIHdlcmUgdGhhbmtmdWxseSBubyBBNzIrQTU1IGV2
ZXIgcHJvZHVjZWQgKGp1c3QgdGhlCj4+Pj4+IHRob3VnaCBvZiBpdCBtYWtlcyBtZSBzaWNrKS4K
Pj4+Pj4KPj4+Pj4+Pj4+Cj4+Pj4+Pj4+PiBDdXJyZW50bHkgdGhlIHdvcmtpbmcgeG1sIGlzOgo+
Pj4+Pj4+Pj4KPj4+Pj4+Pj4+ICAgwqDCoMKgIDx2Y3B1IHBsYWNlbWVudD0nc3RhdGljJyBjcHVz
ZXQ9JzQtNSc+MjwvdmNwdT4KPj4+Pj4+Pj4+ICAgwqDCoMKgIDxjcHUgbW9kZT0naG9zdC1wYXNz
dGhyb3VnaCcgY2hlY2s9J25vbmUnLz4KPj4+Pj4+Pj4+Cj4+Pj4+Pj4+PiBCdXQgZXZlbiB3aXRo
IHZjcHVwaW4sIHBpbm5pbmcgZWFjaCB2Y3B1IHRvIGVhY2ggcGh5c2ljYWwgY29yZSwgVk0KPj4+
Pj4+Pj4+IHdpbGwKPj4+Pj4+Pj4+IG1vc3RseSBmYWlsIHRvIHN0YXJ0IHVwIGR1ZSB0byB2Y3B1
IGluaXRpYWxpemF0aW9uIGZhaWxlZCB3aXRoCj4+Pj4+Pj4+PiAtRUlOVkFMLgo+Pj4+Pgo+Pj4+
PiBEaXNjbGFpbWVyOiBJIGtub3cgbm90aGluZyBhYm91dCBsaWJ2aXJ0IChhbmQgbm8sIEkgZG9u
J3Qgd2FudCB0bwo+Pj4+PiBrbm93ISA7LSkuCj4+Pj4+Cj4+Pj4+IEhvd2V2ZXIsIGZvciB0aGlu
Z3MgdG8gYmUgcmVsaWFibGUsIHlvdSBuZWVkIHRvIHRhc2tzZXQgdGhlIHdob2xlIFFFTVUKPj4+
Pj4gcHJvY2VzcyB0byB0aGUgQ1BVIHR5cGUgeW91IGludGVuZCB0byB1c2UuCj4+Pj4KPj4+PiBZ
ZXAsIHRoYXQncyB3aGF0IEknbSBkb2luZy4KPj4+Pgo+Pj4+PiBUaGF0J3MgYmVjYXVzZSwgQUZB
SUNULAo+Pj4+PiBRRU1VIHdpbGwgc25hcHNob3QgdGhlIHN5c3RlbSByZWdpc3RlcnMgb3V0c2lk
ZSBvZiB0aGUgdmNwdSB0aHJlYWRzLAo+Pj4+PiBhbmQgYXR0ZW1wdCB0byB1c2UgdGhlIHJlc3Vs
dCB0byBjb25maWd1cmUgdGhlIGFjdHVhbCB2Y3B1IHRocmVhZHMuIElmCj4+Pj4+IHRoZXkgaGFw
cGVuIHRvIHJ1biBvbiBkaWZmZXJlbnQgQ1BVIHR5cGVzLCB0aGUgc3lzcmVncyB3aWxsIGRpZmZl
ciBpbgo+Pj4+PiBpbmNvbXBhdGlibGUgd2F5cyBhbmQgYW4gZXJyb3Igd2lsbCBiZSByZXR1cm5l
ZC4gVGhpcyBtYXkgb3IgbWF5IG5vdAo+Pj4+PiBiZSBhIGJ1ZywgSSBkb24ndCBrbm93IChJIHNl
ZSBpdCBhcyBhIGZlYXR1cmUpLgo+Pj4+Cj4+Pj4gVGhlbiB0aGlzIGJyaW5ncyBhbm90aGVyIHF1
ZXN0aW9uLgo+Pj4+Cj4+Pj4gSWYgd2UgY2FuIHBpbiBlYWNoIHZDUFUgdG8gZWFjaCBwaHlzaWNh
bCBjb3JlIChib3RoIGxpdHRsZSBhbmQgYmlnKSwKPj4+PiB0aGVuIGFzIGxvbmcgYXMgdGhlIHJl
Z2lzdGVycyBhcmUgcGVyLXZDUFUgYmFzZWQsIGl0IHNob3VsZCBiZSBhYmxlIHRvCj4+Pj4gcGFz
cyBib3RoIGJpZyBhbmQgbGl0dGxlIGNvcmVzIHRvIHRoZSBWTS4KPj4+Pgo+Pj4+IFllYWgsIEkg
dG90YWxseSB1bmRlcnN0YW5kIHRoaXMgc2NyZXcgdXAgdGhlIHNjaGVkdWxpbmcsIGJ1dCB0aGF0
J3MgYXQKPj4+PiBsZWFzdCB3aGF0IChzb21lIGluc2FuZSkgdXNlcnMgd2FudCAoanVzdCBsaWtl
IG1lKS4KPj4+Pgo+Pj4+Pgo+Pj4+PiBJZiB5b3UgYXJlIGFubm95ZWQgd2l0aCB0aGlzIGJlaGF2
aW91ciwgeW91IGNhbiBhbHdheXMgdXNlIGEgZGlmZmVyZW50Cj4+Pj4+IFZNTSB0aGF0IHdvbid0
IGNhcmUgYWJvdXQgc3VjaCBkaWZmZXJlbmNlIChjcm9zdm0gb3Iga3ZtdG9vbCwgdG8gbmFtZQo+
Pj4+PiBhIGZldykuCj4+Pj4KPj4+PiBTb3VuZHMgcHJldHR5IGludGVyZXN0aW5nLCBhIG5ldyB3
b3JsZCBidXQgd2l0aG91dCBsaWJ2aXJ0Li4uCj4+Pj4KPj4+Pj4gSG93ZXZlciwgdGhlIGd1ZXN0
IHdpbGwgYmUgYWJsZSB0byBvYnNlcnZlIHRoZSBtaWdyYXRpb24gZnJvbQo+Pj4+PiBvbmUgY3B1
IHR5cGUgdG8gYW5vdGhlci4gVGhpcyBtYXkgb3IgbWF5IG5vdCBhZmZlY3QgeW91ciBndWVzdCdz
Cj4+Pj4+IGJlaGF2aW91ci4KPj4+Pgo+Pj4+IE5vdCBzdXJlIGlmIGl0J3MgcG9zc2libGUgdG8g
cGluIGVhY2ggdkNQVSB0aHJlYWQgdG8gZWFjaCBjb3JlLCBidXQgbGV0Cj4+Pj4gbWUgdHJ5Lgo+
Pj4+Cj4+Pgo+Pj4gU3VyZSBpdCBpcywgZm9yIGluc3RhbmNlOgo+Pj4KPj4+IDxjcHV0dW5lPgo+
Pj4gICAgICAgPHZjcHVwaW4gdmNwdT0iMCIgY3B1c2V0PSIxLTQsXjIiLz4KPj4+ICAgICAgIDx2
Y3B1cGluIHZjcHU9IjEiIGNwdXNldD0iMCwxIi8+Cj4+PiAgICAgICA8dmNwdXBpbiB2Y3B1PSIy
IiBjcHVzZXQ9IjIsMyIvPgo+Pj4gICAgICAgPHZjcHVwaW4gdmNwdT0iMyIgY3B1c2V0PSIwLDQi
Lz4KPj4+ICAgICAgIDxlbXVsYXRvcnBpbiBjcHVzZXQ9IjEtMyIvPgo+Pj4gICAgICAgPGlvdGhy
ZWFkcGluIGlvdGhyZWFkPSIxIiBjcHVzZXQ9IjUsNiIvPgo+Pj4gICAgICAgPGlvdGhyZWFkcGlu
IGlvdGhyZWFkPSIyIiBjcHVzZXQ9IjcsOCIvPgo+Pj4gPC9jcHV0dW5lPgo+Pgo+PiBUaGF0J3Mg
d2hhdCBJIGhhdmUgYWxyZWFkeSB0cmllZCBiZWZvcmUuCj4+IEkgcGlubmVkIHZjcHUgMC02IHRv
IHBoeXNpY2FsIGNvcmUgMC02LCBhbmQgc3RpbGwgbm8gcmVsaWFibGUgYm9vdCB1cC4KPj4KPj4g
QW5kIHRoYXQncyB3aHkgSSdtIGFza2luZyBoZXJlLgo+Cj4gWW91IGFyZSBzdGlsbCBtaXNzaW5n
IHRoZSBwb2ludCBvZiBob3cgUUVNVSB3b3JrczoKPgo+IC0gUUVNVSBjcmVhdGVzIGEgZHVtbXkg
Vk0gd2l0aCBhIHNpbmdsZSB2Y3B1LiBUaGlzIGNhbiBoYXBwZW4gb24gKmFueSoKPiAgICBDUFUu
CgpUaGlzIGlzIHRoZSBtYWluIHBvaW50IHRoYXQgSSBtaXNzZWQuCgpUaGFua3MgdmVyeSBtdWNo
IGZvciBwb2ludCB0aGlzIG91dC4KCj4gLSBJdCBzbmFwc2hvdHMgdGhlIHN5c3JlZ3MgZm9yIHRo
aXMgdmNwdSwgYW5kIGtlZXAgdGhlbSBmb3IgbGF0ZXIKPiAtIEl0IHRoZW4gZGVzdHJveSB0aGlz
IFZNCj4gLSBRRU1VIHRoZW4gY3JlYXRlcyB0aGUgZnVsbCBWTSwgd2l0aCBhbGwgdGhlIHZjcHVz
Cj4gLSBFYWNoIHZjcHUgZ2V0cyBpbml0aWFsaXNlZCB3aXRoIHRoZSBzdGF0ZSBzYXZlZCBlYXJs
aWVyLiBJZiBhbnkgdmNwdQo+ICAgIGlzIGluaXRpYWxpc2VkIG9uIGEgcGh5c2ljYWwgQ1BVIG9m
IGEgZGlmZmVyZW50IHR5cGUgZnJvbSB0aGUgb25lCj4gICAgdGhhdCBoYXMgYmVlbiB1c2VkIGZv
ciB0aGUgZHVtbXkgVk0sIHlvdSBsb3NlLCBhcyB3ZSBjYW5ub3QgcmVzdG9yZQo+ICAgIHNvbWUg
b2YgdGhlIHJlZ2lzdGVycyBzdWNoIGFzIE1JRFJfRUwxIChhbmQgb3RoZXIgcmVnaXN0ZXJzIHRo
YXQgS1ZNCj4gICAgY29uc2lkZXJzIGFzIGludmFyaWFudCkuCj4KPiBUbyBmaXggdGhpcywgeW91
IG5lZWQgdG8gY2hhbmdlIFFFTVUncyBub3Rpb24gb2YgYSB0ZW1wbGF0ZSBWTSwgb3IKPiBjaGFu
Z2UgS1ZNJ3Mgbm90aW9uIG9mIGludmFyaWFudCByZWdpc3RlcnMuIFRoZSBmb3JtZXIgaXMgcXVp
dGUgaGFyZCwKPiBhbmQgdGhlIGxhdGVyIGJyZWFrcyBhIHRvbiBvZiB0aGluZ3MgZm9yIGd1ZXN0
cywgc3VjaCBhcyBlcnJhdGEKPiB3b3JrYXJvdW5kcy4KCj4gVGhlIGJlc3Qgd29ya2Fyb3VuZCBp
cyB0byB0YXNrc2V0IHRoZSBRRU1VIHByb2Nlc3MgKGFuZCBJIHJlYWxseSBtZWFuCj4gdGhlIHBy
b2Nlc3MsIG5vdCBpbmRpdmlkdWFsIHRocmVhZHMpIHRvIGFuIGhvbW9nZW5lb3VzIHNldCBvZiBD
UFVzIGFuZAo+IGJlIGRvbmUgd2l0aCBpdC4KClllYWgsIHRoYXQncyB3aHkgdGhlIGNwdXNldCB3
YXkgaXMgd29ya2luZywgYXMgaXQgc2VlbXMgYWxzbyBsaW1pdGluZwp0aGUgaW5pdGlhbCAidGVt
cG9yYXJ5IiBWTSBjcmVhdGluZyB0byBzcGVjaWZpZWQgQ1BVcy4KCkp1c3QgY3VyaW91cywgaXMg
dGhlcmUgc29tZSBkZWZpbmVkIGNvbW1vbiBWTSByZWxhdGVkIHJlZ2lzdGVycyB0aGF0IGNhbgpi
ZSByZXN0b3JlIG9uIGFsbCBjb3Jlcz8gKEF0IGxlYXN0IGZvciBBNTMgKyBBNzIgY2FzZSkuCgpJ
ZiBjb21wbGV0ZWx5IG5vLCB0aGVuIHZpcnR1YWxpemF0aW9uIGlzIHJlYWxseSBub3QgZXZlbiB0
YXJnZXRlZCBmb3IKQklHLmxpdHRsZSBkZXNpZ25zIEkgZ3Vlc3MuCgpUaGFua3MsClF1Cgo+Cj4g
CU0uCj4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
