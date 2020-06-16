Return-Path: <SRS0=MRip=75=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7702BC433DF
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jun 2020 12:38:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9A8142071A
	for <kvmarm@archiver.kernel.org>; Tue, 16 Jun 2020 12:38:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9A8142071A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 102E94B12A;
	Tue, 16 Jun 2020 08:38:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hXNHTwEgIdBf; Tue, 16 Jun 2020 08:38:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F24424B120;
	Tue, 16 Jun 2020 08:38:47 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EDD44B0AC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 07:55:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mO0Rrj9GLR1i for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Jun 2020 07:55:20 -0400 (EDT)
Received: from out4436.biz.mail.alibaba.com (out4436.biz.mail.alibaba.com
 [47.88.44.36])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0D1494A483
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Jun 2020 07:55:19 -0400 (EDT)
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R181e4; CH=green; DM=||false|;
 DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e07484;
 MF=tianjia.zhang@linux.alibaba.com; NM=1; PH=DS; RN=37; SR=0;
 TI=SMTPD_---0U.mfflQ_1592308495; 
Received: from 30.27.116.240(mailfrom:tianjia.zhang@linux.alibaba.com
 fp:SMTPD_---0U.mfflQ_1592308495) by smtp.aliyun-inc.com(127.0.0.1);
 Tue, 16 Jun 2020 19:54:57 +0800
Subject: Re: [PATCH v4 6/7] KVM: MIPS: clean up redundant 'kvm_run' parameters
To: Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@gmail.com>
References: <20200427043514.16144-1-tianjia.zhang@linux.alibaba.com>
 <20200427043514.16144-7-tianjia.zhang@linux.alibaba.com>
 <CAAhV-H7kpKUfQoWid6GSNL5+4hTTroGyL83EaW6yZwS2+Ti9kA@mail.gmail.com>
 <37246a25-c4dc-7757-3f5c-d46870a4f186@linux.alibaba.com>
 <30c2ac06-1a7e-2f85-fbe1-e9dc25bf2ae2@redhat.com>
From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <5f0d01ad-d299-083b-70e4-995ad7596fbd@linux.alibaba.com>
Date: Tue, 16 Jun 2020 19:54:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <30c2ac06-1a7e-2f85-fbe1-e9dc25bf2ae2@redhat.com>
X-Mailman-Approved-At: Tue, 16 Jun 2020 08:38:46 -0400
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
 mpe@ellerman.id.au, vkuznets@redhat.com, linuxppc-dev@lists.ozlabs.org
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



On 2020/5/29 17:48, Paolo Bonzini wrote:
> On 27/05/20 08:24, Tianjia Zhang wrote:
>>>>
>>>>
>>
>> Hi Huacai,
>>
>> These two patches(6/7 and 7/7) should be merged into the tree of the
>> mips architecture separately. At present, there seems to be no good way
>> to merge the whole architecture patchs.
>>
>> For this series of patches, some architectures have been merged, some
>> need to update the patch.
> 
> Hi Tianjia, I will take care of this during the merge window.
> 
> Thanks,
> 
> Paolo
> 

Hi Paolo,

The following individual patch is the v5 version of 5/7 in this group of 
patches.

https://lkml.org/lkml/2020/5/28/106
([v5] KVM: PPC: clean up redundant kvm_run parameters in assembly)

Thanks and best,
Tianjia
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
