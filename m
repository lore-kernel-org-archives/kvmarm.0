Return-Path: <SRS0=EEll=33=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F630C2BA83
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:25:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D1FB421775
	for <kvmarm@archiver.kernel.org>; Fri,  7 Feb 2020 16:25:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lvn87mwA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D1FB421775
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84D754A5C3;
	Fri,  7 Feb 2020 11:25:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ai5gygzpGxxH; Fri,  7 Feb 2020 11:25:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C40C4A541;
	Fri,  7 Feb 2020 11:25:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 873074A418
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:25:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Nacvf43d8gba for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Feb 2020 11:25:40 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 28E364A389
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Feb 2020 11:25:40 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id F1DD720720;
 Fri,  7 Feb 2020 16:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581092739;
 bh=dxItuX/MNTUp6xJbcDfCUpdL0low5rzKYrUjnrd6wsA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=Lvn87mwAKYbtOHpVVZV+YpOuzhgWjtpfnUl9KvehyroTl8nYi41besgKe0gXZbmpC
 1p66gQ7h+1nMkurSSG0TJEZNXL+teKng2Ek82V+YEHYTymtJW8XK/jpp6zAYQThCon
 5pV9CuQF0UAXduZ63tImO8Uc/k7OO8R59Phlq0kY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j06Rl-003ZVe-8p; Fri, 07 Feb 2020 16:25:37 +0000
MIME-Version: 1.0
Date: Fri, 07 Feb 2020 16:25:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: Peter Xu <peterx@redhat.com>
Subject: Re: BUG: using __this_cpu_read() in preemptible [00000000] code
In-Reply-To: <20200207161845.GB707371@xz-x1>
References: <318984f6-bc36-33a3-abc6-bf2295974b06@huawei.com>
 <828d3b538b7258f692f782b6798277cf@kernel.org>
 <3e90c020-e7f3-61f1-3731-a489df0b1d9c@huawei.com>
 <f2fd3b371fda9167a02a7312cda5d217@kernel.org>
 <20200207161845.GB707371@xz-x1>
Message-ID: <5a132e2ca9918b1b2c3d2f146ab44311@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: peterx@redhat.com, yuzenghui@huawei.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

T24gMjAyMC0wMi0wNyAxNjoxOCwgUGV0ZXIgWHUgd3JvdGU6Cj4gT24gRnJpLCBGZWIgMDcsIDIw
MjAgYXQgMTA6MjU6MjNBTSArMDAwMCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBPbiAyMDIwLTAy
LTA3IDEwOjE5LCBaZW5naHVpIFl1IHdyb3RlOgo+PiA+IEhpIE1hcmMsCj4+ID4KPj4gPiBPbiAy
MDIwLzIvNyAxNzoxOSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiA+ID4gSGkgWmVuZ2h1aSwKPj4g
PiA+Cj4+ID4gPiBPbiAyMDIwLTAyLTA3IDA5OjAwLCBaZW5naHVpIFl1IHdyb3RlOgo+PiA+ID4g
PiBIaSwKPj4gPiA+ID4KPj4gPiA+ID4gUnVubmluZyBhIGxhdGVzdCBwcmVlbXB0aWJsZSBrZXJu
ZWwgYW5kIHNvbWUgZ3Vlc3RzIG9uIGl0LAo+PiA+ID4gPiBJIGdvdCB0aGUgZm9sbG93aW5nIG1l
c3NhZ2UsCj4+ID4gPiA+Cj4+ID4gPiA+IC0tLTg8LS0tCj4+ID4gPiA+Cj4+ID4gPiA+IFvCoCA2
MzAuMDMxODcwXSBCVUc6IHVzaW5nIF9fdGhpc19jcHVfcmVhZCgpIGluIHByZWVtcHRpYmxlIFsw
MDAwMDAwMF0KPj4gPiA+ID4gY29kZTogcWVtdS1zeXN0ZW0tYWFyLzM3MjcwCj4+ID4gPiA+IFvC
oCA2MzAuMDMxODcyXSBjYWxsZXIgaXMga3ZtX2dldF9ydW5uaW5nX3ZjcHUrMHgxYy8weDM4Cj4+
ID4gPiA+IFvCoCA2MzAuMDMxODc0XSBDUFU6IDMyIFBJRDogMzcyNzAgQ29tbTogcWVtdS1zeXN0
ZW0tYWFyIEtkdW1wOiBsb2FkZWQKPj4gPiA+ID4gTm90IHRhaW50ZWQgNS41LjArCj4+ID4gPiA+
IFvCoCA2MzAuMDMxODc2XSBIYXJkd2FyZSBuYW1lOiBIdWF3ZWkgVGFpU2hhbiAyMjgwIC9CQzEx
U1BDRCwKPj4gPiA+ID4gQklPUyAxLjU4Cj4+ID4gPiA+IDEwLzI5LzIwMTgKPj4gPiA+ID4gW8Kg
IDYzMC4wMzE4NzZdIENhbGwgdHJhY2U6Cj4+ID4gPiA+IFvCoCA2MzAuMDMxODc4XcKgIGR1bXBf
YmFja3RyYWNlKzB4MC8weDIwMAo+PiA+ID4gPiBbwqAgNjMwLjAzMTg4MF3CoCBzaG93X3N0YWNr
KzB4MjQvMHgzMAo+PiA+ID4gPiBbwqAgNjMwLjAzMTg4Ml3CoCBkdW1wX3N0YWNrKzB4YjAvMHhm
NAo+PiA+ID4gPiBbwqAgNjMwLjAzMTg4NF3CoCBfX3RoaXNfY3B1X3ByZWVtcHRfY2hlY2srMHhj
OC8weGQwCj4+ID4gPiA+IFvCoCA2MzAuMDMxODg2XcKgIGt2bV9nZXRfcnVubmluZ192Y3B1KzB4
MWMvMHgzOAo+PiA+ID4gPiBbwqAgNjMwLjAzMTg4OF3CoCB2Z2ljX21taW9fY2hhbmdlX2FjdGl2
ZS5pc3JhLjQrMHgyYy8weGUwCj4+ID4gPiA+IFvCoCA2MzAuMDMxODkwXcKgIF9fdmdpY19tbWlv
X3dyaXRlX2NhY3RpdmUrMHg4MC8weGM4Cj4+ID4gPiA+IFvCoCA2MzAuMDMxODkyXcKgIHZnaWNf
bW1pb191YWNjZXNzX3dyaXRlX2NhY3RpdmUrMHgzYy8weDUwCj4+ID4gPiA+IFvCoCA2MzAuMDMx
ODk0XcKgIHZnaWNfdWFjY2VzcysweGNjLzB4MTM4Cj4+ID4gPiA+IFvCoCA2MzAuMDMxODk2XcKg
IHZnaWNfdjNfcmVkaXN0X3VhY2Nlc3MrMHg3Yy8weGE4Cj4+ID4gPiA+IFvCoCA2MzAuMDMxODk4
XcKgIHZnaWNfdjNfYXR0cl9yZWdzX2FjY2VzcysweDFhOC8weDIzMAo+PiA+ID4gPiBbwqAgNjMw
LjAzMTkwMV3CoCB2Z2ljX3YzX3NldF9hdHRyKzB4MWI0LzB4MjkwCj4+ID4gPiA+IFvCoCA2MzAu
MDMxOTAzXcKgIGt2bV9kZXZpY2VfaW9jdGxfYXR0cisweGJjLzB4MTEwCj4+ID4gPiA+IFvCoCA2
MzAuMDMxOTA1XcKgIGt2bV9kZXZpY2VfaW9jdGwrMHhjNC8weDEwOAo+PiA+ID4gPiBbwqAgNjMw
LjAzMTkwN13CoCBrc3lzX2lvY3RsKzB4YjQvMHhkMAo+PiA+ID4gPiBbwqAgNjMwLjAzMTkwOV3C
oCBfX2FybTY0X3N5c19pb2N0bCsweDI4LzB4MzgKPj4gPiA+ID4gW8KgIDYzMC4wMzE5MTFdwqAg
ZWwwX3N2Y19jb21tb24uY29uc3Rwcm9wLjErMHg3Yy8weDFhMAo+PiA+ID4gPiBbwqAgNjMwLjAz
MTkxM13CoCBkb19lbDBfc3ZjKzB4MzQvMHhhMAo+PiA+ID4gPiBbwqAgNjMwLjAzMTkxNV3CoCBl
bDBfc3luY19oYW5kbGVyKzB4MTI0LzB4Mjc0Cj4+ID4gPiA+IFvCoCA2MzAuMDMxOTE2XcKgIGVs
MF9zeW5jKzB4MTQwLzB4MTgwCj4+ID4gPiA+Cj4+ID4gPiA+IC0tLTg8LS0tCj4+ID4gPiA+Cj4+
ID4gPiA+IEknbSBub3cgYXQgY29tbWl0IDkwNTY4ZWNmNTYxNTQwZmEzMzA1MTFlMjFmY2Q4MjNi
MGMzODI5YzYuCj4+ID4gPiA+Cj4+ID4gPiA+IEFuZCBpdCBsb29rcyBsaWtlIHZnaWNfZ2V0X21t
aW9fcmVxdWVzdGVyX3ZjcHUoKSB3YXMgYnJva2VuIGJ5Cj4+ID4gPiA+IDc0OTVlMjJiYjE2NSAo
IktWTTogTW92ZSBydW5uaW5nIFZDUFUgZnJvbSBBUk0gdG8gY29tbW9uIGNvZGUiKS4KPj4gPiA+
ID4KPj4gPiA+ID4gQ291bGQgYW55b25lIHBsZWFzZSBoYXZlIGEgbG9vaz8KPj4gPiA+Cj4+ID4g
PiBIZXJlIHlvdSBnbzoKPj4gPiA+Cj4+ID4gPiBkaWZmIC0tZ2l0IGEvdmlydC9rdm0vYXJtL3Zn
aWMvdmdpYy1tbWlvLmMKPj4gPiA+IGIvdmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLmMKPj4g
PiA+IGluZGV4IGQ2NTZlYmQ1ZjlkNC4uZTE3MzVmMTljOTI0IDEwMDY0NAo+PiA+ID4gLS0tIGEv
dmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1tbWlvLmMKPj4gPiA+ICsrKyBiL3ZpcnQva3ZtL2FybS92
Z2ljL3ZnaWMtbW1pby5jCj4+ID4gPiBAQCAtMTkwLDYgKzE5MCwxNSBAQCB1bnNpZ25lZCBsb25n
IHZnaWNfbW1pb19yZWFkX3BlbmRpbmcoc3RydWN0Cj4+ID4gPiBrdm1fdmNwdSAqdmNwdSwKPj4g
PiA+ICDCoCAqIHZhbHVlIGxhdGVyIHdpbGwgZ2l2ZSB1cyB0aGUgc2FtZSB2YWx1ZSBhcyB3ZSB1
cGRhdGUgdGhlCj4+ID4gPiBwZXItQ1BVIHZhcmlhYmxlCj4+ID4gPiAgwqAgKiBpbiB0aGUgcHJl
ZW1wdCBub3RpZmllciBoYW5kbGVycy4KPj4gPiA+ICDCoCAqLwo+PiA+ID4gK3N0YXRpYyBzdHJ1
Y3Qga3ZtX3ZjcHUgKnZnaWNfZ2V0X21taW9fcmVxdWVzdGVyX3ZjcHUodm9pZCkKPj4gPiA+ICt7
Cj4+ID4gPiArwqDCoMKgIHN0cnVjdCBrdm1fdmNwdSAqdmNwdTsKPj4gPiA+ICsKPj4gPiA+ICvC
oMKgwqAgcHJlZW1wdF9kaXNhYmxlKCk7Cj4+ID4gPiArwqDCoMKgIHZjcHUgPSBrdm1fZ2V0X3J1
bm5pbmdfdmNwdSgpOwo+PiA+ID4gK8KgwqDCoCBwcmVlbXB0X2VuYWJsZSgpOwo+PiA+ID4gK8Kg
wqDCoCByZXR1cm4gdmNwdTsKPj4gPiA+ICt9Cj4+ID4gPgo+PiA+ID4gIMKgLyogTXVzdCBiZSBj
YWxsZWQgd2l0aCBpcnEtPmlycV9sb2NrIGhlbGQgKi8KPj4gPiA+ICDCoHN0YXRpYyB2b2lkIHZn
aWNfaHdfaXJxX3NwZW5kaW5nKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0Cj4+ID4gPiB2
Z2ljX2lycSAqaXJxLAo+PiA+ID4gQEAgLTIxMiw3ICsyMjEsNyBAQCB2b2lkIHZnaWNfbW1pb193
cml0ZV9zcGVuZGluZyhzdHJ1Y3Qga3ZtX3ZjcHUKPj4gPiA+ICp2Y3B1LAo+PiA+ID4gIMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBncGFfdCBhZGRyLCB1bnNpZ25lZCBpbnQg
bGVuLAo+PiA+ID4gIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25l
ZCBsb25nIHZhbCkKPj4gPiA+ICDCoHsKPj4gPiA+IC3CoMKgwqAgYm9vbCBpc191YWNjZXNzID0g
IWt2bV9nZXRfcnVubmluZ192Y3B1KCk7Cj4+ID4gPiArwqDCoMKgIGJvb2wgaXNfdWFjY2VzcyA9
ICF2Z2ljX2dldF9tbWlvX3JlcXVlc3Rlcl92Y3B1KCk7Cj4+ID4gPiAgwqDCoMKgwqAgdTMyIGlu
dGlkID0gVkdJQ19BRERSX1RPX0lOVElEKGFkZHIsIDEpOwo+PiA+ID4gIMKgwqDCoMKgIGludCBp
Owo+PiA+ID4gIMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgZmxhZ3M7Cj4+ID4gPiBAQCAtMjY1LDcg
KzI3NCw3IEBAIHZvaWQgdmdpY19tbWlvX3dyaXRlX2NwZW5kaW5nKHN0cnVjdCBrdm1fdmNwdQo+
PiA+ID4gKnZjcHUsCj4+ID4gPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGdwYV90IGFkZHIsIHVuc2lnbmVkIGludCBsZW4sCj4+ID4gPiAgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGxvbmcgdmFsKQo+PiA+ID4gIMKgewo+PiA+ID4g
LcKgwqDCoCBib29sIGlzX3VhY2Nlc3MgPSAha3ZtX2dldF9ydW5uaW5nX3ZjcHUoKTsKPj4gPiA+
ICvCoMKgwqAgYm9vbCBpc191YWNjZXNzID0gIXZnaWNfZ2V0X21taW9fcmVxdWVzdGVyX3ZjcHUo
KTsKPj4gPiA+ICDCoMKgwqDCoCB1MzIgaW50aWQgPSBWR0lDX0FERFJfVE9fSU5USUQoYWRkciwg
MSk7Cj4+ID4gPiAgwqDCoMKgwqAgaW50IGk7Cj4+ID4gPiAgwqDCoMKgwqAgdW5zaWduZWQgbG9u
ZyBmbGFnczsKPj4gPiA+IEBAIC0zMjYsNyArMzM1LDcgQEAgc3RhdGljIHZvaWQgdmdpY19tbWlv
X2NoYW5nZV9hY3RpdmUoc3RydWN0Cj4+ID4gPiBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IHZnaWNf
aXJxICppcnEsCj4+ID4gPiAgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBib29sIGFjdGl2ZSkKPj4gPiA+ICDCoHsKPj4gPiA+ICDCoMKgwqDCoCB1bnNpZ25lZCBsb25n
IGZsYWdzOwo+PiA+ID4gLcKgwqDCoCBzdHJ1Y3Qga3ZtX3ZjcHUgKnJlcXVlc3Rlcl92Y3B1ID0g
a3ZtX2dldF9ydW5uaW5nX3ZjcHUoKTsKPj4gPiA+ICvCoMKgwqAgc3RydWN0IGt2bV92Y3B1ICpy
ZXF1ZXN0ZXJfdmNwdSA9IHZnaWNfZ2V0X21taW9fcmVxdWVzdGVyX3ZjcHUoKTsKPj4gPiA+Cj4+
ID4gPiAgwqDCoMKgwqAgcmF3X3NwaW5fbG9ja19pcnFzYXZlKCZpcnEtPmlycV9sb2NrLCBmbGFn
cyk7Cj4+ID4gPgo+PiA+ID4KPj4gPiA+IFRoYXQncyBiYXNpY2FsbHkgYSByZXZlcnQgb2YgdGhl
IG9mZmVuZGluZyBjb2RlLiBUaGUgY29tbWVudCByaWdodAo+PiA+ID4gYWJvdmUKPj4gPiA+IHZn
aWNfZ2V0X21taW9fcmVxdWVzdGVyX3ZjcHUoKSBleHBsYWlucyAqd2h5KiB0aGlzIGlzIHZhbGlk
LCBhbmQgd2h5Cj4+ID4gPiBwcmVlbXB0X2Rpc2FibGUoKSBpcyBuZWVkZWQuCj4gCj4gU29ycnkg
Zm9yIG5vdCBub3RpY2luZyB0aGlzIGJlZm9yZS4KPiAKPj4gPgo+PiA+IEkgc2VlLCB0aGFua3Mh
Cj4+ID4KPj4gPiA+Cj4+ID4gPiBDYW4geW91IHBsZWFzZSBnaXZlIGl0IGEgc2hvdD8KPj4gPgo+
PiA+IFllcywgaXQgd29ya3MgZm9yIG1lOgo+PiA+Cj4+ID4gVGVzdGVkLWJ5OiBaZW5naHVpIFl1
IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPj4gCj4+IEFjdHVhbGx5LCBtYXliZSBhIGJldHRlci9z
aW1wbGVyIGZpeCB3b3VsZCBiZSB0aGlzOgo+PiAKPj4gZGlmZiAtLWdpdCBhL3ZpcnQva3ZtL2t2
bV9tYWluLmMgYi92aXJ0L2t2bS9rdm1fbWFpbi5jCj4+IGluZGV4IDY3YWUyZDVjMzdiMi4uM2Nm
NzcxOWQzMTc3IDEwMDY0NAo+PiAtLS0gYS92aXJ0L2t2bS9rdm1fbWFpbi5jCj4+ICsrKyBiL3Zp
cnQva3ZtL2t2bV9tYWluLmMKPj4gQEAgLTQ0MTQsNyArNDQxNCwxMyBAQCBzdGF0aWMgdm9pZCBr
dm1fc2NoZWRfb3V0KHN0cnVjdCAKPj4gcHJlZW1wdF9ub3RpZmllcgo+PiAqcG4sCj4+ICAgKi8K
Pj4gIHN0cnVjdCBrdm1fdmNwdSAqa3ZtX2dldF9ydW5uaW5nX3ZjcHUodm9pZCkKPj4gIHsKPj4g
LSAgICAgICAgcmV0dXJuIF9fdGhpc19jcHVfcmVhZChrdm1fcnVubmluZ192Y3B1KTsKPj4gKwlz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHU7Cj4+ICsKPj4gKwlwcmVlbXB0X2Rpc2FibGUoKTsKPj4gKwl2
Y3B1ID0gX190aGlzX2NwdV9yZWFkKGt2bV9ydW5uaW5nX3ZjcHUpOwo+PiArCXByZWVtcHRfZW5h
YmxlKCk7Cj4+ICsKPj4gKwlyZXR1cm4gdmNwdTsKPj4gIH0KPj4gCj4+ICAvKioKPj4gCj4+IHdo
aWNoIG1hdGNoZXMgdGhlIGNvbW1lbnQgdGhhdCBjb21lcyB3aXRoIHRoZSBmdW5jdGlvbi4KPj4g
Cj4+IFBhb2xvLCB3aGljaCBvbmUgZG8geW91IHByZWZlcj8gSXQgc2VlbXMgdG8gbWUgdGhhdCB0
aGUgaW50ZW50IG9mIAo+PiBtb3ZpbmcKPj4gdGhpcyB0byBjb3JlIGNvZGUgd2FzIHRvIHByb3Zp
ZGUgYSBoaWdoIGxldmVsIEFQSSB0aGF0IHdvcmtzIGF0IGFsbCAKPj4gdGltZXMuCj4gCj4gTm90
IHN1cmUgYWJvdXQgUGFvbG8sIGJ1dCB0aGlzIGxvb2tzIGJldHRlciBhdCBsZWFzdCB0byBtZS4g
IFNoYWxsIHdlCj4gYWxzbyBtb3ZlIHRoZSBjb21tZW50IGZyb20gdmdpYy1tbWlvLmMgdG8gaGVy
ZT8gIEFuZCB3ZSBjYW4gcmVtb3ZlIHRoZQo+IDFzdCBwYXJhZ3JhcGg6Cj4gCj4gLyoKPiAgKiBX
ZSBjYW4gZGlzYWJsZSBwcmVlbXB0aW9uIGxvY2FsbHkgYXJvdW5kIGFjY2Vzc2luZyB0aGUgcGVy
LUNQVSAKPiB2YXJpYWJsZSwKPiAgKiBhbmQgdXNlIHRoZSByZXNvbHZlZCB2Y3B1IHBvaW50ZXIg
YWZ0ZXIgZW5hYmxpbmcgcHJlZW1wdGlvbiBhZ2FpbiwgCj4gYmVjYXVzZQo+ICAqIGV2ZW4gaWYg
dGhlIGN1cnJlbnQgdGhyZWFkIGlzIG1pZ3JhdGVkIHRvIGFub3RoZXIgQ1BVLCByZWFkaW5nIHRo
ZSAKPiBwZXItQ1BVCj4gICogdmFsdWUgbGF0ZXIgd2lsbCBnaXZlIHVzIHRoZSBzYW1lIHZhbHVl
IGFzIHdlIHVwZGF0ZSB0aGUgcGVyLUNQVSAKPiB2YXJpYWJsZQo+ICAqIGluIHRoZSBwcmVlbXB0
IG5vdGlmaWVyIGhhbmRsZXJzLgo+ICAqLwoKU3VyZS4gSSdsbCBhZGQgaXQgYW5kIHBvc3QgYW4g
YWN0dWFsIHBhdGNoIGluIGEgbW9tZW50LgoKVGhhbmtzLAoKICAgICAgICAgTS4KLS0gCkphenog
aXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxp
c3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFu
L2xpc3RpbmZvL2t2bWFybQo=
