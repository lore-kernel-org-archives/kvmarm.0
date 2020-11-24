Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB534C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:49:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 69D0820738
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:49:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 69D0820738
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 847104BD3F;
	Tue, 24 Nov 2020 09:49:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QvBnpeAUfuxE; Tue, 24 Nov 2020 09:49:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D0F54BD9F;
	Tue, 24 Nov 2020 09:49:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 581044BD06
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 02:38:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NUolimP2gqBp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 02:38:48 -0500 (EST)
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 82BF54BCFC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 02:38:47 -0500 (EST)
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
 by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CgG90577CzhfY3;
 Tue, 24 Nov 2020 15:38:28 +0800 (CST)
Received: from [10.174.187.74] (10.174.187.74) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 15:38:32 +0800
Subject: Re: [RFC PATCH v1 1/4] irqchip/gic-v4.1: Plumb get_irqchip_state VLPI
 callback
To: Marc Zyngier <maz@kernel.org>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-2-lushenming@huawei.com>
 <f64703b618a2ebc6c6f5c423e2b779c6@kernel.org>
From: Shenming Lu <lushenming@huawei.com>
Message-ID: <7bc7e428-cfd5-6171-dc1e-4be097c46690@huawei.com>
Date: Tue, 24 Nov 2020 15:38:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <f64703b618a2ebc6c6f5c423e2b779c6@kernel.org>
Content-Language: en-US
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
X-Mailman-Approved-At: Tue, 24 Nov 2020 09:49:14 -0500
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMjAyMC8xMS8yMyAxNzowMSwgTWFyYyBaeW5naWVyIHdyb3RlOgo+IE9uIDIwMjAtMTEtMjMg
MDY6NTQsIFNoZW5taW5nIEx1IHdyb3RlOgo+PiBGcm9tOiBaZW5naHVpIFl1IDx5dXplbmdodWlA
aHVhd2VpLmNvbT4KPj4KPj4gVXAgdG8gbm93LCB0aGUgaXJxX2dldF9pcnFjaGlwX3N0YXRlKCkg
Y2FsbGJhY2sgb2YgaXRzX2lycV9jaGlwCj4+IGxlYXZlcyB1bmltcGxlbWVudGVkIHNpbmNlIHRo
ZXJlIGlzIG5vIGFyY2hpdGVjdHVyYWwgd2F5IHRvIGdldAo+PiB0aGUgVkxQSSdzIHBlbmRpbmcg
c3RhdGUgYmVmb3JlIEdJQ3Y0LjEuIFllYWgsIHRoZXJlIGhhcyBvbmUgaW4KPj4gdjQuMSBmb3Ig
VkxQSXMuCj4+Cj4+IFdpdGggR0lDdjQuMSwgYWZ0ZXIgdW5tYXBwaW5nIHRoZSB2UEUsIHdoaWNo
IGNsZWFucyBhbmQgaW52YWxpZGF0ZXMKPj4gYW55IGNhY2hpbmcgb2YgdGhlIFZQVCwgd2UgY2Fu
IGdldCB0aGUgVkxQSSdzIHBlbmRpbmcgc3RhdGUgYnkKPiAKPiBUaGlzIGlzIGEgY3J1Y2lhbCBu
b3RlOiB3aXRob3V0IHRoaXMgdW5tYXBwaW5nIGFuZCBpbnZhbGlkYXRpb24sCj4gdGhlIHBlbmRp
bmcgYml0cyBhcmUgbm90IGdlbmVyYWxseSBhY2Nlc3NpYmxlICh0aGV5IGNvdWxkIGJlIGNhY2hl
ZAo+IGluIGEgR0lDIHByaXZhdGUgc3RydWN0dXJlLCBjYWNoZSBvciBvdGhlcndpc2UpLgo+IAo+
PiBwZWVraW5nIGF0IHRoZSBWUFQuIFNvIHdlIGltcGxlbWVudCB0aGUgaXJxX2dldF9pcnFjaGlw
X3N0YXRlKCkKPj4gY2FsbGJhY2sgb2YgaXRzX2lycV9jaGlwIHRvIGRvIGl0Lgo+Pgo+PiBTaWdu
ZWQtb2ZmLWJ5OiBaZW5naHVpIFl1IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPj4gU2lnbmVkLW9m
Zi1ieTogU2hlbm1pbmcgTHUgPGx1c2hlbm1pbmdAaHVhd2VpLmNvbT4KPj4gLS0tCj4+IMKgZHJp
dmVycy9pcnFjaGlwL2lycS1naWMtdjMtaXRzLmMgfCAzOCArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKwo+PiDCoDEgZmlsZSBjaGFuZ2VkLCAzOCBpbnNlcnRpb25zKCspCj4+Cj4+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYyBiL2RyaXZlcnMvaXJx
Y2hpcC9pcnEtZ2ljLXYzLWl0cy5jCj4+IGluZGV4IDBmZWMzMTkzMWUxMS4uMjg3MDAzY2FjYWM3
IDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYwo+PiArKysg
Yi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYwo+PiBAQCAtMTY5NSw2ICsxNjk1LDQz
IEBAIHN0YXRpYyB2b2lkIGl0c19pcnFfY29tcG9zZV9tc2lfbXNnKHN0cnVjdAo+PiBpcnFfZGF0
YSAqZCwgc3RydWN0IG1zaV9tc2cgKm1zZykKPj4gwqDCoMKgwqAgaW9tbXVfZG1hX2NvbXBvc2Vf
bXNpX21zZyhpcnFfZGF0YV9nZXRfbXNpX2Rlc2MoZCksIG1zZyk7Cj4+IMKgfQo+Pgo+PiArc3Rh
dGljIGJvb2wgaXRzX3BlZWtfdnB0KHN0cnVjdCBpdHNfdnBlICp2cGUsIGlycV9od19udW1iZXJf
dCBod2lycSkKPj4gK3sKPj4gK8KgwqDCoCBpbnQgbWFzayA9IGh3aXJxICUgQklUU19QRVJfQllU
RTsKPiAKPiBuaXQ6IHRoaXMgaXNuJ3QgYSBtYXNrLCBidXQgYSBzaGlmdCBpbnN0ZWFkLiBCSVQo
aHdpcnEgJSBCUEIpIHdvdWxkIGdpdmUKPiB5b3UgYSBtYXNrLgoKT2ssIEkgd2lsbCBjb3JyZWN0
IGl0LgoKPiAKPj4gK8KgwqDCoCB2b2lkICp2YTsKPj4gK8KgwqDCoCB1OCAqcHQ7Cj4+ICsKPj4g
K8KgwqDCoCB2YSA9IHBhZ2VfYWRkcmVzcyh2cGUtPnZwdF9wYWdlKTsKPj4gK8KgwqDCoCBwdCA9
IHZhICsgaHdpcnEgLyBCSVRTX1BFUl9CWVRFOwo+PiArCj4+ICvCoMKgwqAgcmV0dXJuICEhKCpw
dCAmICgxVSA8PCBtYXNrKSk7Cj4+ICt9Cj4+ICsKPj4gK3N0YXRpYyBpbnQgaXRzX2lycV9nZXRf
aXJxY2hpcF9zdGF0ZShzdHJ1Y3QgaXJxX2RhdGEgKmQsCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIGVudW0gaXJxY2hpcF9pcnFfc3RhdGUgd2hpY2gsIGJvb2wg
KnZhbCkKPj4gK3sKPj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX2RldmljZSAqaXRzX2RldiA9IGlycV9k
YXRhX2dldF9pcnFfY2hpcF9kYXRhKGQpOwo+PiArwqDCoMKgIHN0cnVjdCBpdHNfdmxwaV9tYXAg
Km1hcCA9IGdldF92bHBpX21hcChkKTsKPj4gKwo+PiArwqDCoMKgIGlmICh3aGljaCAhPSBJUlFD
SElQX1NUQVRFX1BFTkRJTkcpCj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPj4g
Kwo+PiArwqDCoMKgIC8qIG5vdCBpbnRlbmRlZCBmb3IgcGh5c2ljYWwgTFBJJ3MgcGVuZGluZyBz
dGF0ZSAqLwo+PiArwqDCoMKgIGlmICghbWFwKQo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1F
SU5WQUw7Cj4+ICsKPj4gK8KgwqDCoCAvKgo+PiArwqDCoMKgwqAgKiBJbiBHSUN2NC4xLCBhIFZN
QVBQIHdpdGgge1YsQWxsb2N9PT17MCwxfSBjbGVhbnMgYW5kIGludmFsaWRhdGVzCj4+ICvCoMKg
wqDCoCAqIGFueSBjYWNoaW5nIG9mIHRoZSBWUFQgYXNzb2NpYXRlZCB3aXRoIHRoZSB2UEVJRCBo
ZWxkIGluIHRoZSBHSUMuCj4+ICvCoMKgwqDCoCAqLwo+PiArwqDCoMKgIGlmICghaXNfdjRfMShp
dHNfZGV2LT5pdHMpIHx8IGF0b21pY19yZWFkKCZtYXAtPnZwZS0+dm1hcHBfY291bnQpKQo+IAo+
IEl0IGlzbid0IGNsZWFyIHRvIG1lIHdoYXQgcHJldmVudHMgdGhpcyBmcm9tIHJhY2luZyBhZ2Fp
bnN0IGEgbWFwcGluZyBvZgo+IHRoZSBWUEUuIEFjdHVhbGx5LCBzaW5jZSB3ZSBvbmx5IGhvbGQg
dGhlIExQSSBpcnFkZXNjIGxvY2ssIEknbSBwcmV0dHkgc3VyZQo+IG5vdGhpbmcgcHJldmVudHMg
aXQuCgpZZXMsIHNob3VsZCBoYXZlIHRoZSB2bW92cF9sb2NrIGhlbGQ/CkFuZCBpcyBpdCBuZWNl
c3NhcnkgdG8gYWxzbyBob2xkIHRoaXMgbG9jayBpbiBpdHNfdnBlX2lycV9kb21haW5fYWN0aXZh
dGUvZGVhY3RpdmF0ZT8KCj4gCj4+ICvCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVBQ0NFUzsKPiAK
PiBJIGNhbiBzb3J0IG9mIGJ1eSBFQUNDRVNTIGZvciBhIFZQRSB0aGF0IGlzIGN1cnJlbnRseSBt
YXBwZWQsIGJ1dCBhIG5vbi00LjEKPiBJVFMgc2hvdWxkIGRlZmluaXRlbHkgcmV0dXJuIEVJTlZB
TC4KCkFscmlnaHQsIEVJTlZBTCBsb29rcyBiZXR0ZXIuCgo+IAo+PiArCj4+ICvCoMKgwqAgKnZh
bCA9IGl0c19wZWVrX3ZwdChtYXAtPnZwZSwgbWFwLT52aW50aWQpOwo+PiArCj4+ICvCoMKgwqAg
cmV0dXJuIDA7Cj4+ICt9Cj4+ICsKPj4gwqBzdGF0aWMgaW50IGl0c19pcnFfc2V0X2lycWNoaXBf
c3RhdGUoc3RydWN0IGlycV9kYXRhICpkLAo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgZW51bSBpcnFjaGlwX2lycV9zdGF0ZSB3aGljaCwKPj4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wgc3RhdGUpCj4+IEBAIC0xOTc1
LDYgKzIwMTIsNyBAQCBzdGF0aWMgc3RydWN0IGlycV9jaGlwIGl0c19pcnFfY2hpcCA9IHsKPj4g
wqDCoMKgwqAgLmlycV9lb2nCoMKgwqDCoMKgwqDCoCA9IGlycV9jaGlwX2VvaV9wYXJlbnQsCj4+
IMKgwqDCoMKgIC5pcnFfc2V0X2FmZmluaXR5wqDCoMKgID0gaXRzX3NldF9hZmZpbml0eSwKPj4g
wqDCoMKgwqAgLmlycV9jb21wb3NlX21zaV9tc2fCoMKgwqAgPSBpdHNfaXJxX2NvbXBvc2VfbXNp
X21zZywKPj4gK8KgwqDCoCAuaXJxX2dldF9pcnFjaGlwX3N0YXRlwqDCoMKgID0gaXRzX2lycV9n
ZXRfaXJxY2hpcF9zdGF0ZSwKPiAKPiBNeSBiaWdnZXN0IGlzc3VlIHdpdGggdGhpcyBpcyB0aGF0
IGl0IGlzbid0IGEgcmVsaWFibGUgaW50ZXJmYWNlLgo+IEl0IGhhcHBlbnMgdG8gd29yayBpbiB0
aGUgY29udGV4dCBvZiBLVk0sIGJlY2F1c2UgeW91IG1ha2Ugc3VyZSBpdAo+IGlzIGNhbGxlZCBh
dCB0aGUgcmlnaHQgdGltZSwgYnV0IHRoYXQgZG9lc24ndCBtYWtlIGl0IHNhZmUgaW4gZ2VuZXJh
bAo+IChhbnlvbmUgd2l0aCB0aGUgaW50ZXJydXB0IG51bWJlciBpcyBhbGxvd2VkIHRvIGNhbGwg
dGhpcyBhdCBhbnkgdGltZSkuCgpXZSBjaGVjayB0aGUgdm1hcHBfY291bnQgaW4gaXQgdG8gZW5z
dXJlIHRoZSB1bm1hcHBpbmcgb2YgdGhlIHZQRSwgYW5kCmxldCB0aGUgY2FsbGVyIGRvIHRoZSB1
bm1hcHBpbmcgKHRoZXkgc2hvdWxkIGtub3cgd2hldGhlciBpdCBpcyB0aGUgcmlnaHQKdGltZSku
IElmIHRoZSB1bm1hcHBpbmcgaXMgbm90IGRvbmUsIGp1c3QgcmV0dXJuIGEgZmFpbHVyZS4KCj4g
Cj4gSXMgdGhlcmUgYSBwcm9ibGVtIHdpdGggcG9raW5nIGF0IHRoZSBWUFQgcGFnZSBmcm9tIHRo
ZSBLVk0gc2lkZT8KPiBUaGUgY29kZSBzaG91bGQgYmUgZXhhY3RseSB0aGUgc2FtZSAobWF5YmUg
c2ltcGxlciBldmVuKSwgYW5kIGF0IGxlYXN0Cj4geW91J2QgYmUgZ3VhcmFudGVlZCB0byBiZSBp
biB0aGUgY29ycmVjdCBjb250ZXh0LgoKWWVhaCwgdGhhdCBhbHNvIHNlZW1zIGEgZ29vZCBjaG9p
Y2UuCklmIHlvdSBwcmVmZXIgaXQsIHdlIGNhbiB0cnkgdG8gcmVhbGl6ZSBpdCBpbiB2Mi4KCj4g
Cj4+IMKgwqDCoMKgIC5pcnFfc2V0X2lycWNoaXBfc3RhdGXCoMKgwqAgPSBpdHNfaXJxX3NldF9p
cnFjaGlwX3N0YXRlLAo+PiDCoMKgwqDCoCAuaXJxX3JldHJpZ2dlcsKgwqDCoMKgwqDCoMKgID0g
aXRzX2lycV9yZXRyaWdnZXIsCj4+IMKgwqDCoMKgIC5pcnFfc2V0X3ZjcHVfYWZmaW5pdHnCoMKg
wqAgPSBpdHNfaXJxX3NldF92Y3B1X2FmZmluaXR5LAo+IAo+IFRoYW5rcywKPiAKPiDCoMKgwqDC
oMKgwqDCoCBNLgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Xwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6
Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
