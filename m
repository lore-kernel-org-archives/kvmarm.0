Return-Path: <SRS0=np2t=GI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54388C433DB
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 16:38:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDADF22CB8
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jan 2021 16:38:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDADF22CB8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4ED704B365;
	Tue,  5 Jan 2021 11:38:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 90MvNRP6F1wx; Tue,  5 Jan 2021 11:38:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D40D84B30B;
	Tue,  5 Jan 2021 11:38:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B65D4B29E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 11:38:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id e5fUVCHUrCn0 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jan 2021 11:38:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA9204B297
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jan 2021 11:38:17 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5440B1FB;
 Tue,  5 Jan 2021 08:38:17 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 57B083F70D;
 Tue,  5 Jan 2021 08:38:16 -0800 (PST)
Subject: Re: [PATCH] KVM: arm64: Replace KVM_ARM_PMU with HW_PERF_EVENTS
To: Marc Zyngier <maz@kernel.org>
References: <20210104172723.2014324-1-maz@kernel.org>
 <fd094578-0b7d-57be-6f68-a55aca39e961@arm.com>
 <6444e331b4e0eacdae43cfde3ad05d43@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <33ff9b72-4168-a9d5-307c-cc0622bcdbbf@arm.com>
Date: Tue, 5 Jan 2021 16:38:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <6444e331b4e0eacdae43cfde3ad05d43@kernel.org>
Content-Language: en-US
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu
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

SGkgTWFyYywKCk9uIDEvNS8yMSA0OjI1IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gSGkgQWxl
eCwKPgo+IE9uIDIwMjEtMDEtMDUgMTU6NDksIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6Cj4+IEhp
IE1hcmMsCj4+Cj4+IE9uIDEvNC8yMSA1OjI3IFBNLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+PiBL
Vk1fQVJNX1BNVSBvbmx5IGV4aXN0ZWQgZm9yIHRoZSBiZW5lZml0IG9mIDMyYml0IEFSTSBob3N0
cywKPj4+IGFuZCBtYWtlcyBubyBzZW5zZSBub3cgdGhhdCB3ZSBhcmUgNjRiaXQgb25seS4gR2V0
IHJpZCBvZiBpdC4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJu
ZWwub3JnPgo+Pj4gLS0tCj4+PiDCoGFyY2gvYXJtNjQva3ZtL0tjb25maWfCoCB8IDggLS0tLS0t
LS0KPj4+IMKgYXJjaC9hcm02NC9rdm0vTWFrZWZpbGUgfCAyICstCj4+PiDCoGluY2x1ZGUva3Zt
L2FybV9wbXUuaMKgwqAgfCAyICstCj4+PiDCoDMgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAxMCBkZWxldGlvbnMoLSkKPj4+Cj4+PiBkaWZmIC0tZ2l0IGEvYXJjaC9hcm02NC9rdm0v
S2NvbmZpZyBiL2FyY2gvYXJtNjQva3ZtL0tjb25maWcKPj4+IGluZGV4IDA0Mzc1NmRiOGY2ZS4u
Mzk2NGFjZjU0NTFlIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vS2NvbmZpZwo+Pj4g
KysrIGIvYXJjaC9hcm02NC9rdm0vS2NvbmZpZwo+Pj4gQEAgLTQ5LDE0ICs0OSw2IEBAIGlmIEtW
TQo+Pj4KPj4+IMKgc291cmNlICJ2aXJ0L2t2bS9LY29uZmlnIgo+Pj4KPj4+IC1jb25maWcgS1ZN
X0FSTV9QTVUKPj4+IC3CoMKgwqAgYm9vbCAiVmlydHVhbCBQZXJmb3JtYW5jZSBNb25pdG9yaW5n
IFVuaXQgKFBNVSkgc3VwcG9ydCIKPj4+IC3CoMKgwqAgZGVwZW5kcyBvbiBIV19QRVJGX0VWRU5U
Uwo+Pj4gLcKgwqDCoCBkZWZhdWx0IHkKPj4+IC3CoMKgwqAgaGVscAo+Pj4gLcKgwqDCoMKgwqAg
QWRkcyBzdXBwb3J0IGZvciBhIHZpcnR1YWwgUGVyZm9ybWFuY2UgTW9uaXRvcmluZyBVbml0IChQ
TVUpIGluCj4+PiAtwqDCoMKgwqDCoCB2aXJ0dWFsIG1hY2hpbmVzLgo+Pj4gLQo+Pj4gwqBlbmRp
ZiAjIEtWTQo+Pj4KPj4+IMKgZW5kaWYgIyBWSVJUVUFMSVpBVElPTgo+Pj4gZGlmZiAtLWdpdCBh
L2FyY2gvYXJtNjQva3ZtL01ha2VmaWxlIGIvYXJjaC9hcm02NC9rdm0vTWFrZWZpbGUKPj4+IGlu
ZGV4IDYwZmQxODFkZjYyNC4uMTNiMDE3Mjg0YmY5IDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02
NC9rdm0vTWFrZWZpbGUKPj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL01ha2VmaWxlCj4+PiBAQCAt
MjQsNCArMjQsNCBAQCBrdm0teSA6PSAkKEtWTSkva3ZtX21haW4ubyAkKEtWTSkvY29hbGVzY2Vk
X21taW8ubwo+Pj4gJChLVk0pL2V2ZW50ZmQubyBcCj4+PiDCoMKgwqDCoMKgIHZnaWMvdmdpYy1t
bWlvLXYzLm8gdmdpYy92Z2ljLWt2bS1kZXZpY2UubyBcCj4+PiDCoMKgwqDCoMKgIHZnaWMvdmdp
Yy1pdHMubyB2Z2ljL3ZnaWMtZGVidWcubwo+Pj4KPj4+IC1rdm0tJChDT05GSUdfS1ZNX0FSTV9Q
TVUpwqAgKz0gcG11LWVtdWwubwo+Pj4gK2t2bS0kKENPTkZJR19IV19QRVJGX0VWRU5UUynCoCAr
PSBwbXUtZW11bC5vCj4+PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9rdm0vYXJtX3BtdS5oIGIvaW5j
bHVkZS9rdm0vYXJtX3BtdS5oCj4+PiBpbmRleCBmYzg1ZjUwZmEwZTkuLjhkY2IzZTE0NzdiYyAx
MDA2NDQKPj4+IC0tLSBhL2luY2x1ZGUva3ZtL2FybV9wbXUuaAo+Pj4gKysrIGIvaW5jbHVkZS9r
dm0vYXJtX3BtdS5oCj4+PiBAQCAtMTMsNyArMTMsNyBAQAo+Pj4gwqAjZGVmaW5lIEFSTVY4X1BN
VV9DWUNMRV9JRFjCoMKgwqDCoMKgwqDCoCAoQVJNVjhfUE1VX01BWF9DT1VOVEVSUyAtIDEpCj4+
PiDCoCNkZWZpbmUgQVJNVjhfUE1VX01BWF9DT1VOVEVSX1BBSVJTwqDCoMKgICgoQVJNVjhfUE1V
X01BWF9DT1VOVEVSUyArIDEpID4+IDEpCj4+Pgo+Pj4gLSNpZmRlZiBDT05GSUdfS1ZNX0FSTV9Q
TVUKPj4+ICsjaWZkZWYgQ09ORklHX0hXX1BFUkZfRVZFTlRTCj4+Pgo+Pj4gwqBzdHJ1Y3Qga3Zt
X3BtYyB7Cj4+PiDCoMKgwqDCoCB1OCBpZHg7wqDCoMKgIC8qIGluZGV4IGludG8gdGhlIHBtdS0+
cG1jIGFycmF5ICovCj4+Cj4+IEkgZ3JlcCdlZCBmb3IgS1ZNX0FSTV9QTVUgaW4gdGhlIExpbnV4
IHNvdXJjZXMsIHRoaXMgcGF0Y2ggdGFrZXMgY2FyZSBvZiBhbGwgaXRzCj4+IG9jY3VycmVuY2Vz
Lgo+Pgo+PiBBIGZldyB0aGluZ3MgcG9wcGVkIGludG8gbXkgbWluZCB3aGVuIEkgc2F3IHRoZSBw
YXRjaC4KPj4KPj4gMS4gUmVwbGFjaW5nIEtWTV9BUk1fUE1VIHdpdGggQ09ORklHX0hXX1BFUkZf
RVZFTlRTIG1lYW5zIGl0J3Mgbm90IHBvc3NpYmxlCj4+IGFueW1vcmUgZm9yIHRoZSBob3N0IHRv
IGhhdmUgcGVyZiBzdXBwb3J0IHdoaWxlIEtWTSBkb2VzIG5vdCBzdXBwb3J0IGVtdWxhdGluZyBh
Cj4+IFBNVS4gSW4gdGhpcyBzY2VuYXJpbywgZnVuY3Rpb25zIHdoaWNoIHdvdWxkIGhhdmUgYmVl
biBlbXB0eSBmdW5jdGlvbnMgaWYKPj4gS1ZNX0FSTV9QTVUgd2FzIHN0aWxsIGFyb3VuZCAoSSBv
bmx5IGZvdW5kIGt2bV9wbXVfZmx1c2hfaHdzdGF0ZSgpIGFuZAo+PiBrdm1fcG11X3N5bmNfaHdz
dGF0ZSgpIG9uIHRoZSBLVk1fUlVOIHBhdGgpIHdpbGwgbm93IGJlIGNhbGxlZCBhbmQgcmV0dXJu
IGVhcmx5Cj4+IGFmdGVyIGt2bV92Y3B1X2hhc19wbXUoKSByZXR1cm5zIDAuIFRoZSBvdmVyaGVh
ZCBsb29rcyBuZWdsaWdpYmxlIHRvIG1lLCBhbmQgSQo+PiBkb24ndCB0aGluayB0aGlzIGNvbmZp
Z3VyYXRpb24gd2FzIGNvbW1vbiAoZXNwZWNpYWxseSBzaW5jZSB0aGUgZGVmYXVsdCB3YXMgeSku
Cj4KPiBJIGRvbid0IHRoaW5rIHRoaXMgaXMgZWl0aGVyIGNvbW1vbiBub3IgdXNlZnVsLiBJZiB0
aGUga2VybmVsIHN1cHBvcnRzCj4gdGhlIFBNVSwgdGhlbiBmaW5kaW5nIGEgUE1VIGVuYWJsZXMg
YWxsIHRoZSB1c2VzIG9mIHRoZSBQTVUsIGluY2x1ZGluZwo+IGZvciBndWVzdHMuIEFuZCB1c2Vy
c3BhY2UgaXMgc3RpbGwgaW4gY29udHJvbCBvZiB3aGF0IGl0IGV4cG9zZXMgdG8KPiB0aGUgZ3Vl
c3QuIFllcywgaXQncyBhIHRpbnkgbW9yZSBvdmVyaGVhZCAob25lIGV4dHJhIGxvYWQpIG9uIHRo
ZQo+IGV4aXQvZW50cnkgcGF0aC4gU2hvdWxkIHdlIGNhcmU/IEkgZG9uJ3QgdGhpbmsgc28uCgpZ
ZXMsIEkgYWdyZWU6CgpSZXZpZXdlZC1ieTogQWxleGFuZHJ1IEVsaXNlaSA8YWxleGFuZHJ1LmVs
aXNlaUBhcm0uY29tPgoKPgo+PiAyLiBJIGRpZCBhIGdyZXAgZm9yIHRoZSBmaWxlcyB0aGF0IGlu
Y2x1ZGUgYXJtX3BtdS5oLCBhbmQgYWxsIHRoZSBmaWxlcyB3ZXJlIGluCj4+IGFyY2gvYXJtNjQu
IEkgc3VwcG9zZSBhcm1fcG11LmggZXhpc3RzIGluIGluY2x1ZGUva3ZtIGluc3RlYWQgb2YKPj4g
YXJjaC9hcm02NC9pbmNsdWRlL2FzbSBiZWNhdXNlIGl0IHdhcyBzaGFyZWQgd2l0aCBLVk0vYXJt
IHdoZW4gaXQgd2FzIHN0aWxsCj4+IGFyb3VuZCwgcmlnaHQ/IE9yIGlzIHRoZXJlIGFub3RoZXIg
cmVhc29uIGZvciB0aGF0Pwo+Cj4gTm8sIHRoYXQncyBiYXNpY2FsbHkgdGhlIG9ubHkgcmVhc29u
LiBUaGF0IHdhcyB0aGUgZWFzeSBsYW5kaW5nIHNwb3QKPiBmb3IgYW55dGhpbmcgc2hhcmVkIChp
bmNsdWRpbmcgdGhpbmdzIGxpa2UgR0lDLCB0aW1lcnMgYW5kIGNvKS4KPiBJJ20gbm90IHN1cmUg
aXQgaXMgd29ydGggdGhlIG1vdmUsIFRCSC4uLgoKSSBmZWVsIHRoZSBzYW1lIHdheSwgSSB3YXMg
YXNraW5nIG1vcmUgaW4gdGhlIGNvbnRleHQgb2YgbmV3IGNvZGUuIEkgYWRtaXQgdG8gYWxzbwpo
YXZpbmcgYW4gdWx0ZXJpb3IgbW90aXZlLCBhcyBvbmUgb2YgdGhlIHBhdGNoZXMgSSBwaWNrZWQg
dXAgZm9yIHRoZSBTUEUgc2VyaWVzCmFkZGVkIGEgaGVhZGVyIGZpbGUgaW4gaW5jbHVkZS9rdm0g
YW5kIGl0IGxvb2tlZCBhIGJpdCBvdXQgb2YgcGxhY2UuCgpUaGFua3MsCkFsZXgKPgo+PiBbMV0g
aHR0cHM6Ly93d3cuc3Bpbmljcy5uZXQvbGlzdHMva3ZtLWFybS9tc2c0NDE4NC5odG1sCj4KPiBZ
dW8sIGFuZCB0aGF0J3MgdGhlIHJlYXNvbiBJIHBvc3RlZCB0aGlzIHBhdGNoLiBJIGhhdmUgYSBj
b3VwbGUgbW9yZQo+IHRoYXQgSSdsbCBwb3N0IGJ5IHRoZSBlbmQgb2YgdGhlIGRheS4KPgo+IFRo
YW5rcywKPgo+IMKgwqDCoMKgwqDCoMKgIE0uCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNv
bHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZv
L2t2bWFybQo=
