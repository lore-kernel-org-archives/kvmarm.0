Return-Path: <SRS0=mTyv=AV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D97C0C433DF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jul 2020 08:07:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C7ED2080D
	for <kvmarm@archiver.kernel.org>; Fri, 10 Jul 2020 08:07:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BtVEkmGy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C7ED2080D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC8504B157;
	Fri, 10 Jul 2020 04:07:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zgrkkd7bWtSa; Fri, 10 Jul 2020 04:07:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96BC84B0F9;
	Fri, 10 Jul 2020 04:07:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A476C4B0F9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 04:06:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WPSd8KsQuta3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Jul 2020 04:06:57 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B6F3A4B0E8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 04:06:57 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1594368417;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=U4jS1QoQjjeHX3nPPzYjEddY3DRl7Jsr2mcq4h0i1jc=;
 b=BtVEkmGyeiLf1NmxwEisL0pgA/fXYsAzjvm7IvGNMzI5Dmrb+P5tPUmzesic+F0EH/lBj4
 +BOobClErGeXU57p3mnY6H6x0DL+Wkg6k8M60/IBm/VZmhTgvach14O+DbWG1tw2CpJhIT
 gzXgHz0KKDuvkdNYqQmeD8my8zhcqzU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-X8gAz9xgN62wxF78rSw9zA-1; Fri, 10 Jul 2020 04:06:55 -0400
X-MC-Unique: X8gAz9xgN62wxF78rSw9zA-1
Received: by mail-wr1-f69.google.com with SMTP id v3so5124563wrq.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Jul 2020 01:06:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=U4jS1QoQjjeHX3nPPzYjEddY3DRl7Jsr2mcq4h0i1jc=;
 b=qwtVO4KhUkso2q08NVuVQq5T5iYl96I+ywiBw3T4AwLIP+sb3LyPpgbzbzJiq327mD
 7Ad1bkb9VHKX0JlP8/0J1rFAH+PPXiXTIOJ0nUac5a5y/Leb7OVc6gvXvulJ1PDIxhwM
 FLOH7RivjXnxNsvR3+lrwLf23VspdvhgjhnNMAGuo4eroCmdW8GLk1DgOPsXc7BXwZJH
 77n7WDCdSzbN4OYWQl5KHvin5WOzYS0l5Mm+cZD7E9myifMA3saqld4lodK1VuwAEoSZ
 yo05Q2LYyubKHNbVkaNAjmz0Ts8NI5h85kSjsslYwgQ2F9HtQA1DFHZVLpJFwGPjhArh
 CzsQ==
X-Gm-Message-State: AOAM53165FurErWXBm43NRGrVCsGKnUl8Z1naqhVf04NgIRpMQC1G/bv
 hctugRSJ9+CwtQnQ67MEIV/UOL10p9QYtkK6H1k55hrlqdSGlS89VmwjXTpaSF2wit7mO2P6Yvd
 46znUUNDGsFpxJ7Rb/93yhxNX
X-Received: by 2002:a1c:1fd1:: with SMTP id f200mr3838427wmf.162.1594368414533; 
 Fri, 10 Jul 2020 01:06:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyJjT5tWv9/nRHPZPlasSYyXK0UFRsIXqd7zkWACOymjphFAEJPu8OB7fs8YgXWFmbnz1f6Yg==
X-Received: by 2002:a1c:1fd1:: with SMTP id f200mr3838385wmf.162.1594368414271; 
 Fri, 10 Jul 2020 01:06:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c?
 ([2001:b07:6468:f312:9541:9439:cb0f:89c])
 by smtp.gmail.com with ESMTPSA id v3sm9130496wrq.57.2020.07.10.01.06.52
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 10 Jul 2020 01:06:53 -0700 (PDT)
Subject: Re: [PATCH v6 0/5] clean up redundant 'kvm_run' parameters
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
 tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au,
 benh@kernel.crashing.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, cohuck@redhat.com, heiko.carstens@de.ibm.com,
 gor@linux.ibm.com, sean.j.christopherson@intel.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com,
 chenhuacai@gmail.com
References: <20200623131418.31473-1-tianjia.zhang@linux.alibaba.com>
 <6604e273-d7b1-5007-8721-75c4a4dec68e@linux.alibaba.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <433ae9a7-ee86-28ea-e600-8769f9759513@redhat.com>
Date: Fri, 10 Jul 2020 10:06:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <6604e273-d7b1-5007-8721-75c4a4dec68e@linux.alibaba.com>
Content-Language: en-US
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-mips@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvmarm@lists.cs.columbia.edu,
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

T24gMTAvMDcvMjAgMDk6MzIsIFRpYW5qaWEgWmhhbmcgd3JvdGU6Cj4gSGkgUGFvbG8sCj4gCj4g
QW55IG9waW5pb24gb24gdGhpcyBzZXJpZXMgcGF0Y2hlcz8gQ2FuIEkgaGVscCB3aXRoIHRoaXMg
cGF0Y2hzZXQgPwoKSSB3YXMgaG9waW5nIHRvIGhhdmUgc29tZSBUZXN0ZWQtYnksIGZvciBub3cg
SSdtIHF1ZXVpbmcgcGF0Y2hlcyAxIGFuZAoyLiAgVGhhbmtzLAoKUGFvbG8KCj4gVGhhbmtzIGFu
ZCBiZXN0LAo+IFRpYW5qaWEKPiAKPiBPbiAyMDIwLzYvMjMgMjE6MTQsIFRpYW5qaWEgWmhhbmcg
d3JvdGU6Cj4+IEluIHRoZSBjdXJyZW50IGt2bSB2ZXJzaW9uLCAna3ZtX3J1bicgaGFzIGJlZW4g
aW5jbHVkZWQgaW4gdGhlICdrdm1fdmNwdScKPj4gc3RydWN0dXJlLiBGb3IgaGlzdG9yaWNhbCBy
ZWFzb25zLCBtYW55IGt2bS1yZWxhdGVkIGZ1bmN0aW9uIHBhcmFtZXRlcnMKPj4gcmV0YWluIHRo
ZSAna3ZtX3J1bicgYW5kICdrdm1fdmNwdScgcGFyYW1ldGVycyBhdCB0aGUgc2FtZSB0aW1lLiBU
aGlzCj4+IHBhdGNoIGRvZXMgYSB1bmlmaWVkIGNsZWFudXAgb2YgdGhlc2UgcmVtYWluaW5nIHJl
ZHVuZGFudCBwYXJhbWV0ZXJzLgo+Pgo+PiBUaGlzIHNlcmllcyBvZiBwYXRjaGVzIGhhcyBjb21w
bGV0ZWx5IGNsZWFuZWQgdGhlIGFyY2hpdGVjdHVyZSBvZgo+PiBhcm02NCwgbWlwcywgcHBjLCBh
bmQgczM5MCAobm8gc3VjaCByZWR1bmRhbnQgY29kZSBvbiB4ODYpLiBEdWUgdG8KPj4gdGhlIGxh
cmdlIG51bWJlciBvZiBtb2RpZmllZCBjb2RlcywgYSBzZXBhcmF0ZSBwYXRjaCBpcyBtYWRlIGZv
ciBlYWNoCj4+IHBsYXRmb3JtLiBPbiB0aGUgcHBjIHBsYXRmb3JtLCB0aGVyZSBpcyBhbHNvIGEg
cmVkdW5kYW50IHN0cnVjdHVyZQo+PiBwb2ludGVyIG9mICdrdm1fcnVuJyBpbiAndmNwdV9hcmNo
Jywgd2hpY2ggaGFzIGFsc28gYmVlbiBjbGVhbmVkCj4+IHNlcGFyYXRlbHkuCj4+Cj4+IC0tLQo+
PiB2NiBjaGFuZ2VzOgo+PiDCoMKgIFJlYXJyYW5nZSBwYXRjaCBzZXRzLCBvbmx5IGtlZXAgdGhl
IHVubWVyZ2VkIHBhdGNoLgo+PiDCoMKgIHJlYmFzZSBvbiBtYWlubGluZS4KPj4KPj4gdjUgY2hh
bmdlOgo+PiDCoMKgIHBwYzogZml4IGZvciByZXZpZXcuCj4+Cj4+IHY0IGNoYW5nZToKPj4gwqDC
oCBtaXBzOiBmaXhlcyB0d28gZXJyb3JzIGluIGVudHJ5LmMuCj4+Cj4+IHYzIGNoYW5nZToKPj4g
wqDCoCBLZWVwIHRoZSBleGlzdGluZyBgdmNwdS0+cnVuYCBpbiB0aGUgZnVuY3Rpb24gYm9keSB1
bmNoYW5nZWQuCj4+Cj4+IHYyIGNoYW5nZToKPj4gwqDCoCBzMzkwIHJldGFpbnMgdGhlIG9yaWdp
bmFsIHZhcmlhYmxlIG5hbWUgYW5kIG1pbmltaXplcyBtb2RpZmljYXRpb24uCj4+Cj4+IFRpYW5q
aWEgWmhhbmcgKDUpOgo+PiDCoMKgIEtWTTogczM5MDogY2xlYW4gdXAgcmVkdW5kYW50ICdrdm1f
cnVuJyBwYXJhbWV0ZXJzCj4+IMKgwqAgS1ZNOiBhcm02NDogY2xlYW4gdXAgcmVkdW5kYW50ICdr
dm1fcnVuJyBwYXJhbWV0ZXJzCj4+IMKgwqAgS1ZNOiBQUEM6IGNsZWFuIHVwIHJlZHVuZGFudCBr
dm1fcnVuIHBhcmFtZXRlcnMgaW4gYXNzZW1ibHkKPj4gwqDCoCBLVk06IE1JUFM6IGNsZWFuIHVw
IHJlZHVuZGFudCAna3ZtX3J1bicgcGFyYW1ldGVycwo+PiDCoMKgIEtWTTogTUlQUzogY2xlYW4g
dXAgcmVkdW5kYW50IGt2bV9ydW4gcGFyYW1ldGVycyBpbiBhc3NlbWJseQo+Pgo+PiDCoCBhcmNo
L2FybTY0L2luY2x1ZGUvYXNtL2t2bV9jb3Byb2MuaMKgwqAgfMKgIDEyICstLQo+PiDCoCBhcmNo
L2FybTY0L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmjCoMKgwqDCoCB8wqAgMTEgKy0tCj4+IMKgIGFy
Y2gvYXJtNjQvaW5jbHVkZS9hc20va3ZtX21tdS5owqDCoMKgwqDCoCB8wqDCoCAyICstCj4+IMKg
IGFyY2gvYXJtNjQva3ZtL2FybS5jwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8
wqDCoCA2ICstCj4+IMKgIGFyY2gvYXJtNjQva3ZtL2hhbmRsZV9leGl0LmPCoMKgwqDCoMKgwqDC
oMKgwqAgfMKgIDM2ICsrKystLS0tCj4+IMKgIGFyY2gvYXJtNjQva3ZtL21taW8uY8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAxMSArLS0KPj4gwqAgYXJjaC9hcm02NC9rdm0v
bW11LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoMKgIDUgKy0KPj4gwqAg
YXJjaC9hcm02NC9rdm0vc3lzX3JlZ3MuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMTMg
KystCj4+IMKgIGFyY2gvbWlwcy9pbmNsdWRlL2FzbS9rdm1faG9zdC5owqDCoMKgwqDCoCB8wqAg
MzIgKystLS0tLS0KPj4gwqAgYXJjaC9taXBzL2t2bS9lbXVsYXRlLmPCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHzCoCA1OSArKysrKy0tLS0tLS0tCj4+IMKgIGFyY2gvbWlwcy9rdm0vZW50
cnkuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyMSArKy0tLQo+PiDCoCBh
cmNoL21pcHMva3ZtL21pcHMuY8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKg
IDE0ICsrLS0KPj4gwqAgYXJjaC9taXBzL2t2bS90cmFwX2VtdWwuY8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB8IDExNCArKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLQo+PiDCoCBhcmNoL21pcHMv
a3ZtL3Z6LmPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMjYgKysr
LS0tCj4+IMKgIGFyY2gvcG93ZXJwYy9pbmNsdWRlL2FzbS9rdm1fcHBjLmjCoMKgwqAgfMKgwqAg
MiArLQo+PiDCoCBhcmNoL3Bvd2VycGMva3ZtL2Jvb2szc19pbnRlcnJ1cHRzLlPCoCB8wqAgMjIg
KysrLS0KPj4gwqAgYXJjaC9wb3dlcnBjL2t2bS9ib29rM3NfcHIuY8KgwqDCoMKgwqDCoMKgwqDC
oCB8wqDCoCA5ICstCj4+IMKgIGFyY2gvcG93ZXJwYy9rdm0vYm9va2UuY8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHzCoMKgIDkgKy0KPj4gwqAgYXJjaC9wb3dlcnBjL2t2bS9ib29rZV9pbnRl
cnJ1cHRzLlPCoMKgIHzCoMKgIDkgKy0KPj4gwqAgYXJjaC9wb3dlcnBjL2t2bS9ib29rZWh2X2lu
dGVycnVwdHMuUyB8wqAgMTAgKy0tCj4+IMKgIGFyY2gvczM5MC9rdm0va3ZtLXMzOTAuY8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAyMyArKysrLS0KPj4gwqAgMjEgZmlsZXMgY2hhbmdl
ZCwgMTg4IGluc2VydGlvbnMoKyksIDI1OCBkZWxldGlvbnMoLSkKPj4KPiAKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QK
a3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVk
dS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
