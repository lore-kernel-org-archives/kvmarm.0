Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736AEC2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 08:27:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A0A212085B
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 08:27:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzSuDDeB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0A212085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9D5F4BB10;
	Tue, 24 Nov 2020 03:27:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ctrd1WjXYjnu; Tue, 24 Nov 2020 03:27:02 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 450004BB2E;
	Tue, 24 Nov 2020 03:27:02 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31B9D4BB24
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 03:27:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 50Wb9aEsjJuw for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 03:26:59 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 904674BB10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 03:26:59 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 293F220870;
 Tue, 24 Nov 2020 08:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606206418;
 bh=YCvAHBNcK4JrFhb6WFO3tG22p20ZWh3it7ak5hEvG2I=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=DzSuDDeBaz/h0qW7OiRtKhYC5Y7L3qQx5larBizrKvm42cruk2f03ei1/RN4SR/Wr
 VSq9y/dhO+f009B8o9oyOsJQZerIHcfaAvtZjq1hE5/nGqXOA5oGkdNmfMyTUC0dNJ
 eR9lbz+Lh/m3jdkMri6N7jXDJshrGda3DKeHP0pM=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1khTf5-00DBXE-Ui; Tue, 24 Nov 2020 08:26:56 +0000
MIME-Version: 1.0
Date: Tue, 24 Nov 2020 08:26:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [RFC PATCH v1 2/4] KVM: arm64: GICv4.1: Try to save hw pending
 state in save_pending_tables
In-Reply-To: <90f04f50-c1ba-55b2-0f93-1e755b40b487@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-3-lushenming@huawei.com>
 <f3ea1b24436bb86b5a5633f8ccc9b3d1@kernel.org>
 <90f04f50-c1ba-55b2-0f93-1e755b40b487@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <4e2b87897485e38e251c447b9ad70eb6@kernel.org>
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

T24gMjAyMC0xMS0yNCAwNzo0MCwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gT24gMjAyMC8xMS8yMyAx
NzoxOCwgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBPbiAyMDIwLTExLTIzIDA2OjU0LCBTaGVubWlu
ZyBMdSB3cm90ZToKPj4+IEFmdGVyIHBhdXNpbmcgYWxsIHZDUFVzIGFuZCBkZXZpY2VzIGNhcGFi
bGUgb2YgaW50ZXJydXB0aW5nLCBpbiBvcmRlcgo+PiDCoMKgwqDCoMKgwqDCoCBeXl5eXl5eXl5e
Xl5eXl5eXgo+PiBTZWUgbXkgY29tbWVudCBiZWxvdyBhYm91dCB0aGlzLgo+PiAKPj4+IHRvIHNh
dmUgdGhlIGluZm9ybWF0aW9uIG9mIGFsbCBpbnRlcnJ1cHRzLCBiZXNpZGVzIGZsdXNoaW5nIHRo
ZSAKPj4+IHBlbmRpbmcKPj4+IHN0YXRlcyBpbiBrdm3igJlzIHZnaWMsIHdlIGFsc28gdHJ5IHRv
IGZsdXNoIHRoZSBzdGF0ZXMgb2YgVkxQSXMgaW4gdGhlCj4+PiB2aXJ0dWFsIHBlbmRpbmcgdGFi
bGVzIGludG8gZ3Vlc3QgUkFNLCBidXQgd2UgbmVlZCB0byBoYXZlIEdJQ3Y0LjEgCj4+PiBhbmQK
Pj4+IHNhZmVseSB1bm1hcCB0aGUgdlBFcyBmaXJzdC4KPj4+IAo+Pj4gU2lnbmVkLW9mZi1ieTog
U2hlbm1pbmcgTHUgPGx1c2hlbm1pbmdAaHVhd2VpLmNvbT4KPj4+IC0tLQo+Pj4gwqBhcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtdjMuYyB8IDYyIAo+Pj4gKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLS0KPj4+IMKgMSBmaWxlIGNoYW5nZWQsIDU2IGluc2VydGlvbnMoKyksIDYgZGVs
ZXRpb25zKC0pCj4+PiAKPj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
djMuYyAKPj4+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMKPj4+IGluZGV4IDljZGYz
OWE5NGE2My4uZTFiM2FhNGIyYjEyIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLXYzLmMKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jCj4+PiBA
QCAtMSw2ICsxLDggQEAKPj4+IMKgLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAt
b25seQo+Pj4gCj4+PiDCoCNpbmNsdWRlIDxsaW51eC9pcnFjaGlwL2FybS1naWMtdjMuaD4KPj4+
ICsjaW5jbHVkZSA8bGludXgvaXJxLmg+Cj4+PiArI2luY2x1ZGUgPGxpbnV4L2lycWRvbWFpbi5o
Pgo+Pj4gwqAjaW5jbHVkZSA8bGludXgva3ZtLmg+Cj4+PiDCoCNpbmNsdWRlIDxsaW51eC9rdm1f
aG9zdC5oPgo+Pj4gwqAjaW5jbHVkZSA8a3ZtL2FybV92Z2ljLmg+Cj4+PiBAQCAtMzU2LDYgKzM1
OCwzOSBAQCBpbnQgdmdpY192M19scGlfc3luY19wZW5kaW5nX3N0YXR1cyhzdHJ1Y3Qga3ZtCj4+
PiAqa3ZtLCBzdHJ1Y3QgdmdpY19pcnEgKmlycSkKPj4+IMKgwqDCoMKgIHJldHVybiAwOwo+Pj4g
wqB9Cj4+PiAKPj4+ICsvKgo+Pj4gKyAqIFdpdGggR0lDdjQuMSwgd2UgY2FuIGdldCB0aGUgVkxQ
SSdzIHBlbmRpbmcgc3RhdGUgYWZ0ZXIgdW5tYXBwaW5nCj4+PiArICogdGhlIHZQRS4gVGhlIGRl
YWN0aXZhdGlvbiBvZiB0aGUgZG9vcmJlbGwgaW50ZXJydXB0IHdpbGwgdHJpZ2dlcgo+Pj4gKyAq
IHRoZSB1bm1hcHBpbmcgb2YgdGhlIGFzc29jaWF0ZWQgdlBFLgo+Pj4gKyAqLwo+Pj4gK3N0YXRp
YyB2b2lkIGdldF92bHBpX3N0YXRlX3ByZShzdHJ1Y3QgdmdpY19kaXN0ICpkaXN0KQo+Pj4gK3sK
Pj4+ICvCoMKgwqAgc3RydWN0IGlycV9kZXNjICpkZXNjOwo+Pj4gK8KgwqDCoCBpbnQgaTsKPj4+
ICsKPj4+ICvCoMKgwqAgaWYgKCFrdm1fdmdpY19nbG9iYWxfc3RhdGUuaGFzX2dpY3Y0XzEpCj4+
PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuOwo+Pj4gKwo+Pj4gK8KgwqDCoCBmb3IgKGkgPSAwOyBp
IDwgZGlzdC0+aXRzX3ZtLm5yX3ZwZXM7IGkrKykgewo+Pj4gK8KgwqDCoMKgwqDCoMKgIGRlc2Mg
PSBpcnFfdG9fZGVzYyhkaXN0LT5pdHNfdm0udnBlc1tpXS0+aXJxKTsKPj4+ICvCoMKgwqDCoMKg
wqDCoCBpcnFfZG9tYWluX2RlYWN0aXZhdGVfaXJxKGlycV9kZXNjX2dldF9pcnFfZGF0YShkZXNj
KSk7Cj4+PiArwqDCoMKgIH0KPj4+ICt9Cj4+PiArCj4+PiArc3RhdGljIHZvaWQgZ2V0X3ZscGlf
c3RhdGVfcG9zdChzdHJ1Y3QgdmdpY19kaXN0ICpkaXN0KQo+PiAKPj4gbml0OiB0aGUgbmFtaW5n
IGZlZWxzIGEgYml0Li4uIG9kZC4gUHJlL3Bvc3Qgd2hhdD8KPiAKPiBNeSB1bmRlcnN0YW5kaW5n
IGlzIHRoYXQgdGhlIHVubWFwcGluZyBpcyBhIHByZXBhcmF0aW9uIGZvciAKPiBnZXRfdmxwaV9z
dGF0ZS4uLgo+IE1heWJlIGp1c3QgY2FsbCBpdCB1bm1hcC9tYXBfYWxsX3ZwZXM/CgpZZXMsIG11
Y2ggYmV0dGVyLgoKWy4uLl0KCj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGlycS0+aHcpIHsKPj4+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFdBUk5fUkFURUxJTUlUKGlycV9nZXRfaXJxY2hpcF9z
dGF0ZShpcnEtPmhvc3RfaXJxLAo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgSVJRQ0hJUF9TVEFURV9QRU5ESU5HLCAmaXNfcGVuZGluZyksCj4+PiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIklSUSAlZCIsIGly
cS0+aG9zdF9pcnEpOwo+PiAKPj4gSXNuJ3QgdGhpcyBnb2luZyB0byB3YXJuIGxpa2UgbWFkIG9u
IGEgR0lDdjQuMCBzeXN0ZW0gd2hlcmUgdGhpcywgYnkgCj4+IGRlZmluaXRpb24sCj4+IHdpbGwg
Z2VuZXJhdGUgYW4gZXJyb3I/Cj4gCj4gQXMgd2UgaGF2ZSByZXR1cm5lZCBhbiBlcnJvciBpbiBz
YXZlX2l0c190YWJsZXMgaWYgaHcgJiYgIWhhc19naWN2NF8xLCAKPiB3ZSBkb24ndAo+IGhhdmUg
dG8gd2FybiB0aGlzIGhlcmU/CgpBcmUgeW91IHJlZmVycmluZyB0byB0aGUgY2hlY2sgaW4gdmdp
Y19pdHNfc2F2ZV9pdHQoKSB0aGF0IG9jY3VycyBpbiAKcGF0Y2ggND8KRmFpciBlbm91Z2gsIHRo
b3VnaCBJIHRoaW5rIHRoZSB1c2Ugb2YgaXJxX2dldF9pcnFjaGlwX3N0YXRlKCkgaXNuJ3QgCnF1
aXRlCndoYXQgd2Ugd2FudCwgYXMgcGVyIG15IGNvbW1lbnRzIG9uIHBhdGNoICMxLgoKPj4gCj4+
PiArwqDCoMKgwqDCoMKgwqAgfQo+Pj4gKwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmIChzdG9yZWQg
PT0gaXNfcGVuZGluZykKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsKPj4+
IAo+Pj4gLcKgwqDCoMKgwqDCoMKgIGlmIChpcnEtPnBlbmRpbmdfbGF0Y2gpCj4+PiArwqDCoMKg
wqDCoMKgwqAgaWYgKGlzX3BlbmRpbmcpCj4+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmFs
IHw9IDEgPDwgYml0X25yOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoCBlbHNlCj4+PiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgdmFsICY9IH4oMSA8PCBiaXRfbnIpOwo+Pj4gCj4+PiDCoMKgwqDCoMKg
wqDCoMKgIHJldCA9IGt2bV93cml0ZV9ndWVzdF9sb2NrKGt2bSwgcHRyLCAmdmFsLCAxKTsKPj4+
IMKgwqDCoMKgwqDCoMKgwqAgaWYgKHJldCkKPj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJl
dHVybiByZXQ7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsKPj4+IMKgwqDC
oMKgIH0KPj4+IC3CoMKgwqAgcmV0dXJuIDA7Cj4+PiArCj4+PiArb3V0Ogo+Pj4gK8KgwqDCoCBn
ZXRfdmxwaV9zdGF0ZV9wb3N0KGRpc3QpOwo+PiAKPj4gVGhpcyBiaXQgd29ycmllcyBtZTogeW91
IGhhdmUgdW5tYXBwZWQgdGhlIFZQRXMsIHNvIGFueSBpbnRlcnJ1cHQgdGhhdCAKPj4gaGFzIGJl
ZW4KPj4gZ2VuZXJhdGVkIGR1cmluZyB0aGF0IHBoYXNlIGlzIG5vdyBmb3JldmVyIGxvc3QgKHRo
ZSBHSUMgZG9lc24ndCBoYXZlIAo+PiBvd25lcnNoaXAKPj4gb2YgdGhlIHBlbmRpbmcgdGFibGVz
KS4KPiAKPiBJbiBteSBvcGluaW9uLCBkdXJpbmcgdGhpcyBwaGFzZSwgdGhlIGRldmljZXMgY2Fw
YWJsZSBvZiBpbnRlcnJ1cHRpbmcKPiBzaG91bGQgaGF2ZSAgYWxyZWFkeSBiZWVuIHBhdXNlZCAo
cHJldmVudCBmcm9tIHNlbmRpbmcgaW50ZXJydXB0cyksCj4gc3VjaCBhcyBWRklPIG1pZ3JhdGlv
biBwcm90b2NvbCBoYXMgYWxyZWFkeSByZWFsaXplZCBpdC4KCklzIHRoYXQgYSBoYXJkIGd1YXJh
bnRlZT8gUGF1c2luZyBkZXZpY2VzICptYXkqIGJlIHBvc3NpYmxlIGZvciBhIApsaW1pdGVkCnNl
dCBvZiBlbmRwb2ludHMsIGJ1dCBJJ20gbm90IHN1cmUgdGhhdCBpcyB1bml2ZXJzYWxseSBwb3Nz
aWJsZSB0byAKcmVzdGFydAp0aGVtIGFuZCBleHBlY3QgYSBjb25zaXN0ZW50IHN0YXRlICh5b3Ug
aGF2ZSBqdXN0IGRyb3BwZWQgYSBidW5jaCBvZiAKbmV0d29yawpwYWNrZXRzIG9uIHRoZSBmbG9v
ci4uLikuCgo+PiBEbyB5b3UgcmVhbGx5IGV4cGVjdCB0aGUgVk0gdG8gYmUgcmVzdGFydGFibGUg
ZnJvbSB0aGF0IHBvaW50PyBJIGRvbid0IAo+PiBzZWUgaG93Cj4+IHRoaXMgaXMgcG9zc2libGUu
Cj4+IAo+IAo+IElmIHRoZSBtaWdyYXRpb24gaGFzIGVuY291bnRlcmVkIGFuIGVycm9yLCB0aGUg
c3JjIFZNIG1pZ2h0IGJlCj4gcmVzdGFydGVkLCBzbyB3ZSBoYXZlIHRvIG1hcCB0aGUgdlBFcyBi
YWNrLgoKQXMgSSBzYWlkIGFib3ZlLCBJIGRvdWJ0IGl0IGlzIHVuaXZlcnNhbGx5IHBvc3NpYmxl
IHRvIGRvIHNvLCBidXQKYWZ0ZXIgYWxsLCB0aGlzIHByb2JhYmx5IGlzbid0IHdvcnNlIHRoYXQg
cmVzdGFydGluZyBvbiB0aGUgdGFyZ2V0Li4uCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3Qg
ZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
