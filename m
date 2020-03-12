Return-Path: <SRS0=wch9=45=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8CF5C2BB1D
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 09:59:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7BA9F20724
	for <kvmarm@archiver.kernel.org>; Thu, 12 Mar 2020 09:59:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C+aLhxAt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BA9F20724
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E55F74A389;
	Thu, 12 Mar 2020 05:59:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5onVHFPlS0HE; Thu, 12 Mar 2020 05:59:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B98F44A3BF;
	Thu, 12 Mar 2020 05:59:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1B0C4A389
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 05:59:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pSA-6nS1fxTh for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Mar 2020 05:59:44 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D14794A32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Mar 2020 05:59:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1584007184;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VfdtuMjqV4xA6TiIUXqMrT4N1Cfthn1N0mvQcwPp5tg=;
 b=C+aLhxAtAsf4ILUePfUEpS68BRkVqe4cJ6nNWpy+a0xU6ocVb08oSW96fxiGj3XliJsAuF
 T8muTK9UkycGjWF1Rvpvht8OlyLK6VuV30/EvXKI/3ODw/wszQvyOgF9cBs07z9N0FZgPk
 C/SxGjHFPlWAJamsJeldBRseV2QEC9g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-t4xEsr7HMISRGINyRi2OEQ-1; Thu, 12 Mar 2020 05:59:42 -0400
X-MC-Unique: t4xEsr7HMISRGINyRi2OEQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D8FEEDBA3;
 Thu, 12 Mar 2020 09:59:40 +0000 (UTC)
Received: from [10.36.118.12] (unknown [10.36.118.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 91A24272A5;
 Thu, 12 Mar 2020 09:59:35 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 10/13] arm/arm64: ITS: INT functional
 tests
To: Zenghui Yu <yuzenghui@huawei.com>, Marc Zyngier <maz@kernel.org>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-11-eric.auger@redhat.com>
 <d3f651a0-2344-4d6e-111b-be133db7e068@huawei.com>
 <46f0ed1d-3bda-f91b-e2b0-addf1c61c373@redhat.com>
 <301a8b402ff7e480e927b0f8f8b093f2@kernel.org>
 <7fb9f81f-6520-526d-7031-d3d08cb1dd6a@huawei.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <acc652b7-f331-1e48-160c-f07e0e5283b3@redhat.com>
Date: Thu, 12 Mar 2020 10:59:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <7fb9f81f-6520-526d-7031-d3d08cb1dd6a@huawei.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, thuth@redhat.com, kvmarm@lists.cs.columbia.edu,
 eric.auger.pro@gmail.com
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

SGkgWmVuZ2h1aSwKCk9uIDMvMTIvMjAgMTA6MTkgQU0sIFplbmdodWkgWXUgd3JvdGU6Cj4gT24g
MjAyMC8zLzExIDIyOjAwLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4+IFRoYXQgaXMgc3RpbGwgYSBw
cm9ibGVtIHdpdGggdGhlIElUUy4gVGhlcmUgaXMgbm8gYXJjaGl0ZWN0dXJhbCB3YXkKPj4gdG8g
cmVwb3J0IGFuIGVycm9yLCBldmVuIGlmIHRoZSBlcnJvciBudW1iZXJzIGFyZSBhcmNoaXRlY3Rl
ZC4uLgo+Pgo+PiBPbmUgdGhpbmcgd2UgY291bGQgZG8gdGhvdWdoIGlzIHRvIGltcGxlbWVudCB0
aGUgc3RhbGwgbW9kZWwgKGFzCj4+IGRlc2NyaWJlZAo+PiBpbiA1LjMuMikuIEl0IHN0aWxsIGRv
ZXNuJ3QgZ2l2ZSB1cyB0aGUgZXJyb3IsIGJ1dCBhdCBsZWFzdCB0aGUgY29tbWFuZAo+PiBxdWV1
ZSB3b3VsZCBzdG9wIG9uIGRldGVjdGluZyBhbiBlcnJvci4KPiAKPiBJdCB3b3VsZCBiZSBpbnRl
cmVzdGluZyB0byBzZWUgdGhlIGJ1Z2d5IGd1ZXN0J3MgYmVoYXZpb3IgdW5kZXIgdGhlCj4gc3Rh
bGwgbW9kZS4gSSd2ZSB1c2VkIHRoZSBmb2xsb3dpbmcgZGlmZiAoYWJzb2x1dGVseSAqbm90KiBh
IGZvcm1hbAo+IHBhdGNoLCBkb24ndCBoYW5kbGUgQ1JFQURSLlN0YWxsZWQgYW5kIENXUklURVIu
UmV0cnkgYXQgYWxsKSB0byBoYXZlCj4gYSB0cnksIGFuZCBjYXVnaHQgYW5vdGhlciBjb21tYW5k
IGVycm9yIGluIHRoZSAnaXRzLXRyaWdnZXInIHRlc3QuCj4gCj4gbG9ncy9pdHMtdHJpZ2dlci5s
b2c6Cj4gIiBJTlQgZGV2X2lkPTIgZXZlbnRfaWQ9MjAKPiBsaWIvYXJtNjQvZ2ljLXYzLWl0cy1j
bWQuYzoxOTQ6IGFzc2VydCBmYWlsZWQ6IGZhbHNlOiBJTlQgdGltZW91dCEgIgo+IAo+IGRtZXNn
Ogo+IFsxMzI5Ny43MTE5NThdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0tLS0tLQo+
IFsxMzI5Ny43MTE5NjRdIElUUyBjb21tYW5kIGVycm9yIGVuY29kaW5nIDB4MTAzMDcKPiAKPiBJ
dCdzIHRoZSBsYXN0IElOVCB0ZXN0IGluIHRlc3RfaXRzX3RyaWdnZXIoKSB3aG8gaGFzIHRyaWdn
ZXJlZCB0aGlzCj4gZXJyb3IsIEVyaWM/CgpZZXMgaXQgbWF5IGJlIHRoZSBjdWxwcml0LiBBbnl3
YXkgSSByZW1vdmVkIHRoZSBjb2xsZWN0aW9uIHVubWFwIGluIHY2LgoKQnkgdGhlIHdheSBhcmUg
eW91IE9LIG5vdyB3aXRoIHY2PyBJIHRoaW5rIERyZXcgcGxhbnMgdG8gc2VuZCBhIHB1bGwKcmVx
dWVzdCBieSB0aGUgZW5kIG9mIHRoaXMgd2Vlay4KClRoYW5rcwoKRXJpYwo+IAo+IAo+IFRoYW5r
cy4KPiAKPiAtLS04PC0tLQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2t2bS9hcm1fdmdpYy5oIGIv
aW5jbHVkZS9rdm0vYXJtX3ZnaWMuaAo+IGluZGV4IDlkNTNmNTQ1YTNkNS4uNTcxN2Y1ZGEwZjIy
IDEwMDY0NAo+IC0tLSBhL2luY2x1ZGUva3ZtL2FybV92Z2ljLmgKPiArKysgYi9pbmNsdWRlL2t2
bS9hcm1fdmdpYy5oCj4gQEAgLTE3OSw2ICsxNzksNyBAQCBzdHJ1Y3QgdmdpY19pdHMgewo+IMKg
wqDCoMKgIHU2NMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY2Jhc2VyOwo+IMKgwqDCoMKgIHUzMsKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgY3JlYWRyOwo+IMKgwqDCoMKgIHUzMsKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgY3dyaXRlcjsKPiArwqDCoMKgIGJvb2zCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0
YWxsZWQ7Cj4gCj4gwqDCoMKgwqAgLyogbWlncmF0aW9uIEFCSSByZXZpc2lvbiBpbiB1c2UgKi8K
PiDCoMKgwqDCoCB1MzLCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGFiaV9yZXY7Cj4gZGlmZiAtLWdp
dCBhL3ZpcnQva3ZtL2FybS92Z2ljL3ZnaWMtaXRzLmMgYi92aXJ0L2t2bS9hcm0vdmdpYy92Z2lj
LWl0cy5jCj4gaW5kZXggZDUzZDM0YTMzZTM1Li43MjQyMmI3NWU2MjcgMTAwNjQ0Cj4gLS0tIGEv
dmlydC9rdm0vYXJtL3ZnaWMvdmdpYy1pdHMuYwo+ICsrKyBiL3ZpcnQva3ZtL2FybS92Z2ljL3Zn
aWMtaXRzLmMKPiBAQCAtMTUxOSw2ICsxNTE5LDkgQEAgc3RhdGljIHZvaWQgdmdpY19pdHNfcHJv
Y2Vzc19jb21tYW5kcyhzdHJ1Y3Qga3ZtCj4gKmt2bSwgc3RydWN0IHZnaWNfaXRzICppdHMpCj4g
wqDCoMKgwqAgaWYgKCFpdHMtPmVuYWJsZWQpCj4gwqDCoMKgwqDCoMKgwqDCoCByZXR1cm47Cj4g
Cj4gK8KgwqDCoCBpZiAodW5saWtlbHkoaXRzLT5zdGFsbGVkKSkKPiArwqDCoMKgwqDCoMKgwqAg
cmV0dXJuOwo+ICsKPiDCoMKgwqDCoCBjYmFzZXIgPSBHSVRTX0NCQVNFUl9BRERSRVNTKGl0cy0+
Y2Jhc2VyKTsKPiAKPiDCoMKgwqDCoCB3aGlsZSAoaXRzLT5jd3JpdGVyICE9IGl0cy0+Y3JlYWRy
KSB7Cj4gQEAgLTE1MzEsOSArMTUzNCwzNCBAQCBzdGF0aWMgdm9pZCB2Z2ljX2l0c19wcm9jZXNz
X2NvbW1hbmRzKHN0cnVjdCBrdm0KPiAqa3ZtLCBzdHJ1Y3QgdmdpY19pdHMgKml0cykKPiDCoMKg
wqDCoMKgwqDCoMKgwqAgKiBBY2NvcmRpbmcgdG8gc2VjdGlvbiA2LjMuMiBpbiB0aGUgR0lDdjMg
c3BlYyB3ZSBjYW4ganVzdAo+IMKgwqDCoMKgwqDCoMKgwqDCoCAqIGlnbm9yZSB0aGF0IGNvbW1h
bmQgdGhlbi4KPiDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiAtwqDCoMKgwqDCoMKgwqAgaWYgKCFy
ZXQpCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdmdpY19pdHNfaGFuZGxlX2NvbW1hbmQoa3Zt
LCBpdHMsIGNtZF9idWYpOwo+ICvCoMKgwqDCoMKgwqDCoCBpZiAocmV0KQo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGdvdG8gZG9uZTsKPiArCj4gK8KgwqDCoMKgwqDCoMKgIHJldCA9IHZnaWNf
aXRzX2hhbmRsZV9jb21tYW5kKGt2bSwgaXRzLCBjbWRfYnVmKTsKPiArCj4gK8KgwqDCoMKgwqDC
oMKgIC8qCj4gK8KgwqDCoMKgwqDCoMKgwqAgKiBDaG9vc2UgdGhlIHN0YWxsIG1vZGUgb24gZGV0
ZWN0aW9uIG9mIGNvbW1hbmQgZXJyb3JzLgo+ICvCoMKgwqDCoMKgwqDCoMKgICogR3Vlc3Qgc3Rp
bGwgY2FuJ3QgZ2V0IHRoZSBhcmNoaXRlY3RlZCBlcnJvciBudW1iZXJzIHRob3VnaC4uLgo+ICvC
oMKgwqDCoMKgwqDCoMKgICovCj4gK8KgwqDCoMKgwqDCoMKgIGlmIChyZXQpIHsKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAvKiBHSVRTX0NSRUFEUi5TdGFsbGVkIGlzIHNldCB0byAxLiAqLwo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGl0cy0+c3RhbGxlZCA9IHRydWU7Cj4gKwo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIC8qCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIEdJVFNf
VFlQRVIuU0VJUyBpcyAwIGF0bSwgbm8gU3lzdGVtIGVycm9yIHdpbGwgYmUKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgICogZ2VuZXJhdGVkLsKgIEluc3RlYWQgcmVwb3J0IGVycm9yIGVuY29k
aW5ncyBhdCBJVFMKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogbGV2ZWwuCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIFdBUk5fUkFU
RUxJTUlUKHJldCwgIklUUyBjb21tYW5kIGVycm9yIGVuY29kaW5nIDB4JXgiLCByZXQpOwo+ICsK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAvKgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
KiBHSVRTX0NSRUFEUiBpcyBub3QgaW5jcmVtZW50ZWQgYW5kIGNvbnRpbnVlcyB0bwo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBwb2ludCB0byB0aGUgZW50cnkgdGhhdCB0cmlnZ2VyZWQg
dGhlIGVycm9yLgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCBicmVhazsKPiArwqDCoMKgwqDCoMKgwqAgfQo+IAo+ICtkb25lOgo+IMKgwqDC
oMKgwqDCoMKgwqAgaXRzLT5jcmVhZHIgKz0gSVRTX0NNRF9TSVpFOwo+IMKgwqDCoMKgwqDCoMKg
wqAgaWYgKGl0cy0+Y3JlYWRyID09IElUU19DTURfQlVGRkVSX1NJWkUoaXRzLT5jYmFzZXIpKQo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpdHMtPmNyZWFkciA9IDA7Cj4gCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0
Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5l
ZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
