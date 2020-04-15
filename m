Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4732FC2BA19
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 17:06:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EDE5820737
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 17:06:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2QYfucGH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDE5820737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A678D4B20A;
	Wed, 15 Apr 2020 13:06:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mrp8vCIgJ9dN; Wed, 15 Apr 2020 13:06:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0EA04B241;
	Wed, 15 Apr 2020 13:06:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54F574B0FE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 12:49:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5CzcKSNNM5vO for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 12:49:16 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E1F6D4B0F6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 12:49:15 -0400 (EDT)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com
 [209.85.166.51])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D583E20857
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 16:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586969354;
 bh=F9GmaurKbAsn0X4HPrA0BeOP+nd3evkoARWIjfwwJ94=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=2QYfucGH83QacyGRLcm5xQ5CPVMhF/U54RicpamklvDd0aE+Z6xkO9b+wSGsNI5SJ
 EID1rbhXnSGx0yQW/y+Kro5T/06cGmBO7HR8orKvwkdAorJyTvck96oGbJvEdDIZ2J
 Jc/IFNk4KSj8ubaMgJprOR67aY35EY4YeZmq0CtI=
Received: by mail-io1-f51.google.com with SMTP id f3so17872769ioj.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 09:49:14 -0700 (PDT)
X-Gm-Message-State: AGi0PuY5vKLOQRGAdgXdkeG39V1gbahWn5wSwXjm7P7kBQrTY+qS1Lbo
 /XcxlS2wgyGzgBwXVlQHtkq5gAth2RsUwnY0qPQ=
X-Google-Smtp-Source: APiQypJWGMRiNduUYPB9oJ7u8KNJwMs3LO6HUvUASLH07gImZaYwmVp66Og1pCmupdLk+f0b5w/3jrmg4Ku7V8LKgKI=
X-Received: by 2002:a5e:8b47:: with SMTP id z7mr26739930iom.16.1586969354138; 
 Wed, 15 Apr 2020 09:49:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200221165532.90618-1-andre.przywara@arm.com>
 <2d3bad43-10a5-3ee1-72e7-e1da1d6c65dd@arm.com>
 <CAMj1kXGUiCLvmJUwrxCc8aHdE30WWfa95ou-tEM8Kv0nj2GdDA@mail.gmail.com>
 <CAMj1kXF6iw47MM_tg5izB9KC-N2zrnQbhwT2TVPOuKdpOBX=ow@mail.gmail.com>
 <d9ae6d29-c2c5-6aa7-15b6-6549fc89c043@arm.com>
 <CAMj1kXHKOBbCKsgYOYuLU+vOALBUbNRysVfVRpKXkh00GvTtEA@mail.gmail.com>
 <32355204-30b1-4615-0d08-b484f0340e82@arm.com>
In-Reply-To: <32355204-30b1-4615-0d08-b484f0340e82@arm.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 15 Apr 2020 18:49:02 +0200
X-Gmail-Original-Message-ID: <CAMj1kXG5aE9AjpKG28Ftsta6hOrP3aHMMYLvmVNUkRYsSeBfGg@mail.gmail.com>
Message-ID: <CAMj1kXG5aE9AjpKG28Ftsta6hOrP3aHMMYLvmVNUkRYsSeBfGg@mail.gmail.com>
Subject: Re: [PATCH kvmtool v3] Add emulation for CFI compatible flash memory
To: =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
X-Mailman-Approved-At: Wed, 15 Apr 2020 13:06:31 -0400
Cc: kvm@vger.kernel.org, Raphael Gault <raphael.gault@arm.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, sami.mujawar@arm.com,
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

T24gV2VkLCAxNSBBcHIgMjAyMCBhdCAxODozNiwgQW5kcsOpIFByenl3YXJhIDxhbmRyZS5wcnp5
d2FyYUBhcm0uY29tPiB3cm90ZToKPgo+IE9uIDE1LzA0LzIwMjAgMTc6MjAsIEFyZCBCaWVzaGV1
dmVsIHdyb3RlOgo+ID4gT24gV2VkLCAxNSBBcHIgMjAyMCBhdCAxODoxMSwgQW5kcsOpIFByenl3
YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0uY29tPiB3cm90ZToKPiA+Pgo+ID4+IE9uIDE1LzA0LzIw
MjAgMTY6NTUsIEFyZCBCaWVzaGV1dmVsIHdyb3RlOgo+ID4+PiBPbiBXZWQsIDE1IEFwciAyMDIw
IGF0IDE3OjQzLCBBcmQgQmllc2hldXZlbCA8YXJkYkBrZXJuZWwub3JnPiB3cm90ZToKPiA+Pj4+
Cj4gPj4+PiBPbiBUdWUsIDcgQXByIDIwMjAgYXQgMTc6MTUsIEFsZXhhbmRydSBFbGlzZWkgPGFs
ZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4gd3JvdGU6Cj4gPj4+Pj4KPiA+Pj4+PiBIaSwKPiA+Pj4+
Pgo+ID4+Pj4+IEkndmUgdGVzdGVkIHRoaXMgcGF0Y2ggYnkgcnVubmluZyBiYWRibG9ja3MgYW5k
IGZpbyBvbiBhIGZsYXNoIGRldmljZSBpbnNpZGUgYQo+ID4+Pj4+IGd1ZXN0LCBldmVyeXRoaW5n
IHdvcmtlZCBhcyBleHBlY3RlZC4KPiA+Pj4+Pgo+ID4+Pj4+IEkndmUgYWxzbyBsb29rZWQgYXQg
dGhlIGZsb3djaGFydHMgZm9yIGRldmljZSBvcGVyYXRpb24gZnJvbSBJbnRlbCBBcHBsaWNhdGlv
bgo+ID4+Pj4+IE5vdGUgNjQ2LCBwYWdlcyAxMi0yMSwgYW5kIHRoZXkgc2VlbSBpbXBsZW1lbnRl
ZCBjb3JyZWN0bHkuCj4gPj4+Pj4KPiA+Pj4+PiBBIGZldyBtaW5vciBpc3N1ZXMgYmVsb3cuCj4g
Pj4+Pj4KPiA+Pj4+PiBPbiAyLzIxLzIwIDQ6NTUgUE0sIEFuZHJlIFByenl3YXJhIHdyb3RlOgo+
ID4+Pj4+PiBGcm9tOiBSYXBoYWVsIEdhdWx0IDxyYXBoYWVsLmdhdWx0QGFybS5jb20+Cj4gPj4+
Pj4+Cj4gPj4+Pj4+IFRoZSBFREsgSUkgVUVGSSBmaXJtd2FyZSBpbXBsZW1lbnRhdGlvbiByZXF1
aXJlcyBzb21lIHN0b3JhZ2UgZm9yIHRoZSBFRkkKPiA+Pj4+Pj4gdmFyaWFibGVzLCB3aGljaCBp
cyB0eXBpY2FsbHkgc29tZSBmbGFzaCBzdG9yYWdlLgo+ID4+Pj4+PiBTaW5jZSB0aGlzIGlzIGFs
cmVhZHkgc3VwcG9ydGVkIG9uIHRoZSBFREsgSUkgc2lkZSwgd2UgYWRkIGEgQ0ZJIGZsYXNoCj4g
Pj4+Pj4+IGVtdWxhdGlvbiB0byBrdm10b29sLgo+ID4+Pj4+PiBUaGlzIGlzIGJhY2tlZCBieSBh
IGZpbGUsIHNwZWNpZmllZCB2aWEgdGhlIC0tZmxhc2ggb3IgLUYgY29tbWFuZCBsaW5lCj4gPj4+
Pj4+IG9wdGlvbi4gQW55IGZsYXNoIHdyaXRlcyBkb25lIGJ5IHRoZSBndWVzdCB3aWxsIGltbWVk
aWF0ZWx5IGJlIHJlZmxlY3RlZAo+ID4+Pj4+PiBpbnRvIHRoaXMgZmlsZSAoa3ZtdG9vbCBtbWFw
J3MgdGhlIGZpbGUpLgo+ID4+Pj4+PiBUaGUgZmxhc2ggd2lsbCBiZSBsaW1pdGVkIHRvIHRoZSBu
ZWFyZXN0IHBvd2VyLW9mLTIgc2l6ZSwgc28gb25seSB0aGUKPiA+Pj4+Pj4gZmlyc3QgMiBNQiBv
ZiBhIDMgTUIgZmlsZSB3aWxsIGJlIHVzZWQuCj4gPj4+Pj4+Cj4gPj4+Pj4+IFRoaXMgaW1wbGVt
ZW50cyBhIENGSSBmbGFzaCB1c2luZyB0aGUgIkludGVsL1NoYXJwIGV4dGVuZGVkIGNvbW1hbmQK
PiA+Pj4+Pj4gc2V0IiwgYXMgc3BlY2lmaWVkIGluOgo+ID4+Pj4+PiAtIEpFREVDIEpFU0Q2OC4w
MQo+ID4+Pj4+PiAtIEpFREVDIEpFUDEzN0IKPiA+Pj4+Pj4gLSBJbnRlbCBBcHBsaWNhdGlvbiBO
b3RlIDY0Ngo+ID4+Pj4+PiBTb21lIGdhcHMgaW4gdGhvc2Ugc3BlY3MgaGF2ZSBiZWVuIGZpbGxl
ZCBieSBsb29raW5nIGF0IHJlYWwgZGV2aWNlcyBhbmQKPiA+Pj4+Pj4gb3RoZXIgaW1wbGVtZW50
YXRpb25zIChRRU1VLCBMaW51eCBrZXJuZWwgZHJpdmVyKS4KPiA+Pj4+Pj4KPiA+Pj4+Pj4gQXQg
dGhlIG1vbWVudCB0aGlzIHJlbGllcyBvbiBEVCB0byBhZHZlcnRpc2UgdGhlIGJhc2UgYWRkcmVz
cyBvZiB0aGUKPiA+Pj4+Pj4gZmxhc2ggbWVtb3J5IChtYXBwZWQgaW50byB0aGUgTU1JTyBhZGRy
ZXNzIHNwYWNlKSBhbmQgaXMgb25seSBlbmFibGVkCj4gPj4+Pj4+IGZvciBBUk0vQVJNNjQuIFRo
ZSBlbXVsYXRpb24gaXRzZWxmIGlzIGFyY2hpdGVjdHVyZSBhZ25vc3RpYywgdGhvdWdoLgo+ID4+
Pj4+Pgo+ID4+Pj4+PiBUaGlzIGlzIG9uZSBtaXNzaW5nIHBpZWNlIHRvd2FyZCBhIHdvcmtpbmcg
VUVGSSBib290IHdpdGgga3ZtdG9vbCBvbgo+ID4+Pj4+PiBBUk0gZ3Vlc3RzLCB0aGUgb3RoZXIg
aXMgdG8gcHJvdmlkZSB3cml0YWJsZSBQQ0kgQkFScywgd2hpY2ggaXMgV0lQLgo+ID4+Pj4+Pgo+
ID4+Pj4KPiA+Pj4+IEkgaGF2ZSBnaXZlbiB0aGlzIGEgc3BpbiB3aXRoIFVFRkkgYnVpbHQgZm9y
IGt2bXRvb2wsIGFuZCBpdCBhcHBlYXJzCj4gPj4+PiB0byBiZSB3b3JraW5nIGNvcnJlY3RseS4g
SG93ZXZlciwgSSBub3RpY2VkIHRoYXQgaXQgaXMgaW50b2xlcmFibHkKPiA+Pj4+IHNsb3csIHdo
aWNoIHNlZW1zIHRvIGJlIGNhdXNlZCBieSB0aGUgZmFjdCB0aGF0IGJvdGggYXJyYXkgbW9kZSBh
bmQKPiA+Pj4+IGNvbW1hbmQgbW9kZSAob3Igd2hhdGV2ZXIgaXQgaXMgY2FsbGVkIGluIHRoZSBD
Rkkgc3BlYykgYXJlIGZ1bGx5Cj4gPj4+PiBlbXVsYXRlZCwgd2hlcmVhcyBpbiB0aGUgUUVNVSBp
bXBsZW1lbnRhdGlvbiAoZm9yIGluc3RhbmNlKSwgdGhlCj4gPj4+PiByZWdpb24gaXMgYWN0dWFs
bHkgZXhwb3NlZCB0byB0aGUgZ3Vlc3QgdXNpbmcgYSByZWFkLW9ubHkgS1ZNIG1lbXNsb3QKPiA+
Pj4+IGluIGFycmF5IG1vZGUsIGFuZCBzbyB0aGUgcmVhZCBhY2Nlc3NlcyBhcmUgbWFkZSBuYXRp
dmVseS4KPiA+Pj4+Cj4gPj4+PiBJdCBpcyBhbHNvIGNhdXNpbmcgcHJvYmxlbXMgaW4gdGhlIFVF
RkkgaW1wbGVtZW50YXRpb24sIGFzIHdlIGNhbiBubwo+ID4+Pj4gbG9uZ2VyIHVzZSB1bmFsaWdu
ZWQgYWNjZXNzZXMgdG8gcmVhZCBmcm9tIHRoZSByZWdpb24sIHdoaWNoIGlzCj4gPj4+PiBzb21l
dGhpbmcgdGhlIGNvZGUgY3VycmVudGx5IHJlbGllcyBvbiAoYW5kIHdoaWNoIHdvcmtzIGZpbmUg
b24gYWN0dWFsCj4gPj4+PiBoYXJkd2FyZSBhcyBsb25nIGFzIHlvdSB1c2Ugbm9ybWFsIG5vbi1j
YWNoZWFibGUgbWFwcGluZ3MpCj4gPj4+Pgo+ID4+Pgo+ID4+PiBBY3R1YWxseSwgdGhlIGlzc3Vl
IGlzIG5vdCBhbGlnbm1lbnQuIFRoZSBpc3N1ZSBpcyB3aXRoIGluc3RydWN0aW9ucwo+ID4+PiB3
aXRoIG11bHRpcGxlIG91dHB1dHMsIHdoaWNoIG1lYW5zIHlvdSBjYW5ub3QgZG8gYW4gb3JkaW5h
cnkgbWVtY3B5KCkKPiA+Pj4gZnJvbSB0aGUgTk9SIHJlZ2lvbiB1c2luZyBsZHAgaW5zdHJ1Y3Rp
b25zLCBhbGlnbmVkIG9yIG5vdC4KPiA+Pgo+ID4+IFllcywgd2UgdHJhY2VkIHRoYXQgZG93biB0
byBhbiAibGRyYiB3aXRoIHBvc3QtaW5jIiwgaW4gdGhlIG1lbWNweSBjb2RlLgo+ID4+IE15IHN1
Z2dlc3Rpb24gd2FzIHRvIHByb3ZpZGUgYSB2ZXJzaW9uIG9mIG1lbWNweV97ZnJvbSx0b31faW8o
KSwgYXMKPiA+PiBMaW51eCBkb2VzLCB3aGljaCBvbmx5IHVzZXMgTU1JTyBhY2Nlc3NvcnMgdG8g
YXZvaWQgImZhbmN5IiBpbnN0cnVjdGlvbnMuCj4gPj4KPiA+Cj4gPiBUaGF0IGlzIHBvc3NpYmxl
LCBhbmQgdGhlIGltcGFjdCBvbiB0aGUgY29kZSBpcyBtYW5hZ2VhYmxlLCBnaXZlbiB0aGUKPiA+
IG1vZHVsYXIgbmF0dXJlIG9mIEVESzIuCj4gPgo+ID4+IEJhY2sgYXQgdGhpcyBwb2ludCBJIHdh
cyBjaGFsbGVuZ2luZyB0aGUgaWRlYSBvZiBhY2Nlc3NpbmcgYSBmbGFzaAo+ID4+IGRldmljZSB3
aXRoIGEgbm9ybWFsIG1lbW9yeSBtYXBwaW5nLCBiZWNhdXNlIG9mIGl0IGZhaWxpbmcgd2hlbiBi
ZWluZyBpbgo+ID4+IHNvbWUgcXVlcnkgbW9kZS4gRG8geW91IGtub3cgb2YgYW55IGJlc3QgcHJh
Y3RpY2VzIGZvciBmbGFzaCBtYXBwaW5ncz8KPiA+PiBBcmUgdHdvIG1hcHBpbmdzIGNvbW1vbj8K
PiA+Pgo+ID4KPiA+IEluIHRoZSBRRU1VIHBvcnQgb2YgRURLMiwgd2UgdXNlIG5vcm1hbCBub24t
Y2FjaGVhYmxlIGZvciB0aGUgZmlyc3QKPiA+IGZsYXNoIGRldmljZSwgd2hpY2ggY29udGFpbnMg
dGhlIGV4ZWN1dGFibGUgaW1hZ2UsIGFuZCBpcyBub3QKPiA+IHVwZGF0YWJsZSBieSB0aGUgZ3Vl
c3QuIFRoZSBzZWNvbmQgZmxhc2ggYmFuayBpcyB1c2VkIGZvciB0aGUgdmFyaWFibGUKPiA+IHN0
b3JlLCBhbmQgaXMgYWN0dWFsbHkgbWFwcGVkIGFzIGEgZGV2aWNlIGFsbCB0aGUgdGltZS4KPiA+
Cj4gPiBBbm90aGVyIHRoaW5nIEkganVzdCByZWFsaXplZCBpcyB0aGF0IHlvdSBjYW5ub3QgZmV0
Y2ggaW5zdHJ1Y3Rpb25zCj4gPiBmcm9tIGFuIGVtdWxhdGVkIGZsYXNoIGRldmljZSBlaXRoZXIs
IHNvIHRvIGV4ZWN1dGUgZnJvbSBOT1IgZmxhc2gsCj4gPiB5b3Ugd2lsbCBuZWVkIGEgdHJ1ZSBt
ZW1vcnkgbWFwcGluZyBhcyB3ZWxsLgo+Cj4gV2FpdCwgZGlkIHlvdSBwdXQgdGhlIHdob2xlIG9m
IEVESy0yIGltYWdlIGluIHRoZSBmbGFzaD8KCk5vLCBteSBwb2ludCBpcyB0aGF0IHlvdSBjYW5u
b3QgYWN0dWFsbHkgZG8gdGhhdCwgc2luY2UgSSBkb24ndCB0aGluawp5b3UgY2FuIGZldGNoIGlu
c3RydWN0aW9ucyB1c2luZyBNTUlPIGVtdWxhdGlvbi4KCj4gTXkgYXNzdW1wdGlvbgo+IChhbmQg
dGVzdGluZykgd2FzIHRvIHVzZQo+Cj4gJCBsa3ZtIHJ1biAtZiBLVk1UT09MX0VGSS5mZCAtLWZs
YXNoIGp1c3RfdGhlX3ZhcmlhYmxlcy5pbWcKPgo+IEhlbmNlIG15IGlnbm9yYW5jZSBhYm91dCBw
ZXJmb3JtYW5jZSwgYmVjYXVzZSBpdCB3b3VsZCBqdXN0IGJlIGEgZmV3Cj4gYnl0ZXMgd3JpdHRl
bi9yZWFkLiAtZiBsb2FkcyB0aGUgZmlybXdhcmUgaW1hZ2UgaW50byBndWVzdCBSQU0uCj4KCk5v
LCB0aGUgcGVyZm9ybWFuY2UgaW1wYWN0IGlzIGR1ZSB0byB0aGUgbnVtZXJvdXMgdmFyaWFibGUg
YWNjZXNzZXMKZG9uZSBieSBVRUZJIGR1cmluZyBib290LgoKPiA+IFNvIGluIHN1bW1hcnksIEkg
dGhpbmsgdGhlIG1vZGUgc3dpdGNoIGlzIG5lZWRlZCB0byBiZSBnZW5lcmFsbHkKPiA+IHVzZWZ1
bCwgZXZlbiBpZiB0aGUgY3VycmVudCBhcHByb2FjaCBpcyBzdWZmaWNpZW50IGZvciAoc2xvdykK
PiA+IHJlYWQvd3JpdGUgdXNpbmcgc3BlY2lhbCBtZW1vcnkgYWNjZXNzb3JzLgo+Cj4gV2VsbCxp
biBoaW5kc2lnaHQgSSByZWdyZXQgcHVyc3VpbmcgdGhpcyB3aG9sZSBmbGFzaCBlbXVsYXRpb24g
YXBwcm9hY2gKPiBpbiBrdm10b29sIGluIHRoZSBmaXJzdCBwbGFjZS4gSnVzdCBzb21lIG1hZ2lj
ICJ0aGlzIG1lbW9yeSByZWdpb24gaXMKPiBwZXJzaXN0ZW50IiAobW1hcHBpbmcgYSBmaWxlIGFu
ZCBwcmVzZW50aW5nIGFzIGEgbWVtc2xvdCkgd291bGQgYmUKPiAqbXVjaCogZWFzaWVyIG9uIHRo
ZSBrdm10b29sIHNpZGUuIEl0IGp1c3Qgc2VlbXMgdGhhdCB0aGVyZSB3YXNuJ3QgYW55Cj4gZ29v
ZCBEVCBiaW5kaW5nIG9yIGV4aXN0aW5nIGRldmljZSBjbGFzcyBmb3IgdGhpcyAodG8gbXkgc3Vy
cHJpc2UpLCBvcgo+IGF0IGxlYXN0IG5vdCBvbmUgd2l0aG91dCBpc3N1ZXMuIEFuZCB0aGVuIEVE
Sy0yIGhhZCB0aGlzIENGSSBmbGFzaAo+IHN1cHBvcnQgYWxyZWFkeSwgc28gd2UgZmlndXJlZCB0
aGlzIHNob3VsZCBiZSB0aGUgd2F5IHRvIGdvLiBXZSBqdXN0Cj4gbmVlZCBzb21lIGVtdWxhdGlv
biBjb2RlIC4uLiBtb250aHMgbGF0ZXIgLi4uCj4KPiBTbyBkbyB5b3Uga25vdyBvZiBzb21lIHBl
cnNpc3RlbnQgc3RvcmFnZSBkZXZpY2Ugd2UgY291bGQgdXNlPyBUaGlzCj4gd291bGQgY29tZSBh
dCB0aGUgY29zdCBvZiBhZGRpbmcgc3VwcG9ydCB0byBFREstMiwgYnV0IEkgZ3Vlc3MgaXQgc2hv
dWxkCj4gYmUgc3RyYWlnaHQtZm9yd2FyZCBnaXZlbiB0aGUgc2ltcGxlIHNlbWFudGljPwo+CgpJ
IHRoaW5rIGVtdWxhdGluZyBDRkkgaXMgc3RpbGwgdGhlIHJpZ2h0IGFwcHJvYWNoLCBzaW5jZSBp
dCBnaXZlcyB1cwpwYXJpdHkgd2l0aCBRRU1VIGFuZCBhY3R1YWwgaGFyZHdhcmUuIEFsdGVybmF0
aXZlbHksIHdlIGNvdWxkIGV4cGxvcmUKcGFyYXZpcnR1YWxpemF0aW9uIG9mIHRoZSBzZWN1cmUg
VUVGSSB2YXJpYWJsZSBzdG9yZSBpbXBsZW1lbnRhdGlvbgp1c2luZyB0aGUgc3RhbmRhbG9uZSBN
TSBzdGFjayAod2hpY2ggcnVucyBhdCBTLUVMMCBidXQgY291bGQgZWFzaWx5CnJ1biBhdCBOUy1F
TDAgYXMgd2VsbCkgYW5kIGFuIGltcGxlbWVudGF0aW9uIG9mIHRoZSBzZWN1cmUgcGFydGl0aW9u
Cm1hbmFnZXIgaW50ZXJmYWNlIGluc2lkZSBrdm10b29sLiBUaGlzIHdvdWxkIGFjdHVhbGx5IGdp
dmUgdXMgYW4KaW1wbGVtZW50YXRpb24gb2YgVUVGSSBzZWN1cmUgYm9vdCB0aGF0IGFjdHVhbGx5
IG1ha2VzIHNlbnNlLCBzaW5jZQp0aGUgZ3Vlc3Qgd291bGQgbm90IGJlIGFibGUgdG8gbWFuaXB1
bGF0ZSB0aGUgYmFja2luZyBzdG9yZSBkaXJlY3RseS4KCkJ1dCB0aGlzIGlzIGEgd2hvbGUgb3Ro
ZXIgcHJvamVjdCAuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
