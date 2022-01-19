Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731E2C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 19 Jan 2022 10:16:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD5D04B092;
	Wed, 19 Jan 2022 05:16:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2WzSWXzxa1fW; Wed, 19 Jan 2022 05:16:51 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 477EE4B0BF;
	Wed, 19 Jan 2022 05:16:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3216C49F2F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jan 2022 01:42:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fbA+zusOaDkq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Jan 2022 01:42:26 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E55F649F28
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Jan 2022 01:42:26 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1642574546;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=MF1FuGFJdpOohIJ1ssXp+qAxwbB16v8stQCdey9tRcg=;
 b=QZBh/S5obycedEYcYaocchDNEmgUeR43nEDnaNyTj+97rjCscl+6hH8qBqmrtIrZGvS/Xa
 IENGxSyS1ox7p3VrJlpChoMs3i9h4aselNMMUw+gxFTCf4B4Ulf56hBDGbJzMDml1eDe7x
 eLWC168nji/3dRoveVxYmSXaNGqRJWs=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-BzFEkVKWMaW2ea9eIxsn4Q-1; Wed, 19 Jan 2022 01:42:24 -0500
X-MC-Unique: BzFEkVKWMaW2ea9eIxsn4Q-1
Received: by mail-pj1-f69.google.com with SMTP id
 v8-20020a17090a778800b001b2e6d08cd1so1143772pjk.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jan 2022 22:42:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=MF1FuGFJdpOohIJ1ssXp+qAxwbB16v8stQCdey9tRcg=;
 b=Y+xy/Q1uiXoiSz0JbUR6bbkBOJbD7NxGJS7W6tYs2LZQJxUZRANEY5O7/jOmTbZeQD
 sxf6psY1ClymNUde5Tie8WaYXw3AJSot6d2seJv3cNJXcXQ3X+DHijjvgcGPmvc+VNJm
 RVUW2fKtd4QShPcOUao/UYKoBqEhyHJSFSkWQEajUWaR03Rn5E3oHDkn2f+MNPYRr3is
 l+4NrF+HGoKKr7OBSKJcEPf2yrMdyfMA0iL00fgBhJ90R0WWqRIa/HrtOUlmHLOWjH9y
 TNg/8zIbgw+njtDd4FYn7Vx+CUio0ZdS+WVBsQGbQL1gxEmFQrP77ahY4wPJ/i/N/9o6
 4kQA==
X-Gm-Message-State: AOAM533wx+QZod3/ZWa4uLUgTLLdX7mP1JKO52ErCGYYoLYyXXgR+fXw
 vo64NImc/S/LlUdewYt4+QgEq3kygdV4UY6adzFFSNCPKuvSZhrDA8oSCNBQf9kfcANitn0XCZm
 VXMAlLX1EupXALVx9UlxgIwPU
X-Received: by 2002:a17:902:ac8f:b0:14a:ac30:47d7 with SMTP id
 h15-20020a170902ac8f00b0014aac3047d7mr16543335plr.168.1642574543716; 
 Tue, 18 Jan 2022 22:42:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzfLyBSLuUdFeXn+Bg5WDLz7nFtnsc2uixZcGKG5XSs6BPtw5MhYNQsaP8UjQVY658RSwJjgQ==
X-Received: by 2002:a17:902:ac8f:b0:14a:ac30:47d7 with SMTP id
 h15-20020a170902ac8f00b0014aac3047d7mr16543301plr.168.1642574543414; 
 Tue, 18 Jan 2022 22:42:23 -0800 (PST)
Received: from [10.72.13.227] ([209.132.188.80])
 by smtp.gmail.com with ESMTPSA id x4sm4821921pjn.56.2022.01.18.22.42.17
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 18 Jan 2022 22:42:22 -0800 (PST)
Message-ID: <960d4166-1718-55ef-d324-507a8add7e3e@redhat.com>
Date: Wed, 19 Jan 2022 14:42:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v3 04/11] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
To: Raghavendra Rao Ananta <rananta@google.com>, Marc Zyngier
 <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
 James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20220104194918.373612-1-rananta@google.com>
 <20220104194918.373612-5-rananta@google.com>
From: Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220104194918.373612-5-rananta@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jasowang@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
X-Mailman-Approved-At: Wed, 19 Jan 2022 05:16:50 -0500
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

CuWcqCAyMDIyLzEvNSDkuIrljYgzOjQ5LCBSYWdoYXZlbmRyYSBSYW8gQW5hbnRhIOWGmemBkzoK
PiBLVk0gcmVndWxhcmx5IGludHJvZHVjZXMgbmV3IGh5cGVyY2FsbCBzZXJ2aWNlcyB0byB0aGUg
Z3Vlc3RzIHdpdGhvdXQKPiBhbnkgY29uc2VudCBmcm9tIHRoZSBWaXJ0dWFsIE1hY2hpbmUgTWFu
YWdlciAoVk1NKS4gVGhpcyBtZWFucywgdGhlCj4gZ3Vlc3RzIGNhbiBvYnNlcnZlIGh5cGVyY2Fs
bCBzZXJ2aWNlcyBpbiBhbmQgb3V0IGFzIHRoZXkgbWlncmF0ZQo+IGFjcm9zcyB2YXJpb3VzIGhv
c3Qga2VybmVsIHZlcnNpb25zLiBUaGlzIGNvdWxkIGJlIGEgbWFqb3IgcHJvYmxlbQo+IGlmIHRo
ZSBndWVzdCBkaXNjb3ZlcmVkIGEgaHlwZXJjYWxsLCBzdGFydGVkIHVzaW5nIGl0LCBhbmQgYWZ0
ZXIKPiBnZXR0aW5nIG1pZ3JhdGVkIHRvIGFuIG9sZGVyIGtlcm5lbCByZWFsaXplcyB0aGF0IGl0
J3Mgbm8gbG9uZ2VyCj4gYXZhaWxhYmxlLiBEZXBlbmRpbmcgb24gaG93IHRoZSBndWVzdCBoYW5k
bGVzIHRoZSBjaGFuZ2UsIHRoZXJlJ3MKPiBhIHBvdGVudGlhbCBjaGFuY2UgdGhhdCB0aGUgZ3Vl
c3Qgd291bGQganVzdCBwYW5pYy4KPgo+IEFzIGEgcmVzdWx0LCB0aGVyZSdzIGEgbmVlZCBmb3Ig
dGhlIFZNTSB0byBlbGVjdCB0aGUgc2VydmljZXMgdGhhdAo+IGl0IHdpc2hlcyB0aGUgZ3Vlc3Qg
dG8gZGlzY292ZXIuIFZNTSBjYW4gZWxlY3QgdGhlc2Ugc2VydmljZXMgYmFzZWQKPiBvbiB0aGUg
a2VybmVscyBzcHJlYWQgYWNyb3NzIGl0cyAobWlncmF0aW9uKSBmbGVldC4gVG8gcmVtZWR5IHRo
aXMsCj4gZXh0ZW5kIHRoZSBleGlzdGluZyBmaXJtd2FyZSBwc3VlZG8tcmVnaXN0ZXJzLCBzdWNo
IGFzCj4gS1ZNX1JFR19BUk1fUFNDSV9WRVJTSU9OLCBmb3IgYWxsIHRoZSBoeXBlcmNhbGwgc2Vy
dmljZXMgYXZhaWxhYmxlLgoKCgpIYXZlbid0IGdvbmUgdGhyb3VnaCB0aGUgc2VyaWVzIGJ1dCBJ
IHdvbmRlciB3aGV0aGVyIGl0J3MgYmV0dGVyIHRvIGhhdmUgCmEgKGUpQlBGIGZpbHRlciBmb3Ig
dGhpcyBsaWtlIHNlY2NvbXAuCgpUaGFua3MKCgo+Cj4gVGhlc2UgZmlybXdhcmUgcmVnaXN0ZXJz
IGFyZSBjYXRlZ29yaXplZCBiYXNlZCBvbiB0aGUgc2VydmljZSBjYWxsCj4gb3duZXJzLCBhbmQg
dW5saWtlIHRoZSBleGlzdGluZyBmaXJtd2FyZSBwc3VlZG8tcmVnaXN0ZXJzLCB0aGV5IGhvbGQK
PiB0aGUgZmVhdHVyZXMgc3VwcG9ydGVkIGluIHRoZSBmb3JtIG9mIGEgYml0bWFwLgo+Cj4gVGhl
IGNhcGFiaWxpdHksIEtWTV9DQVBfQVJNX0hWQ19GV19SRUdfQk1BUCwgaXMgdXNlZCB0byBhbm5v
dW5jZQo+IHRoaXMgZXh0ZW5zaW9uLCB3aGljaCByZXR1cm5zIHRoZSBudW1iZXIgb2YgcHN1ZWRv
LWZpcm13YXJlCj4gcmVnaXN0ZXJzIHN1cHBvcnRlZC4gRHVyaW5nIHRoZSBWTSBpbml0aWFsaXph
dGlvbiwgdGhlIHJlZ2lzdGVycwo+IGhvbGRzIGFuIHVwcGVyLWxpbWl0IG9mIHRoZSBmZWF0dXJl
cyBzdXBwb3J0ZWQgYnkgdGhlIGNvcnJlc3BvbmRpbmcKPiByZWdpc3RlcnMuIEl0J3MgZXhwZWN0
ZWQgdGhhdCB0aGUgVk1NcyBkaXNjb3ZlciB0aGUgZmVhdHVyZXMKPiBwcm92aWRlZCBieSBlYWNo
IHJlZ2lzdGVyIHZpYSBHRVRfT05FX1JFRywgYW5kIHdyaXRlYmFjayB0aGUKPiBkZXNpcmVkIHZh
bHVlcyB1c2luZyBTRVRfT05FX1JFRy4gS1ZNIGFsbG93cyB0aGlzIG1vZGlmaWNhdGlvbgo+IG9u
bHkgdW50aWwgdGhlIFZNIGhhcyBzdGFydGVkLgo+Cj4gT2xkZXIgVk1NcyBjYW4gc2ltcGx5IGln
bm9yZSB0aGUgY2FwYWJpbGl0eSBhbmQgdGhlIGh5cGVyY2FsbCBzZXJ2aWNlcwo+IHdpbGwgYmUg
ZXhwb3NlZCB1bmNvbmRpdGlvbmFsbHkgdG8gdGhlIGd1ZXN0cywgdGh1cyBlbnN1cmluZyBiYWNr
d2FyZAo+IGNvbXBhdGliaWxpdHkuCj4KPiBJbiB0aGlzIHBhdGNoLCB0aGUgZnJhbWV3b3JrIGFk
ZHMgdGhlIHJlZ2lzdGVyIG9ubHkgZm9yIEFSTSdzIHN0YW5kYXJkCj4gc2VjdXJlIHNlcnZpY2Vz
IChvd25lciB2YWx1ZSA0KS4gQ3VycmVudGx5LCB0aGlzIGluY2x1ZGVzIHN1cHBvcnQgb25seQo+
IGZvciBBUk0gVHJ1ZSBSYW5kb20gTnVtYmVyIEdlbmVyYXRvciAoVFJORykgc2VydmljZSwgd2l0
aCBiaXQtMCBvZiB0aGUKPiByZWdpc3RlciByZXByZXNlbnRpbmcgbWFuZGF0b3J5IGZlYXR1cmVz
IG9mIHYxLjAuIE90aGVyIHNlcnZpY2VzIGFyZQo+IG1vbWVudGFyaWx5IGFkZGVkIGluIHRoZSB1
cGNvbWluZyBwYXRjaGVzLgo+Cj4gU2lnbmVkLW9mZi1ieTogUmFnaGF2ZW5kcmEgUmFvIEFuYW50
YTxyYW5hbnRhQGdvb2dsZS5jb20+CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJp
YS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1h
cm0K
