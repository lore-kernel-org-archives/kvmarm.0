From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH v11 19/21] KVM: ARM64: Add a new feature bit for PMUv3
Date: Mon, 22 Feb 2016 15:43:56 +0800
Message-ID: <56CABC3C.8000304@huawei.com>
References: <1454656456-11640-1-git-send-email-zhaoshenglong@huawei.com>
 <1454656456-11640-20-git-send-email-zhaoshenglong@huawei.com>
 <20160208122957.GE620@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 648A24852F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2016 02:43:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qTecO+Bvajy0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 22 Feb 2016 02:43:26 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D82C4852E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 22 Feb 2016 02:43:25 -0500 (EST)
In-Reply-To: <20160208122957.GE620@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 2016/2/8 20:29, Christoffer Dall wrote:
>> +bool kvm_arm_support_pmu_v3(void)
>> > +{
>> > +	/* Check if HW_PERF_EVENTS are supported by checking the number of
>> > +	 * hardware performance counters. This could ensure physical PMU and
>> > +	 * PERF_EVENT driver existing.
>> > +	 */
> nit: coding style, opening comment block should be on its own line
> 
> I don't understand the last sentence.  Do you mean: "This ensures the
> presence of a physical PMU and that CONFIG_PERF_EVENT is selected." ?
Right.

-- 
Shannon
