Return-Path: <SRS0=iQbv=4Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E061C3F2D2
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 19:37:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC507246A2
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 19:37:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDC+EaNm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC507246A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D0D84AFB7;
	Fri, 28 Feb 2020 14:37:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Axp+DZs8akXO; Fri, 28 Feb 2020 14:37:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EC014AFF0;
	Fri, 28 Feb 2020 14:37:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 617BC4AF7B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 14:37:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vs+dW7NA7DyC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Feb 2020 14:37:51 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 45EC64AF57
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 14:37:51 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 2B5062468E;
 Fri, 28 Feb 2020 19:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1582918670;
 bh=GR2XIlY7VhwIG2Z0tuLnjCZ9twVNAAlxyjR6cCpLapc=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=MDC+EaNmqCEkJ+97BWWShMEb2fNu+dKrf+uEr314pT30XDXvN51eMNGx0x1pj7zcA
 j6PJ/803E6x7Gg2YjNyPEG/yDRG9A4lM4u+9tXLSxCxUkDE7pF1AMx7bjx5KR1jK17
 WhtaHaUWTauLUqNFuf/i1VYPRpA0A/RxsDQNnIC0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j7lSG-008q14-CA; Fri, 28 Feb 2020 19:37:48 +0000
MIME-Version: 1.0
Date: Fri, 28 Feb 2020 19:37:48 +0000
From: Marc Zyngier <maz@kernel.org>
To: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v4 08/20] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
In-Reply-To: <3d725ede-6631-59fb-1a10-9fb9890f3df6@huawei.com>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-9-maz@kernel.org>
 <4b7f71f1-5e7f-e6af-f47d-7ed0d3a8739f@huawei.com>
 <75597af0d2373ac4d92d8162a1338cbb@kernel.org>
 <19a7c193f0e4b97343e822a35f0911ed@kernel.org>
 <3d725ede-6631-59fb-1a10-9fb9890f3df6@huawei.com>
Message-ID: <dd9f1224b3b21ad793862406bd8855ba@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net,
 rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
 Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Robert Richter <rrichter@marvell.com>,
 Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

T24gMjAyMC0wMi0yMCAwMzoxMSwgWmVuZ2h1aSBZdSB3cm90ZToKPiBIaSBNYXJjLAo+IAo+IE9u
IDIwMjAvMi8xOCAyMzozMSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMgCj4+IGIvZHJpdmVycy9pcnFjaGlwL2lycS1n
aWMtdjMtaXRzLmMKPj4gaW5kZXggNzY1NmIzNTNhOTVmLi4wZWQyODZkYmE4MjcgMTAwNjQ0Cj4+
IC0tLSBhL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYzLWl0cy5jCj4+ICsrKyBiL2RyaXZlcnMv
aXJxY2hpcC9pcnEtZ2ljLXYzLWl0cy5jCj4+IEBAIC0xNDQsNyArMTQ0LDcgQEAgc3RydWN0IGV2
ZW50X2xwaV9tYXAgewo+PiAgwqDCoMKgwqAgdTE2wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqY29s
X21hcDsKPj4gIMKgwqDCoMKgIGlycV9od19udW1iZXJfdMKgwqDCoMKgwqDCoMKgIGxwaV9iYXNl
Owo+PiAgwqDCoMKgwqAgaW50wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBucl9scGlzOwo+PiAtwqDC
oMKgIHJhd19zcGlubG9ja190wqDCoMKgwqDCoMKgwqAgdmxwaV9sb2NrOwo+PiArwqDCoMKgIHJh
d19zcGlubG9ja190wqDCoMKgwqDCoMKgwqAgbWFwX2xvY2s7Cj4gCj4gU28gd2UgdXNlIG1hcF9s
b2NrIHRvIHByb3RlY3QgYm90aCBMUEkncyBhbmQgVkxQSSdzIG1hcHBpbmcgYWZmaW5pdHkgb2YK
PiBhIGRldmljZSwgYW5kIHVzZSB2cGVfbG9jayB0byBwcm90ZWN0IHZQRSdzIGFmZmluaXR5LCBP
Sy4KPiAKPj4gIMKgwqDCoMKgIHN0cnVjdCBpdHNfdm3CoMKgwqDCoMKgwqDCoCAqdm07Cj4+ICDC
oMKgwqDCoCBzdHJ1Y3QgaXRzX3ZscGlfbWFwwqDCoMKgICp2bHBpX21hcHM7Cj4+ICDCoMKgwqDC
oCBpbnTCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG5yX3ZscGlzOwo+PiBAQCAtMjQwLDE1ICsyNDAs
MzMgQEAgc3RhdGljIHN0cnVjdCBpdHNfdmxwaV9tYXAgKmdldF92bHBpX21hcChzdHJ1Y3QgCj4+
IGlycV9kYXRhICpkKQo+PiAgwqDCoMKgwqAgcmV0dXJuIE5VTEw7Cj4+ICDCoH0KPj4gCj4+IC1z
dGF0aWMgaW50IGlycV90b19jcHVpZChzdHJ1Y3QgaXJxX2RhdGEgKmQpCj4+ICtzdGF0aWMgaW50
IGlycV90b19jcHVpZF9sb2NrKHN0cnVjdCBpcnFfZGF0YSAqZCwgdW5zaWduZWQgbG9uZyAKPj4g
KmZsYWdzKQo+PiAgwqB7Cj4+IC3CoMKgwqAgc3RydWN0IGl0c19kZXZpY2UgKml0c19kZXYgPSBp
cnFfZGF0YV9nZXRfaXJxX2NoaXBfZGF0YShkKTsKPj4gIMKgwqDCoMKgIHN0cnVjdCBpdHNfdmxw
aV9tYXAgKm1hcCA9IGdldF92bHBpX21hcChkKTsKPj4gK8KgwqDCoCBpbnQgY3B1Owo+PiAKPj4g
LcKgwqDCoCBpZiAobWFwKQo+PiAtwqDCoMKgwqDCoMKgwqAgcmV0dXJuIG1hcC0+dnBlLT5jb2xf
aWR4Owo+PiArwqDCoMKgIGlmIChtYXApIHsKPj4gK8KgwqDCoMKgwqDCoMKgIHJhd19zcGluX2xv
Y2tfaXJxc2F2ZSgmbWFwLT52cGUtPnZwZV9sb2NrLCAqZmxhZ3MpOwo+PiArwqDCoMKgwqDCoMKg
wqAgY3B1ID0gbWFwLT52cGUtPmNvbF9pZHg7Cj4+ICvCoMKgwqAgfSBlbHNlIHsKPj4gK8KgwqDC
oMKgwqDCoMKgIHN0cnVjdCBpdHNfZGV2aWNlICppdHNfZGV2ID0gaXJxX2RhdGFfZ2V0X2lycV9j
aGlwX2RhdGEoZCk7Cj4+ICvCoMKgwqDCoMKgwqDCoCByYXdfc3Bpbl9sb2NrX2lycXNhdmUoJml0
c19kZXYtPmV2ZW50X21hcC5tYXBfbG9jaywgKmZsYWdzKTsKPj4gK8KgwqDCoMKgwqDCoMKgIGNw
dSA9IGl0c19kZXYtPmV2ZW50X21hcC5jb2xfbWFwW2l0c19nZXRfZXZlbnRfaWQoZCldOwo+PiAr
wqDCoMKgIH0KPj4gCj4+IC3CoMKgwqAgcmV0dXJuIGl0c19kZXYtPmV2ZW50X21hcC5jb2xfbWFw
W2l0c19nZXRfZXZlbnRfaWQoZCldOwo+PiArwqDCoMKgIHJldHVybiBjcHU7Cj4+ICt9Cj4gCj4g
VGhpcyBoZWxwZXIgaXMgY29ycmVjdCBmb3Igbm9ybWFsIExQSXMgYW5kIFZMUElzLCBidXQgd3Jv
bmcgZm9yIHBlci12UEUKPiBJUlEgKGRvb3JiZWxsKSBhbmQgdlNHSXMuIGlycV9kYXRhX2dldF9p
cnFfY2hpcF9kYXRhKCkgZ2V0cyBjb25mdXNlZCBieQo+IGJvdGggb2YgdGhlbS4KClllcywgSSd2
ZSBmaXhlZCB0aGF0IGluIHRoZSBjdXJyZW50IHN0YXRlIG9mIHRoZSB0cmVlIGxhc3Qgd2Vlay4g
RG8gaGF2ZSAKYQpsb29rIGlmIHlvdSBjYW4sIGJ1dCBpdCBzZWVtcyB0byBzdXJ2aXZlIG9uIGJv
dGggdGhlIG1vZGVsIHdpdGggdjQuMSBhbmQKbXkgRDA1LgoKWy4uLl0KCj4+IC3CoMKgwqDCoMKg
wqDCoCByZGJhc2UgPSBwZXJfY3B1X3B0cihnaWNfcmRpc3RzLT5yZGlzdCwgCj4+IHZwZS0+Y29s
X2lkeCktPnJkX2Jhc2U7Cj4+ICvCoMKgwqDCoMKgwqDCoCBjcHUgPSBpcnFfdG9fY3B1aWRfbG9j
ayhkLCAmZmxhZ3MpOwo+PiArwqDCoMKgwqDCoMKgwqAgcmRiYXNlID0gcGVyX2NwdV9wdHIoZ2lj
X3JkaXN0cy0+cmRpc3QsIGNwdSktPnJkX2Jhc2U7Cj4+ICDCoMKgwqDCoMKgwqDCoMKgIGdpY193
cml0ZV9scGlyKGQtPnBhcmVudF9kYXRhLT5od2lycSwgcmRiYXNlICsgCj4+IEdJQ1JfSU5WTFBJ
Uik7Cj4+ICDCoMKgwqDCoMKgwqDCoMKgIHdhaXRfZm9yX3N5bmNyKHJkYmFzZSk7Cj4+ICvCoMKg
wqDCoMKgwqDCoCBpcnFfdG9fY3B1aWRfdW5sb2NrKGQsIGZsYWdzKTsKPj4gIMKgwqDCoMKgIH0g
ZWxzZSB7Cj4+ICDCoMKgwqDCoMKgwqDCoMKgIGl0c192cGVfc2VuZF9jbWQodnBlLCBpdHNfc2Vu
ZF9pbnYpOwo+PiAgwqDCoMKgwqAgfQo+IAo+IERvIHdlIHJlYWxseSBuZWVkIHRvIGdyYWIgdGhl
IHZwZV9sb2NrIGZvciB0aG9zZSB3aGljaCBhcmUgYmVsb25nIHRvCj4gdGhlIHNhbWUgaXJxY2hp
cCB3aXRoIGl0c192cGVfc2V0X2FmZmluaXR5KCk/IFRoZSBJUlEgY29yZSBjb2RlIHNob3VsZAo+
IGFscmVhZHkgZW5zdXJlIHRoZSBtdXR1YWwgZXhjbHVzaW9uIGFtb25nIHRoZW0sIHdyb25nPwoK
SSd2ZSBiZWVuIHRyeWluZyB0byB0aGluayBhYm91dCB0aGF0LCBidXQgamV0LWxhZyBrZWVwcyBn
ZXR0aW5nIGluIHRoZSAKd2F5LgpJIGVtcGlyaWNhbGx5IHRoaW5rIHRoYXQgeW91IGFyZSByaWdo
dCwgYnV0IEkgbmVlZCB0byBnbyBhbmQgY2hlY2sgdGhlIAp2YXJpb3VzCmNvZGUgcGF0aHMgdG8g
YmUgc3VyZS4gSG9wZWZ1bGx5IEknbGwgaGF2ZSBhIGJpdCBtb3JlIGJyYWluIHNwYWNlIG5leHQg
CndlZWsuCgpGb3Igc3VyZSB0aGlzIHBhdGNoIHRyaWVzIHRvIGRvIHRvbyBtYW55IHRoaW5ncyBh
dCBvbmNlLi4uCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3QgZGVhZC4gSXQganVzdCBzbWVs
bHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBz
Oi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
