Return-Path: <SRS0=H8K6=OU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB994C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 09:14:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 32813619E3
	for <kvmarm@archiver.kernel.org>; Thu, 30 Sep 2021 09:14:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 32813619E3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B27849DE3;
	Thu, 30 Sep 2021 05:14:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JK0kxKjjwEci; Thu, 30 Sep 2021 05:14:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A4ED04B099;
	Thu, 30 Sep 2021 05:14:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A5F9149DE3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 05:14:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7aOhu049T2hu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Sep 2021 05:14:10 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACC5F407D1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 05:14:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632993250;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=5i00CB+tDLW94gAUllzqnCmt6UVPauV4nQL/hdD8AIo=;
 b=fhwL+Hv1v5NBSgQa71z19l5KnbFb2EbRk6aH6wSK7x55HDkdn3NH1/lwgND2rm73ytQgc9
 GkmPNwNAuHcFb9EvasSMDoNFTCK53qoEfxI8/Qn4Hrj76pon/afIpm/prLxk9ri/UIjHWX
 Hl2JK0qwShNOgpkxVCVF540OXCj3uN4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-IyrdKTnVNDOus8rGOEtPbw-1; Thu, 30 Sep 2021 05:14:07 -0400
X-MC-Unique: IyrdKTnVNDOus8rGOEtPbw-1
Received: by mail-wm1-f71.google.com with SMTP id
 j82-20020a1c2355000000b0030cec9c9a66so2667381wmj.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Sep 2021 02:14:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=5i00CB+tDLW94gAUllzqnCmt6UVPauV4nQL/hdD8AIo=;
 b=01jvnu/BcIfnoUBDEoBssQmFXmwSHipNwTUE6sH3DdfF0qWnCwanBrD6whFCrdPW8Z
 OMMgrkSjnMggSVPpaX7O2hm0/ALj+V9BjygXK1T68DRV5Q/9S0WVu8XdVTghzwHm2CFT
 r1reu1QlGsW08qGR7b3sTwqZ6tOyLEBBMR6Q+plM8BYy34j5LCJB7fhU3g9MbNGtxYZd
 hj5WCW9QP8u7v2Ac9lfLAsnSbVyFU3eo73tSaLhg0+JryRznkBg+Fb8wM/vOfB3Ng28o
 lNT9i9eJlro82KToxEPh6wthGD8NrLquOqB2Ju2IwjyimhBfAoGKjCvmIUio1rCeO3Yi
 6HPA==
X-Gm-Message-State: AOAM530BoHXDPSAqfZO4ShtWxqgsaKZp5QCpYEjtMtSNlYhfAeCOUfvO
 KiWFFybhn9fLRGk+CUwzyNmPtz0qhmUDsBE2yzcpIrjnDoKAx9h8DfVsbf6RLmwo0Qwb/5+nNyS
 fWH5mDKfVr1yG8vkKYA4AnAav
X-Received: by 2002:a7b:c5c9:: with SMTP id n9mr14773853wmk.141.1632993245901; 
 Thu, 30 Sep 2021 02:14:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXnJJHykF2wK68naO4trA+VWC8AvHvLKrCrkS+NvdwtjLKTrVSexNUWshv4izEe7G3+3ZnWQ==
X-Received: by 2002:a7b:c5c9:: with SMTP id n9mr14773822wmk.141.1632993245686; 
 Thu, 30 Sep 2021 02:14:05 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id r4sm2456106wma.48.2021.09.30.02.14.03
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 30 Sep 2021 02:14:04 -0700 (PDT)
Subject: Re: [PATCH v3 10/10] KVM: arm64: selftests: Add basic ITS device tests
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
 alexandru.elisei@arm.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210929001012.2539461-1-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <a7df5700-ebef-9fd3-3067-ae35cbaaf3a9@redhat.com>
Date: Thu, 30 Sep 2021 11:14:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210929001012.2539461-1-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

SGkgUmljYXJkbywKCk9uIDkvMjkvMjEgMjoxMCBBTSwgUmljYXJkbyBLb2xsZXIgd3JvdGU6Cj4g
QWRkIHNvbWUgSVRTIGRldmljZSB0ZXN0czogZ2VuZXJhbCBLVk0gZGV2aWNlIHRlc3RzIChhZGRy
ZXNzIG5vdCBkZWZpbmVkCj4gYWxyZWFkeSwgYWRkcmVzcyBhbGlnbmVkKSBhbmQgdGVzdHMgZm9y
IHRoZSBJVFMgcmVnaW9uIGJlaW5nIHdpdGhpbiB0aGUKPiBhZGRyZXNzYWJsZSBJUEEgcmFuZ2Uu
Cj4KPiBTaWduZWQtb2ZmLWJ5OiBSaWNhcmRvIEtvbGxlciA8cmljYXJrb2xAZ29vZ2xlLmNvbT4K
PiAtLS0KPiAgLi4uL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3ZnaWNfaW5pdC5jIHwg
NDIgKysrKysrKysrKysrKysrKysrKwo+ICAxIGZpbGUgY2hhbmdlZCwgNDIgaW5zZXJ0aW9ucygr
KQo+Cj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3Zn
aWNfaW5pdC5jIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMva3ZtL2FhcmNoNjQvdmdpY19pbml0
LmMKPiBpbmRleCA0MTdhOWE1MTVjYWQuLjE4MDIyMWVjMzI1ZCAxMDA2NDQKPiAtLS0gYS90b29s
cy90ZXN0aW5nL3NlbGZ0ZXN0cy9rdm0vYWFyY2g2NC92Z2ljX2luaXQuYwo+ICsrKyBiL3Rvb2xz
L3Rlc3Rpbmcvc2VsZnRlc3RzL2t2bS9hYXJjaDY0L3ZnaWNfaW5pdC5jCj4gQEAgLTYwMyw2ICs2
MDMsNDcgQEAgc3RhdGljIHZvaWQgdGVzdF92M19yZWRpc3RfaXBhX3JhbmdlX2NoZWNrX2F0X3Zj
cHVfcnVuKHZvaWQpCj4gIAl2bV9naWNfZGVzdHJveSgmdik7Cj4gIH0KPiAgCj4gK3N0YXRpYyB2
b2lkIHRlc3RfdjNfaXRzX3JlZ2lvbih2b2lkKQo+ICt7Cj4gKwlzdHJ1Y3Qgdm1fZ2ljIHY7Cj4g
Kwl1aW50NjRfdCBhZGRyOwo+ICsJaW50IGl0c19mZCwgcmV0Owo+ICsKPiArCXYgPSB2bV9naWNf
Y3JlYXRlX3dpdGhfdmNwdXMoS1ZNX0RFVl9UWVBFX0FSTV9WR0lDX1YzLCBOUl9WQ1BVUyk7Cj4g
KwlpdHNfZmQgPSBrdm1fY3JlYXRlX2RldmljZSh2LnZtLCBLVk1fREVWX1RZUEVfQVJNX1ZHSUNf
SVRTLCBmYWxzZSk7CnRoaXMgbWF5IGZhaWwgaWYgdGhlIElUUyBkZXZpY2UgaGFzIG5vdCBiZWVu
IHJlZ2lzdGVyZWQgYnkgS1ZNIChob3N0IEdJQ3YyKQoKTWF5YmUgcmVmaW5lIHRoZSBwYXRjaCB0
aXRsZSBtZW50aW9ubmluZyB0aGlzIGlzIGFuIElUUyBkZXZpY2UgImluaXQiIHRlc3QuCmFzIHBl
ciBEb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2RldmljZXMvYXJtLXZnaWMtaXRzLnJzdCB3ZSBjb3Vs
ZCBhbHNvIHRyeQppbnN0YW50aWF0aW5nIHRoZSBJVFMgYmVmb3JlIHRoZSBHSUMgYW5kIHRyeSBp
bnN0YW50aWF0aW5nIHNldmVyYWwgSVRTcwp3aXRoIG92ZXJsYXBwaW5nIGFkZHJlc3Nlcy4KQnV0
IEkgd291bGQgdG90YWxseSB1bmRlcnN0YW5kIGlmIHlvdSBjb25zaWRlciB0aGlzIG91dCBvZiB0
aGUgc2NvcGUgb2YKeW91csKgIGZpeGVzICsgdGVzdHMuCgpUaGFua3MhCgpFcmljCj4gKwo+ICsJ
YWRkciA9IDB4NDAxMDAwOwo+ICsJcmV0ID0gX2t2bV9kZXZpY2VfYWNjZXNzKGl0c19mZCwgS1ZN
X0RFVl9BUk1fVkdJQ19HUlBfQUREUiwKPiArCQkJICBLVk1fVkdJQ19JVFNfQUREUl9UWVBFLCAm
YWRkciwgdHJ1ZSk7Cj4gKwlURVNUX0FTU0VSVChyZXQgJiYgZXJybm8gPT0gRUlOVkFMLAo+ICsJ
CSJJVFMgcmVnaW9uIHdpdGggbWlzYWxpZ25lZCBhZGRyZXNzIik7Cj4gKwo+ICsJYWRkciA9IG1h
eF9waHlzX3NpemU7Cj4gKwlyZXQgPSBfa3ZtX2RldmljZV9hY2Nlc3MoaXRzX2ZkLCBLVk1fREVW
X0FSTV9WR0lDX0dSUF9BRERSLAo+ICsJCQkgIEtWTV9WR0lDX0lUU19BRERSX1RZUEUsICZhZGRy
LCB0cnVlKTsKPiArCVRFU1RfQVNTRVJUKHJldCAmJiBlcnJubyA9PSBFMkJJRywKPiArCQkicmVn
aXN0ZXIgSVRTIHJlZ2lvbiB3aXRoIGJhc2UgYWRkcmVzcyBiZXlvbmQgSVBBIHJhbmdlIik7Cj4g
Kwo+ICsJYWRkciA9IG1heF9waHlzX3NpemUgLSAweDEwMDAwOwo+ICsJcmV0ID0gX2t2bV9kZXZp
Y2VfYWNjZXNzKGl0c19mZCwgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfQUREUiwKPiArCQkJICBLVk1f
VkdJQ19JVFNfQUREUl9UWVBFLCAmYWRkciwgdHJ1ZSk7Cj4gKwlURVNUX0FTU0VSVChyZXQgJiYg
ZXJybm8gPT0gRTJCSUcsCj4gKwkJIkhhbGYgb2YgSVRTIHJlZ2lvbiBpcyBiZXlvbmQgSVBBIHJh
bmdlIik7Cj4gKwo+ICsJLyogVGhpcyBvbmUgc3VjY2VlZHMgc2V0dGluZyB0aGUgSVRTIGJhc2Ug
Ki8KPiArCWFkZHIgPSAweDQwMDAwMDsKPiArCWt2bV9kZXZpY2VfYWNjZXNzKGl0c19mZCwgS1ZN
X0RFVl9BUk1fVkdJQ19HUlBfQUREUiwKPiArCQkJICBLVk1fVkdJQ19JVFNfQUREUl9UWVBFLCAm
YWRkciwgdHJ1ZSk7Cj4gKwo+ICsJYWRkciA9IDB4MzAwMDAwOwo+ICsJcmV0ID0gX2t2bV9kZXZp
Y2VfYWNjZXNzKGl0c19mZCwgS1ZNX0RFVl9BUk1fVkdJQ19HUlBfQUREUiwKPiArCQkJICBLVk1f
VkdJQ19JVFNfQUREUl9UWVBFLCAmYWRkciwgdHJ1ZSk7Cj4gKwlURVNUX0FTU0VSVChyZXQgJiYg
ZXJybm8gPT0gRUVYSVNULCAiSVRTIGJhc2Ugc2V0IGFnYWluIik7Cj4gKwo+ICsJY2xvc2UoaXRz
X2ZkKTsKPiArCXZtX2dpY19kZXN0cm95KCZ2KTsKPiArfQo+ICsKPiAgLyoKPiAgICogUmV0dXJu
cyAwIGlmIGl0J3MgcG9zc2libGUgdG8gY3JlYXRlIEdJQyBkZXZpY2Ugb2YgYSBnaXZlbiB0eXBl
IChWMiBvciBWMykuCj4gICAqLwo+IEBAIC02NTUsNiArNjk2LDcgQEAgdm9pZCBydW5fdGVzdHMo
dWludDMyX3QgZ2ljX2Rldl90eXBlKQo+ICAJCXRlc3RfdjNfbGFzdF9iaXRfcmVkaXN0X3JlZ2lv
bnMoKTsKPiAgCQl0ZXN0X3YzX2xhc3RfYml0X3NpbmdsZV9yZGlzdCgpOwo+ICAJCXRlc3RfdjNf
cmVkaXN0X2lwYV9yYW5nZV9jaGVja19hdF92Y3B1X3J1bigpOwo+ICsJCXRlc3RfdjNfaXRzX3Jl
Z2lvbigpOwo+ICAJfQo+ICB9Cj4gIAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
