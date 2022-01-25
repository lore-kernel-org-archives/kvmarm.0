Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE53C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 18:43:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B939E49EF4;
	Tue, 25 Jan 2022 13:43:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9v9Kft-lO9Nz; Tue, 25 Jan 2022 13:43:05 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AB7D49E35;
	Tue, 25 Jan 2022 13:43:05 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D586D41003
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 13:43:03 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lcEGW8eDzLnW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 13:43:02 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8708240E00
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 13:43:02 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643136182;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=k/E8W/vFo172c5tLpHmdy+vUoVoEPG0qfVKMS8tIOlk=;
 b=bOzVR+JulCFXAfDzR8tu83XPUPrmMdYHhGZbNdC8arC7PSaey8i18eNN+/2hrGB3NtBv8/
 xiEKwLFNcZMfIFL+GbtYKvZaJJLOudWUD6bL/FZLRT0si2e3v9iTvuyvuMQs7zu4D40lSs
 dZLFLfYgI+BMEc97tQuPOj1ZZ8dcrrk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-KusHN2JIPWW2w74AL9fwhA-1; Tue, 25 Jan 2022 13:43:00 -0500
X-MC-Unique: KusHN2JIPWW2w74AL9fwhA-1
Received: by mail-wr1-f69.google.com with SMTP id
 j26-20020adfb31a000000b001d8e22f75fbso3467946wrd.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 10:43:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=k/E8W/vFo172c5tLpHmdy+vUoVoEPG0qfVKMS8tIOlk=;
 b=wwnj7yH1bhScxwCLKjjSWoACRDVx77aoMA+zMGh0AP9ojTC58Jaqbu/8XKZ7/egFSH
 YoANEJ6MSKIXgoS10EpSCBnir/Zzgp/+HPeWQzXt6d+lgZ+8bxHQLZRXGuCL7imDmKGk
 XaOzbjfonrE32hXDVCrcafNkDzRpxRRsQFfKHtYy3U4xIxGhrEZiQdzU73Kjnim07PTg
 TXOyMz/guuIpUSTdPRVoQnltnLxlqL+CxqOdipXALPxnKz8ImynHn9ZLEY8tO42DT4gy
 k/VllSnR0BpmvC2d8e5buFwXS+f9S5P9YD6+v/EG8hlZ0lk9WGI64kP+Qf5fEVK0H9tb
 efeg==
X-Gm-Message-State: AOAM5328sZXZ+LiV4nmEXKs3lMmU8BmiK/O1EpKugTzL2/px8HmIQBLj
 Hq3neEqZomk0GwmpZHKs+8EIBIoBeOkwXvhBGsGIJCvVXtt2lBEE6BEll2ltM35W3cUaLWAnoB7
 MBXAUY//kdnpawSi9a5DvjJSy
X-Received: by 2002:a5d:6d04:: with SMTP id e4mr9512120wrq.398.1643136179216; 
 Tue, 25 Jan 2022 10:42:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyy/7ISkdIjSYoDZ1gzcYOgd0KtipUYjYIsylN82M3L6gXjY9mDWnzDzpKnA0PmGmlx+o5rrA==
X-Received: by 2002:a5d:6d04:: with SMTP id e4mr9512106wrq.398.1643136178982; 
 Tue, 25 Jan 2022 10:42:58 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id 11sm1096881wmx.5.2022.01.25.10.42.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 25 Jan 2022 10:42:58 -0800 (PST)
Subject: Re: [PATCH v4 07/21] KVM: arm64: Support SDEI_EVENT_UNREGISTER
 hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-8-gshan@redhat.com>
 <100a4aa0-6c2d-2fec-6f11-c7e64946ef0b@redhat.com>
 <11022feb-16d7-8732-0d3a-12a65a4e39de@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <60e5b475-2ebb-f697-9024-3afba7a7ab3e@redhat.com>
Date: Tue, 25 Jan 2022 19:42:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <11022feb-16d7-8732-0d3a-12a65a4e39de@redhat.com>
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

SGkgR2F2aW4sCk9uIDEvMTIvMjIgMzozOCBBTSwgR2F2aW4gU2hhbiB3cm90ZToKPiBIaSBFcmlj
LAo+IAo+IE9uIDExLzEwLzIxIDE6MDUgQU0sIEVyaWMgQXVnZXIgd3JvdGU6Cj4+IE9uIDgvMTUv
MjEgMjoxMyBBTSwgR2F2aW4gU2hhbiB3cm90ZToKPj4+IFRoaXMgc3VwcG9ydHMgU0RFSV9FVkVO
VF9VTlJFR0lTVEVSIGh5cGVyY2FsbC4gSXQncyB1c2VkIGJ5IHRoZQo+Pj4gZ3Vlc3QgdG8gdW5y
ZWdpc3RlciBTREVJIGV2ZW50LiBUaGUgU0RFSSBldmVudCB3b24ndCBiZSByYWlzZWQgdG8KPj4+
IHRoZSBndWVzdCBvciBzcGVjaWZpYyB2Q1BVIGFmdGVyIGl0J3MgdW5yZWdpc3RlcmVkIHN1Y2Nl
c3NmdWxseS4KPj4+IEl0J3Mgbm90YWJsZSB0aGUgU0RFSSBldmVudCBpcyBkaXNhYmxlZCBhdXRv
bWF0aWNhbGx5IG9uIHRoZSBndWVzdAo+Pj4gb3Igc3BlY2lmaWMgdkNQVSBvbmNlIGl0J3MgdW5y
ZWdpc3RlcmVkIHN1Y2Nlc3NmdWxseS4KPj4+Cj4+PiBTaWduZWQtb2ZmLWJ5OiBHYXZpbiBTaGFu
IDxnc2hhbkByZWRoYXQuY29tPgo+Pj4gLS0tCj4+PiDCoCBhcmNoL2FybTY0L2t2bS9zZGVpLmMg
fCA2MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCj4+PiDCoCAx
IGZpbGUgY2hhbmdlZCwgNjEgaW5zZXJ0aW9ucygrKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9hcmNo
L2FybTY0L2t2bS9zZGVpLmMgYi9hcmNoL2FybTY0L2t2bS9zZGVpLmMKPj4+IGluZGV4IGI0MTYy
ZWZkYTQ3MC4uYTNiYTY5ZGM5MWNiIDEwMDY0NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc2Rl
aS5jCj4+PiArKysgYi9hcmNoL2FybTY0L2t2bS9zZGVpLmMKPj4+IEBAIC0zMDgsNiArMzA4LDY1
IEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nCj4+PiBrdm1fc2RlaV9oeXBlcmNhbGxfY29udGV4dChz
dHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4+PiDCoMKgwqDCoMKgIHJldHVybiByZXQ7Cj4+PiDCoCB9
Cj4+PiDCoCArc3RhdGljIHVuc2lnbmVkIGxvbmcga3ZtX3NkZWlfaHlwZXJjYWxsX3VucmVnaXN0
ZXIoc3RydWN0IGt2bV92Y3B1Cj4+PiAqdmNwdSkKPj4+ICt7Cj4+PiArwqDCoMKgIHN0cnVjdCBr
dm0gKmt2bSA9IHZjcHUtPmt2bTsKPj4+ICvCoMKgwqAgc3RydWN0IGt2bV9zZGVpX2t2bSAqa3Nk
ZWkgPSBrdm0tPmFyY2guc2RlaTsKPj4+ICvCoMKgwqAgc3RydWN0IGt2bV9zZGVpX3ZjcHUgKnZz
ZGVpID0gdmNwdS0+YXJjaC5zZGVpOwo+Pj4gK8KgwqDCoCBzdHJ1Y3Qga3ZtX3NkZWlfZXZlbnQg
KmtzZSA9IE5VTEw7Cj4+PiArwqDCoMKgIHN0cnVjdCBrdm1fc2RlaV9rdm1fZXZlbnQgKmtza2Ug
PSBOVUxMOwo+Pj4gK8KgwqDCoCB1bnNpZ25lZCBsb25nIGV2ZW50X251bSA9IHNtY2NjX2dldF9h
cmcxKHZjcHUpOwo+Pj4gK8KgwqDCoCBpbnQgaW5kZXggPSAwOwo+Pj4gK8KgwqDCoCB1bnNpZ25l
ZCBsb25nIHJldCA9IFNERUlfU1VDQ0VTUzsKPj4+ICsKPj4+ICvCoMKgwqAgLyogU2FuaXR5IGNo
ZWNrICovCj4+PiArwqDCoMKgIGlmICghKGtzZGVpICYmIHZzZGVpKSkgewo+Pj4gK8KgwqDCoMKg
wqDCoMKgIHJldCA9IFNERUlfTk9UX1NVUFBPUlRFRDsKPj4+ICvCoMKgwqDCoMKgwqDCoCBnb3Rv
IG91dDsKPj4+ICvCoMKgwqAgfQo+Pj4gKwo+Pj4gK8KgwqDCoCBpZiAoIWt2bV9zZGVpX2lzX3Zh
bGlkX2V2ZW50X251bShldmVudF9udW0pKSB7Cj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0gU0RF
SV9JTlZBTElEX1BBUkFNRVRFUlM7Cj4+PiArwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+PiAr
wqDCoMKgIH0KPj4+ICsKPj4+ICvCoMKgwqAgLyogQ2hlY2sgaWYgdGhlIEtWTSBldmVudCBleGlz
dHMgKi8KPj4+ICvCoMKgwqAgc3Bpbl9sb2NrKCZrc2RlaS0+bG9jayk7Cj4+PiArwqDCoMKgIGtz
a2UgPSBrdm1fc2RlaV9maW5kX2t2bV9ldmVudChrdm0sIGV2ZW50X251bSk7Cj4+PiArwqDCoMKg
IGlmICgha3NrZSkgewo+Pj4gK8KgwqDCoMKgwqDCoMKgIHJldCA9IFNERUlfSU5WQUxJRF9QQVJB
TUVURVJTOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGdvdG8gdW5sb2NrOwo+Pj4gK8KgwqDCoCB9Cj4+
PiArCj4+PiArwqDCoMKgIC8qIENoZWNrIGlmIHRoZXJlIGlzIHBlbmRpbmcgZXZlbnRzICovCj4+
PiArwqDCoMKgIGlmIChrc2tlLT5zdGF0ZS5yZWZjb3VudCkgewo+Pj4gK8KgwqDCoMKgwqDCoMKg
IHJldCA9IFNERUlfUEVORElORzsKPj4gZG9uJ3QgeW91IHdhbnQgdG8gcmVjb3JkIHRoZSBmYWN0
IHRoZSB1bnJlZ2lzdHJhdGlvbiBpcyBvdXRzdGFuZGluZyB0bwo+PiBwZXJmb3JtIHN1YnNlcXVl
bnQgYWN0aW9ucz8gT3RoZXJ3aXNlIG5vdGhpbmcgd2lsbCBoYXBlbiB3aGVuIHRoZQo+PiBjdXJy
ZW50IGV4ZWN1dGluZyBoYW5kbGVycyBjb21wbGV0ZT8+Cj4gSXQncyBub3QgbmVjZXNzYXJ5LiBU
aGUgZ3Vlc3Qgc2hvdWxkIHJldHJ5IGluIHRoaXMgY2FzZS4KCkkgZG8gbm90IHVuZGVyc3RhbmQg
dGhhdCBmcm9tIHRoZSBzcGVjOgo2LjcgVW5yZWdpc3RlcmluZyBhbiBldmVudCBzYXlzCgpXaXRo
IHRoZSBQRU5ESU5HIHN0YXR1cywgdGhlIHVucmVnaXN0ZXIgcmVxdWVzdCB3aWxsIGJlIHF1ZXVl
ZCB1bnRpbCB0aGUKZXZlbnQgaXMgY29tcGxldGVkIHVzaW5nIFNERUlfRVZFTlRfQ09NUExFVEUg
LgoKQWxzbyB0aGVyZSBpcyBzdGF0ZSBjYWxsZWQgIkhhbmRsZXItdW5yZWdpc3Rlci1wZW5kaW5n
IgoKQnV0IHdlbGwgSSB3b3VsZCBuZWVkIHRvIGRpZyBmdXJ0aGVyIGludG8gdGhlIHNwZWMgYWdh
aW4gOikKCgo+IAo+Pj4gK8KgwqDCoMKgwqDCoMKgIGdvdG8gdW5sb2NrOwo+Pj4gK8KgwqDCoCB9
Cj4+PiArCj4+PiArwqDCoMKgIC8qIENoZWNrIGlmIGl0IGhhcyBiZWVuIHJlZ2lzdGVyZWQgKi8K
Pj4+ICvCoMKgwqAga3NlID0ga3NrZS0+a3NlOwo+Pj4gK8KgwqDCoCBpbmRleCA9IChrc2UtPnN0
YXRlLnR5cGUgPT0gU0RFSV9FVkVOVF9UWVBFX1BSSVZBVEUpID8KPj4+ICvCoMKgwqDCoMKgwqDC
oCB2Y3B1LT52Y3B1X2lkeCA6IDA7Cj4+IHlvdSBjb3VsZCBoYXZlIGFuIGlubGluZSBmb3IgdGhl
IGFib3ZlIGFzIHRoaXMgaXMgZXhlY3V0ZWQgaW4gbWFueQo+PiBmdW5jdGlvbnMuIGV2ZW4gaW5j
bHVkaW5nIHRoZSBjb2RlIGJlbG93Lgo+IAo+IE9rLCBpdCdzIGEgZ29vZCBpZGVhLgo+IAo+Pj4g
K8KgwqDCoCBpZiAoIWt2bV9zZGVpX2lzX3JlZ2lzdGVyZWQoa3NrZSwgaW5kZXgpKSB7Cj4+PiAr
wqDCoMKgwqDCoMKgwqAgcmV0ID0gU0RFSV9ERU5JRUQ7Cj4+PiArwqDCoMKgwqDCoMKgwqAgZ290
byB1bmxvY2s7Cj4+PiArwqDCoMKgIH0KPj4+ICsKPj4+ICvCoMKgwqAgLyogVGhlIGV2ZW50IGlz
IGRpc2FibGVkIHdoZW4gaXQncyB1bnJlZ2lzdGVyZWQgKi8KPj4+ICvCoMKgwqAga3ZtX3NkZWlf
Y2xlYXJfZW5hYmxlZChrc2tlLCBpbmRleCk7Cj4+PiArwqDCoMKgIGt2bV9zZGVpX2NsZWFyX3Jl
Z2lzdGVyZWQoa3NrZSwgaW5kZXgpOwo+Pj4gK8KgwqDCoCBpZiAoa3ZtX3NkZWlfZW1wdHlfcmVn
aXN0ZXJlZChrc2tlKSkgewo+PiBhIHJlZmNvdW50IG1lY2hhbmlzbSB3b3VsZCBiZSBjbGVhbmVy
IEkgdGhpbmsuCj4gCj4gQSByZWZjb3VudCBpc24ndCB3b3JraW5nIHdlbGwuIFdlIG5lZWQgYSBt
YXBwaW5nIGhlcmUgYmVjYXVzZSB0aGUgcHJpdmF0ZQo+IFNERUkgZXZlbnQgY2FuIGJlIGVuYWJs
ZWQvcmVnaXN0ZXJlZCBvbiBtdWx0aXBsZSB2Q1BVcy4gV2UgbmVlZCB0byBrbm93Cj4gdGhlIGV4
YWN0IHZDUFVzIHdoZXJlIHRoZSBwcml2YXRlIFNERUkgZXZlbnQgaXMgZW5hYmxlZC9yZWdpc3Rl
cmVkLgoKSSBkb24ndCBnZXQgd2h5IHlvdSBjYW4ndCBpbmNyZW1lbnQvZGVjcmVtZW50IHRoZSBy
ZWYgY291bnQgZWFjaCB0aW1lCnRoZSBldmVudCBpcyByZWdpc3RlcmVkL3VucmVnaXN0ZXJlZCBi
eSBhIGdpdmVuIHZjcHUgdG8gbWFuYWdlIGl0cyBsaWZlCmN5Y2xlPyBEb2VzIG5vdCBtZWFuIHlv
dSBkb24ndCBuZWVkIHRoZSBiaXRtYXAgdG8ga25vdyB0aGUgYWN0dWFsIG1hcHBpbmcuCgpUaGFu
a3MKCkVyaWMKPiAKPj4+ICvCoMKgwqDCoMKgwqDCoCBsaXN0X2RlbCgma3NrZS0+bGluayk7Cj4+
PiArwqDCoMKgwqDCoMKgwqAga2ZyZWUoa3NrZSk7Cj4+PiArwqDCoMKgIH0KPj4+ICsKPj4+ICt1
bmxvY2s6Cj4+PiArwqDCoMKgIHNwaW5fdW5sb2NrKCZrc2RlaS0+bG9jayk7Cj4+PiArb3V0Ogo+
Pj4gK8KgwqDCoCByZXR1cm4gcmV0Owo+Pj4gK30KPj4+ICsKPj4+IMKgIGludCBrdm1fc2RlaV9o
eXBlcmNhbGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+Pj4gwqAgewo+Pj4gwqDCoMKgwqDCoCB1
MzIgZnVuYyA9IHNtY2NjX2dldF9mdW5jdGlvbih2Y3B1KTsKPj4+IEBAIC0zMzMsNiArMzkyLDgg
QEAgaW50IGt2bV9zZGVpX2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpCj4+PiDCoMKg
wqDCoMKgIGNhc2UgU0RFSV8xXzBfRk5fU0RFSV9FVkVOVF9DT01QTEVURToKPj4+IMKgwqDCoMKg
wqAgY2FzZSBTREVJXzFfMF9GTl9TREVJX0VWRU5UX0NPTVBMRVRFX0FORF9SRVNVTUU6Cj4+PiDC
oMKgwqDCoMKgIGNhc2UgU0RFSV8xXzBfRk5fU0RFSV9FVkVOVF9VTlJFR0lTVEVSOgo+Pj4gK8Kg
wqDCoMKgwqDCoMKgIHJldCA9IGt2bV9zZGVpX2h5cGVyY2FsbF91bnJlZ2lzdGVyKHZjcHUpOwo+
Pj4gK8KgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4gwqDCoMKgwqDCoCBjYXNlIFNERUlfMV8wX0ZO
X1NERUlfRVZFTlRfU1RBVFVTOgo+Pj4gwqDCoMKgwqDCoCBjYXNlIFNERUlfMV8wX0ZOX1NERUlf
RVZFTlRfR0VUX0lORk86Cj4+PiDCoMKgwqDCoMKgIGNhc2UgU0RFSV8xXzBfRk5fU0RFSV9FVkVO
VF9ST1VUSU5HX1NFVDoKPj4+Cj4gCj4gVGhhbmtzLAo+IEdhdmluCj4gCgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
