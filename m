Return-Path: <SRS0=+uR8=P5=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CD3C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 14:29:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 837FA61106
	for <kvmarm@archiver.kernel.org>; Wed, 10 Nov 2021 14:29:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 837FA61106
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4F6E4B308;
	Wed, 10 Nov 2021 09:29:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PkMJx2-aDBFb; Wed, 10 Nov 2021 09:29:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C88F4B313;
	Wed, 10 Nov 2021 09:29:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06A844B30A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 09:29:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7Jj2VeMAgssq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Nov 2021 09:29:24 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C906A4B301
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 09:29:24 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1636554564;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bnca2yMtA4WzvVxShB8WJkPxX9FUiW0h7CO30+UcGxs=;
 b=LUtrMMBzEdi4e2YlGn4SOY8eJ/B18uCjKVPgqLxJ/gnvJDl6RLRul0lhIJaMzcGuwUqswy
 t6n9Caez/ywMdpgE3TyzZFRH/qEIu7kW2VlzYcW3Y1u62chAmEaPAwcdKNLb9181XNlBrd
 xsdFMizmPXvTHVCJIAxlo9NMe4MViuY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-CagJpajiOKWuU80dG4YkzA-1; Wed, 10 Nov 2021 09:29:21 -0500
X-MC-Unique: CagJpajiOKWuU80dG4YkzA-1
Received: by mail-wr1-f70.google.com with SMTP id
 z5-20020a5d6405000000b00182083d7d2aso452240wru.13
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Nov 2021 06:29:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=bnca2yMtA4WzvVxShB8WJkPxX9FUiW0h7CO30+UcGxs=;
 b=Z6A6/zeJeNWp0jRv8Kf5HNcKWKCRL21gIFxish6XdU9YFI0l7RPm5zFUVBtFlJzWdp
 Y24lPZBp6DOVNziUe0RPM0lvjYSj2qeWkrybbMiJYlOjjFrmBVvvZzLKF7Q/ThuangZm
 FM2+cREMzrPSnsh3cc+52GVnCROF9DoKwlpRNJemeqDF3ow9eYJiT2/knJniG/2wm3kY
 UGEvMDzBweuv/yoGtNpeOaxRA6GH6ZChLko5r26vhQbG/ELwT2EFNQKOc46Iyj+wUG+8
 AxOww6DnbJbflCKcYQJ3mNuQc7KnU6uKz/Ax4K/h+EDd+cDr2wR89Am/FKKjFmWOLynE
 iAIg==
X-Gm-Message-State: AOAM530lJ3BRg//NrSeuSRx5Qn1pVtIDHn/5jcq8Sx6tj/ZECksbfTZX
 6+JhCzgLOtH6qyNF2yumpB+/ETLsdeDeW/cZC/GFjIDy39lTSHHVLRFUBVX4948sfBZ2WbmzQ+I
 xChcpjj7oOHAPkEPk2w57q+C2
X-Received: by 2002:adf:f10d:: with SMTP id r13mr180073wro.414.1636554560271; 
 Wed, 10 Nov 2021 06:29:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz2szMrbPauSa/I+sU8autgCEFlMAC/W1iydquyymlOm2eFXJw326dRVjIhcOSCJVvTEJzr0A==
X-Received: by 2002:adf:f10d:: with SMTP id r13mr180037wro.414.1636554560015; 
 Wed, 10 Nov 2021 06:29:20 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id o4sm23362wry.80.2021.11.10.06.29.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 10 Nov 2021 06:29:19 -0800 (PST)
Subject: Re: [PATCH v4 00/21] Support SDEI Virtualization
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <eee7eeb2-cedf-e52f-1e5f-403d9edabd94@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <7f5e86dd-b38d-8699-58bd-35db78ec1b7a@redhat.com>
Date: Wed, 10 Nov 2021 15:29:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <eee7eeb2-cedf-e52f-1e5f-403d9edabd94@redhat.com>
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

SGkgR2F2aW4sCgpPbiA4LzE1LzIxIDI6MTkgQU0sIEdhdmluIFNoYW4gd3JvdGU6Cj4gT24gOC8x
NS8yMSAxMDoxMyBBTSwgR2F2aW4gU2hhbiB3cm90ZToKPj4gVGhpcyBzZXJpZXMgaW50ZW5kcyB0
byB2aXJ0dWFsaXplIFNvZnR3YXJlIERlbGVnYXRlZCBFeGNlcHRpb24gSW50ZXJmYWNlCj4+IChT
REVJKSwgd2hpY2ggaXMgZGVmaW5lZCBieSBERU4wMDU0QS4gSXQgYWxsb3dzIHRoZSBoeXBlcnZp
c29yIHRvIGRlbGl2ZXIKPj4gTk1JLWFsaWtlIGV2ZW50IHRvIGd1ZXN0IGFuZCBpdCdzIG5lZWRl
ZCBieSBhc3luY2hyb25vdXMgcGFnZSBmYXVsdCB0bwo+PiBkZWxpdmVyIHBhZ2Utbm90LXByZXNl
bnQgbm90aWZpY2F0aW9uIGZyb20gaHlwZXJ2aXNvciB0byBndWVzdC4gVGhlIGNvZGUKPj4gYW5k
IHRoZSByZXF1aXJlZCBxZW11IGNoYW5nZXMgY2FuIGJlIGZvdW5kIGZyb206Cj4+Cj4+IMKgwqDC
oCBodHRwczovL2RldmVsb3Blci5hcm0uY29tL2RvY3VtZW50YXRpb24vZGVuMDA1NC9sYXRlc3QK
Pj4gwqDCoMKgIGh0dHBzOi8vZ2l0aHViLmNvbS9nd3NoYW4vbGludXjCoMKgwqAgKCJrdm0vYXJt
NjRfc2RlaSIpCj4+IMKgwqDCoCBodHRwczovL2dpdGh1Yi5jb20vZ3dzaGFuL3FlbXXCoMKgwqDC
oCAoImt2bS9hcm02NF9zZGVpIikKPj4KPj4gVGhlIFNERUkgZXZlbnQgaXMgaWRlbnRpZmllZCBi
eSBhIDMyLWJpdHMgbnVtYmVyLiBCaXRzWzMxOjI0XSBhcmUgdXNlZAo+PiB0byBpbmRpY2F0ZSB0
aGUgU0RFSSBldmVudCBwcm9wZXJ0aWVzIHdoaWxlIGJpdHNbMjM6MF0gYXJlIGlkZW50aWZ5aW5n
Cj4+IHRoZSB1bmlxdWUgbnVtYmVyLiBUaGUgaW1wbGVtZW50YXRpb24gdGFrZXMgYml0c1syMzoy
Ml0gdG8gaW5kaWNhdGUgdGhlCj4+IG93bmVyIG9mIHRoZSBTREVJIGV2ZW50LiBGb3IgZXhhbXBs
ZSwgdGhvc2UgU0RFSSBldmVudHMgb3duZWQgYnkgS1ZNCj4+IHNob3VsZCBoYXZlIHRoZXNlIHR3
byBiaXRzIHNldCB0byAwYjAxLiBCZXNpZGVzLCB0aGUgaW1wbGVtZW50YXRpb24KPj4gc3VwcG9y
dHMgU0RFSSBldmVudHMgb3duZWQgYnkgS1ZNIG9ubHkuCj4+Cj4+IFRoZSBkZXNpZ24gaXMgcHJl
dHR5IHN0cmFpZ2h0Zm9yd2FyZCBhbmQgdGhlIGltcGxlbWVudGF0aW9uIGlzIGp1c3QKPj4gZm9s
bG93aW5nIHRoZSBTREVJIHNwZWNpZmljYXRpb24sIHRvIHN1cHBvcnQgdGhlIGRlZmluZWQgU01D
Q0MgaW50ZWZhY2VzLAo+PiBleGNlcHQgdGhlIElSUSBiaW5kaW5nIHN0dWZmLiBUaGVyZSBhcmUg
c2V2ZXJhbCBkYXRhIHN0cnVjdHVyZXMKPj4gaW50cm9kdWNlZC4KPj4gU29tZSBvZiB0aGUgb2Jq
ZWN0cyBoYXZlIHRvIGJlIG1pZ3JhdGVkIGJ5IFZNTS4gU28gdGhlaXIgZGVmaW5pdGlvbnMgYXJl
Cj4+IHNwbGl0IHVwIGZvciBWTU0gdG8gaW5jbHVkZSB0aGUgY29ycmVzcG9uZGluZyBzdGF0ZXMg
Zm9yIG1pZ3JhdGlvbi4KPj4KPj4gwqDCoMKgIHN0cnVjdCBrdm1fc2RlaV9rdm0KPj4gwqDCoMKg
wqDCoMKgIEFzc29jaWF0ZWQgd2l0aCBWTSBhbmQgdXNlZCB0byB0cmFjayB0aGUgS1ZNIGV4cG9z
ZWQgU0RFSSBldmVudHMKPj4gwqDCoMKgwqDCoMKgIGFuZCB0aG9zZSByZWdpc3RlcmVkIGJ5IGd1
ZXN0Lgo+PiDCoMKgwqAgc3RydWN0IGt2bV9zZGVpX3ZjcHUKPj4gwqDCoMKgwqDCoMKgIEFzc29j
aWF0ZWQgd2l0aCB2Q1BVIGFuZCB1c2VkIHRvIHRyYWNrIFNERUkgZXZlbnQgZGVsaXZlcnkuIFRo
ZQo+PiDCoMKgwqDCoMKgwqAgcHJlZW1wdGVkIGNvbnRleHQgaXMgc2F2ZWQgcHJpb3IgdG8gdGhl
IGRlbGl2ZXJ5IGFuZCByZXN0b3JlZAo+PiDCoMKgwqDCoMKgwqAgYWZ0ZXIgdGhhdC4KPj4gwqDC
oMKgIHN0cnVjdCBrdm1fc2RlaV9ldmVudAo+PiDCoMKgwqDCoMKgwqAgU0RFSSBldmVudHMgZXhw
b3NlZCBieSBLVk0gc28gdGhhdCBndWVzdCBjYW4gcmVnaXN0ZXIgYW5kIGVuYWJsZS4KPj4gwqDC
oMKgIHN0cnVjdCBrdm1fc2RlaV9rdm1fZXZlbnQKPj4gwqDCoMKgwqDCoMKgIFNERUkgZXZlbnRz
IHRoYXQgaGF2ZSBiZWVuIHJlZ2lzdGVyZWQgYnkgZ3Vlc3QuCj4+IMKgwqDCoCBzdHJ1Y3Qga3Zt
X3NkZWlfdmNwdV9ldmVudAo+PiDCoMKgwqDCoMKgwqAgU0RFSSBldmVudHMgdGhhdCBoYXZlIGJl
ZW4gcXVldWVkIHRvIHNwZWNpZmljIHZDUFUgZm9yIGRlbGl2ZXJ5Lgo+Pgo+PiBUaGUgc2VyaWVz
IGlzIG9yZ2FuaXplZCBhcyBiZWxvdzoKPj4KPj4gwqDCoMKgIFBBVENIWzAxXcKgwqDCoCBJbnRy
b2R1Y2VzIHRlbXBsYXRlIGZvciBzbWNjY19nZXRfYXJneCgpCj4+IMKgwqDCoCBQQVRDSFswMl3C
oMKgwqAgSW50cm9kdWNlcyB0aGUgZGF0YSBzdHJ1Y3R1cmVzIGFuZCBpbmZyYXN0cnVjdHVyZQo+
PiDCoMKgwqAgUEFUQ0hbMDMtMTRdIFN1cHBvcnRzIHZhcmlvdXMgU0RFSSByZWxhdGVkIGh5cGVy
Y2FsbHMKPj4gwqDCoMKgIFBBVENIWzE1XcKgwqDCoCBTdXBwb3J0cyBTREVJIGV2ZW50IG5vdGlm
aWNhdGlvbgo+PiDCoMKgwqAgUEFUQ0hbMTYtMTddIEludHJvZHVjZXMgaW9jdGwgY29tbWFuZCBm
b3IgbWlncmF0aW9uCj4+IMKgwqDCoCBQQVRDSFsxOC0xOV0gU3VwcG9ydHMgU0RFSSBldmVudCBp
bmplY3Rpb24gYW5kIGNhbmNlbGxhdGlvbgo+PiDCoMKgwqAgUEFUQ0hbMjBdwqDCoMKgIEV4cG9y
dHMgU0RFSSBjYXBhYmlsaXR5Cj4+IMKgwqDCoCBQQVRDSFsyMV3CoMKgwqAgQWRkcyBzZWxmLXRl
c3QgY2FzZSBmb3IgU0RFSSB2aXJ0dWFsaXphdGlvbgo+Pgo+IAo+IFsuLi5dCj4gCj4gSSBleHBs
aWNpdGx5IGNvcGllZCBKYW1lcyBNb3JzZSBhbmQgTWFyayBSdXRsYW5kIHdoZW4gcG9zdGluZyB0
aGUgc2VyaWVzLAo+IGJ1dCBzb21ldGhpbmcgdW5rbm93biB3ZW50IHdyb25nLiBJJ20gaW5jbHVk
aW5nIHRoZW0gaGVyZSB0byBhdm9pZAo+IHJlcG9zdGluZyB0aGUgd2hvbGUgc2VyaWVzLgpJIGRv
bid0IHNlZSBKYW1lcyBub3IgTWFyayBpbmNsdWRlZCBoZXJlIGVpdGhlcgoKRXJpYwo+IAo+IFRo
YW5rcywKPiBHYXZpbgo+IAo+IF9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fCj4ga3ZtYXJtIG1haWxpbmcgbGlzdAo+IGt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKPiBodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2
bWFybQo+IAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
