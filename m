Return-Path: <SRS0=MITk=7J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26C2C433E2
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 07:18:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96CB5208FE
	for <kvmarm@archiver.kernel.org>; Wed, 27 May 2020 07:18:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 96CB5208FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 515984B1DD;
	Wed, 27 May 2020 03:18:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hW0PN2oUBdAH; Wed, 27 May 2020 03:18:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1D1594B21E;
	Wed, 27 May 2020 03:18:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E78A14B153
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 02:24:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fLf1ht-Jkw1D for <kvmarm@lists.cs.columbia.edu>;
 Wed, 27 May 2020 02:24:17 -0400 (EDT)
Received: from out30-54.freemail.mail.aliyun.com
 (out30-54.freemail.mail.aliyun.com [115.124.30.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34B044B148
 for <kvmarm@lists.cs.columbia.edu>; Wed, 27 May 2020 02:24:15 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R941e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e07425;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=37; SR=0;
 TI=SMTPD_---0TzmW8ts_1590560648; 
Received: from 30.27.118.64(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0TzmW8ts_1590560648) by smtp.aliyun-inc.com(127.0.0.1);
 Wed, 27 May 2020 14:24:10 +0800
Subject: Re: [PATCH v4 6/7] KVM: MIPS: clean up redundant 'kvm_run' parameters
To: Huacai Chen <chenhuacai@gmail.com>
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-7-tianjia.zhang@linux.alibaba.com>
 <CAAhV-H7kpKUfQoWid6GSNL5+4hTTroGyL83EaW6yZwS2+Ti9kA@mail.gmail.com>
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <37246a25-c4dc-7757-3f5c-d46870a4f186@linux.alibaba.com>
Date: Wed, 27 May 2020 14:24:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7kpKUfQoWid6GSNL5+4hTTroGyL83EaW6yZwS2+Ti9kA@mail.gmail.com>
X-Mailman-Approved-At: Wed, 27 May 2020 03:18:39 -0400
Cc: wanpengli@tencent.com, kvm@vger.kernel.org, david@redhat.com,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, heiko.carstens@de.ibm.com,
 "open list:MIPS" <linux-mips@vger.kernel.org>, paulus@ozlabs.org,
 hpa@zytor.com, kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 frankja@linux.ibm.com, Marc Zyngier <maz@kernel.org>, joro@8bytes.org,
 x86@kernel.org, borntraeger@de.ibm.com, mingo@redhat.com, thuth@redhat.com,
 gor@linux.ibm.com, kvm-ppc@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, jmattson@google.com,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, cohuck@redhat.com,
 sean.j.christopherson@intel.com, LKML <linux-kernel@vger.kernel.org>,
 mpe@ellerman.id.au, Paolo Bonzini <pbonzini@redhat.com>, vkuznets@redhat.com,
 linuxppc-dev@lists.ozlabs.org
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



On 2020/4/27 13:40, Huacai Chen wrote:
> Reviewed-by: Huacai Chen <chenhc@lemote.com>
> 
> On Mon, Apr 27, 2020 at 12:35 PM Tianjia Zhang
> <tianjia.zhang@linux.alibaba.com> wrote:
>>
>> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
>> structure. For historical reasons, many kvm-related function parameters
>> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
>> patch does a unified cleanup of these remaining redundant parameters.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> ---
>>   arch/mips/include/asm/kvm_host.h |  28 +-------
>>   arch/mips/kvm/emulate.c          |  59 ++++++----------
>>   arch/mips/kvm/mips.c             |  11 ++-
>>   arch/mips/kvm/trap_emul.c        | 114 ++++++++++++++-----------------
>>   arch/mips/kvm/vz.c               |  26 +++----
>>   5 files changed, 87 insertions(+), 151 deletions(-)
>>

Hi Huacai,

These two patches(6/7 and 7/7) should be merged into the tree of the 
mips architecture separately. At present, there seems to be no good way 
to merge the whole architecture patchs.

For this series of patches, some architectures have been merged, some 
need to update the patch.

Thanks and best,
Tianjia
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
