Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 943D2C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 13:05:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 492ED61B1B
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 13:05:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 492ED61B1B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 549F24B1F5;
	Thu, 18 Nov 2021 08:05:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@infradead.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cEPY3zgYjoVd; Thu, 18 Nov 2021 08:05:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AB104B204;
	Thu, 18 Nov 2021 08:05:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 816394B08B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 13:32:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UhnGuvsTE1Yw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 13:32:39 -0500 (EST)
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C69564B08A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 13:32:39 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
 :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
 Sender:Reply-To:Content-ID:Content-Description;
 bh=UrCfwAAERGpFkpH84kgGsztDfzBHzApXpFPk7Q4aM3Q=; b=qlkcK6EiUDCYNFmrW2y88AiZNE
 cmQvmZ/hQeDmBuBaxBlEz8/9xSDGrc79+e+G9Ohrg5SCBR9+U6oMY2TCcJXuU2nNiBFuD3+kWs5eT
 IBPH2OgqzqIIS3CImevIylsIHPwL04bJaRDQbp5TgrjKZuuQ7/IGm6pG4x0HQWq0ZUJe2eHLXzCPj
 f6Yvwy6gqczKGGJV9qWHf3sPhxK2DC4ivkTSa4HaWFyKoFujkMpT8PDC2tAVJRnfRaU58s8vA1x38
 8L1RywfOIo3IjwOk1sM0OUF4A2t8iZC5ZKCHOLMVvHUQ609zEC4WkGW9X1KUl7pVE6G8B/0JOjLPo
 DBQsXa2g==;
Received: from [2001:8b0:10b:1:d129:67c1:5868:c3aa] (helo=[IPv6:::1])
 by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1mnPiu-00GXzz-IG; Wed, 17 Nov 2021 18:31:56 +0000
Date: Wed, 17 Nov 2021 18:31:55 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3_08/12=5D_KVM=3A_Propagate_vcpu?=
 =?US-ASCII?Q?_explicitly_to_mark=5Fpage=5Fdirty=5Fin=5Fslot=28=29?=
User-Agent: K-9 Mail for Android
In-Reply-To: <87pmqy7ir2.wl-maz@kernel.org>
References: <20211117174003.297096-1-dwmw2@infradead.org>
 <20211117174003.297096-9-dwmw2@infradead.org> <87pmqy7ir2.wl-maz@kernel.org>
Message-ID: <63CDC53D-D05A-499B-8694-14E5DA3855FB@infradead.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by
 desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Mailman-Approved-At: Thu, 18 Nov 2021 08:05:18 -0500
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu



On 17 November 2021 18:13:37 GMT, Marc Zyngier <maz@kernel.org> wrote:
>On Wed, 17 Nov 2021 17:39:59 +0000,
>David Woodhouse <dwmw2@infradead.org> wrote:
>> 
>> From: David Woodhouse <dwmw@amazon.co.uk>
>> 
>> The kvm_dirty_ring_get() function uses kvm_get_running_vcpu() to work out
>> which dirty ring to use, but there are some use cases where that doesn't
>> work.
>> 
>> There's one in setting the Xen shared info page, introduced in commit
>> 629b5348841a ("KVM: x86/xen: update wallclock region") and reported by
>> "butt3rflyh4ck" <butterflyhuangxx@gmail.com> in
>> https://lore.kernel.org/kvm/CAFcO6XOmoS7EacN_n6v4Txk7xL7iqRa2gABg3F7E3Naf5uG94g@mail.gmail.com/
>> 
>> There's also about to be another one when the newly-reintroduced
>> gfn_to_pfn_cache needs to mark a page as dirty from the MMU notifier
>> which invalidates the mapping. In that case, we will *know* the vcpu
>> that can be 'blamed' for dirtying the page, and we just need to be
>> able to pass it in as an explicit argument when doing so.
>> 
>> This patch preemptively resolves the second issue, and paves the way
>> for resolving the first. A complete fix for the first issue will need
>> us to switch the Xen shinfo to be owned by a particular vCPU, which
>> will happen in a separate patch.
>> 
>> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
>> ---
>>  arch/arm64/kvm/mmu.c           |  2 +-
>>  arch/x86/kvm/mmu/mmu.c         |  2 +-
>>  arch/x86/kvm/mmu/spte.c        |  2 +-
>>  arch/x86/kvm/mmu/tdp_mmu.c     |  2 +-
>>  arch/x86/kvm/x86.c             |  4 ++--
>>  include/linux/kvm_dirty_ring.h |  6 ++++--
>>  include/linux/kvm_host.h       |  3 ++-
>>  virt/kvm/dirty_ring.c          |  8 ++++++--
>>  virt/kvm/kvm_main.c            | 18 +++++++++---------
>>  9 files changed, 27 insertions(+), 20 deletions(-)
>
>What's the base for this series? This patch fails to compile for me
>(at least on arm64), and the following patch doesn't apply on -rc1.

kvm/master

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
