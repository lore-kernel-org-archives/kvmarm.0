From: Julien Grall <julien.grall@arm.com>
Subject: Re: [PATCH v6 05/10] irqchip/gic-v3: Prefix all pr_* messages by
 "GICv3: "
Date: Tue, 26 Apr 2016 18:52:00 +0100
Message-ID: <571FAAC0.3070706@arm.com>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <1460388780-914-6-git-send-email-julien.grall@arm.com>
 <570E190C.8020203@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CF7C410EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2016 13:49:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u0Gzx5HOjBX0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Apr 2016 13:49:48 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F93E40FA7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Apr 2016 13:49:47 -0400 (EDT)
In-Reply-To: <570E190C.8020203@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Hanjun Guo <hanjun.guo@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

Hi Hanjun,

Sorry for the late answer.

On 13/04/16 11:01, Hanjun Guo wrote:
> On 2016/4/11 23:32, Julien Grall wrote:
>> Currently, most of the pr_* messages in the GICv3 driver don't have a
>> prefix.  Add one to make clear where the messages come from.
>>
>> Signed-off-by: Julien Grall <julien.grall@arm.com>
>>
>> ---
>>      Changes in v6:
>>          - Patch added
>> ---
>>   drivers/irqchip/irq-gic-v3.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>> index 5b7d3c2..6dc6f03 100644
>> --- a/drivers/irqchip/irq-gic-v3.c
>> +++ b/drivers/irqchip/irq-gic-v3.c
>> @@ -15,6 +15,8 @@
>>    * along with this program.  If not, see
>> <http://www.gnu.org/licenses/>.
>>    */
>>
>> +#define pr_fmt(fmt)    "GICv3: " fmt
>
> I don't think this patch is needed, as GICv3 and GICv2 will
> not be probed at the same time, did I miss something?

True, however this make slightly easier to know which driver is in-use 
and avoid to prefix all the messages with "GIC:" or "GICv3:".

>
> Further more, there are prefixes in pr_fmt in this
> patch using GIC:, with your patch added, it will print:
>
> GIV3: GIC: .....
>
> which is not a good idea.

I think it is better than having message without prefix at all.

Regards,

-- 
Julien Grall
