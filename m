From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Close VMID generation race
Date: Mon, 16 Apr 2018 11:20:32 +0100
Message-ID: <09e4f259-a49b-8a5a-6b75-7dacfd90fb0e@arm.com>
References: <20180409170706.23541-1-marc.zyngier@arm.com>
 <20180409205139.GH10904@cbox>
 <20180410105119.yzzzd4lyvlsvtbfy@lakrids.cambridge.arm.com>
 <20180410150540.GK10904@cbox>
 <20180410152419.inzprhuqhx26keuq@lakrids.cambridge.arm.com>
 <f90f8486-10c7-ce42-94a8-abaabd80ebb7@arm.com> <5ACD6521.5090500@huawei.com>
 <5AD47578.7010103@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5AD47578.7010103@huawei.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, Mark Rutland <mark.rutland@arm.com>, Christoffer Dall <cdall@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 16/04/18 11:05, Shannon Zhao wrote:
> 
> 
> On 2018/4/11 9:30, Shannon Zhao wrote:
>>
>> On 2018/4/10 23:37, Marc Zyngier wrote:

[...]

>>>> I don't mind either way. If you can be bothered to write a proper commit
>>>> log for this, I'll take it. What I'd really want is Shannon to indicate
>>>> whether or not this solves the issue he was seeing.
>>>>
>> I'll test Marc's patch. This will take about 3 days since it's not 100%
>> reproducible.
> Hi Marc,
> 
> I've run the test for about 4 days. The issue doesn't appear.
> So Tested-by: Shannon Zhao <zhaoshenglong@huawei.com>

Thanks Shannon, much appreciated. I'll send the fix upstream towards the
end of the week.

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...
