Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D505C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 08:08:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8534C206E0
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 08:08:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="eDV1mZdh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8534C206E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D51864BCAD;
	Tue, 24 Nov 2020 03:08:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xJ8zlmO1r0h6; Tue, 24 Nov 2020 03:08:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 838C24BCED;
	Tue, 24 Nov 2020 03:08:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D00724BCAD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 03:08:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JL1eGQKLGkmB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 03:08:14 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E16D4BC8C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 03:08:14 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id E5DD6206D9;
 Tue, 24 Nov 2020 08:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606205293;
 bh=G+ujxjFt/eVsHQI1QsvkPgPsk4UXcNfS/bgQijKG/hA=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=eDV1mZdh+r548ggFb4+qZPDsElMU200zkPh59LiqAg/HwFaKAhufK4hlprPzNgE1+
 wVj6edkiR1Vd3YKTRmAquQc14/9ZNQ1EWEA4va9qtXPDMkl2WwXxXjrSvDer7DBpM8
 7TtSk3JfZDuUiQ3rjx9vcUXwtBAOG8XZNxH81NY8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1khTMw-00DBJ1-GG; Tue, 24 Nov 2020 08:08:10 +0000
MIME-Version: 1.0
Date: Tue, 24 Nov 2020 08:08:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [RFC PATCH v1 1/4] irqchip/gic-v4.1: Plumb get_irqchip_state VLPI
 callback
In-Reply-To: <7bc7e428-cfd5-6171-dc1e-4be097c46690@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-2-lushenming@huawei.com>
 <f64703b618a2ebc6c6f5c423e2b779c6@kernel.org>
 <7bc7e428-cfd5-6171-dc1e-4be097c46690@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <e01d8bf87ef42bda3f3ec117e474d103@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: lushenming@huawei.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, christoffer.dall@arm.com,
 alex.williamson@redhat.com, kwankhede@nvidia.com, cohuck@redhat.com,
 cjia@nvidia.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Neo Jia <cjia@nvidia.com>, kvm@vger.kernel.org,
 Cornelia Huck <cohuck@redhat.com>, linux-kernel@vger.kernel.org,
 Kirti Wankhede <kwankhede@nvidia.com>,
 Alex Williamson <alex.williamson@redhat.com>, kvmarm@lists.cs.columbia.edu,
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

T24gMjAyMC0xMS0yNCAwNzozOCwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gT24gMjAyMC8xMS8yMyAx
NzowMSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBPbiAyMDIwLTExLTIzIDA2OjU0LCBTaGVubWlu
ZyBMdSB3cm90ZToKPj4+IEZyb206IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+
Pj4gCj4+PiBVcCB0byBub3csIHRoZSBpcnFfZ2V0X2lycWNoaXBfc3RhdGUoKSBjYWxsYmFjayBv
ZiBpdHNfaXJxX2NoaXAKPj4+IGxlYXZlcyB1bmltcGxlbWVudGVkIHNpbmNlIHRoZXJlIGlzIG5v
IGFyY2hpdGVjdHVyYWwgd2F5IHRvIGdldAo+Pj4gdGhlIFZMUEkncyBwZW5kaW5nIHN0YXRlIGJl
Zm9yZSBHSUN2NC4xLiBZZWFoLCB0aGVyZSBoYXMgb25lIGluCj4+PiB2NC4xIGZvciBWTFBJcy4K
Pj4+IAo+Pj4gV2l0aCBHSUN2NC4xLCBhZnRlciB1bm1hcHBpbmcgdGhlIHZQRSwgd2hpY2ggY2xl
YW5zIGFuZCBpbnZhbGlkYXRlcwo+Pj4gYW55IGNhY2hpbmcgb2YgdGhlIFZQVCwgd2UgY2FuIGdl
dCB0aGUgVkxQSSdzIHBlbmRpbmcgc3RhdGUgYnkKPj4gCj4+IFRoaXMgaXMgYSBjcnVjaWFsIG5v
dGU6IHdpdGhvdXQgdGhpcyB1bm1hcHBpbmcgYW5kIGludmFsaWRhdGlvbiwKPj4gdGhlIHBlbmRp
bmcgYml0cyBhcmUgbm90IGdlbmVyYWxseSBhY2Nlc3NpYmxlICh0aGV5IGNvdWxkIGJlIGNhY2hl
ZAo+PiBpbiBhIEdJQyBwcml2YXRlIHN0cnVjdHVyZSwgY2FjaGUgb3Igb3RoZXJ3aXNlKS4KPj4g
Cj4+PiBwZWVraW5nIGF0IHRoZSBWUFQuIFNvIHdlIGltcGxlbWVudCB0aGUgaXJxX2dldF9pcnFj
aGlwX3N0YXRlKCkKPj4+IGNhbGxiYWNrIG9mIGl0c19pcnFfY2hpcCB0byBkbyBpdC4KPj4+IAo+
Pj4gU2lnbmVkLW9mZi1ieTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+PiBT
aWduZWQtb2ZmLWJ5OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPgo+Pj4gLS0t
Cj4+PiDCoGRyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYzLWl0cy5jIHwgMzggCj4+PiArKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKwo+Pj4gwqAxIGZpbGUgY2hhbmdlZCwgMzggaW5zZXJ0
aW9ucygrKQo+Pj4gCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9pcnFjaGlwL2lycS1naWMtdjMt
aXRzLmMgCj4+PiBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYzLWl0cy5jCj4+PiBpbmRleCAw
ZmVjMzE5MzFlMTEuLjI4NzAwM2NhY2FjNyAxMDA2NDQKPj4+IC0tLSBhL2RyaXZlcnMvaXJxY2hp
cC9pcnEtZ2ljLXYzLWl0cy5jCj4+PiArKysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1p
dHMuYwo+Pj4gQEAgLTE2OTUsNiArMTY5NSw0MyBAQCBzdGF0aWMgdm9pZCBpdHNfaXJxX2NvbXBv
c2VfbXNpX21zZyhzdHJ1Y3QKPj4+IGlycV9kYXRhICpkLCBzdHJ1Y3QgbXNpX21zZyAqbXNnKQo+
Pj4gwqDCoMKgwqAgaW9tbXVfZG1hX2NvbXBvc2VfbXNpX21zZyhpcnFfZGF0YV9nZXRfbXNpX2Rl
c2MoZCksIG1zZyk7Cj4+PiDCoH0KPj4+IAo+Pj4gK3N0YXRpYyBib29sIGl0c19wZWVrX3ZwdChz
dHJ1Y3QgaXRzX3ZwZSAqdnBlLCBpcnFfaHdfbnVtYmVyX3QgaHdpcnEpCj4+PiArewo+Pj4gK8Kg
wqDCoCBpbnQgbWFzayA9IGh3aXJxICUgQklUU19QRVJfQllURTsKPj4gCj4+IG5pdDogdGhpcyBp
c24ndCBhIG1hc2ssIGJ1dCBhIHNoaWZ0IGluc3RlYWQuIEJJVChod2lycSAlIEJQQikgd291bGQg
Cj4+IGdpdmUKPj4geW91IGEgbWFzay4KPiAKPiBPaywgSSB3aWxsIGNvcnJlY3QgaXQuCj4gCj4+
IAo+Pj4gK8KgwqDCoCB2b2lkICp2YTsKPj4+ICvCoMKgwqAgdTggKnB0Owo+Pj4gKwo+Pj4gK8Kg
wqDCoCB2YSA9IHBhZ2VfYWRkcmVzcyh2cGUtPnZwdF9wYWdlKTsKPj4+ICvCoMKgwqAgcHQgPSB2
YSArIGh3aXJxIC8gQklUU19QRVJfQllURTsKPj4+ICsKPj4+ICvCoMKgwqAgcmV0dXJuICEhKCpw
dCAmICgxVSA8PCBtYXNrKSk7Cj4+PiArfQo+Pj4gKwo+Pj4gK3N0YXRpYyBpbnQgaXRzX2lycV9n
ZXRfaXJxY2hpcF9zdGF0ZShzdHJ1Y3QgaXJxX2RhdGEgKmQsCj4+PiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlbnVtIGlycWNoaXBfaXJxX3N0YXRlIHdoaWNoLCBi
b29sICp2YWwpCj4+PiArewo+Pj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX2RldmljZSAqaXRzX2RldiA9
IGlycV9kYXRhX2dldF9pcnFfY2hpcF9kYXRhKGQpOwo+Pj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX3Zs
cGlfbWFwICptYXAgPSBnZXRfdmxwaV9tYXAoZCk7Cj4+PiArCj4+PiArwqDCoMKgIGlmICh3aGlj
aCAhPSBJUlFDSElQX1NUQVRFX1BFTkRJTkcpCj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1F
SU5WQUw7Cj4+PiArCj4+PiArwqDCoMKgIC8qIG5vdCBpbnRlbmRlZCBmb3IgcGh5c2ljYWwgTFBJ
J3MgcGVuZGluZyBzdGF0ZSAqLwo+Pj4gK8KgwqDCoCBpZiAoIW1hcCkKPj4+ICvCoMKgwqDCoMKg
wqDCoCByZXR1cm4gLUVJTlZBTDsKPj4+ICsKPj4+ICvCoMKgwqAgLyoKPj4+ICvCoMKgwqDCoCAq
IEluIEdJQ3Y0LjEsIGEgVk1BUFAgd2l0aCB7VixBbGxvY309PXswLDF9IGNsZWFucyBhbmQgCj4+
PiBpbnZhbGlkYXRlcwo+Pj4gK8KgwqDCoMKgICogYW55IGNhY2hpbmcgb2YgdGhlIFZQVCBhc3Nv
Y2lhdGVkIHdpdGggdGhlIHZQRUlEIGhlbGQgaW4gdGhlIAo+Pj4gR0lDLgo+Pj4gK8KgwqDCoMKg
ICovCj4+PiArwqDCoMKgIGlmICghaXNfdjRfMShpdHNfZGV2LT5pdHMpIHx8IAo+Pj4gYXRvbWlj
X3JlYWQoJm1hcC0+dnBlLT52bWFwcF9jb3VudCkpCj4+IAo+PiBJdCBpc24ndCBjbGVhciB0byBt
ZSB3aGF0IHByZXZlbnRzIHRoaXMgZnJvbSByYWNpbmcgYWdhaW5zdCBhIG1hcHBpbmcgCj4+IG9m
Cj4+IHRoZSBWUEUuIEFjdHVhbGx5LCBzaW5jZSB3ZSBvbmx5IGhvbGQgdGhlIExQSSBpcnFkZXNj
IGxvY2ssIEknbSBwcmV0dHkgCj4+IHN1cmUKPj4gbm90aGluZyBwcmV2ZW50cyBpdC4KPiAKPiBZ
ZXMsIHNob3VsZCBoYXZlIHRoZSB2bW92cF9sb2NrIGhlbGQ/CgpUaGF0J3Mgbm90IGhlbHBpbmcg
YmVjYXVzZSBvZiB0aGUgVlBFIGFjdGl2YXRpb24uCgo+IEFuZCBpcyBpdCBuZWNlc3NhcnkgdG8g
YWxzbyBob2xkIHRoaXMgbG9jayBpbgo+IGl0c192cGVfaXJxX2RvbWFpbl9hY3RpdmF0ZS9kZWFj
dGl2YXRlPwoKV2VsbCwgeW91J2QgbmVlZCB0aGF0LCBidXQgdGhhdCdzIHVubmVjZXNzYXJ5IGNv
bXBsZXggQUZBSUNULgoKPiAKPj4gCj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FQUNDRVM7
Cj4+IAo+PiBJIGNhbiBzb3J0IG9mIGJ1eSBFQUNDRVNTIGZvciBhIFZQRSB0aGF0IGlzIGN1cnJl
bnRseSBtYXBwZWQsIGJ1dCBhIAo+PiBub24tNC4xCj4+IElUUyBzaG91bGQgZGVmaW5pdGVseSBy
ZXR1cm4gRUlOVkFMLgo+IAo+IEFscmlnaHQsIEVJTlZBTCBsb29rcyBiZXR0ZXIuCj4gCj4+IAo+
Pj4gKwo+Pj4gK8KgwqDCoCAqdmFsID0gaXRzX3BlZWtfdnB0KG1hcC0+dnBlLCBtYXAtPnZpbnRp
ZCk7Cj4+PiArCj4+PiArwqDCoMKgIHJldHVybiAwOwo+Pj4gK30KPj4+ICsKPj4+IMKgc3RhdGlj
IGludCBpdHNfaXJxX3NldF9pcnFjaGlwX3N0YXRlKHN0cnVjdCBpcnFfZGF0YSAqZCwKPj4+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlbnVtIGlycWNoaXBfaXJx
X3N0YXRlIHdoaWNoLAo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGJvb2wgc3RhdGUpCj4+PiBAQCAtMTk3NSw2ICsyMDEyLDcgQEAgc3RhdGljIHN0cnVjdCBp
cnFfY2hpcCBpdHNfaXJxX2NoaXAgPSB7Cj4+PiDCoMKgwqDCoCAuaXJxX2VvacKgwqDCoMKgwqDC
oMKgID0gaXJxX2NoaXBfZW9pX3BhcmVudCwKPj4+IMKgwqDCoMKgIC5pcnFfc2V0X2FmZmluaXR5
wqDCoMKgID0gaXRzX3NldF9hZmZpbml0eSwKPj4+IMKgwqDCoMKgIC5pcnFfY29tcG9zZV9tc2lf
bXNnwqDCoMKgID0gaXRzX2lycV9jb21wb3NlX21zaV9tc2csCj4+PiArwqDCoMKgIC5pcnFfZ2V0
X2lycWNoaXBfc3RhdGXCoMKgwqAgPSBpdHNfaXJxX2dldF9pcnFjaGlwX3N0YXRlLAo+PiAKPj4g
TXkgYmlnZ2VzdCBpc3N1ZSB3aXRoIHRoaXMgaXMgdGhhdCBpdCBpc24ndCBhIHJlbGlhYmxlIGlu
dGVyZmFjZS4KPj4gSXQgaGFwcGVucyB0byB3b3JrIGluIHRoZSBjb250ZXh0IG9mIEtWTSwgYmVj
YXVzZSB5b3UgbWFrZSBzdXJlIGl0Cj4+IGlzIGNhbGxlZCBhdCB0aGUgcmlnaHQgdGltZSwgYnV0
IHRoYXQgZG9lc24ndCBtYWtlIGl0IHNhZmUgaW4gZ2VuZXJhbAo+PiAoYW55b25lIHdpdGggdGhl
IGludGVycnVwdCBudW1iZXIgaXMgYWxsb3dlZCB0byBjYWxsIHRoaXMgYXQgYW55IAo+PiB0aW1l
KS4KPiAKPiBXZSBjaGVjayB0aGUgdm1hcHBfY291bnQgaW4gaXQgdG8gZW5zdXJlIHRoZSB1bm1h
cHBpbmcgb2YgdGhlIHZQRSwgYW5kCj4gbGV0IHRoZSBjYWxsZXIgZG8gdGhlIHVubWFwcGluZyAo
dGhleSBzaG91bGQga25vdyB3aGV0aGVyIGl0IGlzIHRoZSAKPiByaWdodAo+IHRpbWUpLiBJZiB0
aGUgdW5tYXBwaW5nIGlzIG5vdCBkb25lLCBqdXN0IHJldHVybiBhIGZhaWx1cmUuCgpBbmQgd2l0
aG91dCBndWFyYW50ZWVpbmcgbXV0dWFsIGV4Y2x1c2lvbiBhZ2FpbnN0IGEgY29uY3VycmVudCBW
TUFQUCwKY2hlY2tpbmcgdGhlIHZtYXBwX2NvdW50IG1lYW5zIG5vdGhpbmcgKHlvdSBuZWVkIHRo
ZSBsb2NrIGRlc2NyaWJlZAphYm92ZSwgYW5kIHN0YXJ0IHNwcmlua2xpbmcgaXQgYXJvdW5kIGlu
IG90aGVyIHBsYWNlcyBhcyB3ZWxsKS4KCj4+IAo+PiBJcyB0aGVyZSBhIHByb2JsZW0gd2l0aCBw
b2tpbmcgYXQgdGhlIFZQVCBwYWdlIGZyb20gdGhlIEtWTSBzaWRlPwo+PiBUaGUgY29kZSBzaG91
bGQgYmUgZXhhY3RseSB0aGUgc2FtZSAobWF5YmUgc2ltcGxlciBldmVuKSwgYW5kIGF0IGxlYXN0
Cj4+IHlvdSdkIGJlIGd1YXJhbnRlZWQgdG8gYmUgaW4gdGhlIGNvcnJlY3QgY29udGV4dC4KPiAK
PiBZZWFoLCB0aGF0IGFsc28gc2VlbXMgYSBnb29kIGNob2ljZS4KPiBJZiB5b3UgcHJlZmVyIGl0
LCB3ZSBjYW4gdHJ5IHRvIHJlYWxpemUgaXQgaW4gdjIuCgpJJ2QgY2VydGFpbmx5IHByZWZlciB0
aGF0LiBMZXQgbWUga25vdyBpZiB5b3Ugc3BvdCBhbnkgaW1wbGVtZW50YXRpb24KaXNzdWUgd2l0
aCB0aGF0LgoKVGhhbmtzLAoKICAgICAgICAgTS4KLS0gCkphenogaXMgbm90IGRlYWQuIEl0IGp1
c3Qgc21lbGxzIGZ1bm55Li4uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVk
dQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
