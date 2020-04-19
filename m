Return-Path: <SRS0=Mx9U=6D=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	HK_RANDOM_FROM,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01A6C54FCB
	for <kvmarm@archiver.kernel.org>; Sun, 19 Apr 2020 09:38:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 838E6214AF
	for <kvmarm@archiver.kernel.org>; Sun, 19 Apr 2020 09:38:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 838E6214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DD244B0FF;
	Sun, 19 Apr 2020 05:38:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RHnH5fVWO49O; Sun, 19 Apr 2020 05:38:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 627154B1DF;
	Sun, 19 Apr 2020 05:38:15 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 331514B130
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Apr 2020 04:24:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gX8osuC9jC1h for <kvmarm@lists.cs.columbia.edu>;
 Sun, 19 Apr 2020 04:24:29 -0400 (EDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 98D6D4B128
 for <kvmarm@lists.cs.columbia.edu>; Sun, 19 Apr 2020 04:24:29 -0400 (EDT)
IronPort-SDR: WlH4n/n+NuSSxIxuH0VNnGDOWZz1y6sbMXaSkbAgvC2MWbwCbAsJVe8R7PdIJDaA+ohYnKhbBc
 P1SUJWjveYdA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
 by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 19 Apr 2020 01:24:28 -0700
IronPort-SDR: 5bTV3PMh/h/IpB7kLfIrzCg8Fo/mJzhnyaMGYARomkIW7rvbXCWMjVwZD/fKzDk1jnTpAU1Qxz
 1DLl94MlS5Ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,402,1580803200"; d="scan'208";a="456070012"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.255.30.120])
 ([10.255.30.120])
 by fmsmga006.fm.intel.com with ESMTP; 19 Apr 2020 01:24:20 -0700
Subject: Re: [PATCH] KVM: X86: Fix compile error in svm/sev.c
To: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>, pbonzini@redhat.com,
 tsbogend@alpha.franken.de, paulus@ozlabs.org, mpe@ellerman.id.au,
 benh@kernel.crashing.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
 david@redhat.com, cohuck@redhat.com, heiko.carstens@de.ibm.com,
 gor@linux.ibm.com, sean.j.christopherson@intel.com, vkuznets@redhat.com,
 wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, maz@kernel.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 christoffer.dall@arm.com, peterx@redhat.com, thuth@redhat.com
References: <20200419073047.14413-1-tianjia.zhang@linux.alibaba.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <82ce1798-1dab-d271-d084-e9a89bb44e71@intel.com>
Date: Sun, 19 Apr 2020 16:24:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200419073047.14413-1-tianjia.zhang@linux.alibaba.com>
Content-Language: en-US
X-Mailman-Approved-At: Sun, 19 Apr 2020 05:38:13 -0400
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gNC8xOS8yMDIwIDM6MzAgUE0sIFRpYW5qaWEgWmhhbmcgd3JvdGU6Cj4gVGhlIGNvbXBpbGVy
IHJlcG9ydGVkIHRoZSBmb2xsb3dpbmcgY29tcGlsYXRpb24gZXJyb3JzOgo+IAo+IGFyY2gveDg2
L2t2bS9zdm0vc2V2LmM6IEluIGZ1bmN0aW9uIOKAmHNldl9waW5fbWVtb3J54oCZOgo+IGFyY2gv
eDg2L2t2bS9zdm0vc2V2LmM6MzYxOjM6IGVycm9yOiBpbXBsaWNpdCBkZWNsYXJhdGlvbiBvZiBm
dW5jdGlvbgo+IOKAmHJlbGVhc2VfcGFnZXPigJkgWy1XZXJyb3I9aW1wbGljaXQtZnVuY3Rpb24t
ZGVjbGFyYXRpb25dCj4gICAgIHJlbGVhc2VfcGFnZXMocGFnZXMsIG5waW5uZWQpOwo+ICAgICBe
fn5+fn5+fn5+fn5+Cj4gCj4gVGhlIHJlYXNvbiBpcyB0aGF0IHRoZSAncGFnZW1hcC5oJyBoZWFk
ZXIgZmlsZSBpcyBub3QgaW5jbHVkZWQuCj4gCgpGWUkuCgpCb3JpcyBoYXMgc2VudCB0aGUgUGF0
Y2g6Cmh0dHBzOi8vbGttbC5rZXJuZWwub3JnL3IvMjAyMDA0MTExNjA5MjcuMjc5NTQtMS1icEBh
bGllbjguZGUKCmFuZCBpdCdzIGFscmVhZHkgaW4ga3ZtIG1hc3Rlci9xdWV1ZSBicmFuY2gKCgoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
