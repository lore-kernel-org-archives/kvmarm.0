Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30A2C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 14:19:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E2114A369;
	Thu, 27 Jan 2022 09:19:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lSYAInFgmhce; Thu, 27 Jan 2022 09:19:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A327749F37;
	Thu, 27 Jan 2022 09:19:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98B6149F32
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 09:19:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gMkNXPMUetaD for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 09:19:41 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E3FE49ED4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 09:19:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643293181;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=zdw6B1+/yghhyiOfWsSzGzXgg3VtutpZI7oStoOL0GI=;
 b=ED5gbT3I9z4uG/a0vYWr8QkFCukTvpdiuy5bzIlI/JRYlNs9aOvJdFHRpolJwbLNSJoG9Q
 Rj45XpjmVieM3WHhQJMQk9XCL1qA9NwlKycdx6LdhwPrgKX0v2rFpDICk8RUnznktBjb8x
 K3VCf5BoYYwAJhn1XQNjKDiysLDLRlI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-170-PVC98qtPOHqpZtl7wwkkYw-1; Thu, 27 Jan 2022 09:19:37 -0500
X-MC-Unique: PVC98qtPOHqpZtl7wwkkYw-1
Received: by mail-wm1-f69.google.com with SMTP id
 s1-20020a1ca901000000b0034ece94dd8cso4255775wme.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 06:19:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=zdw6B1+/yghhyiOfWsSzGzXgg3VtutpZI7oStoOL0GI=;
 b=CBtWk2Cg+xZb7nJVtuI58YJpjs3wZAmVH5/ydX6LGf4GXIyv12WFe6HZ420FkwNjpE
 9P+rjlBKLsIqaskSrySssV3tlvuwFMdaQn/UxH46RrpH4bs4opk8rqmY9n91rKpgFWRm
 Ii4u8S5NbXRTn73nNAItgmdYDOfIWEOs7Ei3GzOApxBMcI7Qjy8bI1Buc46seW6sQLEE
 YH/noc9XZVN5DCI2Ivz4vUN43x74N8peZZquGZiHNT2cxIDxTjo3fZItWHazm/Z1CJfv
 TyQmauGJ9Ovx5AdNSJXXh3JbbxBe0dX+PrP2n6i/QiQvUfu3gRLPmeDNhbaGGCscLn0u
 Ns5g==
X-Gm-Message-State: AOAM532heq/0YyrUUFFdHlVNqobYur4lxTmSQP1h78vs9ZPo1RFL5YO5
 DIATh5mKJAvcA2A6uja6aKcMgiG077BkoOKR09hBSaCA2YwizlOwTVkk0CQy0Y43BJeykeKPTC3
 Wu4I0jvVoynTTYhEVj48IXy9L
X-Received: by 2002:a05:6000:c2:: with SMTP id q2mr3222165wrx.85.1643293176595; 
 Thu, 27 Jan 2022 06:19:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx/UemIofHSAjIkOM40Icl8MDcnSL8ap54lx+rFPtBHcYLstOFs35S+CqvKI+yehQuSceZJCQ==
X-Received: by 2002:a05:6000:c2:: with SMTP id q2mr3222145wrx.85.1643293176325; 
 Thu, 27 Jan 2022 06:19:36 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id j2sm2419005wms.2.2022.01.27.06.19.35
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 27 Jan 2022 06:19:35 -0800 (PST)
Subject: Re: [PATCH v4 09/21] KVM: arm64: Support SDEI_EVENT_GET_INFO hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-10-gshan@redhat.com>
 <03e9b1fb-af79-69bf-f242-00fef3b11a81@redhat.com>
 <44039a09-344f-3ac9-0d58-c0c8c4562b60@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <9764c112-733a-fae5-b198-c0b0b2370f2a@redhat.com>
Date: Thu, 27 Jan 2022 15:19:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <44039a09-344f-3ac9-0d58-c0c8c4562b60@redhat.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eauger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org, pbonzini@redhat.com, will@kernel.org,
 linux-kernel@vger.kernel.org, Jonathan.Cameron@huawei.com
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

SGkgR2F2aW4sCgpPbiAxLzEyLzIyIDM6NDYgQU0sIEdhdmluIFNoYW4gd3JvdGU6Cj4gSGkgRXJp
YywKPiAKPiBPbiAxMS8xMC8yMSAxOjE5IEFNLCBFcmljIEF1Z2VyIHdyb3RlOgo+PiBPbiA4LzE1
LzIxIDI6MTMgQU0sIEdhdmluIFNoYW4gd3JvdGU6Cj4+PiBUaGlzIHN1cHBvcnRzIFNERUlfRVZF
TlRfR0VUX0lORk8gaHlwZXJjYWxsLiBJdCdzIHVzZWQgYnkgdGhlIGd1ZXN0Cj4+PiB0byByZXRy
aWV2ZSB2YXJpb3VzIGluZm9ybWF0aW9uIGFib3V0IHRoZSBzdXBwb3J0ZWQgKGV4cG9ydGVkKSBl
dmVudHMsCj4+PiBpbmNsdWRpbmcgdHlwZSwgc2lnbmFsZWQsIHJvdXRlIG1vZGUgYW5kIGFmZmlu
aXR5IGZvciB0aGUgc2hhcmVkCj4+PiBldmVudHMuCj4+Pgo+Pj4gU2lnbmVkLW9mZi1ieTogR2F2
aW4gU2hhbiA8Z3NoYW5AcmVkaGF0LmNvbT4KPj4+IC0tLQo+Pj4gwqAgYXJjaC9hcm02NC9rdm0v
c2RlaS5jIHwgNzYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+
Pj4gwqAgMSBmaWxlIGNoYW5nZWQsIDc2IGluc2VydGlvbnMoKykKPj4+Cj4+PiBkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9rdm0vc2RlaS5jIGIvYXJjaC9hcm02NC9rdm0vc2RlaS5jCj4+PiBpbmRl
eCBiOTViOGM0NDU1ZTEuLjVkZmE3NGIwOTNmMSAxMDA2NDQKPj4+IC0tLSBhL2FyY2gvYXJtNjQv
a3ZtL3NkZWkuYwo+Pj4gKysrIGIvYXJjaC9hcm02NC9rdm0vc2RlaS5jCj4+PiBAQCAtNDE1LDYg
KzQxNSw4MCBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZwo+Pj4ga3ZtX3NkZWlfaHlwZXJjYWxsX3N0
YXR1cyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4+PiDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+
PiDCoCB9Cj4+PiDCoCArc3RhdGljIHVuc2lnbmVkIGxvbmcga3ZtX3NkZWlfaHlwZXJjYWxsX2lu
Zm8oc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+Pj4gK3sKPj4+ICvCoMKgwqAgc3RydWN0IGt2bSAq
a3ZtID0gdmNwdS0+a3ZtOwo+Pj4gK8KgwqDCoCBzdHJ1Y3Qga3ZtX3NkZWlfa3ZtICprc2RlaSA9
IGt2bS0+YXJjaC5zZGVpOwo+Pj4gK8KgwqDCoCBzdHJ1Y3Qga3ZtX3NkZWlfdmNwdSAqdnNkZWkg
PSB2Y3B1LT5hcmNoLnNkZWk7Cj4+PiArwqDCoMKgIHN0cnVjdCBrdm1fc2RlaV9ldmVudCAqa3Nl
ID0gTlVMTDsKPj4+ICvCoMKgwqAgc3RydWN0IGt2bV9zZGVpX2t2bV9ldmVudCAqa3NrZSA9IE5V
TEw7Cj4+PiArwqDCoMKgIHVuc2lnbmVkIGxvbmcgZXZlbnRfbnVtID0gc21jY2NfZ2V0X2FyZzEo
dmNwdSk7Cj4+PiArwqDCoMKgIHVuc2lnbmVkIGxvbmcgZXZlbnRfaW5mbyA9IHNtY2NjX2dldF9h
cmcyKHZjcHUpOwo+Pj4gK8KgwqDCoCB1bnNpZ25lZCBsb25nIHJldCA9IFNERUlfU1VDQ0VTUzsK
Pj4+ICsKPj4+ICvCoMKgwqAgLyogU2FuaXR5IGNoZWNrICovCj4+PiArwqDCoMKgIGlmICghKGtz
ZGVpICYmIHZzZGVpKSkgewo+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldCA9IFNERUlfTk9UX1NVUFBP
UlRFRDsKPj4+ICvCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsKPj4+ICvCoMKgwqAgfQo+Pj4gKwo+
Pj4gK8KgwqDCoCBpZiAoIWt2bV9zZGVpX2lzX3ZhbGlkX2V2ZW50X251bShldmVudF9udW0pKSB7
Cj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0gU0RFSV9JTlZBTElEX1BBUkFNRVRFUlM7Cj4+PiAr
wqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+PiArwqDCoMKgIH0KPj4+ICsKPj4+ICvCoMKgwqAg
LyoKPj4+ICvCoMKgwqDCoCAqIENoZWNrIGlmIHRoZSBLVk0gZXZlbnQgZXhpc3RzLiBUaGUgZXZl
bnQgbWlnaHQgaGF2ZSBiZWVuCj4+PiArwqDCoMKgwqAgKiByZWdpc3RlcmVkLCB3ZSBuZWVkIGZl
dGNoIHRoZSBpbmZvcm1hdGlvbiBmcm9tIHRoZSByZWdpc3RlcmVkCj4+IHMvZmV0Y2gvdG8gZmV0
Y2gKPiAKPiBBY2suCj4gCj4+PiArwqDCoMKgwqAgKiBldmVudCBpbiB0aGF0IGNhc2UuCj4+PiAr
wqDCoMKgwqAgKi8KPj4+ICvCoMKgwqAgc3Bpbl9sb2NrKCZrc2RlaS0+bG9jayk7Cj4+PiArwqDC
oMKgIGtza2UgPSBrdm1fc2RlaV9maW5kX2t2bV9ldmVudChrdm0sIGV2ZW50X251bSk7Cj4+PiAr
wqDCoMKgIGtzZSA9IGtza2UgPyBrc2tlLT5rc2UgOiBOVUxMOwo+Pj4gK8KgwqDCoCBpZiAoIWtz
ZSkgewo+Pj4gK8KgwqDCoMKgwqDCoMKgIGtzZSA9IGt2bV9zZGVpX2ZpbmRfZXZlbnQoa3ZtLCBl
dmVudF9udW0pOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmICgha3NlKSB7Cj4+PiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCByZXQgPSBTREVJX0lOVkFMSURfUEFSQU1FVEVSUzsKPj4gdGhpcyBzaG91
bGQgaGF2ZSBhbHJlYWR5IGJlIGNvdmVyZWQgYnkgIWt2bV9zZGVpX2lzX3ZhbGlkX2V2ZW50X251
bSBJCj4+IHRoaW5rIChhbHRob3VnaCB0aGlzIGxhdHRlciBvbmx5IGNoZWNrcyB0aGUgc2luY2Ug
c3RhdGljIGV2ZW50IG51bSB3aXRoCj4+IEtWTSBvd25lciBtYXNrKQo+IAo+IE5vcGUuIFN0cmlj
dGx5IHNwZWFraW5nLCBrdm1fc2RlaV9maW5kX2V2ZW50KCkgY292ZXJzIHRoZSBjaGVjayBjYXJy
aWVkCj4gYnkgIWt2bV9zZGVpX2lzX3ZhbGlkX2V2ZW50X251bSgpLiBBbGwgdGhlIGRlZmluZWQg
KGV4cG9zZWQpIGV2ZW50cyBzaG91bGQKPiBoYXZlIHZpcnR1YWwgZXZlbnQgbnVtYmVyIDopCnlv
dSdyZSByaWdodAo+IAo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byB1bmxvY2s7Cj4+
PiArwqDCoMKgwqDCoMKgwqAgfQo+Pj4gK8KgwqDCoCB9Cj4+PiArCj4+PiArwqDCoMKgIC8qIFJl
dHJpZXZlIHRoZSByZXF1ZXN0ZWQgaW5mb3JtYXRpb24gKi8KPj4+ICvCoMKgwqAgc3dpdGNoIChl
dmVudF9pbmZvKSB7Cj4+PiArwqDCoMKgIGNhc2UgU0RFSV9FVkVOVF9JTkZPX0VWX1RZUEU6Cj4+
PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0ga3NlLT5zdGF0ZS50eXBlOwo+Pj4gK8KgwqDCoMKgwqDC
oMKgIGJyZWFrOwo+Pj4gK8KgwqDCoCBjYXNlIFNERUlfRVZFTlRfSU5GT19FVl9TSUdOQUxFRDoK
Pj4+ICvCoMKgwqDCoMKgwqDCoCByZXQgPSBrc2UtPnN0YXRlLnNpZ25hbGVkOwo+Pj4gK8KgwqDC
oMKgwqDCoMKgIGJyZWFrOwo+Pj4gK8KgwqDCoCBjYXNlIFNERUlfRVZFTlRfSU5GT19FVl9QUklP
UklUWToKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXQgPSBrc2UtPnN0YXRlLnByaW9yaXR5Owo+Pj4g
K8KgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4gK8KgwqDCoCBjYXNlIFNERUlfRVZFTlRfSU5GT19F
Vl9ST1VUSU5HX01PREU6Cj4+PiArwqDCoMKgIGNhc2UgU0RFSV9FVkVOVF9JTkZPX0VWX1JPVVRJ
TkdfQUZGOgo+Pj4gK8KgwqDCoMKgwqDCoMKgIGlmIChrc2UtPnN0YXRlLnR5cGUgIT0gU0RFSV9F
VkVOVF9UWVBFX1NIQVJFRCkgewo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0gU0RF
SV9JTlZBTElEX1BBUkFNRVRFUlM7Cj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhazsK
Pj4+ICvCoMKgwqDCoMKgwqDCoCB9Cj4+PiArCj4+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGV2ZW50
X2luZm8gPT0gU0RFSV9FVkVOVF9JTkZPX0VWX1JPVVRJTkdfTU9ERSkgewo+Pj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgcmV0ID0ga3NrZSA/IGtza2UtPnN0YXRlLnJvdXRlX21vZGUgOgo+Pj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgU0RFSV9FVkVOVF9SRUdJ
U1RFUl9STV9BTlk7Cj4+IG5vLCBpZiBldmVudCBpcyBub3QgcmVnaXN0ZXJlZCAoIWtza2UpIERF
TklFRCBzaG91bGQgYmUgcmV0dXJuZWQKPiAKPiBJIGRvbid0IHRoaW5rIHNvLiBBY2NvcmRpbmcg
dG8gdGhlIHNwZWNpZmljYXRpb24sIHRoZXJlIGlzIG5vIERFTklFRAo+IHJldHVybiB2YWx1ZSBm
b3IgU1RBVFVTIGh5cGVyY2FsbC4gRWl0aGVyIElOVkFMSURfUEFSQU1FVEVSUyBvcgo+IE5PVF9T
VVBQT1JURUQKPiBzaG91bGQgYmUgcmV0dXJuZWQgZnJvbSB0aGlzIGh5cGVyY2FsbCA6KQoKTG9v
ayBhdCB0YWJsZSA1LjEuMTAuMiBQYXJhbWV0ZXIgYSxkIFJldHVybiBWYWx1ZXMuIERFTklFRCBp
cyByZXR1cm5lZAppbiBzb21lIGNhc2VzCgpFcmljCj4gCj4+PiArwqDCoMKgwqDCoMKgwqAgfSBl
bHNlIHsKPj4gc2FtZSBoZXJlCj4+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBrc2tl
ID8ga3NrZS0+c3RhdGUucm91dGVfYWZmaW5pdHkgOiAwOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIH0K
Pj4+ICsKPj4+ICvCoMKgwqDCoMKgwqDCoCBicmVhazsKPj4+ICvCoMKgwqAgZGVmYXVsdDoKPj4+
ICvCoMKgwqDCoMKgwqDCoCByZXQgPSBTREVJX0lOVkFMSURfUEFSQU1FVEVSUzsKPj4+ICvCoMKg
wqAgfQo+Pj4gKwo+Pj4gK3VubG9jazoKPj4+ICvCoMKgwqAgc3Bpbl91bmxvY2soJmtzZGVpLT5s
b2NrKTsKPj4+ICtvdXQ6Cj4+PiArwqDCoMKgIHJldHVybiByZXQ7Cj4+PiArfQo+Pj4gKwo+Pj4g
wqAgaW50IGt2bV9zZGVpX2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4+PiDCoCB7
Cj4+PiDCoMKgwqDCoMKgIHUzMiBmdW5jID0gc21jY2NfZ2V0X2Z1bmN0aW9uKHZjcHUpOwo+Pj4g
QEAgLTQ0Niw2ICs1MjAsOCBAQCBpbnQga3ZtX3NkZWlfaHlwZXJjYWxsKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSkKPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBrdm1fc2RlaV9oeXBlcmNhbGxf
c3RhdHVzKHZjcHUpOwo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4gwqDCoMKgwqDC
oCBjYXNlIFNERUlfMV8wX0ZOX1NERUlfRVZFTlRfR0VUX0lORk86Cj4+PiArwqDCoMKgwqDCoMKg
wqAgcmV0ID0ga3ZtX3NkZWlfaHlwZXJjYWxsX2luZm8odmNwdSk7Cj4+PiArwqDCoMKgwqDCoMKg
wqAgYnJlYWs7Cj4+PiDCoMKgwqDCoMKgIGNhc2UgU0RFSV8xXzBfRk5fU0RFSV9FVkVOVF9ST1VU
SU5HX1NFVDoKPj4+IMKgwqDCoMKgwqAgY2FzZSBTREVJXzFfMF9GTl9TREVJX1BFX01BU0s6Cj4+
PiDCoMKgwqDCoMKgIGNhc2UgU0RFSV8xXzBfRk5fU0RFSV9QRV9VTk1BU0s6Cj4+Pgo+IAo+IFRo
YW5rcywKPiBHYXZpbgo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
