Return-Path: <SRS0=vB6B=MO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E38C6377D
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 08:11:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D4CD86121E
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 08:11:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D4CD86121E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AB294B085;
	Thu, 22 Jul 2021 04:11:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e8KkMOJ7b4vG; Thu, 22 Jul 2021 04:11:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C45A4B0CF;
	Thu, 22 Jul 2021 04:11:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D522E4B0F3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 22:38:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HB5K1j6SgnJe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 22:38:11 -0400 (EDT)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A33CB4A3BF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 22:38:11 -0400 (EDT)
X-IronPort-AV: E=McAfee;i="6200,9189,10052"; a="198825015"
X-IronPort-AV: E=Sophos;i="5.84,259,1620716400"; d="scan'208";a="198825015"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 21 Jul 2021 19:38:09 -0700
X-IronPort-AV: E=Sophos;i="5.84,259,1620716400"; d="scan'208";a="512014134"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.29.38])
 ([10.255.29.38])
 by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 21 Jul 2021 19:38:02 -0700
Subject: Re: [PATCH V8 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
To: Like Xu <like.xu.linux@gmail.com>
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
 <20210716085325.10300-2-lingshan.zhu@intel.com>
 <fd117e37-8063-63a4-43cd-7cb555e5bab5@gmail.com>
From: "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <c5fad2b5-2c2f-9b06-6f45-629776a690fa@intel.com>
Date: Thu, 22 Jul 2021 10:38:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <fd117e37-8063-63a4-43cd-7cb555e5bab5@gmail.com>
Content-Language: en-US
X-Mailman-Approved-At: Thu, 22 Jul 2021 04:11:46 -0400
Cc: wanpengli@tencent.com, Like Xu <like.xu@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>, eranian@google.com,
 Guo Ren <guoren@kernel.org>, linux-riscv@lists.infradead.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 kan.liang@linux.intel.com, ak@linux.intel.com, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, joro@8bytes.org, x86@kernel.org,
 linux-csky@vger.kernel.org, wei.w.wang@intel.com,
 linux-arm-kernel@lists.infradead.org, xen-devel@lists.xenproject.org,
 liuxiangdong5@huawei.com, bp@alien8.de,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, boris.ostrvsky@oracle.com,
 jmattson@google.com, Nick Hu <nickhu@andestech.com>, seanjc@google.com,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 vkuznets@redhat.com
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

CgpPbiA3LzIxLzIwMjEgNzo1NyBQTSwgTGlrZSBYdSB3cm90ZToKPiBPbiAxNi83LzIwMjEgNDo1
MyBwbSwgWmh1IExpbmdzaGFuIHdyb3RlOgo+PiArwqDCoMKgIH0gZWxzZSBpZiAoeGVucG11X2Rh
dGEtPnBtdS5yLnJlZ3MuY3BsICYgMykKb2gsIG15IHR5cG8sIHdpbGwgZml4IGluIFY5CgpUaGFu
a3MKPgo+IExpbmdzaGFuLCBzZXJpb3VzIGZvciB0aGlzIHZlcnNpb24gPwo+Cj4gYXJjaC94ODYv
eGVuL3BtdS5jOjQzODo5OiBlcnJvcjogZXhwZWN0ZWQgaWRlbnRpZmllciBvciDigJgo4oCZIGJl
Zm9yZSAKPiDigJhyZXR1cm7igJkKPiDCoCA0MzggfMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIHN0
YXRlOwo+IMKgwqDCoMKgwqAgfMKgwqDCoMKgwqDCoMKgwqAgXn5+fn5+Cj4gYXJjaC94ODYveGVu
L3BtdS5jOjQzOToxOiBlcnJvcjogZXhwZWN0ZWQgaWRlbnRpZmllciBvciDigJgo4oCZIGJlZm9y
ZSDigJh94oCZIAo+IHRva2VuCj4gwqAgNDM5IHwgfQo+IMKgwqDCoMKgwqAgfCBeCj4gYXJjaC94
ODYveGVuL3BtdS5jOiBJbiBmdW5jdGlvbiDigJh4ZW5fZ3Vlc3Rfc3RhdGXigJk6Cj4gYXJjaC94
ODYveGVuL3BtdS5jOjQzNjo5OiBlcnJvcjogY29udHJvbCByZWFjaGVzIGVuZCBvZiBub24tdm9p
ZCAKPiBmdW5jdGlvbiBbLVdlcnJvcj1yZXR1cm4tdHlwZV0KPiDCoCA0MzYgfMKgwqDCoMKgwqDC
oMKgwqAgfQo+IMKgwqDCoMKgwqAgfMKgwqDCoMKgwqDCoMKgwqAgXgo+IGNjMTogc29tZSB3YXJu
aW5ncyBiZWluZyB0cmVhdGVkIGFzIGVycm9ycwo+Cj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IHN0YXRlIHw9IFBFUkZfR1VFU1RfVVNFUjsKPj4gwqDCoMKgwqDCoCB9CgpfX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2
bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUv
bWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
