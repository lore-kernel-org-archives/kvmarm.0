Return-Path: <SRS0=68gc=DW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA856C433E7
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 13:52:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CEFCC22248
	for <kvmarm@archiver.kernel.org>; Thu, 15 Oct 2020 13:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="aYovgX3/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEFCC22248
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CACC4B2B8;
	Thu, 15 Oct 2020 09:52:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id j6vTCyVdnrGa; Thu, 15 Oct 2020 09:52:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF70A4B58B;
	Thu, 15 Oct 2020 09:52:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 580884B2C6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2020 09:52:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D-on-8JcsDUQ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Oct 2020 09:52:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2025A4B2B8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Oct 2020 09:52:38 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id C4B422222B;
 Thu, 15 Oct 2020 13:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1602769956;
 bh=xarXKYZ8s+xHzOaOdBDdrKmal0xGW3EEb9e3ttVwQAg=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=aYovgX3/go3eG/ZbCmpQGRKnh9z5m7oWFIjx02kMEtmPXNzYE1JjO31kXpusbaeuU
 Rf2KrjwgM5OFSnhgQbmMevkh9IJM6bEp3jvhorN7Twx8caRis8VNIlFS2v5KmPH2vR
 8Gzar2oZW80L6/oh0qW1Crk98JSJAYlz9/aCGkdE=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1kT3gI-001OiW-M4; Thu, 15 Oct 2020 14:52:34 +0100
MIME-Version: 1.0
Date: Thu, 15 Oct 2020 14:52:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: Andrew Jones <drjones@redhat.com>
Subject: Re: Kernel patch cases qemu live migration failed.
In-Reply-To: <20201015133505.ubxvbrt6xyvl4362@kamzik.brq.redhat.com>
References: <20201015040639.70C6D414009F@webmail.sinamail.sina.com.cn>
 <7fecfc67da4caab1d677a8b4cd5386b3@kernel.org>
 <20201015133505.ubxvbrt6xyvl4362@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <16400df4bdf79b8b22e824eb1a20e2b4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, xu910121@sina.com, qemu-devel@nongnu.org,
 dave.martin@arm.com, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kvmarm <kvmarm@lists.cs.columbia.edu>, xu910121@sina.com,
 qemu-devel <qemu-devel@nongnu.org>, "Dave.Martin" <dave.martin@arm.com>
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

T24gMjAyMC0xMC0xNSAxNDozNSwgQW5kcmV3IEpvbmVzIHdyb3RlOgo+IE9uIFRodSwgT2N0IDE1
LCAyMDIwIGF0IDEyOjI2OjEwUE0gKzAxMDAsIE1hcmMgWnluZ2llciB3cm90ZToKPj4gSGkKPj4g
Cj4+IFBsZWFzZSBkb24ndCB1c2UgbXkgYXJtLmNvbSBhZGRyZXNzIGFueW1vcmUsIG5vYm9keSBy
ZWFkcyBpdC4uLgo+PiAKPj4gT24gMjAyMC0xMC0xNSAwNTowNiwg5byg5Lic5petIHdyb3RlOgo+
PiA+IEknbSBzbyBzb3JyeSBmb3IgZGlzdHVyYmluZyB5b3UuCj4+ID4KPj4gPiBXaGVuIEkgYXBw
bHkgdGhpcyBrZXJuZWwgcGF0Y2jvvJpLVk06IGFybTY0L3N2ZTogU3lzdGVtIHJlZ2lzdGVyCj4+
ID4gY29udGV4dCBzd2l0Y2ggYW5kIGFjY2VzcyBzdXBwb3J0Cj4+ID4gaHR0cHM6Ly9naXQua2Vy
bmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L2NvbW1p
dC9hcmNoL2FybTY0L2t2bS9zeXNfcmVncy5jP2lkPTczNDMzNzYyZmNhZWI5ZDU5ZTg0ZDI5OTAy
MWM2YjE1NDY2Yzk2ZGQKPj4gCj4+IFRoaXMgcGF0Y2ggd2FzIG9ubHkgaW50cm9kdWNlZCBpbiA1
LjIsIGFuZCB3YXNuJ3Qgc3VwcG9zZWQgdG8gYmUKPj4gYmFja3BvcnRlZCB0byBhbnl0aGluZyBl
bHNlLgo+IAo+IEFsbCB1cHN0cmVhbSBwYXRjaGVzIGFyZSBiYWNrcG9ydCBjYW5kaWRhdGVzLiBX
ZWxjb21lIHRvIFJIRUwgOi0pCgpHcmVhdCEgUkhFTCBnZXRzIHRvIGtlZXAgdGhlIHBpZWNlcyEg
Oy0pCgo+IAo+PiAKPj4gPiBxZW11IGxpdmUgbWlncmF0aW9uIHdpbGwgZmFpbGVkIHdpdGggbWVz
c2FnZXPvvJoKPj4gPiAgICAgICAgICAgICAgIOKAi3FlbXUta3ZtOiBJbnZhbGlkIHZhbHVlIDIz
MyBleHBlY3RpbmcgcG9zaXRpdmUgdmFsdWUKPj4gPiA8PSAyMzIKPj4gPiAgICAgICAgICAgICAg
IHFlbXUta3ZtOiBGYWlsZWQgdG8gbG9hZCBjcHU6Y3ByZWdfdm1zdGF0ZV9hcnJheV9sZW4KPj4g
PiBOZXcgdmVyc2lvbiBrZXJuZWwgIGV4Y2x1ZGUgSURfQUE2NFpGUjBfRUwxIHJlZ2lzdGVyIHdo
ZW4gaG9zdCBub3QKPj4gPiBzdXBwb3J0IFNWRSBmZWF0dXJlLAo+PiA+IHNvIHFlbXUgaW9jdGwg
a3ZtKEtWTV9HRVRfUkVHX0xJU1QpIHdpbGwgbm90IGNvbnRhaW4gSURfQUE2NFpGUjBfRUwxCj4+
ID4gcmVnaXN0ZXIuCj4+ID4KPj4gPiBJJ20gdXNpbmcgQ2VudE9TIExpbnV4IGtlcm5lbCwgb2xk
IGtlcm5lbCB2ZXJzaW9u77yaNC4xOC4wLTgwLjExLmVsOAo+PiA+IChtaWdyYXRpb24gc291cmNl
KQo+PiA+ICAgICAgIG5ldyBrZXJuZWwgdmVyc2lvbu+8mjQuMTguMC0xNDcuNS5lbDggKG1pZ3Jh
dGlvbiBkZXN0aW5hdGlvbikKPj4gPgo+PiA+IENlbnRPUyBsaW51eCBrZXJuZWwgdmVyc2lvbiA0
LjE4LjAtMTExLmVsOCBhcHBsaWVkIHRoaXMgcGF0Y2guIFNvCj4+ID4gNC4xOC4wLTE0Ny41LmVs
OCBhbHNvIGFwcGxpZWQgdGhpcyBwYXRjaC4KPj4gPgo+PiA+IE1pZ3JhdGlvbiBzb3VyY2UgYW5k
IGRlc3RpbmF0aW9uIGhvc3RzIGhhdmUgdGhlIHNhbWUgaGFyZHdhcmUsIGp1c3QKPj4gPiBrZXJu
ZWwgdmVyc2lvbiBpcyBkaWZmZXJlbnQsCj4+ID4gYW5kIHRoZSBoYXJkd2FyZSBvbiBlaXRoZXIg
c2lkZSBvZiB0aGUgbWlncmF0aW9uIG5vdCBzdXBwb3J0IFNWRS4KPj4gPgo+PiA+IElzIHRoZXJl
IHNvbWUgZ29vZCBzdWdnZXN0aW9uc++8jHdoaWNoIGNhbiBtYWtlIHN1cmUgb2xkIHZlcnNpb24K
Pj4gPiBrZXJuZWwgbGl2ZSBtaWdyYXRpb24gdG8gbmV3IHZlcnNpb24ga2VybmVsIHdpdGggcWVt
dT8KPj4gCj4+IElbJ20gYWZyYWlkIHlvdSBzaG91bGQgdGFrZSB0aGlzIHdpdGggeW91ciBkaXN0
cmlidXRpb24gb2YKPj4gY2hvaWNlLCB1bmxlc3MgeW91IGNhbiByZXByb2R1Y2UgdGhlIHByb2Js
ZW0gd2l0aCBtYWlubGluZSBrZXJuZWxzLgo+IAo+IEknbGwgYmV0IHRoaXMgcmVwcm9kdWNlcyB3
aGVuIG1pZ3JhdGluZyBmcm9tIGEgbWFpbmxpbmUgcHJlIFNWRSAKPiByZWdpc3Rlcgo+IGZpbHRl
cmluZyBrZXJuZWwgdG8gYSBtYWlubGluZSB0aGF0IGRvZXMgdGhlIGZpbHRlcmluZy4gSSBkb24n
dCBoYXZlCj4gdGltZSB0byB0ZXN0IHRoYXQgdGhvdWdoLgoKUHJvYmFibHkuIEknbSBub3QgcmVh
bGx5IHN1cmUgd2hlcmUgdG8gZmluZCBTVkUgSFcgdGhvdWdoLCBvdGhlcgp0aGFuIGVtdWxhdGlv
bi4uLgoKICAgICAgICAgTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1c3Qgc21lbGxzIGZ1
bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2
bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xp
c3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
