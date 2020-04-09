Return-Path: <SRS0=LaKu=5Z=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E61C9C2D0EA
	for <kvmarm@archiver.kernel.org>; Thu,  9 Apr 2020 08:08:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 691E220692
	for <kvmarm@archiver.kernel.org>; Thu,  9 Apr 2020 08:08:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="J1SZXJcV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 691E220692
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFAE44B13A;
	Thu,  9 Apr 2020 04:08:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WsoSH1vNoF22; Thu,  9 Apr 2020 04:08:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F8484B147;
	Thu,  9 Apr 2020 04:08:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 22CDF4B13E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 04:08:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rj0QWp1Y4FMY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Apr 2020 04:08:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BC9CA4B13A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Apr 2020 04:08:38 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 8108220692;
 Thu,  9 Apr 2020 08:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586419717;
 bh=ZYPF+rqovQLCUsclK6F4X9TtrIH2oOg/81gTxOxeTgg=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=J1SZXJcVZQ7/9n8KUsYnObss5o5bQv9Bod/OTeAZR8Ee6db01n5Gylh0gYLTA++j5
 iFtLaRcpoIpbHzIRTF5TEp4WdHIZgorpkr/xoqJkVqpkweltXge9pHibnTqFQqSuSy
 +JgZc5XV7Ips4tm112z57o/y/xiOf6BY5aSGdh9Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jMSEl-001qYZ-O9; Thu, 09 Apr 2020 09:08:35 +0100
Date: Thu, 9 Apr 2020 09:08:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: =?UTF-8?Q?Andr=C3=A9?= Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] KVM: arm64: arch_timer shouldn't assume the vcpu is loaded
Message-ID: <20200409090834.7d655d8f@why>
In-Reply-To: <d49f5180-aa5a-a04c-836a-0b30336d1d7c@arm.com>
References: <20200406150355.4859-1-james.morse@arm.com>
 <20200408110726.4d81bc3b@why>
 <281d91cb-6818-4393-55ce-6207c04d744b@arm.com>
 <92de4dc6e0c065eec528bb21c2d870cf@kernel.org>
 <d49f5180-aa5a-a04c-836a-0b30336d1d7c@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, james.morse@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

T24gV2VkLCA4IEFwciAyMDIwIDE3OjUwOjA5ICswMTAwCkFuZHLDqSBQcnp5d2FyYSA8YW5kcmUu
cHJ6eXdhcmFAYXJtLmNvbT4gd3JvdGU6Cgo+IE9uIDA4LzA0LzIwMjAgMTU6MTksIE1hcmMgWnlu
Z2llciB3cm90ZToKPiAKPiBIaSBNYXJjLAo+IAo+ID4gT24gMjAyMC0wNC0wOCAxMzoxMywgQW5k
csOpIFByenl3YXJhIHdyb3RlOiAgCj4gPj4gT24gMDgvMDQvMjAyMCAxMTowNywgTWFyYyBaeW5n
aWVyIHdyb3RlOgo+ID4+Cj4gPj4gSGkgTWFyYywKPiA+PiAgCj4gPj4+IEhpIEphbWVzLAo+ID4+
Pgo+ID4+PiBUaGFua3MgZm9yIGxvb2tpbmcgaW50byB0aGlzLgo+ID4+Pgo+ID4+PiBPbiBNb24s
wqAgNiBBcHIgMjAyMCAxNjowMzo1NSArMDEwMAo+ID4+PiBKYW1lcyBNb3JzZSA8amFtZXMubW9y
c2VAYXJtLmNvbT4gd3JvdGU6Cj4gPj4+ICAKPiA+Pj4+IGt2bV9hcmNoX3RpbWVyX2dldF9pbnB1
dF9sZXZlbCgpIG5lZWRzIHRvIGdldCB0aGUgYXJjaF90aW1lcl9jb250ZXh0Cj4gPj4+PiBmb3IK
PiA+Pj4+IGEgcGFydGljdWxhciB2Y3B1LCBhbmQgdXNlcyBrdm1fZ2V0X3J1bm5pbmdfdmNwdSgp
IHRvIGZpbmQgaXQuCj4gPj4+Pgo+ID4+Pj4ga3ZtX2FyY2hfdGltZXJfZ2V0X2lucHV0X2xldmVs
KCkgbWF5IGJlIGNhbGxlZCB0byBoYW5kbGUgYSB1c2VyLXNwYWNlCj4gPj4+PiB3cml0ZSB0byB0
aGUgcmVkaXN0cmlidXRvciwgd2hlcmUgdGhlIHZjcHUgaXMgbm90IGxvYWRlZC4gVGhpcyBjYXVz
ZXMKPiA+Pj4+IGt2bV9nZXRfcnVubmluZ192Y3B1KCkgdG8gcmV0dXJuIE5VTEw6Cj4gPj4+PiB8
IFVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBhZ2luZyByZXF1ZXN0IGF0IHZpcnR1YWwgYWRkcmVz
cwo+ID4+Pj4gMDAwMDAwMDAwMDAwMWVjMAo+ID4+Pj4gfCBNZW0gYWJvcnQgaW5mbzoKPiA+Pj4+
IHzCoMKgIEVTUiA9IDB4OTYwMDAwMDQKPiA+Pj4+IHzCoMKgIEVDID0gMHgyNTogREFCVCAoY3Vy
cmVudCBFTCksIElMID0gMzIgYml0cwo+ID4+Pj4gfMKgwqAgU0VUID0gMCwgRm5WID0gMAo+ID4+
Pj4gfMKgwqAgRUEgPSAwLCBTMVBUVyA9IDAKPiA+Pj4+IHwgRGF0YSBhYm9ydCBpbmZvOgo+ID4+
Pj4gfMKgwqAgSVNWID0gMCwgSVNTID0gMHgwMDAwMDAwNAo+ID4+Pj4gfMKgwqAgQ00gPSAwLCBX
blIgPSAwCj4gPj4+PiB8IHVzZXIgcGd0YWJsZTogNGsgcGFnZXMsIDQ4LWJpdCBWQXMsIHBnZHA9
MDAwMDAwMDAzY2JmOTAwMAo+ID4+Pj4gfCBbMDAwMDAwMDAwMDAwMWVjMF0gcGdkPTAwMDAwMDAw
MDAwMDAwMDAKPiA+Pj4+IHwgSW50ZXJuYWwgZXJyb3I6IE9vcHM6IDk2MDAwMDA0IFsjMV0gUFJF
RU1QVCBTTVAKPiA+Pj4+IHwgTW9kdWxlcyBsaW5rZWQgaW46IHI4MTY5IHJlYWx0ZWsgZWZpdmFy
ZnMgaXBfdGFibGVzIHhfdGFibGVzCj4gPj4+PiB8IENQVTogMSBQSUQ6IDI2MTUgQ29tbTogcWVt
dS1zeXN0ZW0tYWFyIE5vdCB0YWludGVkIDUuNi4wLXJjNyAjMzAKPiA+Pj4+IHwgSGFyZHdhcmUg
bmFtZTogTWFydmVsbCBtdmVidV9hcm1hZGEtMzd4eC9tdmVidV9hcm1hZGEtMzd4eCwgQklPUwo+
ID4+Pj4gMjAxOC4wMy1kZXZlbC0xOC4xMi4zLWdjOWFhOTJjLWFybWJpYW4gMDIvMjAvMjAxOQo+
ID4+Pj4gfCBwc3RhdGU6IDAwMDAwMDg1IChuemN2IGRhSWYgLVBBTiAtVUFPKQo+ID4+Pj4gfCBw
YyA6IGt2bV9hcmNoX3RpbWVyX2dldF9pbnB1dF9sZXZlbCsweDFjLzB4NjgKPiA+Pj4+IHwgbHIg
OiBrdm1fYXJjaF90aW1lcl9nZXRfaW5wdXRfbGV2ZWwrMHgxYy8weDY4Cj4gPj4+Pgo+ID4+Pj4g
fCBDYWxsIHRyYWNlOgo+ID4+Pj4gfMKgIGt2bV9hcmNoX3RpbWVyX2dldF9pbnB1dF9sZXZlbCsw
eDFjLzB4NjgKPiA+Pj4+IHzCoCB2Z2ljX2dldF9waHlzX2xpbmVfbGV2ZWwrMHgzYy8weDkwCj4g
Pj4+PiB8wqAgdmdpY19tbWlvX3dyaXRlX3NlbmFibGUrMHhlNC8weDEzMAo+ID4+Pj4gfMKgIHZn
aWNfdWFjY2VzcysweGUwLzB4MTAwCj4gPj4+PiB8wqAgdmdpY192M19yZWRpc3RfdWFjY2Vzcysw
eDVjLzB4ODAKPiA+Pj4+IHzCoCB2Z2ljX3YzX2F0dHJfcmVnc19hY2Nlc3MrMHhmMC8weDIwMAo+
ID4+Pj4gfMKgIG52Z2ljX3YzX3NldF9hdHRyKzB4MjM0LzB4MjUwCj4gPj4+PiB8wqAga3ZtX2Rl
dmljZV9pb2N0bF9hdHRyKzB4YTQvMHhmOAo+ID4+Pj4gfMKgIGt2bV9kZXZpY2VfaW9jdGwrMHg3
Yy8weGMwCj4gPj4+PiB8wqAga3N5c19pb2N0bCsweDFmYy8weGMxOAo+ID4+Pj4gfMKgIF9fYXJt
NjRfc3lzX2lvY3RsKzB4MjQvMHgzMAo+ID4+Pj4gfMKgIGRvX2VsMF9zdmMrMHg3Yy8weDE0OAo+
ID4+Pj4gfMKgIGVsMF9zeW5jX2hhbmRsZXIrMHgxMzgvMHgyNTgKPiA+Pj4+IHzCoCBlbDBfc3lu
YysweDE0MC8weDE4MAo+ID4+Pj4gfCBDb2RlOiA5MTAwMDNmZCBmOTAwMGJmMyAyYTAwMDNmMyA5
N2ZmNjUwYyAoYjk1ZWMwMDEpCj4gPj4+PiB8IC0tLVsgZW5kIHRyYWNlIDgxMjg3NjEyZDkzZjFl
NzAgXS0tLQo+ID4+Pj4gfCBub3RlOiBxZW11LXN5c3RlbS1hYXJbMjYxNV0gZXhpdGVkIHdpdGgg
cHJlZW1wdF9jb3VudCAxCj4gPj4+Pgo+ID4+Pj4gTG9hZGluZyB0aGUgdmNwdSBkb2Vzbid0IG1h
a2UgYSBsb3Qgb2Ygc2Vuc2UgZm9yIGhhbmRsaW5nIGEgZGV2aWNlCj4gPj4+PiBpb2N0bCgpLAo+
ID4+Pj4gc28gaW5zdGVhZCBwYXNzIHRoZSB2Y3B1IHRocm91Z2ggdG8KPiA+Pj4+IGt2bV9hcmNo
X3RpbWVyX2dldF9pbnB1dF9sZXZlbCgpLiBJdHMKPiA+Pj4+IG5vdCBjbGVhciB0aGF0IGFuIGlu
dGlkIG1ha2VzIG11Y2ggc2Vuc2Ugd2l0aG91dCB0aGUgcGFpcmVkIHZjcHUuICAKPiA+Pj4KPiA+
Pj4gSSBkb24ndCBmdWxseSBhZ3JlZSB3aXRoIHRoZSBhbmFseXNpcywgUmVtZW1iZXIgd2UgYXJl
IGxvb2tpbmcgYXQgdGhlCj4gPj4+IHN0YXRlIG9mIHRoZSBwaHlzaWNhbCBpbnRlcnJ1cHQgYXNz
b2NpYXRlZCB3aXRoIGEgdmlydHVhbCBpbnRlcnJ1cHQsIHNvCj4gPj4+IHRoZSB2Y3B1IGRvZXNu
J3QgcXVpdGUgbWFrZSBzZW5zZSBoZXJlIGlmIGl0IGlzbid0IGxvYWRlZC4gIAo+ID4+Cj4gPj4g
QnV0IHdhc24ndCBpdCB0aGF0IHRoaXMgZnVuY3Rpb24gaXMgbWVhbnQgdG8gc3BlY2lmaWNhbGx5
IGRlYWwgd2l0aCB0aGlzCj4gPj4gKndpdGhvdXQqIGdvaW5nIHRvIHRoZSBoYXJkd2FyZSAod2hp
Y2ggaXMgY29zdGx5LCBoZW5jZSB0aGlzCj4gPj4gb3B0aW1pc2F0aW9uKT8gQmVjYXVzZSBmb3Ig
dGhlIHRpbWVyIHdlICpjYW4qIHdvcmsgb3V0IHRoZSBsb2dpY2FsIElSUQo+ID4+IGxpbmUgc3Rh
dGUgYnkgZXhhbWluaW5nIG91ciBzYXZlZCBzdGF0ZT8gQW5kIHRoaXMgaXMgd2hhdCB3ZSBkbyBp
bgo+ID4+IGt2bV90aW1lcl9zaG91bGRfZmlyZSgpLCB3aGVuIHRpbWVyX2N0eC0+bG9hZGVkIGlz
IGZhbHNlLiAgCj4gPiAKPiA+IFllcywgYnV0IHRoYXQncyBqdXN0IGEgc3BlY2lhbGl6YXRpb24g
b2YgYSBtb3JlIGdlbmVyaWMgaW50ZXJmYWNlLCB3aGljaCBpcwo+ID4gImluc3BlY3QgdGhlIHN0
YXRlIG9mIHRoaXMgKnBoeXNpY2FsKiBpbnRpZCIuIFRoZSBmYWN0IHRoYXQgd2UgYXJlIGFibGUK
PiA+IHRvIGRvCj4gPiBpdCBpbiBhIHNwZWNpYWwgd2F5IGZvciB0aGUgdGltZXIgZG9lc24ndCBj
aGFuZ2UgdGhlIG5hdHVyZSBvZiB0aGUKPiA+IGludGVyZmFjZS4gIAo+IAo+IAo+ID4gICAKPiA+
PiBXaGljaCBmb3IgbWUgdGhpcyBzb3VuZHMgbGlrZSB0aGUgcmlnaHQgdGhpbmcgdG8gZG8gaW4g
dGhpcyBzaXR1YXRpb246Cj4gPj4gdGhlIFZDUFUgKGFuZCB0aGUgdGltZXIpIGlzIG5vdCBsb2Fk
ZWQsIHNvIHdlIGNoZWNrIG91ciBzYXZlZCBzdGF0ZSBhbmQKPiA+PiBjb25zdHJ1Y3QgdGhlIGxv
Z2ljYWwgbGluZSBsZXZlbC4gV2UganVzdCBuZWVkIGEgdmFsaWQgVkNQVSBzdHJ1Y3QgdG8KPiA+
PiBhY2hpZXZlIHRoaXMsIGFuZCBob3BlIGZvciB0aGUgdmlydHVhbCB0aW1lciB0byBiZSBhbHJl
YWR5IGluaXRpYWxpc2VkLgo+ID4+Cj4gPj4gRG8gSSBtaXNzIHNvbWV0aGluZyBoZXJlPyAgCj4g
PiAKPiA+IFllcy4gWW91IGFyZSBtaXNzaW5nIHRoYXQgdGhlICppbnRlcmZhY2UqIGlzIGdlbmVy
aWMsIGFuZCB5b3UgY2FuIHJlcGxhY2UKPiA+IGl0IHdpdGggYW55dGhpbmcgeW91IHdhbnQuIENh
c2UgaW4gcG9pbnQsIHdoYXQgd2UgZG8gd2hlbiBnZXRfaW5wdXRfbGV2ZWwKPiA+IGlzIE5VTEwu
Cj4gPiAgIAo+ID4+IEFsc28gdG8gbWUgaXQgc291bmQgbGlrZSB0aGUgaW50ZXJmYWNlIGZvciB0
aGlzIGZ1bmN0aW9uIGlzIHNsaWdodGx5Cj4gPj4gbGFja2luZywgYmVjYXVzZSBqdXN0IGFuIGlu
dGlkIGlzIG5vdCBlbm91Z2ggdG8gdW5pcXVlbHkgaWRlbnRpZnkgYW4KPiA+PiBJUlEuIEl0IHdh
cyBqdXN0IGZpbmUgc28gZmFyIGJlY2F1c2Ugb2YgdGhpcyBzcGVjaWFsIHVzZSBjYXNlLiAgCj4g
PiAKPiA+IFRoaXMgaXMgYSAqcGh5c2ljYWwqIGludGlkLiAgIAo+IAo+IFdhaXQsIEkgYW0gY29u
ZnVzZWQsIHRoZSB0eXBlIGRlY2xhcmF0aW9uIGluIHN0cnVjdCB2Z2ljX2lycSBzYXlzOgo+IC4u
Lgo+ICAgICAgICAgYm9vbCAoKmdldF9pbnB1dF9sZXZlbCkoaW50IHZpbnRpZCk7Cj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBeXl4KPiBBbHNvIGluIHZnaWMuYzp2Z2ljX2dl
dF9waHlzX2xpbmVfbGV2ZWwoKSB3ZSBjYWxsCj4gaXJxLT5nZXRfaW5wdXRfbGV2ZWwoaXJxLT5p
bnRpZCksIHdoaWNoIGlzIHRoZSB2aXJ0dWFsIGludGlkLgoKWWVhaCwgdGhhdCdzIG5vdCBncmVh
dCBpbmRlZWQuIEl0IGlzIGEgY3VubmluZyBzaG9ydGN1dCB0byBnZXQgdG8gdGhlCnRpbWVyLCBi
dXQgdGhhdCByZWFsbHkgc2hvdWxkIGJlIHRoZSBob3N0IGlycS4KCj4gQnV0IEkgc2VlIHRoYXQg
dGhlIHBoeXNpY2FsIGludGlkIG1ha2VzIG1vcmUgc2Vuc2UgaGVyZSAoaW4gdGhlIHNwaXJpdAo+
IG9mOiBwcm92aWRlIGEgc2hvcnRjdXQgZm9yIHBva2luZyB0aGUgR0lDIGZvciB0aGUgYXNzb2Np
YXRlZCBod2lycSksIGJ1dAo+IHNob3VsZG4ndCB3ZSB0aGVuIHBhc3MgYXQgbGVhc3QgaXJxLT5o
d2ludGlkICh3aGljaCBqdXN0IGhhcHBlbnMgdG8gYmUKPiB0aGUgc2FtZSBpbiB0aGUgYXJjaCB0
aW1lciBjYXNlKT8KCmh3aW50aWQgaXNuJ3QgcmVhbGx5IHNvbWV0aGluZyB3ZSBzaG91bGQgY29u
c2lkZXIsIGFzIGl0IGlzIGFuCmltcGxlbWVudGF0aW9uIGRldGFpbCBvZiB0aGUgcGh5c2ljYWwg
R0lDIGFuZCBsaXN0IHJlZ2lzdGVycy4gSXQgaXMKdG9vIGxvdy1sZXZlbCB0byBiZSBnZW5lcmFs
bHkgdXNlZnVsLiBUaGUgaG9zdF9pcnEgZmllbGQsIG9uIHRoZSBvdGhlcgpoYW5kLCBpcyBhIGJl
dHRlciBpbmZvcm1hdGlvbiBzb3VyY2UsIGFuZCB0aGUgdGltZXIgYWxyZWFkeSBoYXMgdGhpcwpz
dGFzaGVkLgoKT3ZlcmFsbCwgd2UgY291bGQganVzdCBwYXNzIHRoZSBwb2ludGVyIHRvIHRoZSB2
Z2ljX2lycSwgYW5kIGxldCB0aGUKaGVscGVyIGRvIHdoYXRldmVyIGl0IG5lZWRzIHRvIHNvcnQg
aXQgb3V0LiBBZnRlciBhbGwsIGl0IGlzIHN1cHBvc2VkCnRvIGJlIGZhc3RlciB0aGFuIGdvaW5n
IHRvIHRoZSBHSUMsIHNvIHdlIGNhbiBoYXZlIGEgYml0IG9mIGxlZXdheSBoZXJlLgoKTm90IGEg
YmlnIGRlYWwsIGFzIHRoaXMgaXNuJ3QgdGhlIHBhcnQgdGhhdCBpcyBicm9rZW4gQVRNLgoKVGhh
bmtzLAoKCU0uCi0tIApKYXp6IGlzIG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpf
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFp
bGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5j
b2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
