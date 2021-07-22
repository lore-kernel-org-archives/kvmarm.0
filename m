Return-Path: <SRS0=vB6B=MO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D322C63793
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 08:11:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1D28361283
	for <kvmarm@archiver.kernel.org>; Thu, 22 Jul 2021 08:11:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1D28361283
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B08924B0D7;
	Thu, 22 Jul 2021 04:11:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jwJOeZ73dDjC; Thu, 22 Jul 2021 04:11:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A06E4B0DB;
	Thu, 22 Jul 2021 04:11:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F51B4AED4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 23:03:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gzLMIvYzvfT7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 21 Jul 2021 23:03:56 -0400 (EDT)
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 596F34A95C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 21 Jul 2021 23:03:56 -0400 (EDT)
X-IronPort-AV: E=McAfee;i="6200,9189,10052"; a="272670257"
X-IronPort-AV: E=Sophos;i="5.84,259,1620716400"; d="scan'208";a="272670257"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
 by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 21 Jul 2021 20:03:54 -0700
X-IronPort-AV: E=Sophos;i="5.84,259,1620716400"; d="scan'208";a="512019825"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.29.38])
 ([10.255.29.38])
 by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 21 Jul 2021 20:03:46 -0700
Subject: Re: [PATCH V8 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
To: Like Xu <like.xu.linux@gmail.com>
References: <20210716085325.10300-1-lingshan.zhu@intel.com>
 <20210716085325.10300-2-lingshan.zhu@intel.com>
 <fd117e37-8063-63a4-43cd-7cb555e5bab5@gmail.com>
From: "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <e8a7de91-fe48-c570-3cea-a296278a7c8a@intel.com>
Date: Thu, 22 Jul 2021 11:03:44 +0800
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
dGEtPnBtdS5yLnJlZ3MuY3BsICYgMykKPgo+IExpbmdzaGFuLCBzZXJpb3VzIGZvciB0aGlzIHZl
cnNpb24gPwo+Cj4gYXJjaC94ODYveGVuL3BtdS5jOjQzODo5OiBlcnJvcjogZXhwZWN0ZWQgaWRl
bnRpZmllciBvciDigJgo4oCZIGJlZm9yZSAKPiDigJhyZXR1cm7igJkKPiDCoCA0MzggfMKgwqDC
oMKgwqDCoMKgwqAgcmV0dXJuIHN0YXRlOwo+IMKgwqDCoMKgwqAgfMKgwqDCoMKgwqDCoMKgwqAg
Xn5+fn5+Cj4gYXJjaC94ODYveGVuL3BtdS5jOjQzOToxOiBlcnJvcjogZXhwZWN0ZWQgaWRlbnRp
ZmllciBvciDigJgo4oCZIGJlZm9yZSDigJh94oCZIAo+IHRva2VuCj4gwqAgNDM5IHwgfQo+IMKg
wqDCoMKgwqAgfCBeCj4gYXJjaC94ODYveGVuL3BtdS5jOiBJbiBmdW5jdGlvbiDigJh4ZW5fZ3Vl
c3Rfc3RhdGXigJk6Cj4gYXJjaC94ODYveGVuL3BtdS5jOjQzNjo5OiBlcnJvcjogY29udHJvbCBy
ZWFjaGVzIGVuZCBvZiBub24tdm9pZCAKPiBmdW5jdGlvbiBbLVdlcnJvcj1yZXR1cm4tdHlwZV0K
PiDCoCA0MzYgfMKgwqDCoMKgwqDCoMKgwqAgfQo+IMKgwqDCoMKgwqAgfMKgwqDCoMKgwqDCoMKg
wqAgXgo+IGNjMTogc29tZSB3YXJuaW5ncyBiZWluZyB0cmVhdGVkIGFzIGVycm9ycwo+Cj4+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0YXRlIHw9IFBFUkZfR1VFU1RfVVNFUjsKPj4gwqDCoMKg
wqDCoCB9CmZvcmdvdCB0byBlbmFibGUgWEVOIGJ1aWxkIGluIC5jb25maWcsIFY5IGZpeGVzIHRo
aXMgd2lsbCBjb21lIHNvb24KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
