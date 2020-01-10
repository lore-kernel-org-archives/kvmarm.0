Return-Path: <SRS0=Qg2m=27=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7BBC282DD
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 14:32:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6F6B22077C
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jan 2020 14:32:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RiRwhglw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F6B22077C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4E294B172;
	Fri, 10 Jan 2020 09:32:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DR2WikAU5gnI; Fri, 10 Jan 2020 09:32:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CB054B14B;
	Fri, 10 Jan 2020 09:32:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC0CE4B0EE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 09:32:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lmwgzhU1E5TY for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jan 2020 09:32:22 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEABD4B0CF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jan 2020 09:32:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1578666742;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=719g42u2rz+9V3916YPTM/uativVLpzDKDsVaRSjTdU=;
 b=RiRwhglwFGTTdlxPSULn9qLANtJULMkSAgM9QQXVIUCVrvyVjH1CNuBFcZFxTAPXusEbm/
 s3K3QVEgTWzNhF5WRqn0GEx4ykq3ppM2jzqwfSgch2r00xL19Z6zw9VLt6ynwy/ou6vdl+
 wggQBO3uQk6Vhb9+DO6Ff8PBGMELBjA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-abbg4ELiP0qL4yvf3JxD8w-1; Fri, 10 Jan 2020 09:32:19 -0500
X-MC-Unique: abbg4ELiP0qL4yvf3JxD8w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF3698C507A;
 Fri, 10 Jan 2020 14:32:16 +0000 (UTC)
Received: from [10.36.117.108] (ovpn-117-108.ams2.redhat.com [10.36.117.108])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F4FF87ED7;
 Fri, 10 Jan 2020 14:32:12 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 11/16] arm/arm64: ITS: Device and
 collection Initialization
To: Zenghui Yu <yuzenghui@huawei.com>, eric.auger.pro@gmail.com,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 qemu-devel@nongnu.org, qemu-arm@nongnu.org
References: <20191216140235.10751-1-eric.auger@redhat.com>
 <20191216140235.10751-12-eric.auger@redhat.com>
 <1f170d74-0ee5-6415-d84e-cd7de4d0f071@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <bb18550e-e9e5-f6ba-a5ff-8dc16cec866a@redhat.com>
Date: Fri, 10 Jan 2020 15:32:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1f170d74-0ee5-6415-d84e-cd7de4d0f071@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: andre.przywara@arm.com, thuth@redhat.com
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

SGkgWmVuZ2h1aSwKCk9uIDEyLzIwLzE5IDg6MjUgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkg
RXJpYywKPiAKPiBPbiAyMDE5LzEyLzE2IDIyOjAyLCBFcmljIEF1Z2VyIHdyb3RlOgo+PiBJbnRy
b2R1Y2UgYW4gaGVscGVyIGZ1bmN0aW9ucyB0byByZWdpc3Rlcgo+PiAtIGEgbmV3IGRldmljZSwg
Y2hhcmFjdGVyaXplZCBieSBpdHMgZGV2aWNlIGlkIGFuZCB0aGUKPj4gwqDCoCBtYXggbnVtYmVy
IG9mIGV2ZW50IElEcyB0aGF0IGRpbWVuc2lvbiBpdHMgSVRUIChJbnRlcnJ1cHQKPj4gwqDCoCBU
cmFuc2xhdGlvbiBUYWJsZSkuwqAgVGhlIGZ1bmN0aW9uIGFsbG9jYXRlcyB0aGUgSVRULgo+Pgo+
PiAtIGEgbmV3IGNvbGxlY3Rpb24sIGNoYXJhY3Rlcml6ZWQgYnkgaXRzIElEIGFuZCB0aGUKPj4g
wqDCoCB0YXJnZXQgcHJvY2Vzc2luZyBlbmdpbmUgKFBFKS4KPj4KPj4gU2lnbmVkLW9mZi1ieTog
RXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+Pgo+PiAtLS0KPj4gLS0tCj4+IMKg
IGxpYi9hcm0vYXNtL2dpYy12My1pdHMuaCB8IDIwICsrKysrKysrKysrKysrKysrCj4+IMKgIGxp
Yi9hcm0vZ2ljLXYzLWl0cy5jwqDCoMKgwqAgfCA0NiArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrCj4+IMKgIDIgZmlsZXMgY2hhbmdlZCwgNjYgaW5zZXJ0aW9ucygrKQo+
Pgo+PiBkaWZmIC0tZ2l0IGEvbGliL2FybS9hc20vZ2ljLXYzLWl0cy5oIGIvbGliL2FybS9hc20v
Z2ljLXYzLWl0cy5oCj4+IGluZGV4IGFiNjM5YzUuLjI0NWVmNjEgMTAwNjQ0Cj4+IC0tLSBhL2xp
Yi9hcm0vYXNtL2dpYy12My1pdHMuaAo+PiArKysgYi9saWIvYXJtL2FzbS9naWMtdjMtaXRzLmgK
Pj4gQEAgLTg3LDYgKzg3LDkgQEAKPj4gwqAgwqAgI2RlZmluZSBJVFNfRkxBR1NfQ01EUV9ORUVE
U19GTFVTSElOR8KgwqDCoMKgwqDCoMKgwqDCoMKgICgxVUxMIDw8IDApCj4+IMKgICsjZGVmaW5l
IEdJVFNfTUFYX0RFVklDRVPCoMKgwqDCoMKgwqDCoCA4Cj4+ICsjZGVmaW5lIEdJVFNfTUFYX0NP
TExFQ1RJT05TwqDCoMKgwqDCoMKgwqAgOAo+PiArCj4+IMKgIHN0cnVjdCBpdHNfdHlwZXIgewo+
PiDCoMKgwqDCoMKgIHVuc2lnbmVkIGludCBpdGVfc2l6ZTsKPj4gwqDCoMKgwqDCoCB1bnNpZ25l
ZCBpbnQgZXZlbnRpZF9iaXRzOwo+PiBAQCAtMTE3LDYgKzEyMCwxNyBAQCBzdHJ1Y3QgaXRzX2Nt
ZF9ibG9jayB7Cj4+IMKgwqDCoMKgwqAgdTY0wqDCoMKgwqAgcmF3X2NtZFs0XTsKPj4gwqAgfTsK
Pj4gwqAgK3N0cnVjdCBpdHNfZGV2aWNlIHsKPj4gK8KgwqDCoCB1MzIgZGV2aWNlX2lkO8KgwqDC
oCAvKiBkZXZpY2UgSUQgKi8KPj4gK8KgwqDCoCB1MzIgbnJfaXRlczvCoMKgwqAgLyogTWF4IElu
dGVycnVwdCBUcmFuc2xhdGlvbiBFbnRyaWVzICovCj4+ICvCoMKgwqAgdm9pZCAqaXR0O8KgwqDC
oCAvKiBJbnRlcnJ1cHQgVHJhbnNsYXRpb24gVGFibGUgR1BBICovCj4+ICt9Owo+PiArCj4+ICtz
dHJ1Y3QgaXRzX2NvbGxlY3Rpb24gewo+PiArwqDCoMKgIHU2NCB0YXJnZXRfYWRkcmVzczsKPj4g
K8KgwqDCoCB1MTYgY29sX2lkOwo+PiArfTsKPj4gKwo+PiDCoCBzdHJ1Y3QgaXRzX2RhdGEgewo+
PiDCoMKgwqDCoMKgIHZvaWQgKmJhc2U7Cj4+IMKgwqDCoMKgwqAgc3RydWN0IGl0c190eXBlciB0
eXBlcjsKPj4gQEAgLTEyNCw2ICsxMzgsMTAgQEAgc3RydWN0IGl0c19kYXRhIHsKPj4gwqDCoMKg
wqDCoCBzdHJ1Y3QgaXRzX2NtZF9ibG9jayAqY21kX2Jhc2U7Cj4+IMKgwqDCoMKgwqAgc3RydWN0
IGl0c19jbWRfYmxvY2sgKmNtZF93cml0ZTsKPj4gwqDCoMKgwqDCoCBzdHJ1Y3QgaXRzX2NtZF9i
bG9jayAqY21kX3JlYWRyOwo+PiArwqDCoMKgIHN0cnVjdCBpdHNfZGV2aWNlIGRldmljZXNbR0lU
U19NQVhfREVWSUNFU107Cj4+ICvCoMKgwqAgdTMyIG5iX2RldmljZXM7wqDCoMKgwqDCoMKgwqAg
LyogQWxsb2NhdGVkIERldmljZXMgKi8KPj4gK8KgwqDCoCBzdHJ1Y3QgaXRzX2NvbGxlY3Rpb24g
Y29sbGVjdGlvbnNbR0lUU19NQVhfQ09MTEVDVElPTlNdOwo+PiArwqDCoMKgIHUzMiBuYl9jb2xs
ZWN0aW9uczvCoMKgwqAgLyogQWxsb2NhdGVkIENvbGxlY3Rpb25zICovCj4gCj4gKCducl8qJyBt
YXkgYmUgdGhlIG1vcmUgd2lkZWx5IHVzZWQgb25lLikKPiAKPj4gwqAgfTsKPj4gwqAgwqAgZXh0
ZXJuIHN0cnVjdCBpdHNfZGF0YSBpdHNfZGF0YTsKPj4gQEAgLTE0MCw2ICsxNTgsOCBAQCBleHRl
cm4gdTggZ2V0X2xwaV9jb25maWcoaW50IG4pOwo+PiDCoCBleHRlcm4gdm9pZCBzZXRfcGVuZGlu
Z190YWJsZV9iaXQoaW50IHJkaXN0LCBpbnQgbiwgYm9vbCBzZXQpOwo+PiDCoCBleHRlcm4gdm9p
ZCBnaWN2M19yZGlzdF9jdHJsX2xwaSh1MzIgcmVkaXN0LCBib29sIHNldCk7Cj4+IMKgIGV4dGVy
biB2b2lkIGl0c19lbmFibGVfZGVmYXVsdHModm9pZCk7Cj4+ICtleHRlcm4gc3RydWN0IGl0c19k
ZXZpY2UgKml0c19jcmVhdGVfZGV2aWNlKHUzMiBkZXZfaWQsIGludCBucl9pdGVzKTsKPj4gK2V4
dGVybiBzdHJ1Y3QgaXRzX2NvbGxlY3Rpb24gKml0c19jcmVhdGVfY29sbGVjdGlvbih1MzIgY29s
X2lkLCB1MzIKPj4gdGFyZ2V0X3BlKTsKPj4gwqAgwqAgI2VuZGlmIC8qICFfX0FTU0VNQkxZX18g
Ki8KPj4gwqAgI2VuZGlmIC8qIF9BU01BUk1fR0lDX1YzX0lUU19IXyAqLwo+PiBkaWZmIC0tZ2l0
IGEvbGliL2FybS9naWMtdjMtaXRzLmMgYi9saWIvYXJtL2dpYy12My1pdHMuYwo+PiBpbmRleCA5
YTUxZWY0Li45OTA2NDI4IDEwMDY0NAo+PiAtLS0gYS9saWIvYXJtL2dpYy12My1pdHMuYwo+PiAr
KysgYi9saWIvYXJtL2dpYy12My1pdHMuYwo+PiBAQCAtMjg0LDMgKzI4NCw0OSBAQCB2b2lkIGl0
c19lbmFibGVfZGVmYXVsdHModm9pZCkKPj4gwqAgwqDCoMKgwqDCoCB3cml0ZWwoR0lUU19DVExS
X0VOQUJMRSwgaXRzX2RhdGEuYmFzZSArIEdJVFNfQ1RMUik7Cj4+IMKgIH0KPj4gKwo+PiArc3Ry
dWN0IGl0c19kZXZpY2UgKml0c19jcmVhdGVfZGV2aWNlKHUzMiBkZXZpY2VfaWQsIGludCBucl9p
dGVzKQo+PiArewo+PiArwqDCoMKgIHN0cnVjdCBpdHNfYmFzZXIgKmJhc2VyOwo+PiArwqDCoMKg
IHN0cnVjdCBpdHNfZGV2aWNlICpuZXc7Cj4+ICvCoMKgwqAgdW5zaWduZWQgbG9uZyBuLCBvcmRl
cjsKPj4gKwo+PiArwqDCoMKgIGlmIChpdHNfZGF0YS5uYl9kZXZpY2VzID49IEdJVFNfTUFYX0RF
VklDRVMpCj4+ICvCoMKgwqDCoMKgwqDCoCByZXBvcnRfYWJvcnQoIiVzIHJlZGltZW5zaW9uIEdJ
VFNfTUFYX0RFVklDRVMiLCBfX2Z1bmNfXyk7Cj4+ICsKPj4gK8KgwqDCoCBiYXNlciA9IGl0c19s
b29rdXBfYmFzZXIoR0lUU19CQVNFUl9UWVBFX0RFVklDRSk7Cj4+ICvCoMKgwqAgaWYgKCFiYXNl
cikKPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybiBOVUxMOwo+PiArCj4+ICvCoMKgwqAgbmV3ID0g
Jml0c19kYXRhLmRldmljZXNbaXRzX2RhdGEubmJfZGV2aWNlc107Cj4+ICsKPj4gK8KgwqDCoCBu
ZXctPmRldmljZV9pZCA9IGRldmljZV9pZDsKPj4gK8KgwqDCoCBuZXctPm5yX2l0ZXMgPSBucl9p
dGVzOwo+PiArCj4+ICvCoMKgwqAgbiA9IChiYXNlci0+ZXN6ICogbnJfaXRlcykgPj4gUEFHRV9T
SElGVDsKPiAKPiBiYXNlci0+ZXN6IGlzIEdJVFNfQkFTRVIuRW50cnlfU2l6ZSwgd2hpY2ggaW5k
aWNhdGVzIHRoZSBzaXplIG9mCj4gRGV2aWNlIFRhYmxlIGVudHJ5Lgo+IFdlJ3JlIGFsbG9jYXRp
bmcgSVRUIGZvciB0aGlzIGRldmljZSBub3csIHNob3VsZG4ndCB3ZSB1c2UKPiBpdHNfZGF0YS50
eXBlci5lc3o/CgpZZXMgeW91J3JlIGRlZmluaXRpdmVseSByaWdodC4gSSBzaG91bGQgdXNlIGl0
c19kYXRhLnR5cGVyLml0ZV9zaXplLgoKVGhhbmsgeW91IQoKRXJpYwo+IAo+IAo+IFRoYW5rcywK
PiBaZW5naHVpCj4gCj4+ICvCoMKgwqAgb3JkZXIgPSBpc19wb3dlcl9vZl8yKG4pID8gZmxzKG4p
IDogZmxzKG4pICsgMTsKPj4gK8KgwqDCoCBuZXctPml0dCA9ICh2b2lkICopdmlydF90b19waHlz
KGFsbG9jX3BhZ2VzKG9yZGVyKSk7Cj4+ICsKPj4gK8KgwqDCoCBpdHNfZGF0YS5uYl9kZXZpY2Vz
Kys7Cj4+ICvCoMKgwqAgcmV0dXJuIG5ldzsKPj4gK30KPj4gKwo+PiArc3RydWN0IGl0c19jb2xs
ZWN0aW9uICppdHNfY3JlYXRlX2NvbGxlY3Rpb24odTMyIGNvbF9pZCwgdTMyIHBlKQo+PiArewo+
PiArwqDCoMKgIHN0cnVjdCBpdHNfY29sbGVjdGlvbiAqbmV3Owo+PiArCj4+ICvCoMKgwqAgaWYg
KGl0c19kYXRhLm5iX2NvbGxlY3Rpb25zID49IEdJVFNfTUFYX0NPTExFQ1RJT05TKQo+PiArwqDC
oMKgwqDCoMKgwqAgcmVwb3J0X2Fib3J0KCIlcyByZWRpbWVuc2lvbiBHSVRTX01BWF9DT0xMRUNU
SU9OUyIsIF9fZnVuY19fKTsKPj4gKwo+PiArwqDCoMKgIG5ldyA9ICZpdHNfZGF0YS5jb2xsZWN0
aW9uc1tpdHNfZGF0YS5uYl9jb2xsZWN0aW9uc107Cj4+ICsKPj4gK8KgwqDCoCBuZXctPmNvbF9p
ZCA9IGNvbF9pZDsKPj4gKwo+PiArwqDCoMKgIGlmIChpdHNfZGF0YS50eXBlci5wdGEpCj4+ICvC
oMKgwqDCoMKgwqDCoCBuZXctPnRhcmdldF9hZGRyZXNzID0gKHU2NClnaWN2M19kYXRhLnJlZGlz
dF9iYXNlW3BlXTsKPj4gK8KgwqDCoCBlbHNlCj4+ICvCoMKgwqDCoMKgwqDCoCBuZXctPnRhcmdl
dF9hZGRyZXNzID0gcGUgPDwgMTY7Cj4+ICsKPj4gK8KgwqDCoCBpdHNfZGF0YS5uYl9jb2xsZWN0
aW9ucysrOwo+PiArwqDCoMKgIHJldHVybiBuZXc7Cj4+ICt9Cj4+Cj4gCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
