From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] KVM: arm64: vgic-its: Remove VLA usage
Date: Mon, 9 Jul 2018 08:53:40 -0700
Message-ID: <CAGXu5jLXQ2ZQ8mCfcKC6F7DMzbvP7MvArcacouVaX=WS9=7LPQ@mail.gmail.com>
References: <20180629184618.GA37364@beast>
 <19f9ddb1-6009-850c-1949-3a8cdacdd2fc@redhat.com>
 <CAGXu5jJcqMX7HjvgqcR37jnuN48PtyHd+VVmfcQH6YfXXSpO_g@mail.gmail.com>
 <f213e03a-66a6-0c07-7bb8-2061b9c24731@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E0504A0CA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 11:41:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tKn8gFegjhWj for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Jul 2018 11:41:00 -0400 (EDT)
Received: from mail-yb0-f196.google.com (mail-yb0-f196.google.com
 [209.85.213.196])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 53FB540192
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Jul 2018 11:41:00 -0400 (EDT)
Received: by mail-yb0-f196.google.com with SMTP id i9-v6so7367010ybo.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Jul 2018 08:53:41 -0700 (PDT)
In-Reply-To: <f213e03a-66a6-0c07-7bb8-2061b9c24731@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, LKML <linux-kernel@vger.kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jul 9, 2018 at 3:47 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
> Hi kees,
>
> On 02/07/18 18:15, Kees Cook wrote:
>> On Mon, Jul 2, 2018 at 12:36 AM, Auger Eric <eric.auger@redhat.com> wrote:
>>> Hi Kees,
>>>
>>> On 06/29/2018 08:46 PM, Kees Cook wrote:
>>>> In the quest to remove all stack VLA usage from the kernel[1], this
>>>> switches to using a maximum size and adds sanity checks. Additionally
>>>> cleans up some of the int-vs-u32 usage and adds additional bounds checking.
>>>> As it currently stands, this will always be 8 bytes until the ABI changes.
>>>>
>>>> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>>>>
>>>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>> Cc: Eric Auger <eric.auger@redhat.com>
>>>> Cc: Andre Przywara <andre.przywara@arm.com>
>>>> Cc: linux-arm-kernel@lists.infradead.org
>>>> Cc: kvmarm@lists.cs.columbia.edu
>>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>>> ---
>>>>  virt/kvm/arm/vgic/vgic-its.c | 19 +++++++++++++++----
>>>>  1 file changed, 15 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>>> index 4ed79c939fb4..3143fc047fcf 100644
>>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>>> @@ -168,8 +168,14 @@ struct vgic_its_abi {
>>>>       int (*commit)(struct vgic_its *its);
>>>>  };
>>>>
>>>> +#define ABI_0_ESZ    8
>>>> +#define ESZ_MAX              ABI_0_ESZ
>>>> +
>>>>  static const struct vgic_its_abi its_table_abi_versions[] = {
>>>> -     [0] = {.cte_esz = 8, .dte_esz = 8, .ite_esz = 8,
>>>> +     [0] = {
>>>> +      .cte_esz = ABI_0_ESZ,
>>>> +      .dte_esz = ABI_0_ESZ,
>>>> +      .ite_esz = ABI_0_ESZ,
>>>>        .save_tables = vgic_its_save_tables_v0,
>>>>        .restore_tables = vgic_its_restore_tables_v0,
>>>>        .commit = vgic_its_commit_v0,
>>>> @@ -180,10 +186,12 @@ static const struct vgic_its_abi its_table_abi_versions[] = {
>>>>
>>>>  inline const struct vgic_its_abi *vgic_its_get_abi(struct vgic_its *its)
>>>>  {
>>>> +     if (WARN_ON(its->abi_rev >= NR_ITS_ABIS))
>>>> +             return NULL;
>>>>       return &its_table_abi_versions[its->abi_rev];
>>>>  }
>>>>
>>>> -int vgic_its_set_abi(struct vgic_its *its, int rev)
>>>> +static int vgic_its_set_abi(struct vgic_its *its, u32 rev)
>>>>  {
>>> if vgic_its_get_abi is likely to return NULL, don't we need to check abi
>>> != NULL in all call sites.
>>
>> My thinking was that since it should never happen, a WARN_ON would be
>> sufficient. But I can drop all these changes if you want. I just
>> wanted to see the VLA removed. :)
>
> Are you going to respin this patch limiting it to just the VLA changes?
> I'm actively queuing stuff for the next merge window, and it'd be good
> to get that one in.
>
> Alternatively, I can drop the WARN_ONs myself. Just let me know.

If you can just drop them that would be best, thanks!

-Kees

-- 
Kees Cook
Pixel Security
