From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: Re: [PATCH v9 04/11] irqchip/gic-v3: Add missing system register
 definitions
Date: Mon, 23 Jan 2017 16:25:27 +0530
Message-ID: <CALicx6vb+9L4WBVWrbMysAa+sOKpsqGWLZtBrQNPURkZU=jiTw@mail.gmail.com>
References: <1479906118-15832-1-git-send-email-vijay.kilari@gmail.com>
 <1479906118-15832-5-git-send-email-vijay.kilari@gmail.com>
 <09831c41-3421-0c35-9d62-0ad7c92916d0@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B7F1B40838
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 05:55:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ukmF+2Zl3mSi for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Jan 2017 05:55:23 -0500 (EST)
Received: from mail-ot0-f195.google.com (mail-ot0-f195.google.com
 [74.125.82.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3E2C40190
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 05:55:23 -0500 (EST)
Received: by mail-ot0-f195.google.com with SMTP id 73so14918482otj.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Jan 2017 02:55:28 -0800 (PST)
In-Reply-To: <09831c41-3421-0c35-9d62-0ad7c92916d0@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

On Tue, Dec 6, 2016 at 7:23 PM, Auger Eric <eric.auger@redhat.com> wrote:
> Hi,
> On 23/11/2016 14:01, vijay.kilari@gmail.com wrote:
>> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>>
>> Define register definitions for ICH_VMCR_EL2, ICC_CTLR_EL1 and
>> ICH_VTR_EL2, ICC_BPR0_EL1, ICC_BPR1_EL1 registers.
>>
>> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
>
>> ---
>>  include/linux/irqchip/arm-gic-v3.h | 43 ++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 41 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
>> index 0deea34..b4f8287 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -352,8 +352,30 @@
>>  /*
>>   * CPU interface registers
>>   */
>> -#define ICC_CTLR_EL1_EOImode_drop_dir        (0U << 1)
>> -#define ICC_CTLR_EL1_EOImode_drop    (1U << 1)
>> +#define ICC_CTLR_EL1_EOImode_SHIFT   (1)
>> +#define ICC_CTLR_EL1_EOImode_drop_dir        (0U << ICC_CTLR_EL1_EOImode_SHIFT)
>> +#define ICC_CTLR_EL1_EOImode_drop    (1U << ICC_CTLR_EL1_EOImode_SHIFT)
>> +#define ICC_CTLR_EL1_EOImode_MASK    (1 << ICC_CTLR_EL1_EOImode_SHIFT)
>> +#define ICC_CTLR_EL1_CBPR_SHIFT              0
>> +#define ICC_CTLR_EL1_CBPR_MASK               (1 << ICC_CTLR_EL1_CBPR_SHIFT)
>> +#define ICC_CTLR_EL1_PRI_BITS_SHIFT  8
>> +#define ICC_CTLR_EL1_PRI_BITS_MASK   (0x7 << ICC_CTLR_EL1_PRI_BITS_SHIFT)
>> +#define ICC_CTLR_EL1_ID_BITS_SHIFT   11
>> +#define ICC_CTLR_EL1_ID_BITS_MASK    (0x7 << ICC_CTLR_EL1_ID_BITS_SHIFT)
>> +#define ICC_CTLR_EL1_SEIS_SHIFT              14
>> +#define ICC_CTLR_EL1_SEIS_MASK               (0x1 << ICC_CTLR_EL1_SEIS_SHIFT)
>> +#define ICC_CTLR_EL1_A3V_SHIFT               15
>> +#define ICC_CTLR_EL1_A3V_MASK                (0x1 << ICC_CTLR_EL1_A3V_SHIFT)
>> +#define ICC_PMR_EL1_SHIFT            0
>> +#define ICC_PMR_EL1_MASK             (0xff << ICC_PMR_EL1_SHIFT)
>> +#define ICC_BPR0_EL1_SHIFT           0
>> +#define ICC_BPR0_EL1_MASK            (0x7 << ICC_BPR0_EL1_SHIFT)
>> +#define ICC_BPR1_EL1_SHIFT           0
>> +#define ICC_BPR1_EL1_MASK            (0x7 << ICC_BPR1_EL1_SHIFT)
>> +#define ICC_IGRPEN0_EL1_SHIFT                0
>> +#define ICC_IGRPEN0_EL1_MASK         (1 << ICC_IGRPEN0_EL1_SHIFT)
>> +#define ICC_IGRPEN1_EL1_SHIFT                0
>> +#define ICC_IGRPEN1_EL1_MASK         (1 << ICC_IGRPEN1_EL1_SHIFT)
>>  #define ICC_SRE_EL1_SRE                      (1U << 0)
>>
>>  /*
>> @@ -384,12 +406,29 @@
>>
>>  #define ICH_VMCR_CTLR_SHIFT          0
>>  #define ICH_VMCR_CTLR_MASK           (0x21f << ICH_VMCR_CTLR_SHIFT)
>> +#define ICH_VMCR_CBPR_SHIFT          4
>> +#define ICH_VMCR_CBPR_MASK           (1 << ICH_VMCR_CBPR_SHIFT)
>> +#define ICH_VMCR_EOIM_SHIFT          9
>> +#define ICH_VMCR_EOIM_MASK           (1 << ICH_VMCR_EOIM_SHIFT)
>>  #define ICH_VMCR_BPR1_SHIFT          18
>>  #define ICH_VMCR_BPR1_MASK           (7 << ICH_VMCR_BPR1_SHIFT)
>>  #define ICH_VMCR_BPR0_SHIFT          21
>>  #define ICH_VMCR_BPR0_MASK           (7 << ICH_VMCR_BPR0_SHIFT)
>>  #define ICH_VMCR_PMR_SHIFT           24
>>  #define ICH_VMCR_PMR_MASK            (0xffUL << ICH_VMCR_PMR_SHIFT)
>> +#define ICH_VMCR_ENG0_SHIFT          0
>> +#define ICH_VMCR_ENG0_MASK           (1 << ICH_VMCR_ENG0_SHIFT)
>> +#define ICH_VMCR_ENG1_SHIFT          1
>> +#define ICH_VMCR_ENG1_MASK           (1 << ICH_VMCR_ENG1_SHIFT)
> Besides the fact the V* was omitted (for instance VENG0) this looks good
> to me.

The previous definitions of has omitted V. If we have to prefix V then
it needs to be changed for all other definitions of VMCR.
I propose to ignore it for now and can clean up later as a separate patch.

>> +
>> +#define ICH_VTR_PRI_BITS_SHIFT               29
>> +#define ICH_VTR_PRI_BITS_MASK                (7 << ICH_VTR_PRI_BITS_SHIFT)
>> +#define ICH_VTR_ID_BITS_SHIFT                23
>> +#define ICH_VTR_ID_BITS_MASK         (7 << ICH_VTR_ID_BITS_SHIFT)
>> +#define ICH_VTR_SEIS_SHIFT           22
>> +#define ICH_VTR_SEIS_MASK            (1 << ICH_VTR_SEIS_SHIFT)
>> +#define ICH_VTR_A3V_SHIFT            21
>> +#define ICH_VTR_A3V_MASK             (1 << ICH_VTR_A3V_SHIFT)
> Some fields are omitted but I guess they are not used.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>
> Eric
>
>>
>>  #define ICC_IAR1_EL1_SPURIOUS                0x3ff
>>
>>
