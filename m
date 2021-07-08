Return-Path: <SRS0=6kC2=MA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E243C07E96
	for <kvmarm@archiver.kernel.org>; Thu,  8 Jul 2021 16:30:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB77061876
	for <kvmarm@archiver.kernel.org>; Thu,  8 Jul 2021 16:30:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB77061876
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D8714B0D0;
	Thu,  8 Jul 2021 12:30:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EB1PWrc8ot5a; Thu,  8 Jul 2021 12:30:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA7134B08C;
	Thu,  8 Jul 2021 12:30:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D970D4A418
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jul 2021 04:53:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1O8MHifrTZBf for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Jul 2021 04:53:39 -0400 (EDT)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 585FC407EC
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jul 2021 04:53:39 -0400 (EDT)
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="231224871"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; d="scan'208";a="231224871"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
 by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 08 Jul 2021 01:53:36 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; d="scan'208";a="487473996"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.249.171.108])
 ([10.249.171.108])
 by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
 08 Jul 2021 01:53:28 -0700
Subject: Re: [PATCH V7 01/18] perf/core: Use static_call to optimize
 perf_guest_info_callbacks
To: Peter Zijlstra <peterz@infradead.org>,
 Zhu Lingshan <lingshan.zhu@intel.com>
References: <20210622094306.8336-1-lingshan.zhu@intel.com>
 <20210622094306.8336-2-lingshan.zhu@intel.com>
 <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
From: Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <82ae3758-6b99-dc43-9515-fabb2b036f3b@linux.intel.com>
Date: Thu, 8 Jul 2021 16:53:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YN722HIrzc6Z2+oD@hirez.programming.kicks-ass.net>
Content-Language: en-US
X-Mailman-Approved-At: Thu, 08 Jul 2021 12:30:34 -0400
Cc: wanpengli@tencent.com, Like Xu <like.xu@linux.intel.com>,
 eranian@google.com, weijiang.yang@intel.com, Guo Ren <guoren@kernel.org>,
 linux-riscv@lists.infradead.org, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, kan.liang@linux.intel.com, ak@linux.intel.com,
 kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, joro@8bytes.org,
 x86@kernel.org, linux-csky@vger.kernel.org, wei.w.wang@intel.com,
 xen-devel@lists.xenproject.org, liuxiangdong5@huawei.com, bp@alien8.de,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel@lists.infradead.org, jmattson@google.com,
 like.xu.linux@gmail.com, Nick Hu <nickhu@andestech.com>, seanjc@google.com,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 7/2/2021 7:22 PM, Peter Zijlstra wrote:
> On Tue, Jun 22, 2021 at 05:42:49PM +0800, Zhu Lingshan wrote:
>> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
>> index 8f71dd72ef95..c71af4cfba9b 100644
>> --- a/arch/x86/events/core.c
>> +++ b/arch/x86/events/core.c
>> @@ -90,6 +90,27 @@ DEFINE_STATIC_CALL_NULL(x86_pmu_pebs_aliases, *x86_pmu.pebs_aliases);
>>    */
>>   DEFINE_STATIC_CALL_RET0(x86_pmu_guest_get_msrs, *x86_pmu.guest_get_msrs);
>>   
>> +DEFINE_STATIC_CALL_RET0(x86_guest_state, *(perf_guest_cbs->state));
>> +DEFINE_STATIC_CALL_RET0(x86_guest_get_ip, *(perf_guest_cbs->get_ip));
>> +DEFINE_STATIC_CALL_RET0(x86_guest_handle_intel_pt_intr, *(perf_guest_cbs->handle_intel_pt_intr));
>> +
>> +void arch_perf_update_guest_cbs(void)
>> +{
>> +	static_call_update(x86_guest_state, (void *)&__static_call_return0);
>> +	static_call_update(x86_guest_get_ip, (void *)&__static_call_return0);
>> +	static_call_update(x86_guest_handle_intel_pt_intr, (void *)&__static_call_return0);
>> +
>> +	if (perf_guest_cbs && perf_guest_cbs->state)
>> +		static_call_update(x86_guest_state, perf_guest_cbs->state);
>> +
>> +	if (perf_guest_cbs && perf_guest_cbs->get_ip)
>> +		static_call_update(x86_guest_get_ip, perf_guest_cbs->get_ip);
>> +
>> +	if (perf_guest_cbs && perf_guest_cbs->handle_intel_pt_intr)
>> +		static_call_update(x86_guest_handle_intel_pt_intr,
>> +				   perf_guest_cbs->handle_intel_pt_intr);
>> +}
> Coding style wants { } on that last if().
will fix these coding style issues in V8

Thanks!
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
