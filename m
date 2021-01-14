Return-Path: <SRS0=BtxD=GR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D2AC433E0
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 10:03:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4177023A52
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jan 2021 10:03:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4177023A52
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CAFEB4B176;
	Thu, 14 Jan 2021 05:03:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uoEbmgpskJVZ; Thu, 14 Jan 2021 05:03:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B10EC4B19F;
	Thu, 14 Jan 2021 05:03:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B9B24B176
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 05:03:04 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LqV3b37-oiiP for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jan 2021 05:03:03 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B3B84B19C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jan 2021 05:03:03 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610618583;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=xXjNcBX1zyUVY22wn0iABMXWOTnE52HCbnMakakpYNA=;
 b=icG59PkANdv79vyej/Hw8Rys/CgnIBvuCfoLkjr3YtPcSQaxJE0dJ1gUdPlwf+woP9Cp3O
 yBF7H7hMUwjpvXVAODU3rR+NckZRP6GcSZTBi7xodVRr8FUvtcsj3JINW9YBLZd5bk3O+3
 BARgICKMD6xSOy/D4nNG8lCj6ls6HDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-p58qiEhWMVmNF5ryZwfFhw-1; Thu, 14 Jan 2021 05:03:01 -0500
X-MC-Unique: p58qiEhWMVmNF5ryZwfFhw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8338084A5E8;
 Thu, 14 Jan 2021 10:02:59 +0000 (UTC)
Received: from [10.36.114.165] (ovpn-114-165.ams2.redhat.com [10.36.114.165])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B7CBF71D60;
 Thu, 14 Jan 2021 10:02:56 +0000 (UTC)
Subject: Re: [PATCH 1/9] KVM: arm64: vgic-v3: Fix some error codes when
 setting RDIST base
To: Alexandru Elisei <alexandru.elisei@arm.com>, eric.auger.pro@gmail.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, maz@kernel.org, drjones@redhat.com
References: <20201212185010.26579-1-eric.auger@redhat.com>
 <20201212185010.26579-2-eric.auger@redhat.com>
 <fa73780d-b72b-6810-460e-5ed1057df093@arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <e37f1942-dcb7-3579-0aba-e131e4bd9217@redhat.com>
Date: Thu, 14 Jan 2021 11:02:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fa73780d-b72b-6810-460e-5ed1057df093@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: shuah@kernel.org, pbonzini@redhat.com
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

SGkgQWxleGFuZHJ1LAoKT24gMS82LzIxIDU6MzIgUE0sIEFsZXhhbmRydSBFbGlzZWkgd3JvdGU6
Cj4gSGkgRXJpYywKPiAKPiBPbiAxMi8xMi8yMCA2OjUwIFBNLCBFcmljIEF1Z2VyIHdyb3RlOgo+
PiBLVk1fREVWX0FSTV9WR0lDX0dSUF9BRERSIGdyb3VwIGRvYyBzYXlzIHdlIHNob3VsZCByZXR1
cm4KPj4gLUVFWElTVCBpbiBjYXNlIHRoZSBiYXNlIGFkZHJlc3Mgb2YgdGhlIHJlZGlzdCBpcyBh
bHJlYWR5IHNldC4KPj4gV2UgY3VycmVudGx5IHJldHVybiAtRUlOVkFMLgo+Pgo+PiBIb3dldmVy
IHdlIG5lZWQgdG8gcmV0dXJuIC1FSU5WQUwgaW4gY2FzZSBhIGxlZ2FjeSBSRURJU1QgYWRkcmVz
cwo+PiBpcyBhdHRlbXB0ZWQgdG8gYmUgc2V0IHdoaWxlIFJFRElTVF9SRUdJT05TIHdlcmUgc2V0
LiBUaGlzIGNhc2UKPj4gaXMgZGlzY3JpbWluYXRlZCBieSBsb29raW5nIGF0IHRoZSBjb3VudCBm
aWVsZC4KPj4KPj4gU2lnbmVkLW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQu
Y29tPgo+PiAtLS0KPj4gIGFyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1tbWlvLXYzLmMgfCA5ICsr
KysrKystLQo+PiAgMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkKPj4KPj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1tbWlvLXYzLmMg
Yi9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtbW1pby12My5jCj4+IGluZGV4IDE1YTZjOThlZTky
Zi4uOGU4YTg2MmRlZjc2IDEwMDY0NAo+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMt
bW1pby12My5jCj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy1tbWlvLXYzLmMKPj4g
QEAgLTc5Miw4ICs3OTIsMTMgQEAgc3RhdGljIGludCB2Z2ljX3YzX2luc2VydF9yZWRpc3RfcmVn
aW9uKHN0cnVjdCBrdm0gKmt2bSwgdWludDMyX3QgaW5kZXgsCj4+ICAJaW50IHJldDsKPj4gIAo+
PiAgCS8qIHNpbmdsZSByZGlzdCByZWdpb24gYWxyZWFkeSBzZXQgPyovCj4+IC0JaWYgKCFjb3Vu
dCAmJiAhbGlzdF9lbXB0eShyZF9yZWdpb25zKSkKPj4gLQkJcmV0dXJuIC1FSU5WQUw7Cj4+ICsJ
aWYgKCFjb3VudCAmJiAhbGlzdF9lbXB0eShyZF9yZWdpb25zKSkgewo+PiArCQlyZHJlZyA9IGxp
c3RfbGFzdF9lbnRyeShyZF9yZWdpb25zLAo+PiArCQkJCSAgICAgICBzdHJ1Y3QgdmdpY19yZWRp
c3RfcmVnaW9uLCBsaXN0KTsKPj4gKwkJaWYgKHJkcmVnLT5jb3VudCkKPj4gKwkJCXJldHVybiAt
RUlOVkFMOyAvKiBNaXhpbmcgUkVESVNUIGFuZCBSRURJU1RfUkVHSU9OIEFQSSAqLwo+PiArCQly
ZXR1cm4gLUVFWElTVDsKPj4gKwl9Cj4gCj4gQSBmZXcgaW5zdHJ1Y3Rpb25zIGJlbG93Ogo+IAo+
IMKgwqDCoCBpZiAobGlzdF9lbXB0eShyZF9yZWdpb25zKSkgewo+IMKgwqDCoCDCoMKgwqAgWy4u
XQo+IMKgwqDCoCB9IGVsc2Ugewo+IMKgwqDCoCDCoMKgwqAgcmRyZWcgPSBsaXN0X2xhc3RfZW50
cnkocmRfcmVnaW9ucywKPiDCoMKgwqAgwqDCoMKgIMKgwqDCoCDCoMKgwqAgwqDCoMKgIHN0cnVj
dCB2Z2ljX3JlZGlzdF9yZWdpb24sIGxpc3QpOwo+IMKgwqDCoCDCoMKgwqAgWy4uXQo+IAo+IMKg
wqDCoCDCoMKgwqAgLyogQ2Fubm90IGFkZCBhbiBleHBsaWNpdGx5IHNpemVkIHJlZ2lvbnMgYWZ0
ZXIgbGVnYWN5IHJlZ2lvbiAqLwo+IMKgwqDCoCDCoMKgwqAgaWYgKCFyZHJlZy0+Y291bnQpCj4g
wqDCoMKgIMKgwqDCoCDCoMKgwqAgcmV0dXJuIC1FSU5WQUw7Cj4gwqDCoMKgIH0KPiAKPiBJc24n
dCB0aGlzIHRlc3RpbmcgZm9yIHRoZSBzYW1lIHRoaW5nLCBidXQgdXNpbmcgdGhlIG9wcG9zaXRl
IGNvbmRpdGlvbj8gT3IgYW0gSQo+IG1pc3VuZGVyc3RhbmRpbmcgdGhlIGNvZGUgKHF1aXRlIGxp
a2VseSk/CnRoZSAxc3QgdGVzdCBzZXF1ZW5jZSBoYW5kbGVzIHRoZSBjYXNlIHdoZXJlIHRoZSBs
ZWdhY3kKS1ZNX1ZHSUNfVjNfQUREUl9UWVBFX1JFRElTVCBpcyB1c2VkICghY291bnQpIHdoaWxl
IHRoZSBzZWNvbmQgaGFuZGxlcwp0aGUgY2FzZSB3aGVyZSB0aGUgUkVESVNUX1JFR0lPTiBpcyB1
c2VkLiBOZXZlcnRoZWxlc3MgSSB0aGluayB0aGlzIGNhbgpiZSBzaW1wbGlmaWVkIGludG86Cgog
ICAgICAgIGlmIChsaXN0X2VtcHR5KHJkX3JlZ2lvbnMpKSB7CiAgICAgICAgICAgICAgICBpZiAo
aW5kZXggIT0gMCkKICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7CiAgICAg
ICAgfSBlbHNlIHsKICAgICAgICAgICAgICAgIHJkcmVnID0gbGlzdF9sYXN0X2VudHJ5KHJkX3Jl
Z2lvbnMsCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3Qgdmdp
Y19yZWRpc3RfcmVnaW9uLCBsaXN0KTsKCiAgICAgICAgICAgICAgICBpZiAoKCFjb3VudCkgIT0g
KCFyZHJlZy0+Y291bnQpKQogICAgICAgICAgICAgICAgICAgICAgICByZXR1cm4gLUVJTlZBTDsg
LyogTWl4IFJFRElTVCBhbmQgUkVESVNUX1JFR0lPTiAqLwoKICAgICAgICAgICAgICAgIGlmICgh
Y291bnQpCiAgICAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUVYSVNUOwoKICAgICAgICAg
ICAgICAgIGlmIChpbmRleCAhPSByZHJlZy0+aW5kZXggKyAxKQogICAgICAgICAgICAgICAgICAg
ICAgICByZXR1cm4gLUVJTlZBTDsKICAgICAgICB9CgoKCgoKCj4gCj4gTG9va3MgdG8gbWUgbGlr
ZSBLVk1fREVWX0FSTV9WR0lDX0dSUF9BRERSKEtWTV9WR0lDX1YzX0FERFJfVFlQRV9SRURJU1R7
LF9SRUdJT059KQo+IHVzZWQgdG8gcmV0dXJuIC1FRVhJU1QgKGZyb20gdmdpY19jaGVja19pb2Fk
ZHIoKSkgYmVmb3JlIGNvbW1pdCBjY2MyN2JmNWJlN2I3Cj4gKCJLVk06IGFybS9hcm02NDogSGVs
cGVyIHRvIHJlZ2lzdGVyIGEgbmV3IHJlZGlzdHJpYnV0b3IgcmVnaW9uIikgd2hpY2ggYWRkZWQg
dGhlCj4gdmdpY192M19pbnNlcnRfcmVkaXN0X3JlZ2lvbigpIGZ1bmN0aW9uLCBzbyBicmluZ2lu
ZyBiYWNrIHRoZSAtRUVYSVNUIHJldHVybiBjb2RlCj4gbG9va3MgdGhlIHJpZ2h0IHRoaW5nIHRv
IG1lLgoKT0sgdGhhbmsgeW91IGZvciB0aGUgZGV0YWlsZWQgc3R1ZHkuCgpFcmljCj4gCj4gVGhh
bmtzLAo+IEFsZXgKPj4gIAo+PiAgCS8qIGNyb3NzIHRoZSBlbmQgb2YgbWVtb3J5ID8gKi8KPj4g
IAlpZiAoYmFzZSArIHNpemUgPCBiYXNlKQo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
