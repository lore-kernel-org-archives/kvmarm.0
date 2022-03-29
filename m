Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DBCC433FE
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 12:55:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3BD649F49;
	Tue, 29 Mar 2022 08:55:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DWiqU8x-WTdn; Tue, 29 Mar 2022 08:55:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62FFE49F31;
	Tue, 29 Mar 2022 08:55:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E278740BED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 03:26:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GyLHdd7Ioywk for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Mar 2022 03:26:20 -0400 (EDT)
Received: from ha.nfschina.com (mail.nfschina.com [124.16.136.209])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EEFB40BDC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 03:26:20 -0400 (EDT)
Received: from localhost (unknown [127.0.0.1])
 by ha.nfschina.com (Postfix) with ESMTP id BF6B51E80D7E;
 Tue, 29 Mar 2022 15:25:42 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from ha.nfschina.com ([127.0.0.1])
 by localhost (ha.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9r--XoVcY8pM; Tue, 29 Mar 2022 15:25:40 +0800 (CST)
Received: from [18.165.124.108] (unknown [101.228.248.165])
 (Authenticated sender: yuzhe@nfschina.com)
 by ha.nfschina.com (Postfix) with ESMTPA id 6921A1E80D70;
 Tue, 29 Mar 2022 15:25:39 +0800 (CST)
Message-ID: <49b93407-dee3-b3bb-6d36-d6f94e9b16bf@nfschina.com>
Date: Tue, 29 Mar 2022 15:26:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: arm64: vgic-debug: remove unnecessary type castings
To: Marc Zyngier <maz@kernel.org>
References: <20220328103836.2829-1-yuzhe@nfschina.com>
 <87h77ifbbd.wl-maz@kernel.org>
 <0f4cf955-ca2b-626f-867e-5a0ecfe68ca1@nfschina.com>
 <87r16li6e7.wl-maz@kernel.org>
From: yuzhe <yuzhe@nfschina.com>
In-Reply-To: <87r16li6e7.wl-maz@kernel.org>
X-Mailman-Approved-At: Tue, 29 Mar 2022 08:55:51 -0400
Cc: will@kernel.org, catalin.marinas@arm.com, kernel-janitors@vger.kernel.org,
 linux-kernel@vger.kernel.org, liqiong@nfschina.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

5ZyoIDIwMjIvMy8yOSAxNTowNywgTWFyYyBaeW5naWVyIOWGmemBkzoKCj4gT24gVHVlLCAyOSBN
YXIgMjAyMiAwNzoxNDoxNiArMDEwMCwKPiB5dXpoZSA8eXV6aGVAbmZzY2hpbmEuY29tPiB3cm90
ZToKPj4+PiBAQCAtMjI5LDcgKzIyOSw3IEBAIHN0YXRpYyB2b2lkIHByaW50X2lycV9zdGF0ZShz
dHJ1Y3Qgc2VxX2ZpbGUgKnMsIHN0cnVjdCB2Z2ljX2lycSAqaXJxLAo+Pj4+ICAgICAgc3RhdGlj
IGludCB2Z2ljX2RlYnVnX3Nob3coc3RydWN0IHNlcV9maWxlICpzLCB2b2lkICp2KQo+Pj4+ICAg
IHsKPj4+PiAtCXN0cnVjdCBrdm0gKmt2bSA9IChzdHJ1Y3Qga3ZtICopcy0+cHJpdmF0ZTsKPj4+
PiArCXN0cnVjdCBrdm0gKmt2bSA9IHMtPnByaXZhdGU7Cj4+Pj4gICAgCXN0cnVjdCB2Z2ljX3N0
YXRlX2l0ZXIgKml0ZXIgPSAoc3RydWN0IHZnaWNfc3RhdGVfaXRlciAqKXY7Cj4+PiBIb3cgYWJv
dXQgeW91IGZ1bGx5IGdldCByaWQgb2YgdGhlIHVubmVjZXNzYXJ5IGNhc3RzIHRoZW4/Cj4+Pgo+
Pj4gCU0uCj4+IEkgZG9uJ3Qga25vdyB3aGF0IHlvdSBleGFjdGx5IG1lYW4uIEkgZm9sbG93IHRo
ZQo+PiBrZXJuZWwtamFuaXRvcnMvVE9ETyBMaXN0IHRvIGdldCByaWQgb2YgdGhlIHVubmVjZXNz
YXJ5IGNhc3RzLiAgQW5kCj4+IEkgY2hlY2tlZCBhbGwgdGhlIGNvZGUgaW4gdGhlIGFyY2ggZGly
ZWN0b3J5IGFuZCBmb3VuZCB0aGVzZSBpc3N1ZXMuCj4gTGV0IG1lIHF1b3RlIHRoZSBsaW5lcyBh
Z2FpbjoKPgo+Pj4+ICAgICAgc3RhdGljIGludCB2Z2ljX2RlYnVnX3Nob3coc3RydWN0IHNlcV9m
aWxlICpzLCB2b2lkICp2KQo+IFsuLi5dCj4+Pj4gICAgCXN0cnVjdCB2Z2ljX3N0YXRlX2l0ZXIg
Kml0ZXIgPSAoc3RydWN0IHZnaWNfc3RhdGVfaXRlciAqKXY7Cj4gRG8geW91IHNlZSB3aGF0IEkg
bWVhbj8KPgo+IAlNLgoKR290IGl0LCB0aGFua3MuIEkgd2lsbCBjaGVjayBhZ2FpbiBhbmQgcmVz
dWJtaXQuCgp5dXpoZQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0
dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
