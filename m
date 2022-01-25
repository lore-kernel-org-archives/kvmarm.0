Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C8F3C433EF
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 18:23:50 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14DEC49EC5;
	Tue, 25 Jan 2022 13:23:50 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vjKla+D9TOKe; Tue, 25 Jan 2022 13:23:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A586649ED8;
	Tue, 25 Jan 2022 13:23:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4508D49EC5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 13:23:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XjM8Pc61tOWM for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 13:23:45 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E733440FD3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 13:23:45 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1643135025;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=wQiWPJdaqri76JgRGXeOGlGXeaAGk3DNqSI3A9eZhrQ=;
 b=ciDtqn6EzNHrW1IFffJshP1ZqsOanf8rdSEKY52RbbjvhV7ax0AvqJgs+RwQFIHGXkj+4C
 k5kGYHJW8UqAsxFopqmK41hPIyhyqyBoFg2ktokKs7eiD9V8uUlShJOHNkBM+wo2sKpxU5
 K0pS1KOnPnhNZeq3qvL+9lLC3BE5ZvE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-mB35xMMfNYmb1q63SMtivw-1; Tue, 25 Jan 2022 13:23:44 -0500
X-MC-Unique: mB35xMMfNYmb1q63SMtivw-1
Received: by mail-wr1-f69.google.com with SMTP id
 q14-20020adfaa4e000000b001dd761d46c7so500991wrd.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 10:23:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=wQiWPJdaqri76JgRGXeOGlGXeaAGk3DNqSI3A9eZhrQ=;
 b=0Xi+KvSLgLLQqsk029f2Q+KFsMZvkfFw5P/HbiLfuWIIccxoFtR3P5liIuZs0vI+sB
 CvVlNucVaYempYwXcOZ5ojauO3Ym6R4A9vrkXKtwX5nt6cYrxid9FracDy1TG0fv7WG2
 gcDtYnyEUYTo3Ad3Fy9pNLg71boqWEpl0mdjpAte+Frlw27WCymYuRDkc/+j8tbHQgry
 2e7TSI30MPbAfJyXUVP+Z4xnt7+dpft5zq7E+n5ZT3o7tJlRpLaZdbBrzM52pj5kqor9
 rQWhJSywd0ihpTAffPsIH/HAeNntBHSu1XSBzEgmcYBN1PMwvra4K/knHUjJMRHNFb1J
 Ft1A==
X-Gm-Message-State: AOAM533R8TL7kVFWjS3BN1Tt+L8Vhm3B5+sHuX7/nPLF/phM+Ov3seSu
 HTHs68CE8oHEiwRSDy9O3HkwQ6AnMJ1MUHVmRNhCsz8EDbfxQQex9gwNKV52MLuBOCal9oeMEnu
 ztxYUjfZzxPRYOV3rOpMnMk6J
X-Received: by 2002:a5d:69c1:: with SMTP id s1mr15463230wrw.114.1643135022682; 
 Tue, 25 Jan 2022 10:23:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJygGx6tbpCyoXfBOstJyIPCE+fQLPVTlTN361eLiHBotZVy/dgkejxLJ7815NvcqdCls1TNvA==
X-Received: by 2002:a5d:69c1:: with SMTP id s1mr15463214wrw.114.1643135022434; 
 Tue, 25 Jan 2022 10:23:42 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id bg26sm1032430wmb.48.2022.01.25.10.23.41
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 25 Jan 2022 10:23:41 -0800 (PST)
Subject: Re: [PATCH v4 05/21] KVM: arm64: Support SDEI_EVENT_{ENABLE, DISABLE}
 hypercall
To: Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu
References: <20210815001352.81927-1-gshan@redhat.com>
 <20210815001352.81927-6-gshan@redhat.com>
 <4ce1aed4-d955-145c-777b-350efec2e7bc@redhat.com>
 <d7fdb8f8-d0f7-32c4-9644-0ab7cb46dfdf@redhat.com>
From: Eric Auger <eauger@redhat.com>
Message-ID: <69cdc2b8-ccbe-dbe2-4805-04f1a53d9a53@redhat.com>
Date: Tue, 25 Jan 2022 19:23:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d7fdb8f8-d0f7-32c4-9644-0ab7cb46dfdf@redhat.com>
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

SGkgR2F2aW4sCgpPbiAxLzEyLzIyIDM6MjkgQU0sIEdhdmluIFNoYW4gd3JvdGU6Cj4gSGkgRXJp
YywKPiAKPiBPbiAxMS8xMC8yMSAxMjowMiBBTSwgRXJpYyBBdWdlciB3cm90ZToKPj4gT24gOC8x
NS8yMSAyOjEzIEFNLCBHYXZpbiBTaGFuIHdyb3RlOgo+Pj4gVGhpcyBzdXBwb3J0cyBTREVJX0VW
RU5UX3tFTkFCTEUsIERJU0FCTEV9IGh5cGVyY2FsbC4gQWZ0ZXIgU0RFSQo+Pj4gZXZlbnQgaXMg
cmVnaXN0ZXJlZCBieSBndWVzdCwgaXQgd29uJ3QgYmUgZGVsaXZlcmVkIHRvIHRoZSBndWVzdAo+
Pj4gdW50aWwgaXQncyBlbmFibGVkLiBPbiB0aGUgb3RoZXIgaGFuZCwgdGhlIFNERUkgZXZlbnQg
d29uJ3QgYmUKPj4+IHJhaXNlZCB0byB0aGUgZ3Vlc3Qgb3Igc3BlY2lmaWMgdkNQVSBpZiBpdCdz
IGhhcyBiZWVuIGRpc2FibGVkCj4+PiBvbiB0aGUgZ3Vlc3Qgb3Igc3BlY2lmaWMgdkNQVS4KPj4+
Cj4+PiBTaWduZWQtb2ZmLWJ5OiBHYXZpbiBTaGFuIDxnc2hhbkByZWRoYXQuY29tPgo+Pj4gLS0t
Cj4+PiDCoCBhcmNoL2FybTY0L2t2bS9zZGVpLmMgfCA2OCArKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrCj4+PiDCoCAxIGZpbGUgY2hhbmdlZCwgNjggaW5zZXJ0aW9u
cygrKQo+Pj4KPj4+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2t2bS9zZGVpLmMgYi9hcmNoL2Fy
bTY0L2t2bS9zZGVpLmMKPj4+IGluZGV4IGQzZWEzZWVlMTU0Yi4uYjAyMmNlMGEyMDJiIDEwMDY0
NAo+Pj4gLS0tIGEvYXJjaC9hcm02NC9rdm0vc2RlaS5jCj4+PiArKysgYi9hcmNoL2FybTY0L2t2
bS9zZGVpLmMKPj4+IEBAIC0yMDYsNiArMjA2LDcwIEBAIHN0YXRpYyB1bnNpZ25lZCBsb25nCj4+
PiBrdm1fc2RlaV9oeXBlcmNhbGxfcmVnaXN0ZXIoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+Pj4g
wqDCoMKgwqDCoCByZXR1cm4gcmV0Owo+Pj4gwqAgfQo+Pj4gwqAgK3N0YXRpYyB1bnNpZ25lZCBs
b25nIGt2bV9zZGVpX2h5cGVyY2FsbF9lbmFibGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAo+Pj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgYm9v
bCBlbmFibGUpCj4+PiArewo+Pj4gK8KgwqDCoCBzdHJ1Y3Qga3ZtICprdm0gPSB2Y3B1LT5rdm07
Cj4+PiArwqDCoMKgIHN0cnVjdCBrdm1fc2RlaV9rdm0gKmtzZGVpID0ga3ZtLT5hcmNoLnNkZWk7
Cj4+PiArwqDCoMKgIHN0cnVjdCBrdm1fc2RlaV92Y3B1ICp2c2RlaSA9IHZjcHUtPmFyY2guc2Rl
aTsKPj4+ICvCoMKgwqAgc3RydWN0IGt2bV9zZGVpX2V2ZW50ICprc2UgPSBOVUxMOwo+Pj4gK8Kg
wqDCoCBzdHJ1Y3Qga3ZtX3NkZWlfa3ZtX2V2ZW50ICprc2tlID0gTlVMTDsKPj4+ICvCoMKgwqAg
dW5zaWduZWQgbG9uZyBldmVudF9udW0gPSBzbWNjY19nZXRfYXJnMSh2Y3B1KTsKPj4+ICvCoMKg
wqAgaW50IGluZGV4ID0gMDsKPj4+ICvCoMKgwqAgdW5zaWduZWQgbG9uZyByZXQgPSBTREVJX1NV
Q0NFU1M7Cj4+PiArCj4+PiArwqDCoMKgIC8qIFNhbml0eSBjaGVjayAqLwo+Pj4gK8KgwqDCoCBp
ZiAoIShrc2RlaSAmJiB2c2RlaSkpIHsKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXQgPSBTREVJX05P
VF9TVVBQT1JURUQ7Cj4+PiArwqDCoMKgwqDCoMKgwqAgZ290byBvdXQ7Cj4+PiArwqDCoMKgIH0K
Pj4+ICsKPj4+ICvCoMKgwqAgaWYgKCFrdm1fc2RlaV9pc192YWxpZF9ldmVudF9udW0oZXZlbnRf
bnVtKSkgewo+PiBJIHdvdWxkIHJlbmFtZSBpbnRvIGlzX2V4cG9zZWRfZXZlbnRfbnVtKCkKPiAK
PiBrdm1fc2RlaV9pc192aXJ0dWFsKCkgaGFzIGJlZW4gcmVjb21tZW5kZWQgYnkgeW91IHdoZW4g
eW91IHJldmlld2VkIHRoZQo+IGZvbGxvd2luZwo+IHBhdGNoLiBJIHRoaW5rIGt2bV9zZGVpX2lz
X3ZpcnR1YWwoKSBpcyBnb29kIGVub3VnaCA6KQoKYXJnaCwgaXNfdmlydHVhbCgpIHRoZW4gOikK
CkVyaWMKPiAKPiDCoMKgIFtQQVRDSCB2NCAwMi8yMV0gS1ZNOiBhcm02NDogQWRkIFNERUkgdmly
dHVhbGl6YXRpb24gaW5mcmFzdHJ1Y3R1cmUKPiAKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXQgPSBT
REVJX0lOVkFMSURfUEFSQU1FVEVSUzsKPj4+ICvCoMKgwqDCoMKgwqDCoCBnb3RvIG91dDsKPj4+
ICvCoMKgwqAgfQo+Pj4gKwo+Pj4gK8KgwqDCoCAvKiBDaGVjayBpZiB0aGUgS1ZNIGV2ZW50IGV4
aXN0cyAqLwo+Pj4gK8KgwqDCoCBzcGluX2xvY2soJmtzZGVpLT5sb2NrKTsKPj4+ICvCoMKgwqAg
a3NrZSA9IGt2bV9zZGVpX2ZpbmRfa3ZtX2V2ZW50KGt2bSwgZXZlbnRfbnVtKTsKPj4+ICvCoMKg
wqAgaWYgKCFrc2tlKSB7Cj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0gU0RFSV9JTlZBTElEX1BB
UkFNRVRFUlM7Cj4+IHNob3VsZCBiZSBERU5JRUQgYWNjb3JkaW5nIHRvIHRoZSBzcGVjLCBpZS4g
bm9ib2R5IHJlZ2lzdGVyZWQgdGhhdCBldmVudD8KPiAKPiBPay4KPiAKPj4+ICvCoMKgwqDCoMKg
wqDCoCBnb3RvIHVubG9jazsKPj4+ICvCoMKgwqAgfQo+Pj4gKwo+Pj4gK8KgwqDCoCAvKiBDaGVj
ayBpZiB0aGVyZSBpcyBwZW5kaW5nIGV2ZW50cyAqLwo+PiBkb2VzIHRoYXQgbWF0Y2ggdGhlICJo
YW5kbGVyLXVucmVnaXN0ZXItcGVuZGluZyBzdGF0ZSIgY2FzZSBtZW50aW9ubmVkCj4+IGluIHRo
ZSBzcGVjPwo+Pj4gK8KgwqDCoCBpZiAoa3NrZS0+c3RhdGUucmVmY291bnQpIHsKPj4+ICvCoMKg
wqDCoMKgwqDCoCByZXQgPSBTREVJX1BFTkRJTkc7Cj4+ID8gbm90IGRvY3VtZW50ZWQgaW4gbXkg
QSBzcGVjPyBERU5JRUQ/Cj4gCj4gWWVwLCBJdCBzaG91bGQgYmUgREVOSUVELgo+IAo+Pj4gK8Kg
wqDCoMKgwqDCoMKgIGdvdG8gdW5sb2NrOwo+Pj4gK8KgwqDCoCB9Cj4+PiArCj4+PiArwqDCoMKg
IC8qIENoZWNrIGlmIGl0IGhhcyBiZWVuIHJlZ2lzdGVyZWQgKi8KPj4gaXNuJ3QgZHVwbGljYXRl
IG9mIC8qIENoZWNrIGlmIHRoZSBLVk0gZXZlbnQgZXhpc3RzICovID8KPiAKPiBJdCdzIG5vdCBk
dXBsaWNhdGUgY2hlY2ssIGJ1dCB0aGUgY29tbWVudCBoZXJlIHNlZW1zIG1pc2xlYWRpbmcuIEkg
d2lsbAo+IGNvcnJlY3QgdGhpcyB0bzoKPiAKPiDCoMKgwqDCoC8qIENoZWNrIGlmIGl0IGhhcyBi
ZWVuIGRlZmluZWQgb3IgZXhwb3NlZCAqLwo+IAo+Pj4gK8KgwqDCoCBrc2UgPSBrc2tlLT5rc2U7
Cj4+PiArwqDCoMKgIGluZGV4ID0gKGtzZS0+c3RhdGUudHlwZSA9PSBTREVJX0VWRU5UX1RZUEVf
UFJJVkFURSkgPwo+Pj4gK8KgwqDCoMKgwqDCoMKgIHZjcHUtPnZjcHVfaWR4IDogMDsKPj4+ICvC
oMKgwqAgaWYgKCFrdm1fc2RlaV9pc19yZWdpc3RlcmVkKGtza2UsIGluZGV4KSkgewo+Pj4gK8Kg
wqDCoMKgwqDCoMKgIHJldCA9IFNERUlfREVOSUVEOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGdvdG8g
dW5sb2NrOwo+Pj4gK8KgwqDCoCB9Cj4+PiArCj4+PiArwqDCoMKgIC8qIFZlcmlmeSBpdHMgZW5h
YmxlbWVudCBzdGF0ZSAqLwo+Pj4gK8KgwqDCoCBpZiAoZW5hYmxlID09IGt2bV9zZGVpX2lzX2Vu
YWJsZWQoa3NrZSwgaW5kZXgpKSB7Cj4+IHNwZWMgc2F5czoKPj4gRW5hYmxpbmcvZGlzYWJsZWQg
YW4gZXZlbnQsIHdoaWNoIGlzIGFscmVhZHkgZW5hYmxlZC9kaXNhYmxlZCwgaXMKPj4gcGVybWl0
dGVkIGFuZCBoYXMgbm8gZWZmZWN0LiBJIGd1ZXNzIHJldCBzaG91bGQgYmUgT0suCj4gCj4geWVw
LCBpdCBzaG91bGQgYmUgb2suCj4gCj4+PiArwqDCoMKgwqDCoMKgwqAgcmV0ID0gU0RFSV9ERU5J
RUQ7Cj4+PiArwqDCoMKgwqDCoMKgwqAgZ290byB1bmxvY2s7Cj4+PiArwqDCoMKgIH0KPj4+ICsK
Pj4+ICvCoMKgwqAgLyogVXBkYXRlIGVuYWJsZW1lbnQgc3RhdGUgKi8KPj4+ICvCoMKgwqAgaWYg
KGVuYWJsZSkKPj4+ICvCoMKgwqDCoMKgwqDCoCBrdm1fc2RlaV9zZXRfZW5hYmxlZChrc2tlLCBp
bmRleCk7Cj4+PiArwqDCoMKgIGVsc2UKPj4+ICvCoMKgwqDCoMKgwqDCoCBrdm1fc2RlaV9jbGVh
cl9lbmFibGVkKGtza2UsIGluZGV4KTsKPj4+ICsKPj4+ICt1bmxvY2s6Cj4+PiArwqDCoMKgIHNw
aW5fdW5sb2NrKCZrc2RlaS0+bG9jayk7Cj4+PiArb3V0Ogo+Pj4gK8KgwqDCoCByZXR1cm4gcmV0
Owo+Pj4gK30KPj4+ICsKPj4+IMKgIGludCBrdm1fc2RlaV9oeXBlcmNhbGwoc3RydWN0IGt2bV92
Y3B1ICp2Y3B1KQo+Pj4gwqAgewo+Pj4gwqDCoMKgwqDCoCB1MzIgZnVuYyA9IHNtY2NjX2dldF9m
dW5jdGlvbih2Y3B1KTsKPj4+IEBAIC0yMjAsNyArMjg0LDExIEBAIGludCBrdm1fc2RlaV9oeXBl
cmNhbGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQo+Pj4gwqDCoMKgwqDCoMKgwqDCoMKgIHJldCA9
IGt2bV9zZGVpX2h5cGVyY2FsbF9yZWdpc3Rlcih2Y3B1KTsKPj4+IMKgwqDCoMKgwqDCoMKgwqDC
oCBicmVhazsKPj4+IMKgwqDCoMKgwqAgY2FzZSBTREVJXzFfMF9GTl9TREVJX0VWRU5UX0VOQUJM
RToKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXQgPSBrdm1fc2RlaV9oeXBlcmNhbGxfZW5hYmxlKHZj
cHUsIHRydWUpOwo+Pj4gK8KgwqDCoMKgwqDCoMKgIGJyZWFrOwo+Pj4gwqDCoMKgwqDCoCBjYXNl
IFNERUlfMV8wX0ZOX1NERUlfRVZFTlRfRElTQUJMRToKPj4+ICvCoMKgwqDCoMKgwqDCoCByZXQg
PSBrdm1fc2RlaV9oeXBlcmNhbGxfZW5hYmxlKHZjcHUsIGZhbHNlKTsKPj4+ICvCoMKgwqDCoMKg
wqDCoCBicmVhazsKPj4+IMKgwqDCoMKgwqAgY2FzZSBTREVJXzFfMF9GTl9TREVJX0VWRU5UX0NP
TlRFWFQ6Cj4+PiDCoMKgwqDCoMKgIGNhc2UgU0RFSV8xXzBfRk5fU0RFSV9FVkVOVF9DT01QTEVU
RToKPj4+IMKgwqDCoMKgwqAgY2FzZSBTREVJXzFfMF9GTl9TREVJX0VWRU5UX0NPTVBMRVRFX0FO
RF9SRVNVTUU6Cj4+Pgo+IAo+IFRoYW5rcywKPiBHYXZpbgo+IAoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
