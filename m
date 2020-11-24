Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AFBC56201
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 08:45:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D0A5D2075A
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 08:45:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1emCflw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0A5D2075A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F8E24BCE8;
	Tue, 24 Nov 2020 03:45:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jAom1g7H7IgR; Tue, 24 Nov 2020 03:45:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F52A4BD4A;
	Tue, 24 Nov 2020 03:45:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA6654BD1D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 03:45:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UtlpZ0ZBvCBQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 03:45:03 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 915B14BCE8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 03:45:03 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 41E362073C;
 Tue, 24 Nov 2020 08:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606207502;
 bh=xCFPFws3rl+rLs/hXsg30ZbSaEzwkNeXgxTpyEHJHGQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=j1emCflw6I0voluiwaNY3BYc4EZplrGs1OCSYe2Yqa0SJJtsdXs0hai6AgbirClTe
 qG89f8UrVqAbfxF11nmuYpnxOTumpsxfG9wd/q1u/ycmgucSruD9YK4nlqp+cu0dGw
 y9/MzlWVYFZePeBDuT6oqJLyp0qBCJrXKeZgDPSs=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa (TLS1.2) tls
 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1khTwZ-00DBsM-Tw; Tue, 24 Nov 2020 08:45:00 +0000
MIME-Version: 1.0
Date: Tue, 24 Nov 2020 08:44:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: Shenming Lu <lushenming@huawei.com>
Subject: Re: [RFC PATCH v1 3/4] KVM: arm64: GICv4.1: Restore VLPI's pending
 state to physical side
In-Reply-To: <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-4-lushenming@huawei.com>
 <5c724bb83730cdd5dcf7add9a812fa92@kernel.org>
 <b03edcf2-2950-572f-fd31-601d8d766c80@huawei.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <2d2bcae4f871d239a1af50362f5c11a4@kernel.org>
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

T24gMjAyMC0xMS0yNCAwODoxMCwgU2hlbm1pbmcgTHUgd3JvdGU6Cj4gT24gMjAyMC8xMS8yMyAx
NzoyNywgTWFyYyBaeW5naWVyIHdyb3RlOgo+PiBPbiAyMDIwLTExLTIzIDA2OjU0LCBTaGVubWlu
ZyBMdSB3cm90ZToKPj4+IEZyb206IFplbmdodWkgWXUgPHl1emVuZ2h1aUBodWF3ZWkuY29tPgo+
Pj4gCj4+PiBXaGVuIHNldHRpbmcgdGhlIGZvcndhcmRpbmcgcGF0aCBvZiBhIFZMUEksIGl0IGlz
IG1vcmUgY29uc2lzdGVudCB0bwo+PiAKPj4gSSdtIG5vdCBzdXJlIGl0IGlzIG1vcmUgY29uc2lz
dGVudC4gSXQgaXMgYSAqbmV3KiBiZWhhdmlvdXIsIGJlY2F1c2UgCj4+IGl0IG9ubHkKPj4gbWF0
dGVycyBmb3IgbWlncmF0aW9uLCB3aGljaCBoYXMgYmVlbiBzbyBmYXIgdW5zdXBwb3J0ZWQuCj4g
Cj4gQWxyaWdodCwgY29uc2lzdGVudCBtYXkgbm90IGJlIGFjY3VyYXRlLi4uCj4gQnV0IEkgaGF2
ZSBkb3VidCB0aGF0IHdoZXRoZXIgdGhlcmUgaXMgcmVhbGx5IG5vIG5lZWQgdG8gdHJhbnNmZXIg
dGhlCj4gcGVuZGluZyBzdGF0ZXMKPiBmcm9tIGt2bSd2Z2ljIHRvIFZQVCBpbiBzZXRfZm9yd2Fy
ZGluZyByZWdhcmRsZXNzIG9mIG1pZ3JhdGlvbiwgYW5kIHRoZSAKPiBzaW1pbGFyCj4gZm9yIHVu
c2V0X2ZvcndhcmRpbmcuCgpJZiB5b3UgaGF2ZSB0byB0cmFuc2ZlciB0aGF0IHN0YXRlIG91dHNp
ZGUgb2YgdGhlIGEgc2F2ZS9yZXN0b3JlLCBpdCAKbWVhbnMgdGhhdAp5b3UgaGF2ZSBtaXNzZWQg
dGhlIHByb2dyYW1taW5nIG9mIHRoZSBQQ0kgZW5kcG9pbnQuIFRoaXMgaXMgYW4gCmVzdGFibGlz
aGVkCnJlc3RyaWN0aW9uIHRoYXQgdGhlIE1TSSBwcm9ncmFtbWluZyBtdXN0IG9jY3VyICphZnRl
ciogdGhlIHRyYW5zbGF0aW9uIApoYXMKYmVlbiBlc3RhYmxpc2hlZCB1c2luZyBNQVBJL01BUFRJ
IChzZWUgdGhlIGxhcmdlIGNvbW1lbnQgYXQgdGhlIApiZWdpbm5pbmcgb2YKdmdpYy12NC5jKS4K
CklmIHlvdSB3YW50IHRvIHJldmlzaXQgdGhpcywgZmFpciBlbm91Z2guIEJ1dCB5b3Ugd2lsbCBu
ZWVkIGEgbG90IG1vcmUgCnRoYW4KanVzdCBvcHBvcnR1bmlzdGljYWxseSB0cmFuc2ZlciB0aGUg
cGVuZGluZyBzdGF0ZS4KCj4gCj4+IAo+Pj4gYWxzbyB0cmFuc2ZlciB0aGUgcGVuZGluZyBzdGF0
ZSBmcm9tIGlycS0+cGVuZGluZ19sYXRjaCB0byBWUFQgCj4+PiAoZXNwZWNpYWxseQo+Pj4gaW4g
bWlncmF0aW9uLCB0aGUgcGVuZGluZyBzdGF0ZXMgb2YgVkxQSXMgYXJlIHJlc3RvcmVkIGludG8g
a3Zt4oCZcyAKPj4+IHZnaWMKPj4+IGZpcnN0KS4gQW5kIHdlIGN1cnJlbnRseSBzZW5kICJJTlQr
VlNZTkMiIHRvIHRyaWdnZXIgYSBWTFBJIHRvIAo+Pj4gcGVuZGluZy4KPj4+IAo+Pj4gU2lnbmVk
LW9mZi1ieTogWmVuZ2h1aSBZdSA8eXV6ZW5naHVpQGh1YXdlaS5jb20+Cj4+PiBTaWduZWQtb2Zm
LWJ5OiBTaGVubWluZyBMdSA8bHVzaGVubWluZ0BodWF3ZWkuY29tPgo+Pj4gLS0tCj4+PiDCoGFy
Y2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12NC5jIHwgMTIgKysrKysrKysrKysrCj4+PiDCoDEgZmls
ZSBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspCj4+PiAKPj4+IGRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L2t2bS92Z2ljL3ZnaWMtdjQuYyAKPj4+IGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0
LmMKPj4+IGluZGV4IGI1ZmE3M2M5ZmQzNS4uY2MzYWI5Y2VhMTgyIDEwMDY0NAo+Pj4gLS0tIGEv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXY0LmMKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3Zn
aWMvdmdpYy12NC5jCj4+PiBAQCAtNDE4LDYgKzQxOCwxOCBAQCBpbnQga3ZtX3ZnaWNfdjRfc2V0
X2ZvcndhcmRpbmcoc3RydWN0IGt2bSAqa3ZtLCAKPj4+IGludCB2aXJxLAo+Pj4gwqDCoMKgwqAg
aXJxLT5ob3N0X2lyccKgwqDCoCA9IHZpcnE7Cj4+PiDCoMKgwqDCoCBhdG9taWNfaW5jKCZtYXAu
dnBlLT52bHBpX2NvdW50KTsKPj4+IAo+Pj4gK8KgwqDCoCAvKiBUcmFuc2ZlciBwZW5kaW5nIHN0
YXRlICovCj4+PiArwqDCoMKgIHJldCA9IGlycV9zZXRfaXJxY2hpcF9zdGF0ZShpcnEtPmhvc3Rf
aXJxLAo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIElSUUNISVBf
U1RBVEVfUEVORElORywKPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBpcnEtPnBlbmRpbmdfbGF0Y2gpOwo+Pj4gK8KgwqDCoCBXQVJOX1JBVEVMSU1JVChyZXQsICJJ
UlEgJWQiLCBpcnEtPmhvc3RfaXJxKTsKPj4+ICsKPj4+ICvCoMKgwqAgLyoKPj4+ICvCoMKgwqDC
oCAqIExldCBpdCBiZSBwcnVuZWQgZnJvbSBhcF9saXN0IGxhdGVyIGFuZCBkb24ndCBib3RoZXIK
Pj4+ICvCoMKgwqDCoCAqIHRoZSBMaXN0IFJlZ2lzdGVyLgo+Pj4gK8KgwqDCoMKgICovCj4+PiAr
wqDCoMKgIGlycS0+cGVuZGluZ19sYXRjaCA9IGZhbHNlOwo+PiAKPj4gSXQgb2NjdXJzIHRvIG1l
IHRoYXQgY2FsbGluZyBpbnRvIGlycV9zZXRfaXJxY2hpcF9zdGF0ZSgpIGZvciBhIGxhcmdlCj4+
IG51bWJlciBvZiBpbnRlcnJ1cHRzIGNhbiB0YWtlIGEgc2lnbmlmaWNhbnQgYW1vdW50IG9mIHRp
bWUuIEl0IGlzIGFsc28KPj4gb2RkIHRoYXQgeW91IGR1bXAgdGhlIFZQVCB3aXRoIHRoZSBWUEUg
dW5tYXBwZWQsIGJ1dCByZWx5IG9uIHRoZSBWUEUKPj4gYmVpbmcgbWFwcGVkIGZvciB0aGUgb3Bw
b3NpdGUgb3BlcmF0aW9uLgo+PiAKPj4gU2hvdWxkbid0IHRoZXNlIGJlIHN5bW1ldHJpYywgYWxs
IHBlcmZvcm1lZCB3aGlsZSB0aGUgVlBFIGlzIHVubWFwcGVkPwo+PiBJdCB3b3VsZCBhbHNvIHNh
dmUgYSBsb3Qgb2YgSVRTIHRyYWZmaWMuCj4+IAo+IAo+IE15IHRob3VnaHQgd2FzIHRvIHVzZSB0
aGUgZXhpc3RpbmcgaW50ZXJmYWNlIGRpcmVjdGx5IHdpdGhvdXQgCj4gdW5tYXBwaW5nLi4uCj4g
Cj4gSWYgeW91IHdhbnQgdG8gdW5tYXAgdGhlIHZQRSBhbmQgcG9rZSB0aGUgVlBUIGhlcmUsIGFz
IEkgc2FpZCBpbiB0aGUgCj4gY292ZXIKPiBsZXR0ZXIsIHNldC91bnNldF9mb3J3YXJkaW5nIG1p
Z2h0IGFsc28gYmUgY2FsbGVkIHdoZW4gYWxsIGRldmljZXMgYXJlIAo+IHJ1bm5pbmcKPiBhdCBu
b3JtYWwgcnVuIHRpbWUsIGluIHdoaWNoIGNhc2UgdGhlIHVubWFwcGluZyBvZiB0aGUgdlBFIGlz
IG5vdCAKPiBhbGxvd2VkLi4uCgpObywgSSdtIHN1Z2dlc3RpbmcgdGhhdCB5b3UgZG9uJ3QgZG8g
YW55dGhpbmcgaGVyZSwgYnV0IGluc3RlYWQgYXMgYSAKYnktcHJvZHVjdApvZiByZXN0b3Jpbmcg
dGhlIElUUyB0YWJsZXMuIFdoYXQgZ29lcyB3cm9uZyBpZiB5b3UgdXNlIHRoZQpLVk1fREVWX0FS
TV9JVFNfUkVTVE9SRV9UQUJMRSBiYWNrZW5kIGluc3RlYWQ/Cgo+IEFub3RoZXIgcG9zc2libGUg
c29sdXRpb24gaXMgdG8gYWRkIGEgbmV3IGRlZGljYXRlZCBpbnRlcmZhY2UgdG8gUUVNVQo+IHRv
IHRyYW5zZmVyCj4gdGhlc2UgcGVuZGluZyBzdGF0ZXMgdG8gSFcgaW4gR0lDIFZNIHN0YXRlIGNo
YW5nZSBoYW5kbGVyIGNvcnJlc3BvbmRpbmcgCj4gdG8KPiBzYXZlX3BlbmRpbmdfdGFibGVzPwoK
VXNlcnNwYWNlIGhhcyBubyB3YXkgdG8ga25vdyB3ZSB1c2UgR0lDdjQsIGFuZCBJIGludGVuZCB0
byBrZWVwIGl0CmNvbXBsZXRlbHkgb3V0IG9mIHRoZSBsb29wLiBUaGUgQVBJIGlzIGFscmVhZHkg
cHJldHR5IHRvcnR1b3VzLCBhbmQKSSByZWFsbHkgZG9uJ3Qgd2FudCB0byBhZGQgYW55IGV4dHJh
IGNvbXBsZXhpdHkgdG8gaXQuCgpUaGFua3MsCgogICAgICAgICBNLgotLSAKSmF6eiBpcyBub3Qg
ZGVhZC4gSXQganVzdCBzbWVsbHMgZnVubnkuLi4KX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
