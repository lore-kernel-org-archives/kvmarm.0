Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0309FC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 10:37:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F9654B1B0;
	Tue, 14 Dec 2021 05:37:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aqer5FQee0cn; Tue, 14 Dec 2021 05:36:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D98684B1A4;
	Tue, 14 Dec 2021 05:36:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42FFB4B154
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 05:36:59 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id riqEIzcBvOMy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 05:36:57 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 605934B177
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 05:36:57 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639478217;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wF3Dfovht0gcvlQHQh+k1gcJTa+cZdxa9d/vX4cT0Hc=;
 b=GOooySdz/0eUIX1VPakLF4e4ViNlVImb21Xa1cH1T+Rovzw5no/TXWhbwQtLBXm8TV7p9z
 EoIVxVpR+P3Lp8BtWzkrFa2PIDLOBaOAo99qnbQ9voGwY+3VB2xUmxYEe15mWGU6F3cCXS
 IEUBq8Gh5uUAAu9U/Z2mDHE1OLeIwKU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-BRLCGMnmNE2q1fEXfieHpQ-1; Tue, 14 Dec 2021 05:36:53 -0500
X-MC-Unique: BRLCGMnmNE2q1fEXfieHpQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com
 [10.5.11.22])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 630101023F79;
 Tue, 14 Dec 2021 10:36:52 +0000 (UTC)
Received: from redhat.com (unknown [10.39.194.122])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 242A61007607;
 Tue, 14 Dec 2021 10:36:42 +0000 (UTC)
Date: Tue, 14 Dec 2021 10:36:40 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: Libvirt on little.BIG ARM systems unable to start guest if no
 cpuset is provided
Message-ID: <YbhzuKQLByleh3T8@redhat.com>
References: <70a2f7d6-5ac1-72df-4a88-b1a662d07070@gmx.com>
 <32bb61a9-0938-d254-0453-18a108bc4b63@redhat.com>
 <1dc0403b-c61b-b04b-e7fd-f2d66276ba7b@gmx.com>
 <CAFEAcA-URrpy3w3AtDb8zVfq8fWxvQ8_jtSqEkaeb=3KE99oAQ@mail.gmail.com>
 <87lf0ojvq2.wl-maz@kernel.org>
 <aa407ba2-e9c4-882e-a085-91e7dd724f78@gmx.com>
 <87fsqvjzs5.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <87fsqvjzs5.wl-maz@kernel.org>
User-Agent: Mutt/2.1.3 (2021-09-10)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=berrange@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Michal =?utf-8?B?UHLDrXZvem7DrWs=?= <mprivozn@redhat.com>,
 Qu Wenruo <quwenruo.btrfs@gmx.com>, qemu-discuss@nongnu.org,
 libvirt-users@redhat.com, qemu-arm@nongnu.org,
 kvmarm <kvmarm@lists.cs.columbia.edu>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
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

T24gVHVlLCBEZWMgMTQsIDIwMjEgYXQgMDk6MzQ6MThBTSArMDAwMCwgTWFyYyBaeW5naWVyIHdy
b3RlOgo+IE9uIFR1ZSwgMTQgRGVjIDIwMjEgMDA6NDE6MDEgKzAwMDAsCj4gUXUgV2VucnVvIDxx
dXdlbnJ1by5idHJmc0BnbXguY29tPiB3cm90ZToKPiA+IAo+ID4gCj4gPiAKPiA+IE9uIDIwMjEv
MTIvMTQgMDA6NDksIE1hcmMgWnluZ2llciB3cm90ZToKPiA+ID4gT24gTW9uLCAxMyBEZWMgMjAy
MSAxNjowNjoxNCArMDAwMCwKPiA+ID4gUGV0ZXIgTWF5ZGVsbCA8cGV0ZXIubWF5ZGVsbEBsaW5h
cm8ub3JnPiB3cm90ZToKPiA+ID4+IAo+ID4gPj4gS1ZNIG9uIGJpZy5saXR0bGUgc2V0dXBzIGlz
IGEga2VybmVsLWxldmVsIHF1ZXN0aW9uIHJlYWxseTsgSSd2ZQo+ID4gPj4gY2MnZCB0aGUga3Zt
YXJtIGxpc3QuCj4gPiA+IAo+ID4gPiBUaGFua3MgUGV0ZXIgZm9yIHRocm93aW5nIHVzIHVuZGVy
IHRoZSBiaWctbGl0dGxlIGJ1cyEgOy0pCj4gPiA+IAo+ID4gPj4gCj4gPiA+PiBPbiBNb24sIDEz
IERlYyAyMDIxIGF0IDE1OjAyLCBRdSBXZW5ydW8gPHF1d2VucnVvLmJ0cmZzQGdteC5jb20+IHdy
b3RlOgo+ID4gPj4+IAo+ID4gPj4+IAo+ID4gPj4+IAo+ID4gPj4+IE9uIDIwMjEvMTIvMTMgMjE6
MTcsIE1pY2hhbCBQcsOtdm96bsOtayB3cm90ZToKPiA+ID4+Pj4gT24gMTIvMTEvMjEgMDI6NTgs
IFF1IFdlbnJ1byB3cm90ZToKPiA+ID4+Pj4+IEhpLAo+ID4gPj4+Pj4gCj4gPiA+Pj4+PiBSZWNl
bnRseSBJIGdvdCBteSBsaWJ2aXJ0IHNldHVwIG9uIGJvdGggUkszMzk5IChSb2NrUHJvNjQpIGFu
ZCBSUEkgQ000LAo+ID4gPj4+Pj4gd2l0aCB1cHN0cmVhbSBrZXJuZWxzLgo+ID4gPj4+Pj4gCj4g
PiA+Pj4+PiBGb3IgUlBJIENNNCBpdHMgbW9zdGx5IHNtb290aCBzYWlsLCBidXQgb24gUkszMzk5
IGR1ZSB0byBpdHMgbGl0dGxlLkJJRwo+ID4gPj4+Pj4gc2V0dXAgKGNvcmUgMC0zIGFyZSA0eCBB
NTUgY29yZXMsIGFuZCBjb3JlIDQtNSBhcmUgMnggQTcyIGNvcmVzKSwgaXQKPiA+ID4+Pj4+IGJy
aW5ncyBxdWl0ZSBzb21lIHRyb3VibGVzIGZvciBWTXMuCj4gPiA+Pj4+PiAKPiA+ID4+Pj4+IElu
IHNob3J0LCB3aXRob3V0IHByb3BlciBjcHVzZXQgdG8gYmluZCB0aGUgVk0gdG8gZWl0aGVyIGFs
bCBBNzIgY29yZXMKPiA+ID4+Pj4+IG9yIGFsbCBBNTUgY29yZXMsIHRoZSBWTSB3aWxsIG1vc3Rs
eSBmYWlsIHRvIGJvb3QuCj4gPiA+IAo+ID4gPiBzL0E1NS9BNTMvLiBUaGVyZSB3ZXJlIHRoYW5r
ZnVsbHkgbm8gQTcyK0E1NSBldmVyIHByb2R1Y2VkIChqdXN0IHRoZQo+ID4gPiB0aG91Z2ggb2Yg
aXQgbWFrZXMgbWUgc2ljaykuCj4gPiA+IAo+ID4gPj4+Pj4gCj4gPiA+Pj4+PiBDdXJyZW50bHkg
dGhlIHdvcmtpbmcgeG1sIGlzOgo+ID4gPj4+Pj4gCj4gPiA+Pj4+PiAgICAgPHZjcHUgcGxhY2Vt
ZW50PSdzdGF0aWMnIGNwdXNldD0nNC01Jz4yPC92Y3B1Pgo+ID4gPj4+Pj4gICAgIDxjcHUgbW9k
ZT0naG9zdC1wYXNzdGhyb3VnaCcgY2hlY2s9J25vbmUnLz4KPiA+ID4+Pj4+IAo+ID4gPj4+Pj4g
QnV0IGV2ZW4gd2l0aCB2Y3B1cGluLCBwaW5uaW5nIGVhY2ggdmNwdSB0byBlYWNoIHBoeXNpY2Fs
IGNvcmUsIFZNIHdpbGwKPiA+ID4+Pj4+IG1vc3RseSBmYWlsIHRvIHN0YXJ0IHVwIGR1ZSB0byB2
Y3B1IGluaXRpYWxpemF0aW9uIGZhaWxlZCB3aXRoIC1FSU5WQUwuCj4gPiA+IAo+ID4gPiBEaXNj
bGFpbWVyOiBJIGtub3cgbm90aGluZyBhYm91dCBsaWJ2aXJ0IChhbmQgbm8sIEkgZG9uJ3Qgd2Fu
dCB0bwo+ID4gPiBrbm93ISA7LSkuCj4gPiA+IAo+ID4gPiBIb3dldmVyLCBmb3IgdGhpbmdzIHRv
IGJlIHJlbGlhYmxlLCB5b3UgbmVlZCB0byB0YXNrc2V0IHRoZSB3aG9sZSBRRU1VCj4gPiA+IHBy
b2Nlc3MgdG8gdGhlIENQVSB0eXBlIHlvdSBpbnRlbmQgdG8gdXNlLgo+ID4gCj4gPiBZZXAsIHRo
YXQncyB3aGF0IEknbSBkb2luZy4KPiAKPiBBcmUgeW91IHN1cmU/IFRoZSB4bWwgZGlyZWN0aXZl
IGFib3ZlIHNlZW0gdG8gb25seSBhcHBseSB0byB0aGUgdmNwdXMsCj4gYW5kIG5vIG90aGVyIFFF
TVUgdGhyZWFkLgoKRm9yIGhpc3RvcmljYWwgcmVhc29ucyB0aGlzIFhNTCBlbGVtZW50IGlzIGEg
Yml0IG1pc2xlYWRpbmdseSBuYW1lZC4KCldpdGggdGhlIGNvbmZpZwoKICAgPHZjcHUgcGxhY2Vt
ZW50PSdzdGF0aWMnIGNwdXNldD0nNC01Jz4yPC92Y3B1PgoKdGhlICdjcHVzZXQnIGFwcGxpZXMg
dG8gdGhlIFFFTVUgcHJvY2VzcyBhcyBhIHdob2xlIC0gaXRzIHZDUFVzLApJL08gdGhyZWFkcyBh
bmQgYW55IG90aGVyIGVtdWxhdG9yIHRocmVhZHMuCgpUaGVyZSBpcyBhIHNlcGFyYXRlIGNvbmZp
ZyBmb3Igc2V0dGluZyBwZXItVkNQVSBiaW5kaW5nIHdoaWNoIHdhcwppbGx1c3RyYXRlZCBlbHNl
d2hlcmUgaW4gdGhpcyB0aHJlYWQuCgpSZWdhcmRzLApEYW5pZWwKLS0gCnw6IGh0dHBzOi8vYmVy
cmFuZ2UuY29tICAgICAgLW8tICAgIGh0dHBzOi8vd3d3LmZsaWNrci5jb20vcGhvdG9zL2RiZXJy
YW5nZSA6fAp8OiBodHRwczovL2xpYnZpcnQub3JnICAgICAgICAgLW8tICAgICAgICAgICAgaHR0
cHM6Ly9mc3RvcDEzOC5iZXJyYW5nZS5jb20gOnwKfDogaHR0cHM6Ly9lbnRhbmdsZS1waG90by5v
cmcgICAgLW8tICAgIGh0dHBzOi8vd3d3Lmluc3RhZ3JhbS5jb20vZGJlcnJhbmdlIDp8CgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
