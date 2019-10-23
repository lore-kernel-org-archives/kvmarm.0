Return-Path: <SRS0=cDTT=YQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D1ACA9EA0
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 02:08:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 844F32086D
	for <kvmarm@archiver.kernel.org>; Wed, 23 Oct 2019 02:08:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 844F32086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0AE34A97C;
	Tue, 22 Oct 2019 22:08:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GsVsS8dtEOXU; Tue, 22 Oct 2019 22:08:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B24BC4A97F;
	Tue, 22 Oct 2019 22:08:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E369E4A95D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 22:08:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ShZv5S-DIl-e for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Oct 2019 22:08:15 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 14F2E4A8BB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Oct 2019 22:08:15 -0400 (EDT)
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
 by Forcepoint Email with ESMTP id EA9C3FFC6E3FBBFE7ED5;
 Wed, 23 Oct 2019 10:08:11 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Wed, 23 Oct 2019
 10:08:05 +0800
Subject: Re: [PATCH] irqchip/gic-v3-its: Use the exact ITSList for VMOVP
To: Marc Zyngier <maz@kernel.org>
References: <1571742366-21008-1-git-send-email-yuzenghui@huawei.com>
 <34e9236f057b22d49f40146b21f81282@www.loen.fr>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <708a2e9d-5992-63b9-8164-96a71f6838d0@huawei.com>
Date: Wed, 23 Oct 2019 10:08:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <34e9236f057b22d49f40146b21f81282@www.loen.fr>
Content-Language: en-US
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Cc: jason@lakedaemon.net, jiayanlei@huawei.com, tglx@linutronix.de,
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

SGkgTWFyYywKCk9uIDIwMTkvMTAvMjIgMjA6NDQsIE1hcmMgWnluZ2llciB3cm90ZToKPiBIaSBa
ZW5naHVpLAo+IAo+IE9uIDIwMTktMTAtMjIgMTI6MDYsIFplbmdodWkgWXUgd3JvdGU6Cj4+IE9u
IGEgc3lzdGVtIHdpdGhvdXQgU2luZ2xlIFZNT1ZQIHN1cHBvcnQgKHNheSBHSVRTX1RZUEVSLlZN
T1ZQID09IDApLAo+PiB3ZSB3aWxsIG1hcCB2UEVzIG9ubHkgb24gSVRTcyB0aGF0IHdpbGwgYWN0
dWFsbHkgY29udHJvbCBpbnRlcnJ1cHRzCj4+IGZvciB0aGUgZ2l2ZW4gVk0uwqAgQW5kIHdoZW4g
bW92aW5nIGEgdlBFLCB0aGUgVk1PVlAgY29tbWFuZCB3aWxsIGJlCj4+IGlzc3VlZCBvbmx5IGZv
ciB0aG9zZSBJVFNzLgo+Pgo+PiBCdXQgd2hlbiBpc3N1aW5nIFZNT1ZQcyB3ZSBzZWVtZWQgZmFp
bCB0byBwcmVzZW50IHRoZSBleGFjdCBJVFNMaXN0Cj4+IHRvIElUU3Mgd2hvIGFyZSBhY3R1YWxs
eSBpbmNsdWRlZCBpbiB0aGUgc3luY2hyb25pemF0aW9uIG9wZXJhdGlvbi4KPj4gVGhlIGl0c19s
aXN0X21hcCB3ZSdyZSBjdXJyZW50bHkgdXNpbmcgaW5jbHVkZXMgYWxsIElUU3MgaW4gdGhlIHN5
c3RlbSwKPj4gZXZlbiB0aG91Z2ggc29tZSBvZiB0aGVtIGRvbid0IGhhdmUgdGhlIGNvcnJzcG9u
ZGluZyB2UEUgbWFwcGluZyBhdCBhbGwuCj4+Cj4+IEludHJvZHVjZSBnZXRfaXRzX2xpc3QoKSB0
byBnZXQgdGhlIHBlci1WTSBpdHNfbGlzdF9tYXAsIHRvIGluZGljYXRlCj4+IHdoaWNoIElUU3Mg
aGF2ZSB2UEUgbWFwcGluZ3MgZm9yIHRoZSBnaXZlbiBWTSwgYW5kIHVzZSB0aGlzIG1hcCBhcwo+
PiB0aGUgZXhwZWN0ZWQgSVRTTGlzdCB3aGVuIGJ1aWxkaW5nIFZNT1ZQLgo+Pgo+PiBTaWduZWQt
b2ZmLWJ5OiBaZW5naHVpIFl1IDx5dXplbmdodWlAaHVhd2VpLmNvbT4KPj4gLS0tCj4+Cj4+IEkg
aGF2ZW4ndCBzZWVuIGFueSBicm9rZW4gd2l0aCB0aGUgY3VycmVudCBpdHNfbGlzdF9tYXAsIGJ1
dCBiZWhhdmlvcgo+PiBtaWdodCBkaWZmZXIgYmV0d2VlbiBpbXBsZW1lbnRhdGlvbnMuwqAgTGV0
J3MgZG8gd2hhdCB0aGUgc3BlYyBleHBlY3RzCj4+IHVzIHRvIGRvIGFuZCB0cnkgbm90IHRvIGNv
bmZ1c2UgdGhlIGltcGxlbWVudGF0aW9uLsKgIE9yIGlzIHRoZXJlIGFueQo+PiBwb2ludHMgSSd2
ZSBtaXNzZWQ/Cj4gCj4gTm8sIEkgdGhpbmsgeW91J3JlIHJpZ2h0LCBhbmQgdGhpcyBpcyBqdXN0
IGFuIG92ZXJzaWdodCBvbiBteSBwYXJ0Ogo+IGZvciBleGFtcGxlLCB3ZSBzZWVtIHRvIGRvIHRo
ZSByaWdodCB0aGluZyB3aGVuIGhhbmRsaW5nIGEgZ3Vlc3QgaW52YWxsLAo+IHdoZXJlIHdlIHNj
YW4gdGhlIElUUyBub2RlcyBhbmQgb25seSBlbWl0IGEgdmludmFsbCBvbiBhbiBJVFMgdGhhdAo+
IGhhcyBWTFBJIG1hcHBlZCBpbi4KPiAKPiBJIGRvbid0IHRoaW5rIHRoaXMgaXMgbGlrZWx5IHRv
IGNhdXNlIGFueSBoYXJtIChhZnRlciBhbGwsIGEgRElTQ0FSRCBhbmQKPiBhIFZNT1ZQIGNvdWxk
IHJhY2UgYXQgYW55IHRpbWUpLCBidXQgaXQgaXMgY2VydGFpbmx5IGEgcGVyZm9ybWFuY2UgZ2Fp
bgo+IG5vdCB0byB0aHJvdyBleHRyYSBjb21tYW5kcyBhdCB1bnN1c3BlY3RpbmcgSVRTcy4gU28g
dGhhbmtzIGZvciBzcG90dGluZyAKPiB0aGlzLgoKSSBhZ3JlZSB0aGF0IGl0IHdpbGwgYmUgYSBw
ZXJmb3JtYW5jZSBnYWluIHdpdGggdGhpcyBwYXRjaCAtIHNpbmNlIGFmdGVyCnJlY2VpdmluZyBW
TU9WUCwgdGhlcmUgbWlnaHQgYmUgYSBzeW5jaHJvbml6YXRpb24gcHJvY2VzcyBhbW9uZyBhbGwg
SVRTcwppbmNsdWRlZCBpbiB0aGUgSVRTTGlzdCwgYnV0IHdhaXRpbmcgZm9yIHRob3NlIHVuc3Vz
cGVjdGluZyBvbmUgaXMKdG90YWxseSBwb2ludGxlc3MuCgo+IAo+IEEgY291cGxlIG9mIGNvbW1l
bnRzIGJlbG93OgoKVGhhbmtzIGZvciB0aGUgY29tbWVudHMuIEkgd2lsbCBkbyBhIHJlc3BpbiBh
bmQgc2VuZCBhIHYyIHNob3J0bHksIHdpdGgKKGhvcGVmdWxseSkgYWxsIG9mIHRoZW0gYWRkcmVz
c2VkLgoKPiAKPj4KPj4gwqBkcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYyB8IDE1ICsr
KysrKysrKysrKysrLQo+PiDCoDEgZmlsZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxIGRl
bGV0aW9uKC0pCj4+Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1p
dHMuYwo+PiBiL2RyaXZlcnMvaXJxY2hpcC9pcnEtZ2ljLXYzLWl0cy5jCj4+IGluZGV4IGM4MWRh
MjcwNDRiZi4uZWViZWU1ODhlYTMwIDEwMDY0NAo+PiAtLS0gYS9kcml2ZXJzL2lycWNoaXAvaXJx
LWdpYy12My1pdHMuYwo+PiArKysgYi9kcml2ZXJzL2lycWNoaXAvaXJxLWdpYy12My1pdHMuYwo+
PiBAQCAtMTc1LDYgKzE3NSwxOSBAQCBzdGF0aWMgREVGSU5FX0lEQShpdHNfdnBlaWRfaWRhKTsK
Pj4gwqAjZGVmaW5lIGdpY19kYXRhX3JkaXN0X3JkX2Jhc2UoKcKgwqDCoCAoZ2ljX2RhdGFfcmRp
c3QoKS0+cmRfYmFzZSkKPj4gwqAjZGVmaW5lIGdpY19kYXRhX3JkaXN0X3ZscGlfYmFzZSgpwqDC
oMKgIChnaWNfZGF0YV9yZGlzdF9yZF9iYXNlKCkgKyAKPj4gU1pfMTI4SykKPj4KPj4gK3N0YXRp
YyBpbmxpbmUgdTE2IGdldF9pdHNfbGlzdChzdHJ1Y3QgaXRzX3ZtICp2bSkKPiAKPiBQbGVhc2Ug
ZHJvcCB0aGUgaW5saW5lLCB0aGUgY29tcGlsZXIgd2lsbCBkbyBpdCBmb3IgeW91Lgo+IAo+PiAr
ewo+PiArwqDCoMKgIHN0cnVjdCBpdHNfbm9kZSAqaXRzOwo+PiArwqDCoMKgIHVuc2lnbmVkIGxv
bmcgaXRzX2xpc3Q7Cj4+ICsKPj4gK8KgwqDCoCBsaXN0X2Zvcl9lYWNoX2VudHJ5KGl0cywgJml0
c19ub2RlcywgZW50cnkpIHsKPiAKPiBZb3UgcHJvYmFibHkgd2FudCB0byBza2lwIG5vbiB2NCBJ
VFNzLCBhcyB0aGV5IGRvbid0IGhhdmUgYSBsaXN0X25yIAo+IGFzc29jaWF0ZWQKPiB0byB0aGVt
IChhbmQgeW91J2QgcHJvYmFibHkgZW5kLXVwIGhpdHRpbmcgSVRTICMwIGZvciBubyBnb29kIHJl
YXNvbikuCj4gCj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAodm0tPnZscGlfY291bnRbaXRzLT5saXN0
X25yXSkKPj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2V0X2JpdChpdHMtPmxpc3RfbnIsICZp
dHNfbGlzdCk7Cj4gCj4gV2UgZG9uJ3QgbmVlZCB0byBiZSBhdG9taWMgaGVyZSwgc28gX19zZXRf
Yml0IHdvdWxkIGJlIGp1c3QgYXMgZmluZS4KPiAKPj4gK8KgwqDCoCB9Cj4+ICsKPj4gK8KgwqDC
oCByZXR1cm4gKHUxNilpdHNfbGlzdDsKPj4gK30KPj4gKwo+PiDCoHN0YXRpYyBzdHJ1Y3QgaXRz
X2NvbGxlY3Rpb24gKmRldl9ldmVudF90b19jb2woc3RydWN0IGl0c19kZXZpY2UgCj4+ICppdHNf
ZGV2LAo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgdTMyIGV2ZW50KQo+PiDCoHsKPj4gQEAgLTk4Miw3ICs5OTUsNiBAQCBzdGF0aWMgdm9p
ZCBpdHNfc2VuZF92bW92cChzdHJ1Y3QgaXRzX3ZwZSAqdnBlKQo+PiDCoMKgwqDCoCBpbnQgY29s
X2lkID0gdnBlLT5jb2xfaWR4Owo+Pgo+PiDCoMKgwqDCoCBkZXNjLml0c192bW92cF9jbWQudnBl
ID0gdnBlOwo+PiAtwqDCoMKgIGRlc2MuaXRzX3Ztb3ZwX2NtZC5pdHNfbGlzdCA9ICh1MTYpaXRz
X2xpc3RfbWFwOwo+IAo+IENhcmVmdWwgaGVyZSwgeW91J3JlIGxlYXZpbmcgdGhlIGl0c19saXN0
IGZpZWxkIHVuaW5pdGlhbGl6ZWQsIGFuZCBpdAo+IHJlYWxseSBzaG91bGQgYmUgMCB3aGVuIEdJ
VFNfVFlQRVIuVk1PVlAgPT0gMSAoaS5lLiB3aGVuIGl0c19saXN0X21hcAo+IGlzIHplcm8pLiBK
dXN0IGluaXRpYWxpemUgdGhlIHdob2xlIGRlc2NyaXB0b3IgdG8gemVyby4KClllcywgdGhpcyBu
ZWVkcyB0byBiZSBmaXhlZCwgYXMgd2VsbCBhcyBpbml0aWFsaXplICJpdHNfbGlzdCIgdG8gemVy
bwppbiBnZXRfaXRzX2xpc3QoKS4KCgpUaGFua3MsCnplbmdodWkKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
