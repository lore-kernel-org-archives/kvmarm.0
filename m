Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6412CC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 14 Dec 2021 11:05:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD2934B11E;
	Tue, 14 Dec 2021 06:05:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D3o86D2gqe+m; Tue, 14 Dec 2021 06:05:39 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 93E994B1FA;
	Tue, 14 Dec 2021 06:05:39 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98DDA4B11E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 06:05:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G-2qsjxjoH8w for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Dec 2021 06:05:36 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DBEE4B10A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Dec 2021 06:05:36 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639479936;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=p/WREcM0SvRtkUuJZM05/oyj5S+0OHpsIu7XRvLVKgY=;
 b=F7H2518PJ+yMYvQBx+IuB04wGljxXaNynI4m6g/9r8FF4XnvMXqIm7TKcL5yHhZ3SPADDU
 LadrDAl4tIOiWk8hEdQmevPprhkth/qhkwZM7/jY7kT2foGJ9BxSpY8Kmo7R0AQ+CwHAQd
 02JzXiTyvkYCbZNu/oMgKlF6tP1ZhJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-6JESUqWwM-6bLiXMtpKYKw-1; Tue, 14 Dec 2021 06:05:33 -0500
X-MC-Unique: 6JESUqWwM-6bLiXMtpKYKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEC42801AAB;
 Tue, 14 Dec 2021 11:05:31 +0000 (UTC)
Received: from redhat.com (unknown [10.39.194.122])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B071B1972E;
 Tue, 14 Dec 2021 11:05:17 +0000 (UTC)
Date: Tue, 14 Dec 2021 11:05:15 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: Libvirt on little.BIG ARM systems unable to start guest if no
 cpuset is provided
Message-ID: <Ybh6a7/I1RXlJmHI@redhat.com>
References: <70a2f7d6-5ac1-72df-4a88-b1a662d07070@gmx.com>
 <32bb61a9-0938-d254-0453-18a108bc4b63@redhat.com>
 <1dc0403b-c61b-b04b-e7fd-f2d66276ba7b@gmx.com>
 <CAFEAcA-URrpy3w3AtDb8zVfq8fWxvQ8_jtSqEkaeb=3KE99oAQ@mail.gmail.com>
 <87lf0ojvq2.wl-maz@kernel.org>
 <aa407ba2-e9c4-882e-a085-91e7dd724f78@gmx.com>
 <87fsqvjzs5.wl-maz@kernel.org> <YbhzuKQLByleh3T8@redhat.com>
 <8693375e-6f29-16f4-4fa4-2fd79a00ebd0@gmx.com>
MIME-Version: 1.0
In-Reply-To: <8693375e-6f29-16f4-4fa4-2fd79a00ebd0@gmx.com>
User-Agent: Mutt/2.1.3 (2021-09-10)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=berrange@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Michal =?utf-8?B?UHLDrXZvem7DrWs=?= <mprivozn@redhat.com>,
 qemu-discuss@nongnu.org, libvirt-users@redhat.com, qemu-arm@nongnu.org,
 Marc Zyngier <maz@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

T24gVHVlLCBEZWMgMTQsIDIwMjEgYXQgMDY6NTk6MTJQTSArMDgwMCwgUXUgV2VucnVvIHdyb3Rl
Ogo+IAo+IAo+IE9uIDIwMjEvMTIvMTQgMTg6MzYsIERhbmllbCBQLiBCZXJyYW5nw6kgd3JvdGU6
Cj4gPiBPbiBUdWUsIERlYyAxNCwgMjAyMSBhdCAwOTozNDoxOEFNICswMDAwLCBNYXJjIFp5bmdp
ZXIgd3JvdGU6Cj4gPiA+IE9uIFR1ZSwgMTQgRGVjIDIwMjEgMDA6NDE6MDEgKzAwMDAsCj4gPiA+
IFF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT4gd3JvdGU6Cj4gPiA+ID4gCj4gPiA+
ID4gCj4gPiA+ID4gCj4gPiA+ID4gT24gMjAyMS8xMi8xNCAwMDo0OSwgTWFyYyBaeW5naWVyIHdy
b3RlOgo+ID4gPiA+ID4gT24gTW9uLCAxMyBEZWMgMjAyMSAxNjowNjoxNCArMDAwMCwKPiA+ID4g
PiA+IFBldGVyIE1heWRlbGwgPHBldGVyLm1heWRlbGxAbGluYXJvLm9yZz4gd3JvdGU6Cj4gPiA+
ID4gPiA+IAo+ID4gPiA+ID4gPiBLVk0gb24gYmlnLmxpdHRsZSBzZXR1cHMgaXMgYSBrZXJuZWwt
bGV2ZWwgcXVlc3Rpb24gcmVhbGx5OyBJJ3ZlCj4gPiA+ID4gPiA+IGNjJ2QgdGhlIGt2bWFybSBs
aXN0Lgo+ID4gPiA+ID4gCj4gPiA+ID4gPiBUaGFua3MgUGV0ZXIgZm9yIHRocm93aW5nIHVzIHVu
ZGVyIHRoZSBiaWctbGl0dGxlIGJ1cyEgOy0pCj4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gCj4gPiA+
ID4gPiA+IE9uIE1vbiwgMTMgRGVjIDIwMjEgYXQgMTU6MDIsIFF1IFdlbnJ1byA8cXV3ZW5ydW8u
YnRyZnNAZ214LmNvbT4gd3JvdGU6Cj4gPiA+ID4gPiA+ID4gCj4gPiA+ID4gPiA+ID4gCj4gPiA+
ID4gPiA+ID4gCj4gPiA+ID4gPiA+ID4gT24gMjAyMS8xMi8xMyAyMToxNywgTWljaGFsIFByw612
b3puw61rIHdyb3RlOgo+ID4gPiA+ID4gPiA+ID4gT24gMTIvMTEvMjEgMDI6NTgsIFF1IFdlbnJ1
byB3cm90ZToKPiA+ID4gPiA+ID4gPiA+ID4gSGksCj4gPiA+ID4gPiA+ID4gPiA+IAo+ID4gPiA+
ID4gPiA+ID4gPiBSZWNlbnRseSBJIGdvdCBteSBsaWJ2aXJ0IHNldHVwIG9uIGJvdGggUkszMzk5
IChSb2NrUHJvNjQpIGFuZCBSUEkgQ000LAo+ID4gPiA+ID4gPiA+ID4gPiB3aXRoIHVwc3RyZWFt
IGtlcm5lbHMuCj4gPiA+ID4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiA+ID4gPiBGb3IgUlBJIENN
NCBpdHMgbW9zdGx5IHNtb290aCBzYWlsLCBidXQgb24gUkszMzk5IGR1ZSB0byBpdHMgbGl0dGxl
LkJJRwo+ID4gPiA+ID4gPiA+ID4gPiBzZXR1cCAoY29yZSAwLTMgYXJlIDR4IEE1NSBjb3Jlcywg
YW5kIGNvcmUgNC01IGFyZSAyeCBBNzIgY29yZXMpLCBpdAo+ID4gPiA+ID4gPiA+ID4gPiBicmlu
Z3MgcXVpdGUgc29tZSB0cm91YmxlcyBmb3IgVk1zLgo+ID4gPiA+ID4gPiA+ID4gPiAKPiA+ID4g
PiA+ID4gPiA+ID4gSW4gc2hvcnQsIHdpdGhvdXQgcHJvcGVyIGNwdXNldCB0byBiaW5kIHRoZSBW
TSB0byBlaXRoZXIgYWxsIEE3MiBjb3Jlcwo+ID4gPiA+ID4gPiA+ID4gPiBvciBhbGwgQTU1IGNv
cmVzLCB0aGUgVk0gd2lsbCBtb3N0bHkgZmFpbCB0byBib290Lgo+ID4gPiA+ID4gCj4gPiA+ID4g
PiBzL0E1NS9BNTMvLiBUaGVyZSB3ZXJlIHRoYW5rZnVsbHkgbm8gQTcyK0E1NSBldmVyIHByb2R1
Y2VkIChqdXN0IHRoZQo+ID4gPiA+ID4gdGhvdWdoIG9mIGl0IG1ha2VzIG1lIHNpY2spLgo+ID4g
PiA+ID4gCj4gPiA+ID4gPiA+ID4gPiA+IAo+ID4gPiA+ID4gPiA+ID4gPiBDdXJyZW50bHkgdGhl
IHdvcmtpbmcgeG1sIGlzOgo+ID4gPiA+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gPiA+ID4gICAg
ICA8dmNwdSBwbGFjZW1lbnQ9J3N0YXRpYycgY3B1c2V0PSc0LTUnPjI8L3ZjcHU+Cj4gPiA+ID4g
PiA+ID4gPiA+ICAgICAgPGNwdSBtb2RlPSdob3N0LXBhc3N0aHJvdWdoJyBjaGVjaz0nbm9uZScv
Pgo+ID4gPiA+ID4gPiA+ID4gPiAKPiA+ID4gPiA+ID4gPiA+ID4gQnV0IGV2ZW4gd2l0aCB2Y3B1
cGluLCBwaW5uaW5nIGVhY2ggdmNwdSB0byBlYWNoIHBoeXNpY2FsIGNvcmUsIFZNIHdpbGwKPiA+
ID4gPiA+ID4gPiA+ID4gbW9zdGx5IGZhaWwgdG8gc3RhcnQgdXAgZHVlIHRvIHZjcHUgaW5pdGlh
bGl6YXRpb24gZmFpbGVkIHdpdGggLUVJTlZBTC4KPiA+ID4gPiA+IAo+ID4gPiA+ID4gRGlzY2xh
aW1lcjogSSBrbm93IG5vdGhpbmcgYWJvdXQgbGlidmlydCAoYW5kIG5vLCBJIGRvbid0IHdhbnQg
dG8KPiA+ID4gPiA+IGtub3chIDstKS4KPiA+ID4gPiA+IAo+ID4gPiA+ID4gSG93ZXZlciwgZm9y
IHRoaW5ncyB0byBiZSByZWxpYWJsZSwgeW91IG5lZWQgdG8gdGFza3NldCB0aGUgd2hvbGUgUUVN
VQo+ID4gPiA+ID4gcHJvY2VzcyB0byB0aGUgQ1BVIHR5cGUgeW91IGludGVuZCB0byB1c2UuCj4g
PiA+ID4gCj4gPiA+ID4gWWVwLCB0aGF0J3Mgd2hhdCBJJ20gZG9pbmcuCj4gPiA+IAo+ID4gPiBB
cmUgeW91IHN1cmU/IFRoZSB4bWwgZGlyZWN0aXZlIGFib3ZlIHNlZW0gdG8gb25seSBhcHBseSB0
byB0aGUgdmNwdXMsCj4gPiA+IGFuZCBubyBvdGhlciBRRU1VIHRocmVhZC4KPiA+IAo+ID4gRm9y
IGhpc3RvcmljYWwgcmVhc29ucyB0aGlzIFhNTCBlbGVtZW50IGlzIGEgYml0IG1pc2xlYWRpbmds
eSBuYW1lZC4KPiA+IAo+ID4gV2l0aCB0aGUgY29uZmlnCj4gPiAKPiA+ICAgICA8dmNwdSBwbGFj
ZW1lbnQ9J3N0YXRpYycgY3B1c2V0PSc0LTUnPjI8L3ZjcHU+Cj4gPiAKPiA+IHRoZSAnY3B1c2V0
JyBhcHBsaWVzIHRvIHRoZSBRRU1VIHByb2Nlc3MgYXMgYSB3aG9sZSAtIGl0cyB2Q1BVcywKPiA+
IEkvTyB0aHJlYWRzIGFuZCBhbnkgb3RoZXIgZW11bGF0b3IgdGhyZWFkcy4KPiA+IAo+ID4gVGhl
cmUgaXMgYSBzZXBhcmF0ZSBjb25maWcgZm9yIHNldHRpbmcgcGVyLVZDUFUgYmluZGluZyB3aGlj
aCB3YXMKPiA+IGlsbHVzdHJhdGVkIGVsc2V3aGVyZSBpbiB0aGlzIHRocmVhZC4KPiAKPiBXaGlj
aCBhbHNvIG1lYW5zLCBJIGNhbiBwdXQgdGhlIGlvIHRocmVhZHMgdG8gQTUzIGNvcmVzIGZyZWVp
bmcgdXAgdGhlCj4gQTcyIGNvcmVzIG1vcmUuCj4gCj4gQW5kIGlzIHRoZXJlIGFueSBwbGFuIHRv
IGRlcHJlY2F0ZSB0aGUgb2xkICJjcHVzZXQiIGtleSBvZiB2Y3B1IGVsZW1lbnQsCj4gYW5kIHJl
Y29tbWVuZCB0byB1c2UgInZjcHVwaW4iIGVsZW1lbnQ/CgpObywgdGhleSdyZSBjb21wbGVtZW50
YXJ5IGFzIHRoZXkncmUgb3BlcmF0aW5nIGF0IGRpZmZlcmVudCBsZXZlbHMKYW5kIG5vdCBldmVy
eSBzY2VuYXJpbyBuZWVkcyB0aGlzIGZpbmUgZ3JhaW5lZCBsZXZlbC4KSW4gZmFjdCBpZiB5b3Ug
anVzdCB1c2UgJ3ZjcHVwaW4nIGFuZCBkb24ndCBwcm92aWRlICdjcHVzZXQnLCB0aGVuCmludGVy
bmFsbHkgdHJlYXRzIGl0IGFzIGlmICdjcHVzZXQnIHdhcyB0aGUgdW5pb24gb2YgYWxsICd2Y3B1
cGluJwpiaXRzZXRzLgoKUmVnYXJkcywKRGFuaWVsCi0tIAp8OiBodHRwczovL2JlcnJhbmdlLmNv
bSAgICAgIC1vLSAgICBodHRwczovL3d3dy5mbGlja3IuY29tL3Bob3Rvcy9kYmVycmFuZ2UgOnwK
fDogaHR0cHM6Ly9saWJ2aXJ0Lm9yZyAgICAgICAgIC1vLSAgICAgICAgICAgIGh0dHBzOi8vZnN0
b3AxMzguYmVycmFuZ2UuY29tIDp8Cnw6IGh0dHBzOi8vZW50YW5nbGUtcGhvdG8ub3JnICAgIC1v
LSAgICBodHRwczovL3d3dy5pbnN0YWdyYW0uY29tL2RiZXJyYW5nZSA6fAoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdApr
dm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1
L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
