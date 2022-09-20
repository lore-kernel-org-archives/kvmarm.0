Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15535ECAAD8
	for <kvmarm@archiver.kernel.org>; Tue, 20 Sep 2022 09:23:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DC1340B59;
	Tue, 20 Sep 2022 05:23:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jCaHy1OYdYr0; Tue, 20 Sep 2022 05:23:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9E214B636;
	Tue, 20 Sep 2022 05:23:33 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 053034B629
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 05:23:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6cLpoadMArMf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Sep 2022 05:23:30 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 77DEC40755
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 05:23:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1663665810;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=GSf87BSSgNT/V3eE50g8WgBHpFjYwLE65SvSOgqQPh4=;
 b=gx+sRURhcG2x6vFG03Shk4VZklufMKdSclrO1D8boSvKjZF+Z70JSIYb+Zil9R3hQFMtHH
 QXA1Wnpgt/l1PMcNTb21TTydpvZ93gmQUtILmkS9w+2gfkWVryPgerZGY2cg8hcpQDGf3v
 sWlgy+CheglPs1S/FhC9U2+6HmwNvyk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-37-GVX_bV5UOomwsNQRLhloXA-1; Tue, 20 Sep 2022 05:23:28 -0400
X-MC-Unique: GVX_bV5UOomwsNQRLhloXA-1
Received: by mail-ej1-f70.google.com with SMTP id
 nb35-20020a1709071ca300b007805be52049so1041372ejc.17
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Sep 2022 02:23:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:in-reply-to:from:references:cc:to
 :content-language:subject:reply-to:user-agent:mime-version:date
 :message-id:x-gm-message-state:from:to:cc:subject:date;
 bh=GSf87BSSgNT/V3eE50g8WgBHpFjYwLE65SvSOgqQPh4=;
 b=PpKhcGW2YgNrCn+u3vWfGOw8OqGsw9taA/RtLT62opBjgH7amfYkosztVA3Cstp1j1
 +lzS7PP9W1MhMHAxS18REHpIuqdyMjHdbAxquFBkYJS8HLjoibOWY4ywOhHl8G+fiCwM
 h972r8vhpGApXag3t+DvW7ieDWdH1LEiO/g3o7xmDfG2cSscEvK3sGh+EIPcuQBQI+XV
 3fc2Kd5pioOecDL/Z99DESfpdDfXoEXYiHCzuoVZ38PTv1Pj0BOI/a1dbZCmIZeWygzw
 gppnQ7o8+lSA6WbdvWf1eH0D8rdJ2jSPgVqTpXNAasDSMHVtSJTo8LwbuVXHG2Q7L/6R
 KfBg==
X-Gm-Message-State: ACrzQf2MbcgwxPj6yB6W/TmFi5cp7Chi5HvXxE7mJBmsYW7p2ZCFDnnH
 k3IuME5hyknGA8LVS6JuO0mqJoIfHPr+fMrvXSuP06XOc1bEFD4kQG2hCEyzoXspfQ0qvNrpEg8
 4x7El95voTZe8QqrobLaP3xbg
X-Received: by 2002:a05:6402:510c:b0:451:f363:24ee with SMTP id
 m12-20020a056402510c00b00451f36324eemr19402273edd.156.1663665807805; 
 Tue, 20 Sep 2022 02:23:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7THS77/1aqAMyw96VtLINHAQS+Y0X3Fmcn7BxfNJgup6o0hnv6228D6cJl3NPO0wZnB0KUCw==
X-Received: by 2002:a05:6402:510c:b0:451:f363:24ee with SMTP id
 m12-20020a056402510c00b00451f36324eemr19402256edd.156.1663665807600; 
 Tue, 20 Sep 2022 02:23:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 d28-20020a056402401c00b0044e7862ab3fsm952192eda.7.2022.09.20.02.23.26
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 20 Sep 2022 02:23:26 -0700 (PDT)
Message-ID: <82f23813-a8ca-d350-891f-100d23c9601e@redhat.com>
Date: Tue, 20 Sep 2022 11:23:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v4 07/12] arm: pmu: Basic event counter
 Tests
To: Zenghui Yu <yuzenghui@huawei.com>
References: <20200403071326.29932-1-eric.auger@redhat.com>
 <20200403071326.29932-8-eric.auger@redhat.com>
 <8fa32eeb-f629-6c27-3b5f-a9a81656a679@huawei.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <8fa32eeb-f629-6c27-3b5f-a9a81656a679@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, maz@kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, andre.przywara@arm.com, andrew.murray@arm.com,
 kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

SGkgWmVuZ2h1aSwKCk9uIDkvMTkvMjIgMTY6MzAsIFplbmdodWkgWXUgd3JvdGU6Cj4gSGkgRXJp
YywKPgo+IEEgZmV3IGNvbW1lbnRzIHdoZW4gbG9va2luZyB0aHJvdWdoIHRoZSBQTVUgdGVzdCBj
b2RlICgyIHllYXJzIGFmdGVyCj4gdGhlIHNlcmllcyB3YXMgbWVyZ2VkKS4KClRoYW5rIHlvdSBm
b3IgcmV2aWV3aW5nIGV2ZW4gYWZ0ZXIgdGhpcyB0aW1lISBEbyB5b3Ugd2FudCB0byBhZGRyZXNz
IHRoZQppc3N1ZXMgeW91cnNlbGYgYW5kIHNlbmQgYSBwYXRjaCBzZXJpZXMgb3IgZG8geW91IHBy
ZWZlciBJIHByb2NlZWQ/CgpUaGFua3MKCkVyaWMKPiBPbiAyMDIwLzQvMyAxNToxMywgRXJpYyBB
dWdlciB3cm90ZToKPj4gQWRkcyB0aGUgZm9sbG93aW5nIHRlc3RzOgo+PiAtIGV2ZW50LWNvdW50
ZXItY29uZmlnOiB0ZXN0IGV2ZW50IGNvdW50ZXIgY29uZmlndXJhdGlvbgo+PiAtIGJhc2ljLWV2
ZW50LWNvdW50Ogo+PiDCoCAtIHByb2dyYW1zIGNvdW50ZXJzICMwIGFuZCAjMSB0byBjb3VudCAy
IHJlcXVpcmVkIGV2ZW50cwo+PiDCoCAocmVzcC4gQ1BVX0NZQ0xFUyBhbmQgSU5TVF9SRVRJUkVE
KS4gQ291bnRlciAjMCBpcyBwcmVzZXQKPj4gwqAgdG8gYSB2YWx1ZSBjbG9zZSBlbm91Z2ggdG8g
dGhlIDMyYgo+PiDCoCBvdmVyZmxvdyBsaW1pdCBzbyB0aGF0IHdlIGNoZWNrIHRoZSBvdmVyZmxv
dyBiaXQgaXMgc2V0Cj4+IMKgIGFmdGVyIHRoZSBleGVjdXRpb24gb2YgdGhlIGFzbSBsb29wLgo+
PiAtIG1lbS1hY2Nlc3M6IGNvdW50cyBNRU1fQUNDRVNTIGV2ZW50IG9uIGNvdW50ZXJzICMwIGFu
ZCAjMQo+PiDCoCB3aXRoIGFuZCB3aXRob3V0IDMyLWJpdCBvdmVyZmxvdy4KPj4KPj4gU2lnbmVk
LW9mZi1ieTogRXJpYyBBdWdlciA8ZXJpYy5hdWdlckByZWRoYXQuY29tPgo+PiBSZXZpZXdlZC1i
eTogQW5kcmUgUHJ6eXdhcmEgPGFuZHJlLnByenl3YXJhQGFybS5jb20+Cj4KPiBbLi4uXQo+Cj4+
IGRpZmYgLS1naXQgYS9hcm0vcG11LmMgYi9hcm0vcG11LmMKPj4gaW5kZXggOGM0OWU1MC4uNDVk
Y2NmNyAxMDA2NDQKPj4gLS0tIGEvYXJtL3BtdS5jCj4+ICsrKyBiL2FybS9wbXUuYwo+PiBAQCAt
MzgsNiArNDMsNyBAQAo+PiDCoCNkZWZpbmUgU1dfSU5DUsKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
MHgwCj4+IMKgI2RlZmluZSBJTlNUX1JFVElSRUTCoMKgwqDCoMKgwqDCoCAweDgKPj4gwqAjZGVm
aW5lIENQVV9DWUNMRVPCoMKgwqDCoMKgwqDCoCAweDExCj4+ICsjZGVmaW5lIE1FTV9BQ0NFU1PC
oMKgwqDCoMKgwqDCoCAweDEzCj4+IMKgI2RlZmluZSBJTlNUX1BSRUPCoMKgwqDCoMKgwqDCoCAw
eDFCCj4KPiBUaGUgc3BlYyBzcGVsbHMgZXZlbnQgMHgwMDFCIGFzIElOU1RfU1BFQy4KPgo+PiDC
oCNkZWZpbmUgU1RBTExfRlJPTlRFTkTCoMKgwqDCoMKgwqDCoCAweDIzCj4+IMKgI2RlZmluZSBT
VEFMTF9CQUNLRU5EwqDCoMKgwqDCoMKgwqAgMHgyNAo+Cj4gWy4uLl0KPgo+PiBAQCAtMTc1LDYg
KzE4OCwxMSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgcHJlY2lzZV9pbnN0cnNfbG9vcChpbnQgbG9v
cCwKPj4gdWludDMyX3QgcG1jcikKPj4gwqB9Cj4+IMKgCj4+IMKgI2RlZmluZSBQTUNFSUQxX0VM
MCBzeXNfcmVnKDMsIDMsIDksIDEyLCA3KQo+PiArI2RlZmluZSBQTUNOVEVOU0VUX0VMMCBzeXNf
cmVnKDMsIDMsIDksIDEyLCAxKQo+PiArI2RlZmluZSBQTUNOVEVOQ0xSX0VMMCBzeXNfcmVnKDMs
IDMsIDksIDEyLCAyKQo+PiArCj4+ICsjZGVmaW5lIFBNRVZUWVBFUl9FWENMVURFX0VMMSBCSVQo
MzEpCj4KPiBVbnVzZWQgbWFjcm8uCj4KPj4gKyNkZWZpbmUgUE1FVlRZUEVSX0VYQ0xVREVfRUww
IEJJVCgzMCkKPj4gwqAKPj4gwqBzdGF0aWMgYm9vbCBpc19ldmVudF9zdXBwb3J0ZWQodWludDMy
X3QgbiwgYm9vbCB3YXJuKQo+PiDCoHsKPj4gQEAgLTIyOCw2ICsyNDYsMjI0IEBAIHN0YXRpYyB2
b2lkIHRlc3RfZXZlbnRfaW50cm9zcGVjdGlvbih2b2lkKQo+PiDCoMKgwqDCoCByZXBvcnQocmVx
dWlyZWRfZXZlbnRzLCAiQ2hlY2sgcmVxdWlyZWQgZXZlbnRzIGFyZSBpbXBsZW1lbnRlZCIpOwo+
PiDCoH0KPj4gwqAKPj4gKy8qCj4+ICsgKiBFeHRyYSBpbnN0cnVjdGlvbnMgaW5zZXJ0ZWQgYnkg
dGhlIGNvbXBpbGVyIHdvdWxkIGJlIGRpZmZpY3VsdCB0bwo+PiBjb21wZW5zYXRlCj4+ICsgKiBm
b3IsIHNvIGhhbmQgYXNzZW1ibGUgZXZlcnl0aGluZyBiZXR3ZWVuLCBhbmQgaW5jbHVkaW5nLCB0
aGUgUE1DUgo+PiBhY2Nlc3Nlcwo+PiArICogdG8gc3RhcnQgYW5kIHN0b3AgY291bnRpbmcuIGlz
YiBpbnN0cnVjdGlvbnMgYXJlIGluc2VydGVkIHRvIG1ha2UKPj4gc3VyZQo+PiArICogcG1jY250
ciByZWFkIGFmdGVyIHRoaXMgZnVuY3Rpb24gcmV0dXJucyB0aGUgZXhhY3QgaW5zdHJ1Y3Rpb25z
Cj4+IGV4ZWN1dGVkCj4+ICsgKiBpbiB0aGUgY29udHJvbGxlZCBibG9jay4gTG9hZHMgQGxvb3Ag
dGltZXMgdGhlIGRhdGEgYXQgQGFkZHJlc3MKPj4gaW50byB4OS4KPj4gKyAqLwo+PiArc3RhdGlj
IHZvaWQgbWVtX2FjY2Vzc19sb29wKHZvaWQgKmFkZHIsIGludCBsb29wLCB1aW50MzJfdCBwbWNy
KQo+PiArewo+PiArYXNtIHZvbGF0aWxlKAo+PiArwqDCoMKgICLCoMKgwqDCoMKgwqAgbXNywqDC
oMKgwqAgcG1jcl9lbDAsICVbcG1jcl1cbiIKPj4gK8KgwqDCoCAiwqDCoMKgwqDCoMKgIGlzYlxu
Igo+PiArwqDCoMKgICLCoMKgwqDCoMKgwqAgbW92wqDCoMKgwqAgeDEwLCAlW2xvb3BdXG4iCj4+
ICvCoMKgwqAgIjE6wqDCoMKgwqAgc3ViwqDCoMKgwqAgeDEwLCB4MTAsICMxXG4iCj4+ICvCoMKg
wqAgIsKgwqDCoMKgwqDCoCBsZHLCoMKgwqAgeDksIFslW2FkZHJdXVxuIgo+PiArwqDCoMKgICLC
oMKgwqDCoMKgwqAgY21wwqDCoMKgwqAgeDEwLCAjMHgwXG4iCj4+ICvCoMKgwqAgIsKgwqDCoMKg
wqDCoCBiLmd0wqDCoMKgIDFiXG4iCj4+ICvCoMKgwqAgIsKgwqDCoMKgwqDCoCBtc3LCoMKgwqDC
oCBwbWNyX2VsMCwgeHpyXG4iCj4+ICvCoMKgwqAgIsKgwqDCoMKgwqDCoCBpc2JcbiIKPj4gK8Kg
wqDCoCA6Cj4+ICvCoMKgwqAgOiBbYWRkcl0gInIiIChhZGRyKSwgW3BtY3JdICJyIiAocG1jciks
IFtsb29wXSAiciIgKGxvb3ApCj4+ICvCoMKgwqAgOiAieDkiLCAieDEwIiwgImNjIik7Cj4+ICt9
Cj4+ICsKPj4gK3N0YXRpYyB2b2lkIHBtdV9yZXNldCh2b2lkKQo+PiArewo+PiArwqDCoMKgIC8q
IHJlc2V0IGFsbCBjb3VudGVycywgY291bnRpbmcgZGlzYWJsZWQgYXQgUE1DUiBsZXZlbCovCj4+
ICvCoMKgwqAgc2V0X3BtY3IocG11LnBtY3Jfcm8gfCBQTVVfUE1DUl9MQyB8IFBNVV9QTUNSX0Mg
fCBQTVVfUE1DUl9QKTsKPj4gK8KgwqDCoCAvKiBEaXNhYmxlIGFsbCBjb3VudGVycyAqLwo+PiAr
wqDCoMKgIHdyaXRlX3N5c3JlZ19zKEFMTF9TRVQsIFBNQ05URU5DTFJfRUwwKTsKPj4gK8KgwqDC
oCAvKiBjbGVhciBvdmVyZmxvdyByZWcgKi8KPj4gK8KgwqDCoCB3cml0ZV9zeXNyZWcoQUxMX1NF
VCwgcG1vdnNjbHJfZWwwKTsKPj4gK8KgwqDCoCAvKiBkaXNhYmxlIG92ZXJmbG93IGludGVycnVw
dHMgb24gYWxsIGNvdW50ZXJzICovCj4+ICvCoMKgwqAgd3JpdGVfc3lzcmVnKEFMTF9TRVQsIHBt
aW50ZW5jbHJfZWwxKTsKPj4gK8KgwqDCoCBpc2IoKTsKPj4gK30KPj4gKwo+PiArc3RhdGljIHZv
aWQgdGVzdF9ldmVudF9jb3VudGVyX2NvbmZpZyh2b2lkKQo+PiArewo+PiArwqDCoMKgIGludCBp
Owo+PiArCj4+ICvCoMKgwqAgaWYgKCFwbXUubmJfaW1wbGVtZW50ZWRfY291bnRlcnMpIHsKPj4g
K8KgwqDCoMKgwqDCoMKgIHJlcG9ydF9za2lwKCJObyBldmVudCBjb3VudGVyLCBza2lwIC4uLiIp
Owo+PiArwqDCoMKgwqDCoMKgwqAgcmV0dXJuOwo+PiArwqDCoMKgIH0KPj4gKwo+PiArwqDCoMKg
IHBtdV9yZXNldCgpOwo+PiArCj4+ICvCoMKgwqAgLyoKPj4gK8KgwqDCoMKgICogVGVzdCBzZXR0
aW5nIHRocm91Z2ggUE1FU0VMUi9QTVhFVlRZUEVSIGFuZCBQTUVWVFlQRVJuIHJlYWQsCj4KPiBz
L1BNRVNFTFIvUE1TRUxSLyA/Cj4KPj4gK8KgwqDCoMKgICogc2VsZWN0IGNvdW50ZXIgMAo+PiAr
wqDCoMKgwqAgKi8KPj4gK8KgwqDCoCB3cml0ZV9zeXNyZWcoMSwgUE1TRUxSX0VMMCk7Cj4+ICvC
oMKgwqAgLyogcHJvZ3JhbSB0aGlzIGNvdW50ZXIgdG8gY291bnQgdW5zdXBwb3J0ZWQgZXZlbnQg
Ki8KPj4gK8KgwqDCoCB3cml0ZV9zeXNyZWcoMHhFQSwgUE1YRVZUWVBFUl9FTDApOwo+PiArwqDC
oMKgIHdyaXRlX3N5c3JlZygweGRlYWRiZWVmLCBQTVhFVkNOVFJfRUwwKTsKPj4gK8KgwqDCoCBy
ZXBvcnQoKHJlYWRfcmVnbl9lbDAocG1ldnR5cGVyLCAxKSAmIDB4RkZGKSA9PSAweEVBLAo+PiAr
wqDCoMKgwqDCoMKgwqAgIlBNRVNFTFIvUE1YRVZUWVBFUi9QTUVWVFlQRVJuIik7Cj4KPiBEaXR0
bwo+Cj4+ICvCoMKgwqAgcmVwb3J0KChyZWFkX3JlZ25fZWwwKHBtZXZjbnRyLCAxKSA9PSAweGRl
YWRiZWVmKSwKPj4gK8KgwqDCoMKgwqDCoMKgICJQTUVTRUxSL1BNWEVWQ05UUi9QTUVWQ05UUm4i
KTsKPgo+IERpdHRvCj4KPj4gKwo+PiArwqDCoMKgIC8qIHRyeSB0byBjb25maWd1cmUgYW4gdW5z
dXBwb3J0ZWQgZXZlbnQgd2l0aGluIHRoZSByYW5nZSBbMHgwLAo+PiAweDNGXSAqLwo+PiArwqDC
oMKgIGZvciAoaSA9IDA7IGkgPD0gMHgzRjsgaSsrKSB7Cj4+ICvCoMKgwqDCoMKgwqDCoCBpZiAo
IWlzX2V2ZW50X3N1cHBvcnRlZChpLCBmYWxzZSkpCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IGJyZWFrOwo+PiArwqDCoMKgIH0KPj4gK8KgwqDCoCBpZiAoaSA+IDB4M0YpIHsKPj4gK8KgwqDC
oMKgwqDCoMKgIHJlcG9ydF9za2lwKCJwbWV2dHlwZXI6IGFsbCBldmVudHMgd2l0aGluIFsweDAs
IDB4M0ZdIGFyZQo+PiBzdXBwb3J0ZWQiKTsKPj4gK8KgwqDCoMKgwqDCoMKgIHJldHVybjsKPj4g
K8KgwqDCoCB9Cj4+ICsKPj4gK8KgwqDCoCAvKiBzZWxlY3QgY291bnRlciAwICovCj4+ICvCoMKg
wqAgd3JpdGVfc3lzcmVnKDAsIFBNU0VMUl9FTDApOwo+PiArwqDCoMKgIC8qIHByb2dyYW0gdGhp
cyBjb3VudGVyIHRvIGNvdW50IHVuc3VwcG9ydGVkIGV2ZW50ICovCj4KPiBXZSBnZXQgdGhlIHVu
c3VwcG9ydGVkIGV2ZW50IG51bWJlciAqaSogYnV0IGRvbid0IHByb2dyYW0gaXQgaW50bwo+IFBN
WEVWVFlQRVJfRUwwIChvciBQTUVWVFlQRVIwX0VMMCkuIElzIGl0IGludGVudGlvbmFsPwo+Cj4+
ICvCoMKgwqAgd3JpdGVfc3lzcmVnKGksIFBNWEVWQ05UUl9FTDApOwo+PiArwqDCoMKgIC8qIHJl
YWQgdGhlIGNvdW50ZXIgdmFsdWUgKi8KPj4gK8KgwqDCoCByZWFkX3N5c3JlZyhQTVhFVkNOVFJf
RUwwKTsKPj4gK8KgwqDCoCByZXBvcnQocmVhZF9zeXNyZWcoUE1YRVZDTlRSX0VMMCkgPT0gaSwK
Pj4gK8KgwqDCoMKgwqDCoMKgICJyZWFkIG9mIGEgY291bnRlciBwcm9ncmFtbWVkIHdpdGggdW5z
dXBwb3J0ZWQgZXZlbnQiKTsKPj4gKwo+PiArfQo+Cj4gWy4uLl0KPgo+PiArCj4+ICtzdGF0aWMg
dm9pZCB0ZXN0X21lbV9hY2Nlc3Modm9pZCkKPj4gK3sKPj4gK8KgwqDCoCB2b2lkICphZGRyID0g
bWFsbG9jKFBBR0VfU0laRSk7Cj4KPiAqYWRkciogaXNuJ3QgZnJlZWQgYXQgdGhlIGVuZCBvZiB0
ZXN0X21lbV9hY2Nlc3MoKS4gVGhlIHNhbWUgaW4KPiB0ZXN0X2NoYWluX3Byb21vdGlvbigpIGFu
ZCB0ZXN0X292ZXJmbG93X2ludGVycnVwdCgpLgo+Cj4gWmVuZ2h1aQo+CgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
